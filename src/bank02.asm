.setcpu "6502"
.include "include/hardware.inc"
.include "include/zeropage.inc"
.include "include/constants.inc"
.include "include/fixed_bank.inc"

.segment "BANK02"

; =============================================================================
; BANK $02 (mapped at $A000) — raw da65 disassembly, annotation in progress
; SKELETON — raw ROM bytes, not yet classified as code or data.
; =============================================================================
L0000           := $0000
L0020           := $0020
L0021           := $0021
L0402           := $0402
L0F21           := $0F21
L1221           := $1221
L1626           := $1626
L1B12           := $1B12
L2000           := $2000
L2221           := $2221
L5150           := $5150
L5A8A           := $5A8A
L6020           := $6020
L6040           := $6040
L6C57           := $6C57
L6C6C           := $6C6C
L70C0           := $70C0
L8040           := $8040
L82B8           := $82B8
L8420           := $8420
L84A6           := $84A6
L84D5           := $84D5
L8936           := $8936
LE700           := $E700
LF2F3           := $F2F3
; ----------------------------------------------------------------------------
        jsr     L84A6                           ; A000 20 A6 84                  ..
        bcs     LA066                           ; A003 B0 61                    .a
        lda     #$80                            ; A005 A9 80                    ..
        sta     $1E                             ; A007 85 1E                    ..
        lda     #$1D                            ; A009 A9 1D                    ..
        sta     $23                             ; A00B 85 23                    .#
        lda     #$17                            ; A00D A9 17                    ..
        sta     $0588,x                         ; A00F 9D 88 05                 ...
        lda     #$A0                            ; A012 A9 A0                    ..
        sta     $05A0,x                         ; A014 9D A0 05                 ...
        lda     $1E                             ; A017 A5 1E                    ..
        bne     LA066                           ; A019 D0 4B                    .K
        sta     $9D                             ; A01B 85 9D                    ..
        sta     $78                             ; A01D 85 78                    .x
        sta     $79                             ; A01F 85 79                    .y
        lda     #$80                            ; A021 A9 80                    ..
        sta     $9B                             ; A023 85 9B                    ..
        lda     #$07                            ; A025 A9 07                    ..
        sta     $99                             ; A027 85 99                    ..
        lda     #$02                            ; A029 A9 02                    ..
        sta     $FD                             ; A02B 85 FD                    ..
        lda     #$E8                            ; A02D A9 E8                    ..
        sta     $EB                             ; A02F 85 EB                    ..
        lda     #$40                            ; A031 A9 40                    .@
        sta     $0588,x                         ; A033 9D 88 05                 ...
        lda     #$A0                            ; A036 A9 A0                    ..
        sta     $05A0,x                         ; A038 9D A0 05                 ...
        lda     #$30                            ; A03B A9 30                    .0
        sta     $0468,x                         ; A03D 9D 68 04                 .h.
        lda     #$6F                            ; A040 A9 6F                    .o
        sta     L0000                           ; A042 85 00                    ..
        lda     #$A2                            ; A044 A9 A2                    ..
        sta     $01                             ; A046 85 01                    ..
        jsr     L8420                           ; A048 20 20 84                   .
        bcs     LA066                           ; A04B B0 19                    ..
        lda     #$67                            ; A04D A9 67                    .g
        sta     $0588,x                         ; A04F 9D 88 05                 ...
        lda     #$A0                            ; A052 A9 A0                    ..
        sta     $05A0,x                         ; A054 9D A0 05                 ...
        lda     #$D2                            ; A057 A9 D2                    ..
        sta     $0468,x                         ; A059 9D 68 04                 .h.
        lda     #$02                            ; A05C A9 02                    ..
        .byte   $9D                             ; A05E 9D                       .
        rti                                     ; A05F 40                       @

; ----------------------------------------------------------------------------
LA060:  ora     $A9                             ; A060 05 A9                    ..
        brk                                     ; A062 00                       .
        sta     $0570,x                         ; A063 9D 70 05                 .p.
LA066:  rts                                     ; A066 60                       `

; ----------------------------------------------------------------------------
        lda     $0468,x                         ; A067 BD 68 04                 .h.
        bne     LA0CF                           ; A06A D0 63                    .c
        lda     #$D2                            ; A06C A9 D2                    ..
        sta     $0468,x                         ; A06E 9D 68 04                 .h.
        lda     $E4                             ; A071 A5 E4                    ..
        adc     $E7                             ; A073 65 E7                    e.
        and     #$03                            ; A075 29 03                    ).
        beq     LA07B                           ; A077 F0 02                    ..
        lda     #$01                            ; A079 A9 01                    ..
LA07B:  sta     $11                             ; A07B 85 11                    ..
        sta     $12                             ; A07D 85 12                    ..
LA07F:  jsr     find_free_slot_y                           ; A07F 20 6F F1                  o.
        bcs     LA0CF                           ; A082 B0 4B                    .K
        lda     #$BE                            ; A084 A9 BE                    ..
        jsr     entity_init_pos                           ; A086 20 A4 EA                  ..
        lda     #$7B                            ; A089 A9 7B                    .{
        sta     $0300,y                         ; A08B 99 00 03                 ...
        lda     #$34                            ; A08E A9 34                    .4
        sta     $0378,y                         ; A090 99 78 03                 .x.
        lda     #$D8                            ; A093 A9 D8                    ..
        sta     $0330,y                         ; A095 99 30 03                 .0.
        lda     #$00                            ; A098 A9 00                    ..
        sta     $03D8,y                         ; A09A 99 D8 03                 ...
        lda     #$02                            ; A09D A9 02                    ..
        .byte   $99                             ; A09F 99                       .
LA0A0:  .byte   $F0,$03                    ; A0A0 F0 03   (branch out of range for ca65: target has no local label)
LA0A2:  lda     $E4                             ; A0A2 A5 E4                    ..
        adc     $E5                             ; A0A4 65 E5                    e.
        sta     $E4                             ; A0A6 85 E4                    ..
        and     #$07                            ; A0A8 29 07                    ).
        tax                                     ; A0AA AA                       .
        lda     LA283,x                         ; A0AB BD 83 A2                 ...
        cmp     $12                             ; A0AE C5 12                    ..
        bne     LA0BA                           ; A0B0 D0 08                    ..
        inx                                     ; A0B2 E8                       .
        txa                                     ; A0B3 8A                       .
        and     #$07                            ; A0B4 29 07                    ).
        tax                                     ; A0B6 AA                       .
        lda     LA283,x                         ; A0B7 BD 83 A2                 ...
LA0BA:  sta     $0468,y                         ; A0BA 99 68 04                 .h.
        sta     $12                             ; A0BD 85 12                    ..
        lda     #$C0                            ; A0BF A9 C0                    ..
        sta     $0408,y                         ; A0C1 99 08 04                 ...
        lda     #$01                            ; A0C4 A9 01                    ..
        sta     $0450,y                         ; A0C6 99 50 04                 .P.
        ldx     $A6                             ; A0C9 A6 A6                    ..
        dec     $11                             ; A0CB C6 11                    ..
        bpl     LA07F                           ; A0CD 10 B0                    ..
LA0CF:  dec     $0468,x                         ; A0CF DE 68 04                 .h.
        lda     #$C2                            ; A0D2 A9 C2                    ..
        ldy     $78                             ; A0D4 A4 78                    .x
        beq     LA0DC                           ; A0D6 F0 04                    ..
        cpy     #$FF                            ; A0D8 C0 FF                    ..
        bne     LA0E6                           ; A0DA D0 0A                    ..
LA0DC:  ldy     $79                             ; A0DC A4 79                    .y
        beq     LA0E4                           ; A0DE F0 04                    ..
        cpy     #$FF                            ; A0E0 C0 FF                    ..
        bne     LA0E6                           ; A0E2 D0 02                    ..
LA0E4:  lda     #$C3                            ; A0E4 A9 C3                    ..
LA0E6:  cmp     $0558,x                         ; A0E6 DD 58 05                 .X.
        beq     LA0EE                           ; A0E9 F0 03                    ..
        jsr     entity_set_subtype                           ; A0EB 20 98 EA                  ..
LA0EE:  lda     $0540,x                         ; A0EE BD 40 05                 .@.
        cmp     #$02                            ; A0F1 C9 02                    ..
        bne     LA0FA                           ; A0F3 D0 05                    ..
        lda     #$00                            ; A0F5 A9 00                    ..
        sta     $0570,x                         ; A0F7 9D 70 05                 .p.
LA0FA:  lda     #$03                            ; A0FA A9 03                    ..
        ldy     $0558,x                         ; A0FC BC 58 05                 .X.
        cpy     #$C3                            ; A0FF C0 C3                    ..
        beq     LA105                           ; A101 F0 02                    ..
        lda     #$00                            ; A103 A9 00                    ..
LA105:  clc                                     ; A105 18                       .
        adc     $0540,x                         ; A106 7D 40 05                 }@.
        tay                                     ; A109 A8                       .
        lda     $0408,x                         ; A10A BD 08 04                 ...
        and     #$BF                            ; A10D 29 BF                    ).
        ora     LA28B,y                         ; A10F 19 8B A2                 ...
        sta     $0408,x                         ; A112 9D 08 04                 ...
LA115:  rts                                     ; A115 60                       `

; ----------------------------------------------------------------------------
        lda     $2F                             ; A116 A5 2F                    ./
        bpl     LA115                           ; A118 10 FB                    ..
        lda     $30                             ; A11A A5 30                    .0
        cmp     #$08                            ; A11C C9 08                    ..
        bcs     LA115                           ; A11E B0 F5                    ..
        lda     $32                             ; A120 A5 32                    .2
        cmp     #$07                            ; A122 C9 07                    ..
        beq     LA115                           ; A124 F0 EF                    ..
        jsr     entity_hitbox_check                           ; A126 20 F8 EF                  ..
        bcc     LA12E                           ; A129 90 03                    ..
        jmp     LA1CE                           ; A12B 4C CE A1                 L..

; ----------------------------------------------------------------------------
LA12E:  ldy     $10                             ; A12E A4 10                    ..
        jsr     LF2F3                           ; A130 20 F3 F2                  ..
        lda     #$02                            ; A133 A9 02                    ..
        sta     $0420,x                         ; A135 9D 20 04                 . .
        lda     #$00                            ; A138 A9 00                    ..
        sta     $03A8,x                         ; A13A 9D A8 03                 ...
        lda     #$04                            ; A13D A9 04                    ..
        sta     $03C0,x                         ; A13F 9D C0 03                 ...
        lda     #$4C                            ; A142 A9 4C                    .L
        sta     $0588,x                         ; A144 9D 88 05                 ...
        lda     #$A1                            ; A147 A9 A1                    ..
        sta     $05A0,x                         ; A149 9D A0 05                 ...
        jsr     LA1F6                           ; A14C 20 F6 A1                  ..
        lda     $0330,x                         ; A14F BD 30 03                 .0.
        cmp     #$20                            ; A152 C9 20                    . 
        bne     LA1CE                           ; A154 D0 78                    .x
        lda     #$1E                            ; A156 A9 1E                    ..
        sta     $0468,x                         ; A158 9D 68 04                 .h.
        lda     #$65                            ; A15B A9 65                    .e
        sta     $0588,x                         ; A15D 9D 88 05                 ...
        lda     #$A1                            ; A160 A9 A1                    ..
        sta     $05A0,x                         ; A162 9D A0 05                 ...
        lda     $0468,x                         ; A165 BD 68 04                 .h.
        cmp     #$14                            ; A168 C9 14                    ..
        bcc     LA17A                           ; A16A 90 0E                    ..
        and     #$01                            ; A16C 29 01                    ).
        sta     L0000                           ; A16E 85 00                    ..
        lda     $0330,x                         ; A170 BD 30 03                 .0.
        and     #$F0                            ; A173 29 F0                    ).
        ora     L0000                           ; A175 05 00                    ..
        sta     $0330,x                         ; A177 9D 30 03                 .0.
LA17A:  dec     $0468,x                         ; A17A DE 68 04                 .h.
        bne     LA1CE                           ; A17D D0 4F                    .O
        lda     #$01                            ; A17F A9 01                    ..
        sta     $0420,x                         ; A181 9D 20 04                 . .
        lda     #$02                            ; A184 A9 02                    ..
        sta     $03C0,x                         ; A186 9D C0 03                 ...
        lda     #$93                            ; A189 A9 93                    ..
        .byte   $9D                             ; A18B 9D                       .
        dey                                     ; A18C 88                       .
LA18D:  ora     $A9                             ; A18D 05 A9                    ..
        lda     ($9D,x)                         ; A18F A1 9D                    ..
        ldy     #$05                            ; A191 A0 05                    ..
        jsr     LA1F6                           ; A193 20 F6 A1                  ..
        lda     $0330,x                         ; A196 BD 30 03                 .0.
        cmp     #$D8                            ; A199 C9 D8                    ..
        bne     LA1CE                           ; A19B D0 31                    .1
        lda     #$AC                            ; A19D A9 AC                    ..
        sta     $0588,x                         ; A19F 9D 88 05                 ...
        lda     #$A1                            ; A1A2 A9 A1                    ..
        sta     $05A0,x                         ; A1A4 9D A0 05                 ...
        lda     #$06                            ; A1A7 A9 06                    ..
        sta     $0468,x                         ; A1A9 9D 68 04                 .h.
        dec     $0468,x                         ; A1AC DE 68 04                 .h.
        lda     $0468,x                         ; A1AF BD 68 04                 .h.
        pha                                     ; A1B2 48                       H
        and     #$01                            ; A1B3 29 01                    ).
        sta     L0000                           ; A1B5 85 00                    ..
        lda     $0330,x                         ; A1B7 BD 30 03                 .0.
        and     #$F8                            ; A1BA 29 F8                    ).
        ora     L0000                           ; A1BC 05 00                    ..
        sta     $0330,x                         ; A1BE 9D 30 03                 .0.
        pla                                     ; A1C1 68                       h
        bne     LA1CE                           ; A1C2 D0 0A                    ..
        lda     #$16                            ; A1C4 A9 16                    ..
        sta     $0588,x                         ; A1C6 9D 88 05                 ...
        lda     #$A1                            ; A1C9 A9 A1                    ..
        sta     $05A0,x                         ; A1CB 9D A0 05                 ...
LA1CE:  ldy     #$00                            ; A1CE A0 00                    ..
        lda     $0378,x                         ; A1D0 BD 78 03                 .x.
        cmp     #$90                            ; A1D3 C9 90                    ..
        beq     LA1D8                           ; A1D5 F0 01                    ..
        iny                                     ; A1D7 C8                       .
LA1D8:  lda     #$D8                            ; A1D8 A9 D8                    ..
        sec                                     ; A1DA 38                       8
        sbc     $0330,x                         ; A1DB FD 30 03                 .0.
        sta     $78,y                           ; A1DE 99 78 00                 .x.
        lda     $0408,x                         ; A1E1 BD 08 04                 ...
        pha                                     ; A1E4 48                       H
        lda     #$B2                            ; A1E5 A9 B2                    ..
        sta     $0408,x                         ; A1E7 9D 08 04                 ...
        jsr     entity_player_collide                           ; A1EA 20 87 EF                  ..
        pla                                     ; A1ED 68                       h
        sta     $0408,x                         ; A1EE 9D 08 04                 ...
        bcs     LA213                           ; A1F1 B0 20                    . 
        jmp     L82B8                           ; A1F3 4C B8 82                 L..

; ----------------------------------------------------------------------------
LA1F6:  jsr     entity_facing_dispatch                           ; A1F6 20 65 EA                  e.
        dec     $0378,x                         ; A1F9 DE 78 03                 .x.
        jsr     entity_player_collide                           ; A1FC 20 87 EF                  ..
        inc     $0378,x                         ; A1FF FE 78 03                 .x.
        bcs     LA213                           ; A202 B0 0F                    ..
        lda     $0420,x                         ; A204 BD 20 04                 . .
        sta     $39                             ; A207 85 39                    .9
        lda     $03A8,x                         ; A209 BD A8 03                 ...
        sta     $3A                             ; A20C 85 3A                    .:
        lda     $03C0,x                         ; A20E BD C0 03                 ...
        sta     $3B                             ; A211 85 3B                    .;
LA213:  rts                                     ; A213 60                       `

; ----------------------------------------------------------------------------
        jsr     entity_move_up_nofacing                           ; A214 20 4A E9                  J.
        lda     $0390,x                         ; A217 BD 90 03                 ...
        beq     LA26E                           ; A21A F0 52                    .R
        lda     #$00                            ; A21C A9 00                    ..
        sta     $0390,x                         ; A21E 9D 90 03                 ...
        sta     $0378,x                         ; A221 9D 78 03                 .x.
        lda     $0468,x                         ; A224 BD 68 04                 .h.
        sta     $0330,x                         ; A227 9D 30 03                 .0.
        lda     #$6A                            ; A22A A9 6A                    .j
        sta     $03A8,x                         ; A22C 9D A8 03                 ...
        sta     $03D8,x                         ; A22F 9D D8 03                 ...
        lda     #$01                            ; A232 A9 01                    ..
        sta     $03C0,x                         ; A234 9D C0 03                 ...
        sta     $03F0,x                         ; A237 9D F0 03                 ...
        lda     #$06                            ; A23A A9 06                    ..
        sta     $0420,x                         ; A23C 9D 20 04                 . .
        lda     #$16                            ; A23F A9 16                    ..
        sta     $0468,x                         ; A241 9D 68 04                 .h.
        lda     #$4E                            ; A244 A9 4E                    .N
        sta     $0588,x                         ; A246 9D 88 05                 ...
        lda     #$A2                            ; A249 A9 A2                    ..
        sta     $05A0,x                         ; A24B 9D A0 05                 ...
        lda     $0528,x                         ; A24E BD 28 05                 .(.
        pha                                     ; A251 48                       H
        jsr     entity_facing_dispatch                           ; A252 20 65 EA                  e.
        jsr     entity_vert_dispatch_raw                           ; A255 20 86 EA                  ..
        pla                                     ; A258 68                       h
        sta     $0528,x                         ; A259 9D 28 05                 .(.
        dec     $0468,x                         ; A25C DE 68 04                 .h.
        bne     LA26E                           ; A25F D0 0D                    ..
        lda     #$16                            ; A261 A9 16                    ..
        sta     $0468,x                         ; A263 9D 68 04                 .h.
        lda     $0420,x                         ; A266 BD 20 04                 . .
        eor     #$03                            ; A269 49 03                    I.
        sta     $0420,x                         ; A26B 9D 20 04                 . .
LA26E:  rts                                     ; A26E 60                       `

; ----------------------------------------------------------------------------
        .byte   $0F                             ; A26F 0F                       .
        rol     $16,x                           ; A270 36 16                    6.
        asl     $0F                             ; A272 06 0F                    ..
        bmi     LA286                           ; A274 30 10                    0.
        brk                                     ; A276 00                       .
        .byte   $0F                             ; A277 0F                       .
        bmi     LA29B                           ; A278 30 21                    0!
        ora     ($0F),y                         ; A27A 11 0F                    ..
        .byte   $0F                             ; A27C 0F                       .
        jsr     L0F21                           ; A27D 20 21 0F                  !.
        .byte   $0F                             ; A280 0F                       .
        .byte   $20                             ; A281 20                        
        .byte   $2B                             ; A282 2B                       +
LA283:  jsr     LA060                           ; A283 20 60 A0                  `.
LA286:  rti                                     ; A286 40                       @

; ----------------------------------------------------------------------------
        .byte   $80                             ; A287 80                       .
        jsr     LA060                           ; A288 20 60 A0                  `.
LA28B:  brk                                     ; A28B 00                       .
        brk                                     ; A28C 00                       .
        rti                                     ; A28D 40                       @

; ----------------------------------------------------------------------------
        rti                                     ; A28E 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; A28F 00                       .
        brk                                     ; A290 00                       .
        jsr     L84A6                           ; A291 20 A6 84                  ..
        bcs     LA26E                           ; A294 B0 D8                    ..
        lda     #$80                            ; A296 A9 80                    ..
        sta     $1E                             ; A298 85 1E                    ..
        .byte   $A9                             ; A29A A9                       .
LA29B:  ora     $2385,y                         ; A29B 19 85 23                 ..#
        lda     #$A8                            ; A29E A9 A8                    ..
        sta     $0588,x                         ; A2A0 9D 88 05                 ...
        lda     #$A2                            ; A2A3 A9 A2                    ..
        sta     $05A0,x                         ; A2A5 9D A0 05                 ...
        lda     $1E                             ; A2A8 A5 1E                    ..
        bne     LA26E                           ; A2AA D0 C2                    ..
        jsr     L84D5                           ; A2AC 20 D5 84                  ..
        lda     #$EA                            ; A2AF A9 EA                    ..
        sta     $EA                             ; A2B1 85 EA                    ..
        lda     #$C6                            ; A2B3 A9 C6                    ..
        sta     $0588,x                         ; A2B5 9D 88 05                 ...
        lda     #$A2                            ; A2B8 A9 A2                    ..
        sta     $05A0,x                         ; A2BA 9D A0 05                 ...
        lda     #$30                            ; A2BD A9 30                    .0
        sta     $0468,x                         ; A2BF 9D 68 04                 .h.
        lda     #$40                            ; A2C2 A9 40                    .@
        sta     $FA                             ; A2C4 85 FA                    ..
        lda     #$A4                            ; A2C6 A9 A4                    ..
        sta     L0000                           ; A2C8 85 00                    ..
        lda     #$A5                            ; A2CA A9 A5                    ..
        sta     $01                             ; A2CC 85 01                    ..
        jsr     L8420                           ; A2CE 20 20 84                   .
        bcs     LA337                           ; A2D1 B0 64                    .d
        jsr     LA4E4                           ; A2D3 20 E4 A4                  ..
        lda     #$0A                            ; A2D6 A9 0A                    ..
        sta     $0420,y                         ; A2D8 99 20 04                 . .
        lda     #$34                            ; A2DB A9 34                    .4
        sta     $0330,y                         ; A2DD 99 30 03                 .0.
        jsr     LA4E4                           ; A2E0 20 E4 A4                  ..
        lda     #$09                            ; A2E3 A9 09                    ..
        sta     $0420,y                         ; A2E5 99 20 04                 . .
        lda     #$C4                            ; A2E8 A9 C4                    ..
        sta     $0330,y                         ; A2EA 99 30 03                 .0.
        jsr     LA515                           ; A2ED 20 15 A5                  ..
        lda     #$3C                            ; A2F0 A9 3C                    .<
        sta     $0378,y                         ; A2F2 99 78 03                 .x.
        lda     #$E4                            ; A2F5 A9 E4                    ..
        sta     $0480,y                         ; A2F7 99 80 04                 ...
        jsr     LA515                           ; A2FA 20 15 A5                  ..
        lda     #$74                            ; A2FD A9 74                    .t
        sta     $0378,y                         ; A2FF 99 78 03                 .x.
        lda     #$1C                            ; A302 A9 1C                    ..
        sta     $0480,y                         ; A304 99 80 04                 ...
        lda     #$80                            ; A307 A9 80                    ..
        sta     $0330,x                         ; A309 9D 30 03                 .0.
        lda     #$58                            ; A30C A9 58                    .X
        sta     $0378,x                         ; A30E 9D 78 03                 .x.
        lda     $E4                             ; A311 A5 E4                    ..
        and     #$03                            ; A313 29 03                    ).
        tay                                     ; A315 A8                       .
        lda     LA5FF,y                         ; A316 B9 FF A5                 ...
        sta     $04E0,x                         ; A319 9D E0 04                 ...
        lda     #$3E                            ; A31C A9 3E                    .>
        sta     $0588,x                         ; A31E 9D 88 05                 ...
        lda     #$A3                            ; A321 A9 A3                    ..
        sta     $05A0,x                         ; A323 9D A0 05                 ...
        lda     #$02                            ; A326 A9 02                    ..
        sta     $0468,x                         ; A328 9D 68 04                 .h.
        lda     #$3C                            ; A32B A9 3C                    .<
        sta     $0498,x                         ; A32D 9D 98 04                 ...
        lda     #$3F                            ; A330 A9 3F                    .?
        sta     $0480,x                         ; A332 9D 80 04                 ...
        bne     LA358                           ; A335 D0 21                    .!
LA337:  rts                                     ; A337 60                       `

; ----------------------------------------------------------------------------
LA338:  dec     $04C8,x                         ; A338 DE C8 04                 ...
LA33B:  jmp     LA421                           ; A33B 4C 21 A4                 L!.

; ----------------------------------------------------------------------------
        lda     $04C8,x                         ; A33E BD C8 04                 ...
        bne     LA338                           ; A341 D0 F5                    ..
        lda     $0468,x                         ; A343 BD 68 04                 .h.
        bne     LA368                           ; A346 D0 20                    . 
        lda     #$04                            ; A348 A9 04                    ..
        sta     $0468,x                         ; A34A 9D 68 04                 .h.
        inc     $0480,x                         ; A34D FE 80 04                 ...
        lda     $0480,x                         ; A350 BD 80 04                 ...
        and     #$3F                            ; A353 29 3F                    )?
        sta     $0480,x                         ; A355 9D 80 04                 ...
LA358:  cmp     #$20                            ; A358 C9 20                    . 
        bcc     LA35E                           ; A35A 90 02                    ..
        sbc     #$10                            ; A35C E9 10                    ..
LA35E:  tay                                     ; A35E A8                       .
        lda     LA5B8,y                         ; A35F B9 B8 A5                 ...
        tay                                     ; A362 A8                       .
        lda     #$08                            ; A363 A9 08                    ..
        jsr     entity_set_dir_velocity                           ; A365 20 70 F4                  p.
LA368:  dec     $0468,x                         ; A368 DE 68 04                 .h.
        jsr     entity_facing_dispatch                           ; A36B 20 65 EA                  e.
        jsr     entity_vert_dispatch_raw                           ; A36E 20 86 EA                  ..
        dec     $0498,x                         ; A371 DE 98 04                 ...
        bne     LA37E                           ; A374 D0 08                    ..
        lda     #$3C                            ; A376 A9 3C                    .<
        sta     $0498,x                         ; A378 9D 98 04                 ...
        jsr     LA469                           ; A37B 20 69 A4                  i.
LA37E:  lda     $0480,x                         ; A37E BD 80 04                 ...
        cmp     #$3F                            ; A381 C9 3F                    .?
        bne     LA33B                           ; A383 D0 B6                    ..
        lda     $0468,x                         ; A385 BD 68 04                 .h.
        cmp     #$02                            ; A388 C9 02                    ..
        bne     LA33B                           ; A38A D0 AF                    ..
        lda     #$D0                            ; A38C A9 D0                    ..
        sta     $0588,x                         ; A38E 9D 88 05                 ...
        lda     #$A3                            ; A391 A9 A3                    ..
        sta     $05A0,x                         ; A393 9D A0 05                 ...
        lda     #$33                            ; A396 A9 33                    .3
        sta     $03A8,x                         ; A398 9D A8 03                 ...
        lda     #$01                            ; A39B A9 01                    ..
        sta     $03C0,x                         ; A39D 9D C0 03                 ...
        lda     #$D9                            ; A3A0 A9 D9                    ..
        sta     $03D8,x                         ; A3A2 9D D8 03                 ...
        lda     #$00                            ; A3A5 A9 00                    ..
        sta     $03F0,x                         ; A3A7 9D F0 03                 ...
        jsr     entity_set_facing                           ; A3AA 20 16 EC                  ..
        lda     $0420,x                         ; A3AD BD 20 04                 . .
        ora     #$04                            ; A3B0 09 04                    ..
        sta     $0420,x                         ; A3B2 9D 20 04                 . .
        lda     #$42                            ; A3B5 A9 42                    .B
        sta     $0498,x                         ; A3B7 9D 98 04                 ...
        sta     $04C8,x                         ; A3BA 9D C8 04                 ...
        lda     #$03                            ; A3BD A9 03                    ..
        sta     $04B0,x                         ; A3BF 9D B0 04                 ...
        ldy     $0540,x                         ; A3C2 BC 40 05                 .@.
        lda     LA603,y                         ; A3C5 B9 03 A6                 ...
        sta     $0540,x                         ; A3C8 9D 40 05                 .@.
        lda     #$F3                            ; A3CB A9 F3                    ..
        sta     $0408,x                         ; A3CD 9D 08 04                 ...
        lda     $0540,x                         ; A3D0 BD 40 05                 .@.
        cmp     #$10                            ; A3D3 C9 10                    ..
        bne     LA3DC                           ; A3D5 D0 05                    ..
        lda     #$00                            ; A3D7 A9 00                    ..
        sta     $0570,x                         ; A3D9 9D 70 05                 .p.
LA3DC:  lda     $04C8,x                         ; A3DC BD C8 04                 ...
        bne     LA41E                           ; A3DF D0 3D                    .=
        jsr     entity_facing_dispatch                           ; A3E1 20 65 EA                  e.
        jsr     entity_vert_dispatch_raw                           ; A3E4 20 86 EA                  ..
        dec     $0498,x                         ; A3E7 DE 98 04                 ...
        bne     LA421                           ; A3EA D0 35                    .5
        lda     #$42                            ; A3EC A9 42                    .B
        sta     $0498,x                         ; A3EE 9D 98 04                 ...
        ldy     $04B0,x                         ; A3F1 BC B0 04                 ...
        lda     $0420,x                         ; A3F4 BD 20 04                 . .
        eor     #$0C                            ; A3F7 49 0C                    I.
        eor     LA5E8,y                         ; A3F9 59 E8 A5                 Y..
        sta     $0420,x                         ; A3FC 9D 20 04                 . .
        lda     LA5EC,y                         ; A3FF B9 EC A5                 ...
        sta     $04C8,x                         ; A402 9D C8 04                 ...
        lda     $04B0,x                         ; A405 BD B0 04                 ...
        and     #$01                            ; A408 29 01                    ).
        beq     LA40F                           ; A40A F0 03                    ..
        jsr     LA4B9                           ; A40C 20 B9 A4                  ..
LA40F:  dec     $04B0,x                         ; A40F DE B0 04                 ...
        bpl     LA421                           ; A412 10 0D                    ..
        lda     #$07                            ; A414 A9 07                    ..
        sta     $0588,x                         ; A416 9D 88 05                 ...
        lda     #$A3                            ; A419 A9 A3                    ..
        sta     $05A0,x                         ; A41B 9D A0 05                 ...
LA41E:  dec     $04C8,x                         ; A41E DE C8 04                 ...
LA421:  lda     $0540,x                         ; A421 BD 40 05                 .@.
        cmp     #$13                            ; A424 C9 13                    ..
        bcc     LA42F                           ; A426 90 07                    ..
        lda     #$A9                            ; A428 A9 A9                    ..
        sta     $0408,x                         ; A42A 9D 08 04                 ...
        bne     LA458                           ; A42D D0 29                    .)
LA42F:  lda     $0540,x                         ; A42F BD 40 05                 .@.
        bne     LA458                           ; A432 D0 24                    .$
        sta     $0570,x                         ; A434 9D 70 05                 .p.
        lda     #$A9                            ; A437 A9 A9                    ..
        sta     $0408,x                         ; A439 9D 08 04                 ...
        dec     $04E0,x                         ; A43C DE E0 04                 ...
        bne     LA458                           ; A43F D0 17                    ..
        lda     $E4                             ; A441 A5 E4                    ..
        adc     $E5                             ; A443 65 E5                    e.
        sta     $E5                             ; A445 85 E5                    ..
        and     #$03                            ; A447 29 03                    ).
        tay                                     ; A449 A8                       .
        lda     LA5FF,y                         ; A44A B9 FF A5                 ...
        sta     $04E0,x                         ; A44D 9D E0 04                 ...
        inc     $0540,x                         ; A450 FE 40 05                 .@.
        lda     #$F3                            ; A453 A9 F3                    ..
        sta     $0408,x                         ; A455 9D 08 04                 ...
LA458:  lda     #$98                            ; A458 A9 98                    ..
        sec                                     ; A45A 38                       8
        sbc     $0378,x                         ; A45B FD 78 03                 .x.
        sta     $FA                             ; A45E 85 FA                    ..
        lda     #$80                            ; A460 A9 80                    ..
        sec                                     ; A462 38                       8
        sbc     $0330,x                         ; A463 FD 30 03                 .0.
        sta     $78                             ; A466 85 78                    .x
        rts                                     ; A468 60                       `

; ----------------------------------------------------------------------------
LA469:  jsr     find_free_slot_y                           ; A469 20 6F F1                  o.
        bcs     LA4B8                           ; A46C B0 4A                    .J
        lda     #$BB                            ; A46E A9 BB                    ..
        jsr     entity_init_pos                           ; A470 20 A4 EA                  ..
        lda     #$7E                            ; A473 A9 7E                    .~
        sta     $0300,y                         ; A475 99 00 03                 ...
        lda     #$80                            ; A478 A9 80                    ..
        sta     $0408,y                         ; A47A 99 08 04                 ...
        lda     $0378,x                         ; A47D BD 78 03                 .x.
        sec                                     ; A480 38                       8
        sbc     #$44                            ; A481 E9 44                    .D
        sta     $0378,y                         ; A483 99 78 03                 .x.
        lda     $0390,x                         ; A486 BD 90 03                 ...
        sbc     #$00                            ; A489 E9 00                    ..
        sta     $0390,y                         ; A48B 99 90 03                 ...
        lda     #$7A                            ; A48E A9 7A                    .z
        sta     $03D8,y                         ; A490 99 D8 03                 ...
        lda     #$03                            ; A493 A9 03                    ..
        sta     $03F0,y                         ; A495 99 F0 03                 ...
        tya                                     ; A498 98                       .
        tax                                     ; A499 AA                       .
        jsr     entity_set_facing                           ; A49A 20 16 EC                  ..
        jsr     entity_x_dist_px                           ; A49D 20 94 EC                  ..
        ldy     #$04                            ; A4A0 A0 04                    ..
