.setcpu "6502"
.include "include/hardware.inc"
.include "include/zeropage.inc"
.include "include/constants.inc"
.include "include/fixed_bank.inc"

.segment "BANK03"

; =============================================================================
; BANK $03 (mapped at $A000) — raw da65 disassembly, annotation in progress
; SKELETON — raw ROM bytes, not yet classified as code or data.
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
; $A656-$A7FF: data, TBD (unreferenced in-bank; likely BG strip data
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
        brk                                     ; A800 00
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
        .byte   $02                             ; A811 02                       .
        ora     ($01,x)                         ; A812 01 01                    ..
        ora     ($01,x)                         ; A814 01 01                    ..
        ora     ($02,x)                         ; A816 01 02                    ..
        .byte   $02                             ; A818 02                       .
        ora     ($01,x)                         ; A819 01 01                    ..
        .byte   $02                             ; A81B 02                       .
        ora     ($01,x)                         ; A81C 01 01                    ..
        brk                                     ; A81E 00                       .
        brk                                     ; A81F 00                       .
        .byte   $02                             ; A820 02                       .
        .byte   $02                             ; A821 02                       .
        brk                                     ; A822 00                       .
        brk                                     ; A823 00                       .
        brk                                     ; A824 00                       .
        ora     (L0000,x)                       ; A825 01 00                    ..
        brk                                     ; A827 00                       .
        .byte   $02                             ; A828 02                       .
        ora     ($02,x)                         ; A829 01 02                    ..
        ora     (L0000,x)                       ; A82B 01 00                    ..
        brk                                     ; A82D 00                       .
        brk                                     ; A82E 00                       .
        brk                                     ; A82F 00                       .
        brk                                     ; A830 00                       .
        .byte   $02                             ; A831 02                       .
        ora     ($02,x)                         ; A832 01 02                    ..
        ora     (L0000,x)                       ; A834 01 00                    ..
        .byte   $02                             ; A836 02                       .
        brk                                     ; A837 00                       .
        brk                                     ; A838 00                       .
        ora     ($02,x)                         ; A839 01 02                    ..
        ora     (L0000,x)                       ; A83B 01 00                    ..
        brk                                     ; A83D 00                       .
        .byte   $02                             ; A83E 02                       .
        brk                                     ; A83F 00                       .
        .byte   $03                             ; A840 03                       .
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
        .byte   $04                             ; A84F 04                       .
        ora     (L0000,x)                       ; A850 01 00                    ..
        ora     ($01,x)                         ; A852 01 01                    ..
        ora     (L0000,x)                       ; A854 01 00                    ..
        ora     (L0000,x)                       ; A856 01 00                    ..
        brk                                     ; A858 00                       .
        .byte   $02                             ; A859 02                       .
        ora     (L0000,x)                       ; A85A 01 00                    ..
        .byte   $02                             ; A85C 02                       .
        .byte   $02                             ; A85D 02                       .
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
        .byte   $03                             ; A889 03                       .
        brk                                     ; A88A 00                       .
        brk                                     ; A88B 00                       .
        brk                                     ; A88C 00                       .
        ora     (L0000,x)                       ; A88D 01 00                    ..
        brk                                     ; A88F 00                       .
        brk                                     ; A890 00                       .
        .byte   $02                             ; A891 02                       .
        brk                                     ; A892 00                       .
        ora     (L0000,x)                       ; A893 01 00                    ..
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
        ora     (L0000,x)                       ; A8A5 01 00                    ..
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
        .byte   $02                             ; A8BD 02                       .
        .byte   $02                             ; A8BE 02                       .
        brk                                     ; A8BF 00                       .
        brk                                     ; A8C0 00                       .
        brk                                     ; A8C1 00                       .
        brk                                     ; A8C2 00                       .
        brk                                     ; A8C3 00                       .
        .byte   $02                             ; A8C4 02                       .
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
        ora     $1B1A,y                         ; A919 19 1A 1B                 ...
        .byte   $1C                             ; A91C 1C                       .
        ora     a:$16,x                         ; A91D 1D 16 00                 ...
        brk                                     ; A920 00                       .
        brk                                     ; A921 00                       .
        brk                                     ; A922 00                       .
LA923:  brk                                     ; A923 00                       .
        brk                                     ; A924 00                       .
        .byte   $14                             ; A925 14                       .
        brk                                     ; A926 00                       .
        brk                                     ; A927 00                       .
        brk                                     ; A928 00                       .
        brk                                     ; A929 00                       .
        brk                                     ; A92A 00                       .
        brk                                     ; A92B 00                       .
        brk                                     ; A92C 00                       .
        brk                                     ; A92D 00                       .
        brk                                     ; A92E 00                       .
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
        brk                                     ; A940 00                       .
        brk                                     ; A941 00                       .
        brk                                     ; A942 00                       .
        brk                                     ; A943 00                       .
        brk                                     ; A944 00                       .
        brk                                     ; A945 00                       .
        brk                                     ; A946 00                       .
        brk                                     ; A947 00                       .
        brk                                     ; A948 00                       .
        brk                                     ; A949 00                       .
        brk                                     ; A94A 00                       .
        brk                                     ; A94B 00                       .
        brk                                     ; A94C 00                       .
        brk                                     ; A94D 00                       .
        brk                                     ; A94E 00                       .
        brk                                     ; A94F 00                       .
        jsr     L2220                           ; A950 20 20 22                   "
        .byte   $80                             ; A953 80                       .
        .byte   $A3                             ; A954 A3                       .
        .byte   $80                             ; A955 80                       .
        ldx     #$80                            ; A956 A2 80                    ..
        .byte   $A3                             ; A958 A3                       .
        jsr     LA080                           ; A959 20 80 A0                  ..
        .byte   $22                             ; A95C 22                       "
        rts                                     ; A95D 60                       `

; ----------------------------------------------------------------------------
        jsr     L0020                           ; A95E 20 20 00                   .
        brk                                     ; A961 00                       .
        brk                                     ; A962 00                       .
        brk                                     ; A963 00                       .
        brk                                     ; A964 00                       .
        brk                                     ; A965 00                       .
        brk                                     ; A966 00                       .
        brk                                     ; A967 00                       .
        clc                                     ; A968 18                       .
        clc                                     ; A969 18                       .
        .byte   $1A                             ; A96A 1A                       .
        jsr     L1A19                           ; A96B 20 19 1A                  ..
        sec                                     ; A96E 38                       8
        and     $1B                             ; A96F 25 1B                    %.
        brk                                     ; A971 00                       .
        brk                                     ; A972 00                       .
        brk                                     ; A973 00                       .
        .byte   $1C                             ; A974 1C                       .
        ora     #$80                            ; A975 09 80                    ..
        ldx     L0000,y                         ; A977 B6 00                    ..
        brk                                     ; A979 00                       .
        brk                                     ; A97A 00                       .
        .byte   $02                             ; A97B 02                       .
        brk                                     ; A97C 00                       .
        brk                                     ; A97D 00                       .
        brk                                     ; A97E 00                       .
        asl     a                               ; A97F 0A                       .
        sty     a:$8E                           ; A980 8C 8E 00                 ...
        brk                                     ; A983 00                       .
        brk                                     ; A984 00                       .
        brk                                     ; A985 00                       .
        brk                                     ; A986 00                       .
        brk                                     ; A987 00                       .
        and     (L0030,x)                       ; A988 21 30                    !0
        plp                                     ; A98A 28                       (
        .byte   $0F                             ; A98B 0F                       .
        and     (L0030,x)                       ; A98C 21 30                    !0
        .byte   $2B                             ; A98E 2B                       +
        .byte   $0F                             ; A98F 0F                       .
        and     (L0030,x)                       ; A990 21 30                    !0
        .byte   $27                             ; A992 27                       '
        .byte   $0F                             ; A993 0F                       .
        and     (L0030,x)                       ; A994 21 30                    !0
        .byte   $3C                             ; A996 3C                       <
        bit     a:L0000                         ; A997 2C 00 00                 ,..
        brk                                     ; A99A 00                       .
        sta     (L0000,x)                       ; A99B 81 00                    ..
        brk                                     ; A99D 00                       .
        brk                                     ; A99E 00                       .
        brk                                     ; A99F 00                       .
        brk                                     ; A9A0 00                       .
        brk                                     ; A9A1 00                       .
        brk                                     ; A9A2 00                       .
        brk                                     ; A9A3 00                       .
        brk                                     ; A9A4 00                       .
        brk                                     ; A9A5 00                       .
        brk                                     ; A9A6 00                       .
        brk                                     ; A9A7 00                       .
        brk                                     ; A9A8 00                       .
        brk                                     ; A9A9 00                       .
        brk                                     ; A9AA 00                       .
        brk                                     ; A9AB 00                       .
        brk                                     ; A9AC 00                       .
        brk                                     ; A9AD 00                       .
        brk                                     ; A9AE 00                       .
        brk                                     ; A9AF 00                       .
        brk                                     ; A9B0 00                       .
        brk                                     ; A9B1 00                       .
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
        brk                                     ; A9C0 00                       .
        brk                                     ; A9C1 00                       .
        brk                                     ; A9C2 00                       .
        brk                                     ; A9C3 00                       .
        brk                                     ; A9C4 00                       .
        brk                                     ; A9C5 00                       .
        brk                                     ; A9C6 00                       .
        brk                                     ; A9C7 00                       .
        brk                                     ; A9C8 00                       .
        brk                                     ; A9C9 00                       .
        brk                                     ; A9CA 00                       .
        brk                                     ; A9CB 00                       .
        brk                                     ; A9CC 00                       .
        brk                                     ; A9CD 00                       .
        brk                                     ; A9CE 00                       .
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
        brk                                     ; A9E1 00                       .
        brk                                     ; A9E2 00                       .
        brk                                     ; A9E3 00                       .
        brk                                     ; A9E4 00                       .
        brk                                     ; A9E5 00                       .
        brk                                     ; A9E6 00                       .
        brk                                     ; A9E7 00                       .
        brk                                     ; A9E8 00                       .
        brk                                     ; A9E9 00                       .
        brk                                     ; A9EA 00                       .
        brk                                     ; A9EB 00                       .
        brk                                     ; A9EC 00                       .
        brk                                     ; A9ED 00                       .
        brk                                     ; A9EE 00                       .
        brk                                     ; A9EF 00                       .
        brk                                     ; A9F0 00                       .
        brk                                     ; A9F1 00                       .
        brk                                     ; A9F2 00                       .
        brk                                     ; A9F3 00                       .
        brk                                     ; A9F4 00                       .
        brk                                     ; A9F5 00                       .
        brk                                     ; A9F6 00                       .
        brk                                     ; A9F7 00                       .
        brk                                     ; A9F8 00                       .
        bpl     LA9FB                           ; A9F9 10 00                    ..
LA9FB:  rti                                     ; A9FB 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; A9FC 00                       .
        bpl     LA9FF                           ; A9FD 10 00                    ..
LA9FF:  brk                                     ; A9FF 00                       .
        brk                                     ; AA00 00                       .
        ora     ($01,x)                         ; AA01 01 01                    ..
        .byte   $02                             ; AA03 02                       .
        .byte   $03                             ; AA04 03                       .
        .byte   $03                             ; AA05 03                       .
        .byte   $03                             ; AA06 03                       .
        .byte   $03                             ; AA07 03                       .
        .byte   $04                             ; AA08 04                       .
        .byte   $04                             ; AA09 04                       .
        .byte   $04                             ; AA0A 04                       .
        .byte   $04                             ; AA0B 04                       .
        ora     $05                             ; AA0C 05 05                    ..
        ora     $06                             ; AA0E 05 06                    ..
        asl     $07                             ; AA10 06 07                    ..
        .byte   $07                             ; AA12 07                       .
        php                                     ; AA13 08                       .
        php                                     ; AA14 08                       .
        php                                     ; AA15 08                       .
        ora     #$09                            ; AA16 09 09                    ..
        ora     #$09                            ; AA18 09 09                    ..
        asl     a                               ; AA1A 0A                       .
        asl     a                               ; AA1B 0A                       .
        asl     a                               ; AA1C 0A                       .
        asl     a                               ; AA1D 0A                       .
        asl     a                               ; AA1E 0A                       .
        .byte   $0B                             ; AA1F 0B                       .
        ora     $0D0D                           ; AA20 0D 0D 0D                 ...
        ora     $0D0D                           ; AA23 0D 0D 0D                 ...
        asl     L1010                           ; AA26 0E 10 10                 ...
        bpl     LAA3C                           ; AA29 10 11                    ..
        ora     ($11),y                         ; AA2B 11 11                    ..
        .byte   $12                             ; AA2D 12                       .
        .byte   $12                             ; AA2E 12                       .
LAA2F:  .byte   $13                             ; AA2F 13                       .
        asl     $16,x                           ; AA30 16 16                    ..
        .byte   $17                             ; AA32 17                       .
        .byte   $17                             ; AA33 17                       .
        clc                                     ; AA34 18                       .
        clc                                     ; AA35 18                       .
        clc                                     ; AA36 18                       .
        ora     $FF1B,y                         ; AA37 19 1B FF                 ...
        brk                                     ; AA3A 00                       .
        brk                                     ; AA3B 00                       .
LAA3C:  brk                                     ; AA3C 00                       .
        brk                                     ; AA3D 00                       .
        brk                                     ; AA3E 00                       .
        brk                                     ; AA3F 00                       .
        brk                                     ; AA40 00                       .
        brk                                     ; AA41 00                       .
        brk                                     ; AA42 00                       .
        brk                                     ; AA43 00                       .
        brk                                     ; AA44 00                       .
        brk                                     ; AA45 00                       .
        brk                                     ; AA46 00                       .
        brk                                     ; AA47 00                       .
        brk                                     ; AA48 00                       .
        brk                                     ; AA49 00                       .
        brk                                     ; AA4A 00                       .
        brk                                     ; AA4B 00                       .
        brk                                     ; AA4C 00                       .
        bpl     LAA4F                           ; AA4D 10 00                    ..
LAA4F:  brk                                     ; AA4F 00                       .
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
        brk                                     ; AA62 00                       .
        brk                                     ; AA63 00                       .
        brk                                     ; AA64 00                       .
        brk                                     ; AA65 00                       .
        brk                                     ; AA66 00                       .
LAA67:  brk                                     ; AA67 00                       .
        brk                                     ; AA68 00                       .
        brk                                     ; AA69 00                       .
        brk                                     ; AA6A 00                       .
        brk                                     ; AA6B 00                       .
        brk                                     ; AA6C 00                       .
        jsr     L0000                           ; AA6D 20 00 00                  ..
        brk                                     ; AA70 00                       .
        brk                                     ; AA71 00                       .
        brk                                     ; AA72 00                       .
        brk                                     ; AA73 00                       .
        brk                                     ; AA74 00                       .
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
        brk                                     ; AA80 00                       .
        .byte   $80                             ; AA81 80                       .
        .byte   $80                             ; AA82 80                       .
        bne     LAAD4                           ; AA83 D0 4F                    .O
LAA85:  .byte   $70                             ; AA85 70                       p
LAA86:  cpx     #$F0                            ; AA86 E0 F0                    ..
        .byte   $30,$A0                    ; AA88 30 A0   (branch out of range for ca65: target has no local label)
        .byte   $B0,$F0                    ; AA8A B0 F0   (branch out of range for ca65: target has no local label)
        and     (L0070),y                       ; AA8C 31 70                    1p
        .byte   $A0                             ; AA8E A0                       .
LAA8F:  inx                                     ; AA8F E8                       .
        .byte   $F0                             ; AA90 F0                       .
LAA91:  rts                                     ; AA91 60                       `

; ----------------------------------------------------------------------------
        .byte   $A0                             ; AA92 A0                       .
LAA93:  and     ($D0),y                         ; AA93 31 D0                    1.
        .byte   $F0,$08                    ; AA95 F0 08   (branch out of range for ca65: target has no local label)
        bpl     LAAD9                           ; AA97 10 40                    .@
        cpx     #$00                            ; AA99 E0 00                    ..
        jsr     L4140                           ; AA9B 20 40 41                  @A
        beq     LAAA0                           ; AA9E F0 00                    ..
LAAA0:  jsr     L7040                           ; AAA0 20 40 70                  @p
        .byte   $80                             ; AAA3 80                       .
        bne     LAA86                           ; AAA4 D0 E0                    ..
        jsr     L2818                           ; AAA6 20 18 28                  .(
        sec                                     ; AAA9 38                       8
        rts                                     ; AAAA 60                       `

; ----------------------------------------------------------------------------
        bne     LAA85                           ; AAAB D0 D8                    ..
        pha                                     ; AAAD 48                       H
        cli                                     ; AAAE 58                       X
        .byte   $80                             ; AAAF 80                       .
        sei                                     ; AAB0 78                       x
        bne     LAADB                           ; AAB1 D0 28                    .(
        .byte   $B0                             ; AAB3 B0                       .
LAAB4:  .byte   $50,$90                    ; AAB4 50 90   (branch out of range for ca65: target has no local label)
        cld                                     ; AAB6 D8                       .
        bne     LAA91                           ; AAB7 D0 D8                    ..
LAAB9:  .byte   $FF                             ; AAB9 FF                       .
        brk                                     ; AABA 00                       .
        brk                                     ; AABB 00                       .
        brk                                     ; AABC 00                       .
        brk                                     ; AABD 00                       .
LAABE:  brk                                     ; AABE 00                       .
        brk                                     ; AABF 00                       .
        brk                                     ; AAC0 00                       .
        brk                                     ; AAC1 00                       .
        brk                                     ; AAC2 00                       .
        brk                                     ; AAC3 00                       .
        brk                                     ; AAC4 00                       .
        brk                                     ; AAC5 00                       .
        brk                                     ; AAC6 00                       .
        brk                                     ; AAC7 00                       .
        brk                                     ; AAC8 00                       .
        brk                                     ; AAC9 00                       .
        brk                                     ; AACA 00                       .
        brk                                     ; AACB 00                       .
LAACC:  brk                                     ; AACC 00                       .
        brk                                     ; AACD 00                       .
        brk                                     ; AACE 00                       .
        brk                                     ; AACF 00                       .
        brk                                     ; AAD0 00                       .
        brk                                     ; AAD1 00                       .
        brk                                     ; AAD2 00                       .
        brk                                     ; AAD3 00                       .
LAAD4:  brk                                     ; AAD4 00                       .
        brk                                     ; AAD5 00                       .
        brk                                     ; AAD6 00                       .
        brk                                     ; AAD7 00                       .
        brk                                     ; AAD8 00                       .
LAAD9:  brk                                     ; AAD9 00                       .
        brk                                     ; AADA 00                       .
LAADB:  brk                                     ; AADB 00                       .
        brk                                     ; AADC 00                       .
        brk                                     ; AADD 00                       .
        brk                                     ; AADE 00                       .
        brk                                     ; AADF 00                       .
        brk                                     ; AAE0 00                       .
        brk                                     ; AAE1 00                       .
        brk                                     ; AAE2 00                       .
        brk                                     ; AAE3 00                       .
        brk                                     ; AAE4 00                       .
        brk                                     ; AAE5 00                       .
        brk                                     ; AAE6 00                       .
        brk                                     ; AAE7 00                       .
        brk                                     ; AAE8 00                       .
        brk                                     ; AAE9 00                       .
        brk                                     ; AAEA 00                       .
        brk                                     ; AAEB 00                       .
LAAEC:  brk                                     ; AAEC 00                       .
        .byte   $04                             ; AAED 04                       .
        jsr     L0000                           ; AAEE 20 00 00                  ..
        brk                                     ; AAF1 00                       .
LAAF2:  brk                                     ; AAF2 00                       .
        brk                                     ; AAF3 00                       .
        brk                                     ; AAF4 00                       .
        brk                                     ; AAF5 00                       .
        brk                                     ; AAF6 00                       .
        brk                                     ; AAF7 00                       .
        brk                                     ; AAF8 00                       .
        brk                                     ; AAF9 00                       .
        .byte   $80                             ; AAFA 80                       .
        brk                                     ; AAFB 00                       .
        brk                                     ; AAFC 00                       .
        brk                                     ; AAFD 00                       .
        .byte   $80                             ; AAFE 80                       .
        brk                                     ; AAFF 00                       .
        brk                                     ; AB00 00                       .
        .byte   $80                             ; AB01 80                       .
        .byte   $80                             ; AB02 80                       .
        ldy     #$38                            ; AB03 A0 38                    .8
LAB05:  .byte   $80                             ; AB05 80                       .
        sec                                     ; AB06 38                       8
        ldy     #$80                            ; AB07 A0 80                    ..
        bvc     LAB3B                           ; AB09 50 30                    P0
        bvc     LAA93                           ; AB0B 50 86                    P.
        ldx     $58                             ; AB0D A6 58                    .X
        pha                                     ; AB0F 48                       H
        clc                                     ; AB10 18                       .
        pha                                     ; AB11 48                       H
        bvs     LAACC                           ; AB12 70 B8                    p.
        iny                                     ; AB14 C8                       .
        clc                                     ; AB15 18                       .
        clc                                     ; AB16 18                       .
        clv                                     ; AB17 B8                       .
        sei                                     ; AB18 78                       x
        jsr     LB000                           ; AB19 20 00 B0                  ..
        ror     L0020                           ; AB1C 66 20                    f 
        bvc     LAB20                           ; AB1E 50 00                    P.
LAB20:  .byte   $64                             ; AB20 64                       d
        jsr     L24B0                           ; AB21 20 B0 24                  .$
        ldy     $60                             ; AB24 A4 60                    .`
        sty     $58                             ; AB26 84 58                    .X
        pla                                     ; AB28 68                       h
        sei                                     ; AB29 78                       x
        clc                                     ; AB2A 18                       .
        plp                                     ; AB2B 28                       (
        .byte   $D7                             ; AB2C D7                       .
        plp                                     ; AB2D 28                       (
        sec                                     ; AB2E 38                       8
        .byte   $80                             ; AB2F 80                       .
        bvc     LAB8A                           ; AB30 50 58                    PX
        bvc     LAAB4                           ; AB32 50 80                    P.
        rts                                     ; AB34 60                       `

; ----------------------------------------------------------------------------
        rti                                     ; AB35 40                       @

; ----------------------------------------------------------------------------
        bcc     LAAEC                           ; AB36 90 B4                    ..
        brk                                     ; AB38 00                       .
        .byte   $FF                             ; AB39 FF                       .
        brk                                     ; AB3A 00                       .
LAB3B:  brk                                     ; AB3B 00                       .
        brk                                     ; AB3C 00                       .
        brk                                     ; AB3D 00                       .
        brk                                     ; AB3E 00                       .
        brk                                     ; AB3F 00                       .
        brk                                     ; AB40 00                       .
        brk                                     ; AB41 00                       .
        brk                                     ; AB42 00                       .
        brk                                     ; AB43 00                       .
        brk                                     ; AB44 00                       .
        brk                                     ; AB45 00                       .
        brk                                     ; AB46 00                       .
        brk                                     ; AB47 00                       .
        brk                                     ; AB48 00                       .
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
        brk                                     ; AB62 00                       .
        brk                                     ; AB63 00                       .
        brk                                     ; AB64 00                       .
        brk                                     ; AB65 00                       .
        brk                                     ; AB66 00                       .
        brk                                     ; AB67 00                       .
        brk                                     ; AB68 00                       .
        brk                                     ; AB69 00                       .
        brk                                     ; AB6A 00                       .
        brk                                     ; AB6B 00                       .
        brk                                     ; AB6C 00                       .
        brk                                     ; AB6D 00                       .
        brk                                     ; AB6E 00                       .
        brk                                     ; AB6F 00                       .
        brk                                     ; AB70 00                       .
        brk                                     ; AB71 00                       .
        brk                                     ; AB72 00                       .
        brk                                     ; AB73 00                       .
        brk                                     ; AB74 00                       .
        brk                                     ; AB75 00                       .
        brk                                     ; AB76 00                       .
        brk                                     ; AB77 00                       .
        brk                                     ; AB78 00                       .
        brk                                     ; AB79 00                       .
        brk                                     ; AB7A 00                       .
        brk                                     ; AB7B 00                       .
        brk                                     ; AB7C 00                       .
        brk                                     ; AB7D 00                       .
        brk                                     ; AB7E 00                       .
        brk                                     ; AB7F 00                       .
        bne     LABCA                           ; AB80 D0 48                    .H
        cmp     ($14),y                         ; AB82 D1 14                    ..
        rol     $14,x                           ; AB84 36 14                    6.
        rol     $14,x                           ; AB86 36 14                    6.
        .byte   $14                             ; AB88 14                       .
        .byte   $36                             ; AB89 36                       6
LAB8A:  rol     $14,x                           ; AB8A 36 14                    6.
        .byte   $2F                             ; AB8C 2F                       /
        rol     $6186                           ; AB8D 2E 86 61                 ..a
        adc     ($84,x)                         ; AB90 61 84                    a.
        and     $2083,y                         ; AB92 39 83 20                 9. 
        adc     ($61,x)                         ; AB95 61 61                    aa
        jsr     L6123                           ; AB97 20 23 61                  #a
        cmp     ($36),y                         ; AB9A D1 36                    .6
        and     $3636                           ; AB9C 2D 36 36                 -66
        bne     LABBE                           ; AB9F D0 1D                    ..
        adc     ($61,x)                         ; ABA1 61 61                    aa
        ora     $611D,x                         ; ABA3 1D 1D 61                 ..a
        .byte   $0C                             ; ABA6 0C                       .
        ora     ($01,x)                         ; ABA7 01 01                    ..
        ora     ($01,x)                         ; ABA9 01 01                    ..
        ora     ($8B,x)                         ; ABAB 01 8B                    ..
        ora     ($01,x)                         ; ABAD 01 01                    ..
        eor     #$33                            ; ABAF 49 33                    I3
        .byte   $33                             ; ABB1 33                       3
        .byte   $33                             ; ABB2 33                       3
        .byte   $33                             ; ABB3 33                       3
        .byte   $33                             ; ABB4 33                       3
        .byte   $33                             ; ABB5 33                       3
        .byte   $33                             ; ABB6 33                       3
        ora     $FF64,x                         ; ABB7 1D 64 FF                 .d.
        brk                                     ; ABBA 00                       .
        brk                                     ; ABBB 00                       .
        brk                                     ; ABBC 00                       .
        brk                                     ; ABBD 00                       .
LABBE:  brk                                     ; ABBE 00                       .
        brk                                     ; ABBF 00                       .
        brk                                     ; ABC0 00                       .
        brk                                     ; ABC1 00                       .
        brk                                     ; ABC2 00                       .
        brk                                     ; ABC3 00                       .
        brk                                     ; ABC4 00                       .
        brk                                     ; ABC5 00                       .
        brk                                     ; ABC6 00                       .
        brk                                     ; ABC7 00                       .
        brk                                     ; ABC8 00                       .
        brk                                     ; ABC9 00                       .
LABCA:  brk                                     ; ABCA 00                       .
        .byte   $04                             ; ABCB 04                       .
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
        brk                                     ; ABE0 00                       .
        brk                                     ; ABE1 00                       .
        brk                                     ; ABE2 00                       .
        brk                                     ; ABE3 00                       .
        brk                                     ; ABE4 00                       .
        brk                                     ; ABE5 00                       .
        brk                                     ; ABE6 00                       .
        brk                                     ; ABE7 00                       .
        brk                                     ; ABE8 00                       .
        brk                                     ; ABE9 00                       .
        brk                                     ; ABEA 00                       .
        brk                                     ; ABEB 00                       .
        brk                                     ; ABEC 00                       .
        brk                                     ; ABED 00                       .
        brk                                     ; ABEE 00                       .
        brk                                     ; ABEF 00                       .
        brk                                     ; ABF0 00                       .
        brk                                     ; ABF1 00                       .
        brk                                     ; ABF2 00                       .
        brk                                     ; ABF3 00                       .
        brk                                     ; ABF4 00                       .
        brk                                     ; ABF5 00                       .
        brk                                     ; ABF6 00                       .
        brk                                     ; ABF7 00                       .
        brk                                     ; ABF8 00                       .
        brk                                     ; ABF9 00                       .
        brk                                     ; ABFA 00                       .
        brk                                     ; ABFB 00                       .
        brk                                     ; ABFC 00                       .
        brk                                     ; ABFD 00                       .
        brk                                     ; ABFE 00                       .
        brk                                     ; ABFF 00                       .
        brk                                     ; AC00 00                       .
        ora     ($03,x)                         ; AC01 01 03                    ..
        .byte   $04                             ; AC03 04                       .
        php                                     ; AC04 08                       .
        .byte   $0C                             ; AC05 0C                       .
        .byte   $0F                             ; AC06 0F                       .
        ora     ($13),y                         ; AC07 11 13                    ..
        asl     $1A,x                           ; AC09 16 1A                    ..
        .byte   $1F                             ; AC0B 1F                       .
        jsr     L2620                           ; AC0C 20 20 26                   &
        .byte   $27                             ; AC0F 27                       '
        .byte   $27                             ; AC10 27                       '
        rol     a                               ; AC11 2A                       *
        and     $302F                           ; AC12 2D 2F 30                 -/0
        bmi     LAC47                           ; AC15 30 30                    00
        .byte   $32                             ; AC17 32                       2
        .byte   $34                             ; AC18 34                       4
        .byte   $37                             ; AC19 37                       7
        sec                                     ; AC1A 38                       8
        sec                                     ; AC1B 38                       8
        brk                                     ; AC1C 00                       .
        brk                                     ; AC1D 00                       .
        brk                                     ; AC1E 00                       .
        bpl     LAC21                           ; AC1F 10 00                    ..
LAC21:  brk                                     ; AC21 00                       .
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
LAC47:  brk                                     ; AC47 00                       .
        brk                                     ; AC48 00                       .
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
        brk                                     ; AC65 00                       .
        brk                                     ; AC66 00                       .
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
        brk                                     ; ACE1 00                       .
        brk                                     ; ACE2 00                       .
        brk                                     ; ACE3 00                       .
        brk                                     ; ACE4 00                       .
        brk                                     ; ACE5 00                       .
        brk                                     ; ACE6 00                       .
        brk                                     ; ACE7 00                       .
        brk                                     ; ACE8 00                       .
        brk                                     ; ACE9 00                       .
        rti                                     ; ACEA 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; ACEB 00                       .
        brk                                     ; ACEC 00                       .
        brk                                     ; ACED 00                       .
        brk                                     ; ACEE 00                       .
        brk                                     ; ACEF 00                       .
        brk                                     ; ACF0 00                       .
        brk                                     ; ACF1 00                       .
        brk                                     ; ACF2 00                       .
        brk                                     ; ACF3 00                       .
        brk                                     ; ACF4 00                       .
        brk                                     ; ACF5 00                       .
        brk                                     ; ACF6 00                       .
        brk                                     ; ACF7 00                       .
        brk                                     ; ACF8 00                       .
        brk                                     ; ACF9 00                       .
        brk                                     ; ACFA 00                       .
        brk                                     ; ACFB 00                       .
        brk                                     ; ACFC 00                       .
        brk                                     ; ACFD 00                       .
        php                                     ; ACFE 08                       .
        brk                                     ; ACFF 00                       .
        brk                                     ; AD00 00                       .
        ora     ($03,x)                         ; AD01 01 03                    ..
        ora     $04                             ; AD03 05 04                    ..
        jsr     L6040                           ; AD05 20 40 60                  @`
        .byte   $22                             ; AD08 22                       "
        .byte   $22                             ; AD09 22                       "
        .byte   $22                             ; AD0A 22                       "
        .byte   $63                             ; AD0B 63                       c
        lsr     $4A                             ; AD0C 46 4A                    FJ
        bit     $4247                           ; AD0E 2C 47 42                 ,GB
        .byte   $43                             ; AD11 43                       C
        .byte   $24                             ; AD12 24                       $
LAD13:  .byte   $64                             ; AD13 64                       d
        plp                                     ; AD14 28                       (
        rol     a                               ; AD15 2A                       *
        pla                                     ; AD16 68                       h
        sec                                     ; AD17 38                       8
        .byte   $62                             ; AD18 62                       b
        .byte   $74                             ; AD19 74                       t
        .byte   $34                             ; AD1A 34                       4
        rol     $0D                             ; AD1B 26 0D                    &.
        .byte   $2B                             ; AD1D 2B                       +
        pha                                     ; AD1E 48                       H
        sec                                     ; AD1F 38                       8
LAD20:  .byte   $07                             ; AD20 07                       .
        ora     #$0B                            ; AD21 09 0B                    ..
        cpy     $66                             ; AD23 C4 66                    .f
        ror     a                               ; AD25 6A                       j
        and     $C667                           ; AD26 2D 67 C6                 -g.
        .byte   $A7                             ; AD29 A7                       .
        iny                                     ; AD2A C8                       .
        sty     $A8                             ; AD2B 84 A8                    ..
        tay                                     ; AD2D A8                       .
        tay                                     ; AD2E A8                       .
        lda     #$A9                            ; AD2F A9 A9                    ..
        stx     $88                             ; AD31 86 88                    ..
        .byte   $89                             ; AD33 89                       .
        .byte   $8B                             ; AD34 8B                       .
        brk                                     ; AD35 00                       .
        sta     a:$C0                           ; AD36 8D C0 00                 ...
        sbc     ($E3,x)                         ; AD39 E1 E3                    ..
        sbc     $E7                             ; AD3B E5 E7                    ..
        sbc     #$C2                            ; AD3D E9 C2                    ..
        bne     LAD13                           ; AD3F D0 D2                    ..
        brk                                     ; AD41 00                       .
        dec     $4746                           ; AD42 CE 46 47                 .FG
        lsr     $4B                             ; AD45 46 4B                    FK
        plp                                     ; AD47 28                       (
        adc     #$D1                            ; AD48 69 D1                    i.
        sty     $BC                             ; AD4A 84 BC                    ..
        bne     LAD20                           ; AD4C D0 D2                    ..
        pla                                     ; AD4E 68                       h
        bpl     LAD51                           ; AD4F 10 00                    ..
LAD51:  brk                                     ; AD51 00                       .
        jmp     L000E                           ; AD52 4C 0E 00                 L..

; ----------------------------------------------------------------------------
        bpl     LADA1                           ; AD55 10 4A                    .J
        brk                                     ; AD57 00                       .
        brk                                     ; AD58 00                       .
        jmp     (L107C)                         ; AD59 6C 7C 10                 l|.

; ----------------------------------------------------------------------------
        rol     $100F                           ; AD5C 2E 0F 10                 ...
        dec     $5D00,x                         ; AD5F DE 00 5D                 ..]
        bpl     LADD1                           ; AD62 10 6D                    .m
        bpl     LAD76                           ; AD64 10 10                    ..
        .byte   $1F                             ; AD66 1F                       .
        brk                                     ; AD67 00                       .
        brk                                     ; AD68 00                       .
        lsr     LAF10                           ; AD69 4E 10 AF                 N..
        .byte   $9E                             ; AD6C 9E                       .
        bpl     LAD7F                           ; AD6D 10 10                    ..
        .byte   $AF                             ; AD6F AF                       .
        brk                                     ; AD70 00                       .
        .byte   $6F                             ; AD71 6F                       o
        lsr     L1010                           ; AD72 4E 10 10                 N..
        .byte   $AF                             ; AD75 AF                       .
LAD76:  .byte   $9E                             ; AD76 9E                       .
        asl     $0700,x                         ; AD77 1E 00 07                 ...
        brk                                     ; AD7A 00                       .
        .byte   $6F                             ; AD7B 6F                       o
        .byte   $9E                             ; AD7C 9E                       .
        .byte   $EC                             ; AD7D EC                       .
        .byte   $EE                             ; AD7E EE                       .
LAD7F:  .byte   $0B                             ; AD7F 0B                       .
        nop                                     ; AD80 EA                       .
        cpy     a:L0000                         ; AD81 CC 00 00                 ...
        brk                                     ; AD84 00                       .
        brk                                     ; AD85 00                       .
        brk                                     ; AD86 00                       .
        brk                                     ; AD87 00                       .
        dec     $4746                           ; AD88 CE 46 47                 .FG
        plp                                     ; AD8B 28                       (
        sec                                     ; AD8C 38                       8
        ror     $67                             ; AD8D 66 67                    fg
        ora     $1038                           ; AD8F 0D 38 10                 .8.
        ldy     $8000,x                         ; AD92 BC 00 80                 ...
        .byte   $82                             ; AD95 82                       .
        brk                                     ; AD96 00                       .
        brk                                     ; AD97 00                       .
        bpl     LADAA                           ; AD98 10 10                    ..
        brk                                     ; AD9A 00                       .
LAD9B:  brk                                     ; AD9B 00                       .
        ldy     #$A2                            ; AD9C A0 A2                    ..
        brk                                     ; AD9E 00                       .
        brk                                     ; AD9F 00                       .
        brk                                     ; ADA0 00                       .
LADA1:  brk                                     ; ADA1 00                       .
        brk                                     ; ADA2 00                       .
        brk                                     ; ADA3 00                       .
        brk                                     ; ADA4 00                       .
        brk                                     ; ADA5 00                       .
        brk                                     ; ADA6 00                       .
        brk                                     ; ADA7 00                       .
        brk                                     ; ADA8 00                       .
        brk                                     ; ADA9 00                       .
LADAA:  brk                                     ; ADAA 00                       .
        brk                                     ; ADAB 00                       .
        brk                                     ; ADAC 00                       .
        brk                                     ; ADAD 00                       .
        brk                                     ; ADAE 00                       .
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
        brk                                     ; ADCA 00                       .
        brk                                     ; ADCB 00                       .
        brk                                     ; ADCC 00                       .
        brk                                     ; ADCD 00                       .
        brk                                     ; ADCE 00                       .
        brk                                     ; ADCF 00                       .
        brk                                     ; ADD0 00                       .
LADD1:  brk                                     ; ADD1 00                       .
        brk                                     ; ADD2 00                       .
        brk                                     ; ADD3 00                       .
        brk                                     ; ADD4 00                       .
        brk                                     ; ADD5 00                       .
        brk                                     ; ADD6 00                       .
        brk                                     ; ADD7 00                       .
        brk                                     ; ADD8 00                       .
        brk                                     ; ADD9 00                       .
        brk                                     ; ADDA 00                       .
        brk                                     ; ADDB 00                       .
        brk                                     ; ADDC 00                       .
        brk                                     ; ADDD 00                       .
        brk                                     ; ADDE 00                       .
        brk                                     ; ADDF 00                       .
        brk                                     ; ADE0 00                       .
        brk                                     ; ADE1 00                       .
        brk                                     ; ADE2 00                       .
        brk                                     ; ADE3 00                       .
        brk                                     ; ADE4 00                       .
        brk                                     ; ADE5 00                       .
        brk                                     ; ADE6 00                       .
        brk                                     ; ADE7 00                       .
        brk                                     ; ADE8 00                       .
        brk                                     ; ADE9 00                       .
        brk                                     ; ADEA 00                       .
        brk                                     ; ADEB 00                       .
        brk                                     ; ADEC 00                       .
        brk                                     ; ADED 00                       .
        brk                                     ; ADEE 00                       .
        brk                                     ; ADEF 00                       .
        brk                                     ; ADF0 00                       .
        brk                                     ; ADF1 00                       .
        brk                                     ; ADF2 00                       .
        brk                                     ; ADF3 00                       .
        brk                                     ; ADF4 00                       .
        brk                                     ; ADF5 00                       .
        brk                                     ; ADF6 00                       .
        brk                                     ; ADF7 00                       .
        brk                                     ; ADF8 00                       .
        brk                                     ; ADF9 00                       .
        brk                                     ; ADFA 00                       .
        brk                                     ; ADFB 00                       .
        brk                                     ; ADFC 00                       .
        brk                                     ; ADFD 00                       .
        brk                                     ; ADFE 00                       .
        brk                                     ; ADFF 00                       .
        brk                                     ; AE00 00                       .
        .byte   $02                             ; AE01 02                       .
        .byte   $04                             ; AE02 04                       .
        brk                                     ; AE03 00                       .
        ora     L0021                           ; AE04 05 21                    .!
        eor     ($61,x)                         ; AE06 41 61                    Aa
        .byte   $23                             ; AE08 23                       #
        .byte   $23                             ; AE09 23                       #
        .byte   $23                             ; AE0A 23                       #
        asl     $47                             ; AE0B 06 47                    .G
        .byte   $4B                             ; AE0D 4B                       K
        .byte   $4B                             ; AE0E 4B                       K
        lsr     $43                             ; AE0F 46 43                    FC
        ldy     $6525                           ; AE11 AC 25 65                 .%e
        and     #$2A                            ; AE14 29 2A                    )*
        adc     #$39                            ; AE16 69 39                    i9
        .byte   $63                             ; AE18 63                       c
        adc     $35,x                           ; AE19 75 35                    u5
        .byte   $27                             ; AE1B 27                       '
        and     #$D9                            ; AE1C 29 D9                    ).
        eor     #$1D                            ; AE1E 49 1D                    I.
        php                                     ; AE20 08                       .
        asl     a                               ; AE21 0A                       .
        .byte   $0C                             ; AE22 0C                       .
        cmp     $67                             ; AE23 C5 67                    .g
        .byte   $6B                             ; AE25 6B                       k
        .byte   $6B                             ; AE26 6B                       k
        ror     $C7                             ; AE27 66 C7                    f.
        brk                                     ; AE29 00                       .
        iny                                     ; AE2A C8                       .
        sta     $85                             ; AE2B 85 85                    ..
        lda     $A8                             ; AE2D A5 A8                    ..
        tay                                     ; AE2F A8                       .
        ldy     $87                             ; AE30 A4 87                    ..
        brk                                     ; AE32 00                       .
        txa                                     ; AE33 8A                       .
        sty     LA600                           ; AE34 8C 00 A6                 ...
        cmp     ($E0,x)                         ; AE37 C1 E0                    ..
        .byte   $E2                             ; AE39 E2                       .
        cpx     $E6                             ; AE3A E4 E6                    ..
        inx                                     ; AE3C E8                       .
        brk                                     ; AE3D 00                       .
        .byte   $C3                             ; AE3E C3                       .
        cmp     ($D3),y                         ; AE3F D1 D3                    ..
        brk                                     ; AE41 00                       .
        .byte   $CF                             ; AE42 CF                       .
        .byte   $47                             ; AE43 47                       G
        lsr     $4A                             ; AE44 46 4A                    FJ
        lsr     $68                             ; AE46 46 68                    Fh
        and     LA4D2,y                         ; AE48 39 D2 A4                 9..
        lda     $D3D1,x                         ; AE4B BD D1 D3                 ...
        .byte   $69                             ; AE4E 69                       i
LAE4F:  .byte   $10,$00                    ; AE4F 10 00   (branch out of range for ca65: target has no local label)
        brk                                     ; AE51 00                       .
        eor     a:$0F                           ; AE52 4D 0F 00                 M..
        cmp     #$4B                            ; AE55 C9 4B                    .K
        brk                                     ; AE57 00                       .
        jmp     L106D                           ; AE58 4C 6D 10                 Lm.

; ----------------------------------------------------------------------------
        bpl     LAE8C                           ; AE5B 10 2F                    ./
        brk                                     ; AE5D 00                       .
        .byte   $4F                             ; AE5E 4F                       O
        .byte   $DF                             ; AE5F DF                       .
        jmp     L107C                           ; AE60 4C 7C 10                 L|.

; ----------------------------------------------------------------------------
        .byte   $7C                             ; AE63 7C                       |
        bpl     LAE84                           ; AE64 10 1E                    ..
        brk                                     ; AE66 00                       .
        brk                                     ; AE67 00                       .
        ror     LAE4F                           ; AE68 6E 4F AE                 nO.
        .byte   $BF                             ; AE6B BF                       .
        .byte   $9F                             ; AE6C 9F                       .
        .byte   $3F                             ; AE6D 3F                       ?
        ldx     $6E9F                           ; AE6E AE 9F 6E                 ..n
        ror     $104F,x                         ; AE71 7E 4F 10                 ~O.
        ldx     $9FBF                           ; AE74 AE BF 9F                 ...
        .byte   $1F                             ; AE77 1F                       .
        jmp     L6E08                           ; AE78 4C 08 6E                 L.n

; ----------------------------------------------------------------------------
        ror     $ED9F,x                         ; AE7B 7E 9F ED                 ~..
        .byte   $EF                             ; AE7E EF                       .
        .byte   $0C                             ; AE7F 0C                       .
        .byte   $EB                             ; AE80 EB                       .
        cmp     a:L0000                         ; AE81 CD 00 00                 ...
LAE84:  brk                                     ; AE84 00                       .
        brk                                     ; AE85 00                       .
        brk                                     ; AE86 00                       .
        brk                                     ; AE87 00                       .
        .byte   $CF                             ; AE88 CF                       .
        .byte   $47                             ; AE89 47                       G
        lsr     $29                             ; AE8A 46 29                    F)
LAE8C:  and     $6667,y                         ; AE8C 39 67 66                 9gf
        and     #$1D                            ; AE8F 29 1D                    ).
        cmp     #$BD                            ; AE91 C9 BD                    ..
        brk                                     ; AE93 00                       .
        sta     ($83,x)                         ; AE94 81 83                    ..
        brk                                     ; AE96 00                       .
        brk                                     ; AE97 00                       .
        bpl     LAEAA                           ; AE98 10 10                    ..
        brk                                     ; AE9A 00                       .
        brk                                     ; AE9B 00                       .
        lda     ($A3,x)                         ; AE9C A1 A3                    ..
        brk                                     ; AE9E 00                       .
        brk                                     ; AE9F 00                       .
        brk                                     ; AEA0 00                       .
        brk                                     ; AEA1 00                       .
        brk                                     ; AEA2 00                       .
        brk                                     ; AEA3 00                       .
        brk                                     ; AEA4 00                       .
        brk                                     ; AEA5 00                       .
        brk                                     ; AEA6 00                       .
        brk                                     ; AEA7 00                       .
        brk                                     ; AEA8 00                       .
        brk                                     ; AEA9 00                       .
LAEAA:  brk                                     ; AEAA 00                       .
        brk                                     ; AEAB 00                       .
        brk                                     ; AEAC 00                       .
        brk                                     ; AEAD 00                       .
        brk                                     ; AEAE 00                       .
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
        brk                                     ; AECA 00                       .
        brk                                     ; AECB 00                       .
        brk                                     ; AECC 00                       .
        brk                                     ; AECD 00                       .
        brk                                     ; AECE 00                       .
        brk                                     ; AECF 00                       .
        brk                                     ; AED0 00                       .
        brk                                     ; AED1 00                       .
        brk                                     ; AED2 00                       .
        brk                                     ; AED3 00                       .
        brk                                     ; AED4 00                       .
        brk                                     ; AED5 00                       .
        brk                                     ; AED6 00                       .
        brk                                     ; AED7 00                       .
        brk                                     ; AED8 00                       .
        brk                                     ; AED9 00                       .
        brk                                     ; AEDA 00                       .
        brk                                     ; AEDB 00                       .
        brk                                     ; AEDC 00                       .
        brk                                     ; AEDD 00                       .
        brk                                     ; AEDE 00                       .
        brk                                     ; AEDF 00                       .
        brk                                     ; AEE0 00                       .
        brk                                     ; AEE1 00                       .
        brk                                     ; AEE2 00                       .
        brk                                     ; AEE3 00                       .
        brk                                     ; AEE4 00                       .
        brk                                     ; AEE5 00                       .
        brk                                     ; AEE6 00                       .
        brk                                     ; AEE7 00                       .
        brk                                     ; AEE8 00                       .
        brk                                     ; AEE9 00                       .
        brk                                     ; AEEA 00                       .
        brk                                     ; AEEB 00                       .
        brk                                     ; AEEC 00                       .
        brk                                     ; AEED 00                       .
        brk                                     ; AEEE 00                       .
        brk                                     ; AEEF 00                       .
        brk                                     ; AEF0 00                       .
        brk                                     ; AEF1 00                       .
        brk                                     ; AEF2 00                       .
        brk                                     ; AEF3 00                       .
        brk                                     ; AEF4 00                       .
        brk                                     ; AEF5 00                       .
        brk                                     ; AEF6 00                       .
        brk                                     ; AEF7 00                       .
        brk                                     ; AEF8 00                       .
        brk                                     ; AEF9 00                       .
        brk                                     ; AEFA 00                       .
        brk                                     ; AEFB 00                       .
        brk                                     ; AEFC 00                       .
        brk                                     ; AEFD 00                       .
        brk                                     ; AEFE 00                       .
        brk                                     ; AEFF 00                       .
        brk                                     ; AF00 00                       .
        ora     ($13),y                         ; AF01 11 13                    ..
        ora     $14,x                           ; AF03 15 14                    ..
        bmi     LAF57                           ; AF05 30 50                    0P
        bvs     LAF3B                           ; AF07 70 32                    p2
LAF09:  tax                                     ; AF09 AA                       .
        bit     $54                             ; AF0A 24 54                    $T
        lsr     $5A,x                           ; AF0C 56 5A                    VZ
        .byte   $3C                             ; AF0E 3C                       <
        .byte   $57                             ; AF0F 57                       W
LAF10:  .byte   $52                             ; AF10 52                       R
LAF11:  .byte   $43                             ; AF11 43                       C
        bit     $53                             ; AF12 24 53                    $S
        ora     $783A                           ; AF14 0D 3A 78                 .:x
        sec                                     ; AF17 38                       8
        .byte   $72                             ; AF18 72                       r
        .byte   $54                             ; AF19 54                       T
        .byte   $44                             ; AF1A 44                       D
        rol     $0D,x                           ; AF1B 36 0D                    6.
        .byte   $3B                             ; AF1D 3B                       ;
        cli                                     ; AF1E 58                       X
        sec                                     ; AF1F 38                       8
        .byte   $17                             ; AF20 17                       .
        ora     $D41B,y                         ; AF21 19 1B D4                 ...
        ror     $7A,x                           ; AF24 76 7A                    vz
        and     $D677,x                         ; AF26 3D 77 D6                 =w.
        brk                                     ; AF29 00                       .
        iny                                     ; AF2A C8                       .
        sty     $B8,x                           ; AF2B 94 B8                    ..
        clv                                     ; AF2D B8                       .
        clv                                     ; AF2E B8                       .
        .byte   $B9                             ; AF2F B9                       .
        .byte   $B9                             ; AF30 B9                       .
LAF31:  stx     $98,y                           ; AF31 96 98                    ..
        sta     LAD9B,y                         ; AF33 99 9B AD                 ...
        sta     a:$D0,x                         ; AF36 9D D0 00                 ...
        sbc     ($F3),y                         ; AF39 F1 F3                    ..
LAF3B:  sbc     $F7,x                           ; AF3B F5 F7                    ..
        sbc     $D0D2,y                         ; AF3D F9 D2 D0                 ...
        .byte   $D2                             ; AF40 D2                       .
        brk                                     ; AF41 00                       .
        dec     $7776                           ; AF42 CE 76 77                 .vw
        lsr     $5B,x                           ; AF45 56 5B                    V[
        ora     $D179                           ; AF47 0D 79 D1                 .y.
        sty     $BA,x                           ; AF4A 94 BA                    ..
        bne     LAF09                           ; AF4C D0 BB                    ..
        cmp     #$10                            ; AF4E C9 10                    ..
LAF50:  brk                                     ; AF50 00                       .
        brk                                     ; AF51 00                       .
        eor     $1F10,x                         ; AF52 5D 10 1F                 ]..
        bpl     LAF31                           ; AF55 10 DA                    ..
LAF57:  brk                                     ; AF57 00                       .
        .byte   $5C                             ; AF58 5C                       \
        bpl     LAF6B                           ; AF59 10 10                    ..
        bpl     LAF6D                           ; AF5B 10 10                    ..
        asl     $DE10,x                         ; AF5D 1E 10 DE                 ...
        jmp     L1010                           ; AF60 4C 10 10                 L..

; ----------------------------------------------------------------------------
        bpl     LAF75                           ; AF63 10 10                    ..
        bpl     LAF95                           ; AF65 10 2E                    ..
        .byte   $0F                             ; AF67 0F                       .
        brk                                     ; AF68 00                       .
        .byte   $5E                             ; AF69 5E                       ^
        .byte   $8E                             ; AF6A 8E                       .
LAF6B:  brk                                     ; AF6B 00                       .
        brk                                     ; AF6C 00                       .
LAF6D:  stx     a:$10                           ; AF6D 8E 10 00                 ...
        brk                                     ; AF70 00                       .
        brk                                     ; AF71 00                       .
        lsr     $8E10,x                         ; AF72 5E 10 8E                 ^..
LAF75:  brk                                     ; AF75 00                       .
        brk                                     ; AF76 00                       .
        bpl     LAF79                           ; AF77 10 00                    ..
LAF79:  .byte   $17                             ; AF79 17                       .
        brk                                     ; AF7A 00                       .
        brk                                     ; AF7B 00                       .
        brk                                     ; AF7C 00                       .
        .byte   $FC                             ; AF7D FC                       .
        inc     $FA1B,x                         ; AF7E FE 1B FA                 ...
        .byte   $DC                             ; AF81 DC                       .
        brk                                     ; AF82 00                       .
        brk                                     ; AF83 00                       .
        brk                                     ; AF84 00                       .
        brk                                     ; AF85 00                       .
        brk                                     ; AF86 00                       .
        brk                                     ; AF87 00                       .
        dec     $5756                           ; AF88 CE 56 57                 .VW
        ora     $7638                           ; AF8B 0D 38 76                 .8v
        .byte   $77                             ; AF8E 77                       w
        ora     $1038                           ; AF8F 0D 38 10                 .8.
        ldy     $9000,x                         ; AF92 BC 00 90                 ...
LAF95:  .byte   $92                             ; AF95 92                       .
        brk                                     ; AF96 00                       .
        brk                                     ; AF97 00                       .
        .byte   $B7                             ; AF98 B7                       .
        bpl     LAF9B                           ; AF99 10 00                    ..
LAF9B:  brk                                     ; AF9B 00                       .
        bcs     LAF50                           ; AF9C B0 B2                    ..
        brk                                     ; AF9E 00                       .
        brk                                     ; AF9F 00                       .
        brk                                     ; AFA0 00                       .
        brk                                     ; AFA1 00                       .
        brk                                     ; AFA2 00                       .
        brk                                     ; AFA3 00                       .
        brk                                     ; AFA4 00                       .
        brk                                     ; AFA5 00                       .
        brk                                     ; AFA6 00                       .
        brk                                     ; AFA7 00                       .
        brk                                     ; AFA8 00                       .
        brk                                     ; AFA9 00                       .
        brk                                     ; AFAA 00                       .
        brk                                     ; AFAB 00                       .
        brk                                     ; AFAC 00                       .
        brk                                     ; AFAD 00                       .
        brk                                     ; AFAE 00                       .
        brk                                     ; AFAF 00                       .
        brk                                     ; AFB0 00                       .
        brk                                     ; AFB1 00                       .
        brk                                     ; AFB2 00                       .
        brk                                     ; AFB3 00                       .
        brk                                     ; AFB4 00                       .
        brk                                     ; AFB5 00                       .
        brk                                     ; AFB6 00                       .
        brk                                     ; AFB7 00                       .
        brk                                     ; AFB8 00                       .
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
        brk                                     ; AFC4 00                       .
        brk                                     ; AFC5 00                       .
        brk                                     ; AFC6 00                       .
        brk                                     ; AFC7 00                       .
        brk                                     ; AFC8 00                       .
        brk                                     ; AFC9 00                       .
        brk                                     ; AFCA 00                       .
        brk                                     ; AFCB 00                       .
        brk                                     ; AFCC 00                       .
        brk                                     ; AFCD 00                       .
        brk                                     ; AFCE 00                       .
        brk                                     ; AFCF 00                       .
        brk                                     ; AFD0 00                       .
        brk                                     ; AFD1 00                       .
        brk                                     ; AFD2 00                       .
        brk                                     ; AFD3 00                       .
        brk                                     ; AFD4 00                       .
        brk                                     ; AFD5 00                       .
        brk                                     ; AFD6 00                       .
        brk                                     ; AFD7 00                       .
        brk                                     ; AFD8 00                       .
        brk                                     ; AFD9 00                       .
        brk                                     ; AFDA 00                       .
        brk                                     ; AFDB 00                       .
        brk                                     ; AFDC 00                       .
        brk                                     ; AFDD 00                       .
        brk                                     ; AFDE 00                       .
        brk                                     ; AFDF 00                       .
        brk                                     ; AFE0 00                       .
        brk                                     ; AFE1 00                       .
        brk                                     ; AFE2 00                       .
        brk                                     ; AFE3 00                       .
        brk                                     ; AFE4 00                       .
        brk                                     ; AFE5 00                       .
        brk                                     ; AFE6 00                       .
        brk                                     ; AFE7 00                       .
        brk                                     ; AFE8 00                       .
        brk                                     ; AFE9 00                       .
        brk                                     ; AFEA 00                       .
        brk                                     ; AFEB 00                       .
        brk                                     ; AFEC 00                       .
        brk                                     ; AFED 00                       .
        brk                                     ; AFEE 00                       .
        brk                                     ; AFEF 00                       .
        brk                                     ; AFF0 00                       .
        brk                                     ; AFF1 00                       .
        brk                                     ; AFF2 00                       .
        brk                                     ; AFF3 00                       .
        brk                                     ; AFF4 00                       .
        brk                                     ; AFF5 00                       .
        brk                                     ; AFF6 00                       .
        brk                                     ; AFF7 00                       .
        brk                                     ; AFF8 00                       .
        brk                                     ; AFF9 00                       .
        brk                                     ; AFFA 00                       .
        brk                                     ; AFFB 00                       .
        brk                                     ; AFFC 00                       .
        brk                                     ; AFFD 00                       .
        brk                                     ; AFFE 00                       .
        brk                                     ; AFFF 00                       .
LB000:  brk                                     ; B000 00                       .
        .byte   $12                             ; B001 12                       .
        .byte   $14                             ; B002 14                       .
        brk                                     ; B003 00                       .
LB004:  ora     $31,x                           ; B004 15 31                    .1
        eor     ($71),y                         ; B006 51 71                    Qq
        .byte   $33                             ; B008 33                       3
        .byte   $AB                             ; B009 AB                       .
        and     $16                             ; B00A 25 16                    %.
        .byte   $57                             ; B00C 57                       W
        .byte   $5B                             ; B00D 5B                       [
        .byte   $5B                             ; B00E 5B                       [
        lsr     $43,x                           ; B00F 56 43                    VC
        ldy     $7325                           ; B011 AC 25 73                 .%s
        and     #$D8                            ; B014 29 D8                    ).
        adc     $731D,y                         ; B016 79 1D 73                 y.s
        eor     $45,x                           ; B019 55 45                    UE
        .byte   $37                             ; B01B 37                       7
        and     #$3B                            ; B01C 29 3B                    );
        eor     $181D,y                         ; B01E 59 1D 18                 Y..
        .byte   $1A                             ; B021 1A                       .
        .byte   $1C                             ; B022 1C                       .
        cmp     $77,x                           ; B023 D5 77                    .w
        .byte   $7B                             ; B025 7B                       {
        .byte   $7B                             ; B026 7B                       {
        ror     $D7,x                           ; B027 76 D7                    v.
        brk                                     ; B029 00                       .
        iny                                     ; B02A C8                       .
        .byte   $95                             ; B02B 95                       .
LB02C:  sta     $B5,x                           ; B02C 95 B5                    ..
        clv                                     ; B02E B8                       .
        clv                                     ; B02F B8                       .
        ldy     $97,x                           ; B030 B4 97                    ..
        lda     $9C9A                           ; B032 AD 9A 9C                 ...
        lda     $D1B6                           ; B035 AD B6 D1                 ...
        beq     LB02C                           ; B038 F0 F2                    ..
        .byte   $F4                             ; B03A F4                       .
        inc     $F8,x                           ; B03B F6 F8                    ..
        brk                                     ; B03D 00                       .
        .byte   $D3                             ; B03E D3                       .
LB03F:  cmp     ($D3),y                         ; B03F D1 D3                    ..
        brk                                     ; B041 00                       .
        .byte   $CF                             ; B042 CF                       .
        .byte   $77                             ; B043 77                       w
        ror     $5A,x                           ; B044 76 5A                    vZ
        lsr     $78,x                           ; B046 56 78                    Vx
        ora     LB4D2,x                         ; B048 1D D2 B4                 ...
        .byte   $BB                             ; B04B BB                       .
        tsx                                     ; B04C BA                       .
        .byte   $D3                             ; B04D D3                       .
        .byte   $79                             ; B04E 79                       y
        .byte   $10                             ; B04F 10                       .
LB050:  brk                                     ; B050 00                       .
        .byte   $5C                             ; B051 5C                       \
        bpl     LB072                           ; B052 10 1E                    ..
        brk                                     ; B054 00                       .
        bpl     LB0B2                           ; B055 10 5B                    .[
        brk                                     ; B057 00                       .
        eor     L1010,x                         ; B058 5D 10 10                 ]..
        bpl     LB06D                           ; B05B 10 10                    ..
        .byte   $1F                             ; B05D 1F                       .
        bpl     LB03F                           ; B05E 10 DF                    ..
        eor     L1010,x                         ; B060 5D 10 10                 ]..
        bpl     LB0D2                           ; B063 10 6D                    .m
        bpl     LB096                           ; B065 10 2F                    ./
        brk                                     ; B067 00                       .
        brk                                     ; B068 00                       .
        .byte   $5F                             ; B069 5F                       _
        .byte   $8F                             ; B06A 8F                       .
        brk                                     ; B06B 00                       .
        brk                                     ; B06C 00                       .
LB06D:  .byte   $8F                             ; B06D 8F                       .
        .byte   $8F                             ; B06E 8F                       .
        brk                                     ; B06F 00                       .
        brk                                     ; B070 00                       .
        brk                                     ; B071 00                       .
LB072:  .byte   $5F                             ; B072 5F                       _
        bpl     LB004                           ; B073 10 8F                    ..
        brk                                     ; B075 00                       .
        brk                                     ; B076 00                       .
        asl     $187D,x                         ; B077 1E 7D 18                 .}.
        brk                                     ; B07A 00                       .
        brk                                     ; B07B 00                       .
        brk                                     ; B07C 00                       .
        sbc     $1CFF,x                         ; B07D FD FF 1C                 ...
        .byte   $FB                             ; B080 FB                       .
        cmp     a:L0000,x                       ; B081 DD 00 00                 ...
        brk                                     ; B084 00                       .
        brk                                     ; B085 00                       .
        brk                                     ; B086 00                       .
        brk                                     ; B087 00                       .
        .byte   $CF                             ; B088 CF                       .
        .byte   $57                             ; B089 57                       W
        lsr     $29,x                           ; B08A 56 29                    V)
        ora     $7677,x                         ; B08C 1D 77 76                 .wv
        and     #$1D                            ; B08F 29 1D                    ).
        bpl     LB050                           ; B091 10 BD                    ..
        brk                                     ; B093 00                       .
        sta     ($93),y                         ; B094 91 93                    ..
LB096:  brk                                     ; B096 00                       .
        brk                                     ; B097 00                       .
        bpl     LB0AA                           ; B098 10 10                    ..
        brk                                     ; B09A 00                       .
        brk                                     ; B09B 00                       .
        lda     ($B3),y                         ; B09C B1 B3                    ..
        brk                                     ; B09E 00                       .
        brk                                     ; B09F 00                       .
        brk                                     ; B0A0 00                       .
        brk                                     ; B0A1 00                       .
        brk                                     ; B0A2 00                       .
        brk                                     ; B0A3 00                       .
        brk                                     ; B0A4 00                       .
        brk                                     ; B0A5 00                       .
        brk                                     ; B0A6 00                       .
        brk                                     ; B0A7 00                       .
        brk                                     ; B0A8 00                       .
        brk                                     ; B0A9 00                       .
LB0AA:  brk                                     ; B0AA 00                       .
        brk                                     ; B0AB 00                       .
        brk                                     ; B0AC 00                       .
        brk                                     ; B0AD 00                       .
        brk                                     ; B0AE 00                       .
        brk                                     ; B0AF 00                       .
        brk                                     ; B0B0 00                       .
        brk                                     ; B0B1 00                       .
LB0B2:  brk                                     ; B0B2 00                       .
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
        brk                                     ; B0C3 00                       .
        brk                                     ; B0C4 00                       .
        brk                                     ; B0C5 00                       .
        brk                                     ; B0C6 00                       .
        brk                                     ; B0C7 00                       .
        brk                                     ; B0C8 00                       .
        brk                                     ; B0C9 00                       .
        brk                                     ; B0CA 00                       .
        brk                                     ; B0CB 00                       .
        brk                                     ; B0CC 00                       .
        brk                                     ; B0CD 00                       .
        brk                                     ; B0CE 00                       .
        brk                                     ; B0CF 00                       .
        brk                                     ; B0D0 00                       .
        brk                                     ; B0D1 00                       .
LB0D2:  brk                                     ; B0D2 00                       .
        brk                                     ; B0D3 00                       .
        brk                                     ; B0D4 00                       .
        brk                                     ; B0D5 00                       .
        brk                                     ; B0D6 00                       .
        brk                                     ; B0D7 00                       .
        brk                                     ; B0D8 00                       .
        brk                                     ; B0D9 00                       .
        brk                                     ; B0DA 00                       .
        brk                                     ; B0DB 00                       .
        brk                                     ; B0DC 00                       .
        brk                                     ; B0DD 00                       .
        brk                                     ; B0DE 00                       .
        brk                                     ; B0DF 00                       .
        brk                                     ; B0E0 00                       .
        brk                                     ; B0E1 00                       .
        brk                                     ; B0E2 00                       .
        brk                                     ; B0E3 00                       .
        brk                                     ; B0E4 00                       .
        brk                                     ; B0E5 00                       .
        brk                                     ; B0E6 00                       .
        brk                                     ; B0E7 00                       .
        brk                                     ; B0E8 00                       .
        brk                                     ; B0E9 00                       .
        brk                                     ; B0EA 00                       .
        brk                                     ; B0EB 00                       .
        brk                                     ; B0EC 00                       .
        brk                                     ; B0ED 00                       .
        brk                                     ; B0EE 00                       .
        brk                                     ; B0EF 00                       .
        brk                                     ; B0F0 00                       .
        brk                                     ; B0F1 00                       .
        brk                                     ; B0F2 00                       .
        brk                                     ; B0F3 00                       .
        brk                                     ; B0F4 00                       .
        brk                                     ; B0F5 00                       .
        brk                                     ; B0F6 00                       .
        brk                                     ; B0F7 00                       .
        brk                                     ; B0F8 00                       .
        brk                                     ; B0F9 00                       .
        brk                                     ; B0FA 00                       .
        brk                                     ; B0FB 00                       .
        brk                                     ; B0FC 00                       .
        brk                                     ; B0FD 00                       .
        brk                                     ; B0FE 00                       .
        brk                                     ; B0FF 00                       .
        brk                                     ; B100 00                       .
        brk                                     ; B101 00                       .
        brk                                     ; B102 00                       .
        brk                                     ; B103 00                       .
        brk                                     ; B104 00                       .
        .byte   $12                             ; B105 12                       .
        .byte   $12                             ; B106 12                       .
        .byte   $12                             ; B107 12                       .
        .byte   $12                             ; B108 12                       .
        .byte   $12                             ; B109 12                       .
        .byte   $12                             ; B10A 12                       .
        .byte   $12                             ; B10B 12                       .
        .byte   $12                             ; B10C 12                       .
        ora     ($10),y                         ; B10D 11 10                    ..
        .byte   $12                             ; B10F 12                       .
        .byte   $12                             ; B110 12                       .
        .byte   $12                             ; B111 12                       .
        .byte   $12                             ; B112 12                       .
        .byte   $12                             ; B113 12                       .
        .byte   $12                             ; B114 12                       .
        bpl     LB128                           ; B115 10 11                    ..
        .byte   $12                             ; B117 12                       .
        .byte   $12                             ; B118 12                       .
        .byte   $12                             ; B119 12                       .
        .byte   $12                             ; B11A 12                       .
        and     ($12),y                         ; B11B 31 12                    1.
        bpl     LB130                           ; B11D 10 11                    ..
        .byte   $12                             ; B11F 12                       .
        ora     ($11),y                         ; B120 11 11                    ..
        ora     ($11),y                         ; B122 11 11                    ..
        .byte   $12                             ; B124 12                       .
        ora     ($10),y                         ; B125 11 10                    ..
        .byte   $12                             ; B127 12                       .
LB128:  beq     LB12A                           ; B128 F0 00                    ..
LB12A:  brk                                     ; B12A 00                       .
        ora     ($11),y                         ; B12B 11 11                    ..
        ora     ($11),y                         ; B12D 11 11                    ..
        .byte   $11                             ; B12F 11                       .
LB130:  ora     ($01),y                         ; B130 11 01                    ..
        ora     ($10),y                         ; B132 11 10                    ..
        bpl     LB146                           ; B134 10 10                    ..
        ora     ($10,x)                         ; B136 01 10                    ..
        ora     ($11,x)                         ; B138 01 11                    ..
        ora     ($11),y                         ; B13A 11 11                    ..
        ora     ($01),y                         ; B13C 11 01                    ..
        bpl     LB150                           ; B13E 10 10                    ..
        bpl     LB143                           ; B140 10 01                    ..
        .byte   $20                             ; B142 20                        
LB143:  .byte   $12                             ; B143 12                       .
        .byte   $12                             ; B144 12                       .
        .byte   $10                             ; B145 10                       .
LB146:  bpl     LB158                           ; B146 10 10                    ..
        bpl     LB15A                           ; B148 10 10                    ..
        ora     ($10),y                         ; B14A 11 10                    ..
        bpl     LB15E                           ; B14C 10 10                    ..
        bpl     LB1B3                           ; B14E 10 63                    .c
LB150:  ora     ($63,x)                         ; B150 01 63                    .c
        .byte   $63                             ; B152 63                       c
        .byte   $63                             ; B153 63                       c
        .byte   $63                             ; B154 63                       c
        bpl     LB167                           ; B155 10 10                    ..
        brk                                     ; B157 00                       .
LB158:  .byte   $63                             ; B158 63                       c
        .byte   $63                             ; B159 63                       c
LB15A:  .byte   $63                             ; B15A 63                       c
        .byte   $63                             ; B15B 63                       c
        .byte   $63                             ; B15C 63                       c
        .byte   $63                             ; B15D 63                       c
LB15E:  .byte   $63                             ; B15E 63                       c
        brk                                     ; B15F 00                       .
        .byte   $63                             ; B160 63                       c
        .byte   $63                             ; B161 63                       c
        .byte   $63                             ; B162 63                       c
        .byte   $63                             ; B163 63                       c
        .byte   $63                             ; B164 63                       c
        .byte   $63                             ; B165 63                       c
        .byte   $63                             ; B166 63                       c
LB167:  .byte   $63                             ; B167 63                       c
        .byte   $63                             ; B168 63                       c
        .byte   $63                             ; B169 63                       c
        .byte   $63                             ; B16A 63                       c
        .byte   $63                             ; B16B 63                       c
        .byte   $63                             ; B16C 63                       c
        .byte   $63                             ; B16D 63                       c
        .byte   $63                             ; B16E 63                       c
        .byte   $63                             ; B16F 63                       c
        .byte   $63                             ; B170 63                       c
        .byte   $63                             ; B171 63                       c
        .byte   $63                             ; B172 63                       c
        .byte   $63                             ; B173 63                       c
        .byte   $63                             ; B174 63                       c
        .byte   $63                             ; B175 63                       c
        .byte   $63                             ; B176 63                       c
        .byte   $63                             ; B177 63                       c
        .byte   $63                             ; B178 63                       c
        .byte   $12                             ; B179 12                       .
        .byte   $63                             ; B17A 63                       c
        .byte   $63                             ; B17B 63                       c
        .byte   $63                             ; B17C 63                       c
        .byte   $12                             ; B17D 12                       .
        .byte   $12                             ; B17E 12                       .
        .byte   $12                             ; B17F 12                       .
        .byte   $12                             ; B180 12                       .
        .byte   $12                             ; B181 12                       .
        brk                                     ; B182 00                       .
        brk                                     ; B183 00                       .
        brk                                     ; B184 00                       .
        brk                                     ; B185 00                       .
        brk                                     ; B186 00                       .
        brk                                     ; B187 00                       .
        rti                                     ; B188 40                       @

; ----------------------------------------------------------------------------
        bpl     LB19B                           ; B189 10 10                    ..
        bpl     LB19D                           ; B18B 10 10                    ..
        bpl     LB19F                           ; B18D 10 10                    ..
        bpl     LB1A1                           ; B18F 10 10                    ..
        bpl     LB1A3                           ; B191 10 10                    ..
        brk                                     ; B193 00                       .
        bpl     LB1A6                           ; B194 10 10                    ..
        bpl     LB1A8                           ; B196 10 10                    ..
        .byte   $12                             ; B198 12                       .
        bpl     LB19B                           ; B199 10 00                    ..
LB19B:  brk                                     ; B19B 00                       .
        .byte   $10                             ; B19C 10                       .
LB19D:  bpl     LB19F                           ; B19D 10 00                    ..
LB19F:  brk                                     ; B19F 00                       .
        brk                                     ; B1A0 00                       .
LB1A1:  brk                                     ; B1A1 00                       .
        brk                                     ; B1A2 00                       .
LB1A3:  brk                                     ; B1A3 00                       .
        brk                                     ; B1A4 00                       .
        brk                                     ; B1A5 00                       .
LB1A6:  brk                                     ; B1A6 00                       .
        brk                                     ; B1A7 00                       .
LB1A8:  brk                                     ; B1A8 00                       .
        brk                                     ; B1A9 00                       .
        brk                                     ; B1AA 00                       .
        brk                                     ; B1AB 00                       .
        brk                                     ; B1AC 00                       .
        brk                                     ; B1AD 00                       .
        brk                                     ; B1AE 00                       .
        brk                                     ; B1AF 00                       .
        brk                                     ; B1B0 00                       .
        brk                                     ; B1B1 00                       .
        brk                                     ; B1B2 00                       .
LB1B3:  brk                                     ; B1B3 00                       .
        brk                                     ; B1B4 00                       .
        brk                                     ; B1B5 00                       .
        brk                                     ; B1B6 00                       .
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
        brk                                     ; B1C3 00                       .
        brk                                     ; B1C4 00                       .
        brk                                     ; B1C5 00                       .
        brk                                     ; B1C6 00                       .
        brk                                     ; B1C7 00                       .
        brk                                     ; B1C8 00                       .
        brk                                     ; B1C9 00                       .
        brk                                     ; B1CA 00                       .
        brk                                     ; B1CB 00                       .
        brk                                     ; B1CC 00                       .
        brk                                     ; B1CD 00                       .
        brk                                     ; B1CE 00                       .
        brk                                     ; B1CF 00                       .
        brk                                     ; B1D0 00                       .
        brk                                     ; B1D1 00                       .
        brk                                     ; B1D2 00                       .
        brk                                     ; B1D3 00                       .
        brk                                     ; B1D4 00                       .
        brk                                     ; B1D5 00                       .
        brk                                     ; B1D6 00                       .
        brk                                     ; B1D7 00                       .
        brk                                     ; B1D8 00                       .
        brk                                     ; B1D9 00                       .
        brk                                     ; B1DA 00                       .
        brk                                     ; B1DB 00                       .
        brk                                     ; B1DC 00                       .
        brk                                     ; B1DD 00                       .
        brk                                     ; B1DE 00                       .
        brk                                     ; B1DF 00                       .
        brk                                     ; B1E0 00                       .
        brk                                     ; B1E1 00                       .
        brk                                     ; B1E2 00                       .
        brk                                     ; B1E3 00                       .
        brk                                     ; B1E4 00                       .
        brk                                     ; B1E5 00                       .
        brk                                     ; B1E6 00                       .
        brk                                     ; B1E7 00                       .
        brk                                     ; B1E8 00                       .
        brk                                     ; B1E9 00                       .
        brk                                     ; B1EA 00                       .
        brk                                     ; B1EB 00                       .
        brk                                     ; B1EC 00                       .
        brk                                     ; B1ED 00                       .
        brk                                     ; B1EE 00                       .
        brk                                     ; B1EF 00                       .
        brk                                     ; B1F0 00                       .
        brk                                     ; B1F1 00                       .
        brk                                     ; B1F2 00                       .
        brk                                     ; B1F3 00                       .
        brk                                     ; B1F4 00                       .
        brk                                     ; B1F5 00                       .
        brk                                     ; B1F6 00                       .
        brk                                     ; B1F7 00                       .
        brk                                     ; B1F8 00                       .
        brk                                     ; B1F9 00                       .
        brk                                     ; B1FA 00                       .
        brk                                     ; B1FB 00                       .
        brk                                     ; B1FC 00                       .
        brk                                     ; B1FD 00                       .
        brk                                     ; B1FE 00                       .
        brk                                     ; B1FF 00                       .
        .byte   $4F                             ; B200 4F                       O
        .byte   $4F                             ; B201 4F                       O
        .byte   $4F                             ; B202 4F                       O
        .byte   $4F                             ; B203 4F                       O
        .byte   $4F                             ; B204 4F                       O
        .byte   $4F                             ; B205 4F                       O
        .byte   $4F                             ; B206 4F                       O
        ror     $6F6E                           ; B207 6E 6E 6F                 nno
        .byte   $6F                             ; B20A 6F                       o
        brk                                     ; B20B 00                       .
        .byte   $4F                             ; B20C 4F                       O
        .byte   $4F                             ; B20D 4F                       O
        .byte   $74                             ; B20E 74                       t
        adc     $4F,x                           ; B20F 75 4F                    uO
        .byte   $4F                             ; B211 4F                       O
        .byte   $72                             ; B212 72                       r
        .byte   $4F                             ; B213 4F                       O
        .byte   $4F                             ; B214 4F                       O
        .byte   $4F                             ; B215 4F                       O
        .byte   $4F                             ; B216 4F                       O
        lsr     $6A4F,x                         ; B217 5E 4F 6A                 ^Oj
        .byte   $74                             ; B21A 74                       t
        .byte   $7C                             ; B21B 7C                       |
        .byte   $6B                             ; B21C 6B                       k
        ror     L0000,x                         ; B21D 76 00                    v.
        brk                                     ; B21F 00                       .
        brk                                     ; B220 00                       .
        brk                                     ; B221 00                       .
        brk                                     ; B222 00                       .
        brk                                     ; B223 00                       .
        .byte   $7C                             ; B224 7C                       |
        brk                                     ; B225 00                       .
        brk                                     ; B226 00                       .
        brk                                     ; B227 00                       .
        bvs     LB29B                           ; B228 70 71                    pq
        brk                                     ; B22A 00                       .
        brk                                     ; B22B 00                       .
        .byte   $72                             ; B22C 72                       r
        .byte   $4F                             ; B22D 4F                       O
        pla                                     ; B22E 68                       h
        .byte   $72                             ; B22F 72                       r
        .byte   $4F                             ; B230 4F                       O
        .byte   $4F                             ; B231 4F                       O
        .byte   $73                             ; B232 73                       s
        .byte   $74                             ; B233 74                       t
        .byte   $4F                             ; B234 4F                       O
        ror     $7675                           ; B235 6E 75 76                 nuv
        ror     L0000,x                         ; B238 76 00                    v.
        brk                                     ; B23A 00                       .
        brk                                     ; B23B 00                       .
        brk                                     ; B23C 00                       .
        .byte   $7A                             ; B23D 7A                       z
        brk                                     ; B23E 00                       .
        brk                                     ; B23F 00                       .
        .byte   $7B                             ; B240 7B                       {
        .byte   $7C                             ; B241 7C                       |
        brk                                     ; B242 00                       .
        brk                                     ; B243 00                       .
        ora     ($02,x)                         ; B244 01 02                    ..
        brk                                     ; B246 00                       .
        brk                                     ; B247 00                       .
        .byte   $03                             ; B248 03                       .
        brk                                     ; B249 00                       .
        brk                                     ; B24A 00                       .
        brk                                     ; B24B 00                       .
        brk                                     ; B24C 00                       .
        brk                                     ; B24D 00                       .
        ora     ($04,x)                         ; B24E 01 04                    ..
        .byte   $52                             ; B250 52                       R
        .byte   $53                             ; B251 53                       S
        .byte   $5A                             ; B252 5A                       Z
        .byte   $5B                             ; B253 5B                       [
        .byte   $54                             ; B254 54                       T
        brk                                     ; B255 00                       .
LB256:  .byte   $5C                             ; B256 5C                       \
        eor     $0401,x                         ; B257 5D 01 04                 ]..
        brk                                     ; B25A 00                       .
        brk                                     ; B25B 00                       .
        sta     $9999,y                         ; B25C 99 99 99                 ...
        sta     $0D56,y                         ; B25F 99 56 0D                 .V.
        eor     $15,x                           ; B262 55 15                    U.
        asl     $940D                           ; B264 0E 0D 94                 ...
        sta     L000E,x                         ; B267 95 0E                    ..
        asl     $1515                           ; B269 0E 15 15                 ...
        ora     $150D                           ; B26C 0D 0D 15                 ...
        ora     $0D,x                           ; B26F 15 0D                    ..
        .byte   $0F                             ; B271 0F                       .
        ora     $17,x                           ; B272 15 17                    ..
        .byte   $4F                             ; B274 4F                       O
        eor     $4F,x                           ; B275 55 4F                    UO
        .byte   $4F                             ; B277 4F                       O
        .byte   $9C                             ; B278 9C                       .
        sta     $1E16,x                         ; B279 9D 16 1E                 ...
        ora     $261D,x                         ; B27C 1D 1D 26                 ..&
        rol     $1D                             ; B27F 26 1D                    &.
        ora     $2526,x                         ; B281 1D 26 25                 .&%
        ora     $261F,x                         ; B284 1D 1F 26                 ..&
        .byte   $27                             ; B287 27                       '
        rol     a                               ; B288 2A                       *
        brk                                     ; B289 00                       .
        rol     a                               ; B28A 2A                       *
        brk                                     ; B28B 00                       .
        brk                                     ; B28C 00                       .
        rol     a                               ; B28D 2A                       *
        brk                                     ; B28E 00                       .
        rol     a                               ; B28F 2A                       *
        ora     $08                             ; B290 05 08                    ..
        asl     $10                             ; B292 06 10                    ..
        ora     #$0A                            ; B294 09 0A                    ..
        ora     ($12),y                         ; B296 11 12                    ..
        php                                     ; B298 08                       .
        ora     #$10                            ; B299 09 10                    ..
LB29B:  ora     ($0A),y                         ; B29B 11 0A                    ..
        php                                     ; B29D 08                       .
        .byte   $12                             ; B29E 12                       .
        bpl     LB2AA                           ; B29F 10 09                    ..
        ora     $11                             ; B2A1 05 11                    ..
        asl     $07                             ; B2A3 06 07                    ..
        clc                                     ; B2A5 18                       .
        brk                                     ; B2A6 00                       .
        brk                                     ; B2A7 00                       .
        .byte   $19                             ; B2A8 19                       .
        .byte   $1A                             ; B2A9 1A                       .
LB2AA:  brk                                     ; B2AA 00                       .
        brk                                     ; B2AB 00                       .
        .byte   $13                             ; B2AC 13                       .
        ora     L0000,y                         ; B2AD 19 00 00                 ...
        .byte   $1A                             ; B2B0 1A                       .
        .byte   $13                             ; B2B1 13                       .
        brk                                     ; B2B2 00                       .
        brk                                     ; B2B3 00                       .
        .byte   $0B                             ; B2B4 0B                       .
        .byte   $07                             ; B2B5 07                       .
        brk                                     ; B2B6 00                       .
        brk                                     ; B2B7 00                       .
        brk                                     ; B2B8 00                       .
        brk                                     ; B2B9 00                       .
        brk                                     ; B2BA 00                       .
        ora     (L0000,x)                       ; B2BB 01 00                    ..
        brk                                     ; B2BD 00                       .
        .byte   $02                             ; B2BE 02                       .
        .byte   $03                             ; B2BF 03                       .
        brk                                     ; B2C0 00                       .
        brk                                     ; B2C1 00                       .
        .byte   $2B                             ; B2C2 2B                       +
        bit     a:L0000                         ; B2C3 2C 00 00                 ,..
        and     a:$2E                           ; B2C6 2D 2E 00                 -..
        brk                                     ; B2C9 00                       .
        .byte   $2F                             ; B2CA 2F                       /
        bmi     LB256                           ; B2CB 30 89                    0.
        ora     $158B                           ; B2CD 0D 8B 15                 ...
        asl     $150D                           ; B2D0 0E 0D 15                 ...
        ora     $0D,x                           ; B2D3 15 0D                    ..
        txa                                     ; B2D5 8A                       .
        ora     $8C,x                           ; B2D6 15 8C                    ..
        and     ($32),y                         ; B2D8 31 32                    12
        sec                                     ; B2DA 38                       8
        and     $3433,y                         ; B2DB 39 33 34                 934
        .byte   $3A                             ; B2DE 3A                       :
        .byte   $3B                             ; B2DF 3B                       ;
        and     $36,x                           ; B2E0 35 36                    56
        .byte   $3C                             ; B2E2 3C                       <
        and     $1D8F,x                         ; B2E3 3D 8F 1D                 =..
        sta     $1D25                           ; B2E6 8D 25 1D                 .%.
        bcc     LB311                           ; B2E9 90 26                    .&
        stx     $3E37                           ; B2EB 8E 37 3E                 .7>
        .byte   $3F                             ; B2EE 3F                       ?
        rti                                     ; B2EF 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; B2F0 00                       .
        bvs     LB2F3                           ; B2F1 70 00                    p.
LB2F3:  brk                                     ; B2F3 00                       .
        adc     ($72),y                         ; B2F4 71 72                    qr
        brk                                     ; B2F6 00                       .
        .byte   $7A                             ; B2F7 7A                       z
        .byte   $4F                             ; B2F8 4F                       O
        .byte   $4F                             ; B2F9 4F                       O
        .byte   $72                             ; B2FA 72                       r
        .byte   $73                             ; B2FB 73                       s
        .byte   $7A                             ; B2FC 7A                       z
        .byte   $7B                             ; B2FD 7B                       {
        brk                                     ; B2FE 00                       .
        brk                                     ; B2FF 00                       .
        brk                                     ; B300 00                       .
        and     (L0000),y                       ; B301 31 00                    1.
        sec                                     ; B303 38                       8
        .byte   $32                             ; B304 32                       2
        .byte   $33                             ; B305 33                       3
        and     $343A,y                         ; B306 39 3A 34                 9:4
        and     $3B,x                           ; B309 35 3B                    5;
        .byte   $3C                             ; B30B 3C                       <
        rol     L0000,x                         ; B30C 36 00                    6.
        and     a:L0000,x                       ; B30E 3D 00 00                 =..
LB311:  .byte   $37                             ; B311 37                       7
        brk                                     ; B312 00                       .
        .byte   $3F                             ; B313 3F                       ?
        rol     $4000,x                         ; B314 3E 00 40                 >.@
        brk                                     ; B317 00                       .
        brk                                     ; B318 00                       .
        brk                                     ; B319 00                       .
        eor     ($52),y                         ; B31A 51 52                    QR
        brk                                     ; B31C 00                       .
        brk                                     ; B31D 00                       .
        .byte   $53                             ; B31E 53                       S
        .byte   $54                             ; B31F 54                       T
        brk                                     ; B320 00                       .
        rts                                     ; B321 60                       `

; ----------------------------------------------------------------------------
        cli                                     ; B322 58                       X
        .byte   $5A                             ; B323 5A                       Z
        .byte   $53                             ; B324 53                       S
        .byte   $3F                             ; B325 3F                       ?
        .byte   $4F                             ; B326 4F                       O
        .byte   $5C                             ; B327 5C                       \
        rti                                     ; B328 40                       @

; ----------------------------------------------------------------------------
        cli                                     ; B329 58                       X
        rti                                     ; B32A 40                       @

; ----------------------------------------------------------------------------
        .byte   $4F                             ; B32B 4F                       O
        eor     $4F5A,y                         ; B32C 59 5A 4F                 YZO
        .byte   $4F                             ; B32F 4F                       O
        .byte   $5B                             ; B330 5B                       [
        .byte   $5C                             ; B331 5C                       \
        .byte   $4F                             ; B332 4F                       O
        .byte   $4F                             ; B333 4F                       O
        eor     $6500,x                         ; B334 5D 00 65                 ].e
        ror     L0000                           ; B337 66 00                    f.
        cli                                     ; B339 58                       X
        rts                                     ; B33A 60                       `

; ----------------------------------------------------------------------------
        adc     (L0000,x)                       ; B33B 61 00                    a.
        .byte   $42                             ; B33D 42                       B
        brk                                     ; B33E 00                       .
        .byte   $42                             ; B33F 42                       B
        .byte   $2B                             ; B340 2B                       +
        bit     $3100                           ; B341 2C 00 31                 ,.1
        and     $322E                           ; B344 2D 2E 32                 -.2
        .byte   $33                             ; B347 33                       3
        brk                                     ; B348 00                       .
        sec                                     ; B349 38                       8
        brk                                     ; B34A 00                       .
        brk                                     ; B34B 00                       .
        and     $3A,y                           ; B34C 39 3A 00                 9:.
        .byte   $37                             ; B34F 37                       7
        eor     ($52),y                         ; B350 51 52                    QR
        eor     $5A5A,y                         ; B352 59 5A 5A                 YZZ
        .byte   $5A                             ; B355 5A                       Z
        .byte   $4F                             ; B356 4F                       O
        .byte   $4F                             ; B357 4F                       O
        .byte   $42                             ; B358 42                       B
        brk                                     ; B359 00                       .
        .byte   $42                             ; B35A 42                       B
        brk                                     ; B35B 00                       .
        brk                                     ; B35C 00                       .
        cli                                     ; B35D 58                       X
        sei                                     ; B35E 78                       x
        adc     ($61,x)                         ; B35F 61 61                    aa
        .byte   $4F                             ; B361 4F                       O
        .byte   $4F                             ; B362 4F                       O
        .byte   $4F                             ; B363 4F                       O
        brk                                     ; B364 00                       .
        dey                                     ; B365 88                       .
        brk                                     ; B366 00                       .
        .byte   $42                             ; B367 42                       B
        jsr     L0021                           ; B368 20 21 00                  !.
        brk                                     ; B36B 00                       .
        .byte   $22                             ; B36C 22                       "
        brk                                     ; B36D 00                       .
        brk                                     ; B36E 00                       .
        brk                                     ; B36F 00                       .
        pla                                     ; B370 68                       h
        adc     #$00                            ; B371 69 00                    i.
        pla                                     ; B373 68                       h
        .byte   $4F                             ; B374 4F                       O
        .byte   $4F                             ; B375 4F                       O
        adc     #$4F                            ; B376 69 4F                    iO
        ora     ($03,x)                         ; B378 01 03                    ..
        brk                                     ; B37A 00                       .
        brk                                     ; B37B 00                       .
        and     ($22,x)                         ; B37C 21 22                    !"
        brk                                     ; B37E 00                       .
        brk                                     ; B37F 00                       .
        brk                                     ; B380 00                       .
        jsr     L0000                           ; B381 20 00 00                  ..
        and     (L0021,x)                       ; B384 21 21                    !!
        brk                                     ; B386 00                       .
        brk                                     ; B387 00                       .
        brk                                     ; B388 00                       .
        brk                                     ; B389 00                       .
        ror     $67                             ; B38A 66 67                    fg
        brk                                     ; B38C 00                       .
        adc     L0000,y                         ; B38D 79 00 00                 y..
        adc     $807E,x                         ; B390 7D 7E 80                 }~.
        sta     ($7F,x)                         ; B393 81 7F                    ..
        brk                                     ; B395 00                       .
        brk                                     ; B396 00                       .
        brk                                     ; B397 00                       .
        brk                                     ; B398 00                       .
        brk                                     ; B399 00                       .
        jsr     L0021                           ; B39A 20 21 00                  !.
        brk                                     ; B39D 00                       .
        .byte   $22                             ; B39E 22                       "
        dey                                     ; B39F 88                       .
        .byte   $4F                             ; B3A0 4F                       O
        .byte   $77                             ; B3A1 77                       w
        .byte   $4F                             ; B3A2 4F                       O
        .byte   $5B                             ; B3A3 5B                       [
        .byte   $4F                             ; B3A4 4F                       O
        adc     $766B                           ; B3A5 6D 6B 76                 mkv
        .byte   $67                             ; B3A8 67                       g
        brk                                     ; B3A9 00                       .
        .byte   $77                             ; B3AA 77                       w
        .byte   $54                             ; B3AB 54                       T
        eor     $6D00,x                         ; B3AC 5D 00 6D                 ].m
        brk                                     ; B3AF 00                       .
        ror     a                               ; B3B0 6A                       j
        .byte   $6B                             ; B3B1 6B                       k
        .byte   $7C                             ; B3B2 7C                       |
        brk                                     ; B3B3 00                       .
        brk                                     ; B3B4 00                       .
        brk                                     ; B3B5 00                       .
        dey                                     ; B3B6 88                       .
        jsr     L0000                           ; B3B7 20 00 00                  ..
        and     (L0021,x)                       ; B3BA 21 21                    !!
        jsr     L2122                           ; B3BC 20 22 21                  "!
        .byte   $22                             ; B3BF 22                       "
        .byte   $6F                             ; B3C0 6F                       o
        brk                                     ; B3C1 00                       .
        brk                                     ; B3C2 00                       .
        brk                                     ; B3C3 00                       .
        pla                                     ; B3C4 68                       h
        adc     #$00                            ; B3C5 69 00                    i.
        .byte   $7A                             ; B3C7 7A                       z
        .byte   $4F                             ; B3C8 4F                       O
        .byte   $74                             ; B3C9 74                       t
        .byte   $7B                             ; B3CA 7B                       {
        .byte   $7C                             ; B3CB 7C                       |
        brk                                     ; B3CC 00                       .
        .byte   $7A                             ; B3CD 7A                       z
        jsr     L7B21                           ; B3CE 20 21 7B                  !{
        .byte   $7C                             ; B3D1 7C                       |
        and     ($22,x)                         ; B3D2 21 22                    !"
        .byte   $0C                             ; B3D4 0C                       .
        ora     $1514                           ; B3D5 0D 14 15                 ...
        .byte   $1C                             ; B3D8 1C                       .
        ora     $151C,x                         ; B3D9 1D 1C 15                 ...
        ora     $151D,x                         ; B3DC 1D 1D 15                 ...
        ora     $1D,x                           ; B3DF 15 1D                    ..
        .byte   $27                             ; B3E1 27                       '
        ora     $15,x                           ; B3E2 15 15                    ..
        .byte   $1C                             ; B3E4 1C                       .
        ora     $2524,x                         ; B3E5 1D 24 25                 .$%
        ora     $251D,x                         ; B3E8 1D 1D 25                 ..%
        rol     $4F                             ; B3EB 26 4F                    &O
        .byte   $4F                             ; B3ED 4F                       O
        .byte   $4F                             ; B3EE 4F                       O
        .byte   $74                             ; B3EF 74                       t
        ror     $7C6F                           ; B3F0 6E 6F 7C                 no|
        brk                                     ; B3F3 00                       .
        .byte   $4F                             ; B3F4 4F                       O
        .byte   $4F                             ; B3F5 4F                       O
        adc     ($72),y                         ; B3F6 71 72                    qr
        .byte   $4F                             ; B3F8 4F                       O
        .byte   $4F                             ; B3F9 4F                       O
        .byte   $73                             ; B3FA 73                       s
        .byte   $4F                             ; B3FB 4F                       O
        adc     $76,x                           ; B3FC 75 76                    uv
        brk                                     ; B3FE 00                       .
        brk                                     ; B3FF 00                       .
        brk                                     ; B400 00                       .
        pla                                     ; B401 68                       h
        brk                                     ; B402 00                       .
        brk                                     ; B403 00                       .
        adc     #$4F                            ; B404 69 4F                    iO
        .byte   $7A                             ; B406 7A                       z
        .byte   $7B                             ; B407 7B                       {
        .byte   $74                             ; B408 74                       t
        adc     $7C,x                           ; B409 75 7C                    u|
        brk                                     ; B40B 00                       .
        .byte   $0C                             ; B40C 0C                       .
        .byte   $0F                             ; B40D 0F                       .
        bit     $27                             ; B40E 24 27                    $'
        .byte   $0C                             ; B410 0C                       .
        ora     $1E24                           ; B411 0D 24 1E                 .$.
        asl     $160D                           ; B414 0E 0D 16                 ...
        asl     a:$0F,x                         ; B417 1E 0F 00                 ...
        .byte   $27                             ; B41A 27                       '
        brk                                     ; B41B 00                       .
        .byte   $0C                             ; B41C 0C                       .
        .byte   $0F                             ; B41D 0F                       .
        bit     $17                             ; B41E 24 17                    $.
        ora     $150E                           ; B420 0D 0E 15                 ...
        ora     $0D,x                           ; B423 15 0D                    ..
        .byte   $1F                             ; B425 1F                       .
        ora     $1F,x                           ; B426 15 1F                    ..
        brk                                     ; B428 00                       .
        eor     ($58),y                         ; B429 51 58                    QX
        eor     $1F1D,y                         ; B42B 59 1D 1F                 Y..
        and     $27                             ; B42E 25 27                    %'
        .byte   $5A                             ; B430 5A                       Z
        .byte   $4F                             ; B431 4F                       O
        .byte   $4F                             ; B432 4F                       O
        .byte   $4F                             ; B433 4F                       O
        .byte   $42                             ; B434 42                       B
        brk                                     ; B435 00                       .
        jsr     L0021                           ; B436 20 21 00                  !.
        .byte   $42                             ; B439 42                       B
        brk                                     ; B43A 00                       .
        jsr     L0000                           ; B43B 20 00 00                  ..
        and     ($22,x)                         ; B43E 21 22                    !"
        .byte   $4F                             ; B440 4F                       O
        adc     $4F                             ; B441 65 4F                    eO
        .byte   $4F                             ; B443 4F                       O
        .byte   $53                             ; B444 53                       S
        .byte   $54                             ; B445 54                       T
        .byte   $5B                             ; B446 5B                       [
        .byte   $5C                             ; B447 5C                       \
        dey                                     ; B448 88                       .
        brk                                     ; B449 00                       .
        .byte   $42                             ; B44A 42                       B
        brk                                     ; B44B 00                       .
        .byte   $4F                             ; B44C 4F                       O
        .byte   $4F                             ; B44D 4F                       O
        .byte   $4F                             ; B44E 4F                       O
        .byte   $73                             ; B44F 73                       s
        brk                                     ; B450 00                       .
        brk                                     ; B451 00                       .
        .byte   $0C                             ; B452 0C                       .
        ora     a:L0000                         ; B453 0D 00 00                 ...
        asl     $140D                           ; B456 0E 0D 14                 ...
        ora     $24,x                           ; B459 15 24                    .$
        ora     $0C88,x                         ; B45B 1D 88 0C                 ...
        .byte   $42                             ; B45E 42                       B
        .byte   $14                             ; B45F 14                       .
        ora     $160E                           ; B460 0D 0E 16                 ...
        asl     $1514,x                         ; B463 1E 14 15                 ...
        .byte   $1C                             ; B466 1C                       .
        ora     $9594,x                         ; B467 1D 94 95                 ...
        .byte   $9C                             ; B46A 9C                       .
        sta     $1515,x                         ; B46B 9D 15 15                 ...
        ora     $421D,x                         ; B46E 1D 1D 42                 ..B
        bit     $42                             ; B471 24 42                    $B
        brk                                     ; B473 00                       .
        and     $26                             ; B474 25 26                    %&
        brk                                     ; B476 00                       .
        brk                                     ; B477 00                       .
        bit     $25                             ; B478 24 25                    $%
        brk                                     ; B47A 00                       .
        brk                                     ; B47B 00                       .
        rol     $25                             ; B47C 26 25                    &%
        brk                                     ; B47E 00                       .
        brk                                     ; B47F 00                       .
        rol     $26                             ; B480 26 26                    &&
        brk                                     ; B482 00                       .
        brk                                     ; B483 00                       .
        brk                                     ; B484 00                       .
        brk                                     ; B485 00                       .
        .byte   $43                             ; B486 43                       C
        asl     $1E43,x                         ; B487 1E 43 1E                 .C.
        brk                                     ; B48A 00                       .
        brk                                     ; B48B 00                       .
        .byte   $44                             ; B48C 44                       D
        brk                                     ; B48D 00                       .
        brk                                     ; B48E 00                       .
        brk                                     ; B48F 00                       .
        brk                                     ; B490 00                       .
        brk                                     ; B491 00                       .
        .byte   $22                             ; B492 22                       "
        asl     a:L0000,x                       ; B493 1E 00 00                 ...
        asl     $1E,x                           ; B496 16 1E                    ..
        brk                                     ; B498 00                       .
        brk                                     ; B499 00                       .
        asl     $150F                           ; B49A 0E 0F 15                 ...
        .byte   $17                             ; B49D 17                       .
        ora     a:$27,x                         ; B49E 1D 27 00                 .'.
        brk                                     ; B4A1 00                       .
        asl     a:L000E                         ; B4A2 0E 0E 00                 ...
        brk                                     ; B4A5 00                       .
        ora     $250E                           ; B4A6 0D 0E 25                 ..%
        and     L0000                           ; B4A9 25 00                    %.
        brk                                     ; B4AB 00                       .
        brk                                     ; B4AC 00                       .
        brk                                     ; B4AD 00                       .
        asl     $44,x                           ; B4AE 16 44                    .D
        .byte   $42                             ; B4B0 42                       B
        brk                                     ; B4B1 00                       .
        asl     $150F                           ; B4B2 0E 0F 15                 ...
        .byte   $17                             ; B4B5 17                       .
        ora     $251F,x                         ; B4B6 1D 1F 25                 ..%
        .byte   $27                             ; B4B9 27                       '
        brk                                     ; B4BA 00                       .
        brk                                     ; B4BB 00                       .
        .byte   $03                             ; B4BC 03                       .
        .byte   $42                             ; B4BD 42                       B
        brk                                     ; B4BE 00                       .
        .byte   $42                             ; B4BF 42                       B
        brk                                     ; B4C0 00                       .
        .byte   $42                             ; B4C1 42                       B
        brk                                     ; B4C2 00                       .
        brk                                     ; B4C3 00                       .
        ora     $1627,x                         ; B4C4 1D 27 16                 .'.
        asl     $0F0D,x                         ; B4C7 1E 0D 0F                 ...
        asl     $17,x                           ; B4CA 16 17                    ..
        rol     $27                             ; B4CC 26 27                    &'
        brk                                     ; B4CE 00                       .
        brk                                     ; B4CF 00                       .
        .byte   $0C                             ; B4D0 0C                       .
        .byte   $0D                             ; B4D1 0D                       .
LB4D2:  .byte   $14                             ; B4D2 14                       .
        asl     $1B1B,x                         ; B4D3 1E 1B 1B                 ...
        brk                                     ; B4D6 00                       .
        brk                                     ; B4D7 00                       .
        brk                                     ; B4D8 00                       .
        brk                                     ; B4D9 00                       .
        brk                                     ; B4DA 00                       .
        cli                                     ; B4DB 58                       X
        brk                                     ; B4DC 00                       .
        brk                                     ; B4DD 00                       .
        eor     a:L0000,x                       ; B4DE 5D 00 00                 ]..
        lsr     a                               ; B4E1 4A                       J
        brk                                     ; B4E2 00                       .
        .byte   $92                             ; B4E3 92                       .
        brk                                     ; B4E4 00                       .
        .byte   $4B                             ; B4E5 4B                       K
        brk                                     ; B4E6 00                       .
        .byte   $92                             ; B4E7 92                       .
        brk                                     ; B4E8 00                       .
        .byte   $1B                             ; B4E9 1B                       .
        brk                                     ; B4EA 00                       .
        brk                                     ; B4EB 00                       .
        brk                                     ; B4EC 00                       .
        brk                                     ; B4ED 00                       .
        jsr     L0023                           ; B4EE 20 23 00                  #.
        brk                                     ; B4F1 00                       .
        .byte   $23                             ; B4F2 23                       #
        .byte   $23                             ; B4F3 23                       #
        brk                                     ; B4F4 00                       .
        rol     a                               ; B4F5 2A                       *
        .byte   $22                             ; B4F6 22                       "
        rol     a                               ; B4F7 2A                       *
        brk                                     ; B4F8 00                       .
        plp                                     ; B4F9 28                       (
        brk                                     ; B4FA 00                       .
        and     #$28                            ; B4FB 29 28                    )(
        plp                                     ; B4FD 28                       (
        and     #$29                            ; B4FE 29 29                    ))
        plp                                     ; B500 28                       (
        rol     a                               ; B501 2A                       *
        and     #$2A                            ; B502 29 2A                    )*
        rol     a                               ; B504 2A                       *
        jsr     L282A                           ; B505 20 2A 28                  *(
        .byte   $23                             ; B508 23                       #
        .byte   $23                             ; B509 23                       #
        plp                                     ; B50A 28                       (
        plp                                     ; B50B 28                       (
        rol     a                               ; B50C 2A                       *
        and     #$2A                            ; B50D 29 2A                    )*
        brk                                     ; B50F 00                       .
        and     #$29                            ; B510 29 29                    ))
        brk                                     ; B512 00                       .
        brk                                     ; B513 00                       .
        brk                                     ; B514 00                       .
        and     #$00                            ; B515 29 00                    ).
        brk                                     ; B517 00                       .
        and     #$2A                            ; B518 29 2A                    )*
        brk                                     ; B51A 00                       .
        rol     a                               ; B51B 2A                       *
        .byte   $22                             ; B51C 22                       "
        rol     a                               ; B51D 2A                       *
        plp                                     ; B51E 28                       (
        rol     a                               ; B51F 2A                       *
        brk                                     ; B520 00                       .
        brk                                     ; B521 00                       .
        brk                                     ; B522 00                       .
        jsr     L0000                           ; B523 20 00 00                  ..
        .byte   $23                             ; B526 23                       #
        .byte   $22                             ; B527 22                       "
        plp                                     ; B528 28                       (
        brk                                     ; B529 00                       .
        and     #$00                            ; B52A 29 00                    ).
        brk                                     ; B52C 00                       .
        brk                                     ; B52D 00                       .
        brk                                     ; B52E 00                       .
        .byte   $43                             ; B52F 43                       C
        brk                                     ; B530 00                       .
        .byte   $43                             ; B531 43                       C
        asl     $1E,x                           ; B532 16 1E                    ..
        .byte   $0F                             ; B534 0F                       .
        rol     a                               ; B535 2A                       *
        .byte   $27                             ; B536 27                       '
        rol     a                               ; B537 2A                       *
        .byte   $23                             ; B538 23                       #
        and     ($28,x)                         ; B539 21 28                    !(
        jsr     L2121                           ; B53B 20 21 21                  !!
        .byte   $23                             ; B53E 23                       #
        .byte   $23                             ; B53F 23                       #
        .byte   $22                             ; B540 22                       "
        rol     a                               ; B541 2A                       *
        .byte   $22                             ; B542 22                       "
        rol     a                               ; B543 2A                       *
        and     #$28                            ; B544 29 28                    )(
        brk                                     ; B546 00                       .
        and     #$4A                            ; B547 29 4A                    )J
        brk                                     ; B549 00                       .
        .byte   $92                             ; B54A 92                       .
        brk                                     ; B54B 00                       .
        .byte   $43                             ; B54C 43                       C
        ora     $1514                           ; B54D 0D 14 15                 ...
        .byte   $4B                             ; B550 4B                       K
        brk                                     ; B551 00                       .
        .byte   $92                             ; B552 92                       .
        brk                                     ; B553 00                       .
        brk                                     ; B554 00                       .
        brk                                     ; B555 00                       .
        .byte   $43                             ; B556 43                       C
        asl     L0000,x                         ; B557 16 00                    ..
        brk                                     ; B559 00                       .
        asl     $4316,x                         ; B55A 1E 16 43                 ..C
        ora     $161E                           ; B55D 0D 1E 16                 ...
        brk                                     ; B560 00                       .
        .byte   $0C                             ; B561 0C                       .
        brk                                     ; B562 00                       .
        .byte   $14                             ; B563 14                       .
        brk                                     ; B564 00                       .
        bit     L0000                           ; B565 24 00                    $.
        brk                                     ; B567 00                       .
        .byte   $0C                             ; B568 0C                       .
        ora     $1614                           ; B569 0D 14 16                 ...
        ora     $1E0F                           ; B56C 0D 0F 1E                 ...
        .byte   $17                             ; B56F 17                       .
        asl     $1E0D                           ; B570 0E 0D 1E                 ...
        asl     L000E,x                         ; B573 16 0E                    ..
        .byte   $1F                             ; B575 1F                       .
        asl     $0D27,x                         ; B576 1E 27 0D                 .'.
        asl     $161E                           ; B579 0E 1E 16                 ...
        .byte   $9C                             ; B57C 9C                       .
        sta     $2625,x                         ; B57D 9D 25 26                 .%&
        asl     $1E,x                           ; B580 16 1E                    ..
        rol     $25                             ; B582 26 25                    &%
        asl     $1E,x                           ; B584 16 1E                    ..
        and     $26                             ; B586 25 26                    %&
        asl     $1E,x                           ; B588 16 1E                    ..
        and     $25                             ; B58A 25 25                    %%
        asl     $1F,x                           ; B58C 16 1F                    ..
        rol     $27                             ; B58E 26 27                    &'
        .byte   $1C                             ; B590 1C                       .
        ora     $1C,x                           ; B591 15 1C                    ..
        ora     $0D0D,x                         ; B593 1D 0D 0D                 ...
        asl     $1E,x                           ; B596 16 1E                    ..
        asl     $160F                           ; B598 0E 0F 16                 ...
        .byte   $27                             ; B59B 27                       '
        .byte   $1C                             ; B59C 1C                       .
        asl     $24,x                           ; B59D 16 24                    .$
        and     $1E                             ; B59F 25 1E                    %.
        asl     $26,x                           ; B5A1 16 26                    .&
        and     $15                             ; B5A3 25 15                    %.
        .byte   $0F                             ; B5A5 0F                       .
        ora     $0C27,x                         ; B5A6 1D 27 0C                 .'.
        ora     $24,x                           ; B5A9 15 24                    .$
        ora     $0E0C,x                         ; B5AB 1D 0C 0E                 ...
        .byte   $1C                             ; B5AE 1C                       .
        ora     $1D,x                           ; B5AF 15 1D                    ..
        .byte   $1F                             ; B5B1 1F                       .
        asl     $1F,x                           ; B5B2 16 1F                    ..
        bit     $1D                             ; B5B4 24 1D                    $.
        brk                                     ; B5B6 00                       .
        brk                                     ; B5B7 00                       .
        ora     a:$1D,x                         ; B5B8 1D 1D 00                 ...
        brk                                     ; B5BB 00                       .
        ora     a:$1D,x                         ; B5BC 1D 1D 00                 ...
        .byte   $5F                             ; B5BF 5F                       _
        ora     $1F,x                           ; B5C0 15 1F                    ..
        ora     a:$27,x                         ; B5C2 1D 27 00                 .'.
        .byte   $5F                             ; B5C5 5F                       _
        brk                                     ; B5C6 00                       .
        .byte   $5F                             ; B5C7 5F                       _
        ora     $161D,x                         ; B5C8 1D 1D 16                 ...
        asl     a:$0F,x                         ; B5CB 1E 0F 00                 ...
        .byte   $17                             ; B5CE 17                       .
        brk                                     ; B5CF 00                       .
        .byte   $1C                             ; B5D0 1C                       .
        ora     $24,x                           ; B5D1 15 24                    .$
        ora     a:$1F,x                         ; B5D3 1D 1F 00                 ...
        .byte   $27                             ; B5D6 27                       '
        .byte   $52                             ; B5D7 52                       R
        .byte   $1F                             ; B5D8 1F                       .
        sta     $991F,y                         ; B5D9 99 1F 99                 ...
        .byte   $1F                             ; B5DC 1F                       .
        .byte   $4F                             ; B5DD 4F                       O
        .byte   $1F                             ; B5DE 1F                       .
        .byte   $4F                             ; B5DF 4F                       O
        .byte   $4F                             ; B5E0 4F                       O
        sta     $994F,y                         ; B5E1 99 4F 99                 .O.
        .byte   $1F                             ; B5E4 1F                       .
        .byte   $4F                             ; B5E5 4F                       O
        .byte   $1F                             ; B5E6 1F                       .
        .byte   $72                             ; B5E7 72                       r
        .byte   $1F                             ; B5E8 1F                       .
        .byte   $7A                             ; B5E9 7A                       z
        .byte   $1F                             ; B5EA 1F                       .
        brk                                     ; B5EB 00                       .
        .byte   $4F                             ; B5EC 4F                       O
        sta     $9875,y                         ; B5ED 99 75 98                 .u.
        .byte   $27                             ; B5F0 27                       '
        brk                                     ; B5F1 00                       .
        brk                                     ; B5F2 00                       .
        brk                                     ; B5F3 00                       .
        brk                                     ; B5F4 00                       .
        .byte   $1C                             ; B5F5 1C                       .
        brk                                     ; B5F6 00                       .
        .byte   $1C                             ; B5F7 1C                       .
        brk                                     ; B5F8 00                       .
        .byte   $1C                             ; B5F9 1C                       .
        brk                                     ; B5FA 00                       .
        bit     $1D                             ; B5FB 24 1D                    $.
        ora     $1E16,x                         ; B5FD 1D 16 1E                 ...
        brk                                     ; B600 00                       .
        brk                                     ; B601 00                       .
        brk                                     ; B602 00                       .
        brk                                     ; B603 00                       .
        brk                                     ; B604 00                       .
        brk                                     ; B605 00                       .
        ora     ($02,x)                         ; B606 01 02                    ..
        .byte   $03                             ; B608 03                       .
        .byte   $04                             ; B609 04                       .
        brk                                     ; B60A 00                       .
        ora     L0000                           ; B60B 05 00                    ..
        asl     $07                             ; B60D 06 07                    ..
        php                                     ; B60F 08                       .
        ora     #$0A                            ; B610 09 0A                    ..
        .byte   $0B                             ; B612 0B                       .
        .byte   $0C                             ; B613 0C                       .
        ora     $080E                           ; B614 0D 0E 08                 ...
        php                                     ; B617 08                       .
        php                                     ; B618 08                       .
        php                                     ; B619 08                       .
        .byte   $0F                             ; B61A 0F                       .
        bpl     LB625                           ; B61B 10 08                    ..
        php                                     ; B61D 08                       .
        ora     ($12),y                         ; B61E 11 12                    ..
        php                                     ; B620 08                       .
        php                                     ; B621 08                       .
        php                                     ; B622 08                       .
        .byte   $13                             ; B623 13                       .
        php                                     ; B624 08                       .
LB625:  php                                     ; B625 08                       .
        php                                     ; B626 08                       .
        php                                     ; B627 08                       .
        .byte   $14                             ; B628 14                       .
        ora     $08,x                           ; B629 15 08                    ..
        php                                     ; B62B 08                       .
        php                                     ; B62C 08                       .
        asl     $08,x                           ; B62D 16 08                    ..
        php                                     ; B62F 08                       .
        .byte   $17                             ; B630 17                       .
        .byte   $17                             ; B631 17                       .
        clc                                     ; B632 18                       .
        ora     $1B1A,y                         ; B633 19 1A 1B                 ...
        ora     $171C,y                         ; B636 19 1C 17                 ...
        .byte   $17                             ; B639 17                       .
        ora     $1F1E,x                         ; B63A 1D 1E 1F                 ...
        jsr     L211E                           ; B63D 20 1E 21                  .!
        .byte   $22                             ; B640 22                       "
        php                                     ; B641 08                       .
        php                                     ; B642 08                       .
        php                                     ; B643 08                       .
        php                                     ; B644 08                       .
        php                                     ; B645 08                       .
        asl     L0023,x                         ; B646 16 23                    .#
        .byte   $22                             ; B648 22                       "
        ora     ($12),y                         ; B649 11 12                    ..
        php                                     ; B64B 08                       .
        php                                     ; B64C 08                       .
        php                                     ; B64D 08                       .
        php                                     ; B64E 08                       .
        .byte   $23                             ; B64F 23                       #
        .byte   $22                             ; B650 22                       "
        php                                     ; B651 08                       .
        php                                     ; B652 08                       .
        asl     $08,x                           ; B653 16 08                    ..
        php                                     ; B655 08                       .
        php                                     ; B656 08                       .
        .byte   $23                             ; B657 23                       #
        .byte   $22                             ; B658 22                       "
        php                                     ; B659 08                       .
        php                                     ; B65A 08                       .
        php                                     ; B65B 08                       .
        php                                     ; B65C 08                       .
        php                                     ; B65D 08                       .
        php                                     ; B65E 08                       .
        .byte   $23                             ; B65F 23                       #
        .byte   $22                             ; B660 22                       "
        php                                     ; B661 08                       .
        ora     ($12),y                         ; B662 11 12                    ..
        php                                     ; B664 08                       .
        .byte   $13                             ; B665 13                       .
        php                                     ; B666 08                       .
        .byte   $23                             ; B667 23                       #
        .byte   $22                             ; B668 22                       "
        php                                     ; B669 08                       .
        php                                     ; B66A 08                       .
        php                                     ; B66B 08                       .
        php                                     ; B66C 08                       .
        php                                     ; B66D 08                       .
        php                                     ; B66E 08                       .
        .byte   $23                             ; B66F 23                       #
        bit     $25                             ; B670 24 25                    $%
        rol     $27                             ; B672 26 27                    &'
        and     $26                             ; B674 25 26                    %&
        .byte   $27                             ; B676 27                       '
        plp                                     ; B677 28                       (
        and     #$2A                            ; B678 29 2A                    )*
        .byte   $2B                             ; B67A 2B                       +
        bit     $2B2A                           ; B67B 2C 2A 2B                 ,*+
        bit     $082D                           ; B67E 2C 2D 08                 ,-.
        php                                     ; B681 08                       .
        php                                     ; B682 08                       .
        php                                     ; B683 08                       .
        php                                     ; B684 08                       .
        php                                     ; B685 08                       .
        php                                     ; B686 08                       .
        php                                     ; B687 08                       .
        php                                     ; B688 08                       .
        php                                     ; B689 08                       .
        php                                     ; B68A 08                       .
        php                                     ; B68B 08                       .
        php                                     ; B68C 08                       .
        ora     ($12),y                         ; B68D 11 12                    ..
        php                                     ; B68F 08                       .
        php                                     ; B690 08                       .
        php                                     ; B691 08                       .
        php                                     ; B692 08                       .
        .byte   $13                             ; B693 13                       .
        php                                     ; B694 08                       .
        php                                     ; B695 08                       .
        php                                     ; B696 08                       .
        php                                     ; B697 08                       .
        .byte   $13                             ; B698 13                       .
        php                                     ; B699 08                       .
        php                                     ; B69A 08                       .
        php                                     ; B69B 08                       .
        php                                     ; B69C 08                       .
        php                                     ; B69D 08                       .
        rol     $082F                           ; B69E 2E 2F 08                 ./.
        rol     $082F                           ; B6A1 2E 2F 08                 ./.
        php                                     ; B6A4 08                       .
        php                                     ; B6A5 08                       .
        php                                     ; B6A6 08                       .
        php                                     ; B6A7 08                       .
        php                                     ; B6A8 08                       .
        php                                     ; B6A9 08                       .
        php                                     ; B6AA 08                       .
        php                                     ; B6AB 08                       .
        bmi     LB6DF                           ; B6AC 30 31                    01
        .byte   $32                             ; B6AE 32                       2
        php                                     ; B6AF 08                       .
        .byte   $33                             ; B6B0 33                       3
        .byte   $34                             ; B6B1 34                       4
        and     $08,x                           ; B6B2 35 08                    5.
        rol     $37,x                           ; B6B4 36 37                    67
        sec                                     ; B6B6 38                       8
        asl     $39,x                           ; B6B7 16 39                    .9
        jsr     L163A                           ; B6B9 20 3A 16                  :.
        php                                     ; B6BC 08                       .
        .byte   $3B                             ; B6BD 3B                       ;
        php                                     ; B6BE 08                       .
        php                                     ; B6BF 08                       .
        .byte   $3C                             ; B6C0 3C                       <
        and     $033E,x                         ; B6C1 3D 3E 03                 =>.
        .byte   $04                             ; B6C4 04                       .
        brk                                     ; B6C5 00                       .
        ora     L0000                           ; B6C6 05 00                    ..
        php                                     ; B6C8 08                       .
        php                                     ; B6C9 08                       .
        .byte   $3F                             ; B6CA 3F                       ?
        ora     #$0A                            ; B6CB 09 0A                    ..
        .byte   $0B                             ; B6CD 0B                       .
        .byte   $0C                             ; B6CE 0C                       .
        ora     $0808                           ; B6CF 0D 08 08                 ...
        php                                     ; B6D2 08                       .
        php                                     ; B6D3 08                       .
        php                                     ; B6D4 08                       .
        .byte   $0F                             ; B6D5 0F                       .
        bpl     LB6E0                           ; B6D6 10 08                    ..
        php                                     ; B6D8 08                       .
        ora     ($12),y                         ; B6D9 11 12                    ..
        php                                     ; B6DB 08                       .
        php                                     ; B6DC 08                       .
        php                                     ; B6DD 08                       .
        php                                     ; B6DE 08                       .
LB6DF:  php                                     ; B6DF 08                       .
LB6E0:  bmi     LB713                           ; B6E0 30 31                    01
        and     ($32),y                         ; B6E2 31 32                    12
        php                                     ; B6E4 08                       .
        php                                     ; B6E5 08                       .
        ora     ($12),y                         ; B6E6 11 12                    ..
        rti                                     ; B6E8 40                       @

; ----------------------------------------------------------------------------
        eor     ($42,x)                         ; B6E9 41 42                    AB
        .byte   $43                             ; B6EB 43                       C
        php                                     ; B6EC 08                       .
        bmi     LB720                           ; B6ED 30 31                    01
        .byte   $32                             ; B6EF 32                       2
        php                                     ; B6F0 08                       .
        .byte   $44                             ; B6F1 44                       D
        eor     $46                             ; B6F2 45 46                    EF
        .byte   $47                             ; B6F4 47                       G
        rol     $37,x                           ; B6F5 36 37                    67
        sec                                     ; B6F7 38                       8
        pha                                     ; B6F8 48                       H
        eor     #$4A                            ; B6F9 49 4A                    IJ
        .byte   $4B                             ; B6FB 4B                       K
        jmp     L3B4D                           ; B6FC 4C 4D 3B                 LM;

; ----------------------------------------------------------------------------
        lsr     $0706                           ; B6FF 4E 06 07                 N..
        php                                     ; B702 08                       .
        php                                     ; B703 08                       .
        rol     $4F2F                           ; B704 2E 2F 4F                 ./O
        php                                     ; B707 08                       .
        asl     $2E08                           ; B708 0E 08 2E                 ...
        .byte   $2F                             ; B70B 2F                       /
        php                                     ; B70C 08                       .
        php                                     ; B70D 08                       .
        .byte   $4F                             ; B70E 4F                       O
        php                                     ; B70F 08                       .
        php                                     ; B710 08                       .
        php                                     ; B711 08                       .
        php                                     ; B712 08                       .
LB713:  php                                     ; B713 08                       .
        php                                     ; B714 08                       .
        php                                     ; B715 08                       .
        .byte   $4F                             ; B716 4F                       O
        php                                     ; B717 08                       .
        .byte   $13                             ; B718 13                       .
        php                                     ; B719 08                       .
        php                                     ; B71A 08                       .
        php                                     ; B71B 08                       .
        php                                     ; B71C 08                       .
        php                                     ; B71D 08                       .
        bvc     LB771                           ; B71E 50 51                    PQ
LB720:  php                                     ; B720 08                       .
        bmi     LB754                           ; B721 30 31                    01
        and     ($32),y                         ; B723 31 32                    12
        php                                     ; B725 08                       .
        .byte   $52                             ; B726 52                       R
        .byte   $53                             ; B727 53                       S
        php                                     ; B728 08                       .
        rti                                     ; B729 40                       @

; ----------------------------------------------------------------------------
        eor     ($42,x)                         ; B72A 41 42                    AB
        .byte   $43                             ; B72C 43                       C
        lsr     $54                             ; B72D 46 54                    FT
        eor     #$46                            ; B72F 49 46                    IF
        .byte   $47                             ; B731 47                       G
        .byte   $44                             ; B732 44                       D
        eor     $48                             ; B733 45 48                    EH
        .byte   $4B                             ; B735 4B                       K
        brk                                     ; B736 00                       .
        brk                                     ; B737 00                       .
        .byte   $4B                             ; B738 4B                       K
        jmp     L4A49                           ; B739 4C 49 4A                 LIJ

; ----------------------------------------------------------------------------
        eor     L0000,x                         ; B73C 55 00                    U.
        brk                                     ; B73E 00                       .
        brk                                     ; B73F 00                       .
        rol     $562F                           ; B740 2E 2F 56                 ./V
        php                                     ; B743 08                       .
        php                                     ; B744 08                       .
        php                                     ; B745 08                       .
        php                                     ; B746 08                       .
        lsr     $0808                           ; B747 4E 08 08                 N..
        lsr     $08,x                           ; B74A 56 08                    V.
        php                                     ; B74C 08                       .
        php                                     ; B74D 08                       .
        .byte   $57                             ; B74E 57                       W
        cli                                     ; B74F 58                       X
        eor     $5B5A,y                         ; B750 59 5A 5B                 YZ[
        php                                     ; B753 08                       .
LB754:  php                                     ; B754 08                       .
        php                                     ; B755 08                       .
        .byte   $5C                             ; B756 5C                       \
        eor     $084F,x                         ; B757 5D 4F 08                 ]O.
        lsr     $5A08,x                         ; B75A 5E 08 5A                 ^.Z
        .byte   $5F                             ; B75D 5F                       _
        php                                     ; B75E 08                       .
        asl     a                               ; B75F 0A                       .
        rts                                     ; B760 60                       `

; ----------------------------------------------------------------------------
        adc     ($5B,x)                         ; B761 61 5B                    a[
        php                                     ; B763 08                       .
        php                                     ; B764 08                       .
        ora     ($12),y                         ; B765 11 12                    ..
        php                                     ; B767 08                       .
        .byte   $62                             ; B768 62                       b
        php                                     ; B769 08                       .
        .byte   $63                             ; B76A 63                       c
        .byte   $64                             ; B76B 64                       d
        adc     $66                             ; B76C 65 66                    ef
        .byte   $67                             ; B76E 67                       g
        php                                     ; B76F 08                       .
        pla                                     ; B770 68                       h
LB771:  ora     $08,x                           ; B771 15 08                    ..
        php                                     ; B773 08                       .
        php                                     ; B774 08                       .
        php                                     ; B775 08                       .
        .byte   $4F                             ; B776 4F                       O
        php                                     ; B777 08                       .
        brk                                     ; B778 00                       .
        adc     #$08                            ; B779 69 08                    i.
        php                                     ; B77B 08                       .
        php                                     ; B77C 08                       .
        php                                     ; B77D 08                       .
        .byte   $4F                             ; B77E 4F                       O
        lsr     a:L0000,x                       ; B77F 5E 00 00                 ^..
        brk                                     ; B782 00                       .
        brk                                     ; B783 00                       .
        brk                                     ; B784 00                       .
        ora     ($02,x)                         ; B785 01 02                    ..
        .byte   $3C                             ; B787 3C                       <
        .byte   $04                             ; B788 04                       .
        brk                                     ; B789 00                       .
        ora     L0000                           ; B78A 05 00                    ..
        asl     $07                             ; B78C 06 07                    ..
        php                                     ; B78E 08                       .
        php                                     ; B78F 08                       .
        asl     a                               ; B790 0A                       .
        .byte   $0B                             ; B791 0B                       .
        .byte   $0C                             ; B792 0C                       .
        ora     $080E                           ; B793 0D 0E 08                 ...
        php                                     ; B796 08                       .
        php                                     ; B797 08                       .
        ror     a                               ; B798 6A                       j
        .byte   $3C                             ; B799 3C                       <
        bpl     LB7A4                           ; B79A 10 08                    ..
        php                                     ; B79C 08                       .
        php                                     ; B79D 08                       .
        ora     ($12),y                         ; B79E 11 12                    ..
        jmp     L086B                           ; B7A0 4C 6B 08                 Lk.

; ----------------------------------------------------------------------------
        php                                     ; B7A3 08                       .
LB7A4:  php                                     ; B7A4 08                       .
        php                                     ; B7A5 08                       .
        php                                     ; B7A6 08                       .
        php                                     ; B7A7 08                       .
        jmp     (L6D0E)                         ; B7A8 6C 0E 6D                 l.m

; ----------------------------------------------------------------------------
        ror     $636F                           ; B7AB 6E 6F 63                 noc
        .byte   $64                             ; B7AE 64                       d
        adc     $08                             ; B7AF 65 08                    e.
        php                                     ; B7B1 08                       .
        lsr     $08,x                           ; B7B2 56 08                    V.
        php                                     ; B7B4 08                       .
        rol     $082F                           ; B7B5 2E 2F 08                 ./.
        php                                     ; B7B8 08                       .
        php                                     ; B7B9 08                       .
        lsr     $08,x                           ; B7BA 56 08                    V.
        php                                     ; B7BC 08                       .
        php                                     ; B7BD 08                       .
        php                                     ; B7BE 08                       .
        php                                     ; B7BF 08                       .
        and     a:$04,x                         ; B7C0 3D 04 00                 =..
        ora     L0000                           ; B7C3 05 00                    ..
        .byte   $03                             ; B7C5 03                       .
        .byte   $04                             ; B7C6 04                       .
        brk                                     ; B7C7 00                       .
        php                                     ; B7C8 08                       .
        asl     a                               ; B7C9 0A                       .
        .byte   $0B                             ; B7CA 0B                       .
        .byte   $0C                             ; B7CB 0C                       .
        ora     $7170                           ; B7CC 0D 70 71                 .pq
        .byte   $72                             ; B7CF 72                       r
        lsr     $7308,x                         ; B7D0 5E 08 73                 ^.s
        .byte   $74                             ; B7D3 74                       t
        php                                     ; B7D4 08                       .
        php                                     ; B7D5 08                       .
        php                                     ; B7D6 08                       .
        php                                     ; B7D7 08                       .
        php                                     ; B7D8 08                       .
        php                                     ; B7D9 08                       .
        php                                     ; B7DA 08                       .
        php                                     ; B7DB 08                       .
        php                                     ; B7DC 08                       .
        ora     ($12),y                         ; B7DD 11 12                    ..
        php                                     ; B7DF 08                       .
        php                                     ; B7E0 08                       .
        php                                     ; B7E1 08                       .
        lsr     $5A08,x                         ; B7E2 5E 08 5A                 ^.Z
        .byte   $5F                             ; B7E5 5F                       _
        php                                     ; B7E6 08                       .
        ora     ($08),y                         ; B7E7 11 08                    ..
        adc     $34,x                           ; B7E9 75 34                    u4
        .byte   $1A                             ; B7EB 1A                       .
        .byte   $1C                             ; B7EC 1C                       .
        php                                     ; B7ED 08                       .
        php                                     ; B7EE 08                       .
        .byte   $5A                             ; B7EF 5A                       Z
        php                                     ; B7F0 08                       .
        ror     $77,x                           ; B7F1 76 77                    vw
        .byte   $77                             ; B7F3 77                       w
        sei                                     ; B7F4 78                       x
        .byte   $34                             ; B7F5 34                       4
        .byte   $1A                             ; B7F6 1A                       .
        .byte   $1B                             ; B7F7 1B                       .
        php                                     ; B7F8 08                       .
        adc     L201F,y                         ; B7F9 79 1F 20                 y. 
        .byte   $7A                             ; B7FC 7A                       z
        .byte   $1F                             ; B7FD 1F                       .
        jsr     L7B1F                           ; B7FE 20 1F 7B                  .{
        .byte   $7C                             ; B801 7C                       |
        php                                     ; B802 08                       .
        .byte   $3C                             ; B803 3C                       <
        and     $7E7D,x                         ; B804 3D 7D 7E                 =}~
        brk                                     ; B807 00                       .
        .byte   $7F                             ; B808 7F                       .
        php                                     ; B809 08                       .
        php                                     ; B80A 08                       .
        php                                     ; B80B 08                       .
        php                                     ; B80C 08                       .
        .byte   $80                             ; B80D 80                       .
LB80E:  sta     ($82,x)                         ; B80E 81 82                    ..
        php                                     ; B810 08                       .
        php                                     ; B811 08                       .
        php                                     ; B812 08                       .
        ora     ($12),y                         ; B813 11 12                    ..
        php                                     ; B815 08                       .
        php                                     ; B816 08                       .
        php                                     ; B817 08                       .
        php                                     ; B818 08                       .
        .byte   $83                             ; B819 83                       .
        php                                     ; B81A 08                       .
        php                                     ; B81B 08                       .
        php                                     ; B81C 08                       .
        php                                     ; B81D 08                       .
        ora     ($12),y                         ; B81E 11 12                    ..
        sty     $85                             ; B820 84 85                    ..
        stx     $08                             ; B822 86 08                    ..
        php                                     ; B824 08                       .
        php                                     ; B825 08                       .
        php                                     ; B826 08                       .
        php                                     ; B827 08                       .
        .byte   $5F                             ; B828 5F                       _
        php                                     ; B829 08                       .
        .byte   $87                             ; B82A 87                       .
        php                                     ; B82B 08                       .
        php                                     ; B82C 08                       .
        php                                     ; B82D 08                       .
        php                                     ; B82E 08                       .
        php                                     ; B82F 08                       .
        dey                                     ; B830 88                       .
        .byte   $1B                             ; B831 1B                       .
        .byte   $89                             ; B832 89                       .
        .byte   $63                             ; B833 63                       c
        .byte   $64                             ; B834 64                       d
        adc     $8A                             ; B835 65 8A                    e.
        .byte   $14                             ; B837 14                       .
        jsr     L8B7A                           ; B838 20 7A 8B                  z.
        php                                     ; B83B 08                       .
        php                                     ; B83C 08                       .
        lsr     $8C58                           ; B83D 4E 58 8C                 NX.
        asl     $07                             ; B840 06 07                    ..
        php                                     ; B842 08                       .
        php                                     ; B843 08                       .
        php                                     ; B844 08                       .
        lsr     $11,x                           ; B845 56 11                    V.
        .byte   $12                             ; B847 12                       .
        asl     $2E08                           ; B848 0E 08 2E                 ...
        .byte   $2F                             ; B84B 2F                       /
        php                                     ; B84C 08                       .
        sta     $0867                           ; B84D 8D 67 08                 .g.
        php                                     ; B850 08                       .
        php                                     ; B851 08                       .
        php                                     ; B852 08                       .
        php                                     ; B853 08                       .
        php                                     ; B854 08                       .
        php                                     ; B855 08                       .
        .byte   $4F                             ; B856 4F                       O
        php                                     ; B857 08                       .
        php                                     ; B858 08                       .
        php                                     ; B859 08                       .
        php                                     ; B85A 08                       .
        php                                     ; B85B 08                       .
        ora     ($12),y                         ; B85C 11 12                    ..
        .byte   $4F                             ; B85E 4F                       O
        php                                     ; B85F 08                       .
        php                                     ; B860 08                       .
        rol     $082F                           ; B861 2E 2F 08                 ./.
        php                                     ; B864 08                       .
        php                                     ; B865 08                       .
        stx     $088F                           ; B866 8E 8F 08                 ...
        php                                     ; B869 08                       .
        php                                     ; B86A 08                       .
        php                                     ; B86B 08                       .
        php                                     ; B86C 08                       .
        php                                     ; B86D 08                       .
        php                                     ; B86E 08                       .
        php                                     ; B86F 08                       .
        ora     $08,x                           ; B870 15 08                    ..
        php                                     ; B872 08                       .
        lsr     $47                             ; B873 46 47                    FG
        .byte   $63                             ; B875 63                       c
        .byte   $64                             ; B876 64                       d
        adc     $90                             ; B877 65 90                    e.
        sta     ($4E),y                         ; B879 91 4E                    .N
        .byte   $4B                             ; B87B 4B                       K
        jmp     L084D                           ; B87C 4C 4D 08                 LM.

; ----------------------------------------------------------------------------
        php                                     ; B87F 08                       .
        php                                     ; B880 08                       .
        lsr     $08,x                           ; B881 56 08                    V.
        php                                     ; B883 08                       .
        php                                     ; B884 08                       .
        php                                     ; B885 08                       .
        php                                     ; B886 08                       .
        lsr     $5608                           ; B887 4E 08 56                 N.V
        php                                     ; B88A 08                       .
        php                                     ; B88B 08                       .
        asl     $08,x                           ; B88C 16 08                    ..
        .byte   $57                             ; B88E 57                       W
        cli                                     ; B88F 58                       X
        php                                     ; B890 08                       .
        lsr     $11,x                           ; B891 56 11                    V.
        .byte   $12                             ; B893 12                       .
        php                                     ; B894 08                       .
        php                                     ; B895 08                       .
        .byte   $5C                             ; B896 5C                       \
        eor     $5A15,x                         ; B897 5D 15 5A                 ].Z
        .byte   $5F                             ; B89A 5F                       _
        php                                     ; B89B 08                       .
        php                                     ; B89C 08                       .
        php                                     ; B89D 08                       .
        php                                     ; B89E 08                       .
        asl     a                               ; B89F 0A                       .
        adc     #$08                            ; B8A0 69 08                    i.
        php                                     ; B8A2 08                       .
        .byte   $5A                             ; B8A3 5A                       Z
        .byte   $5F                             ; B8A4 5F                       _
        .byte   $92                             ; B8A5 92                       .
        php                                     ; B8A6 08                       .
        .byte   $57                             ; B8A7 57                       W
        .byte   $62                             ; B8A8 62                       b
        php                                     ; B8A9 08                       .
        php                                     ; B8AA 08                       .
        ora     ($12),y                         ; B8AB 11 12                    ..
        lsr     $08,x                           ; B8AD 56 08                    V.
        .byte   $5C                             ; B8AF 5C                       \
        pla                                     ; B8B0 68                       h
        ora     $08,x                           ; B8B1 15 08                    ..
        php                                     ; B8B3 08                       .
        php                                     ; B8B4 08                       .
        lsr     $08,x                           ; B8B5 56 08                    V.
        php                                     ; B8B7 08                       .
        brk                                     ; B8B8 00                       .
        adc     #$08                            ; B8B9 69 08                    i.
        php                                     ; B8BB 08                       .
        php                                     ; B8BC 08                       .
        lsr     $08,x                           ; B8BD 56 08                    V.
        php                                     ; B8BF 08                       .
        brk                                     ; B8C0 00                       .
        brk                                     ; B8C1 00                       .
        brk                                     ; B8C2 00                       .
        brk                                     ; B8C3 00                       .
        brk                                     ; B8C4 00                       .
        brk                                     ; B8C5 00                       .
        brk                                     ; B8C6 00                       .
        brk                                     ; B8C7 00                       .
        brk                                     ; B8C8 00                       .
        brk                                     ; B8C9 00                       .
        brk                                     ; B8CA 00                       .
        brk                                     ; B8CB 00                       .
        brk                                     ; B8CC 00                       .
        ora     L0000                           ; B8CD 05 00                    ..
        .byte   $93                             ; B8CF 93                       .
        brk                                     ; B8D0 00                       .
        ora     L0000                           ; B8D1 05 00                    ..
        .byte   $03                             ; B8D3 03                       .
        .byte   $04                             ; B8D4 04                       .
        brk                                     ; B8D5 00                       .
        .byte   $7B                             ; B8D6 7B                       {
        ora     $0C0B                           ; B8D7 0D 0B 0C                 ...
        ora     $7170                           ; B8DA 0D 70 71                 .pq
        .byte   $72                             ; B8DD 72                       r
        .byte   $7F                             ; B8DE 7F                       .
        php                                     ; B8DF 08                       .
        .byte   $3C                             ; B8E0 3C                       <
        bpl     LB8EB                           ; B8E1 10 08                    ..
        php                                     ; B8E3 08                       .
        php                                     ; B8E4 08                       .
        php                                     ; B8E5 08                       .
        php                                     ; B8E6 08                       .
        sty     $08,x                           ; B8E7 94 08                    ..
        php                                     ; B8E9 08                       .
        php                                     ; B8EA 08                       .
LB8EB:  asl     $08,x                           ; B8EB 16 08                    ..
        sty     $95,x                           ; B8ED 94 95                    ..
        stx     $08,y                           ; B8EF 96 08                    ..
        .byte   $97                             ; B8F1 97                       .
        sta     $98                             ; B8F2 85 98                    ..
        sta     $99                             ; B8F4 85 99                    ..
        txs                                     ; B8F6 9A                       .
        .byte   $9B                             ; B8F7 9B                       .
        php                                     ; B8F8 08                       .
        .byte   $9C                             ; B8F9 9C                       .
        sta     $9D9D,x                         ; B8FA 9D 9D 9D                 ...
        .byte   $9E                             ; B8FD 9E                       .
        .byte   $9F                             ; B8FE 9F                       .
        ldy     #$00                            ; B8FF A0 00                    ..
        .byte   $7B                             ; B901 7B                       {
        ora     $080E                           ; B902 0D 0E 08                 ...
        php                                     ; B905 08                       .
        adc     ($72),y                         ; B906 71 72                    qr
        asl     $7F                             ; B908 06 7F                    ..
        php                                     ; B90A 08                       .
        php                                     ; B90B 08                       .
        .byte   $5E,$08,$A1                     ; B90C 5E 08 A1                 ^..
        ror     L000E                           ; B90F 66 0E                    f.
        rol     $082F                           ; B911 2E 2F 08                 ./.
        php                                     ; B914 08                       .
        ldx     #$A3                            ; B915 A2 A3                    ..
        php                                     ; B917 08                       .
        php                                     ; B918 08                       .
        php                                     ; B919 08                       .
        php                                     ; B91A 08                       .
        php                                     ; B91B 08                       .
        lda     ($66,x)                         ; B91C A1 66                    .f
        ldy     $A5                             ; B91E A4 A5                    ..
        sta     $A6,x                           ; B920 95 A6                    ..
        php                                     ; B922 08                       .
        ldx     #$A3                            ; B923 A2 A3                    ..
        php                                     ; B925 08                       .
        ora     ($12),y                         ; B926 11 12                    ..
        txs                                     ; B928 9A                       .
        .byte   $A7                             ; B929 A7                       .
        sta     $A8,x                           ; B92A 95 A8                    ..
        lda     #$95                            ; B92C A9 95                    ..
        tay                                     ; B92E A8                       .
        lda     #$9B                            ; B92F A9 9B                    ..
        .byte   $9B                             ; B931 9B                       .
        txs                                     ; B932 9A                       .
        .byte   $9B                             ; B933 9B                       .
        .byte   $9B                             ; B934 9B                       .
        txs                                     ; B935 9A                       .
        .byte   $9B                             ; B936 9B                       .
        .byte   $9B                             ; B937 9B                       .
        tax                                     ; B938 AA                       .
        .byte   $9F                             ; B939 9F                       .
        ldy     #$AA                            ; B93A A0 AA                    ..
        .byte   $9F                             ; B93C 9F                       .
        ldy     #$9F                            ; B93D A0 9F                    ..
        ldy     #$7F                            ; B93F A0 7F                    ..
        php                                     ; B941 08                       .
        ora     ($12),y                         ; B942 11 12                    ..
        php                                     ; B944 08                       .
        .byte   $13                             ; B945 13                       .
        php                                     ; B946 08                       .
        lsr     $A4,x                           ; B947 56 A4                    V.
        ror     $A4                             ; B949 66 A4                    f.
        ror     $A4                             ; B94B 66 A4                    f.
        .byte   $AB                             ; B94D AB                       .
        php                                     ; B94E 08                       .
        lsr     $08,x                           ; B94F 56 08                    V.
        ora     ($12),y                         ; B951 11 12                    ..
        php                                     ; B953 08                       .
        php                                     ; B954 08                       .
        .byte   $83                             ; B955 83                       .
        php                                     ; B956 08                       .
        lsr     $66,x                           ; B957 56 66                    Vf
        ldy     $A5                             ; B959 A4 A5                    ..
        ror     $A4                             ; B95B 66 A4                    f.
        .byte   $AB                             ; B95D AB                       .
        lsr     $0856,x                         ; B95E 5E 56 08                 ^V.
        php                                     ; B961 08                       .
        .byte   $13                             ; B962 13                       .
        php                                     ; B963 08                       .
        php                                     ; B964 08                       .
        asl     $08,x                           ; B965 16 08                    ..
        lsr     $95,x                           ; B967 56 95                    V.
        tay                                     ; B969 A8                       .
        lda     #$95                            ; B96A A9 95                    ..
        tay                                     ; B96C A8                       .
        sta     $A8,x                           ; B96D 95 A8                    ..
        ldy     $9B9A                           ; B96F AC 9A 9B                 ...
        .byte   $9B                             ; B972 9B                       .
        txs                                     ; B973 9A                       .
        .byte   $9B                             ; B974 9B                       .
        .byte   $9B                             ; B975 9B                       .
        txs                                     ; B976 9A                       .
        lda     $9FAA                           ; B977 AD AA 9F                 ...
        .byte   $9F                             ; B97A 9F                       .
        ldy     #$9F                            ; B97B A0 9F                    ..
        ldy     #$9F                            ; B97D A0 9F                    ..
        ldx     $4F08                           ; B97F AE 08 4F                 ..O
        php                                     ; B982 08                       .
        php                                     ; B983 08                       .
        php                                     ; B984 08                       .
        php                                     ; B985 08                       .
        php                                     ; B986 08                       .
        lsr     LAF11                           ; B987 4E 11 AF                 N..
        php                                     ; B98A 08                       .
        php                                     ; B98B 08                       .
        php                                     ; B98C 08                       .
        php                                     ; B98D 08                       .
        .byte   $57                             ; B98E 57                       W
        cli                                     ; B98F 58                       X
        php                                     ; B990 08                       .
        .byte   $4F                             ; B991 4F                       O
        php                                     ; B992 08                       .
        php                                     ; B993 08                       .
        ora     ($12),y                         ; B994 11 12                    ..
        .byte   $5C                             ; B996 5C                       \
        eor     $4F08,x                         ; B997 5D 08 4F                 ].O
        php                                     ; B99A 08                       .
        php                                     ; B99B 08                       .
        php                                     ; B99C 08                       .
        php                                     ; B99D 08                       .
        php                                     ; B99E 08                       .
        asl     a                               ; B99F 0A                       .
        .byte   $2F                             ; B9A0 2F                       /
        bcs     LB9B9                           ; B9A1 B0 16                    ..
        php                                     ; B9A3 08                       .
        php                                     ; B9A4 08                       .
        .byte   $13                             ; B9A5 13                       .
        php                                     ; B9A6 08                       .
        .byte   $57                             ; B9A7 57                       W
        ora     $081C,y                         ; B9A8 19 1C 08                 ...
        php                                     ; B9AB 08                       .
        php                                     ; B9AC 08                       .
        php                                     ; B9AD 08                       .
        php                                     ; B9AE 08                       .
        .byte   $5C                             ; B9AF 5C                       \
        asl     $98B1,x                         ; B9B0 1E B1 98                 ...
        sta     $85                             ; B9B3 85 85                    ..
        tya                                     ; B9B5 98                       .
        .byte   $B2                             ; B9B6 B2                       .
        .byte   $92                             ; B9B7 92                       .
        .byte   $A0                             ; B9B8 A0                       .
LB9B9:  ldy     #$9F                            ; B9B9 A0 9F                    ..
        ldy     #$A0                            ; B9BB A0 A0                    ..
        .byte   $9F                             ; B9BD 9F                       .
        .byte   $B3                             ; B9BE B3                       .
        lsr     L0000,x                         ; B9BF 56 00                    V.
        brk                                     ; B9C1 00                       .
        brk                                     ; B9C2 00                       .
        brk                                     ; B9C3 00                       .
        brk                                     ; B9C4 00                       .
        brk                                     ; B9C5 00                       .
        brk                                     ; B9C6 00                       .
        brk                                     ; B9C7 00                       .
        brk                                     ; B9C8 00                       .
        brk                                     ; B9C9 00                       .
        brk                                     ; B9CA 00                       .
        brk                                     ; B9CB 00                       .
        brk                                     ; B9CC 00                       .
        brk                                     ; B9CD 00                       .
        brk                                     ; B9CE 00                       .
        brk                                     ; B9CF 00                       .
        brk                                     ; B9D0 00                       .
        brk                                     ; B9D1 00                       .
        brk                                     ; B9D2 00                       .
        brk                                     ; B9D3 00                       .
        brk                                     ; B9D4 00                       .
        ora     L0000                           ; B9D5 05 00                    ..
        .byte   $93                             ; B9D7 93                       .
        brk                                     ; B9D8 00                       .
        ora     L0000                           ; B9D9 05 00                    ..
        .byte   $03                             ; B9DB 03                       .
        .byte   $04                             ; B9DC 04                       .
        brk                                     ; B9DD 00                       .
        .byte   $7B                             ; B9DE 7B                       {
        ora     $0C0B                           ; B9DF 0D 0B 0C                 ...
        ora     $7170                           ; B9E2 0D 70 71                 .pq
        .byte   $72                             ; B9E5 72                       r
        .byte   $7F                             ; B9E6 7F                       .
        php                                     ; B9E7 08                       .
        .byte   $3C                             ; B9E8 3C                       <
        bpl     LB9F3                           ; B9E9 10 08                    ..
        php                                     ; B9EB 08                       .
        php                                     ; B9EC 08                       .
        php                                     ; B9ED 08                       .
        php                                     ; B9EE 08                       .
        php                                     ; B9EF 08                       .
        php                                     ; B9F0 08                       .
        .byte   $59                             ; B9F1 59                       Y
        .byte   $B4                             ; B9F2 B4                       .
LB9F3:  sta     $98                             ; B9F3 85 98                    ..
        tya                                     ; B9F5 98                       .
        sta     $85                             ; B9F6 85 85                    ..
        php                                     ; B9F8 08                       .
        .byte   $4F                             ; B9F9 4F                       O
        .byte   $9E                             ; B9FA 9E                       .
        ldy     #$9F                            ; B9FB A0 9F                    ..
        .byte   $9F                             ; B9FD 9F                       .
        ldy     #$AA                            ; B9FE A0 AA                    ..
        brk                                     ; BA00 00                       .
        brk                                     ; BA01 00                       .
        brk                                     ; BA02 00                       .
        brk                                     ; BA03 00                       .
        brk                                     ; BA04 00                       .
        brk                                     ; BA05 00                       .
        brk                                     ; BA06 00                       .
        brk                                     ; BA07 00                       .
        brk                                     ; BA08 00                       .
        brk                                     ; BA09 00                       .
        brk                                     ; BA0A 00                       .
        brk                                     ; BA0B 00                       .
        brk                                     ; BA0C 00                       .
        brk                                     ; BA0D 00                       .
        brk                                     ; BA0E 00                       .
        brk                                     ; BA0F 00                       .
        .byte   $03                             ; BA10 03                       .
        .byte   $04                             ; BA11 04                       .
        brk                                     ; BA12 00                       .
        brk                                     ; BA13 00                       .
        brk                                     ; BA14 00                       .
        brk                                     ; BA15 00                       .
        brk                                     ; BA16 00                       .
        ora     (L0070,x)                       ; BA17 01 70                    .p
        adc     ($04),y                         ; BA19 71 04                    q.
        brk                                     ; BA1B 00                       .
        ora     L0000                           ; BA1C 05 00                    ..
        asl     $07                             ; BA1E 06 07                    ..
        php                                     ; BA20 08                       .
        php                                     ; BA21 08                       .
        asl     a                               ; BA22 0A                       .
        .byte   $0B                             ; BA23 0B                       .
        .byte   $0C                             ; BA24 0C                       .
        ora     $080E                           ; BA25 0D 0E 08                 ...
        lsr     $0808,x                         ; BA28 5E 08 08                 ^..
        .byte   $3C                             ; BA2B 3C                       <
        bpl     LBA36                           ; BA2C 10 08                    ..
        php                                     ; BA2E 08                       .
        php                                     ; BA2F 08                       .
        tya                                     ; BA30 98                       .
        .byte   $B2                             ; BA31 B2                       .
        php                                     ; BA32 08                       .
        lda     $B5,x                           ; BA33 B5 B5                    ..
        .byte   $B5                             ; BA35 B5                       .
LBA36:  lda     $B5,x                           ; BA36 B5 B5                    ..
        ldy     #$B3                            ; BA38 A0 B3                    ..
        php                                     ; BA3A 08                       .
        php                                     ; BA3B 08                       .
        php                                     ; BA3C 08                       .
        ora     ($12),y                         ; BA3D 11 12                    ..
        php                                     ; BA3F 08                       .
        brk                                     ; BA40 00                       .
        brk                                     ; BA41 00                       .
        brk                                     ; BA42 00                       .
        brk                                     ; BA43 00                       .
        brk                                     ; BA44 00                       .
        brk                                     ; BA45 00                       .
        brk                                     ; BA46 00                       .
        ora     (L0000,x)                       ; BA47 01 00                    ..
        .byte   $03                             ; BA49 03                       .
        .byte   $04                             ; BA4A 04                       .
        brk                                     ; BA4B 00                       .
        brk                                     ; BA4C 00                       .
        brk                                     ; BA4D 00                       .
        asl     $07                             ; BA4E 06 07                    ..
        ora     $0A70                           ; BA50 0D 70 0A                 .p.
        .byte   $0B                             ; BA53 0B                       .
        .byte   $0C                             ; BA54 0C                       .
        ora     $080E                           ; BA55 0D 0E 08                 ...
        php                                     ; BA58 08                       .
        php                                     ; BA59 08                       .
        php                                     ; BA5A 08                       .
        .byte   $3C                             ; BA5B 3C                       <
        bpl     LBA66                           ; BA5C 10 08                    ..
        php                                     ; BA5E 08                       .
        php                                     ; BA5F 08                       .
        php                                     ; BA60 08                       .
        php                                     ; BA61 08                       .
        php                                     ; BA62 08                       .
        php                                     ; BA63 08                       .
        .byte   $2E                             ; BA64 2E                       .
        .byte   $2F                             ; BA65 2F                       /
LBA66:  php                                     ; BA66 08                       .
        php                                     ; BA67 08                       .
        php                                     ; BA68 08                       .
        lsr     $0808,x                         ; BA69 5E 08 08                 ^..
        php                                     ; BA6C 08                       .
        php                                     ; BA6D 08                       .
        php                                     ; BA6E 08                       .
        php                                     ; BA6F 08                       .
        lda     $B5,x                           ; BA70 B5 B5                    ..
        lda     $B5,x                           ; BA72 B5 B5                    ..
        php                                     ; BA74 08                       .
        lda     $B5,x                           ; BA75 B5 B5                    ..
        lda     $08,x                           ; BA77 B5 08                    ..
        php                                     ; BA79 08                       .
        php                                     ; BA7A 08                       .
        ldx     $54,y                           ; BA7B B6 54                    .T
        sta     ($B7),y                         ; BA7D 91 B7                    ..
        php                                     ; BA7F 08                       .
        ora     $0A70                           ; BA80 0D 70 0A                 .p.
        .byte   $0B                             ; BA83 0B                       .
        .byte   $0C                             ; BA84 0C                       .
        ora     LB80E                           ; BA85 0D 0E B8                 ...
        php                                     ; BA88 08                       .
        php                                     ; BA89 08                       .
        php                                     ; BA8A 08                       .
        .byte   $3C                             ; BA8B 3C                       <
        bpl     LBA96                           ; BA8C 10 08                    ..
        php                                     ; BA8E 08                       .
        lda     $1108,y                         ; BA8F B9 08 11                 ...
        .byte   $12                             ; BA92 12                       .
        php                                     ; BA93 08                       .
        php                                     ; BA94 08                       .
        php                                     ; BA95 08                       .
LBA96:  php                                     ; BA96 08                       .
        clv                                     ; BA97 B8                       .
        php                                     ; BA98 08                       .
        php                                     ; BA99 08                       .
        php                                     ; BA9A 08                       .
        php                                     ; BA9B 08                       .
        php                                     ; BA9C 08                       .
        php                                     ; BA9D 08                       .
        php                                     ; BA9E 08                       .
        lda     $0808,y                         ; BA9F B9 08 08                 ...
        php                                     ; BAA2 08                       .
        php                                     ; BAA3 08                       .
        php                                     ; BAA4 08                       .
        php                                     ; BAA5 08                       .
        ora     ($12),y                         ; BAA6 11 12                    ..
        php                                     ; BAA8 08                       .
        php                                     ; BAA9 08                       .
        php                                     ; BAAA 08                       .
        php                                     ; BAAB 08                       .
        php                                     ; BAAC 08                       .
        php                                     ; BAAD 08                       .
        php                                     ; BAAE 08                       .
        php                                     ; BAAF 08                       .
        lda     $B5,x                           ; BAB0 B5 B5                    ..
        .byte   $13                             ; BAB2 13                       .
        tsx                                     ; BAB3 BA                       .
        lda     $B5,x                           ; BAB4 B5 B5                    ..
        php                                     ; BAB6 08                       .
        .byte   $83                             ; BAB7 83                       .
        php                                     ; BAB8 08                       .
        php                                     ; BAB9 08                       .
        php                                     ; BABA 08                       .
        ldx     $54,y                           ; BABB B6 54                    .T
        sta     ($B7),y                         ; BABD 91 B7                    ..
        .byte   $83                             ; BABF 83                       .
        .byte   $22                             ; BAC0 22                       "
        php                                     ; BAC1 08                       .
        php                                     ; BAC2 08                       .
        php                                     ; BAC3 08                       .
        .byte   $BB                             ; BAC4 BB                       .
        ldy     LBDBC,x                         ; BAC5 BC BC BD                 ...
        .byte   $22                             ; BAC8 22                       "
        ora     ($12),y                         ; BAC9 11 12                    ..
        php                                     ; BACB 08                       .
        ldx     LBFBF,y                         ; BACC BE BF BF                 ...
        cpy     #$22                            ; BACF C0 22                    ."
        php                                     ; BAD1 08                       .
        php                                     ; BAD2 08                       .
        php                                     ; BAD3 08                       .
        ora     ($12),y                         ; BAD4 11 12                    ..
        php                                     ; BAD6 08                       .
        .byte   $23                             ; BAD7 23                       #
        cmp     ($C2,x)                         ; BAD8 C1 C2                    ..
        .byte   $C2                             ; BADA C2                       .
        .byte   $C2                             ; BADB C2                       .
        .byte   $C2                             ; BADC C2                       .
        .byte   $5B                             ; BADD 5B                       [
        .byte   $13                             ; BADE 13                       .
        .byte   $23                             ; BADF 23                       #
        .byte   $C3                             ; BAE0 C3                       .
        cpy     $C4                             ; BAE1 C4 C4                    ..
        cpy     $C4                             ; BAE3 C4 C4                    ..
        php                                     ; BAE5 08                       .
        php                                     ; BAE6 08                       .
        .byte   $23                             ; BAE7 23                       #
        .byte   $22                             ; BAE8 22                       "
        php                                     ; BAE9 08                       .
        php                                     ; BAEA 08                       .
        asl     $08,x                           ; BAEB 16 08                    ..
        php                                     ; BAED 08                       .
        php                                     ; BAEE 08                       .
        .byte   $23                             ; BAEF 23                       #
        bit     $25                             ; BAF0 24 25                    $%
        rol     $27                             ; BAF2 26 27                    &'
        and     $26                             ; BAF4 25 26                    %&
        .byte   $27                             ; BAF6 27                       '
        plp                                     ; BAF7 28                       (
        and     #$2A                            ; BAF8 29 2A                    )*
        .byte   $2B                             ; BAFA 2B                       +
        bit     $2B2A                           ; BAFB 2C 2A 2B                 ,*+
        bit     $222D                           ; BAFE 2C 2D 22                 ,-"
        php                                     ; BB01 08                       .
        php                                     ; BB02 08                       .
        cmp     $C4                             ; BB03 C5 C4                    ..
        cpy     $C4                             ; BB05 C4 C4                    ..
        dec     $C1                             ; BB07 C6 C1                    ..
        .byte   $C2                             ; BB09 C2                       .
        .byte   $C2                             ; BB0A C2                       .
        .byte   $5B                             ; BB0B 5B                       [
        rts                                     ; BB0C 60                       `

; ----------------------------------------------------------------------------
        .byte   $C2                             ; BB0D C2                       .
        .byte   $C2                             ; BB0E C2                       .
        .byte   $C7                             ; BB0F C7                       .
        .byte   $C3                             ; BB10 C3                       .
        cpy     $C4                             ; BB11 C4 C4                    ..
        ora     ($12),y                         ; BB13 11 12                    ..
        cpy     $C4                             ; BB15 C4 C4                    ..
        dec     $22                             ; BB17 C6 22                    ."
        rts                                     ; BB19 60                       `

; ----------------------------------------------------------------------------
        .byte   $C2                             ; BB1A C2                       .
        .byte   $C2                             ; BB1B C2                       .
        .byte   $C2                             ; BB1C C2                       .
        .byte   $C2                             ; BB1D C2                       .
        .byte   $5B                             ; BB1E 5B                       [
        .byte   $23                             ; BB1F 23                       #
        .byte   $22                             ; BB20 22                       "
        asl     $C4,x                           ; BB21 16 C4                    ..
        cpy     $C4                             ; BB23 C4 C4                    ..
        cpy     $08                             ; BB25 C4 08                    ..
        .byte   $23                             ; BB27 23                       #
        .byte   $22                             ; BB28 22                       "
        iny                                     ; BB29 C8                       .
        ldy     $08C9,x                         ; BB2A BC C9 08                 ...
        iny                                     ; BB2D C8                       .
        ldy     $22BD,x                         ; BB2E BC BD 22                 .."
        php                                     ; BB31 08                       .
        .byte   $BF                             ; BB32 BF                       .
        dex                                     ; BB33 CA                       .
        ora     ($12),y                         ; BB34 11 12                    ..
        .byte   $BF                             ; BB36 BF                       .
        cpy     #$22                            ; BB37 C0 22                    ."
        php                                     ; BB39 08                       .
        php                                     ; BB3A 08                       .
        php                                     ; BB3B 08                       .
        php                                     ; BB3C 08                       .
        php                                     ; BB3D 08                       .
        php                                     ; BB3E 08                       .
        .byte   $23                             ; BB3F 23                       #
        brk                                     ; BB40 00                       .
        .byte   $03                             ; BB41 03                       .
        .byte   $04                             ; BB42 04                       .
        brk                                     ; BB43 00                       .
        .byte   $7B                             ; BB44 7B                       {
        ora     $230E                           ; BB45 0D 0E 23                 ..#
        ora     $7170                           ; BB48 0D 70 71                 .pq
        .byte   $72                             ; BB4B 72                       r
        .byte   $7F                             ; BB4C 7F                       .
        php                                     ; BB4D 08                       .
        php                                     ; BB4E 08                       .
        .byte   $23                             ; BB4F 23                       #
        .byte   $22                             ; BB50 22                       "
        php                                     ; BB51 08                       .
        php                                     ; BB52 08                       .
        php                                     ; BB53 08                       .
        php                                     ; BB54 08                       .
        php                                     ; BB55 08                       .
        php                                     ; BB56 08                       .
        .byte   $23                             ; BB57 23                       #
        .byte   $22                             ; BB58 22                       "
        php                                     ; BB59 08                       .
        php                                     ; BB5A 08                       .
        php                                     ; BB5B 08                       .
        php                                     ; BB5C 08                       .
        ora     ($12),y                         ; BB5D 11 12                    ..
        .byte   $23                             ; BB5F 23                       #
        .byte   $22                             ; BB60 22                       "
        asl     $08,x                           ; BB61 16 08                    ..
        php                                     ; BB63 08                       .
        php                                     ; BB64 08                       .
        php                                     ; BB65 08                       .
        php                                     ; BB66 08                       .
        .byte   $23                             ; BB67 23                       #
        .byte   $22                             ; BB68 22                       "
        php                                     ; BB69 08                       .
        php                                     ; BB6A 08                       .
        .byte   $CB                             ; BB6B CB                       .
        cpy     $9885                           ; BB6C CC 85 98                 ...
        cmp     $6022                           ; BB6F CD 22 60                 ."`
        .byte   $C2                             ; BB72 C2                       .
        dec     $CFCF                           ; BB73 CE CF CF                 ...
        .byte   $CF                             ; BB76 CF                       .
        bne     LBB9B                           ; BB77 D0 22                    ."
        php                                     ; BB79 08                       .
        cpy     $D1                             ; BB7A C4 D1                    ..
        .byte   $BF                             ; BB7C BF                       .
        .byte   $BF                             ; BB7D BF                       .
        .byte   $BF                             ; BB7E BF                       .
        cpy     #$3C                            ; BB7F C0 3C                    .<
        and     a:$04,x                         ; BB81 3D 04 00                 =..
        ora     L0000                           ; BB84 05 00                    ..
        .byte   $03                             ; BB86 03                       .
        .byte   $04                             ; BB87 04                       .
        php                                     ; BB88 08                       .
        php                                     ; BB89 08                       .
        asl     a                               ; BB8A 0A                       .
        .byte   $0B                             ; BB8B 0B                       .
        .byte   $0C                             ; BB8C 0C                       .
        ora     $7170                           ; BB8D 0D 70 71                 .pq
        php                                     ; BB90 08                       .
        php                                     ; BB91 08                       .
        php                                     ; BB92 08                       .
        .byte   $0F                             ; BB93 0F                       .
        bpl     LBB9E                           ; BB94 10 08                    ..
        php                                     ; BB96 08                       .
        php                                     ; BB97 08                       .
        php                                     ; BB98 08                       .
        ora     ($12),y                         ; BB99 11 12                    ..
LBB9B:  clv                                     ; BB9B B8                       .
        php                                     ; BB9C 08                       .
        php                                     ; BB9D 08                       .
LBB9E:  php                                     ; BB9E 08                       .
        php                                     ; BB9F 08                       .
        php                                     ; BBA0 08                       .
        php                                     ; BBA1 08                       .
        .byte   $D2                             ; BBA2 D2                       .
        lda     $6308,y                         ; BBA3 B9 08 63                 ..c
        .byte   $64                             ; BBA6 64                       d
        adc     $D3                             ; BBA7 65 D3                    e.
        .byte   $1C                             ; BBA9 1C                       .
        .byte   $D4                             ; BBAA D4                       .
        lda     $0813,y                         ; BBAB B9 13 08                 ...
        php                                     ; BBAE 08                       .
        php                                     ; BBAF 08                       .
        adc     $D421,y                         ; BBB0 79 21 D4                 y!.
        lda     $4608,y                         ; BBB3 B9 08 46                 ..F
        .byte   $47                             ; BBB6 47                       G
        php                                     ; BBB7 08                       .
        php                                     ; BBB8 08                       .
        php                                     ; BBB9 08                       .
        .byte   $D4                             ; BBBA D4                       .
        lda     $4B4E,y                         ; BBBB B9 4E 4B                 .NK
        jmp     L004D                           ; BBBE 4C 4D 00                 LM.

; ----------------------------------------------------------------------------
        .byte   $7B                             ; BBC1 7B                       {
        .byte   $7C                             ; BBC2 7C                       |
        adc     ($72),y                         ; BBC3 71 72                    qr
        .byte   $7F                             ; BBC5 7F                       .
        .byte   $3C                             ; BBC6 3C                       <
        and     $7F72,x                         ; BBC7 3D 72 7F                 =r.
        php                                     ; BBCA 08                       .
        php                                     ; BBCB 08                       .
        php                                     ; BBCC 08                       .
        php                                     ; BBCD 08                       .
        php                                     ; BBCE 08                       .
        php                                     ; BBCF 08                       .
        php                                     ; BBD0 08                       .
        php                                     ; BBD1 08                       .
        php                                     ; BBD2 08                       .
        lsr     $0808,x                         ; BBD3 5E 08 08                 ^..
        php                                     ; BBD6 08                       .
        php                                     ; BBD7 08                       .
        asl     $08,x                           ; BBD8 16 08                    ..
        php                                     ; BBDA 08                       .
        php                                     ; BBDB 08                       .
        php                                     ; BBDC 08                       .
        .byte   $13                             ; BBDD 13                       .
        php                                     ; BBDE 08                       .
        php                                     ; BBDF 08                       .
        php                                     ; BBE0 08                       .
        .byte   $D2                             ; BBE1 D2                       .
        php                                     ; BBE2 08                       .
        php                                     ; BBE3 08                       .
        php                                     ; BBE4 08                       .
        php                                     ; BBE5 08                       .
        php                                     ; BBE6 08                       .
        php                                     ; BBE7 08                       .
        php                                     ; BBE8 08                       .
        .byte   $D4                             ; BBE9 D4                       .
        php                                     ; BBEA 08                       .
        ora     ($12),y                         ; BBEB 11 12                    ..
        cmp     $D6,x                           ; BBED D5 D6                    ..
        .byte   $D7                             ; BBEF D7                       .
        php                                     ; BBF0 08                       .
        .byte   $D4                             ; BBF1 D4                       .
        cld                                     ; BBF2 D8                       .
        .byte   $34                             ; BBF3 34                       4
        .byte   $1A                             ; BBF4 1A                       .
        .byte   $1B                             ; BBF5 1B                       .
        dey                                     ; BBF6 88                       .
        .byte   $34                             ; BBF7 34                       4
        php                                     ; BBF8 08                       .
        .byte   $D4                             ; BBF9 D4                       .
        cmp     $1F20,y                         ; BBFA D9 20 1F                 . .
        jsr     L201F                           ; BBFD 20 1F 20                  . 
        rol     $0403,x                         ; BC00 3E 03 04                 >..
        brk                                     ; BC03 00                       .
        ora     L0000                           ; BC04 05 00                    ..
        asl     $07                             ; BC06 06 07                    ..
        .byte   $3F                             ; BC08 3F                       ?
        ora     #$0A                            ; BC09 09 0A                    ..
        .byte   $0B                             ; BC0B 0B                       .
        .byte   $0C                             ; BC0C 0C                       .
        ora     $080E                           ; BC0D 0D 0E 08                 ...
        php                                     ; BC10 08                       .
        php                                     ; BC11 08                       .
        php                                     ; BC12 08                       .
        .byte   $0F                             ; BC13 0F                       .
        bpl     LBC1E                           ; BC14 10 08                    ..
        php                                     ; BC16 08                       .
        .byte   $13                             ; BC17 13                       .
        lsr     $0808,x                         ; BC18 5E 08 08                 ^..
        php                                     ; BC1B 08                       .
        .byte   $DA                             ; BC1C DA                       .
        .byte   $DB                             ; BC1D DB                       .
LBC1E:  php                                     ; BC1E 08                       .
        php                                     ; BC1F 08                       .
        php                                     ; BC20 08                       .
        php                                     ; BC21 08                       .
        .byte   $DA                             ; BC22 DA                       .
        .byte   $DC                             ; BC23 DC                       .
        .byte   $DC                             ; BC24 DC                       .
        cmp     $0808,x                         ; BC25 DD 08 08                 ...
        .byte   $DC                             ; BC28 DC                       .
        .byte   $DC                             ; BC29 DC                       .
        dec     $DBDC,x                         ; BC2A DE DC DB                 ...
        php                                     ; BC2D 08                       .
        php                                     ; BC2E 08                       .
        php                                     ; BC2F 08                       .
        ora     $341B,y                         ; BC30 19 1B 34                 ..4
        ora     $0889,y                         ; BC33 19 89 08                 ...
        adc     $19,x                           ; BC36 75 19                    u.
        .byte   $DF                             ; BC38 DF                       .
        .byte   $1F                             ; BC39 1F                       .
        jsr     L8BDF                           ; BC3A 20 DF 8B                  ..
        php                                     ; BC3D 08                       .
        adc     $E0DF,y                         ; BC3E 79 DF E0                 y..
        sbc     ($E1,x)                         ; BC41 E1 E1                    ..
        .byte   $E2                             ; BC43 E2                       .
        .byte   $E3                             ; BC44 E3                       .
        php                                     ; BC45 08                       .
        cpx     $9B                             ; BC46 E4 9B                    ..
        sta     $E5                             ; BC48 85 E5                    ..
        sta     $E6                             ; BC4A 85 E6                    ..
        php                                     ; BC4C 08                       .
        php                                     ; BC4D 08                       .
        .byte   $E7                             ; BC4E E7                       .
        inx                                     ; BC4F E8                       .
        .byte   $9B                             ; BC50 9B                       .
        .byte   $9B                             ; BC51 9B                       .
        sbc     #$08                            ; BC52 E9 08                    ..
        php                                     ; BC54 08                       .
        nop                                     ; BC55 EA                       .
        .byte   $9B                             ; BC56 9B                       .
        txs                                     ; BC57 9A                       .
        ora     $081C,y                         ; BC58 19 1C 08                 ...
        php                                     ; BC5B 08                       .
        .byte   $EB                             ; BC5C EB                       .
        .byte   $34                             ; BC5D 34                       4
        .byte   $1A                             ; BC5E 1A                       .
        .byte   $1B                             ; BC5F 1B                       .
        asl     $08EC,x                         ; BC60 1E EC 08                 ...
        php                                     ; BC63 08                       .
        sbc     $EEEE                           ; BC64 ED EE EE                 ...
        .byte   $EF                             ; BC67 EF                       .
        .byte   $9B                             ; BC68 9B                       .
        beq     LBC73                           ; BC69 F0 08                    ..
        php                                     ; BC6B 08                       .
        php                                     ; BC6C 08                       .
        php                                     ; BC6D 08                       .
        php                                     ; BC6E 08                       .
        sbc     ($19),y                         ; BC6F F1 19                    ..
        .byte   $1A                             ; BC71 1A                       .
        .byte   $1B                             ; BC72 1B                       .
LBC73:  ora     $1A34,y                         ; BC73 19 34 1A                 .4.
        ora     $1E34,y                         ; BC76 19 34 1E                 .4.
        .byte   $F2                             ; BC79 F2                       .
        .byte   $F2                             ; BC7A F2                       .
        asl     $F2F2,x                         ; BC7B 1E F2 F2                 ...
        .byte   $1E                             ; BC7E 1E                       .
        .byte   $F2                             ; BC7F F2                       .
LBC80:  .byte   $F3                             ; BC80 F3                       .
        php                                     ; BC81 08                       .
        php                                     ; BC82 08                       .
        .byte   $F4                             ; BC83 F4                       .
        txs                                     ; BC84 9A                       .
        .byte   $9B                             ; BC85 9B                       .
        txs                                     ; BC86 9A                       .
        .byte   $9B                             ; BC87 9B                       .
        sbc     $47,x                           ; BC88 F5 47                    .G
        txa                                     ; BC8A 8A                       .
        .byte   $14                             ; BC8B 14                       .
        ora     $46,x                           ; BC8C 15 46                    .F
        .byte   $47                             ; BC8E 47                       G
        php                                     ; BC8F 08                       .
        sbc     #$4C                            ; BC90 E9 4C                    .L
        cli                                     ; BC92 58                       X
        brk                                     ; BC93 00                       .
        bcc     LBC80                           ; BC94 90 EA                    ..
        txs                                     ; BC96 9A                       .
        .byte   $9B                             ; BC97 9B                       .
        .byte   $34                             ; BC98 34                       4
        .byte   $1A                             ; BC99 1A                       .
        .byte   $1B                             ; BC9A 1B                       .
        .byte   $34                             ; BC9B 34                       4
        .byte   $34                             ; BC9C 34                       4
        .byte   $1A                             ; BC9D 1A                       .
        .byte   $1B                             ; BC9E 1B                       .
        .byte   $34                             ; BC9F 34                       4
        inc     $EEEE                           ; BCA0 EE EE EE                 ...
        inc     $EEEE                           ; BCA3 EE EE EE                 ...
        inc     $08EF                           ; BCA6 EE EF 08                 ...
        php                                     ; BCA9 08                       .
        php                                     ; BCAA 08                       .
        php                                     ; BCAB 08                       .
        php                                     ; BCAC 08                       .
        php                                     ; BCAD 08                       .
        php                                     ; BCAE 08                       .
        sbc     ($34),y                         ; BCAF F1 34                    .4
        ora     $341B,y                         ; BCB1 19 1B 34                 ..4
        .byte   $34                             ; BCB4 34                       4
        .byte   $1A                             ; BCB5 1A                       .
        .byte   $1B                             ; BCB6 1B                       .
        .byte   $34                             ; BCB7 34                       4
        .byte   $F2                             ; BCB8 F2                       .
        asl     $F2F2,x                         ; BCB9 1E F2 F2                 ...
        .byte   $F2                             ; BCBC F2                       .
        .byte   $F2                             ; BCBD F2                       .
        .byte   $F2                             ; BCBE F2                       .
        .byte   $F2                             ; BCBF F2                       .
        inc     $17,x                           ; BCC0 F6 17                    ..
        .byte   $17                             ; BCC2 17                       .
        .byte   $17                             ; BCC3 17                       .
        .byte   $17                             ; BCC4 17                       .
        .byte   $17                             ; BCC5 17                       .
        .byte   $17                             ; BCC6 17                       .
        .byte   $17                             ; BCC7 17                       .
        .byte   $F7                             ; BCC8 F7                       .
        brk                                     ; BCC9 00                       .
        brk                                     ; BCCA 00                       .
        brk                                     ; BCCB 00                       .
        brk                                     ; BCCC 00                       .
        brk                                     ; BCCD 00                       .
        brk                                     ; BCCE 00                       .
        sed                                     ; BCCF F8                       .
        sbc     $727B,y                         ; BCD0 F9 7B 72                 .{r
        .byte   $0B                             ; BCD3 0B                       .
        brk                                     ; BCD4 00                       .
        brk                                     ; BCD5 00                       .
        brk                                     ; BCD6 00                       .
        sed                                     ; BCD7 F8                       .
        .byte   $FA                             ; BCD8 FA                       .
        .byte   $7F                             ; BCD9 7F                       .
        php                                     ; BCDA 08                       .
        .byte   $0F                             ; BCDB 0F                       .
        and     $033E,x                         ; BCDC 3D 3E 03                 =>.
        .byte   $FB                             ; BCDF FB                       .
        .byte   $FC                             ; BCE0 FC                       .
        php                                     ; BCE1 08                       .
        php                                     ; BCE2 08                       .
        php                                     ; BCE3 08                       .
        php                                     ; BCE4 08                       .
        .byte   $3F                             ; BCE5 3F                       ?
        ora     #$FD                            ; BCE6 09 FD                    ..
        php                                     ; BCE8 08                       .
        php                                     ; BCE9 08                       .
        php                                     ; BCEA 08                       .
        php                                     ; BCEB 08                       .
        php                                     ; BCEC 08                       .
        php                                     ; BCED 08                       .
        php                                     ; BCEE 08                       .
        inc     $1934,x                         ; BCEF FE 34 19                 .4.
        .byte   $1B                             ; BCF2 1B                       .
        .byte   $34                             ; BCF3 34                       4
        .byte   $34                             ; BCF4 34                       4
        .byte   $1A                             ; BCF5 1A                       .
        ora     $F234,y                         ; BCF6 19 34 F2                 .4.
        asl     $F2F2,x                         ; BCF9 1E F2 F2                 ...
        .byte   $F2                             ; BCFC F2                       .
        .byte   $F2                             ; BCFD F2                       .
        asl     $22F2,x                         ; BCFE 1E F2 22                 .."
        php                                     ; BD01 08                       .
        php                                     ; BD02 08                       .
        php                                     ; BD03 08                       .
        php                                     ; BD04 08                       .
        php                                     ; BD05 08                       .
        asl     L0023,x                         ; BD06 16 23                    .#
        .byte   $22                             ; BD08 22                       "
        ora     ($12),y                         ; BD09 11 12                    ..
        php                                     ; BD0B 08                       .
        php                                     ; BD0C 08                       .
        php                                     ; BD0D 08                       .
        php                                     ; BD0E 08                       .
        .byte   $23                             ; BD0F 23                       #
        .byte   $22                             ; BD10 22                       "
        php                                     ; BD11 08                       .
        php                                     ; BD12 08                       .
        asl     $08,x                           ; BD13 16 08                    ..
        php                                     ; BD15 08                       .
        php                                     ; BD16 08                       .
        .byte   $23                             ; BD17 23                       #
        .byte   $22                             ; BD18 22                       "
        php                                     ; BD19 08                       .
        php                                     ; BD1A 08                       .
        php                                     ; BD1B 08                       .
        php                                     ; BD1C 08                       .
        php                                     ; BD1D 08                       .
        php                                     ; BD1E 08                       .
        .byte   $23                             ; BD1F 23                       #
        .byte   $22                             ; BD20 22                       "
        php                                     ; BD21 08                       .
        ora     ($12),y                         ; BD22 11 12                    ..
        php                                     ; BD24 08                       .
        .byte   $13                             ; BD25 13                       .
        php                                     ; BD26 08                       .
        .byte   $23                             ; BD27 23                       #
        .byte   $22                             ; BD28 22                       "
        php                                     ; BD29 08                       .
        php                                     ; BD2A 08                       .
        php                                     ; BD2B 08                       .
        php                                     ; BD2C 08                       .
        php                                     ; BD2D 08                       .
        php                                     ; BD2E 08                       .
        .byte   $23                             ; BD2F 23                       #
        .byte   $22                             ; BD30 22                       "
        php                                     ; BD31 08                       .
        php                                     ; BD32 08                       .
        php                                     ; BD33 08                       .
        php                                     ; BD34 08                       .
        php                                     ; BD35 08                       .
        php                                     ; BD36 08                       .
        .byte   $23                             ; BD37 23                       #
        .byte   $22                             ; BD38 22                       "
        php                                     ; BD39 08                       .
        php                                     ; BD3A 08                       .
        php                                     ; BD3B 08                       .
        php                                     ; BD3C 08                       .
        php                                     ; BD3D 08                       .
        php                                     ; BD3E 08                       .
        .byte   $23                             ; BD3F 23                       #
        brk                                     ; BD40 00                       .
        .byte   $03                             ; BD41 03                       .
        .byte   $04                             ; BD42 04                       .
        brk                                     ; BD43 00                       .
        .byte   $7B                             ; BD44 7B                       {
        ora     $230E                           ; BD45 0D 0E 23                 ..#
        ora     $7170                           ; BD48 0D 70 71                 .pq
        .byte   $72                             ; BD4B 72                       r
        .byte   $7F                             ; BD4C 7F                       .
        php                                     ; BD4D 08                       .
        php                                     ; BD4E 08                       .
        .byte   $23                             ; BD4F 23                       #
        .byte   $22                             ; BD50 22                       "
        php                                     ; BD51 08                       .
        asl     $08,x                           ; BD52 16 08                    ..
        php                                     ; BD54 08                       .
        php                                     ; BD55 08                       .
        php                                     ; BD56 08                       .
        .byte   $23                             ; BD57 23                       #
        .byte   $22                             ; BD58 22                       "
        php                                     ; BD59 08                       .
        php                                     ; BD5A 08                       .
        php                                     ; BD5B 08                       .
        php                                     ; BD5C 08                       .
        ora     ($12),y                         ; BD5D 11 12                    ..
        .byte   $23                             ; BD5F 23                       #
        .byte   $22                             ; BD60 22                       "
        asl     $08,x                           ; BD61 16 08                    ..
        php                                     ; BD63 08                       .
        php                                     ; BD64 08                       .
        php                                     ; BD65 08                       .
        php                                     ; BD66 08                       .
        .byte   $23                             ; BD67 23                       #
        .byte   $22                             ; BD68 22                       "
        php                                     ; BD69 08                       .
        php                                     ; BD6A 08                       .
        .byte   $CB                             ; BD6B CB                       .
        cpy     $9885                           ; BD6C CC 85 98                 ...
        cmp     $2524                           ; BD6F CD 24 25                 .$%
        rol     $27                             ; BD72 26 27                    &'
        and     $26                             ; BD74 25 26                    %&
        .byte   $27                             ; BD76 27                       '
        plp                                     ; BD77 28                       (
        and     #$2A                            ; BD78 29 2A                    )*
        .byte   $2B                             ; BD7A 2B                       +
        bit     $2B2A                           ; BD7B 2C 2A 2B                 ,*+
        bit     $082D                           ; BD7E 2C 2D 08                 ,-.
        php                                     ; BD81 08                       .
        php                                     ; BD82 08                       .
        php                                     ; BD83 08                       .
        php                                     ; BD84 08                       .
        php                                     ; BD85 08                       .
        php                                     ; BD86 08                       .
        php                                     ; BD87 08                       .
        php                                     ; BD88 08                       .
        php                                     ; BD89 08                       .
        php                                     ; BD8A 08                       .
        php                                     ; BD8B 08                       .
        php                                     ; BD8C 08                       .
        php                                     ; BD8D 08                       .
        php                                     ; BD8E 08                       .
        php                                     ; BD8F 08                       .
        php                                     ; BD90 08                       .
        php                                     ; BD91 08                       .
        php                                     ; BD92 08                       .
        php                                     ; BD93 08                       .
        php                                     ; BD94 08                       .
        php                                     ; BD95 08                       .
        php                                     ; BD96 08                       .
        php                                     ; BD97 08                       .
        php                                     ; BD98 08                       .
        php                                     ; BD99 08                       .
        php                                     ; BD9A 08                       .
        php                                     ; BD9B 08                       .
        php                                     ; BD9C 08                       .
        php                                     ; BD9D 08                       .
        php                                     ; BD9E 08                       .
        php                                     ; BD9F 08                       .
        php                                     ; BDA0 08                       .
        php                                     ; BDA1 08                       .
        php                                     ; BDA2 08                       .
        php                                     ; BDA3 08                       .
        php                                     ; BDA4 08                       .
        php                                     ; BDA5 08                       .
        php                                     ; BDA6 08                       .
        php                                     ; BDA7 08                       .
        php                                     ; BDA8 08                       .
        php                                     ; BDA9 08                       .
        php                                     ; BDAA 08                       .
        php                                     ; BDAB 08                       .
        php                                     ; BDAC 08                       .
        php                                     ; BDAD 08                       .
        php                                     ; BDAE 08                       .
        php                                     ; BDAF 08                       .
        php                                     ; BDB0 08                       .
        php                                     ; BDB1 08                       .
        php                                     ; BDB2 08                       .
        php                                     ; BDB3 08                       .
        php                                     ; BDB4 08                       .
        php                                     ; BDB5 08                       .
        php                                     ; BDB6 08                       .
        php                                     ; BDB7 08                       .
        php                                     ; BDB8 08                       .
        php                                     ; BDB9 08                       .
        php                                     ; BDBA 08                       .
        php                                     ; BDBB 08                       .
LBDBC:  php                                     ; BDBC 08                       .
        php                                     ; BDBD 08                       .
        php                                     ; BDBE 08                       .
        php                                     ; BDBF 08                       .
        php                                     ; BDC0 08                       .
        php                                     ; BDC1 08                       .
        php                                     ; BDC2 08                       .
        php                                     ; BDC3 08                       .
        php                                     ; BDC4 08                       .
        php                                     ; BDC5 08                       .
        php                                     ; BDC6 08                       .
        php                                     ; BDC7 08                       .
        php                                     ; BDC8 08                       .
        php                                     ; BDC9 08                       .
        php                                     ; BDCA 08                       .
        php                                     ; BDCB 08                       .
        php                                     ; BDCC 08                       .
        php                                     ; BDCD 08                       .
        php                                     ; BDCE 08                       .
        php                                     ; BDCF 08                       .
        php                                     ; BDD0 08                       .
        php                                     ; BDD1 08                       .
        php                                     ; BDD2 08                       .
        php                                     ; BDD3 08                       .
        php                                     ; BDD4 08                       .
        php                                     ; BDD5 08                       .
        php                                     ; BDD6 08                       .
        php                                     ; BDD7 08                       .
        php                                     ; BDD8 08                       .
        php                                     ; BDD9 08                       .
        php                                     ; BDDA 08                       .
        php                                     ; BDDB 08                       .
        php                                     ; BDDC 08                       .
        php                                     ; BDDD 08                       .
        php                                     ; BDDE 08                       .
        php                                     ; BDDF 08                       .
        php                                     ; BDE0 08                       .
        php                                     ; BDE1 08                       .
        php                                     ; BDE2 08                       .
        php                                     ; BDE3 08                       .
        php                                     ; BDE4 08                       .
        php                                     ; BDE5 08                       .
        php                                     ; BDE6 08                       .
        php                                     ; BDE7 08                       .
        php                                     ; BDE8 08                       .
        php                                     ; BDE9 08                       .
        php                                     ; BDEA 08                       .
        php                                     ; BDEB 08                       .
        php                                     ; BDEC 08                       .
        php                                     ; BDED 08                       .
        php                                     ; BDEE 08                       .
        php                                     ; BDEF 08                       .
        php                                     ; BDF0 08                       .
        php                                     ; BDF1 08                       .
        php                                     ; BDF2 08                       .
        php                                     ; BDF3 08                       .
        php                                     ; BDF4 08                       .
        php                                     ; BDF5 08                       .
        php                                     ; BDF6 08                       .
        php                                     ; BDF7 08                       .
        php                                     ; BDF8 08                       .
        php                                     ; BDF9 08                       .
        php                                     ; BDFA 08                       .
        php                                     ; BDFB 08                       .
        php                                     ; BDFC 08                       .
        php                                     ; BDFD 08                       .
        php                                     ; BDFE 08                       .
        php                                     ; BDFF 08                       .
        php                                     ; BE00 08                       .
        php                                     ; BE01 08                       .
        php                                     ; BE02 08                       .
        php                                     ; BE03 08                       .
        php                                     ; BE04 08                       .
        php                                     ; BE05 08                       .
        php                                     ; BE06 08                       .
        php                                     ; BE07 08                       .
        php                                     ; BE08 08                       .
        php                                     ; BE09 08                       .
        php                                     ; BE0A 08                       .
        php                                     ; BE0B 08                       .
        php                                     ; BE0C 08                       .
        php                                     ; BE0D 08                       .
        php                                     ; BE0E 08                       .
        php                                     ; BE0F 08                       .
        php                                     ; BE10 08                       .
        php                                     ; BE11 08                       .
        php                                     ; BE12 08                       .
        php                                     ; BE13 08                       .
        php                                     ; BE14 08                       .
        php                                     ; BE15 08                       .
        php                                     ; BE16 08                       .
        php                                     ; BE17 08                       .
        php                                     ; BE18 08                       .
        php                                     ; BE19 08                       .
        php                                     ; BE1A 08                       .
        php                                     ; BE1B 08                       .
        php                                     ; BE1C 08                       .
        php                                     ; BE1D 08                       .
        php                                     ; BE1E 08                       .
        php                                     ; BE1F 08                       .
        php                                     ; BE20 08                       .
        php                                     ; BE21 08                       .
        php                                     ; BE22 08                       .
        php                                     ; BE23 08                       .
        php                                     ; BE24 08                       .
        php                                     ; BE25 08                       .
        php                                     ; BE26 08                       .
        php                                     ; BE27 08                       .
        php                                     ; BE28 08                       .
        php                                     ; BE29 08                       .
        php                                     ; BE2A 08                       .
        php                                     ; BE2B 08                       .
        php                                     ; BE2C 08                       .
        php                                     ; BE2D 08                       .
        php                                     ; BE2E 08                       .
        php                                     ; BE2F 08                       .
        php                                     ; BE30 08                       .
        php                                     ; BE31 08                       .
        php                                     ; BE32 08                       .
        php                                     ; BE33 08                       .
        php                                     ; BE34 08                       .
        php                                     ; BE35 08                       .
        php                                     ; BE36 08                       .
        php                                     ; BE37 08                       .
        php                                     ; BE38 08                       .
        php                                     ; BE39 08                       .
        php                                     ; BE3A 08                       .
        php                                     ; BE3B 08                       .
        php                                     ; BE3C 08                       .
        php                                     ; BE3D 08                       .
        php                                     ; BE3E 08                       .
        php                                     ; BE3F 08                       .
        php                                     ; BE40 08                       .
        php                                     ; BE41 08                       .
        php                                     ; BE42 08                       .
        php                                     ; BE43 08                       .
        php                                     ; BE44 08                       .
        php                                     ; BE45 08                       .
        php                                     ; BE46 08                       .
        php                                     ; BE47 08                       .
        php                                     ; BE48 08                       .
        php                                     ; BE49 08                       .
        php                                     ; BE4A 08                       .
        php                                     ; BE4B 08                       .
        php                                     ; BE4C 08                       .
        php                                     ; BE4D 08                       .
        php                                     ; BE4E 08                       .
        php                                     ; BE4F 08                       .
        php                                     ; BE50 08                       .
        php                                     ; BE51 08                       .
        php                                     ; BE52 08                       .
        php                                     ; BE53 08                       .
        php                                     ; BE54 08                       .
        php                                     ; BE55 08                       .
        php                                     ; BE56 08                       .
        php                                     ; BE57 08                       .
        php                                     ; BE58 08                       .
        php                                     ; BE59 08                       .
        php                                     ; BE5A 08                       .
        php                                     ; BE5B 08                       .
        php                                     ; BE5C 08                       .
        php                                     ; BE5D 08                       .
        php                                     ; BE5E 08                       .
        php                                     ; BE5F 08                       .
        php                                     ; BE60 08                       .
        php                                     ; BE61 08                       .
        php                                     ; BE62 08                       .
        php                                     ; BE63 08                       .
        php                                     ; BE64 08                       .
        php                                     ; BE65 08                       .
        php                                     ; BE66 08                       .
        php                                     ; BE67 08                       .
        php                                     ; BE68 08                       .
        php                                     ; BE69 08                       .
        php                                     ; BE6A 08                       .
        php                                     ; BE6B 08                       .
        php                                     ; BE6C 08                       .
        php                                     ; BE6D 08                       .
        php                                     ; BE6E 08                       .
        php                                     ; BE6F 08                       .
        php                                     ; BE70 08                       .
        php                                     ; BE71 08                       .
        php                                     ; BE72 08                       .
        php                                     ; BE73 08                       .
        php                                     ; BE74 08                       .
        php                                     ; BE75 08                       .
        php                                     ; BE76 08                       .
        php                                     ; BE77 08                       .
        php                                     ; BE78 08                       .
        php                                     ; BE79 08                       .
        php                                     ; BE7A 08                       .
        php                                     ; BE7B 08                       .
        php                                     ; BE7C 08                       .
        php                                     ; BE7D 08                       .
        php                                     ; BE7E 08                       .
        php                                     ; BE7F 08                       .
        php                                     ; BE80 08                       .
        php                                     ; BE81 08                       .
        php                                     ; BE82 08                       .
        php                                     ; BE83 08                       .
        php                                     ; BE84 08                       .
        php                                     ; BE85 08                       .
        php                                     ; BE86 08                       .
        php                                     ; BE87 08                       .
        php                                     ; BE88 08                       .
        php                                     ; BE89 08                       .
        php                                     ; BE8A 08                       .
        php                                     ; BE8B 08                       .
        php                                     ; BE8C 08                       .
        php                                     ; BE8D 08                       .
        php                                     ; BE8E 08                       .
        php                                     ; BE8F 08                       .
        php                                     ; BE90 08                       .
        php                                     ; BE91 08                       .
        php                                     ; BE92 08                       .
        php                                     ; BE93 08                       .
        php                                     ; BE94 08                       .
        php                                     ; BE95 08                       .
        php                                     ; BE96 08                       .
        php                                     ; BE97 08                       .
        php                                     ; BE98 08                       .
        php                                     ; BE99 08                       .
        php                                     ; BE9A 08                       .
        php                                     ; BE9B 08                       .
        php                                     ; BE9C 08                       .
        php                                     ; BE9D 08                       .
        php                                     ; BE9E 08                       .
        php                                     ; BE9F 08                       .
        php                                     ; BEA0 08                       .
        php                                     ; BEA1 08                       .
        php                                     ; BEA2 08                       .
        php                                     ; BEA3 08                       .
        php                                     ; BEA4 08                       .
        php                                     ; BEA5 08                       .
        php                                     ; BEA6 08                       .
        php                                     ; BEA7 08                       .
        php                                     ; BEA8 08                       .
        php                                     ; BEA9 08                       .
        php                                     ; BEAA 08                       .
        php                                     ; BEAB 08                       .
        php                                     ; BEAC 08                       .
        php                                     ; BEAD 08                       .
        php                                     ; BEAE 08                       .
        php                                     ; BEAF 08                       .
        php                                     ; BEB0 08                       .
        php                                     ; BEB1 08                       .
        php                                     ; BEB2 08                       .
        php                                     ; BEB3 08                       .
        php                                     ; BEB4 08                       .
        php                                     ; BEB5 08                       .
        php                                     ; BEB6 08                       .
        php                                     ; BEB7 08                       .
        php                                     ; BEB8 08                       .
        php                                     ; BEB9 08                       .
        php                                     ; BEBA 08                       .
        php                                     ; BEBB 08                       .
        php                                     ; BEBC 08                       .
        php                                     ; BEBD 08                       .
        php                                     ; BEBE 08                       .
        php                                     ; BEBF 08                       .
        php                                     ; BEC0 08                       .
        php                                     ; BEC1 08                       .
        php                                     ; BEC2 08                       .
        php                                     ; BEC3 08                       .
        php                                     ; BEC4 08                       .
        php                                     ; BEC5 08                       .
        php                                     ; BEC6 08                       .
        php                                     ; BEC7 08                       .
        php                                     ; BEC8 08                       .
        php                                     ; BEC9 08                       .
        php                                     ; BECA 08                       .
        php                                     ; BECB 08                       .
        php                                     ; BECC 08                       .
        php                                     ; BECD 08                       .
        php                                     ; BECE 08                       .
        php                                     ; BECF 08                       .
        php                                     ; BED0 08                       .
        php                                     ; BED1 08                       .
        php                                     ; BED2 08                       .
        php                                     ; BED3 08                       .
        php                                     ; BED4 08                       .
        php                                     ; BED5 08                       .
        php                                     ; BED6 08                       .
        php                                     ; BED7 08                       .
        php                                     ; BED8 08                       .
        php                                     ; BED9 08                       .
        php                                     ; BEDA 08                       .
        php                                     ; BEDB 08                       .
        php                                     ; BEDC 08                       .
        php                                     ; BEDD 08                       .
        php                                     ; BEDE 08                       .
        php                                     ; BEDF 08                       .
        php                                     ; BEE0 08                       .
        php                                     ; BEE1 08                       .
        php                                     ; BEE2 08                       .
        php                                     ; BEE3 08                       .
        php                                     ; BEE4 08                       .
        php                                     ; BEE5 08                       .
        php                                     ; BEE6 08                       .
        php                                     ; BEE7 08                       .
        php                                     ; BEE8 08                       .
        php                                     ; BEE9 08                       .
        php                                     ; BEEA 08                       .
        php                                     ; BEEB 08                       .
        php                                     ; BEEC 08                       .
        php                                     ; BEED 08                       .
        php                                     ; BEEE 08                       .
        php                                     ; BEEF 08                       .
        php                                     ; BEF0 08                       .
        php                                     ; BEF1 08                       .
        php                                     ; BEF2 08                       .
        php                                     ; BEF3 08                       .
        php                                     ; BEF4 08                       .
        php                                     ; BEF5 08                       .
        php                                     ; BEF6 08                       .
        php                                     ; BEF7 08                       .
        php                                     ; BEF8 08                       .
        php                                     ; BEF9 08                       .
        php                                     ; BEFA 08                       .
        php                                     ; BEFB 08                       .
        php                                     ; BEFC 08                       .
        php                                     ; BEFD 08                       .
        php                                     ; BEFE 08                       .
        php                                     ; BEFF 08                       .
        php                                     ; BF00 08                       .
        php                                     ; BF01 08                       .
        php                                     ; BF02 08                       .
        php                                     ; BF03 08                       .
        php                                     ; BF04 08                       .
        php                                     ; BF05 08                       .
        php                                     ; BF06 08                       .
        php                                     ; BF07 08                       .
        php                                     ; BF08 08                       .
        php                                     ; BF09 08                       .
        php                                     ; BF0A 08                       .
        php                                     ; BF0B 08                       .
        php                                     ; BF0C 08                       .
        php                                     ; BF0D 08                       .
        php                                     ; BF0E 08                       .
        php                                     ; BF0F 08                       .
        php                                     ; BF10 08                       .
        php                                     ; BF11 08                       .
        php                                     ; BF12 08                       .
        php                                     ; BF13 08                       .
        php                                     ; BF14 08                       .
        php                                     ; BF15 08                       .
        php                                     ; BF16 08                       .
        php                                     ; BF17 08                       .
        php                                     ; BF18 08                       .
        php                                     ; BF19 08                       .
        php                                     ; BF1A 08                       .
        php                                     ; BF1B 08                       .
        php                                     ; BF1C 08                       .
        php                                     ; BF1D 08                       .
        php                                     ; BF1E 08                       .
        php                                     ; BF1F 08                       .
        php                                     ; BF20 08                       .
        php                                     ; BF21 08                       .
        php                                     ; BF22 08                       .
        php                                     ; BF23 08                       .
        php                                     ; BF24 08                       .
        php                                     ; BF25 08                       .
        php                                     ; BF26 08                       .
        php                                     ; BF27 08                       .
        php                                     ; BF28 08                       .
        php                                     ; BF29 08                       .
        php                                     ; BF2A 08                       .
        php                                     ; BF2B 08                       .
        php                                     ; BF2C 08                       .
        php                                     ; BF2D 08                       .
        php                                     ; BF2E 08                       .
        php                                     ; BF2F 08                       .
        php                                     ; BF30 08                       .
        php                                     ; BF31 08                       .
        php                                     ; BF32 08                       .
        php                                     ; BF33 08                       .
        php                                     ; BF34 08                       .
        php                                     ; BF35 08                       .
        php                                     ; BF36 08                       .
        php                                     ; BF37 08                       .
        php                                     ; BF38 08                       .
        php                                     ; BF39 08                       .
        php                                     ; BF3A 08                       .
        php                                     ; BF3B 08                       .
        php                                     ; BF3C 08                       .
        php                                     ; BF3D 08                       .
        php                                     ; BF3E 08                       .
        php                                     ; BF3F 08                       .
        php                                     ; BF40 08                       .
        php                                     ; BF41 08                       .
        php                                     ; BF42 08                       .
        php                                     ; BF43 08                       .
        php                                     ; BF44 08                       .
        php                                     ; BF45 08                       .
        php                                     ; BF46 08                       .
        php                                     ; BF47 08                       .
        php                                     ; BF48 08                       .
        php                                     ; BF49 08                       .
        php                                     ; BF4A 08                       .
        php                                     ; BF4B 08                       .
        php                                     ; BF4C 08                       .
        php                                     ; BF4D 08                       .
        php                                     ; BF4E 08                       .
        php                                     ; BF4F 08                       .
        php                                     ; BF50 08                       .
        php                                     ; BF51 08                       .
        php                                     ; BF52 08                       .
        php                                     ; BF53 08                       .
        php                                     ; BF54 08                       .
        php                                     ; BF55 08                       .
        php                                     ; BF56 08                       .
        php                                     ; BF57 08                       .
        php                                     ; BF58 08                       .
        php                                     ; BF59 08                       .
        php                                     ; BF5A 08                       .
        php                                     ; BF5B 08                       .
        php                                     ; BF5C 08                       .
        php                                     ; BF5D 08                       .
        php                                     ; BF5E 08                       .
        php                                     ; BF5F 08                       .
        php                                     ; BF60 08                       .
        php                                     ; BF61 08                       .
        php                                     ; BF62 08                       .
        php                                     ; BF63 08                       .
        php                                     ; BF64 08                       .
        php                                     ; BF65 08                       .
        php                                     ; BF66 08                       .
        php                                     ; BF67 08                       .
        php                                     ; BF68 08                       .
        php                                     ; BF69 08                       .
        php                                     ; BF6A 08                       .
        php                                     ; BF6B 08                       .
        php                                     ; BF6C 08                       .
        php                                     ; BF6D 08                       .
        php                                     ; BF6E 08                       .
        php                                     ; BF6F 08                       .
        php                                     ; BF70 08                       .
        php                                     ; BF71 08                       .
        php                                     ; BF72 08                       .
        php                                     ; BF73 08                       .
        php                                     ; BF74 08                       .
        php                                     ; BF75 08                       .
        php                                     ; BF76 08                       .
        php                                     ; BF77 08                       .
        php                                     ; BF78 08                       .
        php                                     ; BF79 08                       .
        php                                     ; BF7A 08                       .
        php                                     ; BF7B 08                       .
        php                                     ; BF7C 08                       .
        php                                     ; BF7D 08                       .
        php                                     ; BF7E 08                       .
        php                                     ; BF7F 08                       .
        php                                     ; BF80 08                       .
        php                                     ; BF81 08                       .
        php                                     ; BF82 08                       .
        php                                     ; BF83 08                       .
        php                                     ; BF84 08                       .
        php                                     ; BF85 08                       .
        php                                     ; BF86 08                       .
        php                                     ; BF87 08                       .
        php                                     ; BF88 08                       .
        php                                     ; BF89 08                       .
        php                                     ; BF8A 08                       .
        php                                     ; BF8B 08                       .
        php                                     ; BF8C 08                       .
        php                                     ; BF8D 08                       .
        php                                     ; BF8E 08                       .
        php                                     ; BF8F 08                       .
        php                                     ; BF90 08                       .
        php                                     ; BF91 08                       .
        php                                     ; BF92 08                       .
        php                                     ; BF93 08                       .
        php                                     ; BF94 08                       .
        php                                     ; BF95 08                       .
        php                                     ; BF96 08                       .
        php                                     ; BF97 08                       .
        php                                     ; BF98 08                       .
        php                                     ; BF99 08                       .
        php                                     ; BF9A 08                       .
        php                                     ; BF9B 08                       .
        php                                     ; BF9C 08                       .
        php                                     ; BF9D 08                       .
        php                                     ; BF9E 08                       .
        php                                     ; BF9F 08                       .
        php                                     ; BFA0 08                       .
        php                                     ; BFA1 08                       .
        php                                     ; BFA2 08                       .
        php                                     ; BFA3 08                       .
        php                                     ; BFA4 08                       .
        php                                     ; BFA5 08                       .
        php                                     ; BFA6 08                       .
        php                                     ; BFA7 08                       .
        php                                     ; BFA8 08                       .
        php                                     ; BFA9 08                       .
        php                                     ; BFAA 08                       .
        php                                     ; BFAB 08                       .
        php                                     ; BFAC 08                       .
        php                                     ; BFAD 08                       .
        php                                     ; BFAE 08                       .
        php                                     ; BFAF 08                       .
        php                                     ; BFB0 08                       .
        php                                     ; BFB1 08                       .
        php                                     ; BFB2 08                       .
        php                                     ; BFB3 08                       .
        php                                     ; BFB4 08                       .
        php                                     ; BFB5 08                       .
        php                                     ; BFB6 08                       .
        php                                     ; BFB7 08                       .
        php                                     ; BFB8 08                       .
        php                                     ; BFB9 08                       .
        php                                     ; BFBA 08                       .
        php                                     ; BFBB 08                       .
        php                                     ; BFBC 08                       .
        php                                     ; BFBD 08                       .
        php                                     ; BFBE 08                       .
LBFBF:  php                                     ; BFBF 08                       .
        php                                     ; BFC0 08                       .
        php                                     ; BFC1 08                       .
        php                                     ; BFC2 08                       .
        php                                     ; BFC3 08                       .
        php                                     ; BFC4 08                       .
        php                                     ; BFC5 08                       .
        php                                     ; BFC6 08                       .
        php                                     ; BFC7 08                       .
        php                                     ; BFC8 08                       .
        php                                     ; BFC9 08                       .
        php                                     ; BFCA 08                       .
        php                                     ; BFCB 08                       .
        php                                     ; BFCC 08                       .
        php                                     ; BFCD 08                       .
        php                                     ; BFCE 08                       .
        php                                     ; BFCF 08                       .
        php                                     ; BFD0 08                       .
        php                                     ; BFD1 08                       .
        php                                     ; BFD2 08                       .
        php                                     ; BFD3 08                       .
        php                                     ; BFD4 08                       .
        php                                     ; BFD5 08                       .
        php                                     ; BFD6 08                       .
        php                                     ; BFD7 08                       .
        php                                     ; BFD8 08                       .
        php                                     ; BFD9 08                       .
        php                                     ; BFDA 08                       .
        php                                     ; BFDB 08                       .
        php                                     ; BFDC 08                       .
        php                                     ; BFDD 08                       .
        php                                     ; BFDE 08                       .
        php                                     ; BFDF 08                       .
        php                                     ; BFE0 08                       .
        php                                     ; BFE1 08                       .
        php                                     ; BFE2 08                       .
        php                                     ; BFE3 08                       .
        php                                     ; BFE4 08                       .
        php                                     ; BFE5 08                       .
        php                                     ; BFE6 08                       .
        php                                     ; BFE7 08                       .
        php                                     ; BFE8 08                       .
        php                                     ; BFE9 08                       .
        php                                     ; BFEA 08                       .
        php                                     ; BFEB 08                       .
        php                                     ; BFEC 08                       .
        php                                     ; BFED 08                       .
        php                                     ; BFEE 08                       .
        php                                     ; BFEF 08                       .
        php                                     ; BFF0 08                       .
        php                                     ; BFF1 08                       .
        php                                     ; BFF2 08                       .
        php                                     ; BFF3 08                       .
        php                                     ; BFF4 08                       .
        php                                     ; BFF5 08                       .
        php                                     ; BFF6 08                       .
        php                                     ; BFF7 08                       .
        php                                     ; BFF8 08                       .
        php                                     ; BFF9 08                       .
        php                                     ; BFFA 08                       .
        php                                     ; BFFB 08                       .
        php                                     ; BFFC 08                       .
        php                                     ; BFFD 08                       .
        php                                     ; BFFE 08                       .
        php                                     ; BFFF 08                       .