LA4A2:  cmp     LA5F0,y                         ; A4A2 D9 F0 A5                 ...
        bcs     LA4AA                           ; A4A5 B0 03                    ..
        dey                                     ; A4A7 88                       .
        bne     LA4A2                           ; A4A8 D0 F8                    ..
LA4AA:  lda     LA5F5,y                         ; A4AA B9 F5 A5                 ...
        sta     $03A8,x                         ; A4AD 9D A8 03                 ...
        lda     LA5FA,y                         ; A4B0 B9 FA A5                 ...
        sta     $03C0,x                         ; A4B3 9D C0 03                 ...
        ldx     $A6                             ; A4B6 A6 A6                    ..
LA4B8:  rts                                     ; A4B8 60                       `

; ----------------------------------------------------------------------------
LA4B9:  jsr     find_free_slot_y                           ; A4B9 20 6F F1                  o.
        bcs     LA4E3                           ; A4BC B0 25                    .%
        lda     #$BC                            ; A4BE A9 BC                    ..
        jsr     entity_init_pos                           ; A4C0 20 A4 EA                  ..
        lda     #$7F                            ; A4C3 A9 7F                    ..
        sta     $0300,y                         ; A4C5 99 00 03                 ...
        lda     #$85                            ; A4C8 A9 85                    ..
        sta     $0408,y                         ; A4CA 99 08 04                 ...
        lda     $0378,x                         ; A4CD BD 78 03                 .x.
        clc                                     ; A4D0 18                       .
        adc     #$14                            ; A4D1 69 14                    i.
        sta     $0378,y                         ; A4D3 99 78 03                 .x.
        tya                                     ; A4D6 98                       .
        tax                                     ; A4D7 AA                       .
        jsr     entity_distance_calc                           ; A4D8 20 C2 EC                  ..
        tay                                     ; A4DB A8                       .
        lda     #$28                            ; A4DC A9 28                    .(
        jsr     entity_set_dir_velocity                           ; A4DE 20 70 F4                  p.
        ldx     $A6                             ; A4E1 A6 A6                    ..
LA4E3:  rts                                     ; A4E3 60                       `

; ----------------------------------------------------------------------------
LA4E4:  jsr     find_free_slot_y                           ; A4E4 20 6F F1                  o.
        lda     #$BD                            ; A4E7 A9 BD                    ..
        jsr     entity_init_pos                           ; A4E9 20 A4 EA                  ..
        lda     $0528,y                         ; A4EC B9 28 05                 .(.
        ora     #$01                            ; A4EF 09 01                    ..
        sta     $0528,y                         ; A4F1 99 28 05                 .(.
        lda     #$7D                            ; A4F4 A9 7D                    .}
        sta     $0300,y                         ; A4F6 99 00 03                 ...
        lda     #$22                            ; A4F9 A9 22                    ."
        sta     $0408,y                         ; A4FB 99 08 04                 ...
        lda     #$BC                            ; A4FE A9 BC                    ..
        sta     $0378,y                         ; A500 99 78 03                 .x.
        lda     #$66                            ; A503 A9 66                    .f
        sta     $03A8,y                         ; A505 99 A8 03                 ...
        sta     $03D8,y                         ; A508 99 D8 03                 ...
        lda     #$00                            ; A50B A9 00                    ..
        sta     $03C0,y                         ; A50D 99 C0 03                 ...
        sta     $03F0,y                         ; A510 99 F0 03                 ...
        tya                                     ; A513 98                       .
        rts                                     ; A514 60                       `

; ----------------------------------------------------------------------------
LA515:  jsr     find_free_slot_y                           ; A515 20 6F F1                  o.
        lda     #$62                            ; A518 A9 62                    .b
        jsr     entity_init_pos                           ; A51A 20 A4 EA                  ..
        lda     #$B1                            ; A51D A9 B1                    ..
        sta     $0300,y                         ; A51F 99 00 03                 ...
        lda     #$EA                            ; A522 A9 EA                    ..
        sta     $0408,y                         ; A524 99 08 04                 ...
        lda     $0330,x                         ; A527 BD 30 03                 .0.
        sta     $0330,y                         ; A52A 99 30 03                 .0.
        txa                                     ; A52D 8A                       .
        sta     $0468,y                         ; A52E 99 68 04                 .h.
        tya                                     ; A531 98                       .
        rts                                     ; A532 60                       `

; ----------------------------------------------------------------------------
        jsr     entity_process_y_vel                           ; A533 20 68 E9                  h.
        jmp     entity_facing_dispatch                           ; A536 4C 65 EA                 Le.

; ----------------------------------------------------------------------------
        dec     $0378,x                         ; A539 DE 78 03                 .x.
        jsr     entity_player_collide                           ; A53C 20 87 EF                  ..
        inc     $0378,x                         ; A53F FE 78 03                 .x.
        bcs     LA5A3                           ; A542 B0 5F                    ._
        lda     #$82                            ; A544 A9 82                    ..
        sta     $0468,x                         ; A546 9D 68 04                 .h.
        lda     #$53                            ; A549 A9 53                    .S
        sta     $0588,x                         ; A54B 9D 88 05                 ...
        lda     #$A5                            ; A54E A9 A5                    ..
        sta     $05A0,x                         ; A550 9D A0 05                 ...
        dec     $0378,x                         ; A553 DE 78 03                 .x.
        jsr     entity_player_collide                           ; A556 20 87 EF                  ..
        inc     $0378,x                         ; A559 FE 78 03                 .x.
        bcs     LA578                           ; A55C B0 1A                    ..
        lda     $0420,x                         ; A55E BD 20 04                 . .
        sta     $39                             ; A561 85 39                    .9
        lda     $03A8,x                         ; A563 BD A8 03                 ...
        sta     $3A                             ; A566 85 3A                    .:
        lda     $03C0,x                         ; A568 BD C0 03                 ...
        sta     $3B                             ; A56B 85 3B                    .;
        jsr     entity_x_dist_px                           ; A56D 20 94 EC                  ..
        cmp     #$12                            ; A570 C9 12                    ..
        bcc     LA578                           ; A572 90 04                    ..
        lda     #$00                            ; A574 A9 00                    ..
        sta     $39                             ; A576 85 39                    .9
LA578:  jsr     entity_facing_dispatch                           ; A578 20 65 EA                  e.
        jsr     entity_vert_dispatch_raw                           ; A57B 20 86 EA                  ..
        dec     $0468,x                         ; A57E DE 68 04                 .h.
        bne     LA5A3                           ; A581 D0 20                    . 
        lda     #$82                            ; A583 A9 82                    ..
        sta     $0468,x                         ; A585 9D 68 04                 .h.
        lda     $0420,x                         ; A588 BD 20 04                 . .
        eor     #$0F                            ; A58B 49 0F                    I.
        sta     $0420,x                         ; A58D 9D 20 04                 . .
        and     #$08                            ; A590 29 08                    ).
        beq     LA5A3                           ; A592 F0 0F                    ..
        lda     #$BC                            ; A594 A9 BC                    ..
        sta     $0378,x                         ; A596 9D 78 03                 .x.
        lda     #$39                            ; A599 A9 39                    .9
        sta     $0588,x                         ; A59B 9D 88 05                 ...
        lda     #$A5                            ; A59E A9 A5                    ..
        sta     $05A0,x                         ; A5A0 9D A0 05                 ...
LA5A3:  rts                                     ; A5A3 60                       `

; ----------------------------------------------------------------------------
        .byte   $0F                             ; A5A4 0F                       .
        .byte   $37                             ; A5A5 37                       7
        .byte   $27                             ; A5A6 27                       '
        .byte   $03                             ; A5A7 03                       .
        .byte   $0F                             ; A5A8 0F                       .
        bmi     LA5D6                           ; A5A9 30 2B                    0+
        .byte   $1B                             ; A5AB 1B                       .
        .byte   $0F                             ; A5AC 0F                       .
        bmi     LA5C3                           ; A5AD 30 14                    0.
        .byte   $03                             ; A5AF 03                       .
        .byte   $0F                             ; A5B0 0F                       .
        .byte   $0F                             ; A5B1 0F                       .
        .byte   $37                             ; A5B2 37                       7
        .byte   $27                             ; A5B3 27                       '
        .byte   $0F                             ; A5B4 0F                       .
        bmi     LA5C7                           ; A5B5 30 10                    0.
        .byte   $1C                             ; A5B7 1C                       .
LA5B8:  ora     #$0A                            ; A5B8 09 0A                    ..
        .byte   $0B                             ; A5BA 0B                       .
        .byte   $0C                             ; A5BB 0C                       .
        ora     $0F0E                           ; A5BC 0D 0E 0F                 ...
        brk                                     ; A5BF 00                       .
        .byte   $0F                             ; A5C0 0F                       .
        .byte   $0E                             ; A5C1 0E                       .
        .byte   $0D                             ; A5C2 0D                       .
LA5C3:  .byte   $0C                             ; A5C3 0C                       .
        .byte   $0B                             ; A5C4 0B                       .
        asl     a                               ; A5C5 0A                       .
        .byte   $09                             ; A5C6 09                       .
LA5C7:  php                                     ; A5C7 08                       .
        .byte   $07                             ; A5C8 07                       .
        asl     $05                             ; A5C9 06 05                    ..
        .byte   $04                             ; A5CB 04                       .
        .byte   $03                             ; A5CC 03                       .
        .byte   $02                             ; A5CD 02                       .
        ora     (L0000,x)                       ; A5CE 01 00                    ..
        ora     ($02,x)                         ; A5D0 01 02                    ..
        .byte   $03                             ; A5D2 03                       .
        .byte   $04                             ; A5D3 04                       .
        ora     $06                             ; A5D4 05 06                    ..
LA5D6:  .byte   $07                             ; A5D6 07                       .
        php                                     ; A5D7 08                       .
        ora     #$0A                            ; A5D8 09 0A                    ..
        .byte   $0B                             ; A5DA 0B                       .
        .byte   $0C                             ; A5DB 0C                       .
        ora     $0F0E                           ; A5DC 0D 0E 0F                 ...
        brk                                     ; A5DF 00                       .
        .byte   $0F                             ; A5E0 0F                       .
        asl     $0C0D                           ; A5E1 0E 0D 0C                 ...
        .byte   $0B                             ; A5E4 0B                       .
        asl     a                               ; A5E5 0A                       .
        ora     #$08                            ; A5E6 09 08                    ..
LA5E8:  brk                                     ; A5E8 00                       .
        .byte   $03                             ; A5E9 03                       .
        brk                                     ; A5EA 00                       .
        .byte   $03                             ; A5EB 03                       .
LA5EC:  .byte   $3C                             ; A5EC 3C                       <
        brk                                     ; A5ED 00                       .
        brk                                     ; A5EE 00                       .
        brk                                     ; A5EF 00                       .
LA5F0:  rti                                     ; A5F0 40                       @

; ----------------------------------------------------------------------------
        rts                                     ; A5F1 60                       `

; ----------------------------------------------------------------------------
        .byte   $80                             ; A5F2 80                       .
        ldy     #$C0                            ; A5F3 A0 C0                    ..
LA5F5:  .byte   $47                             ; A5F5 47                       G
        .byte   $EB                             ; A5F6 EB                       .
        .byte   $8F                             ; A5F7 8F                       .
        .byte   $33                             ; A5F8 33                       3
        .byte   $D7                             ; A5F9 D7                       .
LA5FA:  ora     ($01,x)                         ; A5FA 01 01                    ..
        .byte   $02                             ; A5FC 02                       .
        .byte   $03                             ; A5FD 03                       .
        .byte   $03                             ; A5FE 03                       .
LA5FF:  asl     $5A3C,x                         ; A5FF 1E 3C 5A                 .<Z
        sei                                     ; A602 78                       x
LA603:  ora     ($01,x)                         ; A603 01 01                    ..
        bpl     LA617                           ; A605 10 10                    ..
        bpl     LA619                           ; A607 10 10                    ..
        bpl     LA61B                           ; A609 10 10                    ..
        bpl     LA61D                           ; A60B 10 10                    ..
        bpl     LA61F                           ; A60D 10 10                    ..
        bpl     LA621                           ; A60F 10 10                    ..
        bpl     LA623                           ; A611 10 10                    ..
        bpl     LA625                           ; A613 10 10                    ..
        ora     ($01,x)                         ; A615 01 01                    ..
LA617:  ora     ($01,x)                         ; A617 01 01                    ..
LA619:  ora     (L0020,x)                       ; A619 01 20                    . 
LA61B:  ldx     $84                             ; A61B A6 84                    ..
LA61D:  bcs     LA5A3                           ; A61D B0 84                    ..
LA61F:  lda     #$80                            ; A61F A9 80                    ..
LA621:  sta     $1E                             ; A621 85 1E                    ..
LA623:  lda     #$07                            ; A623 A9 07                    ..
LA625:  sta     $23                             ; A625 85 23                    .#
        lda     #$31                            ; A627 A9 31                    .1
        sta     $0588,x                         ; A629 9D 88 05                 ...
        lda     #$A6                            ; A62C A9 A6                    ..
        sta     $05A0,x                         ; A62E 9D A0 05                 ...
        lda     $1E                             ; A631 A5 1E                    ..
        bne     LA69E                           ; A633 D0 69                    .i
        jsr     L84D5                           ; A635 20 D5 84                  ..
        inc     $46                             ; A638 E6 46                    .F
        lda     #$4D                            ; A63A A9 4D                    .M
        sta     $0588,x                         ; A63C 9D 88 05                 ...
        lda     #$A6                            ; A63F A9 A6                    ..
        sta     $05A0,x                         ; A641 9D A0 05                 ...
        lda     #$30                            ; A644 A9 30                    .0
        sta     $0468,x                         ; A646 9D 68 04                 .h.
        lda     #$B0                            ; A649 A9 B0                    ..
        sta     $FA                             ; A64B 85 FA                    ..
        lda     #$BD                            ; A64D A9 BD                    ..
        sta     L0000                           ; A64F 85 00                    ..
        lda     #$A7                            ; A651 A9 A7                    ..
        sta     $01                             ; A653 85 01                    ..
        jsr     L8420                           ; A655 20 20 84                   .
        bcs     LA69E                           ; A658 B0 44                    .D
        jsr     find_free_slot_y                           ; A65A 20 6F F1                  o.
        lda     #$62                            ; A65D A9 62                    .b
        jsr     entity_init_pos                           ; A65F 20 A4 EA                  ..
        lda     #$A1                            ; A662 A9 A1                    ..
        sta     $0300,y                         ; A664 99 00 03                 ...
        lda     #$38                            ; A667 A9 38                    .8
        sta     $0378,y                         ; A669 99 78 03                 .x.
        lda     #$DD                            ; A66C A9 DD                    ..
        sta     $0408,y                         ; A66E 99 08 04                 ...
        txa                                     ; A671 8A                       .
        sta     $0468,y                         ; A672 99 68 04                 .h.
        lda     $E4                             ; A675 A5 E4                    ..
        adc     $E6                             ; A677 65 E6                    e.
        sta     $E6                             ; A679 85 E6                    ..
        and     #$03                            ; A67B 29 03                    ).
        tay                                     ; A67D A8                       .
        lda     LA7D5,y                         ; A67E B9 D5 A7                 ...
        sta     $0468,x                         ; A681 9D 68 04                 .h.
        lda     LA7D9,y                         ; A684 B9 D9 A7                 ...
        sta     $0480,x                         ; A687 9D 80 04                 ...
        lda     #$00                            ; A68A A9 00                    ..
        sta     $03D8,x                         ; A68C 9D D8 03                 ...
        lda     #$02                            ; A68F A9 02                    ..
        sta     $03F0,x                         ; A691 9D F0 03                 ...
        lda     #$9F                            ; A694 A9 9F                    ..
        sta     $0588,x                         ; A696 9D 88 05                 ...
        lda     #$A6                            ; A699 A9 A6                    ..
        sta     $05A0,x                         ; A69B 9D A0 05                 ...
LA69E:  rts                                     ; A69E 60                       `

; ----------------------------------------------------------------------------
        lda     #$55                            ; A69F A9 55                    .U
        cmp     $0558,x                         ; A6A1 DD 58 05                 .X.
        beq     LA6B0                           ; A6A4 F0 0A                    ..
        ldy     $0540,x                         ; A6A6 BC 40 05                 .@.
        cpy     #$02                            ; A6A9 C0 02                    ..
        bne     LA6B0                           ; A6AB D0 03                    ..
        jsr     entity_set_subtype                           ; A6AD 20 98 EA                  ..
LA6B0:  lda     $0498,x                         ; A6B0 BD 98 04                 ...
        bne     LA6BD                           ; A6B3 D0 08                    ..
        lda     #$14                            ; A6B5 A9 14                    ..
        sta     $0498,x                         ; A6B7 9D 98 04                 ...
        jsr     entity_set_facing                           ; A6BA 20 16 EC                  ..
LA6BD:  jsr     entity_facing_dispatch                           ; A6BD 20 65 EA                  e.
        lda     $0528,x                         ; A6C0 BD 28 05                 .(.
        and     #$DF                            ; A6C3 29 DF                    ).
        sta     $0528,x                         ; A6C5 9D 28 05                 .(.
        lda     $0420,x                         ; A6C8 BD 20 04                 . .
        and     #$01                            ; A6CB 29 01                    ).
        beq     LA6D8                           ; A6CD F0 09                    ..
        lda     $0330,x                         ; A6CF BD 30 03                 .0.
        cmp     #$C8                            ; A6D2 C9 C8                    ..
        bcs     LA6DF                           ; A6D4 B0 09                    ..
        bcc     LA6E7                           ; A6D6 90 0F                    ..
LA6D8:  lda     $0330,x                         ; A6D8 BD 30 03                 .0.
        cmp     #$39                            ; A6DB C9 39                    .9
        bcs     LA6E7                           ; A6DD B0 08                    ..
LA6DF:  lda     $0420,x                         ; A6DF BD 20 04                 . .
        eor     #$03                            ; A6E2 49 03                    I.
        sta     $0420,x                         ; A6E4 9D 20 04                 . .
LA6E7:  dec     $0498,x                         ; A6E7 DE 98 04                 ...
        lda     $0468,x                         ; A6EA BD 68 04                 .h.
        sec                                     ; A6ED 38                       8
        sbc     #$01                            ; A6EE E9 01                    ..
        sta     $0468,x                         ; A6F0 9D 68 04                 .h.
        lda     $0480,x                         ; A6F3 BD 80 04                 ...
        sbc     #$00                            ; A6F6 E9 00                    ..
        sta     $0480,x                         ; A6F8 9D 80 04                 ...
        ora     $0468,x                         ; A6FB 1D 68 04                 .h.
        bne     LA741                           ; A6FE D0 41                    .A
        lda     #$08                            ; A700 A9 08                    ..
        sta     $0420,x                         ; A702 9D 20 04                 . .
        lda     #$32                            ; A705 A9 32                    .2
        sta     $0498,x                         ; A707 9D 98 04                 ...
        lda     #$19                            ; A70A A9 19                    ..
        sta     $0588,x                         ; A70C 9D 88 05                 ...
        lda     #$A7                            ; A70F A9 A7                    ..
        sta     $05A0,x                         ; A711 9D A0 05                 ...
        lda     #$56                            ; A714 A9 56                    .V
        jsr     entity_set_subtype                           ; A716 20 98 EA                  ..
        lda     #$57                            ; A719 A9 57                    .W
        cmp     $0558,x                         ; A71B DD 58 05                 .X.
        beq     LA72A                           ; A71E F0 0A                    ..
        ldy     $0540,x                         ; A720 BC 40 05                 .@.
        cpy     #$02                            ; A723 C0 02                    ..
        bne     LA72A                           ; A725 D0 03                    ..
        jsr     entity_set_subtype                           ; A727 20 98 EA                  ..
LA72A:  lda     $0498,x                         ; A72A BD 98 04                 ...
        beq     LA743                           ; A72D F0 14                    ..
        dec     $0498,x                         ; A72F DE 98 04                 ...
        bne     LA781                           ; A732 D0 4D                    .M
        lda     #$20                            ; A734 A9 20                    . 
        sta     $0468,x                         ; A736 9D 68 04                 .h.
        lda     $0420,x                         ; A739 BD 20 04                 . .
        eor     #$0C                            ; A73C 49 0C                    I.
        sta     $0420,x                         ; A73E 9D 20 04                 . .
LA741:  bne     LA781                           ; A741 D0 3E                    .>
LA743:  jsr     entity_vert_dispatch_raw                           ; A743 20 86 EA                  ..
        dec     $0468,x                         ; A746 DE 68 04                 .h.
        bne     LA781                           ; A749 D0 36                    .6
        lda     #$14                            ; A74B A9 14                    ..
        sta     $0498,x                         ; A74D 9D 98 04                 ...
        lda     $0420,x                         ; A750 BD 20 04                 . .
        and     #$08                            ; A753 29 08                    ).
        bne     LA772                           ; A755 D0 1B                    ..
        jsr     find_free_slot_y                           ; A757 20 6F F1                  o.
        bcs     LA781                           ; A75A B0 25                    .%
        lda     #$5A                            ; A75C A9 5A                    .Z
        jsr     entity_init_pos                           ; A75E 20 A4 EA                  ..
        lda     #$80                            ; A761 A9 80                    ..
        sta     $0378,y                         ; A763 99 78 03                 .x.
        lda     #$6D                            ; A766 A9 6D                    .m
        sta     $0300,y                         ; A768 99 00 03                 ...
        lda     #$00                            ; A76B A9 00                    ..
        sta     $0408,y                         ; A76D 99 08 04                 ...
        beq     LA781                           ; A770 F0 0F                    ..
LA772:  lda     #$75                            ; A772 A9 75                    .u
        sta     $0588,x                         ; A774 9D 88 05                 ...
        lda     #$A6                            ; A777 A9 A6                    ..
        sta     $05A0,x                         ; A779 9D A0 05                 ...
LA77C:  lda     #$56                            ; A77C A9 56                    .V
        jsr     entity_set_subtype                           ; A77E 20 98 EA                  ..
LA781:  lda     #$C8                            ; A781 A9 C8                    ..
        sec                                     ; A783 38                       8
        sbc     $0378,x                         ; A784 FD 78 03                 .x.
        sta     $FA                             ; A787 85 FA                    ..
        lda     #$80                            ; A789 A9 80                    ..
        sec                                     ; A78B 38                       8
        sbc     $0330,x                         ; A78C FD 30 03                 .0.
        sta     $78                             ; A78F 85 78                    .x
        lda     #$D7                            ; A791 A9 D7                    ..
        sec                                     ; A793 38                       8
        sbc     $0378,x                         ; A794 FD 78 03                 .x.
        sta     $9B                             ; A797 85 9B                    ..
        lda     #$BF                            ; A799 A9 BF                    ..
        sec                                     ; A79B 38                       8
        sbc     $9B                             ; A79C E5 9B                    ..
        sta     $79                             ; A79E 85 79                    .y
        ldy     $0558,x                         ; A7A0 BC 58 05                 .X.
        lda     LA77C,y                         ; A7A3 B9 7C A7                 .|.
        sta     $0408,x                         ; A7A6 9D 08 04                 ...
        rts                                     ; A7A9 60                       `

; ----------------------------------------------------------------------------
        ldy     $0468,x                         ; A7AA BC 68 04                 .h.
        lda     $0378,y                         ; A7AD B9 78 03                 .x.
        clc                                     ; A7B0 18                       .
        adc     #$20                            ; A7B1 69 20                    i 
        sta     $0378,x                         ; A7B3 9D 78 03                 .x.
        lda     $0330,y                         ; A7B6 B9 30 03                 .0.
        sta     $0330,x                         ; A7B9 9D 30 03                 .0.
        rts                                     ; A7BC 60                       `

; ----------------------------------------------------------------------------
        .byte   $0F                             ; A7BD 0F                       .
        bmi     LA7E7                           ; A7BE 30 27                    0'
        .byte   $07                             ; A7C0 07                       .
        .byte   $0F                             ; A7C1 0F                       .
        bmi     LA7E6                           ; A7C2 30 22                    0"
        .byte   $13                             ; A7C4 13                       .
        .byte   $0F                             ; A7C5 0F                       .
        bmi     LA7ED                           ; A7C6 30 25                    0%
        ora     $0F,x                           ; A7C8 15 0F                    ..
        .byte   $0F                             ; A7CA 0F                       .
        plp                                     ; A7CB 28                       (
        asl     $0F,x                           ; A7CC 16 0F                    ..
        .byte   $22                             ; A7CE 22                       "
        jsr     L8936                           ; A7CF 20 36 89                  6.
        .byte   $89                             ; A7D2 89                       .
        cmp     #$00                            ; A7D3 C9 00                    ..
LA7D5:  bit     $C82C                           ; A7D5 2C 2C C8                 ,,.
        .byte   $96                             ; A7D8 96                       .
LA7D9:  ora     ($01,x)                         ; A7D9 01 01                    ..
        brk                                     ; A7DB 00                       .
        brk                                     ; A7DC 00                       .
        .byte   $77                             ; A7DD 77                       w
        .byte   $FF                             ; A7DE FF                       .
        .byte   $FF                             ; A7DF FF                       .
        .byte   $FF                             ; A7E0 FF                       .
        .byte   $D7                             ; A7E1 D7                       .
        .byte   $DF                             ; A7E2 DF                       .
        .byte   $FF                             ; A7E3 FF                       .
        .byte   $FF                             ; A7E4 FF                       .
        .byte   $7D                             ; A7E5 7D                       }
LA7E6:  .byte   $FF                             ; A7E6 FF                       .
LA7E7:  .byte   $DF                             ; A7E7 DF                       .
        .byte   $F7                             ; A7E8 F7                       .
        cmp     $8FFF,x                         ; A7E9 DD FF 8F                 ...
        .byte   $FF                             ; A7EC FF                       .
LA7ED:  .byte   $FF                             ; A7ED FF                       .
        .byte   $FF                             ; A7EE FF                       .
        adc     $FE,x                           ; A7EF 75 FE                    u.
        .byte   $7F                             ; A7F1 7F                       .
        .byte   $FF                             ; A7F2 FF                       .
        sbc     $FF,x                           ; A7F3 F5 FF                    ..
        cmp     $45FF,x                         ; A7F5 DD FF 45                 ..E
        .byte   $FF                             ; A7F8 FF                       .
        sbc     $FF,x                           ; A7F9 F5 FF                    ..
        sbc     $77FF,x                         ; A7FB FD FF 77                 ..w
        .byte   $FF                             ; A7FE FF                       .
        .byte   $5F                             ; A7FF 5F                       _
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
        ora     ($01,x)                         ; A819 01 01                    ..
        .byte   $02                             ; A81B 02                       .
        ora     ($01,x)                         ; A81C 01 01                    ..
        brk                                     ; A81E 00                       .
        brk                                     ; A81F 00                       .
        .byte   $04                             ; A820 04                       .
        .byte   $03                             ; A821 03                       .
        brk                                     ; A822 00                       .
        brk                                     ; A823 00                       .
        brk                                     ; A824 00                       .
        ora     (L0000,x)                       ; A825 01 00                    ..
        brk                                     ; A827 00                       .
        .byte   $03                             ; A828 03                       .
        ora     ($03,x)                         ; A829 01 03                    ..
        ora     (L0000,x)                       ; A82B 01 00                    ..
        brk                                     ; A82D 00                       .
        brk                                     ; A82E 00                       .
        brk                                     ; A82F 00                       .
        brk                                     ; A830 00                       .
        .byte   $02                             ; A831 02                       .
        ora     ($01,x)                         ; A832 01 01                    ..
        ora     (L0000,x)                       ; A834 01 00                    ..
        ora     (L0000,x)                       ; A836 01 00                    ..
        brk                                     ; A838 00                       .
        ora     ($01,x)                         ; A839 01 01                    ..
        .byte   $03                             ; A83B 03                       .
        brk                                     ; A83C 00                       .
        brk                                     ; A83D 00                       .
        ora     (L0000,x)                       ; A83E 01 00                    ..
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
        ora     ($01,x)                         ; A84F 01 01                    ..
        brk                                     ; A851 00                       .
        ora     ($01,x)                         ; A852 01 01                    ..
        ora     (L0000,x)                       ; A854 01 00                    ..
        ora     (L0000,x)                       ; A856 01 00                    ..
        brk                                     ; A858 00                       .
        .byte   $02                             ; A859 02                       .
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
        ora     ($04,x)                         ; A87B 01 04                    ..
        brk                                     ; A87D 00                       .
        brk                                     ; A87E 00                       .
        brk                                     ; A87F 00                       .
        brk                                     ; A880 00                       .
        ora     (L0000,x)                       ; A881 01 00                    ..
        .byte   $04                             ; A883 04                       .
        brk                                     ; A884 00                       .
        brk                                     ; A885 00                       .
        ora     (L0000,x)                       ; A886 01 00                    ..
        brk                                     ; A888 00                       .
        ora     (L0000,x)                       ; A889 01 00                    ..
        brk                                     ; A88B 00                       .
        brk                                     ; A88C 00                       .
        ora     (L0000,x)                       ; A88D 01 00                    ..
        brk                                     ; A88F 00                       .
        brk                                     ; A890 00                       .
        ora     (L0000,x)                       ; A891 01 00                    ..
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
        ora     $1F1E,x                         ; A91D 1D 1E 1F                 ...
        jsr     L0021                           ; A920 20 21 00                  !.
LA923:  brk                                     ; A923 00                       .
        brk                                     ; A924 00                       .
        brk                                     ; A925 00                       .
        .byte   $80                             ; A926 80                       .
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
        .byte   $02                             ; A934 02                       .
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
        .byte   $04                             ; A94F 04                       .
        .byte   $23                             ; A950 23                       #
        ldy     #$20                            ; A951 A0 20                    . 
        jsr     L2000                           ; A953 20 00 20                  . 
        .byte   $22                             ; A956 22                       "
        ldy     #$22                            ; A957 A0 22                    ."
        ldy     #$20                            ; A959 A0 20                    . 
        brk                                     ; A95B 00                       .
        bit     $A0                             ; A95C 24 A0                    $.
        .byte   $22                             ; A95E 22                       "
        ldy     #$20                            ; A95F A0 20                    . 
        brk                                     ; A961 00                       .
        .byte   $23                             ; A962 23                       #
        jsr     L0020                           ; A963 20 20 00                   .
        brk                                     ; A966 00                       .
        brk                                     ; A967 00                       .
        asl     $06                             ; A968 06 06                    ..
        .byte   $07                             ; A96A 07                       .
        rti                                     ; A96B 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; A96C 00                       .
        asl     $08                             ; A96D 06 08                    ..
        .byte   $1C                             ; A96F 1C                       .
        asl     $1C                             ; A970 06 1C                    ..
        pha                                     ; A972 48                       H
        brk                                     ; A973 00                       .
        .byte   $0B                             ; A974 0B                       .
        .byte   $1C                             ; A975 1C                       .
        lsr     a                               ; A976 4A                       J
        asl     a:$40,x                         ; A977 1E 40 00                 .@.
        .byte   $1C                             ; A97A 1C                       .
        .byte   $80                             ; A97B 80                       .
        lda     L0000,x                         ; A97C B5 00                    ..
        brk                                     ; A97E 00                       .
        brk                                     ; A97F 00                       .
        dey                                     ; A980 88                       .
        txa                                     ; A981 8A                       .
        brk                                     ; A982 00                       .
        brk                                     ; A983 00                       .
        brk                                     ; A984 00                       .
        brk                                     ; A985 00                       .
        brk                                     ; A986 00                       .
        brk                                     ; A987 00                       .
        .byte   $0F                             ; A988 0F                       .
        and     $1727,y                         ; A989 39 27 17                 9'.
        .byte   $0F                             ; A98C 0F                       .
        ora     $0609,y                         ; A98D 19 09 06                 ...
        .byte   $0F                             ; A990 0F                       .
        and     ($14,x)                         ; A991 21 14                    !.
        .byte   $12                             ; A993 12                       .
        .byte   $0F                             ; A994 0F                       .
        jsr     L1221                           ; A995 20 21 12                  !.
        brk                                     ; A998 00                       .
        brk                                     ; A999 00                       .
        brk                                     ; A99A 00                       .
        brk                                     ; A99B 00                       .
        .byte   $0F                             ; A99C 0F                       .
        and     $1727,y                         ; A99D 39 27 17                 9'.
        .byte   $0F                             ; A9A0 0F                       .
        ora     $0609,y                         ; A9A1 19 09 06                 ...
        .byte   $0F                             ; A9A4 0F                       .
        jsr     L1626                           ; A9A5 20 26 16                  &.
        .byte   $0F                             ; A9A8 0F                       .
        jsr     L1221                           ; A9A9 20 21 12                  !.
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
        .byte   $80                             ; A9C8 80                       .
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
        ora     $80                             ; A9E0 05 80                    ..
        .byte   $07                             ; A9E2 07                       .
        ora     $07                             ; A9E3 05 07                    ..
        rti                                     ; A9E5 40                       @

; ----------------------------------------------------------------------------
        ora     $02                             ; A9E6 05 02                    ..
        .byte   $0F                             ; A9E8 0F                       .
        .byte   $80                             ; A9E9 80                       .
        ora     ($0C),y                         ; A9EA 11 0C                    ..
        ora     ($40),y                         ; A9EC 11 40                    .@
        .byte   $0F                             ; A9EE 0F                       .
        ora     #$1A                            ; A9EF 09 1A                    ..
        .byte   $80                             ; A9F1 80                       .
        .byte   $1C                             ; A9F2 1C                       .
        .byte   $12                             ; A9F3 12                       .
        .byte   $1C                             ; A9F4 1C                       .
        rti                                     ; A9F5 40                       @

; ----------------------------------------------------------------------------
        .byte   $1A                             ; A9F6 1A                       .
        .byte   $0F                             ; A9F7 0F                       .
        .byte   $FF                             ; A9F8 FF                       .
        brk                                     ; A9F9 00                       .
        brk                                     ; A9FA 00                       .
        brk                                     ; A9FB 00                       .
        .byte   $02                             ; A9FC 02                       .
        rti                                     ; A9FD 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; A9FE 00                       .
        brk                                     ; A9FF 00                       .
        ora     ($01,x)                         ; AA00 01 01                    ..
        .byte   $02                             ; AA02 02                       .
        .byte   $03                             ; AA03 03                       .
        .byte   $03                             ; AA04 03                       .
        .byte   $04                             ; AA05 04                       .
        .byte   $04                             ; AA06 04                       .
        .byte   $04                             ; AA07 04                       .
        ora     $05                             ; AA08 05 05                    ..
        ora     $06                             ; AA0A 05 06                    ..
        .byte   $07                             ; AA0C 07                       .
        .byte   $07                             ; AA0D 07                       .
        .byte   $07                             ; AA0E 07                       .
        php                                     ; AA0F 08                       .
        php                                     ; AA10 08                       .
        ora     #$09                            ; AA11 09 09                    ..
        ora     #$0A                            ; AA13 09 0A                    ..
        asl     a                               ; AA15 0A                       .
        .byte   $0B                             ; AA16 0B                       .
        .byte   $0B                             ; AA17 0B                       .
        .byte   $0B                             ; AA18 0B                       .
        .byte   $0B                             ; AA19 0B                       .
LAA1A:  .byte   $0C                             ; AA1A 0C                       .
        .byte   $0C                             ; AA1B 0C                       .
        .byte   $0C                             ; AA1C 0C                       .
        ora     $0D0D                           ; AA1D 0D 0D 0D                 ...
        ora     $0E0D                           ; AA20 0D 0D 0E                 ...
        asl     $0F0E                           ; AA23 0E 0E 0F                 ...
LAA26:  .byte   $0F                             ; AA26 0F                       .
        .byte   $0F                             ; AA27 0F                       .
        bpl     LAA3A                           ; AA28 10 10                    ..
        bpl     LAA3D                           ; AA2A 10 11                    ..
        .byte   $12                             ; AA2C 12                       .
        .byte   $12                             ; AA2D 12                       .
        .byte   $12                             ; AA2E 12                       .
        .byte   $12                             ; AA2F 12                       .
        .byte   $12                             ; AA30 12                       .
        .byte   $12                             ; AA31 12                       .
        .byte   $12                             ; AA32 12                       .
        .byte   $12                             ; AA33 12                       .
        .byte   $13                             ; AA34 13                       .
        .byte   $13                             ; AA35 13                       .
LAA36:  .byte   $13                             ; AA36 13                       .
        .byte   $13                             ; AA37 13                       .
LAA38:  .byte   $13                             ; AA38 13                       .
LAA39:  .byte   $13                             ; AA39 13                       .
LAA3A:  .byte   $14                             ; AA3A 14                       .
        .byte   $14                             ; AA3B 14                       .
        .byte   $14                             ; AA3C 14                       .
LAA3D:  .byte   $14                             ; AA3D 14                       .
        ora     $15,x                           ; AA3E 15 15                    ..
        ora     $15,x                           ; AA40 15 15                    ..
        asl     $17,x                           ; AA42 16 17                    ..
        .byte   $17                             ; AA44 17                       .
        .byte   $17                             ; AA45 17                       .
        .byte   $17                             ; AA46 17                       .
        clc                                     ; AA47 18                       .
        clc                                     ; AA48 18                       .
        clc                                     ; AA49 18                       .
        clc                                     ; AA4A 18                       .
        ora     $1919,y                         ; AA4B 19 19 19                 ...
        ora     $1B1A,y                         ; AA4E 19 1A 1B                 ...
        .byte   $1B                             ; AA51 1B                       .
        ora     $1D1D,x                         ; AA52 1D 1D 1D                 ...
        asl     $1E1E,x                         ; AA55 1E 1E 1E                 ...
        asl     $1F1F,x                         ; AA58 1E 1F 1F                 ...
        and     ($FF,x)                         ; AA5B 21 FF                    !.
        brk                                     ; AA5D 00                       .
        brk                                     ; AA5E 00                       .
        brk                                     ; AA5F 00                       .
        brk                                     ; AA60 00                       .
LAA61:  brk                                     ; AA61 00                       .
        brk                                     ; AA62 00                       .
        brk                                     ; AA63 00                       .
        brk                                     ; AA64 00                       .
        brk                                     ; AA65 00                       .
        brk                                     ; AA66 00                       .
        brk                                     ; AA67 00                       .
        brk                                     ; AA68 00                       .
LAA69:  brk                                     ; AA69 00                       .
LAA6A:  brk                                     ; AA6A 00                       .
        brk                                     ; AA6B 00                       .
        brk                                     ; AA6C 00                       .
        brk                                     ; AA6D 00                       .
        brk                                     ; AA6E 00                       .
        brk                                     ; AA6F 00                       .
LAA70:  brk                                     ; AA70 00                       .
        brk                                     ; AA71 00                       .
        brk                                     ; AA72 00                       .
        brk                                     ; AA73 00                       .
        brk                                     ; AA74 00                       .
        ora     (L0000,x)                       ; AA75 01 00                    ..
        brk                                     ; AA77 00                       .
        brk                                     ; AA78 00                       .
        brk                                     ; AA79 00                       .
        brk                                     ; AA7A 00                       .
        brk                                     ; AA7B 00                       .
        brk                                     ; AA7C 00                       .
        brk                                     ; AA7D 00                       .
        brk                                     ; AA7E 00                       .
        brk                                     ; AA7F 00                       .
        jsr     L70C0                           ; AA80 20 C0 70                  .p
        bmi     LAAED                           ; AA83 30 68                    0h
        pha                                     ; AA85 48                       H
        bne     LAA70                           ; AA86 D0 E8                    ..
        bvs     LAA1A                           ; AA88 70 90                    p.
        cld                                     ; AA8A D8                       .
        bcs     LAADD                           ; AA8B B0 50                    .P
        .byte   $80                             ; AA8D 80                       .
        .byte   $E0                             ; AA8E E0                       .
LAA8F:  .byte   $B0,$E8                    ; AA8F B0 E8   (branch out of range for ca65: target has no local label)
        bpl     LAAE3                           ; AA91 10 50                    .P
        .byte   $80                             ; AA93 80                       .
        bmi     LAA26                           ; AA94 30 90                    0.
        plp                                     ; AA96 28                       (
        bvc     LAA39                           ; AA97 50 A0                    P.
        lda     $8070,y                         ; AA99 B9 70 80                 .p.
        beq     LAAAE                           ; AA9C F0 10                    ..
        .byte   $6F                             ; AA9E 6F                       o
        adc     ($B0),y                         ; AA9F 71 B0                    q.
        beq     LAAF3                           ; AAA1 F0 50                    .P
        ldy     #$A0                            ; AAA3 A0 A0                    ..
        brk                                     ; AAA5 00                       .
        bmi     LAA38                           ; AAA6 30 90                    0.
        pla                                     ; AAA8 68                       h
        tay                                     ; AAA9 A8                       .
        cld                                     ; AAAA D8                       .
        jsr     L0402                           ; AAAB 20 02 04                  ..
LAAAE:  jsr     L6020                           ; AAAE 20 20 60                   `
        stx     $97,y                           ; AAB1 96 97                    ..
        tya                                     ; AAB3 98                       .
        bmi     LAA36                           ; AAB4 30 80                    0.
        sta     ($90,x)                         ; AAB6 81 90                    ..
        cpx     #$E1                            ; AAB8 E0 E1                    ..
        bcc     LAA6A                           ; AABA 90 AE                    ..
        .byte   $AF                             ; AABC AF                       .
        beq     LAADF                           ; AABD F0 20                    . 
        and     ($22,x)                         ; AABF 21 22                    !"
        clv                                     ; AAC1 B8                       .
        bmi     LAB24                           ; AAC2 30 60                    0`
        .byte   $61                             ; AAC4 61                       a
LAAC5:  dey                                     ; AAC5 88                       .
        cpy     #$10                            ; AAC6 C0 10                    ..
        ora     ($88),y                         ; AAC8 11 88                    ..
        ldy     #$18                            ; AACA A0 18                    ..
        rti                                     ; AACC 40                       @

; ----------------------------------------------------------------------------
        .byte   $50                             ; AACD 50                       P
LAACE:  cpy     #$50                            ; AACE C0 50                    .P
        .byte   $90,$B0                    ; AAD0 90 B0   (branch out of range for ca65: target has no local label)
        jsr     $F0B0                           ; AAD2 20 B0 F0                  ..
        bpl     LAB17                           ; AAD5 10 40                    .@
        bvs     LAA69                           ; AAD7 70 90                    p.
        sei                                     ; AAD9 78                       x
        adc     $FFD8,y                         ; AADA 79 D8 FF                 y..
LAADD:  brk                                     ; AADD 00                       .
        brk                                     ; AADE 00                       .
LAADF:  brk                                     ; AADF 00                       .
        brk                                     ; AAE0 00                       .
        brk                                     ; AAE1 00                       .
        brk                                     ; AAE2 00                       .
LAAE3:  brk                                     ; AAE3 00                       .
        brk                                     ; AAE4 00                       .
        brk                                     ; AAE5 00                       .
        brk                                     ; AAE6 00                       .
        brk                                     ; AAE7 00                       .
LAAE8:  brk                                     ; AAE8 00                       .
        brk                                     ; AAE9 00                       .
        brk                                     ; AAEA 00                       .
        brk                                     ; AAEB 00                       .
        brk                                     ; AAEC 00                       .
LAAED:  brk                                     ; AAED 00                       .
        brk                                     ; AAEE 00                       .
        brk                                     ; AAEF 00                       .
LAAF0:  brk                                     ; AAF0 00                       .
        brk                                     ; AAF1 00                       .
        brk                                     ; AAF2 00                       .
LAAF3:  brk                                     ; AAF3 00                       .
        jsr     L0000                           ; AAF4 20 00 00                  ..
        brk                                     ; AAF7 00                       .
        brk                                     ; AAF8 00                       .
        brk                                     ; AAF9 00                       .
        brk                                     ; AAFA 00                       .
        php                                     ; AAFB 08                       .
        brk                                     ; AAFC 00                       .
        brk                                     ; AAFD 00                       .
        brk                                     ; AAFE 00                       .
        brk                                     ; AAFF 00                       .
        tsx                                     ; AB00 BA                       .
        txs                                     ; AB01 9A                       .
        ror     a                               ; AB02 6A                       j
        .byte   $1B                             ; AB03 1B                       .
        .byte   $1B                             ; AB04 1B                       .
        .byte   $9B                             ; AB05 9B                       .
        jmp     (LB82B)                         ; AB06 6C 2B B8                 l+.

; ----------------------------------------------------------------------------
        .byte   $5C                             ; AB09 5C                       \
        sei                                     ; AB0A 78                       x
        iny                                     ; AB0B C8                       .
        .byte   $5C                             ; AB0C 5C                       \
        .byte   $2B                             ; AB0D 2B                       +
        .byte   $3B                             ; AB0E 3B                       ;
        .byte   $6B                             ; AB0F 6B                       k
        pha                                     ; AB10 48                       H
        bcs     LAB5E                           ; AB11 B0 4B                    .K
        rol     a                               ; AB13 2A                       *
        rol     a                               ; AB14 2A                       *
        cpy     #$31                            ; AB15 C0 31                    .1
LAB17:  cli                                     ; AB17 58                       X
        .byte   $7B                             ; AB18 7B                       {
        and     ($BC),y                         ; AB19 31 BC                    1.
        .byte   $5A                             ; AB1B 5A                       Z
        lsr     a                               ; AB1C 4A                       J
        ldy     $D82A                           ; AB1D AC 2A D8                 .*.
        ldy     $3A2A,x                         ; AB20 BC 2A 3A                 .*:
        rol     a                               ; AB23 2A                       *
LAB24:  .byte   $9B                             ; AB24 9B                       .
        brk                                     ; AB25 00                       .
        sta     (L0021,x)                       ; AB26 81 21                    .!
        and     ($90),y                         ; AB28 31 90                    1.
        tya                                     ; AB2A 98                       .
        brk                                     ; AB2B 00                       .
        rti                                     ; AB2C 40                       @

; ----------------------------------------------------------------------------
        .byte   $80                             ; AB2D 80                       .
        brk                                     ; AB2E 00                       .
        brk                                     ; AB2F 00                       .
        bcc     LAB92                           ; AB30 90 60                    .`
        .byte   $80                             ; AB32 80                       .
        tay                                     ; AB33 A8                       .
        bcc     LAB76                           ; AB34 90 40                    .@
        bvs     LAAE8                           ; AB36 70 B0                    p.
        bvc     LABAA                           ; AB38 50 70                    Pp
        ldy     #$50                            ; AB3A A0 50                    .P
        bvs     LAACE                           ; AB3C 70 90                    p.
        bmi     LABA0                           ; AB3E 30 60                    0`
        rti                                     ; AB40 40                       @

; ----------------------------------------------------------------------------
        .byte   $80                             ; AB41 80                       .
        cli                                     ; AB42 58                       X
        tay                                     ; AB43 A8                       .
        jsr     L6040                           ; AB44 20 40 60                  @`
        jsr     L8040                           ; AB47 20 40 80                  @.
        iny                                     ; AB4A C8                       .
        clc                                     ; AB4B 18                       .
        cli                                     ; AB4C 58                       X
        iny                                     ; AB4D C8                       .
        bcc     LAAE8                           ; AB4E 90 98                    ..
        tay                                     ; AB50 A8                       .
        clv                                     ; AB51 B8                       .
        ror     a                               ; AB52 6A                       j
        .byte   $7A                             ; AB53 7A                       z
        bmi     LAAF0                           ; AB54 30 9A                    0.
        lsr     a                               ; AB56 4A                       J
        jsr     L5A8A                           ; AB57 20 8A 5A                  .Z
        txs                                     ; AB5A 9A                       .
        brk                                     ; AB5B 00                       .
        .byte   $FF                             ; AB5C FF                       .
        brk                                     ; AB5D 00                       .
LAB5E:  brk                                     ; AB5E 00                       .
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
        .byte   $02                             ; AB72 02                       .
        brk                                     ; AB73 00                       .
        brk                                     ; AB74 00                       .
        brk                                     ; AB75 00                       .
LAB76:  brk                                     ; AB76 00                       .
        brk                                     ; AB77 00                       .
        brk                                     ; AB78 00                       .
        brk                                     ; AB79 00                       .
        brk                                     ; AB7A 00                       .
        brk                                     ; AB7B 00                       .
        brk                                     ; AB7C 00                       .
        brk                                     ; AB7D 00                       .
        .byte   $02                             ; AB7E 02                       .
        brk                                     ; AB7F 00                       .
        and     ($31),y                         ; AB80 31 31                    11
        and     ($34),y                         ; AB82 31 34                    14
        .byte   $34                             ; AB84 34                       4
        .byte   $34                             ; AB85 34                       4
        and     ($34),y                         ; AB86 31 34                    14
        .byte   $32                             ; AB88 32                       2
        and     ($32),y                         ; AB89 31 32                    12
        txa                                     ; AB8B 8A                       .
        and     ($34),y                         ; AB8C 31 34                    14
        .byte   $34                             ; AB8E 34                       4
        .byte   $34                             ; AB8F 34                       4
        .byte   $34                             ; AB90 34                       4
        .byte   $35                             ; AB91 35                       5
LAB92:  .byte   $34                             ; AB92 34                       4
        .byte   $34                             ; AB93 34                       4
        .byte   $34                             ; AB94 34                       4
        and     $1C,x                           ; AB95 35 1C                    5.
        sty     $31                             ; AB97 84 31                    .1
        .byte   $1C                             ; AB99 1C                       .
        ora     $34                             ; AB9A 05 34                    .4
        .byte   $34                             ; AB9C 34                       4
        ora     $34                             ; AB9D 05 34                    .4
        .byte   $84                             ; AB9F 84                       .
LABA0:  ora     $34                             ; ABA0 05 34                    .4
        .byte   $34                             ; ABA2 34                       4
        .byte   $34                             ; ABA3 34                       4
        and     ($EF),y                         ; ABA4 31 EF                    1.
        .byte   $1C                             ; ABA6 1C                       .
        .byte   $1C                             ; ABA7 1C                       .
        .byte   $1C                             ; ABA8 1C                       .
        .byte   $35                             ; ABA9 35                       5
LABAA:  .byte   $82                             ; ABAA 82                       .
        dec     $61                             ; ABAB C6 61                    .a
        adc     ($D6,x)                         ; ABAD 61 D6                    a.
        .byte   $C7                             ; ABAF C7                       .
        .byte   $14                             ; ABB0 14                       .
        adc     ($61,x)                         ; ABB1 61 61                    aa
        and     ($14,x)                         ; ABB3 21 14                    !.
        adc     ($61,x)                         ; ABB5 61 61                    aa
        .byte   $14                             ; ABB7 14                       .
        adc     ($61,x)                         ; ABB8 61 61                    aa
        .byte   $14                             ; ABBA 14                       .
        adc     ($61,x)                         ; ABBB 61 61                    aa
        .byte   $14                             ; ABBD 14                       .
        adc     ($61,x)                         ; ABBE 61 61                    aa
        adc     ($14,x)                         ; ABC0 61 14                    a.
        .byte   $83                             ; ABC2 83                       .
        and     ($61,x)                         ; ABC3 21 61                    !a
        adc     ($61,x)                         ; ABC5 61 61                    aa
        adc     ($61,x)                         ; ABC7 61 61                    aa
        adc     (L0020,x)                       ; ABC9 61 20                    a 
        sta     ($22,x)                         ; ABCB 81 22                    ."
        .byte   $22                             ; ABCD 22                       "
        rol     $80                             ; ABCE 26 80                    &.
        stx     $84                             ; ABD0 86 84                    ..
        and     ($61),y                         ; ABD2 31 61                    1a
        adc     ($31,x)                         ; ABD4 61 31                    a1
        and     ($61),y                         ; ABD6 31 61                    1a
        adc     ($61,x)                         ; ABD8 61 61                    aa
        and     ($62),y                         ; ABDA 31 62                    1b
        .byte   $FF                             ; ABDC FF                       .
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
        .byte   $04                             ; ABE7 04                       .
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
        bpl     LABFB                           ; ABF9 10 00                    ..
LABFB:  brk                                     ; ABFB 00                       .
        brk                                     ; ABFC 00                       .
        brk                                     ; ABFD 00                       .
        brk                                     ; ABFE 00                       .
        brk                                     ; ABFF 00                       .
        brk                                     ; AC00 00                       .
        brk                                     ; AC01 00                       .
        .byte   $02                             ; AC02 02                       .
        .byte   $03                             ; AC03 03                       .
        ora     $08                             ; AC04 05 08                    ..
        .byte   $0B                             ; AC06 0B                       .
        .byte   $0C                             ; AC07 0C                       .
        .byte   $0F                             ; AC08 0F                       .
        ora     ($14),y                         ; AC09 11 14                    ..
        asl     $1A,x                           ; AC0B 16 1A                    ..
        ora     $2522,x                         ; AC0D 1D 22 25                 ."%
        plp                                     ; AC10 28                       (
        .byte   $2B                             ; AC11 2B                       +
        bit     $3A34                           ; AC12 2C 34 3A                 ,4:
        rol     $4342,x                         ; AC15 3E 42 43                 >BC
        .byte   $47                             ; AC18 47                       G
        .byte   $4B                             ; AC19 4B                       K
        .byte   $4F                             ; AC1A 4F                       O
        bvc     LAC6F                           ; AC1B 50 52                    PR
        .byte   $52                             ; AC1D 52                       R
        eor     $59,x                           ; AC1E 55 59                    UY
        .byte   $5B                             ; AC20 5B                       [
        .byte   $5B                             ; AC21 5B                       [
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
        brk                                     ; AC47 00                       .
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
        php                                     ; AC60 08                       .
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
LAC6F:  brk                                     ; AC6F 00                       .
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
        rti                                     ; ACAA 40                       @

; ----------------------------------------------------------------------------
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
        brk                                     ; ACEA 00                       .
        brk                                     ; ACEB 00                       .
        brk                                     ; ACEC 00                       .
        brk                                     ; ACED 00                       .
        brk                                     ; ACEE 00                       .
        brk                                     ; ACEF 00                       .
        brk                                     ; ACF0 00                       .
        brk                                     ; ACF1 00                       .
        rti                                     ; ACF2 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; ACF3 00                       .
        brk                                     ; ACF4 00                       .
        brk                                     ; ACF5 00                       .
        brk                                     ; ACF6 00                       .
        brk                                     ; ACF7 00                       .
        brk                                     ; ACF8 00                       .
        brk                                     ; ACF9 00                       .
        rti                                     ; ACFA 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; ACFB 00                       .
        brk                                     ; ACFC 00                       .
        brk                                     ; ACFD 00                       .
        brk                                     ; ACFE 00                       .
        brk                                     ; ACFF 00                       .
        brk                                     ; AD00 00                       .
        bpl     LAD07                           ; AD01 10 04                    ..
        asl     $2E                             ; AD03 06 2E                    ..
        .byte   $3C                             ; AD05 3C                       <
        .byte   $2E                             ; AD06 2E                       .
LAD07:  inc     $010E                           ; AD07 EE 0E 01                 ...
        bit     $26                             ; AD0A 24 26                    $&
        .byte   $8F                             ; AD0C 8F                       .
        .byte   $8F                             ; AD0D 8F                       .
        .byte   $8F                             ; AD0E 8F                       .
        dec     $4240                           ; AD0F CE 40 42                 .@B
        cpy     $40CE                           ; AD12 CC CE 40                 ..@
        .byte   $42                             ; AD15 42                       B
        cpy     $448F                           ; AD16 CC 8F 44                 ..D
        lsr     $EC                             ; AD19 46 EC                    F.
        inc     $6664                           ; AD1B EE 64 66                 .df
        plp                                     ; AD1E 28                       (
        rol     a                               ; AD1F 2A                       *
        brk                                     ; AD20 00                       .
        eor     $C700                           ; AD21 4D 00 C7                 M..
        pla                                     ; AD24 68                       h
        asl     $E5E3                           ; AD25 0E E3 E5                 ...
        brk                                     ; AD28 00                       .
        jmp     LE700                           ; AD29 4C 00 E7                 L..

; ----------------------------------------------------------------------------
        ora     (L0000,x)                       ; AD2C 01 00                    ..
        cpy     $C6                             ; AD2E C4 C6                    ..
        .byte   $80                             ; AD30 80                       .
        .byte   $82                             ; AD31 82                       .
        ror     a                               ; AD32 6A                       j
        jmp     (L0000)                         ; AD33 6C 00 00                 l..

; ----------------------------------------------------------------------------
        brk                                     ; AD36 00                       .
        dec     $2A0C                           ; AD37 CE 0C 2A                 ..*
        lsr     $026E                           ; AD3A 4E 6E 02                 Nn.
        ora     ($2E,x)                         ; AD3D 01 2E                    ..
        .byte   $CF                             ; AD3F CF                       .
        .byte   $44                             ; AD40 44                       D
        lsr     L0000                           ; AD41 46 00                    F.
        brk                                     ; AD43 00                       .
        brk                                     ; AD44 00                       .
        brk                                     ; AD45 00                       .
        .byte   $04                             ; AD46 04                       .
        asl     L0000                           ; AD47 06 00                    ..
        brk                                     ; AD49 00                       .
        brk                                     ; AD4A 00                       .
        brk                                     ; AD4B 00                       .
        brk                                     ; AD4C 00                       .
        brk                                     ; AD4D 00                       .
        bit     $26                             ; AD4E 24 26                    $&
        dey                                     ; AD50 88                       .
        .byte   $C2                             ; AD51 C2                       .
        brk                                     ; AD52 00                       .
        brk                                     ; AD53 00                       .
        brk                                     ; AD54 00                       .
        brk                                     ; AD55 00                       .
        brk                                     ; AD56 00                       .
        brk                                     ; AD57 00                       .
        txa                                     ; AD58 8A                       .
        tay                                     ; AD59 A8                       .
        tax                                     ; AD5A AA                       .
        sty     $DA10                           ; AD5B 8C 10 DA                 ...
        ldx     $CA3E                           ; AD5E AE 3E CA                 .>.
        iny                                     ; AD61 C8                       .
        dex                                     ; AD62 CA                       .
        cld                                     ; AD63 D8                       .
        bpl     LAD67                           ; AD64 10 01                    ..
        .byte   $01                             ; AD66 01                       .
LAD67:  brk                                     ; AD67 00                       .
        sta     $0202,y                         ; AD68 99 02 02                 ...
        .byte   $02                             ; AD6B 02                       .
        ora     ($92,x)                         ; AD6C 01 92                    ..
        cpx     #$E2                            ; AD6E E0 E2                    ..
        brk                                     ; AD70 00                       .
        .byte   $02                             ; AD71 02                       .
        stx     $0100                           ; AD72 8E 00 01                 ...
        .byte   $B2                             ; AD75 B2                       .
        brk                                     ; AD76 00                       .
        brk                                     ; AD77 00                       .
        brk                                     ; AD78 00                       .
        brk                                     ; AD79 00                       .
        ora     ($01,x)                         ; AD7A 01 01                    ..
        ldy     $A6                             ; AD7C A4 A6                    ..
        brk                                     ; AD7E 00                       .
        brk                                     ; AD7F 00                       .
        sty     $86                             ; AD80 84 86                    ..
        sty     L0000,x                         ; AD82 94 00                    ..
        brk                                     ; AD84 00                       .
        brk                                     ; AD85 00                       .
        rts                                     ; AD86 60                       `

; ----------------------------------------------------------------------------
        .byte   $62                             ; AD87 62                       b
        ldy     #$A2                            ; AD88 A0 A2                    ..
        inx                                     ; AD8A E8                       .
        nop                                     ; AD8B EA                       .
        .byte   $EB                             ; AD8C EB                       .
        ldx     #$64                            ; AD8D A2 64                    .d
        ror     $C0                             ; AD8F 66 C0                    f.
        .byte   $C2                             ; AD91 C2                       .
        lsr     $804E                           ; AD92 4E 4E 80                 NN.
        .byte   $82                             ; AD95 82                       .
        cpy     $F4                             ; AD96 C4 F4                    ..
        cpx     #$E2                            ; AD98 E0 E2                    ..
        brk                                     ; AD9A 00                       .
        brk                                     ; AD9B 00                       .
        cpy     $E4                             ; AD9C C4 E4                    ..
        .byte   $D4                             ; AD9E D4                       .
        ora     ($4E,x)                         ; AD9F 01 4E                    .N
LADA1:  lsr     a:$4E                           ; ADA1 4E 4E 00                 NN.
        brk                                     ; ADA4 00                       .
        brk                                     ; ADA5 00                       .
        brk                                     ; ADA6 00                       .
        brk                                     ; ADA7 00                       .
        lsr     $4E00                           ; ADA8 4E 00 4E                 N.N
        brk                                     ; ADAB 00                       .
        brk                                     ; ADAC 00                       .
        .byte   $CF                             ; ADAD CF                       .
        .byte   $CF                             ; ADAE CF                       .
        brk                                     ; ADAF 00                       .
        brk                                     ; ADB0 00                       .
        brk                                     ; ADB1 00                       .
        ldy     $CFAE                           ; ADB2 AC AE CF                 ...
        .byte   $CF                             ; ADB5 CF                       .
        rti                                     ; ADB6 40                       @

; ----------------------------------------------------------------------------
        .byte   $42                             ; ADB7 42                       B
        tax                                     ; ADB8 AA                       .
        cpy     a:L0000                         ; ADB9 CC 00 00                 ...
        .byte   $CF                             ; ADBC CF                       .
        .byte   $CF                             ; ADBD CF                       .
        .byte   $44                             ; ADBE 44                       D
        lsr     $80                             ; ADBF 46 80                    F.
        .byte   $82                             ; ADC1 82                       .
        .byte   $4F                             ; ADC2 4F                       O
        lsr     a:L0000                         ; ADC3 4E 00 00                 N..
        dey                                     ; ADC6 88                       .
        brk                                     ; ADC7 00                       .
        asl     $8584,x                         ; ADC8 1E 84 85                 ...
        sta     $A5                             ; ADCB 85 A5                    ..
        ror     $0184                           ; ADCD 6E 84 01                 n..
        pha                                     ; ADD0 48                       H
        ldy     $A5                             ; ADD1 A4 A5                    ..
        ora     ($D6,x)                         ; ADD3 01 D6                    ..
        ora     ($01,x)                         ; ADD5 01 01                    ..
        ora     ($94,x)                         ; ADD7 01 94                    ..
        stx     $87                             ; ADD9 86 87                    ..
        .byte   $D7                             ; ADDB D7                       .
        ora     ($85,x)                         ; ADDC 01 85                    ..
        stx     $87                             ; ADDE 86 87                    ..
        php                                     ; ADE0 08                       .
        asl     a                               ; ADE1 0A                       .
        brk                                     ; ADE2 00                       .
        cpx     #$E2                            ; ADE3 E0 E2                    ..
        ora     ($87,x)                         ; ADE5 01 87                    ..
        .byte   $97                             ; ADE7 97                       .
        jsr     LB022                           ; ADE8 20 22 B0                  ".
        tax                                     ; ADEB AA                       .
        .byte   $B2                             ; ADEC B2                       .
        .byte   $D2                             ; ADED D2                       .
        .byte   $E2                             ; ADEE E2                       .
        .byte   $87                             ; ADEF 87                       .
        ldy     $80AE                           ; ADF0 AC AE 80                 ...
        sta     ($D2,x)                         ; ADF3 81 D2                    ..
        bcs     LADA1                           ; ADF5 B0 AA                    ..
        .byte   $B2                             ; ADF7 B2                       .
        tay                                     ; ADF8 A8                       .
        dey                                     ; ADF9 88                       .
        ldy     #$C0                            ; ADFA A0 C0                    ..
        ldx     #$88                            ; ADFC A2 88                    ..
        cpy     a:$CE                           ; ADFE CC CE 00                 ...
        bpl     LAE08                           ; AE01 10 05                    ..
        .byte   $07                             ; AE03 07                       .
        .byte   $2F                             ; AE04 2F                       /
        and     $EE2F,x                         ; AE05 3D 2F EE                 =/.
LAE08:  .byte   $0F                             ; AE08 0F                       .
        ora     ($25,x)                         ; AE09 01 25                    .%
        .byte   $27                             ; AE0B 27                       '
        .byte   $8F                             ; AE0C 8F                       .
        .byte   $8F                             ; AE0D 8F                       .
        .byte   $8F                             ; AE0E 8F                       .
        .byte   $CF                             ; AE0F CF                       .
        eor     ($43,x)                         ; AE10 41 43                    AC
        cmp     $41CF                           ; AE12 CD CF 41                 ..A
        .byte   $43                             ; AE15 43                       C
        cmp     $459F                           ; AE16 CD 9F 45                 ..E
        .byte   $47                             ; AE19 47                       G
        sbc     $65EF                           ; AE1A ED EF 65                 ..e
        .byte   $67                             ; AE1D 67                       g
        and     #$2B                            ; AE1E 29 2B                    )+
        lsr     a                               ; AE20 4A                       J
        brk                                     ; AE21 00                       .
        dec     L0000                           ; AE22 C6 00                    ..
        adc     #$0F                            ; AE24 69 0F                    i.
        cpx     $E6                             ; AE26 E4 E6                    ..
        .byte   $4B                             ; AE28 4B                       K
        brk                                     ; AE29 00                       .
        inc     L0000                           ; AE2A E6 00                    ..
        ora     (L0000,x)                       ; AE2C 01 00                    ..
        cmp     $C7                             ; AE2E C5 C7                    ..
        sta     ($83,x)                         ; AE30 81 83                    ..
        .byte   $6B                             ; AE32 6B                       k
        adc     a:L0000                         ; AE33 6D 00 00                 m..
        brk                                     ; AE36 00                       .
        dec     $0D29                           ; AE37 CE 29 0D                 .).
        .byte   $4F                             ; AE3A 4F                       O
        .byte   $6F                             ; AE3B 6F                       o
        .byte   $02                             ; AE3C 02                       .
        ora     ($2F,x)                         ; AE3D 01 2F                    ./
        .byte   $CF                             ; AE3F CF                       .
        eor     $47                             ; AE40 45 47                    EG
        brk                                     ; AE42 00                       .
        brk                                     ; AE43 00                       .
        brk                                     ; AE44 00                       .
        brk                                     ; AE45 00                       .
        ora     $07                             ; AE46 05 07                    ..
        brk                                     ; AE48 00                       .
        brk                                     ; AE49 00                       .
        brk                                     ; AE4A 00                       .
        brk                                     ; AE4B 00                       .
        brk                                     ; AE4C 00                       .
        brk                                     ; AE4D 00                       .
        and     $27                             ; AE4E 25 27                    %'
        .byte   $89                             ; AE50 89                       .
        .byte   $C3                             ; AE51 C3                       .
        brk                                     ; AE52 00                       .
        brk                                     ; AE53 00                       .
        brk                                     ; AE54 00                       .
        brk                                     ; AE55 00                       .
        brk                                     ; AE56 00                       .
        brk                                     ; AE57 00                       .
        .byte   $8B                             ; AE58 8B                       .
        lda     #$AB                            ; AE59 A9 AB                    ..
        lda     $DB98                           ; AE5B AD 98 DB                 ...
        .byte   $AF                             ; AE5E AF                       .
        .byte   $3F                             ; AE5F 3F                       ?
        tya                                     ; AE60 98                       .
        cmp     #$10                            ; AE61 C9 10                    ..
        cmp     $01BC,y                         ; AE63 D9 BC 01                 ...
        ora     (L0000,x)                       ; AE66 01 00                    ..
        sta     $9D02,y                         ; AE68 99 02 9D                 ...
        sta     $9391,x                         ; AE6B 9D 91 93                 ...
        sbc     ($E3,x)                         ; AE6E E1 E3                    ..
        brk                                     ; AE70 00                       .
        .byte   $02                             ; AE71 02                       .
        bpl     LAE74                           ; AE72 10 00                    ..
LAE74:  lda     ($B3),y                         ; AE74 B1 B3                    ..
        brk                                     ; AE76 00                       .
        brk                                     ; AE77 00                       .
        brk                                     ; AE78 00                       .
        brk                                     ; AE79 00                       .
        ora     ($01,x)                         ; AE7A 01 01                    ..
        lda     $01                             ; AE7C A5 01                    ..
        brk                                     ; AE7E 00                       .
        brk                                     ; AE7F 00                       .
        sta     $87                             ; AE80 85 87                    ..
        .byte   $02                             ; AE82 02                       .
        brk                                     ; AE83 00                       .
        brk                                     ; AE84 00                       .
        brk                                     ; AE85 00                       .
        adc     ($63,x)                         ; AE86 61 63                    ac
        lda     ($A3,x)                         ; AE88 A1 A3                    ..
        sbc     #$EA                            ; AE8A E9 EA                    ..
        cpx     $65EF                           ; AE8C EC EF 65                 ..e
        .byte   $67                             ; AE8F 67                       g
        cmp     ($C3,x)                         ; AE90 C1 C3                    ..
        lsr     $814E                           ; AE92 4E 4E 81                 NN.
        .byte   $83                             ; AE95 83                       .
        .byte   $F4                             ; AE96 F4                       .
        cmp     $E1                             ; AE97 C5 E1                    ..
        .byte   $E3                             ; AE99 E3                       .
        brk                                     ; AE9A 00                       .
        brk                                     ; AE9B 00                       .
        cmp     $E5                             ; AE9C C5 E5                    ..
        ora     ($D5,x)                         ; AE9E 01 D5                    ..
        lsr     $4E4E                           ; AEA0 4E 4E 4E                 NNN
        brk                                     ; AEA3 00                       .
        brk                                     ; AEA4 00                       .
        brk                                     ; AEA5 00                       .
        brk                                     ; AEA6 00                       .
        brk                                     ; AEA7 00                       .
        lsr     $4E00                           ; AEA8 4E 00 4E                 N.N
        brk                                     ; AEAB 00                       .
        brk                                     ; AEAC 00                       .
LAEAD:  .byte   $CF                             ; AEAD CF                       .
        .byte   $CF                             ; AEAE CF                       .
        brk                                     ; AEAF 00                       .
        brk                                     ; AEB0 00                       .
        brk                                     ; AEB1 00                       .
        lda     $CF01                           ; AEB2 AD 01 CF                 ...
        .byte   $CF                             ; AEB5 CF                       .
        eor     ($43,x)                         ; AEB6 41 43                    AC
        ora     ($CD,x)                         ; AEB8 01 CD                    ..
        brk                                     ; AEBA 00                       .
        brk                                     ; AEBB 00                       .
        .byte   $CF                             ; AEBC CF                       .
        .byte   $CF                             ; AEBD CF                       .
        eor     $47                             ; AEBE 45 47                    EG
        sta     ($83,x)                         ; AEC0 81 83                    ..
        .byte   $4F                             ; AEC2 4F                       O
        .byte   $4E                             ; AEC3 4E                       N
LAEC4:  brk                                     ; AEC4 00                       .
        brk                                     ; AEC5 00                       .
        .byte   $89                             ; AEC6 89                       .
        brk                                     ; AEC7 00                       .
        brk                                     ; AEC8 00                       .
        sta     $86                             ; AEC9 85 86                    ..
        sta     $94                             ; AECB 85 94                    ..
        .byte   $6F                             ; AECD 6F                       o
        sta     $01                             ; AECE 85 01                    ..
        brk                                     ; AED0 00                       .
        lda     $B6                             ; AED1 A5 B6                    ..
        ora     ($D7,x)                         ; AED3 01 D7                    ..
        ora     ($01,x)                         ; AED5 01 01                    ..
        dec     $A5,x                           ; AED7 D6 A5                    ..
        stx     $85,y                           ; AED9 96 85                    ..
        ora     ($01,x)                         ; AEDB 01 01                    ..
        .byte   $87                             ; AEDD 87                       .
        brk                                     ; AEDE 00                       .
        .byte   $87                             ; AEDF 87                       .
        ora     #$0B                            ; AEE0 09 0B                    ..
        brk                                     ; AEE2 00                       .
        sbc     ($E3,x)                         ; AEE3 E1 E3                    ..
        ora     ($E2,x)                         ; AEE5 01 E2                    ..
        .byte   $97                             ; AEE7 97                       .
        and     ($23,x)                         ; AEE8 21 23                    !#
        lda     ($AB),y                         ; AEEA B1 AB                    ..
        .byte   $B3                             ; AEEC B3                       .
        .byte   $D3                             ; AEED D3                       .
        .byte   $87                             ; AEEE 87                       .
        .byte   $97                             ; AEEF 97                       .
        lda     $D2AF                           ; AEF0 AD AF D2                 ...
        .byte   $82                             ; AEF3 82                       .
        .byte   $83                             ; AEF4 83                       .
        lda     ($AB),y                         ; AEF5 B1 AB                    ..
        .byte   $B3                             ; AEF7 B3                       .
        lda     #$89                            ; AEF8 A9 89                    ..
        lda     ($C1,x)                         ; AEFA A1 C1                    ..
        .byte   $A3                             ; AEFC A3                       .
        .byte   $89                             ; AEFD 89                       .
        cmp     a:$CF                           ; AEFE CD CF 00                 ...
        bpl     LAF17                           ; AF01 10 14                    ..
        asl     $2C,x                           ; AF03 16 2C                    .,
        rol     $FE2E                           ; AF05 2E 2E FE                 ...
        asl     $3401                           ; AF08 0E 01 34                 ..4
        rol     $8F,x                           ; AF0B 36 8F                    6.
        .byte   $8F                             ; AF0D 8F                       .
        .byte   $8F                             ; AF0E 8F                       .
        dec     $5250,x                         ; AF0F DE 50 52                 .PR
        .byte   $DC                             ; AF12 DC                       .
        dec     $8C8A,x                         ; AF13 DE 8A 8C                 ...
        .byte   $DC                             ; AF16 DC                       .
LAF17:  .byte   $8F                             ; AF17 8F                       .
        .byte   $54                             ; AF18 54                       T
        lsr     $FC,x                           ; AF19 56 FC                    V.
        inc     $7674,x                         ; AF1B FE 74 76                 .tv
        sec                                     ; AF1E 38                       8
        .byte   $3A                             ; AF1F 3A                       :
        brk                                     ; AF20 00                       .
        eor     $D700,x                         ; AF21 5D 00 D7                 ]..
        sei                                     ; AF24 78                       x
        asl     $F5F3                           ; AF25 0E F3 F5                 ...
        brk                                     ; AF28 00                       .
        .byte   $5C                             ; AF29 5C                       \
        brk                                     ; AF2A 00                       .
        .byte   $F7                             ; AF2B F7                       .
        ora     (L0000,x)                       ; AF2C 01 00                    ..
        iny                                     ; AF2E C8                       .
        dex                                     ; AF2F CA                       .
        bcc     LAEC4                           ; AF30 90 92                    ..
        .byte   $7A                             ; AF32 7A                       z
        .byte   $7C                             ; AF33 7C                       |
        brk                                     ; AF34 00                       .
        brk                                     ; AF35 00                       .
        brk                                     ; AF36 00                       .
        dec     $3A1C,x                         ; AF37 DE 1C 3A                 ..:
        .byte   $5E                             ; AF3A 5E                       ^
        .byte   $7E                             ; AF3B 7E                       ~
LAF3C:  .byte   $02                             ; AF3C 02                       .
        ora     ($3E,x)                         ; AF3D 01 3E                    .>
        .byte   $DF                             ; AF3F DF                       .
        sbc     a:$FD                           ; AF40 ED FD 00                 ...
        brk                                     ; AF43 00                       .
        brk                                     ; AF44 00                       .
        brk                                     ; AF45 00                       .
        .byte   $14                             ; AF46 14                       .
        asl     L0000,x                         ; AF47 16 00                    ..
        brk                                     ; AF49 00                       .
        brk                                     ; AF4A 00                       .
        brk                                     ; AF4B 00                       .
        brk                                     ; AF4C 00                       .
        brk                                     ; AF4D 00                       .
        .byte   $34                             ; AF4E 34                       4
        rol     $01,x                           ; AF4F 36 01                    6.
        ora     (L0000,x)                       ; AF51 01 00                    ..
        brk                                     ; AF53 00                       .
        brk                                     ; AF54 00                       .
        brk                                     ; AF55 00                       .
        brk                                     ; AF56 00                       .
        brk                                     ; AF57 00                       .
        txs                                     ; AF58 9A                       .
        clv                                     ; AF59 B8                       .
        tsx                                     ; AF5A BA                       .
        ldy     $9598,x                         ; AF5B BC 98 95                 ...
        bpl     LAFA9                           ; AF5E 10 49                    .I
        .byte   $02                             ; AF60 02                       .
        .byte   $02                             ; AF61 02                       .
        .byte   $02                             ; AF62 02                       .
        bpl     LAF75                           ; AF63 10 10                    ..
        .byte   $82                             ; AF65 82                       .
        bne     LAF68                           ; AF66 D0 00                    ..
LAF68:  ora     ($02,x)                         ; AF68 01 02                    ..
        .byte   $CB                             ; AF6A CB                       .
        .byte   $02                             ; AF6B 02                       .
        ldy     #$02                            ; AF6C A0 02                    ..
        .byte   $C2                             ; AF6E C2                       .
        .byte   $C2                             ; AF6F C2                       .
        brk                                     ; AF70 00                       .
        sta     $9E,y                           ; AF71 99 9E 00                 ...
        .byte   $C0                             ; AF74 C0                       .
LAF75:  .byte   $C2                             ; AF75 C2                       .
        brk                                     ; AF76 00                       .
        brk                                     ; AF77 00                       .
        brk                                     ; AF78 00                       .
        brk                                     ; AF79 00                       .
        sty     $86                             ; AF7A 84 86                    ..
        .byte   $A7                             ; AF7C A7                       .
        .byte   $02                             ; AF7D 02                       .
        brk                                     ; AF7E 00                       .
        brk                                     ; AF7F 00                       .
        sty     $02,x                           ; AF80 94 02                    ..
        .byte   $02                             ; AF82 02                       .
        brk                                     ; AF83 00                       .
        brk                                     ; AF84 00                       .
        brk                                     ; AF85 00                       .
        bvs     LAFFA                           ; AF86 70 72                    pr
        bcs     LAF3C                           ; AF88 B0 B2                    ..
        sed                                     ; AF8A F8                       .
        .byte   $FA                             ; AF8B FA                       .
        .byte   $FB                             ; AF8C FB                       .
        .byte   $B2                             ; AF8D B2                       .
        .byte   $74                             ; AF8E 74                       t
        ror     $D0,x                           ; AF8F 76 D0                    v.
        .byte   $D2                             ; AF91 D2                       .
        lsr     $904E                           ; AF92 4E 4E 90                 NN.
        .byte   $92                             ; AF95 92                       .
        .byte   $D4                             ; AF96 D4                       .
        ora     ($F0,x)                         ; AF97 01 F0                    ..
        .byte   $F2                             ; AF99 F2                       .
        brk                                     ; AF9A 00                       .
        brk                                     ; AF9B 00                       .
        .byte   $D4                             ; AF9C D4                       .
        .byte   $F4                             ; AF9D F4                       .
        cpx     $01                             ; AF9E E4 01                    ..
        lsr     $4E4E                           ; AFA0 4E 4E 4E                 NNN
        brk                                     ; AFA3 00                       .
        brk                                     ; AFA4 00                       .
        brk                                     ; AFA5 00                       .
        brk                                     ; AFA6 00                       .
        brk                                     ; AFA7 00                       .
        .byte   $4E                             ; AFA8 4E                       N
LAFA9:  brk                                     ; AFA9 00                       .
        lsr     a:L0000                         ; AFAA 4E 00 00                 N..
        .byte   $CF                             ; AFAD CF                       .
LAFAE:  brk                                     ; AFAE 00                       .
        brk                                     ; AFAF 00                       .
        brk                                     ; AFB0 00                       .
LAFB1:  brk                                     ; AFB1 00                       .
        ldy     $CFBE,x                         ; AFB2 BC BE CF                 ...
        .byte   $CF                             ; AFB5 CF                       .
LAFB6:  bvc     LB00A                           ; AFB6 50 52                    PR
        tsx                                     ; AFB8 BA                       .
        .byte   $DC                             ; AFB9 DC                       .
        brk                                     ; AFBA 00                       .
        brk                                     ; AFBB 00                       .
        .byte   $CF                             ; AFBC CF                       .
        .byte   $CF                             ; AFBD CF                       .
        .byte   $54                             ; AFBE 54                       T
        lsr     $90,x                           ; AFBF 56 90                    V.
        .byte   $92                             ; AFC1 92                       .
        lsr     a:$4F                           ; AFC2 4E 4F 00                 NO.
        brk                                     ; AFC5 00                       .
        tya                                     ; AFC6 98                       .
        brk                                     ; AFC7 00                       .
        .byte   $1F                             ; AFC8 1F                       .
        sty     $96,x                           ; AFC9 94 96                    ..
        ldy     $A5,x                           ; AFCB B4 A5                    ..
        ror     $D494,x                         ; AFCD 7E 94 D4                 ~..
        cli                                     ; AFD0 58                       X
        ldy     $A6,x                           ; AFD1 B4 A6                    ..
        .byte   $D4                             ; AFD3 D4                       .
        bpl     LAFAE                           ; AFD4 10 D8                    ..
        .byte   $D3                             ; AFD6 D3                       .
LAFD7:  cmp     $94,x                           ; AFD7 D5 94                    ..
        sty     $97,x                           ; AFD9 94 97                    ..
        bpl     LAFB6                           ; AFDB 10 D9                    ..
        ldy     $94,x                           ; AFDD B4 94                    ..
        .byte   $97                             ; AFDF 97                       .
        clc                                     ; AFE0 18                       .
        .byte   $1A                             ; AFE1 1A                       .
        brk                                     ; AFE2 00                       .
        beq     LAFD7                           ; AFE3 F0 F2                    ..
        .byte   $D3                             ; AFE5 D3                       .
        .byte   $97                             ; AFE6 97                       .
        .byte   $87                             ; AFE7 87                       .
        bmi     LB01C                           ; AFE8 30 32                    02
        txs                                     ; AFEA 9A                       .
        .byte   $9C                             ; AFEB 9C                       .
        .byte   $9B                             ; AFEC 9B                       .
        ldx     $F2,y                           ; AFED B6 F2                    ..
        .byte   $97                             ; AFEF 97                       .
        ldy     $90BE,x                         ; AFF0 BC BE 90                 ...
        tsx                                     ; AFF3 BA                       .
        .byte   $92                             ; AFF4 92                       .
        bcc     LAFB1                           ; AFF5 90 BA                    ..
        .byte   $92                             ; AFF7 92                       .
        clv                                     ; AFF8 B8                       .
        tya                                     ; AFF9 98                       .
LAFFA:  ldy     #$D0                            ; AFFA A0 D0                    ..
        .byte   $C3                             ; AFFC C3                       .
        tya                                     ; AFFD 98                       .
        .byte   $DC                             ; AFFE DC                       .
        dec     $1000,x                         ; AFFF DE 00 10                 ...
        ora     $17,x                           ; B002 15 17                    ..
        and     $2F2F                           ; B004 2D 2F 2F                 -//
        inc     $010F,x                         ; B007 FE 0F 01                 ...
LB00A:  and     $37,x                           ; B00A 35 37                    57
        .byte   $8F                             ; B00C 8F                       .
        .byte   $8F                             ; B00D 8F                       .
        .byte   $8F                             ; B00E 8F                       .
        .byte   $DF                             ; B00F DF                       .
        eor     ($53),y                         ; B010 51 53                    QS
        cmp     $8BDF,x                         ; B012 DD DF 8B                 ...
        sta     $9FDD                           ; B015 8D DD 9F                 ...
        eor     $57,x                           ; B018 55 57                    UW
        .byte   $FD                             ; B01A FD                       .
        .byte   $FF                             ; B01B FF                       .
LB01C:  adc     $77,x                           ; B01C 75 77                    uw
        and     $5A3B,y                         ; B01E 39 3B 5A                 9;Z
        brk                                     ; B021 00                       .
LB022:  dec     L0000,x                         ; B022 D6 00                    ..
        adc     $F40F,y                         ; B024 79 0F F4                 y..
        inc     $5B,x                           ; B027 F6 5B                    .[
        brk                                     ; B029 00                       .
        inc     L0000,x                         ; B02A F6 00                    ..
        ora     (L0000,x)                       ; B02C 01 00                    ..
        cmp     #$CB                            ; B02E C9 CB                    ..
        sta     ($93),y                         ; B030 91 93                    ..
        .byte   $7B                             ; B032 7B                       {
        adc     a:L0000,x                       ; B033 7D 00 00                 }..
        brk                                     ; B036 00                       .
        dec     $1D39,x                         ; B037 DE 39 1D                 .9.
        .byte   $5F                             ; B03A 5F                       _
        .byte   $7F                             ; B03B 7F                       .
        .byte   $02                             ; B03C 02                       .
        ora     ($3F,x)                         ; B03D 01 3F                    .?
        .byte   $DF                             ; B03F DF                       .
        inc     a:$FE                           ; B040 EE FE 00                 ...
        brk                                     ; B043 00                       .
        brk                                     ; B044 00                       .
        brk                                     ; B045 00                       .
        ora     $17,x                           ; B046 15 17                    ..
        brk                                     ; B048 00                       .
        brk                                     ; B049 00                       .
        brk                                     ; B04A 00                       .
        brk                                     ; B04B 00                       .
        brk                                     ; B04C 00                       .
        brk                                     ; B04D 00                       .
        and     $37,x                           ; B04E 35 37                    57
        ora     ($01,x)                         ; B050 01 01                    ..
        brk                                     ; B052 00                       .
        brk                                     ; B053 00                       .
        brk                                     ; B054 00                       .
        brk                                     ; B055 00                       .
        brk                                     ; B056 00                       .
        brk                                     ; B057 00                       .
        .byte   $9B                             ; B058 9B                       .
        lda     LBDBB,y                         ; B059 B9 BB BD                 ...
        .byte   $02                             ; B05C 02                       .
        .byte   $97                             ; B05D 97                       .
        .byte   $BF                             ; B05E BF                       .
        eor     $0202,y                         ; B05F 59 02 02                 Y..
        sta     $1095                           ; B062 8D 95 10                 ...
        .byte   $83                             ; B065 83                       .
        cmp     (L0000),y                       ; B066 D1 00                    ..
        ora     ($02,x)                         ; B068 01 02                    ..
        ldx     LA18D,y                         ; B06A BE 8D A1                 ...
        .byte   $A3                             ; B06D A3                       .
        .byte   $C2                             ; B06E C2                       .
        .byte   $F3                             ; B06F F3                       .
        brk                                     ; B070 00                       .
        sta     $10,y                           ; B071 99 10 00                 ...
        cmp     ($C3,x)                         ; B074 C1 C3                    ..
        brk                                     ; B076 00                       .
        brk                                     ; B077 00                       .
        brk                                     ; B078 00                       .
        brk                                     ; B079 00                       .
        sta     $87                             ; B07A 85 87                    ..
        .byte   $02                             ; B07C 02                       .
        .byte   $B7                             ; B07D B7                       .
        brk                                     ; B07E 00                       .
        brk                                     ; B07F 00                       .
        .byte   $02                             ; B080 02                       .
        .byte   $02                             ; B081 02                       .
        .byte   $02                             ; B082 02                       .
        brk                                     ; B083 00                       .
        brk                                     ; B084 00                       .
        brk                                     ; B085 00                       .
        adc     ($73),y                         ; B086 71 73                    qs
        lda     ($B3),y                         ; B088 B1 B3                    ..
        sbc     $FCFA,y                         ; B08A F9 FA FC                 ...
        .byte   $FF                             ; B08D FF                       .
        adc     $77,x                           ; B08E 75 77                    uw
        cmp     ($D3),y                         ; B090 D1 D3                    ..
        lsr     $914E                           ; B092 4E 4E 91                 NN.
        .byte   $93                             ; B095 93                       .
        ora     ($D5,x)                         ; B096 01 D5                    ..
        sbc     ($F3),y                         ; B098 F1 F3                    ..
        brk                                     ; B09A 00                       .
        brk                                     ; B09B 00                       .
        cmp     $F5,x                           ; B09C D5 F5                    ..
        ora     ($E5,x)                         ; B09E 01 E5                    ..
        lsr     $4E4E                           ; B0A0 4E 4E 4E                 NNN
        brk                                     ; B0A3 00                       .
        brk                                     ; B0A4 00                       .
        brk                                     ; B0A5 00                       .
        brk                                     ; B0A6 00                       .
        brk                                     ; B0A7 00                       .
        lsr     $4E00                           ; B0A8 4E 00 4E                 N.N
        brk                                     ; B0AB 00                       .
        brk                                     ; B0AC 00                       .
        .byte   $CF                             ; B0AD CF                       .
        ldx     a:L0000,y                       ; B0AE BE 00 00                 ...
        brk                                     ; B0B1 00                       .
        brk                                     ; B0B2 00                       .
        .byte   $BF                             ; B0B3 BF                       .
        .byte   $CF                             ; B0B4 CF                       .
        .byte   $CF                             ; B0B5 CF                       .
        eor     ($53),y                         ; B0B6 51 53                    QS
        .byte   $BB                             ; B0B8 BB                       .
        cmp     a:L0000,x                       ; B0B9 DD 00 00                 ...
        .byte   $CF                             ; B0BC CF                       .
        .byte   $CF                             ; B0BD CF                       .
        eor     $57,x                           ; B0BE 55 57                    UW
        sta     ($93),y                         ; B0C0 91 93                    ..
        lsr     a:$4F                           ; B0C2 4E 4F 00                 NO.
        brk                                     ; B0C5 00                       .
        sta     L0000,y                         ; B0C6 99 00 00                 ...
        sta     $94,x                           ; B0C9 95 94                    ..
        ldy     $94,x                           ; B0CB B4 94                    ..
        .byte   $7F                             ; B0CD 7F                       .
        sta     $D9,x                           ; B0CE 95 D9                    ..
        brk                                     ; B0D0 00                       .
        lda     $B4,x                           ; B0D1 B5 B4                    ..
        cmp     $10,x                           ; B0D3 D5 10                    ..
        cmp     $10D4,y                         ; B0D5 D9 D4 10                 ...
        lda     $A5                             ; B0D8 A5 A5                    ..
        ldy     $D8,x                           ; B0DA B4 D8                    ..
        .byte   $D3                             ; B0DC D3                       .
        .byte   $A7                             ; B0DD A7                       .
        stx     $97,y                           ; B0DE 96 97                    ..
        ora     $1B,y                           ; B0E0 19 1B 00                 ...
        sbc     ($F3),y                         ; B0E3 F1 F3                    ..
        .byte   $D3                             ; B0E5 D3                       .
        .byte   $F2                             ; B0E6 F2                       .
        .byte   $87                             ; B0E7 87                       .
        and     ($33),y                         ; B0E8 31 33                    13
        .byte   $9B                             ; B0EA 9B                       .
        sta     $F59E,x                         ; B0EB 9D 9E F5                 ...
        .byte   $97                             ; B0EE 97                       .
        .byte   $97                             ; B0EF 97                       .
        lda     $91BF,x                         ; B0F0 BD BF 91                 ...
        .byte   $BB                             ; B0F3 BB                       .
        .byte   $93                             ; B0F4 93                       .
        sta     ($BB),y                         ; B0F5 91 BB                    ..
        .byte   $93                             ; B0F7 93                       .
        lda     $C299,y                         ; B0F8 B9 99 C2                 ...
        cmp     ($A3),y                         ; B0FB D1 A3                    ..
        sta     $DFDD,y                         ; B0FD 99 DD DF                 ...
        brk                                     ; B100 00                       .
        .byte   $03                             ; B101 03                       .
        bpl     LB114                           ; B102 10 10                    ..
        .byte   $02                             ; B104 02                       .
        .byte   $02                             ; B105 02                       .
        .byte   $02                             ; B106 02                       .
        ora     ($23),y                         ; B107 11 23                    .#
        .byte   $03                             ; B109 03                       .
        bpl     LB11C                           ; B10A 10 10                    ..
        .byte   $13                             ; B10C 13                       .
        .byte   $13                             ; B10D 13                       .
        .byte   $13                             ; B10E 13                       .
        .byte   $F2                             ; B10F F2                       .
        .byte   $02                             ; B110 02                       .
        .byte   $02                             ; B111 02                       .
        .byte   $02                             ; B112 02                       .
        .byte   $02                             ; B113 02                       .
LB114:  .byte   $02                             ; B114 02                       .
        .byte   $02                             ; B115 02                       .
        .byte   $02                             ; B116 02                       .
        .byte   $03                             ; B117 03                       .
        .byte   $02                             ; B118 02                       .
        .byte   $02                             ; B119 02                       .
        .byte   $02                             ; B11A 02                       .
        .byte   $02                             ; B11B 02                       .
LB11C:  .byte   $02                             ; B11C 02                       .
        .byte   $02                             ; B11D 02                       .
        bpl     LB130                           ; B11E 10 10                    ..
        .byte   $03                             ; B120 03                       .
        .byte   $03                             ; B121 03                       .
        .byte   $03                             ; B122 03                       .
        .byte   $03                             ; B123 03                       .
        bmi     LB169                           ; B124 30 43                    0C
        ora     ($01,x)                         ; B126 01 01                    ..
        .byte   $03                             ; B128 03                       .
        .byte   $03                             ; B129 03                       .
        .byte   $03                             ; B12A 03                       .
        .byte   $03                             ; B12B 03                       .
        ora     (L0000,x)                       ; B12C 01 00                    ..
        ora     ($01,x)                         ; B12E 01 01                    ..
LB130:  .byte   $12                             ; B130 12                       .
        .byte   $12                             ; B131 12                       .
        ora     ($01,x)                         ; B132 01 01                    ..
        brk                                     ; B134 00                       .
        brk                                     ; B135 00                       .
        brk                                     ; B136 00                       .
        .byte   $F2                             ; B137 F2                       .
        bpl     LB14A                           ; B138 10 10                    ..
        ora     ($01,x)                         ; B13A 01 01                    ..
        brk                                     ; B13C 00                       .
        brk                                     ; B13D 00                       .
        .byte   $02                             ; B13E 02                       .
        .byte   $F2                             ; B13F F2                       .
        .byte   $02                             ; B140 02                       .
        .byte   $02                             ; B141 02                       .
        brk                                     ; B142 00                       .
        brk                                     ; B143 00                       .
        brk                                     ; B144 00                       .
        brk                                     ; B145 00                       .
        rts                                     ; B146 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; B147 60                       `

; ----------------------------------------------------------------------------
        brk                                     ; B148 00                       .
        brk                                     ; B149 00                       .
LB14A:  brk                                     ; B14A 00                       .
        brk                                     ; B14B 00                       .
        brk                                     ; B14C 00                       .
        brk                                     ; B14D 00                       .
        rts                                     ; B14E 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; B14F 60                       `

; ----------------------------------------------------------------------------
        .byte   $03                             ; B150 03                       .
        .byte   $03                             ; B151 03                       .
        brk                                     ; B152 00                       .
        .byte   $04                             ; B153 04                       .
        brk                                     ; B154 00                       .
        brk                                     ; B155 00                       .
        brk                                     ; B156 00                       .
        brk                                     ; B157 00                       .
        .byte   $03                             ; B158 03                       .
        .byte   $03                             ; B159 03                       .
        .byte   $03                             ; B15A 03                       .
        .byte   $03                             ; B15B 03                       .
        .byte   $03                             ; B15C 03                       .
        .byte   $03                             ; B15D 03                       .
        .byte   $03                             ; B15E 03                       .
        ora     ($03,x)                         ; B15F 01 03                    ..
        .byte   $03                             ; B161 03                       .
        .byte   $03                             ; B162 03                       .
        .byte   $03                             ; B163 03                       .
        .byte   $03                             ; B164 03                       .
        .byte   $03                             ; B165 03                       .
        .byte   $03                             ; B166 03                       .
        .byte   $03                             ; B167 03                       .
        .byte   $03                             ; B168 03                       .
LB169:  .byte   $03                             ; B169 03                       .
        .byte   $03                             ; B16A 03                       .
        .byte   $03                             ; B16B 03                       .
        .byte   $03                             ; B16C 03                       .
        .byte   $03                             ; B16D 03                       .
        .byte   $03                             ; B16E 03                       .
        .byte   $03                             ; B16F 03                       .
        brk                                     ; B170 00                       .
        .byte   $03                             ; B171 03                       .
        .byte   $03                             ; B172 03                       .
        .byte   $03                             ; B173 03                       .
        .byte   $03                             ; B174 03                       .
        .byte   $03                             ; B175 03                       .
        .byte   $03                             ; B176 03                       .
        .byte   $03                             ; B177 03                       .
        .byte   $03                             ; B178 03                       .
        .byte   $03                             ; B179 03                       .
        .byte   $03                             ; B17A 03                       .
        .byte   $03                             ; B17B 03                       .
        .byte   $03                             ; B17C 03                       .
        .byte   $03                             ; B17D 03                       .
        .byte   $03                             ; B17E 03                       .
        .byte   $03                             ; B17F 03                       .
        .byte   $03                             ; B180 03                       .
        .byte   $03                             ; B181 03                       .
        .byte   $03                             ; B182 03                       .
        .byte   $03                             ; B183 03                       .
        .byte   $03                             ; B184 03                       .
        .byte   $03                             ; B185 03                       .
        .byte   $12                             ; B186 12                       .
        .byte   $12                             ; B187 12                       .
        .byte   $12                             ; B188 12                       .
        .byte   $12                             ; B189 12                       .
        .byte   $13                             ; B18A 13                       .
        .byte   $13                             ; B18B 13                       .
        .byte   $13                             ; B18C 13                       .
        .byte   $12                             ; B18D 12                       .
        .byte   $12                             ; B18E 12                       .
        .byte   $12                             ; B18F 12                       .
        .byte   $12                             ; B190 12                       .
        .byte   $12                             ; B191 12                       .
        bpl     LB1A4                           ; B192 10 10                    ..
        .byte   $12                             ; B194 12                       .
        .byte   $12                             ; B195 12                       .
        .byte   $12                             ; B196 12                       .
        .byte   $12                             ; B197 12                       .
        .byte   $12                             ; B198 12                       .
        .byte   $12                             ; B199 12                       .
        brk                                     ; B19A 00                       .
        brk                                     ; B19B 00                       .
        .byte   $12                             ; B19C 12                       .
        .byte   $12                             ; B19D 12                       .
        .byte   $12                             ; B19E 12                       .
        .byte   $12                             ; B19F 12                       .
        brk                                     ; B1A0 00                       .
        brk                                     ; B1A1 00                       .
        brk                                     ; B1A2 00                       .
        brk                                     ; B1A3 00                       .
LB1A4:  brk                                     ; B1A4 00                       .
        brk                                     ; B1A5 00                       .
        brk                                     ; B1A6 00                       .
        brk                                     ; B1A7 00                       .
        brk                                     ; B1A8 00                       .
        brk                                     ; B1A9 00                       .
        brk                                     ; B1AA 00                       .
        brk                                     ; B1AB 00                       .
        brk                                     ; B1AC 00                       .
        brk                                     ; B1AD 00                       .
        brk                                     ; B1AE 00                       .
        brk                                     ; B1AF 00                       .
        brk                                     ; B1B0 00                       .
        brk                                     ; B1B1 00                       .
        .byte   $03                             ; B1B2 03                       .
        .byte   $03                             ; B1B3 03                       .
        brk                                     ; B1B4 00                       .
        brk                                     ; B1B5 00                       .
        ora     ($01,x)                         ; B1B6 01 01                    ..
        .byte   $03                             ; B1B8 03                       .
        .byte   $03                             ; B1B9 03                       .
        brk                                     ; B1BA 00                       .
        brk                                     ; B1BB 00                       .
        brk                                     ; B1BC 00                       .
        brk                                     ; B1BD 00                       .
        ora     ($01,x)                         ; B1BE 01 01                    ..
        .byte   $02                             ; B1C0 02                       .
        .byte   $02                             ; B1C1 02                       .
        brk                                     ; B1C2 00                       .
        brk                                     ; B1C3 00                       .
        brk                                     ; B1C4 00                       .
        brk                                     ; B1C5 00                       .
        bpl     LB1C8                           ; B1C6 10 00                    ..
LB1C8:  .byte   $03                             ; B1C8 03                       .
        .byte   $13                             ; B1C9 13                       .
        .byte   $13                             ; B1CA 13                       .
        .byte   $13                             ; B1CB 13                       .
        .byte   $13                             ; B1CC 13                       .
        .byte   $13                             ; B1CD 13                       .
        .byte   $13                             ; B1CE 13                       .
        .byte   $03                             ; B1CF 03                       .
        .byte   $03                             ; B1D0 03                       .
        .byte   $13                             ; B1D1 13                       .
        .byte   $13                             ; B1D2 13                       .
        .byte   $03                             ; B1D3 03                       .
        .byte   $03                             ; B1D4 03                       .
        .byte   $03                             ; B1D5 03                       .
        .byte   $03                             ; B1D6 03                       .
        .byte   $03                             ; B1D7 03                       .
        .byte   $13                             ; B1D8 13                       .
        .byte   $13                             ; B1D9 13                       .
        .byte   $13                             ; B1DA 13                       .
        .byte   $03                             ; B1DB 03                       .
        .byte   $03                             ; B1DC 03                       .
        .byte   $13                             ; B1DD 13                       .
        .byte   $13                             ; B1DE 13                       .
        bpl     LB1E2                           ; B1DF 10 01                    ..
        .byte   $01                             ; B1E1 01                       .
LB1E2:  brk                                     ; B1E2 00                       .
        .byte   $03                             ; B1E3 03                       .
        .byte   $03                             ; B1E4 03                       .
        .byte   $03                             ; B1E5 03                       .
        bpl     LB1F8                           ; B1E6 10 10                    ..
        ora     ($01,x)                         ; B1E8 01 01                    ..
        .byte   $13                             ; B1EA 13                       .
        .byte   $13                             ; B1EB 13                       .
        .byte   $13                             ; B1EC 13                       .
        .byte   $03                             ; B1ED 03                       .
        bpl     LB200                           ; B1EE 10 10                    ..
        .byte   $12                             ; B1F0 12                       .
        .byte   $12                             ; B1F1 12                       .
        .byte   $13                             ; B1F2 13                       .
        .byte   $13                             ; B1F3 13                       .
        .byte   $13                             ; B1F4 13                       .
        .byte   $13                             ; B1F5 13                       .
        .byte   $13                             ; B1F6 13                       .
        .byte   $13                             ; B1F7 13                       .
LB1F8:  .byte   $13                             ; B1F8 13                       .
        .byte   $13                             ; B1F9 13                       .
        .byte   $13                             ; B1FA 13                       .
        .byte   $13                             ; B1FB 13                       .
        .byte   $13                             ; B1FC 13                       .
        bpl     LB212                           ; B1FD 10 13                    ..
        .byte   $10                             ; B1FF 10                       .
LB200:  bpl     LB213                           ; B200 10 11                    ..
        clc                                     ; B202 18                       .
        ora     $0909,y                         ; B203 19 09 09                 ...
        ora     #$09                            ; B206 09 09                    ..
        .byte   $14                             ; B208 14                       .
        ora     $1A,x                           ; B209 15 1A                    ..
        .byte   $1B                             ; B20B 1B                       .
        .byte   $CF                             ; B20C CF                       .
        .byte   $D3                             ; B20D D3                       .
        ora     ($01,x)                         ; B20E 01 01                    ..
        .byte   $D4                             ; B210 D4                       .
        .byte   $D5                             ; B211 D5                       .
LB212:  .byte   $01                             ; B212 01                       .
LB213:  ora     ($12,x)                         ; B213 01 12                    ..
        .byte   $13                             ; B215 13                       .
        .byte   $1A                             ; B216 1A                       .
        .byte   $1B                             ; B217 1B                       .
        ora     ($01,x)                         ; B218 01 01                    ..
        ora     ($01,x)                         ; B21A 01 01                    ..
        asl     $0A1F,x                         ; B21C 1E 1F 0A                 ...
        .byte   $0B                             ; B21F 0B                       .
        asl     $0A39,x                         ; B220 1E 39 0A                 .9.
        .byte   $0B                             ; B223 0B                       .
        .byte   $F2                             ; B224 F2                       .
        .byte   $F3                             ; B225 F3                       .
        .byte   $FA                             ; B226 FA                       .
        .byte   $0B                             ; B227 0B                       .
        .byte   $F4                             ; B228 F4                       .
        sbc     $F0FC,y                         ; B229 F9 FC F0                 ...
        sbc     $F1F2,y                         ; B22C F9 F2 F1                 ...
        .byte   $FA                             ; B22F FA                       .
        .byte   $F3                             ; B230 F3                       .
        .byte   $F4                             ; B231 F4                       .
        .byte   $03                             ; B232 03                       .
        .byte   $FC                             ; B233 FC                       .
        .byte   $CB                             ; B234 CB                       .
        .byte   $DA                             ; B235 DA                       .
LB236:  asl     a                               ; B236 0A                       .
        .byte   $0B                             ; B237 0B                       .
        .byte   $02                             ; B238 02                       .
        .byte   $03                             ; B239 03                       .
        asl     a                               ; B23A 0A                       .
        .byte   $0B                             ; B23B 0B                       .
        sbc     $F6,x                           ; B23C F5 F6                    ..
        .byte   $FA                             ; B23E FA                       .
LB23F:  .byte   $0B                             ; B23F 0B                       .
        .byte   $F7                             ; B240 F7                       .
        beq     LB23F                           ; B241 F0 FC                    ..
        beq     LB236                           ; B243 F0 F1                    ..
        sbc     $F1,x                           ; B245 F5 F1                    ..
        .byte   $FA                             ; B247 FA                       .
        inc     $F7,x                           ; B248 F6 F7                    ..
        .byte   $03                             ; B24A 03                       .
        .byte   $FC                             ; B24B FC                       .
        .byte   $D3                             ; B24C D3                       .
        cmp     $01,x                           ; B24D D5 01                    ..
        ora     ($12,x)                         ; B24F 01 12                    ..
        .byte   $13                             ; B251 13                       .
        .byte   $F2                             ; B252 F2                       .
        .byte   $F3                             ; B253 F3                       .
        cmp     #$CB                            ; B254 C9 CB                    ..
        cld                                     ; B256 D8                       .
        .byte   $0B                             ; B257 0B                       .
        .byte   $DA                             ; B258 DA                       .
        .byte   $CB                             ; B259 CB                       .
        asl     a                               ; B25A 0A                       .
        .byte   $0B                             ; B25B 0B                       .
        .byte   $FA                             ; B25C FA                       .
        .byte   $02                             ; B25D 02                       .
        sbc     $F6,x                           ; B25E F5 F6                    ..
        cmp     ($03),y                         ; B260 D1 03                    ..
        asl     a                               ; B262 0A                       .
        .byte   $0B                             ; B263 0B                       .
        iny                                     ; B264 C8                       .
        brk                                     ; B265 00                       .
        bne     LB268                           ; B266 D0 00                    ..
LB268:  cpx     #$E1                            ; B268 E0 E1                    ..
        inx                                     ; B26A E8                       .
        sbc     #$32                            ; B26B E9 32                    .2
        .byte   $33                             ; B26D 33                       3
        .byte   $3A                             ; B26E 3A                       :
        .byte   $3B                             ; B26F 3B                       ;
        brk                                     ; B270 00                       .
        brk                                     ; B271 00                       .
        brk                                     ; B272 00                       .
        brk                                     ; B273 00                       .
        brk                                     ; B274 00                       .
        sbc     (L0000,x)                       ; B275 E1 00                    ..
        brk                                     ; B277 00                       .
        .byte   $3A                             ; B278 3A                       :
        .byte   $3B                             ; B279 3B                       ;
        .byte   $3A                             ; B27A 3A                       :
        .byte   $3B                             ; B27B 3B                       ;
        ora     #$09                            ; B27C 09 09                    ..
        cmp     #$CB                            ; B27E C9 CB                    ..
        iny                                     ; B280 C8                       .
        brk                                     ; B281 00                       .
        .byte   $DA                             ; B282 DA                       .
        .byte   $CB                             ; B283 CB                       .
        brk                                     ; B284 00                       .
        brk                                     ; B285 00                       .
        .byte   $F2                             ; B286 F2                       .
        .byte   $F3                             ; B287 F3                       .
        brk                                     ; B288 00                       .
        brk                                     ; B289 00                       .
        .byte   $F4                             ; B28A F4                       .
        sbc     L0000,y                         ; B28B F9 00 00                 ...
        sbc     $12F2,y                         ; B28E F9 F2 12                 ...
        .byte   $13                             ; B291 13                       .
        .byte   $F4                             ; B292 F4                       .
        sbc     $1312,y                         ; B293 F9 12 13                 ...
LB296:  sbc     $01F2,y                         ; B296 F9 F2 01                 ...
        .byte   $01                             ; B299 01                       .
LB29A:  .byte   $F3                             ; B29A F3                       .
        .byte   $F4                             ; B29B F4                       .
        cld                                     ; B29C D8                       .
        .byte   $0B                             ; B29D 0B                       .
        cmp     ($0B),y                         ; B29E D1 0B                    ..
        .byte   $FC                             ; B2A0 FC                       .
        beq     LB29A                           ; B2A1 F0 F7                    ..
        beq     LB296                           ; B2A3 F0 F1                    ..
        .byte   $FA                             ; B2A5 FA                       .
        sbc     ($F5),y                         ; B2A6 F1 F5                    ..
        asl     a                               ; B2A8 0A                       .
        .byte   $FC                             ; B2A9 FC                       .
        inc     $F7,x                           ; B2AA F6 F7                    ..
        asl     a                               ; B2AC 0A                       .
        .byte   $0B                             ; B2AD 0B                       .
        brk                                     ; B2AE 00                       .
        brk                                     ; B2AF 00                       .
        php                                     ; B2B0 08                       .
        brk                                     ; B2B1 00                       .
LB2B2:  php                                     ; B2B2 08                       .
        brk                                     ; B2B3 00                       .
        brk                                     ; B2B4 00                       .
        brk                                     ; B2B5 00                       .
        cmp     #$CB                            ; B2B6 C9 CB                    ..
        brk                                     ; B2B8 00                       .
        brk                                     ; B2B9 00                       .
        .byte   $DA                             ; B2BA DA                       .
        .byte   $CB                             ; B2BB CB                       .
        cmp     #$CB                            ; B2BC C9 CB                    ..
        cmp     ($02),y                         ; B2BE D1 02                    ..
        brk                                     ; B2C0 00                       .
        brk                                     ; B2C1 00                       .
        .byte   $F3                             ; B2C2 F3                       .
LB2C3:  .byte   $F4                             ; B2C3 F4                       .
        cmp     #$CB                            ; B2C4 C9 CB                    ..
        cmp     ($0B),y                         ; B2C6 D1 0B                    ..
        .byte   $02                             ; B2C8 02                       .
        .byte   $03                             ; B2C9 03                       .
        asl     a                               ; B2CA 0A                       .
        cmp     #$02                            ; B2CB C9 02                    ..
        .byte   $03                             ; B2CD 03                       .
        .byte   $CB                             ; B2CE CB                       .
        .byte   $CB                             ; B2CF CB                       .
        .byte   $FA                             ; B2D0 FA                       .
        .byte   $02                             ; B2D1 02                       .
        nop                                     ; B2D2 EA                       .
        .byte   $EB                             ; B2D3 EB                       .
        .byte   $FC                             ; B2D4 FC                       .
        beq     LB2C3                           ; B2D5 F0 EC                    ..
        sed                                     ; B2D7 F8                       .
        sbc     ($FA),y                         ; B2D8 F1 FA                    ..
        sed                                     ; B2DA F8                       .
        nop                                     ; B2DB EA                       .
        .byte   $02                             ; B2DC 02                       .
        .byte   $DA                             ; B2DD DA                       .
        asl     a                               ; B2DE 0A                       .
        brk                                     ; B2DF 00                       .
        .byte   $DA                             ; B2E0 DA                       .
        .byte   $CB                             ; B2E1 CB                       .
        brk                                     ; B2E2 00                       .
        brk                                     ; B2E3 00                       .
        .byte   $CB                             ; B2E4 CB                       .
        cmp     (L0000),y                       ; B2E5 D1 00                    ..
        brk                                     ; B2E7 00                       .
        .byte   $02                             ; B2E8 02                       .
        .byte   $3B                             ; B2E9 3B                       ;
        asl     a                               ; B2EA 0A                       .
        .byte   $3B                             ; B2EB 3B                       ;
        .byte   $02                             ; B2EC 02                       .
        .byte   $DA                             ; B2ED DA                       .
        asl     a                               ; B2EE 0A                       .
        .byte   $0B                             ; B2EF 0B                       .
        and     $CB                             ; B2F0 25 CB                    %.
        php                                     ; B2F2 08                       .
        brk                                     ; B2F3 00                       .
        cmp     ($0B),y                         ; B2F4 D1 0B                    ..
        brk                                     ; B2F6 00                       .
        brk                                     ; B2F7 00                       .
        .byte   $CB                             ; B2F8 CB                       .
        dex                                     ; B2F9 CA                       .
        asl     a                               ; B2FA 0A                       .
        .byte   $D2                             ; B2FB D2                       .
        brk                                     ; B2FC 00                       .
        brk                                     ; B2FD 00                       .
        and     $DD                             ; B2FE 25 DD                    %.
        php                                     ; B300 08                       .
        .byte   $03                             ; B301 03                       .
        asl     a                               ; B302 0A                       .
        .byte   $0B                             ; B303 0B                       .
        asl     a                               ; B304 0A                       .
        .byte   $FC                             ; B305 FC                       .
        .byte   $EB                             ; B306 EB                       .
        cpx     $0302                           ; B307 EC 02 03                 ...
        dex                                     ; B30A CA                       .
        .byte   $0B                             ; B30B 0B                       .
        .byte   $02                             ; B30C 02                       .
        php                                     ; B30D 08                       .
        asl     a                               ; B30E 0A                       .
        php                                     ; B30F 08                       .
        cpy     $D203                           ; B310 CC 03 D2                 ...
        dex                                     ; B313 CA                       .
        asl     a                               ; B314 0A                       .
        .byte   $0B                             ; B315 0B                       .
        .byte   $3A                             ; B316 3A                       :
        .byte   $3B                             ; B317 3B                       ;
        brk                                     ; B318 00                       .
        php                                     ; B319 08                       .
        brk                                     ; B31A 00                       .
        php                                     ; B31B 08                       .
        .byte   $3B                             ; B31C 3B                       ;
        cpy     $CC3B                           ; B31D CC 3B CC                 .;.
        brk                                     ; B320 00                       .
        brk                                     ; B321 00                       .
        .byte   $CB                             ; B322 CB                       .
        dex                                     ; B323 CA                       .
        brk                                     ; B324 00                       .
        .byte   $D2                             ; B325 D2                       .
        brk                                     ; B326 00                       .
        brk                                     ; B327 00                       .
        .byte   $CB                             ; B328 CB                       .
        dex                                     ; B329 CA                       .
        brk                                     ; B32A 00                       .
        .byte   $D2                             ; B32B D2                       .
        .byte   $CB                             ; B32C CB                       .
        dec     $D1CB,x                         ; B32D DE CB D1                 ...
        .byte   $02                             ; B330 02                       .
        cpy     $D20A                           ; B331 CC 0A D2                 ...
        brk                                     ; B334 00                       .
        brk                                     ; B335 00                       .
        dex                                     ; B336 CA                       .
        brk                                     ; B337 00                       .
        and     $DA                             ; B338 25 DA                    %.
        php                                     ; B33A 08                       .
        .byte   $0B                             ; B33B 0B                       .
        cpy     $CC00                           ; B33C CC 00 CC                 ...
        brk                                     ; B33F 00                       .
        php                                     ; B340 08                       .
        .byte   $03                             ; B341 03                       .
        brk                                     ; B342 00                       .
        brk                                     ; B343 00                       .
        .byte   $D2                             ; B344 D2                       .
        .byte   $CB                             ; B345 CB                       .
        asl     a                               ; B346 0A                       .
        .byte   $0B                             ; B347 0B                       .
        bit     $24                             ; B348 24 24                    $$
        .byte   $CB                             ; B34A CB                       .
        .byte   $CB                             ; B34B CB                       .
        brk                                     ; B34C 00                       .
        brk                                     ; B34D 00                       .
        .byte   $CB                             ; B34E CB                       .
        .byte   $CB                             ; B34F CB                       .
        nop                                     ; B350 EA                       .
        .byte   $EB                             ; B351 EB                       .
        brk                                     ; B352 00                       .
        brk                                     ; B353 00                       .
        cpx     a:$F8                           ; B354 EC F8 00                 ...
        brk                                     ; B357 00                       .
        sed                                     ; B358 F8                       .
        nop                                     ; B359 EA                       .
        brk                                     ; B35A 00                       .
        brk                                     ; B35B 00                       .
        .byte   $DA                             ; B35C DA                       .
        cmp     a:L0000,x                       ; B35D DD 00 00                 ...
        brk                                     ; B360 00                       .
        brk                                     ; B361 00                       .
        brk                                     ; B362 00                       .
        .byte   $DA                             ; B363 DA                       .
        .byte   $02                             ; B364 02                       .
        cpy     $CC0A                           ; B365 CC 0A CC                 ...
        brk                                     ; B368 00                       .
        .byte   $3B                             ; B369 3B                       ;
        dex                                     ; B36A CA                       .
        brk                                     ; B36B 00                       .
        brk                                     ; B36C 00                       .
        .byte   $03                             ; B36D 03                       .
        brk                                     ; B36E 00                       .
        sbc     #$02                            ; B36F E9 02                    ..
        .byte   $D2                             ; B371 D2                       .
        asl     a                               ; B372 0A                       .
        .byte   $0B                             ; B373 0B                       .
        dex                                     ; B374 CA                       .
        brk                                     ; B375 00                       .
        .byte   $D2                             ; B376 D2                       .
        .byte   $CB                             ; B377 CB                       .
        brk                                     ; B378 00                       .
        brk                                     ; B379 00                       .
        .byte   $DD                             ; B37A DD                       .
LB37B:  and     $F0                             ; B37B 25 F0                    %.
        sbc     ($F0),y                         ; B37D F1 F0                    ..
        sbc     ($EB),y                         ; B37F F1 EB                    ..
        cpx     a:L0000                         ; B381 EC 00 00                 ...
        dex                                     ; B384 CA                       .
        .byte   $03                             ; B385 03                       .
        .byte   $D2                             ; B386 D2                       .
        .byte   $CB                             ; B387 CB                       .
        beq     LB37B                           ; B388 F0 F1                    ..
        sed                                     ; B38A F8                       .
        sed                                     ; B38B F8                       .
        .byte   $CB                             ; B38C CB                       .
        .byte   $CB                             ; B38D CB                       .
        .byte   $3A                             ; B38E 3A                       :
        .byte   $3B                             ; B38F 3B                       ;
        sbc     $F0F9,y                         ; B390 F9 F9 F0                 ...
        sbc     ($D8),y                         ; B393 F1 D8                    ..
        php                                     ; B395 08                       .
        cld                                     ; B396 D8                       .
        php                                     ; B397 08                       .
        cpy     $CC03                           ; B398 CC 03 CC                 ...
        .byte   $0B                             ; B39B 0B                       .
        cpy     $D203                           ; B39C CC 03 D2                 ...
        .byte   $CB                             ; B39F CB                       .
        .byte   $02                             ; B3A0 02                       .
        dec     $D1CB                           ; B3A1 CE CB D1                 ...
        cmp     ($08),y                         ; B3A4 D1 08                    ..
        brk                                     ; B3A6 00                       .
        php                                     ; B3A7 08                       .
        brk                                     ; B3A8 00                       .
        php                                     ; B3A9 08                       .
        .byte   $CB                             ; B3AA CB                       .
        .byte   $CB                             ; B3AB CB                       .
        cpx     a:$F8                           ; B3AC EC F8 00                 ...
        sbc     ($3B,x)                         ; B3AF E1 3B                    .;
        .byte   $3B                             ; B3B1 3B                       ;
        .byte   $3A                             ; B3B2 3A                       :
        .byte   $3B                             ; B3B3 3B                       ;
        brk                                     ; B3B4 00                       .
        brk                                     ; B3B5 00                       .
        brk                                     ; B3B6 00                       .
        sec                                     ; B3B7 38                       8
        brk                                     ; B3B8 00                       .
        brk                                     ; B3B9 00                       .
        .byte   $1F                             ; B3BA 1F                       .
        asl     $1F38,x                         ; B3BB 1E 38 1F                 .8.
        asl     a                               ; B3BE 0A                       .
        .byte   $0B                             ; B3BF 0B                       .
        brk                                     ; B3C0 00                       .
        brk                                     ; B3C1 00                       .
        sec                                     ; B3C2 38                       8
        and     $3B00,y                         ; B3C3 39 00 3B                 9.;
        and     $0200,y                         ; B3C6 39 00 02                 9..
        sec                                     ; B3C9 38                       8
        asl     a                               ; B3CA 0A                       .
        .byte   $0B                             ; B3CB 0B                       .
        .byte   $1F                             ; B3CC 1F                       .
        asl     $0B0A,x                         ; B3CD 1E 0A 0B                 ...
        .byte   $1F                             ; B3D0 1F                       .
        and     $0B0A,y                         ; B3D1 39 0A 0B                 9..
        brk                                     ; B3D4 00                       .
        brk                                     ; B3D5 00                       .
        cmp     $D825,y                         ; B3D6 D9 25 D8                 .%.
        php                                     ; B3D9 08                       .
        cld                                     ; B3DA D8                       .
        .byte   $0B                             ; B3DB 0B                       .
        asl     a                               ; B3DC 0A                       .
        .byte   $0B                             ; B3DD 0B                       .
        .byte   $3B                             ; B3DE 3B                       ;
        .byte   $3B                             ; B3DF 3B                       ;
        brk                                     ; B3E0 00                       .
        brk                                     ; B3E1 00                       .
        sec                                     ; B3E2 38                       8
        .byte   $1F                             ; B3E3 1F                       .
        brk                                     ; B3E4 00                       .
        brk                                     ; B3E5 00                       .
        asl     a:$1F,x                         ; B3E6 1E 1F 00                 ...
        brk                                     ; B3E9 00                       .
        asl     $3839,x                         ; B3EA 1E 39 38                 .98
        and     $0B0A,y                         ; B3ED 39 0A 0B                 9..
        php                                     ; B3F0 08                       .
        sec                                     ; B3F1 38                       8
        php                                     ; B3F2 08                       .
        .byte   $0B                             ; B3F3 0B                       .
        php                                     ; B3F4 08                       .
        .byte   $03                             ; B3F5 03                       .
        php                                     ; B3F6 08                       .
        .byte   $0B                             ; B3F7 0B                       .
        and     $0A03,y                         ; B3F8 39 03 0A                 9..
        .byte   $0B                             ; B3FB 0B                       .
        brk                                     ; B3FC 00                       .
        .byte   $02                             ; B3FD 02                       .
        brk                                     ; B3FE 00                       .
        asl     a                               ; B3FF 0A                       .
        .byte   $02                             ; B400 02                       .
        brk                                     ; B401 00                       .
        asl     a                               ; B402 0A                       .
        brk                                     ; B403 00                       .
        brk                                     ; B404 00                       .
        bit     $38                             ; B405 24 38                    $8
        .byte   $1F                             ; B407 1F                       .
        brk                                     ; B408 00                       .
        sec                                     ; B409 38                       8
        asl     $020B,x                         ; B40A 1E 0B 02                 ...
        brk                                     ; B40D 00                       .
        asl     a                               ; B40E 0A                       .
        and     $25,y                           ; B40F 39 25 00                 9%.
        php                                     ; B412 08                       .
        brk                                     ; B413 00                       .
        bcc     LB416                           ; B414 90 00                    ..
LB416:  tya                                     ; B416 98                       .
        brk                                     ; B417 00                       .
        brk                                     ; B418 00                       .
        bcc     LB41B                           ; B419 90 00                    ..
LB41B:  tya                                     ; B41B 98                       .
        tya                                     ; B41C 98                       .
        brk                                     ; B41D 00                       .
        tya                                     ; B41E 98                       .
        brk                                     ; B41F 00                       .
        brk                                     ; B420 00                       .
        tya                                     ; B421 98                       .
        brk                                     ; B422 00                       .
        tya                                     ; B423 98                       .
        brk                                     ; B424 00                       .
        plp                                     ; B425 28                       (
        brk                                     ; B426 00                       .
        jsr     L5150                           ; B427 20 50 51                  PQ
        ora     #$09                            ; B42A 09 09                    ..
        ora     #$58                            ; B42C 09 58                    .X
        eor     $095A,y                         ; B42E 59 5A 09                 YZ.
        ora     #$5B                            ; B431 09 5B                    .[
        eor     $0958,y                         ; B433 59 58 09                 YX.
        .byte   $5A                             ; B436 5A                       Z
        .byte   $5B                             ; B437 5B                       [
        ora     #$59                            ; B438 09 59                    .Y
        eor     $6161,y                         ; B43A 59 61 61                 Yaa
        .byte   $62                             ; B43D 62                       b
        adc     #$6A                            ; B43E 69 6A                    ij
        .byte   $63                             ; B440 63                       c
        lsr     $6401,x                         ; B441 5E 01 64                 ^.d
        .byte   $72                             ; B444 72                       r
        .byte   $63                             ; B445 63                       c
        sec                                     ; B446 38                       8
        .byte   $1F                             ; B447 1F                       .
        .byte   $5B                             ; B448 5B                       [
        ora     #$1E                            ; B449 09 1E                    ..
        .byte   $1F                             ; B44B 1F                       .
        brk                                     ; B44C 00                       .
        rol     a                               ; B44D 2A                       *
        and     $38                             ; B44E 25 38                    %8
        adc     ($69,x)                         ; B450 61 69                    ai
        asl     $0939,x                         ; B452 1E 39 09                 .9.
        ora     #$09                            ; B455 09 09                    ..
        cli                                     ; B457 58                       X
        ora     #$09                            ; B458 09 09                    ..
        ora     #$59                            ; B45A 09 59                    .Y
        eor     $615A,y                         ; B45C 59 5A 61                 YZa
        .byte   $62                             ; B45F 62                       b
        .byte   $5B                             ; B460 5B                       [
        ora     #$63                            ; B461 09 63                    .c
        .byte   $5B                             ; B463 5B                       [
        ora     #$09                            ; B464 09 09                    ..
        asl     $591F,x                         ; B466 1E 1F 59                 ..Y
        adc     ($1E,x)                         ; B469 61 1E                    a.
        and     $8D88,y                         ; B46B 39 88 8D                 9..
        stx     $87                             ; B46E 86 87                    ..
        sta     $8689                           ; B470 8D 89 86                 ...
        .byte   $87                             ; B473 87                       .
        .byte   $5B                             ; B474 5B                       [
        eor     $615C,y                         ; B475 59 5C 61                 Y\a
        .byte   $72                             ; B478 72                       r
        .byte   $63                             ; B479 63                       c
        eor     $8601,x                         ; B47A 5D 01 86                 ]..
        .byte   $87                             ; B47D 87                       .
        stx     $87                             ; B47E 86 87                    ..
        adc     #$69                            ; B480 69 69                    ii
        adc     #$69                            ; B482 69 69                    ii
        adc     #$62                            ; B484 69 62                    ib
        adc     #$6A                            ; B486 69 6A                    ij
        dey                                     ; B488 88                       .
        .byte   $89                             ; B489 89                       .
        stx     $87                             ; B48A 86 87                    ..
        adc     #$6A                            ; B48C 69 6A                    ij
        adc     #$62                            ; B48E 69 62                    ib
        ora     ($64,x)                         ; B490 01 64                    .d
        ora     ($01,x)                         ; B492 01 01                    ..
        adc     #$62                            ; B494 69 62                    ib
        dey                                     ; B496 88                       .
        sta     $0101                           ; B497 8D 01 01                 ...
        sta     $0989                           ; B49A 8D 89 09                 ...
        ora     #$58                            ; B49D 09 58                    .X
        ora     #$5B                            ; B49F 09 5B                    .[
        eor     $5E63,y                         ; B4A1 59 63 5E                 Yc^
        .byte   $5A                             ; B4A4 5A                       Z
        .byte   $5B                             ; B4A5 5B                       [
        .byte   $72                             ; B4A6 72                       r
        .byte   $63                             ; B4A7 63                       c
        ora     #$09                            ; B4A8 09 09                    ..
        .byte   $5B                             ; B4AA 5B                       [
        ora     #$59                            ; B4AB 09 59                    .Y
        adc     ($61,x)                         ; B4AD 61 61                    aa
        adc     #$69                            ; B4AF 69 69                    ii
        ror     a                               ; B4B1 6A                       j
        dey                                     ; B4B2 88                       .
        sta     $6401                           ; B4B3 8D 01 64                 ..d
        sta     $5D89                           ; B4B6 8D 89 5D                 ..]
        ora     ($63,x)                         ; B4B9 01 63                    .c
        eor     $8D8D,x                         ; B4BB 5D 8D 8D                 ]..
        stx     $87                             ; B4BE 86 87                    ..
        ora     ($64,x)                         ; B4C0 01 64                    .d
        dey                                     ; B4C2 88                       .
        .byte   $89                             ; B4C3 89                       .
        brk                                     ; B4C4 00                       .
        php                                     ; B4C5 08                       .
        asl     $4639,x                         ; B4C6 1E 39 46                 .9F
        .byte   $47                             ; B4C9 47                       G
        lsr     $464F                           ; B4CA 4E 4F 46                 NOF
        brk                                     ; B4CD 00                       .
        lsr     $0900                           ; B4CE 4E 00 09                 N..
        ora     #$E3                            ; B4D1 09 E3                    ..
        cpx     $39                             ; B4D3 E4 39                    .9
        brk                                     ; B4D5 00                       .
        asl     a                               ; B4D6 0A                       .
        brk                                     ; B4D7 00                       .
        brk                                     ; B4D8 00                       .
        plp                                     ; B4D9 28                       (
        brk                                     ; B4DA 00                       .
        rol     a                               ; B4DB 2A                       *
        and     $0B22,y                         ; B4DC 39 22 0B                 9".
        rol     a                               ; B4DF 2A                       *
        .byte   $02                             ; B4E0 02                       .
        dey                                     ; B4E1 88                       .
        asl     a                               ; B4E2 0A                       .
        .byte   $0B                             ; B4E3 0B                       .
        .byte   $89                             ; B4E4 89                       .
        and     $0A                             ; B4E5 25 0A                    %.
        php                                     ; B4E7 08                       .
        dey                                     ; B4E8 88                       .
        sta     $0B0A                           ; B4E9 8D 0A 0B                 ...
        sbc     $63E4                           ; B4EC ED E4 63                 ..c
        .byte   $5B                             ; B4EF 5B                       [
        .byte   $72                             ; B4F0 72                       r
        .byte   $5C                             ; B4F1 5C                       \
        .byte   $5C                             ; B4F2 5C                       \
        adc     #$61                            ; B4F3 69 61                    ia
        adc     #$69                            ; B4F5 69 69                    ii
        adc     #$01                            ; B4F7 69 01                    i.
        .byte   $5C                             ; B4F9 5C                       \
        .byte   $5C                             ; B4FA 5C                       \
        adc     #$69                            ; B4FB 69 69                    ii
        rts                                     ; B4FD 60                       `

; ----------------------------------------------------------------------------
        adc     #$69                            ; B4FE 69 69                    ii
        iny                                     ; B500 C8                       .
        brk                                     ; B501 00                       .
        and     #$00                            ; B502 29 00                    ).
        and     (L0000,x)                       ; B504 21 00                    !.
        and     #$00                            ; B506 29 00                    ).
        .byte   $02                             ; B508 02                       .
        .byte   $03                             ; B509 03                       .
        brk                                     ; B50A 00                       .
        brk                                     ; B50B 00                       .
        .byte   $02                             ; B50C 02                       .
        .byte   $03                             ; B50D 03                       .
        brk                                     ; B50E 00                       .
        asl     a                               ; B50F 0A                       .
        sec                                     ; B510 38                       8
        asl     $0B0A,x                         ; B511 1E 0A 0B                 ...
        .byte   $03                             ; B514 03                       .
        brk                                     ; B515 00                       .
        .byte   $0B                             ; B516 0B                       .
        brk                                     ; B517 00                       .
        php                                     ; B518 08                       .
        .byte   $02                             ; B519 02                       .
        php                                     ; B51A 08                       .
        asl     a                               ; B51B 0A                       .
        .byte   $02                             ; B51C 02                       .
        and     $0B0A,y                         ; B51D 39 0A 0B                 9..
        sec                                     ; B520 38                       8
        .byte   $02                             ; B521 02                       .
        brk                                     ; B522 00                       .
        asl     a                               ; B523 0A                       .
        .byte   $02                             ; B524 02                       .
        brk                                     ; B525 00                       .
        .byte   $0B                             ; B526 0B                       .
        brk                                     ; B527 00                       .
        .byte   $5F                             ; B528 5F                       _
        .byte   $03                             ; B529 03                       .
        .byte   $5F                             ; B52A 5F                       _
        asl     a                               ; B52B 0A                       .
        .byte   $5F                             ; B52C 5F                       _
        brk                                     ; B52D 00                       .
        .byte   $5F                             ; B52E 5F                       _
        .byte   $5F                             ; B52F 5F                       _
        brk                                     ; B530 00                       .
        brk                                     ; B531 00                       .
        .byte   $5F                             ; B532 5F                       _
        .byte   $5F                             ; B533 5F                       _
        brk                                     ; B534 00                       .
        .byte   $03                             ; B535 03                       .
        .byte   $5F                             ; B536 5F                       _
        asl     a                               ; B537 0A                       .
        brk                                     ; B538 00                       .
        php                                     ; B539 08                       .
        .byte   $5F                             ; B53A 5F                       _
        php                                     ; B53B 08                       .
        .byte   $5F                             ; B53C 5F                       _
        .byte   $5F                             ; B53D 5F                       _
        .byte   $5F                             ; B53E 5F                       _
        .byte   $5F                             ; B53F 5F                       _
        .byte   $5F                             ; B540 5F                       _
        php                                     ; B541 08                       .
        and     $5F08,y                         ; B542 39 08 5F                 9._
        .byte   $5F                             ; B545 5F                       _
        .byte   $5F                             ; B546 5F                       _
        sec                                     ; B547 38                       8
        bit     $24                             ; B548 24 24                    $$
        asl     $5F1F,x                         ; B54A 1E 1F 5F                 .._
        .byte   $5F                             ; B54D 5F                       _
        sec                                     ; B54E 38                       8
        .byte   $1F                             ; B54F 1F                       .
        .byte   $5F                             ; B550 5F                       _
        .byte   $5F                             ; B551 5F                       _
        asl     $5F1F,x                         ; B552 1E 1F 5F                 .._
        .byte   $5F                             ; B555 5F                       _
        asl     $5F39,x                         ; B556 1E 39 5F                 .9_
        .byte   $03                             ; B559 03                       .
        and     $0B                             ; B55A 25 0B                    %.
        .byte   $5F                             ; B55C 5F                       _
        .byte   $5F                             ; B55D 5F                       _
        sec                                     ; B55E 38                       8
        and     $0909,y                         ; B55F 39 09 09                 9..
        .byte   $80                             ; B562 80                       .
        sta     ($80,x)                         ; B563 81 80                    ..
        sta     ($69,x)                         ; B565 81 69                    .i
        adc     #$7C                            ; B567 69 7C                    i|
        adc     $6969,x                         ; B569 7D 69 69                 }ii
        brk                                     ; B56C 00                       .
        rol     a                               ; B56D 2A                       *
        brk                                     ; B56E 00                       .
        .byte   $22                             ; B56F 22                       "
        adc     #$69                            ; B570 69 69                    ii
        dey                                     ; B572 88                       .
        .byte   $89                             ; B573 89                       .
        brk                                     ; B574 00                       .
        rol     a                               ; B575 2A                       *
        dey                                     ; B576 88                       .
        sta     $6969                           ; B577 8D 69 69                 .ii
        sta     $8889                           ; B57A 8D 89 88                 ...
        .byte   $89                             ; B57D 89                       .
        asl     a                               ; B57E 0A                       .
        .byte   $0B                             ; B57F 0B                       .
        .byte   $02                             ; B580 02                       .
        brk                                     ; B581 00                       .
        asl     a                               ; B582 0A                       .
        and     L0000                           ; B583 25 00                    %.
        sec                                     ; B585 38                       8
        sec                                     ; B586 38                       8
        .byte   $0B                             ; B587 0B                       .
        brk                                     ; B588 00                       .
        .byte   $03                             ; B589 03                       .
        brk                                     ; B58A 00                       .
        .byte   $0B                             ; B58B 0B                       .
        .byte   $7A                             ; B58C 7A                       z
        .byte   $7B                             ; B58D 7B                       {
        .byte   $82                             ; B58E 82                       .
        adc     #$7A                            ; B58F 69 7A                    iz
        .byte   $7B                             ; B591 7B                       {
        adc     #$69                            ; B592 69 69                    ii
        adc     #$69                            ; B594 69 69                    ii
        dey                                     ; B596 88                       .
        sta     $8B8A                           ; B597 8D 8A 8B                 ...
        adc     #$69                            ; B59A 69 69                    ii
        .byte   $8B                             ; B59C 8B                       .
        .byte   $8B                             ; B59D 8B                       .
        adc     #$69                            ; B59E 69 69                    ii
        .byte   $8B                             ; B5A0 8B                       .
        sty     $6969                           ; B5A1 8C 69 69                 .ii
        adc     #$69                            ; B5A4 69 69                    ii
        .byte   $37                             ; B5A6 37                       7
        .byte   $37                             ; B5A7 37                       7
        adc     #$88                            ; B5A8 69 88                    i.
        .byte   $37                             ; B5AA 37                       7
        stx     $3F                             ; B5AB 86 3F                    .?
        .byte   $3F                             ; B5AD 3F                       ?
        dey                                     ; B5AE 88                       .
        .byte   $89                             ; B5AF 89                       .
        .byte   $3F                             ; B5B0 3F                       ?
        stx     $89                             ; B5B1 86 89                    ..
        stx     $69                             ; B5B3 86 69                    .i
        adc     #$8A                            ; B5B5 69 8A                    i.
        .byte   $8B                             ; B5B7 8B                       .
        adc     #$69                            ; B5B8 69 69                    ii
        .byte   $8B                             ; B5BA 8B                       .
        sty     $6969                           ; B5BB 8C 69 69                 .ii
        .byte   $8B                             ; B5BE 8B                       .
        .byte   $8B                             ; B5BF 8B                       .
        bne     LB5C2                           ; B5C0 D0 00                    ..
LB5C2:  iny                                     ; B5C2 C8                       .
        brk                                     ; B5C3 00                       .
        .byte   $2B                             ; B5C4 2B                       +
        brk                                     ; B5C5 00                       .
        .byte   $23                             ; B5C6 23                       #
        brk                                     ; B5C7 00                       .
        asl     a                               ; B5C8 0A                       .
        .byte   $0B                             ; B5C9 0B                       .
        brk                                     ; B5CA 00                       .
        .byte   $17                             ; B5CB 17                       .
        and     $0A5F,y                         ; B5CC 39 5F 0A                 9_.
        and     $175F,y                         ; B5CF 39 5F 17                 9_.
        .byte   $5F                             ; B5D2 5F                       _
        .byte   $17                             ; B5D3 17                       .
        stx     a:$8F                           ; B5D4 8E 8F 00                 ...
        brk                                     ; B5D7 00                       .
        stx     $87                             ; B5D8 86 87                    ..
        stx     $028F                           ; B5DA 8E 8F 02                 ...
        .byte   $03                             ; B5DD 03                       .
        stx     $038F                           ; B5DE 8E 8F 03                 ...
        brk                                     ; B5E1 00                       .
        .byte   $0B                             ; B5E2 0B                       .
        .byte   $5F                             ; B5E3 5F                       _
        brk                                     ; B5E4 00                       .
        brk                                     ; B5E5 00                       .
        .byte   $3A                             ; B5E6 3A                       :
        .byte   $3B                             ; B5E7 3B                       ;
        brk                                     ; B5E8 00                       .
        .byte   $02                             ; B5E9 02                       .
        .byte   $5F                             ; B5EA 5F                       _
        asl     a                               ; B5EB 0A                       .
        .byte   $03                             ; B5EC 03                       .
        .byte   $5F                             ; B5ED 5F                       _
        .byte   $0B                             ; B5EE 0B                       .
        .byte   $5F                             ; B5EF 5F                       _
        .byte   $5F                             ; B5F0 5F                       _
        .byte   $02                             ; B5F1 02                       .
        .byte   $5F                             ; B5F2 5F                       _
        asl     a                               ; B5F3 0A                       .
        .byte   $0B                             ; B5F4 0B                       .
        .byte   $5F                             ; B5F5 5F                       _
        brk                                     ; B5F6 00                       .
        .byte   $5F                             ; B5F7 5F                       _
        brk                                     ; B5F8 00                       .
        brk                                     ; B5F9 00                       .
        brk                                     ; B5FA 00                       .
        brk                                     ; B5FB 00                       .
        brk                                     ; B5FC 00                       .
        brk                                     ; B5FD 00                       .
        brk                                     ; B5FE 00                       .
        brk                                     ; B5FF 00                       .
        brk                                     ; B600 00                       .
        brk                                     ; B601 00                       .
        brk                                     ; B602 00                       .
        ora     ($01,x)                         ; B603 01 01                    ..
        brk                                     ; B605 00                       .
        brk                                     ; B606 00                       .
        brk                                     ; B607 00                       .
        brk                                     ; B608 00                       .
        brk                                     ; B609 00                       .
        brk                                     ; B60A 00                       .
        ora     ($01,x)                         ; B60B 01 01                    ..
        brk                                     ; B60D 00                       .
        brk                                     ; B60E 00                       .
        brk                                     ; B60F 00                       .
        brk                                     ; B610 00                       .
        brk                                     ; B611 00                       .
        brk                                     ; B612 00                       .
        ora     ($01,x)                         ; B613 01 01                    ..
        brk                                     ; B615 00                       .
        brk                                     ; B616 00                       .
        brk                                     ; B617 00                       .
        .byte   $02                             ; B618 02                       .
        .byte   $02                             ; B619 02                       .
        .byte   $02                             ; B61A 02                       .
        .byte   $03                             ; B61B 03                       .
        .byte   $04                             ; B61C 04                       .
        .byte   $02                             ; B61D 02                       .
        .byte   $02                             ; B61E 02                       .
        .byte   $02                             ; B61F 02                       .
        ora     $05                             ; B620 05 05                    ..
        ora     $06                             ; B622 05 06                    ..
        asl     $05                             ; B624 06 05                    ..
        ora     $05                             ; B626 05 05                    ..
        ora     $05                             ; B628 05 05                    ..
        ora     $06                             ; B62A 05 06                    ..
        asl     $05                             ; B62C 06 05                    ..
        ora     $05                             ; B62E 05 05                    ..
        .byte   $07                             ; B630 07                       .
        php                                     ; B631 08                       .
        ora     #$0A                            ; B632 09 0A                    ..
        .byte   $0B                             ; B634 0B                       .
        .byte   $0C                             ; B635 0C                       .
        ora     $0E09                           ; B636 0D 09 0E                 ...
        asl     $100F                           ; B639 0E 0F 10                 ...
        ora     ($12),y                         ; B63C 11 12                    ..
        asl     a:$0F                           ; B63E 0E 0F 00                 ...
        brk                                     ; B641 00                       .
        ora     ($01,x)                         ; B642 01 01                    ..
        ora     ($01,x)                         ; B644 01 01                    ..
        brk                                     ; B646 00                       .
        brk                                     ; B647 00                       .
        brk                                     ; B648 00                       .
        brk                                     ; B649 00                       .
        ora     ($01,x)                         ; B64A 01 01                    ..
        ora     ($01,x)                         ; B64C 01 01                    ..
        brk                                     ; B64E 00                       .
        brk                                     ; B64F 00                       .
        brk                                     ; B650 00                       .
        brk                                     ; B651 00                       .
        ora     ($01,x)                         ; B652 01 01                    ..
        ora     ($01,x)                         ; B654 01 01                    ..
        brk                                     ; B656 00                       .
        brk                                     ; B657 00                       .
        .byte   $02                             ; B658 02                       .
        .byte   $02                             ; B659 02                       .
        .byte   $13                             ; B65A 13                       .
        .byte   $03                             ; B65B 03                       .
        .byte   $04                             ; B65C 04                       .
        .byte   $13                             ; B65D 13                       .
        .byte   $02                             ; B65E 02                       .
        .byte   $02                             ; B65F 02                       .
        ora     $05                             ; B660 05 05                    ..
        asl     $06                             ; B662 06 06                    ..
        asl     $06                             ; B664 06 06                    ..
        ora     $14                             ; B666 05 14                    ..
        ora     $05                             ; B668 05 05                    ..
        asl     $15                             ; B66A 06 15                    ..
        asl     $16,x                           ; B66C 16 16                    ..
        asl     $17,x                           ; B66E 16 17                    ..
        asl     a                               ; B670 0A                       .
        .byte   $0B                             ; B671 0B                       .
        .byte   $0C                             ; B672 0C                       .
        clc                                     ; B673 18                       .
        asl     $0E0E                           ; B674 0E 0E 0E                 ...
        .byte   $17                             ; B677 17                       .
        bpl     LB68B                           ; B678 10 11                    ..
        .byte   $12                             ; B67A 12                       .
        asl     $0E0E                           ; B67B 0E 0E 0E                 ...
        asl     a:$17                           ; B67E 0E 17 00                 ...
        brk                                     ; B681 00                       .
        ora     ($01,x)                         ; B682 01 01                    ..
        ora     $1B1A,y                         ; B684 19 1A 1B                 ...
        .byte   $1C                             ; B687 1C                       .
        brk                                     ; B688 00                       .
        brk                                     ; B689 00                       .
        .byte   $01                             ; B68A 01                       .
LB68B:  ora     ($19,x)                         ; B68B 01 19                    ..
        ora     $1E1B,x                         ; B68D 1D 1B 1E                 ...
        brk                                     ; B690 00                       .
        brk                                     ; B691 00                       .
        ora     ($01,x)                         ; B692 01 01                    ..
        ora     $1B1A,y                         ; B694 19 1A 1B                 ...
        ora     $0202,x                         ; B697 1D 02 02                 ...
        .byte   $13                             ; B69A 13                       .
        .byte   $1F                             ; B69B 1F                       .
        jsr     L2221                           ; B69C 20 21 22                  !"
        .byte   $23                             ; B69F 23                       #
        bit     $25                             ; B6A0 24 25                    $%
        rol     $27                             ; B6A2 26 27                    &'
        asl     $2817                           ; B6A4 0E 17 28                 ..(
        and     #$28                            ; B6A7 29 28                    )(
        and     #$2A                            ; B6A9 29 2A                    )*
        asl     $170E                           ; B6AB 0E 0E 17                 ...
        plp                                     ; B6AE 28                       (
        and     #$28                            ; B6AF 29 28                    )(
        and     #$2A                            ; B6B1 29 2A                    )*
        asl     $170E                           ; B6B3 0E 0E 17                 ...
        plp                                     ; B6B6 28                       (
        and     #$28                            ; B6B7 29 28                    )(
        and     #$2A                            ; B6B9 29 2A                    )*
        asl     $170E                           ; B6BB 0E 0E 17                 ...
        plp                                     ; B6BE 28                       (
        and     #$2B                            ; B6BF 29 2B                    )+
        .byte   $2B                             ; B6C1 2B                       +
        .byte   $2B                             ; B6C2 2B                       +
        .byte   $2B                             ; B6C3 2B                       +
        .byte   $1A                             ; B6C4 1A                       .
        ora     $1A2C,x                         ; B6C5 1D 2C 1A                 .,.
        asl     $1E1E,x                         ; B6C8 1E 1E 1E                 ...
        .byte   $1B                             ; B6CB 1B                       .
        asl     $2C1E,x                         ; B6CC 1E 1E 2C                 ..,
        .byte   $1B                             ; B6CF 1B                       .
        ora     $1A1A,x                         ; B6D0 1D 1A 1A                 ...
        and     $2F2E                           ; B6D3 2D 2E 2F                 -./
        ora     $301A                           ; B6D6 0D 1A 30                 ..0
        and     ($0D),y                         ; B6D9 31 0D                    1.
        clc                                     ; B6DB 18                       .
        asl     $0E0E                           ; B6DC 0E 0E 0E                 ...
        .byte   $1C                             ; B6DF 1C                       .
        rol     a                               ; B6E0 2A                       *
        asl     $0E0E                           ; B6E1 0E 0E 0E                 ...
        asl     $0E0E                           ; B6E4 0E 0E 0E                 ...
        .byte   $1C                             ; B6E7 1C                       .
        rol     a                               ; B6E8 2A                       *
        asl     $0E0E                           ; B6E9 0E 0E 0E                 ...
        asl     $0E0E                           ; B6EC 0E 0E 0E                 ...
        .byte   $1C                             ; B6EF 1C                       .
        rol     a                               ; B6F0 2A                       *
        asl     $0E0E                           ; B6F1 0E 0E 0E                 ...
        asl     $0E0E                           ; B6F4 0E 0E 0E                 ...
        .byte   $1C                             ; B6F7 1C                       .
        rol     a                               ; B6F8 2A                       *
        asl     $0E0E                           ; B6F9 0E 0E 0E                 ...
        asl     $0E0E                           ; B6FC 0E 0E 0E                 ...
        .byte   $1C                             ; B6FF 1C                       .
        asl     $0E0E                           ; B700 0E 0E 0E                 ...
        .byte   $32                             ; B703 32                       2
        .byte   $33                             ; B704 33                       3
        .byte   $34                             ; B705 34                       4
        and     $36,x                           ; B706 35 36                    56
        .byte   $37                             ; B708 37                       7
        sec                                     ; B709 38                       8
        sec                                     ; B70A 38                       8
        and     $1D1A,y                         ; B70B 39 1A 1D                 9..
        .byte   $1A                             ; B70E 1A                       .
        .byte   $1B                             ; B70F 1B                       .
        .byte   $3A                             ; B710 3A                       :
        asl     $1E1B,x                         ; B711 1E 1B 1E                 ...
        asl     $1E1E,x                         ; B714 1E 1E 1E                 ...
        .byte   $1B                             ; B717 1B                       .
        .byte   $3A                             ; B718 3A                       :
        .byte   $1B                             ; B719 1B                       .
        .byte   $1A                             ; B71A 1A                       .
        and     $2E2E                           ; B71B 2D 2E 2E                 -..
        rol     $3B2E                           ; B71E 2E 2E 3B                 ..;
        .byte   $3C                             ; B721 3C                       <
        sec                                     ; B722 38                       8
        and     $2B2B,x                         ; B723 3D 2B 2B                 =++
        asl     $0E0E                           ; B726 0E 0E 0E                 ...
        bit     $1D1A                           ; B729 2C 1A 1D                 ,..
        .byte   $1A                             ; B72C 1A                       .
        ora     $0E2B,x                         ; B72D 1D 2B 0E                 .+.
        asl     $0D0D                           ; B730 0E 0D 0D                 ...
        rol     $2E2E,x                         ; B733 3E 2E 2E                 >..
        .byte   $3F                             ; B736 3F                       ?
        asl     $0E0E                           ; B737 0E 0E 0E                 ...
        asl     $0E0E                           ; B73A 0E 0E 0E                 ...
        asl     $0E40                           ; B73D 0E 40 0E                 .@.
        eor     ($33,x)                         ; B740 41 33                    A3
        .byte   $42                             ; B742 42                       B
        asl     $430E                           ; B743 0E 0E 43                 ..C
        asl     $1D0E                           ; B746 0E 0E 1D                 ...
        .byte   $1C                             ; B749 1C                       .
        .byte   $44                             ; B74A 44                       D
        asl     $4645                           ; B74B 0E 45 46                 .EF
        asl     $1E0E,x                         ; B74E 1E 0E 1E                 ...
        .byte   $1B                             ; B751 1B                       .
        .byte   $47                             ; B752 47                       G
        asl     $461B                           ; B753 0E 1B 46                 ..F
        .byte   $1B                             ; B756 1B                       .
        asl     $1A48                           ; B757 0E 48 1A                 .H.
        eor     #$4A                            ; B75A 49 4A                    IJ
        .byte   $4B                             ; B75C 4B                       K
        .byte   $1C                             ; B75D 1C                       .
        asl     $4C0E,x                         ; B75E 1E 0E 4C                 ..L
        eor     $1D1A                           ; B761 4D 1A 1D                 M..
        asl     $4E1D,x                         ; B764 1E 1D 4E                 ..N
        asl     $4F0E                           ; B767 0E 0E 4F                 ..O
        .byte   $1A                             ; B76A 1A                       .
        .byte   $1A                             ; B76B 1A                       .
        .byte   $1B                             ; B76C 1B                       .
        .byte   $1A                             ; B76D 1A                       .
        bvc     LB77E                           ; B76E 50 0E                    P.
        .byte   $0E                             ; B770 0E                       .
        .byte   $51                             ; B771 51                       Q
LB772:  ora     $3E0D                           ; B772 0D 0D 3E                 ..>
        rol     $522E                           ; B775 2E 2E 52                 ..R
        asl     $0E0E                           ; B778 0E 0E 0E                 ...
        asl     $0E0E                           ; B77B 0E 0E 0E                 ...
LB77E:  asl     $0E0E                           ; B77E 0E 0E 0E                 ...
        asl     $2817                           ; B781 0E 17 28                 ..(
        and     #$2A                            ; B784 29 2A                    )*
        .byte   $17                             ; B786 17                       .
        plp                                     ; B787 28                       (
        asl     $170E                           ; B788 0E 0E 17                 ...
        plp                                     ; B78B 28                       (
        and     #$2A                            ; B78C 29 2A                    )*
        .byte   $17                             ; B78E 17                       .
        plp                                     ; B78F 28                       (
        asl     $340E                           ; B790 0E 0E 34                 ..4
        and     $36,x                           ; B793 35 36                    56
        eor     ($17,x)                         ; B795 41 17                    A.
        plp                                     ; B797 28                       (
        asl     $1D0E                           ; B798 0E 0E 1D                 ...
        .byte   $1A                             ; B79B 1A                       .
        ora     $171B,x                         ; B79C 1D 1B 17                 ...
        plp                                     ; B79F 28                       (
        asl     $1A0E                           ; B7A0 0E 0E 1A                 ...
        .byte   $1C                             ; B7A3 1C                       .
        .byte   $1A                             ; B7A4 1A                       .
        .byte   $1B                             ; B7A5 1B                       .
        .byte   $17                             ; B7A6 17                       .
        plp                                     ; B7A7 28                       (
        asl     $1D1A                           ; B7A8 0E 1A 1D                 ...
        .byte   $1A                             ; B7AB 1A                       .
        .byte   $1A                             ; B7AC 1A                       .
        .byte   $1B                             ; B7AD 1B                       .
        .byte   $17                             ; B7AE 17                       .
        plp                                     ; B7AF 28                       (
        .byte   $53                             ; B7B0 53                       S
        and     ($22,x)                         ; B7B1 21 22                    !"
        .byte   $23                             ; B7B3 23                       #
        bmi     LB7E4                           ; B7B4 30 2E                    0.
        .byte   $17                             ; B7B6 17                       .
        plp                                     ; B7B7 28                       (
        asl     $2817                           ; B7B8 0E 17 28                 ..(
        and     #$2A                            ; B7BB 29 2A                    )*
        asl     $2817                           ; B7BD 0E 17 28                 ..(
        .byte   $12                             ; B7C0 12                       .
        asl     $3332                           ; B7C1 0E 32 33                 .23
        .byte   $33                             ; B7C4 33                       3
        .byte   $0F                             ; B7C5 0F                       .
        bpl     LB7D9                           ; B7C6 10 11                    ..
        .byte   $12                             ; B7C8 12                       .
        sec                                     ; B7C9 38                       8
        and     $1A1E,y                         ; B7CA 39 1E 1A                 9..
        .byte   $54                             ; B7CD 54                       T
        eor     $56,x                           ; B7CE 55 56                    UV
        .byte   $12                             ; B7D0 12                       .
        asl     $1B1E,x                         ; B7D1 1E 1E 1B                 ...
        asl     $1E1E,x                         ; B7D4 1E 1E 1E                 ...
        .byte   $1E                             ; B7D7 1E                       .
        .byte   $12                             ; B7D8 12                       .
LB7D9:  .byte   $1B                             ; B7D9 1B                       .
        .byte   $57                             ; B7DA 57                       W
        .byte   $1B                             ; B7DB 1B                       .
        .byte   $1A                             ; B7DC 1A                       .
        and     $1A48                           ; B7DD 2D 48 1A                 -H.
        .byte   $12                             ; B7E0 12                       .
        asl     $2E58,x                         ; B7E1 1E 58 2E                 .X.
LB7E4:  and     ($18),y                         ; B7E4 31 18                    1.
        eor     $121B,y                         ; B7E6 59 1B 12                 Y..
        .byte   $5A                             ; B7E9 5A                       Z
        ora     $1A1B,x                         ; B7EA 1D 1B 1A                 ...
        .byte   $5B                             ; B7ED 5B                       [
        .byte   $5C                             ; B7EE 5C                       \
        ora     $5112                           ; B7EF 0D 12 51                 ..Q
        ora     $5D0D                           ; B7F2 0D 0D 5D                 ..]
        lsr     $0E0E,x                         ; B7F5 5E 0E 0E                 ^..
        .byte   $12                             ; B7F8 12                       .
        asl     $0E0E                           ; B7F9 0E 0E 0E                 ...
        asl     $0E43                           ; B7FC 0E 43 0E                 .C.
        asl     $0E12                           ; B7FF 0E 12 0E                 ...
        asl     $0E5F                           ; B802 0E 5F 0E                 ._.
        .byte   $5F                             ; B805 5F                       _
        asl     $600E                           ; B806 0E 0E 60                 ..`
        sec                                     ; B809 38                       8
        adc     ($5F,x)                         ; B80A 61 5F                    a_
        .byte   $0E                             ; B80C 0E                       .
        .byte   $5F                             ; B80D 5F                       _
LB80E:  .byte   $33                             ; B80E 33                       3
        .byte   $33                             ; B80F 33                       3
        asl     $1E1E,x                         ; B810 1E 1E 1E                 ...
        .byte   $62                             ; B813 62                       b
        .byte   $63                             ; B814 63                       c
        .byte   $62                             ; B815 62                       b
        ora     $1D1C,x                         ; B816 1D 1C 1D                 ...
        .byte   $1A                             ; B819 1A                       .
        .byte   $1A                             ; B81A 1A                       .
        .byte   $1C                             ; B81B 1C                       .
        .byte   $1B                             ; B81C 1B                       .
        .byte   $1C                             ; B81D 1C                       .
        .byte   $1A                             ; B81E 1A                       .
        .byte   $1A                             ; B81F 1A                       .
        asl     $1E1E,x                         ; B820 1E 1E 1E                 ...
        asl     $1E1B,x                         ; B823 1E 1B 1E                 ...
        .byte   $1B                             ; B826 1B                       .
        asl     $3E0D,x                         ; B827 1E 0D 3E                 ..>
        pha                                     ; B82A 48                       H
LB82B:  .byte   $1C                             ; B82B 1C                       .
        asl     $1A1D,x                         ; B82C 1E 1D 1A                 ...
        ora     $0E0E,x                         ; B82F 1D 0E 0E                 ...
        .byte   $5C                             ; B832 5C                       \
        rol     $2E2E,x                         ; B833 3E 2E 2E                 >..
        and     ($0D),y                         ; B836 31 0D                    1.
        asl     $0E0E                           ; B838 0E 0E 0E                 ...
        asl     $0E0E                           ; B83B 0E 0E 0E                 ...
        asl     $5F0E                           ; B83E 0E 0E 5F                 .._
        asl     $335F                           ; B841 0E 5F 33                 ._3
        .byte   $33                             ; B844 33                       3
        .byte   $34                             ; B845 34                       4
        and     $36,x                           ; B846 35 36                    56
        .byte   $62                             ; B848 62                       b
        sec                                     ; B849 38                       8
        .byte   $62                             ; B84A 62                       b
        asl     $1E1B,x                         ; B84B 1E 1B 1E                 ...
        .byte   $1B                             ; B84E 1B                       .
        asl     $1E1A,x                         ; B84F 1E 1A 1E                 ...
        ora     $1A1A,x                         ; B852 1D 1A 1A                 ...
        ora     $1A1A,x                         ; B855 1D 1A 1A                 ...
        .byte   $1A                             ; B858 1A                       .
        asl     $1A1A,x                         ; B859 1E 1A 1A                 ...
        ora     $1D64,x                         ; B85C 1D 64 1D                 .d.
        .byte   $1A                             ; B85F 1A                       .
        asl     $1E1B,x                         ; B860 1E 1B 1E                 ...
        ora     $0D,x                           ; B863 15 0D                    ..
        .byte   $5F                             ; B865 5F                       _
        rol     $1A2E,x                         ; B866 3E 2E 1A                 >..
        and     $1831                           ; B869 2D 31 18                 -1.
        asl     $0E5F                           ; B86C 0E 5F 0E                 ._.
        asl     $180D                           ; B86F 0E 0D 18                 ...
        asl     $0E0E                           ; B872 0E 0E 0E                 ...
        .byte   $5F                             ; B875 5F                       _
        asl     $0E0E                           ; B876 0E 0E 0E                 ...
        asl     $0E0E                           ; B879 0E 0E 0E                 ...
        asl     $0E5F                           ; B87C 0E 5F 0E                 ._.
        asl     $3341                           ; B87F 0E 41 33                 .A3
        .byte   $42                             ; B882 42                       B
        asl     $650E                           ; B883 0E 0E 65                 ..e
        .byte   $17                             ; B886 17                       .
        plp                                     ; B887 28                       (
        .byte   $1B                             ; B888 1B                       .
        asl     $0E66,x                         ; B889 1E 66 0E                 .f.
        asl     $1765                           ; B88C 0E 65 17                 .e.
        plp                                     ; B88F 28                       (
        .byte   $1A                             ; B890 1A                       .
        ora     $6867,x                         ; B891 1D 67 68                 .gh
        sec                                     ; B894 38                       8
        adc     #$17                            ; B895 69 17                    i.
        plp                                     ; B897 28                       (
        .byte   $1A                             ; B898 1A                       .
        .byte   $1A                             ; B899 1A                       .
        asl     $1A1E,x                         ; B89A 1E 1E 1A                 ...
        lsr     $17                             ; B89D 46 17                    F.
        plp                                     ; B89F 28                       (
        pha                                     ; B8A0 48                       H
        .byte   $1A                             ; B8A1 1A                       .
        asl     $1D1B,x                         ; B8A2 1E 1B 1D                 ...
        lsr     $17                             ; B8A5 46 17                    F.
        plp                                     ; B8A7 28                       (
        eor     $1B1E,y                         ; B8A8 59 1E 1B                 Y..
        .byte   $1B                             ; B8AB 1B                       .
        asl     $1746,x                         ; B8AC 1E 46 17                 .F.
        plp                                     ; B8AF 28                       (
        .byte   $5C                             ; B8B0 5C                       \
        .byte   $64                             ; B8B1 64                       d
        asl     $2E2E,x                         ; B8B2 1E 2E 2E                 ...
        ror     a                               ; B8B5 6A                       j
        .byte   $17                             ; B8B6 17                       .
        plp                                     ; B8B7 28                       (
        asl     $1C5F                           ; B8B8 0E 5F 1C                 ._.
        asl     $0E0E                           ; B8BB 0E 0E 0E                 ...
        .byte   $17                             ; B8BE 17                       .
        plp                                     ; B8BF 28                       (
        .byte   $12                             ; B8C0 12                       .
        asl     $0E0E                           ; B8C1 0E 0E 0E                 ...
        asl     $100F                           ; B8C4 0E 0F 10                 ...
        ora     ($12),y                         ; B8C7 11 12                    ..
        .byte   $2B                             ; B8C9 2B                       +
        .byte   $2B                             ; B8CA 2B                       +
        asl     $540E                           ; B8CB 0E 0E 54                 ..T
        .byte   $6B                             ; B8CE 6B                       k
        lsr     $12,x                           ; B8CF 56 12                    V.
        .byte   $1B                             ; B8D1 1B                       .
        .byte   $1A                             ; B8D2 1A                       .
        ora     $1A1D,x                         ; B8D3 1D 1D 1A                 ...
        ora     $121A,x                         ; B8D6 1D 1A 12                 ...
        jmp     (L6C57)                         ; B8D9 6C 57 6C                 lWl

; ----------------------------------------------------------------------------
        jmp     (L6C6C)                         ; B8DC 6C 6C 6C                 lll

; ----------------------------------------------------------------------------
        jmp     (L1B12)                         ; B8DF 6C 12 1B                 l..

; ----------------------------------------------------------------------------
        adc     $6F6E                           ; B8E2 6D 6E 6F                 mno
        php                                     ; B8E5 08                       .
        bvs     LB905                           ; B8E6 70 1D                    p.
        .byte   $12                             ; B8E8 12                       .
        adc     ($1D),y                         ; B8E9 71 1D                    q.
        .byte   $1A                             ; B8EB 1A                       .
        .byte   $1A                             ; B8EC 1A                       .
        ora     $0A09,x                         ; B8ED 1D 09 0A                 ...
        .byte   $12                             ; B8F0 12                       .
        .byte   $72                             ; B8F1 72                       r
        .byte   $73                             ; B8F2 73                       s
        .byte   $74                             ; B8F3 74                       t
        rol     $0F75                           ; B8F4 2E 75 0F                 .u.
        bpl     LB90B                           ; B8F7 10 12                    ..
        asl     $0E0E                           ; B8F9 0E 0E 0E                 ...
        asl     $0F76                           ; B8FC 0E 76 0F                 .v.
        bpl     LB913                           ; B8FF 10 12                    ..
        asl     $0E0E                           ; B901 0E 0E 0E                 ...
        .byte   $0E                             ; B904 0E                       .
LB905:  asl     $0E0E                           ; B905 0E 0E 0E                 ...
        rts                                     ; B908 60                       `

; ----------------------------------------------------------------------------
        .byte   $0E                             ; B909 0E                       .
        .byte   $0E                             ; B90A 0E                       .
LB90B:  asl     $0E0E                           ; B90B 0E 0E 0E                 ...
        asl     $1D0E                           ; B90E 0E 0E 1D                 ...
        .byte   $0E                             ; B911 0E                       .
        .byte   $0E                             ; B912 0E                       .
LB913:  .byte   $77                             ; B913 77                       w
        .byte   $77                             ; B914 77                       w
        asl     $1C0E                           ; B915 0E 0E 1C                 ...
        jmp     (L6C6C)                         ; B918 6C 6C 6C                 lll

; ----------------------------------------------------------------------------
        .byte   $1B                             ; B91B 1B                       .
        .byte   $1B                             ; B91C 1B                       .
        jmp     (L6C6C)                         ; B91D 6C 6C 6C                 lll

; ----------------------------------------------------------------------------
        .byte   $1A                             ; B920 1A                       .
        .byte   $1A                             ; B921 1A                       .
        .byte   $1A                             ; B922 1A                       .
        .byte   $1B                             ; B923 1B                       .
        .byte   $1B                             ; B924 1B                       .
        .byte   $1A                             ; B925 1A                       .
        ora     $0B1A,x                         ; B926 1D 1A 0B                 ...
        .byte   $0C                             ; B929 0C                       .
        ora     $1B1B,x                         ; B92A 1D 1B 1B                 ...
        .byte   $1A                             ; B92D 1A                       .
        .byte   $1A                             ; B92E 1A                       .
        sei                                     ; B92F 78                       x
        ora     ($12),y                         ; B930 11 12                    ..
        .byte   $6F                             ; B932 6F                       o
        php                                     ; B933 08                       .
        sei                                     ; B934 78                       x
        adc     $0E7A,y                         ; B935 79 7A 0E                 yz.
        ora     ($12),y                         ; B938 11 12                    ..
        asl     $0E0E                           ; B93A 0E 0E 0E                 ...
        asl     $0E0E                           ; B93D 0E 0E 0E                 ...
        .byte   $34                             ; B940 34                       4
        and     $36,x                           ; B941 35 36                    56
        eor     ($34,x)                         ; B943 41 34                    A4
        and     $36,x                           ; B945 35 36                    56
        eor     ($1C,x)                         ; B947 41 1C                    A.
        .byte   $1A                             ; B949 1A                       .
        ora     $1A1E,x                         ; B94A 1D 1E 1A                 ...
        .byte   $1A                             ; B94D 1A                       .
        ora     $1A1A,x                         ; B94E 1D 1A 1A                 ...
        ora     $1B1A,x                         ; B951 1D 1A 1B                 ...
        .byte   $1A                             ; B954 1A                       .
        ora     $1A1A,x                         ; B955 1D 1A 1A                 ...
        jmp     (L6C6C)                         ; B958 6C 6C 6C                 lll

; ----------------------------------------------------------------------------
        asl     $1E1E,x                         ; B95B 1E 1E 1E                 ...
        .byte   $1B                             ; B95E 1B                       .
        asl     $1A1D,x                         ; B95F 1E 1D 1A                 ...
        ora     $1A1B,x                         ; B962 1D 1B 1A                 ...
        ora     $1D1A,x                         ; B965 1D 1A 1D                 ...
        adc     $6F7A,y                         ; B968 79 7A 6F                 yzo
        php                                     ; B96B 08                       .
        ora     $7B1C,x                         ; B96C 1D 1C 7B                 ..{
        sei                                     ; B96F 78                       x
        asl     $0E0E                           ; B970 0E 0E 0E                 ...
        asl     $7B1A,x                         ; B973 1E 1A 7B                 ..{
        asl     $0E0E                           ; B976 0E 0E 0E                 ...
        asl     $6F0E                           ; B979 0E 0E 6F                 ..o
        php                                     ; B97C 08                       .
        asl     $0E0E                           ; B97D 0E 0E 0E                 ...
        asl     $0E0E                           ; B980 0E 0E 0E                 ...
        asl     $0E0E                           ; B983 0E 0E 0E                 ...
        bit     $1D0E                           ; B986 2C 0E 1D                 ,..
        .byte   $2B                             ; B989 2B                       +
        .byte   $2B                             ; B98A 2B                       +
        .byte   $2B                             ; B98B 2B                       +
        .byte   $1C                             ; B98C 1C                       .
        asl     $0E2C,x                         ; B98D 1E 2C 0E                 .,.
        .byte   $1A                             ; B990 1A                       .
        ora     $1D1A,x                         ; B991 1D 1A 1D                 ...
        .byte   $1A                             ; B994 1A                       .
        .byte   $1B                             ; B995 1B                       .
        .byte   $7C                             ; B996 7C                       |
        asl     $1E1E                           ; B997 0E 1E 1E                 ...
        .byte   $1B                             ; B99A 1B                       .
        asl     $1E1E,x                         ; B99B 1E 1E 1E                 ...
        adc     $1A0E,x                         ; B99E 7D 0E 1A                 }..
        .byte   $1C                             ; B9A1 1C                       .
        .byte   $1A                             ; B9A2 1A                       .
        .byte   $1A                             ; B9A3 1A                       .
        .byte   $1A                             ; B9A4 1A                       .
        .byte   $1B                             ; B9A5 1B                       .
        adc     $790E,x                         ; B9A6 7D 0E 79                 }.y
        .byte   $7A                             ; B9A9 7A                       z
        ora     #$0A                            ; B9AA 09 0A                    ..
        .byte   $0B                             ; B9AC 0B                       .
        .byte   $0C                             ; B9AD 0C                       .
        ror     $0E0E,x                         ; B9AE 7E 0E 0E                 ~..
        asl     $100F                           ; B9B1 0E 0F 10                 ...
        ora     ($12),y                         ; B9B4 11 12                    ..
        asl     $0E0E                           ; B9B6 0E 0E 0E                 ...
        asl     $100F                           ; B9B9 0E 0F 10                 ...
        ora     ($12),y                         ; B9BC 11 12                    ..
        asl     $0E0E                           ; B9BE 0E 0E 0E                 ...
        ora     $1A2C,x                         ; B9C1 1D 2C 1A                 .,.
        asl     $0E0E                           ; B9C4 0E 0E 0E                 ...
        asl     $7B0E                           ; B9C7 0E 0E 7B                 ..{
        bit     $1A1D                           ; B9CA 2C 1D 1A                 ,..
        .byte   $1A                             ; B9CD 1A                       .
        asl     $0E0E                           ; B9CE 0E 0E 0E                 ...
        asl     $707B                           ; B9D1 0E 7B 70                 .{p
        .byte   $1A                             ; B9D4 1A                       .
        .byte   $1A                             ; B9D5 1A                       .
        .byte   $1C                             ; B9D6 1C                       .
        .byte   $7F                             ; B9D7 7F                       .
        asl     $0E0E                           ; B9D8 0E 0E 0E                 ...
        asl     $707B                           ; B9DB 0E 7B 70                 .{p
        .byte   $1A                             ; B9DE 1A                       .
        .byte   $7F                             ; B9DF 7F                       .
        .byte   $80                             ; B9E0 80                       .
        ora     $2B1A,x                         ; B9E1 1D 1A 2B                 ..+
        .byte   $1A                             ; B9E4 1A                       .
        .byte   $1A                             ; B9E5 1A                       .
        .byte   $1C                             ; B9E6 1C                       .
        sta     ($80,x)                         ; B9E7 81 80                    ..
        .byte   $1A                             ; B9E9 1A                       .
        sei                                     ; B9EA 78                       x
        adc     $7979,y                         ; B9EB 79 79 79                 yyy
        .byte   $82                             ; B9EE 82                       .
        asl     $1A83                           ; B9EF 0E 83 1A                 ...
        .byte   $1A                             ; B9F2 1A                       .
        .byte   $1C                             ; B9F3 1C                       .
        .byte   $1A                             ; B9F4 1A                       .
        .byte   $1A                             ; B9F5 1A                       .
        ora     $720E,x                         ; B9F6 1D 0E 72                 ..r
        .byte   $07                             ; B9F9 07                       .
        .byte   $07                             ; B9FA 07                       .
        .byte   $07                             ; B9FB 07                       .
        .byte   $07                             ; B9FC 07                       .
        .byte   $07                             ; B9FD 07                       .
        sty     $0E                             ; B9FE 84 0E                    ..
        asl     $0E0E                           ; BA00 0E 0E 0E                 ...
        asl     $0E0E                           ; BA03 0E 0E 0E                 ...
        asl     $0E0E                           ; BA06 0E 0E 0E                 ...
        .byte   $2B                             ; BA09 2B                       +
        .byte   $2B                             ; BA0A 2B                       +
        .byte   $2B                             ; BA0B 2B                       +
        .byte   $2B                             ; BA0C 2B                       +
        .byte   $2B                             ; BA0D 2B                       +
        .byte   $2B                             ; BA0E 2B                       +
        asl     $1A0E                           ; BA0F 0E 0E 1A                 ...
        ora     $1A1A,x                         ; BA12 1D 1A 1A                 ...
        ora     $0E1A,x                         ; BA15 1D 1A 0E                 ...
        asl     $1A1D                           ; BA18 0E 1D 1A                 ...
        .byte   $1C                             ; BA1B 1C                       .
        .byte   $1A                             ; BA1C 1A                       .
        .byte   $1A                             ; BA1D 1A                       .
        ora     $790E,x                         ; BA1E 1D 0E 79                 ..y
        .byte   $7A                             ; BA21 7A                       z
        .byte   $1A                             ; BA22 1A                       .
        .byte   $1A                             ; BA23 1A                       .
        ora     $1A1A,x                         ; BA24 1D 1A 1A                 ...
        asl     $0E0E                           ; BA27 0E 0E 0E                 ...
        .byte   $7B                             ; BA2A 7B                       {
        sta     $1A                             ; BA2B 85 1A                    ..
        sta     $86                             ; BA2D 85 86                    ..
        asl     $0E0E                           ; BA2F 0E 0E 0E                 ...
        asl     $1C87                           ; BA32 0E 87 1C                 ...
        .byte   $87                             ; BA35 87                       .
        dey                                     ; BA36 88                       .
        asl     $0E0E                           ; BA37 0E 0E 0E                 ...
        asl     $1C87                           ; BA3A 0E 87 1C                 ...
        .byte   $87                             ; BA3D 87                       .
        dey                                     ; BA3E 88                       .
        asl     $0E0E                           ; BA3F 0E 0E 0E                 ...
        .byte   $89                             ; BA42 89                       .
        ora     ($01,x)                         ; BA43 01 01                    ..
        ora     ($01,x)                         ; BA45 01 01                    ..
        ora     ($0E,x)                         ; BA47 01 0E                    ..
        asl     $0189                           ; BA49 0E 89 01                 ...
        ora     ($01,x)                         ; BA4C 01 01                    ..
        ora     ($01,x)                         ; BA4E 01 01                    ..
        asl     $891C                           ; BA50 0E 1C 89                 ...
        ora     ($01,x)                         ; BA53 01 01                    ..
        ora     ($01,x)                         ; BA55 01 01                    ..
        ora     ($0E,x)                         ; BA57 01 0E                    ..
        .byte   $1C                             ; BA59 1C                       .
        .byte   $89                             ; BA5A 89                       .
        ora     ($01,x)                         ; BA5B 01 01                    ..
        ora     ($8A,x)                         ; BA5D 01 8A                    ..
        ora     ($0E,x)                         ; BA5F 01 0E                    ..
        .byte   $1C                             ; BA61 1C                       .
        .byte   $89                             ; BA62 89                       .
        txa                                     ; BA63 8A                       .
        .byte   $8B                             ; BA64 8B                       .
        sty     $018D                           ; BA65 8C 8D 01                 ...
        asl     $891C                           ; BA68 0E 1C 89                 ...
        stx     $908F                           ; BA6B 8E 8F 90                 ...
        sta     ($92),y                         ; BA6E 91 92                    ..
        asl     $931C                           ; BA70 0E 1C 93                 ...
        sty     $6F,x                           ; BA73 94 6F                    .o
        php                                     ; BA75 08                       .
        asl     $0E0E                           ; BA76 0E 0E 0E                 ...
        .byte   $1C                             ; BA79 1C                       .
        adc     $0E0E,x                         ; BA7A 7D 0E 0E                 }..
        asl     $0E0E                           ; BA7D 0E 0E 0E                 ...
        ora     ($01,x)                         ; BA80 01 01                    ..
        ora     ($01,x)                         ; BA82 01 01                    ..
        ora     ($01,x)                         ; BA84 01 01                    ..
        ora     ($01,x)                         ; BA86 01 01                    ..
        ora     ($01,x)                         ; BA88 01 01                    ..
        ora     ($01,x)                         ; BA8A 01 01                    ..
        ora     ($01,x)                         ; BA8C 01 01                    ..
LBA8E:  ora     ($01,x)                         ; BA8E 01 01                    ..
        ora     ($01,x)                         ; BA90 01 01                    ..
        ora     ($01,x)                         ; BA92 01 01                    ..
        ora     ($01,x)                         ; BA94 01 01                    ..
        txa                                     ; BA96 8A                       .
        ora     ($01,x)                         ; BA97 01 01                    ..
        ora     ($95,x)                         ; BA99 01 95                    ..
        ora     ($8A,x)                         ; BA9B 01 8A                    ..
        ora     ($01,x)                         ; BA9D 01 01                    ..
        ora     ($8A,x)                         ; BA9F 01 8A                    ..
        stx     $97,y                           ; BAA1 96 97                    ..
        tya                                     ; BAA3 98                       .
        ora     ($8B,x)                         ; BAA4 01 8B                    ..
        sty     $998D                           ; BAA6 8C 8D 99                 ...
        txs                                     ; BAA9 9A                       .
        .byte   $9B                             ; BAAA 9B                       .
        .byte   $9C                             ; BAAB 9C                       .
        sta     $908F,x                         ; BAAC 9D 8F 90                 ...
        .byte   $9E                             ; BAAF 9E                       .
        asl     $9F0E                           ; BAB0 0E 0E 9F                 ...
        .byte   $9F                             ; BAB3 9F                       .
        ldy     #$A1                            ; BAB4 A0 A1                    ..
        asl     $9B                             ; BAB6 06 9B                    ..
        asl     $9F0E                           ; BAB8 0E 0E 9F                 ...
        .byte   $9F                             ; BABB 9F                       .
        ldy     #$A1                            ; BABC A0 A1                    ..
        asl     $9F                             ; BABE 06 9F                    ..
        ora     ($01,x)                         ; BAC0 01 01                    ..
        ora     ($01,x)                         ; BAC2 01 01                    ..
        ora     ($01,x)                         ; BAC4 01 01                    ..
        ora     ($01,x)                         ; BAC6 01 01                    ..
        ora     ($01,x)                         ; BAC8 01 01                    ..
        ora     ($01,x)                         ; BACA 01 01                    ..
        ora     ($01,x)                         ; BACC 01 01                    ..
        ora     ($01,x)                         ; BACE 01 01                    ..
        ora     ($01,x)                         ; BAD0 01 01                    ..
        ora     ($01,x)                         ; BAD2 01 01                    ..
        ora     ($8A,x)                         ; BAD4 01 8A                    ..
LBAD6:  ora     ($01,x)                         ; BAD6 01 01                    ..
        ora     ($8A,x)                         ; BAD8 01 8A                    ..
        sta     $01,x                           ; BADA 95 01                    ..
        ora     ($01,x)                         ; BADC 01 01                    ..
        ora     ($01,x)                         ; BADE 01 01                    ..
        txa                                     ; BAE0 8A                       .
        stx     $97,y                           ; BAE1 96 97                    ..
        tya                                     ; BAE3 98                       .
        ora     ($8B,x)                         ; BAE4 01 8B                    ..
        sty     $988D                           ; BAE6 8C 8D 98                 ...
        ldx     #$A3                            ; BAE9 A2 A3                    ..
        ldy     $9D                             ; BAEB A4 9D                    ..
        .byte   $8F                             ; BAED 8F                       .
        bcc     LBA8E                           ; BAEE 90 9E                    ..
        .byte   $9C                             ; BAF0 9C                       .
        .byte   $9F                             ; BAF1 9F                       .
        .byte   $A3                             ; BAF2 A3                       .
        .byte   $9B                             ; BAF3 9B                       .
        .byte   $9C                             ; BAF4 9C                       .
        lda     $A6                             ; BAF5 A5 A6                    ..
        .byte   $9B                             ; BAF7 9B                       .
        .byte   $9F                             ; BAF8 9F                       .
        .byte   $9F                             ; BAF9 9F                       .
        .byte   $A3                             ; BAFA A3                       .
        .byte   $9F                             ; BAFB 9F                       .
        .byte   $9F                             ; BAFC 9F                       .
        .byte   $9F                             ; BAFD 9F                       .
        .byte   $9F                             ; BAFE 9F                       .
        .byte   $9F                             ; BAFF 9F                       .
        ora     ($01,x)                         ; BB00 01 01                    ..
        ora     ($01,x)                         ; BB02 01 01                    ..
        ora     ($01,x)                         ; BB04 01 01                    ..
        ora     ($01,x)                         ; BB06 01 01                    ..
        ora     ($01,x)                         ; BB08 01 01                    ..
        ora     ($01,x)                         ; BB0A 01 01                    ..
        ora     ($01,x)                         ; BB0C 01 01                    ..
        ora     ($01,x)                         ; BB0E 01 01                    ..
        ora     ($01,x)                         ; BB10 01 01                    ..
        ora     ($01,x)                         ; BB12 01 01                    ..
        txa                                     ; BB14 8A                       .
        ora     ($01,x)                         ; BB15 01 01                    ..
        ora     ($8A,x)                         ; BB17 01 8A                    ..
        ora     ($01,x)                         ; BB19 01 01                    ..
        sta     $01,x                           ; BB1B 95 01                    ..
        .byte   $A7                             ; BB1D A7                       .
        ora     ($01,x)                         ; BB1E 01 01                    ..
        ora     ($8A,x)                         ; BB20 01 8A                    ..
        stx     $97,y                           ; BB22 96 97                    ..
        tay                                     ; BB24 A8                       .
        lda     #$AA                            ; BB25 A9 AA                    ..
        txa                                     ; BB27 8A                       .
        tya                                     ; BB28 98                       .
        ldx     #$AB                            ; BB29 A2 AB                    ..
        ldy     LAEAD                           ; BB2B AC AD AE                 ...
        .byte   $9B                             ; BB2E 9B                       .
        .byte   $AF                             ; BB2F AF                       .
        .byte   $9C                             ; BB30 9C                       .
        .byte   $9F                             ; BB31 9F                       .
        ldy     #$9F                            ; BB32 A0 9F                    ..
        .byte   $9F                             ; BB34 9F                       .
        bcs     LBAD6                           ; BB35 B0 9F                    ..
        .byte   $9F                             ; BB37 9F                       .
        .byte   $9F                             ; BB38 9F                       .
        .byte   $9F                             ; BB39 9F                       .
        ldy     #$9F                            ; BB3A A0 9F                    ..
        .byte   $9F                             ; BB3C 9F                       .
        .byte   $9F                             ; BB3D 9F                       .
        .byte   $9F                             ; BB3E 9F                       .
        .byte   $9F                             ; BB3F 9F                       .
        ora     $0E0E,y                         ; BB40 19 0E 0E                 ...
        asl     $0E0E                           ; BB43 0E 0E 0E                 ...
        .byte   $43                             ; BB46 43                       C
        asl     $1A19                           ; BB47 0E 19 1A                 ...
        .byte   $1C                             ; BB4A 1C                       .
        .byte   $1A                             ; BB4B 1A                       .
        ora     $461A,x                         ; BB4C 1D 1A 46                 ..F
        asl     $1D19                           ; BB4F 0E 19 1D                 ...
        .byte   $1A                             ; BB52 1A                       .
        .byte   $1A                             ; BB53 1A                       .
        .byte   $1A                             ; BB54 1A                       .
        ora     $0E46,x                         ; BB55 1D 46 0E                 .F.
        ora     $1D1A,y                         ; BB58 19 1A 1D                 ...
        .byte   $1A                             ; BB5B 1A                       .
        ora     $461A,x                         ; BB5C 1D 1A 46                 ..F
        asl     $7819                           ; BB5F 0E 19 78                 ..x
        adc     $7979,y                         ; BB62 79 79 79                 yyy
        adc     $0EB1,y                         ; BB65 79 B1 0E                 y..
        .byte   $9C                             ; BB68 9C                       .
        asl     $0E0E                           ; BB69 0E 0E 0E                 ...
        asl     $0E0E                           ; BB6C 0E 0E 0E                 ...
        asl     $0E9F                           ; BB6F 0E 9F 0E                 ...
        asl     $0E0E                           ; BB72 0E 0E 0E                 ...
        asl     $0E0E                           ; BB75 0E 0E 0E                 ...
        .byte   $9F                             ; BB78 9F                       .
        asl     $0E0E                           ; BB79 0E 0E 0E                 ...
        asl     $0E0E                           ; BB7C 0E 0E 0E                 ...
        asl     $0E0E                           ; BB7F 0E 0E 0E                 ...
        .byte   $B2                             ; BB82 B2                       .
        .byte   $B2                             ; BB83 B2                       .
        .byte   $B3                             ; BB84 B3                       .
        .byte   $89                             ; BB85 89                       .
        ora     ($01,x)                         ; BB86 01 01                    ..
        asl     LB2B2                           ; BB88 0E B2 B2                 ...
        asl     $8980                           ; BB8B 0E 80 89                 ...
        ldy     $95,x                           ; BB8E B4 95                    ..
        .byte   $0E                             ; BB90 0E                       .
        .byte   $1C                             ; BB91 1C                       .
LBB92:  asl     $1C80                           ; BB92 0E 80 1C                 ...
        .byte   $89                             ; BB95 89                       .
        stx     $97,y                           ; BB96 96 97                    ..
        asl     $0E0E                           ; BB98 0E 0E 0E                 ...
        .byte   $72                             ; BB9B 72                       r
        lda     $B6,x                           ; BB9C B5 B6                    ..
        .byte   $AB                             ; BB9E AB                       .
        .byte   $A3                             ; BB9F A3                       .
        asl     $0E0E                           ; BBA0 0E 0E 0E                 ...
        asl     LB772                           ; BBA3 0E 72 B7                 .r.
        ldy     #$A3                            ; BBA6 A0 A3                    ..
LBBA8:  asl     $0E0E                           ; BBA8 0E 0E 0E                 ...
        asl     LB80E                           ; BBAB 0E 0E B8                 ...
        lda     $0EBA,y                         ; BBAE B9 BA 0E                 ...
        asl     $0E0E                           ; BBB1 0E 0E 0E                 ...
        asl     $430E                           ; BBB4 0E 0E 43                 ..C
        asl     $0E0E                           ; BBB7 0E 0E 0E                 ...
        asl     $0E0E                           ; BBBA 0E 0E 0E                 ...
        asl     $0E43                           ; BBBD 0E 43 0E                 .C.
        ora     ($01,x)                         ; BBC0 01 01                    ..
        ora     ($01,x)                         ; BBC2 01 01                    ..
        ldy     $01,x                           ; BBC4 B4 01                    ..
        ora     ($8B,x)                         ; BBC6 01 8B                    ..
        ora     ($01,x)                         ; BBC8 01 01                    ..
        ora     ($8B,x)                         ; BBCA 01 8B                    ..
        sty     $8E8D                           ; BBCC 8C 8D 8E                 ...
        .byte   $8F                             ; BBCF 8F                       .
        .byte   $BB                             ; BBD0 BB                       .
        ora     ($8E,x)                         ; BBD1 01 8E                    ..
        .byte   $8F                             ; BBD3 8F                       .
        bcc     LBB92                           ; BBD4 90 BC                    ..
        ldx     #$A5                            ; BBD6 A2 A5                    ..
        ldy     $9D                             ; BBD8 A4 9D                    ..
        lda     LBEA1,x                         ; BBDA BD A1 BE                 ...
        ldy     #$9F                            ; BBDD A0 9F                    ..
        .byte   $9F                             ; BBDF 9F                       .
        ldx     LA0A0,y                         ; BBE0 BE A0 A0                 ...
        .byte   $BF                             ; BBE3 BF                       .
        ldy     #$A0                            ; BBE4 A0 A0                    ..
        .byte   $9F                             ; BBE6 9F                       .
        .byte   $9F                             ; BBE7 9F                       .
        .byte   $AF                             ; BBE8 AF                       .
        .byte   $9C                             ; BBE9 9C                       .
        ldy     #$A0                            ; BBEA A0 A0                    ..
        ldy     #$A0                            ; BBEC A0 A0                    ..
        .byte   $9F                             ; BBEE 9F                       .
        .byte   $9F                             ; BBEF 9F                       .
        .byte   $9F                             ; BBF0 9F                       .
        .byte   $9F                             ; BBF1 9F                       .
        ldy     #$A0                            ; BBF2 A0 A0                    ..
        ldy     #$A0                            ; BBF4 A0 A0                    ..
        .byte   $9F                             ; BBF6 9F                       .
        .byte   $9F                             ; BBF7 9F                       .
        .byte   $9F                             ; BBF8 9F                       .
        .byte   $9F                             ; BBF9 9F                       .
        ldy     #$A0                            ; BBFA A0 A0                    ..
        ldy     #$A0                            ; BBFC A0 A0                    ..
        .byte   $9F                             ; BBFE 9F                       .
        .byte   $9F                             ; BBFF 9F                       .
        sty     $018D                           ; BC00 8C 8D 01                 ...
        ora     ($B4,x)                         ; BC03 01 B4                    ..
        ora     $0E0E,y                         ; BC05 19 0E 0E                 ...
        bcc     LBBA8                           ; BC08 90 9E                    ..
        .byte   $BB                             ; BC0A BB                       .
        ora     ($A7,x)                         ; BC0B 01 A7                    ..
        ora     $0E0E,y                         ; BC0D 19 0E 0E                 ...
        ldx     $06                             ; BC10 A6 06                    ..
        ldy     $A8                             ; BC12 A4 A8                    ..
        lda     #$C0                            ; BC14 A9 C0                    ..
        asl     $9F0E                           ; BC16 0E 0E 9F                 ...
        ldx     #$06                            ; BC19 A2 06                    ..
        ldy     $AE                             ; BC1B A4 AE                    ..
        cmp     ($0E,x)                         ; BC1D C1 0E                    ..
        asl     $9F9F                           ; BC1F 0E 9F 9F                 ...
        ldx     #$06                            ; BC22 A2 06                    ..
        ldy     $C1                             ; BC24 A4 C1                    ..
        .byte   $C2                             ; BC26 C2                       .
        .byte   $C3                             ; BC27 C3                       .
        .byte   $9F                             ; BC28 9F                       .
        .byte   $9F                             ; BC29 9F                       .
        .byte   $9F                             ; BC2A 9F                       .
        ldx     #$06                            ; BC2B A2 06                    ..
        cmp     ($1C,x)                         ; BC2D C1 1C                    ..
        .byte   $1C                             ; BC2F 1C                       .
        .byte   $9F                             ; BC30 9F                       .
        .byte   $9F                             ; BC31 9F                       .
        .byte   $9F                             ; BC32 9F                       .
        .byte   $9F                             ; BC33 9F                       .
        asl     $C1                             ; BC34 06 C1                    ..
        cpy     $73                             ; BC36 C4 73                    .s
        .byte   $9F                             ; BC38 9F                       .
        .byte   $9F                             ; BC39 9F                       .
        .byte   $9F                             ; BC3A 9F                       .
        .byte   $9F                             ; BC3B 9F                       .
        asl     $C1                             ; BC3C 06 C1                    ..
        asl     $C50E                           ; BC3E 0E 0E C5                 ...
        .byte   $1C                             ; BC41 1C                       .
        .byte   $1C                             ; BC42 1C                       .
        .byte   $1C                             ; BC43 1C                       .
        ora     $C61C,x                         ; BC44 1D 1C C6                 ...
        asl     $1DC7                           ; BC47 0E C7 1D                 ...
        .byte   $1C                             ; BC4A 1C                       .
        .byte   $1A                             ; BC4B 1A                       .
        .byte   $1A                             ; BC4C 1A                       .
        .byte   $1C                             ; BC4D 1C                       .
        dec     $0E                             ; BC4E C6 0E                    ..
        asl     $1D1A                           ; BC50 0E 1A 1D                 ...
        .byte   $1A                             ; BC53 1A                       .
        .byte   $1A                             ; BC54 1A                       .
        .byte   $1A                             ; BC55 1A                       .
        iny                                     ; BC56 C8                       .
        asl     $1A80                           ; BC57 0E 80 1A                 ...
        .byte   $1A                             ; BC5A 1A                       .
        .byte   $1A                             ; BC5B 1A                       .
        .byte   $1A                             ; BC5C 1A                       .
        ora     $0E1C,x                         ; BC5D 1D 1C 0E                 ...
        cmp     #$1A                            ; BC60 C9 1A                    ..
        ora     $1D1A,x                         ; BC62 1D 1A 1D                 ...
        .byte   $1A                             ; BC65 1A                       .
        .byte   $1A                             ; BC66 1A                       .
        asl     $1C1C                           ; BC67 0E 1C 1C                 ...
LBC6A:  .byte   $1C                             ; BC6A 1C                       .
        .byte   $1A                             ; BC6B 1A                       .
        .byte   $1A                             ; BC6C 1A                       .
        .byte   $1C                             ; BC6D 1C                       .
        ora     $730E,x                         ; BC6E 1D 0E 73                 ..s
        lda     $1C,x                           ; BC71 B5 1C                    ..
        .byte   $1A                             ; BC73 1A                       .
        ora     $1D1A,x                         ; BC74 1D 1A 1D                 ...
        asl     $800E                           ; BC77 0E 0E 80                 ...
        ora     $1C1C,x                         ; BC7A 1D 1C 1C                 ...
        ora     $0E1C,x                         ; BC7D 1D 1C 0E                 ...
        asl     $CA43                           ; BC80 0E 43 CA                 .C.
        asl     $0E0E                           ; BC83 0E 0E 0E                 ...
        asl     $0E0E                           ; BC86 0E 0E 0E                 ...
        .byte   $43                             ; BC89 43                       C
        .byte   $CB                             ; BC8A CB                       .
        cpy     $CDCC                           ; BC8B CC CC CD                 ...
        asl     $0E0E                           ; BC8E 0E 0E 0E                 ...
        dec     $CFCF                           ; BC91 CE CF CF                 ...
        .byte   $CF                             ; BC94 CF                       .
        .byte   $CB                             ; BC95 CB                       .
        cmp     $0E0E                           ; BC96 CD 0E 0E                 ...
        bne     LBC6A                           ; BC99 D0 CF                    ..
        .byte   $CF                             ; BC9B CF                       .
        .byte   $CF                             ; BC9C CF                       .
        .byte   $CF                             ; BC9D CF                       .
        .byte   $CB                             ; BC9E CB                       .
        asl     $430E                           ; BC9F 0E 0E 43                 ..C
        .byte   $CF                             ; BCA2 CF                       .
        .byte   $CF                             ; BCA3 CF                       .
        .byte   $CF                             ; BCA4 CF                       .
        .byte   $CF                             ; BCA5 CF                       .
        cmp     ($D2),y                         ; BCA6 D1 D2                    ..
        asl     $0872                           ; BCA8 0E 72 08                 .r.
        .byte   $D3                             ; BCAB D3                       .
        .byte   $D4                             ; BCAC D4                       .
        cmp     $D6,x                           ; BCAD D5 D6                    ..
        asl     $0E0E                           ; BCAF 0E 0E 0E                 ...
        asl     $0E0E                           ; BCB2 0E 0E 0E                 ...
        asl     $0E7D                           ; BCB5 0E 7D 0E                 .}.
        asl     $0E0E                           ; BCB8 0E 0E 0E                 ...
        asl     $0E0E                           ; BCBB 0E 0E 0E                 ...
        adc     $0E0E,x                         ; BCBE 7D 0E 0E                 }..
        asl     $0E0E                           ; BCC1 0E 0E 0E                 ...
        asl     $0E0E                           ; BCC4 0E 0E 0E                 ...
        asl     $0E0E                           ; BCC7 0E 0E 0E                 ...
        asl     $0E0E                           ; BCCA 0E 0E 0E                 ...
        asl     $0E0E                           ; BCCD 0E 0E 0E                 ...
        asl     $0E0E                           ; BCD0 0E 0E 0E                 ...
        asl     $0E0E                           ; BCD3 0E 0E 0E                 ...
        asl     $0E0E                           ; BCD6 0E 0E 0E                 ...
        cpy     $CCCC                           ; BCD9 CC CC CC                 ...
        cpy     $0ECC                           ; BCDC CC CC 0E                 ...
        asl     $D479                           ; BCDF 0E 79 D4                 .y.
        cmp     $CF,x                           ; BCE2 D5 CF                    ..
        .byte   $CF                             ; BCE4 CF                       .
        .byte   $CF                             ; BCE5 CF                       .
        asl     $0E0E                           ; BCE6 0E 0E 0E                 ...
        asl     $7B0E                           ; BCE9 0E 0E 7B                 ..{
        .byte   $D7                             ; BCEC D7                       .
        .byte   $CF                             ; BCED CF                       .
        asl     $0E0E                           ; BCEE 0E 0E 0E                 ...
        asl     $0E0E                           ; BCF1 0E 0E 0E                 ...
        asl     $0E7B                           ; BCF4 0E 7B 0E                 .{.
        asl     $0E0E                           ; BCF7 0E 0E 0E                 ...
        asl     $0E0E                           ; BCFA 0E 0E 0E                 ...
        asl     $0E0E                           ; BCFD 0E 0E 0E                 ...
        asl     $0E0E                           ; BD00 0E 0E 0E                 ...
        .byte   $80                             ; BD03 80                       .
        .byte   $89                             ; BD04 89                       .
        ora     ($01,x)                         ; BD05 01 01                    ..
        ora     ($0E,x)                         ; BD07 01 0E                    ..
        asl     $800E                           ; BD09 0E 0E 80                 ...
        .byte   $89                             ; BD0C 89                       .
        ora     ($01,x)                         ; BD0D 01 01                    ..
        ora     ($0E,x)                         ; BD0F 01 0E                    ..
        asl     $1D80                           ; BD11 0E 80 1D                 ...
        .byte   $89                             ; BD14 89                       .
        cld                                     ; BD15 D8                       .
        cmp     $0EDA,y                         ; BD16 D9 DA 0E                 ...
        asl     $1A80                           ; BD19 0E 80 1A                 ...
        .byte   $DB                             ; BD1C DB                       .
        ldy     #$A0                            ; BD1D A0 A0                    ..
        ldy     #$0E                            ; BD1F A0 0E                    ..
        .byte   $80                             ; BD21 80                       .
        ora     $DB1A,x                         ; BD22 1D 1A DB                 ...
        ldy     #$A0                            ; BD25 A0 A0                    ..
        .byte   $DC                             ; BD27 DC                       .
        asl     $1A80                           ; BD28 0E 80 1A                 ...
        .byte   $1C                             ; BD2B 1C                       .
        cmp     $DFDE,x                         ; BD2C DD DE DF                 ...
        asl     $E00E                           ; BD2F 0E 0E E0                 ...
        sbc     ($74,x)                         ; BD32 E1 74                    .t
        asl     $0E0E                           ; BD34 0E 0E 0E                 ...
        asl     $430E                           ; BD37 0E 0E 43                 ..C
        .byte   $E2                             ; BD3A E2                       .
        asl     $0E0E                           ; BD3B 0E 0E 0E                 ...
        asl     $010E                           ; BD3E 0E 0E 01                 ...
        ora     ($01,x)                         ; BD41 01 01                    ..
        ora     ($01,x)                         ; BD43 01 01                    ..
        ora     ($01,x)                         ; BD45 01 01                    ..
        ora     ($01,x)                         ; BD47 01 01                    ..
        ora     ($01,x)                         ; BD49 01 01                    ..
        ora     ($01,x)                         ; BD4B 01 01                    ..
        ora     ($01,x)                         ; BD4D 01 01                    ..
        ora     ($DA,x)                         ; BD4F 01 DA                    ..
        .byte   $E3                             ; BD51 E3                       .
        .byte   $E3                             ; BD52 E3                       .
        cmp     $DADA,y                         ; BD53 D9 DA DA                 ...
        cpx     $D9                             ; BD56 E4 D9                    ..
        sbc     $DE                             ; BD58 E5 DE                    ..
        ldy     #$E6                            ; BD5A A0 E6                    ..
        .byte   $E7                             ; BD5C E7                       .
        .byte   $E7                             ; BD5D E7                       .
        .byte   $E7                             ; BD5E E7                       .
        inx                                     ; BD5F E8                       .
        .byte   $9F                             ; BD60 9F                       .
        .byte   $9F                             ; BD61 9F                       .
        ldy     #$A0                            ; BD62 A0 A0                    ..
        ldy     #$A0                            ; BD64 A0 A0                    ..
        ldy     #$A0                            ; BD66 A0 A0                    ..
        .byte   $9F                             ; BD68 9F                       .
        .byte   $9F                             ; BD69 9F                       .
        sbc     $DE                             ; BD6A E5 DE                    ..
        ldy     #$A0                            ; BD6C A0 A0                    ..
        ldy     #$A0                            ; BD6E A0 A0                    ..
        .byte   $9F                             ; BD70 9F                       .
        .byte   $9F                             ; BD71 9F                       .
        .byte   $9F                             ; BD72 9F                       .
        .byte   $9F                             ; BD73 9F                       .
        sbc     #$EA                            ; BD74 E9 EA                    ..
        .byte   $9C                             ; BD76 9C                       .
        ldx     #$9F                            ; BD77 A2 9F                    ..
        .byte   $9F                             ; BD79 9F                       .
        .byte   $9F                             ; BD7A 9F                       .
        .byte   $9F                             ; BD7B 9F                       .
        .byte   $EB                             ; BD7C EB                       .
        cpx     $9F9F                           ; BD7D EC 9F 9F                 ...
        ora     ($01,x)                         ; BD80 01 01                    ..
        ora     ($01,x)                         ; BD82 01 01                    ..
        ora     ($01,x)                         ; BD84 01 01                    ..
        ora     ($01,x)                         ; BD86 01 01                    ..
        cld                                     ; BD88 D8                       .
        cld                                     ; BD89 D8                       .
        .byte   $E3                             ; BD8A E3                       .
        cmp     $DADA,y                         ; BD8B D9 DA DA                 ...
        cld                                     ; BD8E D8                       .
        cld                                     ; BD8F D8                       .
        ldy     #$ED                            ; BD90 A0 ED                    ..
        inc     LA0A0                           ; BD92 EE A0 A0                 ...
        .byte   $A0                             ; BD95 A0                       .
LBD96:  ldy     #$A0                            ; BD96 A0 A0                    ..
        ldy     #$A0                            ; BD98 A0 A0                    ..
        ldy     #$A0                            ; BD9A A0 A0                    ..
        sbc     $EEEF                           ; BD9C ED EF EE                 ...
        ldy     #$A0                            ; BD9F A0 A0                    ..
        ldy     #$A0                            ; BDA1 A0 A0                    ..
        ldy     #$A0                            ; BDA3 A0 A0                    ..
        ldy     #$ED                            ; BDA5 A0 ED                    ..
        inc     LA0A2                           ; BDA7 EE A2 A0                 ...
        ldx     #$A0                            ; BDAA A2 A0                    ..
        ldy     #$A0                            ; BDAC A0 A0                    ..
        ldy     #$A0                            ; BDAE A0 A0                    ..
        .byte   $9F                             ; BDB0 9F                       .
        sbc     #$9F                            ; BDB1 E9 9F                    ..
        ldx     #$A2                            ; BDB3 A2 A2                    ..
        sbc     #$E9                            ; BDB5 E9 E9                    ..
        .byte   $9B                             ; BDB7 9B                       .
        .byte   $9F                             ; BDB8 9F                       .
        .byte   $EB                             ; BDB9 EB                       .
        .byte   $9F                             ; BDBA 9F                       .
LBDBB:  .byte   $9F                             ; BDBB 9F                       .
        .byte   $9F                             ; BDBC 9F                       .
        .byte   $EB                             ; BDBD EB                       .
        .byte   $EB                             ; BDBE EB                       .
        .byte   $9F                             ; BDBF 9F                       .
        beq     LBDD0                           ; BDC0 F0 0E                    ..
        asl     $0E0E                           ; BDC2 0E 0E 0E                 ...
        asl     $0E0E                           ; BDC5 0E 0E 0E                 ...
        beq     LBD96                           ; BDC8 F0 CC                    ..
        .byte   $2B                             ; BDCA 2B                       +
        asl     $0E0E                           ; BDCB 0E 0E 0E                 ...
        .byte   $0E                             ; BDCE 0E                       .
        .byte   $0E                             ; BDCF 0E                       .
LBDD0:  sbc     ($CF),y                         ; BDD0 F1 CF                    ..
        .byte   $CF                             ; BDD2 CF                       .
        .byte   $2B                             ; BDD3 2B                       +
        .byte   $2B                             ; BDD4 2B                       +
        asl     $0E0E                           ; BDD5 0E 0E 0E                 ...
        sbc     ($CF),y                         ; BDD8 F1 CF                    ..
        .byte   $CF                             ; BDDA CF                       .
        .byte   $CF                             ; BDDB CF                       .
        .byte   $CF                             ; BDDC CF                       .
        .byte   $2B                             ; BDDD 2B                       +
        .byte   $2B                             ; BDDE 2B                       +
        asl     $CFF1                           ; BDDF 0E F1 CF                 ...
        .byte   $CF                             ; BDE2 CF                       .
        .byte   $CF                             ; BDE3 CF                       .
        .byte   $CF                             ; BDE4 CF                       .
        .byte   $CF                             ; BDE5 CF                       .
        .byte   $CF                             ; BDE6 CF                       .
        .byte   $F2                             ; BDE7 F2                       .
        sbc     ($CF),y                         ; BDE8 F1 CF                    ..
        .byte   $CF                             ; BDEA CF                       .
        .byte   $6F                             ; BDEB 6F                       o
        .byte   $F3                             ; BDEC F3                       .
        .byte   $CF                             ; BDED CF                       .
        .byte   $CF                             ; BDEE CF                       .
        .byte   $F4                             ; BDEF F4                       .
        .byte   $AF                             ; BDF0 AF                       .
        .byte   $AF                             ; BDF1 AF                       .
        .byte   $9C                             ; BDF2 9C                       .
        asl     $6F0E                           ; BDF3 0E 0E 6F                 ..o
        .byte   $07                             ; BDF6 07                       .
        .byte   $07                             ; BDF7 07                       .
        .byte   $9F                             ; BDF8 9F                       .
        .byte   $9F                             ; BDF9 9F                       .
        .byte   $9F                             ; BDFA 9F                       .
        asl     $0E0E                           ; BDFB 0E 0E 0E                 ...
        asl     $0E0E                           ; BDFE 0E 0E 0E                 ...
        asl     $0E9F                           ; BE01 0E 9F 0E                 ...
        asl     $0E9F                           ; BE04 0E 9F 0E                 ...
        asl     $0E0E                           ; BE07 0E 0E 0E                 ...
        .byte   $9F                             ; BE0A 9F                       .
        asl     $9F0E                           ; BE0B 0E 0E 9F                 ...
        asl     $0E0E                           ; BE0E 0E 0E 0E                 ...
        asl     $0E9F                           ; BE11 0E 9F 0E                 ...
        asl     $0E9F                           ; BE14 0E 9F 0E                 ...
        asl     $0E0E                           ; BE17 0E 0E 0E                 ...
        .byte   $9F                             ; BE1A 9F                       .
        asl     $9F0E                           ; BE1B 0E 0E 9F                 ...
        asl     $2B0E                           ; BE1E 0E 0E 2B                 ..+
        .byte   $2B                             ; BE21 2B                       +
        sbc     $2B,x                           ; BE22 F5 2B                    .+
        .byte   $2B                             ; BE24 2B                       +
        sbc     $2B,x                           ; BE25 F5 2B                    .+
        .byte   $F2                             ; BE27 F2                       .
        .byte   $CF                             ; BE28 CF                       .
        .byte   $CF                             ; BE29 CF                       .
        .byte   $CF                             ; BE2A CF                       .
        .byte   $CF                             ; BE2B CF                       .
        .byte   $CF                             ; BE2C CF                       .
        .byte   $CF                             ; BE2D CF                       .
        .byte   $CF                             ; BE2E CF                       .
        .byte   $F4                             ; BE2F F4                       .
        .byte   $07                             ; BE30 07                       .
        .byte   $07                             ; BE31 07                       .
        ldx     #$07                            ; BE32 A2 07                    ..
        .byte   $07                             ; BE34 07                       .
        ldx     #$07                            ; BE35 A2 07                    ..
        .byte   $07                             ; BE37 07                       .
        asl     $9F0E                           ; BE38 0E 0E 9F                 ...
        asl     $9F0E                           ; BE3B 0E 0E 9F                 ...
        asl     $F60E                           ; BE3E 0E 0E F6                 ...
        .byte   $F7                             ; BE41 F7                       .
        inc     $F7,x                           ; BE42 F6 F7                    ..
        .byte   $F7                             ; BE44 F7                       .
        inc     $F7,x                           ; BE45 F6 F7                    ..
        inc     $F8,x                           ; BE47 F6 F8                    ..
        sbc     $F9CC,y                         ; BE49 F9 CC F9                 ...
        sbc     $F9CC,y                         ; BE4C F9 CC F9                 ...
        .byte   $FA                             ; BE4F FA                       .
        .byte   $FB                             ; BE50 FB                       .
        .byte   $1B                             ; BE51 1B                       .
        .byte   $CF                             ; BE52 CF                       .
        .byte   $1B                             ; BE53 1B                       .
        .byte   $1B                             ; BE54 1B                       .
        .byte   $CF                             ; BE55 CF                       .
        .byte   $1B                             ; BE56 1B                       .
        .byte   $FC                             ; BE57 FC                       .
        .byte   $FB                             ; BE58 FB                       .
        .byte   $1B                             ; BE59 1B                       .
        .byte   $CF                             ; BE5A CF                       .
        .byte   $1B                             ; BE5B 1B                       .
        .byte   $1B                             ; BE5C 1B                       .
        .byte   $CF                             ; BE5D CF                       .
        .byte   $1B                             ; BE5E 1B                       .
        .byte   $FC                             ; BE5F FC                       .
        sbc     $CF1B,x                         ; BE60 FD 1B CF                 ...
        .byte   $1B                             ; BE63 1B                       .
        .byte   $1B                             ; BE64 1B                       .
        .byte   $CF                             ; BE65 CF                       .
        .byte   $1B                             ; BE66 1B                       .
        .byte   $FC                             ; BE67 FC                       .
        .byte   $CF                             ; BE68 CF                       .
        .byte   $1B                             ; BE69 1B                       .
        .byte   $CF                             ; BE6A CF                       .
        .byte   $1B                             ; BE6B 1B                       .
        .byte   $1B                             ; BE6C 1B                       .
        .byte   $CF                             ; BE6D CF                       .
        .byte   $1B                             ; BE6E 1B                       .
        .byte   $FC                             ; BE6F FC                       .
        ldx     #$07                            ; BE70 A2 07                    ..
        ldx     #$07                            ; BE72 A2 07                    ..
        .byte   $07                             ; BE74 07                       .
        ldx     #$07                            ; BE75 A2 07                    ..
        ldx     #$9F                            ; BE77 A2 9F                    ..
        asl     $0E9F                           ; BE79 0E 9F 0E                 ...
        asl     $0E9F                           ; BE7C 0E 9F 0E                 ...
        .byte   $9F                             ; BE7F 9F                       .
        .byte   $1C                             ; BE80 1C                       .
        .byte   $1C                             ; BE81 1C                       .
        .byte   $1C                             ; BE82 1C                       .
        .byte   $1C                             ; BE83 1C                       .
        .byte   $1C                             ; BE84 1C                       .
        .byte   $1C                             ; BE85 1C                       .
        .byte   $1C                             ; BE86 1C                       .
        .byte   $1C                             ; BE87 1C                       .
        .byte   $1C                             ; BE88 1C                       .
        .byte   $1C                             ; BE89 1C                       .
        .byte   $1C                             ; BE8A 1C                       .
        .byte   $1C                             ; BE8B 1C                       .
        .byte   $1C                             ; BE8C 1C                       .
        .byte   $1C                             ; BE8D 1C                       .
        .byte   $1C                             ; BE8E 1C                       .
        .byte   $1C                             ; BE8F 1C                       .
        .byte   $1C                             ; BE90 1C                       .
        .byte   $1C                             ; BE91 1C                       .
        .byte   $1C                             ; BE92 1C                       .
        .byte   $1C                             ; BE93 1C                       .
        .byte   $1C                             ; BE94 1C                       .
        .byte   $1C                             ; BE95 1C                       .
        .byte   $1C                             ; BE96 1C                       .
        .byte   $1C                             ; BE97 1C                       .
        .byte   $1C                             ; BE98 1C                       .
        .byte   $1C                             ; BE99 1C                       .
        .byte   $1C                             ; BE9A 1C                       .
        .byte   $1C                             ; BE9B 1C                       .
        .byte   $1C                             ; BE9C 1C                       .
        .byte   $1C                             ; BE9D 1C                       .
        .byte   $1C                             ; BE9E 1C                       .
        .byte   $1C                             ; BE9F 1C                       .
        .byte   $1C                             ; BEA0 1C                       .
LBEA1:  .byte   $1C                             ; BEA1 1C                       .
        .byte   $1C                             ; BEA2 1C                       .
        .byte   $1C                             ; BEA3 1C                       .
        .byte   $1C                             ; BEA4 1C                       .
        .byte   $1C                             ; BEA5 1C                       .
        .byte   $1C                             ; BEA6 1C                       .
        .byte   $1C                             ; BEA7 1C                       .
        .byte   $1C                             ; BEA8 1C                       .
        .byte   $1C                             ; BEA9 1C                       .
        .byte   $1C                             ; BEAA 1C                       .
        .byte   $1C                             ; BEAB 1C                       .
        .byte   $1C                             ; BEAC 1C                       .
        .byte   $1C                             ; BEAD 1C                       .
        .byte   $1C                             ; BEAE 1C                       .
        .byte   $1C                             ; BEAF 1C                       .
        .byte   $1C                             ; BEB0 1C                       .
        .byte   $1C                             ; BEB1 1C                       .
        .byte   $1C                             ; BEB2 1C                       .
        .byte   $1C                             ; BEB3 1C                       .
        .byte   $1C                             ; BEB4 1C                       .
        .byte   $1C                             ; BEB5 1C                       .
        .byte   $1C                             ; BEB6 1C                       .
        .byte   $1C                             ; BEB7 1C                       .
        .byte   $1C                             ; BEB8 1C                       .
        .byte   $1C                             ; BEB9 1C                       .
        .byte   $1C                             ; BEBA 1C                       .
        .byte   $1C                             ; BEBB 1C                       .
        .byte   $1C                             ; BEBC 1C                       .
        .byte   $1C                             ; BEBD 1C                       .
        .byte   $1C                             ; BEBE 1C                       .
        .byte   $1C                             ; BEBF 1C                       .
        .byte   $1C                             ; BEC0 1C                       .
        .byte   $1C                             ; BEC1 1C                       .
        .byte   $1C                             ; BEC2 1C                       .
        .byte   $1C                             ; BEC3 1C                       .
        .byte   $1C                             ; BEC4 1C                       .
        .byte   $1C                             ; BEC5 1C                       .
        .byte   $1C                             ; BEC6 1C                       .
        .byte   $1C                             ; BEC7 1C                       .
        .byte   $1C                             ; BEC8 1C                       .
        .byte   $1C                             ; BEC9 1C                       .
        .byte   $1C                             ; BECA 1C                       .
        .byte   $1C                             ; BECB 1C                       .
        .byte   $1C                             ; BECC 1C                       .
        .byte   $1C                             ; BECD 1C                       .
        .byte   $1C                             ; BECE 1C                       .
        .byte   $1C                             ; BECF 1C                       .
        .byte   $1C                             ; BED0 1C                       .
        .byte   $1C                             ; BED1 1C                       .
        .byte   $1C                             ; BED2 1C                       .
        .byte   $1C                             ; BED3 1C                       .
        .byte   $1C                             ; BED4 1C                       .
        .byte   $1C                             ; BED5 1C                       .
        .byte   $1C                             ; BED6 1C                       .
        .byte   $1C                             ; BED7 1C                       .
        .byte   $1C                             ; BED8 1C                       .
        .byte   $1C                             ; BED9 1C                       .
        .byte   $1C                             ; BEDA 1C                       .
        .byte   $1C                             ; BEDB 1C                       .
        .byte   $1C                             ; BEDC 1C                       .
        .byte   $1C                             ; BEDD 1C                       .
        .byte   $1C                             ; BEDE 1C                       .
        .byte   $1C                             ; BEDF 1C                       .
        .byte   $1C                             ; BEE0 1C                       .
        .byte   $1C                             ; BEE1 1C                       .
        .byte   $1C                             ; BEE2 1C                       .
        .byte   $1C                             ; BEE3 1C                       .
        .byte   $1C                             ; BEE4 1C                       .
        .byte   $1C                             ; BEE5 1C                       .
        .byte   $1C                             ; BEE6 1C                       .
        .byte   $1C                             ; BEE7 1C                       .
        .byte   $1C                             ; BEE8 1C                       .
        .byte   $1C                             ; BEE9 1C                       .
        .byte   $1C                             ; BEEA 1C                       .
        .byte   $1C                             ; BEEB 1C                       .
        .byte   $1C                             ; BEEC 1C                       .
        .byte   $1C                             ; BEED 1C                       .
        .byte   $1C                             ; BEEE 1C                       .
        .byte   $1C                             ; BEEF 1C                       .
        .byte   $1C                             ; BEF0 1C                       .
        .byte   $1C                             ; BEF1 1C                       .
        .byte   $1C                             ; BEF2 1C                       .
        .byte   $1C                             ; BEF3 1C                       .
        .byte   $1C                             ; BEF4 1C                       .
        .byte   $1C                             ; BEF5 1C                       .
        .byte   $1C                             ; BEF6 1C                       .
        .byte   $1C                             ; BEF7 1C                       .
        .byte   $1C                             ; BEF8 1C                       .
        .byte   $1C                             ; BEF9 1C                       .
        .byte   $1C                             ; BEFA 1C                       .
        .byte   $1C                             ; BEFB 1C                       .
        .byte   $1C                             ; BEFC 1C                       .
        .byte   $1C                             ; BEFD 1C                       .
        .byte   $1C                             ; BEFE 1C                       .
        .byte   $1C                             ; BEFF 1C                       .
        .byte   $1C                             ; BF00 1C                       .
        .byte   $1C                             ; BF01 1C                       .
        .byte   $1C                             ; BF02 1C                       .
        .byte   $1C                             ; BF03 1C                       .
        .byte   $1C                             ; BF04 1C                       .
        .byte   $1C                             ; BF05 1C                       .
        .byte   $1C                             ; BF06 1C                       .
        .byte   $1C                             ; BF07 1C                       .
        .byte   $1C                             ; BF08 1C                       .
        .byte   $1C                             ; BF09 1C                       .
        .byte   $1C                             ; BF0A 1C                       .
        .byte   $1C                             ; BF0B 1C                       .
        .byte   $1C                             ; BF0C 1C                       .
        .byte   $1C                             ; BF0D 1C                       .
        .byte   $1C                             ; BF0E 1C                       .
        .byte   $1C                             ; BF0F 1C                       .
        .byte   $1C                             ; BF10 1C                       .
        .byte   $1C                             ; BF11 1C                       .
        .byte   $1C                             ; BF12 1C                       .
        .byte   $1C                             ; BF13 1C                       .
        .byte   $1C                             ; BF14 1C                       .
        .byte   $1C                             ; BF15 1C                       .
        .byte   $1C                             ; BF16 1C                       .
        .byte   $1C                             ; BF17 1C                       .
        .byte   $1C                             ; BF18 1C                       .
        .byte   $1C                             ; BF19 1C                       .
        .byte   $1C                             ; BF1A 1C                       .
        .byte   $1C                             ; BF1B 1C                       .
        .byte   $1C                             ; BF1C 1C                       .
        .byte   $1C                             ; BF1D 1C                       .
        .byte   $1C                             ; BF1E 1C                       .
        .byte   $1C                             ; BF1F 1C                       .
        .byte   $1C                             ; BF20 1C                       .
        .byte   $1C                             ; BF21 1C                       .
        .byte   $1C                             ; BF22 1C                       .
        .byte   $1C                             ; BF23 1C                       .
        .byte   $1C                             ; BF24 1C                       .
        .byte   $1C                             ; BF25 1C                       .
        .byte   $1C                             ; BF26 1C                       .
        .byte   $1C                             ; BF27 1C                       .
        .byte   $1C                             ; BF28 1C                       .
        .byte   $1C                             ; BF29 1C                       .
        .byte   $1C                             ; BF2A 1C                       .
        .byte   $1C                             ; BF2B 1C                       .
        .byte   $1C                             ; BF2C 1C                       .
        .byte   $1C                             ; BF2D 1C                       .
        .byte   $1C                             ; BF2E 1C                       .
        .byte   $1C                             ; BF2F 1C                       .
        .byte   $1C                             ; BF30 1C                       .
        .byte   $1C                             ; BF31 1C                       .
        .byte   $1C                             ; BF32 1C                       .
        .byte   $1C                             ; BF33 1C                       .
        .byte   $1C                             ; BF34 1C                       .
        .byte   $1C                             ; BF35 1C                       .
        .byte   $1C                             ; BF36 1C                       .
        .byte   $1C                             ; BF37 1C                       .
        .byte   $1C                             ; BF38 1C                       .
        .byte   $1C                             ; BF39 1C                       .
        .byte   $1C                             ; BF3A 1C                       .
        .byte   $1C                             ; BF3B 1C                       .
        .byte   $1C                             ; BF3C 1C                       .
        .byte   $1C                             ; BF3D 1C                       .
        .byte   $1C                             ; BF3E 1C                       .
        .byte   $1C                             ; BF3F 1C                       .
        .byte   $1C                             ; BF40 1C                       .
        .byte   $1C                             ; BF41 1C                       .
        .byte   $1C                             ; BF42 1C                       .
        .byte   $1C                             ; BF43 1C                       .
        .byte   $1C                             ; BF44 1C                       .
        .byte   $1C                             ; BF45 1C                       .
        .byte   $1C                             ; BF46 1C                       .
        .byte   $1C                             ; BF47 1C                       .
        .byte   $1C                             ; BF48 1C                       .
        .byte   $1C                             ; BF49 1C                       .
        .byte   $1C                             ; BF4A 1C                       .
        .byte   $1C                             ; BF4B 1C                       .
        .byte   $1C                             ; BF4C 1C                       .
        .byte   $1C                             ; BF4D 1C                       .
        .byte   $1C                             ; BF4E 1C                       .
        .byte   $1C                             ; BF4F 1C                       .
        .byte   $1C                             ; BF50 1C                       .
        .byte   $1C                             ; BF51 1C                       .
        .byte   $1C                             ; BF52 1C                       .
        .byte   $1C                             ; BF53 1C                       .
        .byte   $1C                             ; BF54 1C                       .
        .byte   $1C                             ; BF55 1C                       .
        .byte   $1C                             ; BF56 1C                       .
        .byte   $1C                             ; BF57 1C                       .
        .byte   $1C                             ; BF58 1C                       .
        .byte   $1C                             ; BF59 1C                       .
        .byte   $1C                             ; BF5A 1C                       .
        .byte   $1C                             ; BF5B 1C                       .
        .byte   $1C                             ; BF5C 1C                       .
        .byte   $1C                             ; BF5D 1C                       .
        .byte   $1C                             ; BF5E 1C                       .
        .byte   $1C                             ; BF5F 1C                       .
        .byte   $1C                             ; BF60 1C                       .
        .byte   $1C                             ; BF61 1C                       .
        .byte   $1C                             ; BF62 1C                       .
        .byte   $1C                             ; BF63 1C                       .
        .byte   $1C                             ; BF64 1C                       .
        .byte   $1C                             ; BF65 1C                       .
        .byte   $1C                             ; BF66 1C                       .
        .byte   $1C                             ; BF67 1C                       .
        .byte   $1C                             ; BF68 1C                       .
        .byte   $1C                             ; BF69 1C                       .
        .byte   $1C                             ; BF6A 1C                       .
        .byte   $1C                             ; BF6B 1C                       .
        .byte   $1C                             ; BF6C 1C                       .
        .byte   $1C                             ; BF6D 1C                       .
        .byte   $1C                             ; BF6E 1C                       .
        .byte   $1C                             ; BF6F 1C                       .
        .byte   $1C                             ; BF70 1C                       .
        .byte   $1C                             ; BF71 1C                       .
        .byte   $1C                             ; BF72 1C                       .
        .byte   $1C                             ; BF73 1C                       .
        .byte   $1C                             ; BF74 1C                       .
        .byte   $1C                             ; BF75 1C                       .
        .byte   $1C                             ; BF76 1C                       .
        .byte   $1C                             ; BF77 1C                       .
        .byte   $1C                             ; BF78 1C                       .
        .byte   $1C                             ; BF79 1C                       .
        .byte   $1C                             ; BF7A 1C                       .
        .byte   $1C                             ; BF7B 1C                       .
        .byte   $1C                             ; BF7C 1C                       .
        .byte   $1C                             ; BF7D 1C                       .
        .byte   $1C                             ; BF7E 1C                       .
        .byte   $1C                             ; BF7F 1C                       .
        .byte   $1C                             ; BF80 1C                       .
        .byte   $1C                             ; BF81 1C                       .
        .byte   $1C                             ; BF82 1C                       .
        .byte   $1C                             ; BF83 1C                       .
        .byte   $1C                             ; BF84 1C                       .
        .byte   $1C                             ; BF85 1C                       .
        .byte   $1C                             ; BF86 1C                       .
        .byte   $1C                             ; BF87 1C                       .
        .byte   $1C                             ; BF88 1C                       .
        .byte   $1C                             ; BF89 1C                       .
        .byte   $1C                             ; BF8A 1C                       .
        .byte   $1C                             ; BF8B 1C                       .
        .byte   $1C                             ; BF8C 1C                       .
        .byte   $1C                             ; BF8D 1C                       .
        .byte   $1C                             ; BF8E 1C                       .
        .byte   $1C                             ; BF8F 1C                       .
        .byte   $1C                             ; BF90 1C                       .
        .byte   $1C                             ; BF91 1C                       .
        .byte   $1C                             ; BF92 1C                       .
        .byte   $1C                             ; BF93 1C                       .
        .byte   $1C                             ; BF94 1C                       .
        .byte   $1C                             ; BF95 1C                       .
        .byte   $1C                             ; BF96 1C                       .
        .byte   $1C                             ; BF97 1C                       .
        .byte   $1C                             ; BF98 1C                       .
        .byte   $1C                             ; BF99 1C                       .
        .byte   $1C                             ; BF9A 1C                       .
        .byte   $1C                             ; BF9B 1C                       .
        .byte   $1C                             ; BF9C 1C                       .
        .byte   $1C                             ; BF9D 1C                       .
        .byte   $1C                             ; BF9E 1C                       .
        .byte   $1C                             ; BF9F 1C                       .
        .byte   $1C                             ; BFA0 1C                       .
        .byte   $1C                             ; BFA1 1C                       .
        .byte   $1C                             ; BFA2 1C                       .
        .byte   $1C                             ; BFA3 1C                       .
        .byte   $1C                             ; BFA4 1C                       .
        .byte   $1C                             ; BFA5 1C                       .
        .byte   $1C                             ; BFA6 1C                       .
        .byte   $1C                             ; BFA7 1C                       .
        .byte   $1C                             ; BFA8 1C                       .
        .byte   $1C                             ; BFA9 1C                       .
        .byte   $1C                             ; BFAA 1C                       .
        .byte   $1C                             ; BFAB 1C                       .
        .byte   $1C                             ; BFAC 1C                       .
        .byte   $1C                             ; BFAD 1C                       .
        .byte   $1C                             ; BFAE 1C                       .
        .byte   $1C                             ; BFAF 1C                       .
        .byte   $1C                             ; BFB0 1C                       .
        .byte   $1C                             ; BFB1 1C                       .
        .byte   $1C                             ; BFB2 1C                       .
        .byte   $1C                             ; BFB3 1C                       .
        .byte   $1C                             ; BFB4 1C                       .
        .byte   $1C                             ; BFB5 1C                       .
        .byte   $1C                             ; BFB6 1C                       .
        .byte   $1C                             ; BFB7 1C                       .
        .byte   $1C                             ; BFB8 1C                       .
        .byte   $1C                             ; BFB9 1C                       .
        .byte   $1C                             ; BFBA 1C                       .
        .byte   $1C                             ; BFBB 1C                       .
        .byte   $1C                             ; BFBC 1C                       .
        .byte   $1C                             ; BFBD 1C                       .
        .byte   $1C                             ; BFBE 1C                       .
        .byte   $1C                             ; BFBF 1C                       .
        .byte   $1C                             ; BFC0 1C                       .
        .byte   $1C                             ; BFC1 1C                       .
        .byte   $1C                             ; BFC2 1C                       .
        .byte   $1C                             ; BFC3 1C                       .
        .byte   $1C                             ; BFC4 1C                       .
        .byte   $1C                             ; BFC5 1C                       .
        .byte   $1C                             ; BFC6 1C                       .
        .byte   $1C                             ; BFC7 1C                       .
        .byte   $1C                             ; BFC8 1C                       .
        .byte   $1C                             ; BFC9 1C                       .
        .byte   $1C                             ; BFCA 1C                       .
        .byte   $1C                             ; BFCB 1C                       .
        .byte   $1C                             ; BFCC 1C                       .
        .byte   $1C                             ; BFCD 1C                       .
        .byte   $1C                             ; BFCE 1C                       .
        .byte   $1C                             ; BFCF 1C                       .
        .byte   $1C                             ; BFD0 1C                       .
        .byte   $1C                             ; BFD1 1C                       .
        .byte   $1C                             ; BFD2 1C                       .
        .byte   $1C                             ; BFD3 1C                       .
        .byte   $1C                             ; BFD4 1C                       .
        .byte   $1C                             ; BFD5 1C                       .
        .byte   $1C                             ; BFD6 1C                       .
        .byte   $1C                             ; BFD7 1C                       .
        .byte   $1C                             ; BFD8 1C                       .
        .byte   $1C                             ; BFD9 1C                       .
        .byte   $1C                             ; BFDA 1C                       .
        .byte   $1C                             ; BFDB 1C                       .
        .byte   $1C                             ; BFDC 1C                       .
        .byte   $1C                             ; BFDD 1C                       .
        .byte   $1C                             ; BFDE 1C                       .
        .byte   $1C                             ; BFDF 1C                       .
        .byte   $1C                             ; BFE0 1C                       .
        .byte   $1C                             ; BFE1 1C                       .
        .byte   $1C                             ; BFE2 1C                       .
        .byte   $1C                             ; BFE3 1C                       .
        .byte   $1C                             ; BFE4 1C                       .
        .byte   $1C                             ; BFE5 1C                       .
        .byte   $1C                             ; BFE6 1C                       .
        .byte   $1C                             ; BFE7 1C                       .
        .byte   $1C                             ; BFE8 1C                       .
        .byte   $1C                             ; BFE9 1C                       .
        .byte   $1C                             ; BFEA 1C                       .
        .byte   $1C                             ; BFEB 1C                       .
        .byte   $1C                             ; BFEC 1C                       .
        .byte   $1C                             ; BFED 1C                       .
        .byte   $1C                             ; BFEE 1C                       .
        .byte   $1C                             ; BFEF 1C                       .
        .byte   $1C                             ; BFF0 1C                       .
        .byte   $1C                             ; BFF1 1C                       .
        .byte   $1C                             ; BFF2 1C                       .
        .byte   $1C                             ; BFF3 1C                       .
        .byte   $1C                             ; BFF4 1C                       .
        .byte   $1C                             ; BFF5 1C                       .
        .byte   $1C                             ; BFF6 1C                       .
        .byte   $1C                             ; BFF7 1C                       .
        .byte   $1C                             ; BFF8 1C                       .
        .byte   $1C                             ; BFF9 1C                       .
        .byte   $1C                             ; BFFA 1C                       .
        .byte   $1C                             ; BFFB 1C                       .
        .byte   $1C                             ; BFFC 1C                       .
        .byte   $1C                             ; BFFD 1C                       .
        .byte   $1C                             ; BFFE 1C                       .
        .byte   $1C                             ; BFFF 1C                       .
