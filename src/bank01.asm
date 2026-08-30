.setcpu "6502"
.include "include/hardware.inc"
.include "include/zeropage.inc"
.include "include/constants.inc"
.include "include/fixed_bank.inc"

.segment "BANK01"

; =============================================================================
; BANK $01 (mapped at $8000) — PAUSE/WEAPON MENU + WAVE MAN STAGE DATA
; The gameplay frame loop maps $01/$08 and calls $8000 when Start is
; pressed ($1E:DE99): the pause/weapon menu (full walkthrough in the
; routine header below). stage_load also reads the weapon swatch/CHR
; tables here ($854B/$85F1, indexed by the equipped cursor slot $50)
; with this bank at $8000. $8800 (rt $A800): Water Wave damage table.
; Data half (file +$0900 on): stage $01 (Wave Man) stage data —
; screen table at $A900 with this bank at $A000; format in
; DATA_REFERENCE.md section 11.
; =============================================================================
L0000           := $0000
L0010           := $0010
L00A2           := $00A2
L0422           := $0422
L056D           := $056D
L0600           := $0600
L064D           := $064D
L0A00           := $0A00
L0B00           := $0B00
L0F07           := $0F07
L0F0F           := $0F0F
L0F11           := $0F11
L0F14           := $0F14
L0F16           := $0F16
L0F1A           := $0F1A
L0F26           := $0F26
L0F2C           := $0F2C
L0F37           := $0F37
L1110           := $1110
L1506           := $1506
L1515           := $1515
L1827           := $1827
L1C2C           := $1C2C
L1F38           := $1F38
L1F3A           := $1F3A
L2020           := $2020
L211C           := $211C
L2120           := $2120
L2121           := $2121
L2221           := $2221
L222A           := $222A
L2322           := $2322
L2522           := $2522
L3130           := $3130
L3422           := $3422
L3722           := $3722
L3A20           := $3A20
L4443           := $4443
L4C00           := $4C00
L4C2F           := $4C2F
L4C4A           := $4C4A
L4C4B           := $4C4B
L4F66           := $4F66
L6422           := $6422
L6820           := $6820
L6D20           := $6D20
L6F82           := $6F82
LA3B0           := $A3B0
LA440           := $A440
LD000           := $D000
LD423           := $D423
LD840           := $D840
LE000           := $E000
LFF24           := $FF24
; ----------------------------------------------------------------------------
; =============================================================================
; PAUSE / WEAPON MENU — $01:8000 (pair $01/$08; entered from the gameplay
; frame loop, $1E:DE99, on Start with sound $29).
; Open: fade/blank, save context to $07A2+ (banks $26/$27, scroll, $23,
; game-mode req, CHR shadows $EA-$EF, master palette) — then switch to
; pseudo-stage $26=$27=$10, redraw the whole screen from its layout
; (redraw_screen_banksafe), load menu CHR (L8524) + palette (L852A), wipe
; entity slots 1-4, and draw the panels: weapon names (L8403 blanks the
; unowned), energy bars (L8437), MEGAMAN-V letters / BEAT row (L8488),
; E/M-tank + lives digits (L84E9), cursor row highlight (L8375).
; $10 holds the PPU-addr OR mask (L8522[mirror_shadow]) selecting the
; visible nametable; $50 = cursor (bits 0-2 row, bit 3 column).
; =============================================================================
        lda     #$00                            ; 8000 A9 00                    ..
        sta     $95                             ; 8002 85 95                    ..
        inc     $1B                             ; 8004 E6 1B                    ..
        jsr     palette_fade_out                           ; 8006 20 F1 C3                  ..
        jsr     oam_clear                           ; 8009 20 8F C3                  ..
        jsr     frame_wait                           ; 800C 20 22 FF                  ".
        jsr     disable_rendering                           ; 800F 20 D1 C2                  ..
        inc     $59                             ; 8012 E6 59                    .Y
        lda     $27                             ; 8014 A5 27                    .'
        sta     $07A2                           ; 8016 8D A2 07                 ...
        lda     $26                             ; 8019 A5 26                    .&
        sta     $07A3                           ; 801B 8D A3 07                 ...
        lda     $FC                             ; 801E A5 FC                    ..
        sta     $07A4                           ; 8020 8D A4 07                 ...
        lda     $FD                             ; 8023 A5 FD                    ..
        sta     $07A5                           ; 8025 8D A5 07                 ...
        lda     $FA                             ; 8028 A5 FA                    ..
        sta     $07A6                           ; 802A 8D A6 07                 ...
        lda     $FB                             ; 802D A5 FB                    ..
        sta     $07A7                           ; 802F 8D A7 07                 ...
        lda     $23                             ; 8032 A5 23                    .#
        sta     $07A8                           ; 8034 8D A8 07                 ...
        lda     $99                             ; 8037 A5 99                    ..
        sta     $07A9                           ; 8039 8D A9 07                 ...
        lda     #$10                            ; 803C A9 10                    ..
        sta     $27                             ; 803E 85 27                    .'
        sta     $26                             ; 8040 85 26                    .&
        ldy     $2C                             ; 8042 A4 2C                    .,
        lda     L8522,y                         ; 8044 B9 22 85                 .".
        sta     $10                             ; 8047 85 10                    ..
        lda     #$00                            ; 8049 A9 00                    ..
        sta     $FC                             ; 804B 85 FC                    ..
        sta     $FA                             ; 804D 85 FA                    ..
        sta     $99                             ; 804F 85 99                    ..
        sta     $23                             ; 8051 85 23                    .#
        jsr     redraw_screen_banksafe                           ; 8053 20 FC DA                  ..
        ldy     #$05                            ; 8056 A0 05                    ..
L8058:  lda     $EA,y                           ; 8058 B9 EA 00                 ...
        sta     $07AA,y                         ; 805B 99 AA 07                 ...
        lda     L8524,y                         ; 805E B9 24 85                 .$.
        sta     $EA,y                           ; 8061 99 EA 00                 ...
        dey                                     ; 8064 88                       .
        bpl     L8058                           ; 8065 10 F1                    ..
        ldy     #$1F                            ; 8067 A0 1F                    ..
L8069:  lda     $0620,y                         ; 8069 B9 20 06                 . .
        sta     $07B0,y                         ; 806C 99 B0 07                 ...
        lda     L852A,y                         ; 806F B9 2A 85                 .*.
        sta     $0620,y                         ; 8072 99 20 06                 . .
        dey                                     ; 8075 88                       .
        bpl     L8069                           ; 8076 10 F1                    ..
        ldy     #$04                            ; 8078 A0 04                    ..
L807A:  jsr     entity_wipe_y                           ; 807A 20 FE F2                  ..
        dey                                     ; 807D 88                       .
        bne     L807A                           ; 807E D0 FA                    ..
        jsr     L82FE                           ; 8080 20 FE 82                  ..
        jsr     L8403                           ; 8083 20 03 84                  ..
        jsr     L8488                           ; 8086 20 88 84                  ..
        jsr     L8437                           ; 8089 20 37 84                  7.
        jsr     L84E9                           ; 808C 20 E9 84                  ..
        ldx     #$00                            ; 808F A2 00                    ..
        jsr     L8375                           ; 8091 20 75 83                  u.
        lda     $2C                             ; 8094 A5 2C                    .,
        sta     $FD                             ; 8096 85 FD                    ..
        inc     $FD                             ; 8098 E6 FD                    ..
        jsr     frame_wait                           ; 809A 20 22 FF                  ".
        jsr     enable_rendering                           ; 809D 20 DB C2                  ..
        jsr     palette_fade_in                           ; 80A0 20 EB C3                  ..

; --- main loop: Start/A ($14 & $90) exits to L8140; d-pad moves the
; cursor over OWNED weapons only (meter $B0+L8594[cursor] bit 7), with
; L858A/L858B step/wrap tables; a move plays sound $27 and redraws the
; old row normal (L834A) + new row highlighted (L8375) ---
L80A3:  lda     $14                             ; 80A3 A5 14                    ..
        and     #$90                            ; 80A5 29 90                    ).
        beq     L80AC                           ; 80A7 F0 03                    ..
        jmp     L8140                           ; 80A9 4C 40 81                 L@.
; ----------------------------------------------------------------------------
L80AC:  lda     $50                             ; 80AC A5 50                    .P
        sta     $00                             ; 80AE 85 00                    ..
        lda     $14                             ; 80B0 A5 14                    ..
        and     #$0F                            ; 80B2 29 0F                    ).
        beq     L811F                           ; 80B4 F0 69                    .i
        and     #$03                            ; 80B6 29 03                    ).
        beq     L80E1                           ; 80B8 F0 27                    .'
        and     #$02                            ; 80BA 29 02                    ).
        tay                                     ; 80BC A8                       .
        lda     $50                             ; 80BD A5 50                    .P
        clc                                     ; 80BF 18                       .
        adc     L858A,y                         ; 80C0 79 8A 85                 y..
        sta     $50                             ; 80C3 85 50                    .P
        cmp     #$10                            ; 80C5 C9 10                    ..
        bcc     L80CF                           ; 80C7 90 06                    ..
        clc                                     ; 80C9 18                       .
        adc     L858B,y                         ; 80CA 79 8B 85                 y..
        sta     $50                             ; 80CD 85 50                    .P
L80CF:  ldx     $50                             ; 80CF A6 50                    .P
        lda     L8594,x                         ; 80D1 BD 94 85                 ...
        tax                                     ; 80D4 AA                       .
        lda     $B0,x                           ; 80D5 B5 B0                    ..
        bmi     L80E1                           ; 80D7 30 08                    0.
        ldy     #$04                            ; 80D9 A0 04                    ..
        lda     $14                             ; 80DB A5 14                    ..
        and     #$0C                            ; 80DD 29 0C                    ).
        beq     L80E8                           ; 80DF F0 07                    ..
L80E1:  lda     $14                             ; 80E1 A5 14                    ..
        and     #$0C                            ; 80E3 29 0C                    ).
        beq     L811B                           ; 80E5 F0 34                    .4
        tay                                     ; 80E7 A8                       .
L80E8:  lda     $50                             ; 80E8 A5 50                    .P
        pha                                     ; 80EA 48                       H
        and     #$08                            ; 80EB 29 08                    ).
        sta     $01                             ; 80ED 85 01                    ..
        pla                                     ; 80EF 68                       h
        and     #$07                            ; 80F0 29 07                    ).
        clc                                     ; 80F2 18                       .
        adc     L858A,y                         ; 80F3 79 8A 85                 y..
        sta     $50                             ; 80F6 85 50                    .P
        cmp     #$08                            ; 80F8 C9 08                    ..
        bcc     L8102                           ; 80FA 90 06                    ..
        clc                                     ; 80FC 18                       .
        adc     L858B,y                         ; 80FD 79 8B 85                 y..
        sta     $50                             ; 8100 85 50                    .P
L8102:  lda     $50                             ; 8102 A5 50                    .P
        ora     $01                             ; 8104 05 01                    ..
        sta     $50                             ; 8106 85 50                    .P
        tax                                     ; 8108 AA                       .
        lda     L8594,x                         ; 8109 BD 94 85                 ...
        tax                                     ; 810C AA                       .
        lda     $B0,x                           ; 810D B5 B0                    ..
        bpl     L80E8                           ; 810F 10 D7                    ..
        lda     $14                             ; 8111 A5 14                    ..
        and     #$0C                            ; 8113 29 0C                    ).
        bne     L811B                           ; 8115 D0 04                    ..
        cpx     #$0D                            ; 8117 E0 0D                    ..
        bcs     L80E8                           ; 8119 B0 CD                    ..
L811B:  ldy     $00                             ; 811B A4 00                    ..
        cpy     $50                             ; 811D C4 50                    .P
L811F:  beq     L8137                           ; 811F F0 16                    ..
        lda     #$27                            ; 8121 A9 27                    .'
        jsr     queue_sound                           ; 8123 20 5D EC                  ].
L8126:  jsr     L834A                           ; 8126 20 4A 83                  J.
        lda     #$FF                            ; 8129 A9 FF                    ..
        sta     $18                             ; 812B 85 18                    ..
        lda     $50                             ; 812D A5 50                    .P
        and     #$07                            ; 812F 29 07                    ).
        cmp     #$06                            ; 8131 C9 06                    ..
        bne     L8137                           ; 8133 D0 02                    ..
        sta     $50                             ; 8135 85 50                    .P
L8137:  jsr     L8309                           ; 8137 20 09 83                  ..
        jsr     frame_wait                           ; 813A 20 22 FF                  ".
        jmp     L80A3                           ; 813D 4C A3 80                 L..
; ----------------------------------------------------------------------------

; --- select/exit: cursor $07 = E-TANK (count $BD; refill HP unless empty/
; full, one step per 4 frames with sound $26), cursor $0F = M-TANK (below),
; anything else = close the menu and switch weapons (L819E) ---
L8140:  lda     $50                             ; 8140 A5 50                    .P
        cmp     #$0F                            ; 8142 C9 0F                    ..
        beq     L8164                           ; 8144 F0 1E                    ..
        cmp     #$07                            ; 8146 C9 07                    ..
        bne     L819E                           ; 8148 D0 54                    .T
        lda     $BD                             ; 814A A5 BD                    ..
        cmp     #$80                            ; 814C C9 80                    ..
        beq     L8137                           ; 814E F0 E7                    ..
        lda     $B0                             ; 8150 A5 B0                    ..
        cmp     #$9C                            ; 8152 C9 9C                    ..
        beq     L8137                           ; 8154 F0 E1                    ..
        dec     $BD                             ; 8156 C6 BD                    ..
        ldy     #$00                            ; 8158 A0 00                    ..
        sty     $50                             ; 815A 84 50                    .P
        jsr     L8235                           ; 815C 20 35 82                  5.
        ldy     #$07                            ; 815F A0 07                    ..
        jmp     L8126                           ; 8161 4C 26 81                 L&.
; ----------------------------------------------------------------------------

; --- M-TANK (count $BE): sound $24, refill EVERY owned meter (L82BA one
; step per pass). If every meter is already full: run bank $08's pickup
; sweep (LA3B0, mapped at $A000 as the pair partner) and, if it reports
; clear ($02 = 0), grant a 1-UP (lives $BF, capped at 9) — the M-tank
; easter egg. L82CE redraws the count/lives digits ---
L8164:  lda     $BE                             ; 8164 A5 BE                    ..
        cmp     #$80                            ; 8166 C9 80                    ..
        beq     L8137                           ; 8168 F0 CD                    ..
        lda     #$24                            ; 816A A9 24                    .$
        jsr     queue_sound                           ; 816C 20 5D EC                  ].
        ldy     #$0C                            ; 816F A0 0C                    ..
L8171:  lda     $B0,y                           ; 8171 B9 B0 00                 ...
        bpl     L8180                           ; 8174 10 0A                    ..
        cmp     #$9C                            ; 8176 C9 9C                    ..
        beq     L8180                           ; 8178 F0 06                    ..
        jsr     L82BA                           ; 817A 20 BA 82                  ..
        jmp     L8192                           ; 817D 4C 92 81                 L..
; ----------------------------------------------------------------------------
L8180:  dey                                     ; 8180 88                       .
        bpl     L8171                           ; 8181 10 EE                    ..
        jsr     LA3B0                           ; 8183 20 B0 A3                  ..
        lda     $02                             ; 8186 A5 02                    ..
        bne     L8192                           ; 8188 D0 08                    ..
        lda     $BF                             ; 818A A5 BF                    ..
        cmp     #$09                            ; 818C C9 09                    ..
        beq     L8192                           ; 818E F0 02                    ..
        inc     $BF                             ; 8190 E6 BF                    ..
L8192:  jsr     L82CE                           ; 8192 20 CE 82                  ..
        lda     #$00                            ; 8195 A9 00                    ..
        sta     $50                             ; 8197 85 50                    .P
        ldy     #$0F                            ; 8199 A0 0F                    ..
        jmp     L8126                           ; 819B 4C 26 81                 L&.
; ----------------------------------------------------------------------------

; --- close: sound $28, fade out, restore the saved context/CHR/palette,
; redraw the stage screen, then equip: $32/$2E = L85E1[cursor] (weapon id,
; |$80 into the HUD state when not the buster), R3 sprite CHR $ED =
; L85F1[cursor]. If the player is mid-slide (sub_type $B0) and the new
; weapon isn't Charge Kick ($08), reset the pose to sub_type $10 ---
L819E:  lda     #$28                            ; 819E A9 28                    .(
        jsr     queue_sound                           ; 81A0 20 5D EC                  ].
        jsr     palette_fade_out                           ; 81A3 20 F1 C3                  ..
        jsr     oam_clear                           ; 81A6 20 8F C3                  ..
        jsr     frame_wait                           ; 81A9 20 22 FF                  ".
        jsr     disable_rendering                           ; 81AC 20 D1 C2                  ..
        lda     $07A2                           ; 81AF AD A2 07                 ...
        sta     $27                             ; 81B2 85 27                    .'
        lda     $07A3                           ; 81B4 AD A3 07                 ...
        sta     $26                             ; 81B7 85 26                    .&
        lda     $07A4                           ; 81B9 AD A4 07                 ...
        sta     $FC                             ; 81BC 85 FC                    ..
        lda     $07A5                           ; 81BE AD A5 07                 ...
        sta     $FD                             ; 81C1 85 FD                    ..
        lda     $07A6                           ; 81C3 AD A6 07                 ...
        sta     $FA                             ; 81C6 85 FA                    ..
        lda     $07A7                           ; 81C8 AD A7 07                 ...
        sta     $FB                             ; 81CB 85 FB                    ..
        lda     $07A8                           ; 81CD AD A8 07                 ...
        sta     $23                             ; 81D0 85 23                    .#
        lda     $07A9                           ; 81D2 AD A9 07                 ...
        sta     $99                             ; 81D5 85 99                    ..
        ldy     #$05                            ; 81D7 A0 05                    ..
L81D9:  lda     $07AA,y                         ; 81D9 B9 AA 07                 ...
        sta     $EA,y                           ; 81DC 99 EA 00                 ...
        dey                                     ; 81DF 88                       .
        bpl     L81D9                           ; 81E0 10 F7                    ..
        ldy     #$1F                            ; 81E2 A0 1F                    ..
L81E4:  lda     $07B0,y                         ; 81E4 B9 B0 07                 ...
        sta     $0620,y                         ; 81E7 99 20 06                 . .
        dey                                     ; 81EA 88                       .
        bpl     L81E4                           ; 81EB 10 F7                    ..
        ldy     $2C                             ; 81ED A4 2C                    .,
        lda     L8522,y                         ; 81EF B9 22 85                 .".
        sta     $10                             ; 81F2 85 10                    ..
        jsr     redraw_screen_banksafe                           ; 81F4 20 FC DA                  ..
        jsr     frame_wait                           ; 81F7 20 22 FF                  ".
        ldy     $50                             ; 81FA A4 50                    .P
        lda     L85E1,y                         ; 81FC B9 E1 85                 ...
        sta     $32                             ; 81FF 85 32                    .2
        sta     $2E                             ; 8201 85 2E                    ..
        beq     L8209                           ; 8203 F0 04                    ..
        ora     #$80                            ; 8205 09 80                    ..
        sta     $2E                             ; 8207 85 2E                    ..
L8209:  lda     L85F1,y                         ; 8209 B9 F1 85                 ...
        sta     $ED                             ; 820C 85 ED                    ..
        jsr     enable_rendering                           ; 820E 20 DB C2                  ..
        jsr     palette_fade_in                           ; 8211 20 EB C3                  ..
        ldx     #$00                            ; 8214 A2 00                    ..
        stx     $1B                             ; 8216 86 1B                    ..
        stx     $59                             ; 8218 86 59                    .Y
        inc     $95                             ; 821A E6 95                    ..
        ldy     $32                             ; 821C A4 32                    .2
        beq     L8222                           ; 821E F0 02                    ..
        stx     $38                             ; 8220 86 38                    .8
L8222:  lda     $0558                           ; 8222 AD 58 05                 .X.
        cmp     #$B0                            ; 8225 C9 B0                    ..
        bne     L8234                           ; 8227 D0 0B                    ..
        lda     $32                             ; 8229 A5 32                    .2
        cmp     #$08                            ; 822B C9 08                    ..
        beq     L8234                           ; 822D F0 05                    ..
        lda     #$10                            ; 822F A9 10                    ..
        jsr     entity_set_subtype                           ; 8231 20 98 EA                  ..
L8234:  rts                                     ; 8234 60                       `
; ----------------------------------------------------------------------------

; --- E-tank refill: build the meter packet (L87D7 template + per-meter
; PPU addr L87BD/L87CA), digits from $BD/$BE; L8275 loop: ++meter, redraw
; ticks (L846A), sound $26, wait 4 frames, until $9C (full) ---
L8235:  ldx     #$12                            ; 8235 A2 12                    ..
L8237:  lda     L87D7,x                         ; 8237 BD D7 87                 ...
        sta     $0780,x                         ; 823A 9D 80 07                 ...
        dex                                     ; 823D CA                       .
        bpl     L8237                           ; 823E 10 F7                    ..
        ldx     $2C                             ; 8240 A6 2C                    .,
        lda     L87BD,y                         ; 8242 B9 BD 87                 ...
        ora     L8522,x                         ; 8245 1D 22 85                 .".
        sta     $0780                           ; 8248 8D 80 07                 ...
        lda     L87CA,y                         ; 824B B9 CA 87                 ...
        sta     $0781                           ; 824E 8D 81 07                 ...
        lda     $078A                           ; 8251 AD 8A 07                 ...
        ora     L8522,x                         ; 8254 1D 22 85                 .".
        sta     $078A                           ; 8257 8D 8A 07                 ...
        lda     $078E                           ; 825A AD 8E 07                 ...
        ora     L8522,x                         ; 825D 1D 22 85                 .".
        sta     $078E                           ; 8260 8D 8E 07                 ...
        lda     $BD                             ; 8263 A5 BD                    ..
        and     #$0F                            ; 8265 29 0F                    ).
        ora     #$B0                            ; 8267 09 B0                    ..
        sta     $078D                           ; 8269 8D 8D 07                 ...
        lda     $BE                             ; 826C A5 BE                    ..
        and     #$0F                            ; 826E 29 0F                    ).
        ora     #$B0                            ; 8270 09 B0                    ..
        sta     $0791                           ; 8272 8D 91 07                 ...
L8275:  lda     $B0,y                           ; 8275 B9 B0 00                 ...
        clc                                     ; 8278 18                       .
        adc     #$01                            ; 8279 69 01                    i.
        sta     $B0,y                           ; 827B 99 B0 00                 ...
        and     #$1F                            ; 827E 29 1F                    ).
        sta     $01                             ; 8280 85 01                    ..
        jsr     L846A                           ; 8282 20 6A 84                  j.
        cpy     #$00                            ; 8285 C0 00                    ..
        bne     L82A6                           ; 8287 D0 1D                    ..
        ldx     #$09                            ; 8289 A2 09                    ..
L828B:  lda     $0780,x                         ; 828B BD 80 07                 ...
        sta     $0792,x                         ; 828E 9D 92 07                 ...
        dex                                     ; 8291 CA                       .
        bpl     L828B                           ; 8292 10 F7                    ..
        stx     $079C                           ; 8294 8E 9C 07                 ...
        lda     #$70                            ; 8297 A9 70                    .p
        sta     $0793                           ; 8299 8D 93 07                 ...
        lda     $0780                           ; 829C AD 80 07                 ...
        and     #$2C                            ; 829F 29 2C                    ),
        ora     #$23                            ; 82A1 09 23                    .#
        sta     $0792                           ; 82A3 8D 92 07                 ...
L82A6:  dec     $19                             ; 82A6 C6 19                    ..
        lda     #$26                            ; 82A8 A9 26                    .&
        jsr     queue_sound                           ; 82AA 20 5D EC                  ].
        lda     #$04                            ; 82AD A9 04                    ..
        jsr     LFF24                           ; 82AF 20 24 FF                  $.
        lda     $B0,y                           ; 82B2 B9 B0 00                 ...
        cmp     #$9C                            ; 82B5 C9 9C                    ..
        bne     L8275                           ; 82B7 D0 BC                    ..
        rts                                     ; 82B9 60                       `
; ----------------------------------------------------------------------------

; --- one refill step for every owned, non-full meter ($B0-$BC) ---
L82BA:  ldy     #$00                            ; 82BA A0 00                    ..
L82BC:  lda     $B0,y                           ; 82BC B9 B0 00                 ...
        bpl     L82C8                           ; 82BF 10 07                    ..
        cmp     #$9C                            ; 82C1 C9 9C                    ..
        beq     L82C8                           ; 82C3 F0 03                    ..
        jsr     L8235                           ; 82C5 20 35 82                  5.
L82C8:  iny                                     ; 82C8 C8                       .
        cpy     #$0D                            ; 82C9 C0 0D                    ..
        bne     L82BC                           ; 82CB D0 EF                    ..
        rts                                     ; 82CD 60                       `
; ----------------------------------------------------------------------------

; --- M-tank use: packet L87EA, --$BE, digits $BE/$BF, flag the flush ---
L82CE:  ldy     #$08                            ; 82CE A0 08                    ..
L82D0:  lda     L87EA,y                         ; 82D0 B9 EA 87                 ...
        sta     $0780,y                         ; 82D3 99 80 07                 ...
        dey                                     ; 82D6 88                       .
        bpl     L82D0                           ; 82D7 10 F7                    ..
        dec     $BE                             ; 82D9 C6 BE                    ..
        lda     $BE                             ; 82DB A5 BE                    ..
        and     #$0F                            ; 82DD 29 0F                    ).
        ora     #$B0                            ; 82DF 09 B0                    ..
        sta     $0783                           ; 82E1 8D 83 07                 ...
        ldx     $2C                             ; 82E4 A6 2C                    .,
        lda     $0780                           ; 82E6 AD 80 07                 ...
        ora     L8522,x                         ; 82E9 1D 22 85                 .".
        sta     $0780                           ; 82EC 8D 80 07                 ...
        sta     $0784                           ; 82EF 8D 84 07                 ...
        lda     $BF                             ; 82F2 A5 BF                    ..
        ora     #$B0                            ; 82F4 09 B0                    ..
        sta     $0787                           ; 82F6 8D 87 07                 ...
        sty     $19                             ; 82F9 84 19                    ..
        jmp     frame_wait                           ; 82FB 4C 22 FF                 L".
; ----------------------------------------------------------------------------

; --- cursor sprites: base OAM frame from L8601, then the per-cursor
; icon records L8621[L8611[cursor]] = [count, R3 CHR bank -> $ED, then
; Y/tile/attr/X quads]; pad OAM to $023C with $F8 ---
L82FE:  ldx     #$0F                            ; 82FE A2 0F                    ..
L8300:  lda     L8601,x                         ; 8300 BD 01 86                 ...
        sta     $0200,x                         ; 8303 9D 00 02                 ...
        dex                                     ; 8306 CA                       .
        bpl     L8300                           ; 8307 10 F7                    ..
L8309:  ldx     $50                             ; 8309 A6 50                    .P
        ldy     L8611,x                         ; 830B BC 11 86                 ...
        lda     L8621,y                         ; 830E B9 21 86                 .!.
        sta     $00                             ; 8311 85 00                    ..
        lda     L8622,y                         ; 8313 B9 22 86                 .".
        sta     $ED                             ; 8316 85 ED                    ..
        ldx     #$10                            ; 8318 A2 10                    ..
L831A:  lda     L8623,y                         ; 831A B9 23 86                 .#.
        sta     $0200,x                         ; 831D 9D 00 02                 ...
        lda     L8624,y                         ; 8320 B9 24 86                 .$.
        sta     $0201,x                         ; 8323 9D 01 02                 ...
        lda     L8625,y                         ; 8326 B9 25 86                 .%.
        sta     $0202,x                         ; 8329 9D 02 02                 ...
        lda     L8626,y                         ; 832C B9 26 86                 .&.
        sta     $0203,x                         ; 832F 9D 03 02                 ...
        iny                                     ; 8332 C8                       .
        iny                                     ; 8333 C8                       .
        iny                                     ; 8334 C8                       .
        iny                                     ; 8335 C8                       .
L8336:  inx                                     ; 8336 E8                       .
        inx                                     ; 8337 E8                       .
        inx                                     ; 8338 E8                       .
        inx                                     ; 8339 E8                       .
        dec     $00                             ; 833A C6 00                    ..
        bpl     L831A                           ; 833C 10 DC                    ..
        cpx     #$3C                            ; 833E E0 3C                    .<
        beq     L8349                           ; 8340 F0 07                    ..
        lda     #$F8                            ; 8342 A9 F8                    ..
        sta     $0200,x                         ; 8344 9D 00 02                 ...
        bne     L8336                           ; 8347 D0 ED                    ..
L8349:  rts                                     ; 8349 60                       `
; ----------------------------------------------------------------------------

; --- weapon-name rows: L834A redraws row Y normal; falls into L8375 =
; draw the CURRENT row with the highlight tile mask (L8722), append the
; energy-tick row (L87B2 + $88 full / $84|rem tiles), and load the
; cursor's swatch colors (L854B+cursor*4) into sprite palette row 4 ---
L834A:  lda     L86B1,y                         ; 834A B9 B1 86                 ...
        tay                                     ; 834D A8                       .
        ldx     #$00                            ; 834E A2 00                    ..
        lda     L86C1,y                         ; 8350 B9 C1 86                 ...
        ora     $10                             ; 8353 05 10                    ..
        sta     $0780,x                         ; 8355 9D 80 07                 ...
        lda     L86C2,y                         ; 8358 B9 C2 86                 ...
        sta     $0781,x                         ; 835B 9D 81 07                 ...
        lda     L86C3,y                         ; 835E B9 C3 86                 ...
        sta     $0782,x                         ; 8361 9D 82 07                 ...
        sta     $02                             ; 8364 85 02                    ..
L8366:  lda     L86C4,y                         ; 8366 B9 C4 86                 ...
        sta     $0783,x                         ; 8369 9D 83 07                 ...
        iny                                     ; 836C C8                       .
        inx                                     ; 836D E8                       .
        dec     $02                             ; 836E C6 02                    ..
        bpl     L8366                           ; 8370 10 F4                    ..
        inx                                     ; 8372 E8                       .
        inx                                     ; 8373 E8                       .
        inx                                     ; 8374 E8                       .
L8375:  ldy     $50                             ; 8375 A4 50                    .P
        lda     L86B1,y                         ; 8377 B9 B1 86                 ...
        tay                                     ; 837A A8                       .
        lda     L86C1,y                         ; 837B B9 C1 86                 ...
        ora     $10                             ; 837E 05 10                    ..
        sta     $0780,x                         ; 8380 9D 80 07                 ...
        lda     L86C2,y                         ; 8383 B9 C2 86                 ...
        sta     $0781,x                         ; 8386 9D 81 07                 ...
        lda     L86C3,y                         ; 8389 B9 C3 86                 ...
        sta     $0782,x                         ; 838C 9D 82 07                 ...
        sta     $02                             ; 838F 85 02                    ..
L8391:  lda     L86C4,y                         ; 8391 B9 C4 86                 ...
        ora     L8722,y                         ; 8394 19 22 87                 .".
        sta     $0783,x                         ; 8397 9D 83 07                 ...
        iny                                     ; 839A C8                       .
        inx                                     ; 839B E8                       .
        dec     $02                             ; 839C C6 02                    ..
        bpl     L8391                           ; 839E 10 F1                    ..
        stx     $02                             ; 83A0 86 02                    ..
        ldy     #$00                            ; 83A2 A0 00                    ..
L83A4:  lda     L87B2,y                         ; 83A4 B9 B2 87                 ...
        sta     $0783,x                         ; 83A7 9D 83 07                 ...
        inx                                     ; 83AA E8                       .
        iny                                     ; 83AB C8                       .
        cpy     #$0B                            ; 83AC C0 0B                    ..
        bne     L83A4                           ; 83AE D0 F4                    ..
        ldy     $50                             ; 83B0 A4 50                    .P
        ldx     L85E1,y                         ; 83B2 BE E1 85                 ...
        lda     $B0,x                           ; 83B5 B5 B0                    ..
        and     #$1F                            ; 83B7 29 1F                    ).
        sta     $01                             ; 83B9 85 01                    ..
        ldx     $02                             ; 83BB A6 02                    ..
        lda     $0783,x                         ; 83BD BD 83 07                 ...
        ora     $10                             ; 83C0 05 10                    ..
        sta     $0783,x                         ; 83C2 9D 83 07                 ...
        lda     #$07                            ; 83C5 A9 07                    ..
        sta     $02                             ; 83C7 85 02                    ..
L83C9:  lda     $01                             ; 83C9 A5 01                    ..
        sec                                     ; 83CB 38                       8
        sbc     #$04                            ; 83CC E9 04                    ..
        bcc     L83DE                           ; 83CE 90 0E                    ..
        sta     $01                             ; 83D0 85 01                    ..
        lda     #$88                            ; 83D2 A9 88                    ..
        sta     $0786,x                         ; 83D4 9D 86 07                 ...
        inx                                     ; 83D7 E8                       .
        dec     $02                             ; 83D8 C6 02                    ..
        bne     L83C9                           ; 83DA D0 ED                    ..
        beq     L83E5                           ; 83DC F0 07                    ..
L83DE:  lda     $01                             ; 83DE A5 01                    ..
        ora     #$84                            ; 83E0 09 84                    ..
        sta     $0786,x                         ; 83E2 9D 86 07                 ...
L83E5:  lda     #$FF                            ; 83E5 A9 FF                    ..
        sta     $19                             ; 83E7 85 19                    ..
        lda     $50                             ; 83E9 A5 50                    .P
        asl     a                               ; 83EB 0A                       .
        asl     a                               ; 83EC 0A                       .
        tay                                     ; 83ED A8                       .
        ldx     #$00                            ; 83EE A2 00                    ..
L83F0:  lda     L854B,y                         ; 83F0 B9 4B 85                 .K.
        sta     $0611,x                         ; 83F3 9D 11 06                 ...
        sta     $0631,x                         ; 83F6 9D 31 06                 .1.
        sta     $07C1,x                         ; 83F9 9D C1 07                 ...
        iny                                     ; 83FC C8                       .
        inx                                     ; 83FD E8                       .
        cpx     #$03                            ; 83FE E0 03                    ..
        bne     L83F0                           ; 8400 D0 EE                    ..
        rts                                     ; 8402 60                       `
; ----------------------------------------------------------------------------

; --- blank the name rows of unowned weapons (menu layout pre-draws all
; 12: L877D blank packets at L879A/L87A6[weapon]) ---
L8403:  ldy     #$1C                            ; 8403 A0 1C                    ..
L8405:  lda     L877D,y                         ; 8405 B9 7D 87                 .}.
        sta     $0780,y                         ; 8408 99 80 07                 ...
        dey                                     ; 840B 88                       .
        bpl     L8405                           ; 840C 10 F7                    ..
        ldy     #$0B                            ; 840E A0 0B                    ..
        sty     $00                             ; 8410 84 00                    ..
L8412:  ldy     $00                             ; 8412 A4 00                    ..
        lda     $B0,y                           ; 8414 B9 B0 00                 ...
        bmi     L8432                           ; 8417 30 19                    0.
        lda     L879A,y                         ; 8419 B9 9A 87                 ...
        ora     $10                             ; 841C 05 10                    ..
        sta     $0780                           ; 841E 8D 80 07                 ...
        sta     $078E                           ; 8421 8D 8E 07                 ...
        lda     L87A6,y                         ; 8424 B9 A6 87                 ...
        sta     $0781                           ; 8427 8D 81 07                 ...
        ora     #$20                            ; 842A 09 20                    . 
        sta     $078F                           ; 842C 8D 8F 07                 ...
        jsr     nametable_flush                           ; 842F 20 98 C2                  ..
L8432:  dec     $00                             ; 8432 C6 00                    ..
        bpl     L8412                           ; 8434 10 DC                    ..
        rts                                     ; 8436 60                       `
; ----------------------------------------------------------------------------

; --- energy bars for every owned meter ($B0-$BC): packet L87B2 at
; L87BD/L87CA[meter], ticks = energy/4 x $88 + remainder | $84 ---
L8437:  ldy     #$0C                            ; 8437 A0 0C                    ..
        sty     $00                             ; 8439 84 00                    ..
L843B:  ldy     $00                             ; 843B A4 00                    ..
        lda     $B0,y                           ; 843D B9 B0 00                 ...
        bpl     L844C                           ; 8440 10 0A                    ..
        and     #$1F                            ; 8442 29 1F                    ).
        sta     $01                             ; 8444 85 01                    ..
        jsr     L8451                           ; 8446 20 51 84                  Q.
        jsr     nametable_flush                           ; 8449 20 98 C2                  ..
L844C:  dec     $00                             ; 844C C6 00                    ..
        bpl     L843B                           ; 844E 10 EB                    ..
        rts                                     ; 8450 60                       `
; ----------------------------------------------------------------------------
L8451:  ldx     #$0A                            ; 8451 A2 0A                    ..
L8453:  lda     L87B2,x                         ; 8453 BD B2 87                 ...
        sta     $0780,x                         ; 8456 9D 80 07                 ...
        dex                                     ; 8459 CA                       .
        bpl     L8453                           ; 845A 10 F7                    ..
        lda     L87BD,y                         ; 845C B9 BD 87                 ...
        ora     $10                             ; 845F 05 10                    ..
        sta     $0780                           ; 8461 8D 80 07                 ...
        lda     L87CA,y                         ; 8464 B9 CA 87                 ...
        sta     $0781                           ; 8467 8D 81 07                 ...
L846A:  ldx     #$00                            ; 846A A2 00                    ..
L846C:  lda     $01                             ; 846C A5 01                    ..
        sec                                     ; 846E 38                       8
        sbc     #$04                            ; 846F E9 04                    ..
        bcc     L8480                           ; 8471 90 0D                    ..
        sta     $01                             ; 8473 85 01                    ..
        lda     #$88                            ; 8475 A9 88                    ..
        sta     $0783,x                         ; 8477 9D 83 07                 ...
        inx                                     ; 847A E8                       .
        cpx     #$07                            ; 847B E0 07                    ..
        bne     L846C                           ; 847D D0 ED                    ..
        rts                                     ; 847F 60                       `
; ----------------------------------------------------------------------------
L8480:  lda     $01                             ; 8480 A5 01                    ..
        ora     #$84                            ; 8482 09 84                    ..
        sta     $0783,x                         ; 8484 9D 83 07                 ...
L8487:  rts                                     ; 8487 60                       `
; ----------------------------------------------------------------------------

; --- items row: Beat not owned -> recolor the collected MEGAMAN-V
; letters via attribute packet L85CC (one quadrant per $6D bit); Beat
; owned ($BC bit 7) -> draw the BEAT row + meter (L85A4/L85B8) ---
L8488:  lda     $BC                             ; 8488 A5 BC                    ..
        bmi     L84BF                           ; 848A 30 33                    03
        lda     $6D                             ; 848C A5 6D                    .m
        beq     L8487                           ; 848E F0 F7                    ..
        sta     $00                             ; 8490 85 00                    ..
        ldy     #$07                            ; 8492 A0 07                    ..
L8494:  lda     L85CC,y                         ; 8494 B9 CC 85                 ...
        sta     $0780,y                         ; 8497 99 80 07                 ...
        dey                                     ; 849A 88                       .
        bpl     L8494                           ; 849B 10 F7                    ..
        ldy     #$00                            ; 849D A0 00                    ..
L849F:  lsr     $00                             ; 849F 46 00                    F.
        bcc     L84B8                           ; 84A1 90 15                    ..
        lda     #$30                            ; 84A3 A9 30                    .0
        sta     $01                             ; 84A5 85 01                    ..
        tya                                     ; 84A7 98                       .
        lsr     a                               ; 84A8 4A                       J
        tax                                     ; 84A9 AA                       .
        bcc     L84B0                           ; 84AA 90 04                    ..
        lda     #$C0                            ; 84AC A9 C0                    ..
        sta     $01                             ; 84AE 85 01                    ..
L84B0:  lda     $0783,x                         ; 84B0 BD 83 07                 ...
        ora     $01                             ; 84B3 05 01                    ..
        sta     $0783,x                         ; 84B5 9D 83 07                 ...
L84B8:  iny                                     ; 84B8 C8                       .
        lda     $00                             ; 84B9 A5 00                    ..
        bne     L849F                           ; 84BB D0 E2                    ..
        beq     L84DE                           ; 84BD F0 1F                    ..
L84BF:  lda     $BC                             ; 84BF A5 BC                    ..
        ora     #$80                            ; 84C1 09 80                    ..
        sta     $BC                             ; 84C3 85 BC                    ..
        ldy     #$13                            ; 84C5 A0 13                    ..
L84C7:  lda     L85A4,y                         ; 84C7 B9 A4 85                 ...
        sta     $0780,y                         ; 84CA 99 80 07                 ...
        dey                                     ; 84CD 88                       .
        bpl     L84C7                           ; 84CE 10 F7                    ..
        jsr     L84DE                           ; 84D0 20 DE 84                  ..
        ldy     #$13                            ; 84D3 A0 13                    ..
L84D5:  lda     L85B8,y                         ; 84D5 B9 B8 85                 ...
        sta     $0780,y                         ; 84D8 99 80 07                 ...
        dey                                     ; 84DB 88                       .
        bpl     L84D5                           ; 84DC 10 F7                    ..
L84DE:  lda     $0780                           ; 84DE AD 80 07                 ...
        ora     $10                             ; 84E1 05 10                    ..
        sta     $0780                           ; 84E3 8D 80 07                 ...
        jmp     nametable_flush                           ; 84E6 4C 98 C2                 L..
; ----------------------------------------------------------------------------

; --- E-tank / M-tank / lives digits (packets L85D4, tiles $B0|count) ---
L84E9:  ldy     #$0C                            ; 84E9 A0 0C                    ..
L84EB:  lda     L85D4,y                         ; 84EB B9 D4 85                 ...
        sta     $0780,y                         ; 84EE 99 80 07                 ...
        dey                                     ; 84F1 88                       .
        bpl     L84EB                           ; 84F2 10 F7                    ..
        lda     $BD                             ; 84F4 A5 BD                    ..
        and     #$0F                            ; 84F6 29 0F                    ).
        ora     #$B0                            ; 84F8 09 B0                    ..
        sta     $0783                           ; 84FA 8D 83 07                 ...
        lda     $BE                             ; 84FD A5 BE                    ..
        and     #$0F                            ; 84FF 29 0F                    ).
        ora     #$B0                            ; 8501 09 B0                    ..
        sta     $0787                           ; 8503 8D 87 07                 ...
        lda     $BF                             ; 8506 A5 BF                    ..
        and     #$0F                            ; 8508 29 0F                    ).
        ora     #$B0                            ; 850A 09 B0                    ..
        sta     $078B                           ; 850C 8D 8B 07                 ...
        lda     $0784                           ; 850F AD 84 07                 ...
        ora     $10                             ; 8512 05 10                    ..
        sta     $0784                           ; 8514 8D 84 07                 ...
        lda     $0788                           ; 8517 AD 88 07                 ...
        ora     $10                             ; 851A 05 10                    ..
        sta     $0788                           ; 851C 8D 88 07                 ...
        jmp     L84DE                           ; 851F 4C DE 84                 L..
; ----------------------------------------------------------------------------

; --- $8522: PPU-addr hi OR mask per mirror_shadow (visible nametable) ---
L8522:  .byte   $04,$08                         ; 8522
; --- $8524: menu CHR banks -> $EA-$EF shadows ---
L8524:  .byte   $CC,$CE,$00,$06,$00,$00         ; 8524
; --- $852A: menu master palette (32 bytes -> $0620) ---
L852A:  .byte   $0F,$20,$10,$00,$0F,$30,$37,$2C,$0F,$38,$2C,$11,$0F,$20,$27,$18 ; 852A
        .byte   $0F,$0F,$2C,$11,$0F,$0F,$20,$37,$0F,$0F,$00,$00,$0F,$0F,$00,$00 ; 853A
        .byte   $0F                             ; 854A
; --- $854B: weapon swatch colors, 4 bytes per cursor slot (3 used -> sprite
; palette row 4); also read by stage_load ($1E:D40E) to restore the equipped
; weapon's colors ($50 persists as the equipped cursor slot) ---
L854B:  .byte   $0F,$2C,$11,$0F,$0F,$20,$11,$0F,$0F,$20,$1A,$0F,$0F,$20,$2C,$0F ; 854B
        .byte   $0F,$27,$12,$0F,$0F,$2C,$11,$0F,$0F,$2C,$11,$0F,$0F,$2C,$11,$0F ; 855B
        .byte   $0F,$20,$07,$0F,$0F,$20,$14,$0F,$0F,$20,$26,$0F,$0F,$28,$17,$0F ; 856B
        .byte   $0F,$20,$16,$0F,$0F,$20,$16,$0F,$0F,$2C,$11,$0F,$0F,$2C,$11 ; 857B
; --- $858A/$858B: cursor step / wrap-correction per d-pad direction ---
L858A:  .byte   $08                             ; 858A
L858B:  .byte   $F0,$F8,$10,$01,$F8,$00,$00,$FF,$08 ; 858B
; --- $8594: cursor -> energy-meter index ($B0-$BC weapons/Beat, $BD E, $BE M) ---
L8594:  .byte   $00,$01,$02,$03,$04,$05,$0C,$0D,$06,$07,$08,$09,$0A,$0B,$0C,$0E ; 8594
; --- $85A4/$85B8: BEAT row + meter packets (Beat owned) ---
L85A4:  .byte   $22,$48,$0F,$00,$00,$8C,$8D,$00,$E1,$E4,$E0,$F0,$00,$00,$00,$00 ; 85A4
        .byte   $00,$00,$00,$FF                 ; 85B4
L85B8:  .byte   $22,$68,$0F,$00,$00,$9C,$9D,$00,$00,$84,$84,$84,$84,$84,$84,$84 ; 85B8
        .byte   $00,$00,$00,$FF                 ; 85C8
; --- $85CC: MEGAMAN-V letters attribute packet (recolor per $6D bit) ---
L85CC:  .byte   $23,$E2,$03,$00,$00,$00,$00,$FF ; 85CC
; --- $85D4: E-tank / M-tank / lives digit packets ---
L85D4:  .byte   $23,$46,$00,$00,$23,$4D,$00,$00,$23,$5D,$00,$00,$FF ; 85D4
; --- $85E1: cursor -> weapon id ($0C = Beat; $00 rows 7/$0F = tanks) ---
L85E1:  .byte   $00,$01,$02,$03,$04,$05,$0C,$00,$06,$07,$08,$09,$0A,$0B,$0C,$00 ; 85E1
; --- $85F1: cursor slot -> sprite CHR bank (R3 shadow $ED); also read by
; stage_load ($1E:D404) ---
L85F1:  .byte   $06,$48,$44,$45,$47,$04,$49,$07,$46,$07,$07,$47,$46,$46,$49,$07 ; 85F1
; --- $8601: cursor frame OAM (4 sprites) ---
L8601:  .byte   $BF,$4C,$00,$D0,$BF,$4C,$40,$D8,$C7,$4D,$01,$D0,$C7,$4D,$41,$D8 ; 8601
; --- $8611: cursor -> offset into the L8621 icon records ---
L8611:  .byte   $00,$00,$00,$00,$00,$00,$7A,$00,$00,$00,$00,$00,$26,$54,$7A,$00 ; 8611
; --- $8621: icon sprite records [count, R3 CHR bank, Y/tile/attr/X quads] ---
L8621:  .byte   $08                             ; 8621
L8622:  .byte   $04                             ; 8622
L8623:  .byte   $C5                             ; 8623
L8624:  .byte   $08                             ; 8624
L8625:  .byte   $41                             ; 8625
L8626:  .byte   $99,$BF,$01,$40,$94,$BF,$00,$40,$9C,$C7,$04,$40,$90,$C7,$03,$40 ; 8626
        .byte   $98,$C7,$02,$40,$A0,$CF,$07,$40,$90,$CF,$06,$40,$98,$CF,$05,$40 ; 8636
        .byte   $A0,$0A,$05,$C5,$78,$41,$9C,$BF,$66,$40,$9C,$BF,$65,$40,$A4,$C7 ; 8646
        .byte   $6B,$40,$8C,$C7,$6A,$40,$94,$C7,$69,$40,$9C,$C7,$68,$41,$A4,$CF ; 8656
        .byte   $67,$40,$8C,$CF,$79,$40,$94,$CF,$6D,$40,$9C,$CF,$6C,$40,$A4,$08 ; 8666
        .byte   $04,$CF,$79,$41,$A1,$C7,$73,$40,$8C,$C7,$72,$40,$94,$C7,$71,$40 ; 8676
        .byte   $9C,$C7,$70,$40,$A4,$CF,$77,$41,$8C,$CF,$76,$40,$94,$CF,$75,$40 ; 8686
        .byte   $9C,$CF,$74,$40,$A4,$04,$49,$CF,$74,$41,$9C,$C7,$66,$40,$94,$C7 ; 8696
        .byte   $65,$40,$9C,$CF,$68,$40,$94,$CF,$67,$40,$9C ; 86A6
; --- $86B1: cursor -> offset into the L86C1 name-row records ---
L86B1:  .byte   $00,$06,$0C,$12,$18,$1E,$57,$24,$29,$30,$37,$3E,$45,$4C,$57,$53 ; 86B1
; --- $86C1: weapon name-row packets [PPU hi, lo, len, tiles...] ---
L86C1:  .byte   $23                             ; 86C1
L86C2:  .byte   $C9                             ; 86C2
L86C3:  .byte   $02                             ; 86C3
L86C4:  .byte   $00,$00,$00,$23,$C9,$02,$00,$00,$00,$23,$D1,$02,$00,$00,$00,$23 ; 86C4
        .byte   $D1,$02,$00,$00,$00,$23,$D9,$02,$00,$00,$00,$23,$D9,$02,$00,$00 ; 86D4
        .byte   $00,$23,$F0,$01,$F3,$FC,$23,$CC,$03,$00,$00,$00,$CC,$23,$CC,$03 ; 86E4
        .byte   $00,$00,$00,$CC,$23,$D4,$03,$00,$00,$00,$CC,$23,$D4,$03,$00,$00 ; 86F4
        .byte   $00,$CC,$23,$DC,$03,$00,$00,$00,$CC,$23,$DC,$03,$00,$00,$00,$CC ; 8704
        .byte   $23,$F2,$00,$F3,$23,$E2,$03,$00,$00,$00,$00,$23,$C9,$02 ; 8714
; --- $8722: highlight tile OR masks (parallel to L86C1 tiles) ---
L8722:  .byte   $0A,$0A,$0A,$23,$C9,$02,$A0,$A0,$A0,$23,$D1,$02,$0A,$0A,$0A,$23 ; 8722
        .byte   $D1,$02,$A0,$A0,$A0,$23,$D9,$02,$0A,$0A,$0A,$23,$D9,$02,$A0,$A0 ; 8732
        .byte   $A0,$23,$F0,$01,$08,$02,$23,$CC,$03,$0A,$0A,$0A,$02,$23,$CC,$03 ; 8742
        .byte   $A0,$A0,$A0,$20,$23,$D4,$03,$0A,$0A,$0A,$02,$23,$D4,$03,$A0,$A0 ; 8752
        .byte   $A0,$20,$23,$DC,$03,$0A,$0A,$0A,$02,$23,$DC,$03,$A0,$A0,$A0,$20 ; 8762
        .byte   $23,$F2,$00,$08,$23,$E2,$03,$A0,$A0,$A0,$A0 ; 8772
; --- $877D: blank-row packet template (unowned weapon names) ---
L877D:  .byte   $20,$00,$0A,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$20,$00 ; 877D
        .byte   $0A,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$FF ; 878D
; --- $879A/$87A6: per-weapon name-row PPU addr hi/lo ---
L879A:  .byte   $20,$20,$21,$21,$21,$21,$20,$20,$21,$21,$21,$21 ; 879A
L87A6:  .byte   $84,$C4,$04,$44,$84,$C4,$92,$D2,$12,$52,$92,$D2 ; 87A6
; --- $87B2: energy-bar packet template ---
L87B2:  .byte   $23,$70,$06,$84,$84,$84,$84,$84,$84,$84,$FF ; 87B2
; --- $87BD/$87CA: per-meter energy-bar PPU addr hi/lo ---
L87BD:  .byte   $20,$20,$21,$21,$21,$21,$20,$20,$21,$21,$21,$21,$22 ; 87BD
L87CA:  .byte   $A8,$E8,$28,$68,$A8,$E8,$B6,$F6,$36,$76,$B6,$F6,$6E ; 87CA
; --- $87D7: E-tank refill packet template ---
L87D7:  .byte   $20,$00,$06,$84,$84,$84,$84,$84,$84,$84,$23,$46,$00,$00,$23,$4D ; 87D7
        .byte   $00,$00,$FF                     ; 87E7
; --- $87EA: M-tank use packet template ---
L87EA:  .byte   $23,$4D,$00,$00,$23,$5D,$00,$00,$FF,$55,$FF,$DF,$FF,$F7,$FF,$FD ; 87EA
        .byte   $EF,$7F,$FF,$7D,$FF,$55         ; 87FA

; --- $8800 (rt $A800): DAMAGE TABLE, weapon $1 (Water Wave) ---
; $A800[ent_type] via damage_engine $1C:809D; low 7 bits = damage,
; bit 7 = special handling; $00 = ricochet. Types $00-$CF.
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8800  types $00-$0F
        .byte   $01,$01,$01,$01,$01,$01,$01,$01,$01,$00,$01,$01,$01,$01,$00,$00 ; 8810  types $10-$1F
        .byte   $01,$01,$00,$00,$00,$01,$80,$00,$01,$01,$01,$01,$80,$80,$00,$00 ; 8820  types $20-$2F
        .byte   $00,$01,$01,$01,$01,$00,$01,$80,$00,$01,$03,$03,$80,$00,$01,$80 ; 8830  types $30-$3F
        .byte   $03,$00,$00,$00,$00,$00,$00,$80,$00,$00,$00,$00,$00,$00,$00,$00 ; 8840  types $40-$4F
        .byte   $01,$80,$01,$01,$01,$80,$01,$00,$80,$01,$01,$00,$05,$00,$00,$00 ; 8850  types $50-$5F
        .byte   $01,$80,$01,$01,$01,$01,$01,$01,$01,$01,$80,$01,$80,$00,$01,$80 ; 8860  types $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$80,$80 ; 8870  types $70-$7F
        .byte   $80,$01,$80,$01,$80,$80,$01,$80,$00,$01,$80,$80,$00,$04,$80,$80 ; 8880  types $80-$8F
        .byte   $80,$01,$00,$01,$80,$80,$03,$80,$01,$00,$80,$80,$00,$80,$00,$80 ; 8890  types $90-$9F
        .byte   $00,$00,$00,$00,$00,$00,$00,$80,$80,$00,$00,$80,$00,$00,$00,$00 ; 88A0  types $A0-$AF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$02,$00 ; 88B0  types $B0-$BF
        .byte   $00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 88C0  types $C0-$CF
; --- $88D0 (rt $A8D0): remainder (beyond type $CF) ---
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 88D0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 88E0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 88F0

; =============================================================================
; WAVE MAN STAGE DATA — format: DATA_REFERENCE.md section 11
; =============================================================================
; --- $8900 (rt $A900): screen -> layout index ---
        .byte   $00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0A,$0B,$0C,$0D,$0E,$0F ; 8900  screens $00-$0F
        .byte   $0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F ; 8910  screens $10-$1F
        .byte   $0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F ; 8920  screens $20-$2F
        .byte   $0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$11 ; 8930  screens $30-$3F
        .byte   $12,$13,$14,$15,$10,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8940  screens $40-$4F
; --- $8950 (rt $A950): section list: start screen (bits 0-4) | flags (bits 5-7) ---
        .byte   $23,$40,$40,$61,$20,$80,$A0,$22,$35,$20,$3A,$20,$20,$20,$20,$00 ; 8950
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 8960
; --- $8968 (rt $A968): per-section attributes (bit 7 = vertical-scroll room) ---
        .byte   $18,$18,$18,$18,$04,$04,$04,$17,$05,$04,$05,$05,$2D,$80,$B4,$00 ; 8968
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 8978
; --- $8980 (rt $A980): BG CHR banks (MMC3 R0/R1 <- $A980/$A981; rest unreferenced) ---
        .byte   $84,$86,$00,$00,$00,$00,$00,$00 ; 8980
; --- $8988 (rt $A988): BG palette (16 bytes) ---
        .byte   $0F,$20,$10,$11,$0F,$20,$27,$18,$0F,$20,$2C,$1C,$0F,$10,$00,$08 ; 8988
; --- $8998 (rt $A998): sprite palette-cycle seeds -> $05F0 slots ($A998-$A99B read) ---
        .byte   $00,$00,$89,$00,$0F,$20,$10,$11 ; 8998
; --- $89A0 (rt $A9A0): unreferenced ---
        .byte   $0F,$20,$1C,$21,$0F,$10,$1C,$0C,$0F,$10,$00,$08,$00,$00,$00,$00 ; 89A0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 89B0
        .byte   $00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 89C0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 89D0
; --- $89E0 (rt $A9E0): screen links [screen, Y band, dest screen, dest section], bit 7 ends ---
        .byte   $FF,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$10,$00,$00,$00,$00 ; 89E0  terminator / filler
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$20,$00,$00,$00 ; 89F0  
        .byte   $00                             ; 89FF  -1 base for the spawn arrays
; --- $8A00 (rt $AA00): spawn screens (ascending) ---
        .byte   $01,$01,$01,$01,$02,$02,$03,$03,$03,$05,$05,$06,$06,$06,$06,$07 ; 8A00  entries $00-$0F
        .byte   $07,$07,$07,$07,$08,$09,$0A,$0C,$0D,$0D,$0F,$10,$11,$12,$13,$14 ; 8A10  entries $10-$1F
        .byte   $15,$16,$17,$18,$19,$1A,$1B,$1C,$1D,$1D,$1F,$20,$21,$22,$24,$26 ; 8A20  entries $20-$2F
        .byte   $28,$29,$2A,$2B,$2C,$2D,$2E,$2F,$2F,$31,$31,$34,$34,$36,$38,$38 ; 8A30  entries $30-$3F
        .byte   $38,$39,$39,$3B,$3C,$3D,$3E,$3E,$3F,$41,$41,$42,$42,$43,$FF,$00 ; 8A40  entries $40-$4F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$04,$00,$00,$00,$00 ; 8A50  entries $50-$5F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8A60  entries $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8A70  entries $70-$7F
; --- $8A80 (rt $AA80): spawn X px ---
        .byte   $60,$70,$E8,$FF,$70,$AC,$88,$A8,$D0,$90,$B0,$C0,$C8,$F0,$FF,$58 ; 8A80  entries $00-$0F
        .byte   $90,$98,$F0,$FF,$80,$80,$80,$00,$00,$D8,$F0,$D0,$90,$E8,$80,$E0 ; 8A90  entries $10-$1F
        .byte   $98,$10,$90,$F0,$70,$D0,$E0,$A0,$30,$D0,$F0,$E0,$70,$00,$C0,$78 ; 8AA0  entries $20-$2F
        .byte   $10,$50,$B0,$58,$B8,$E0,$C0,$30,$A0,$10,$F0,$40,$70,$10,$70,$90 ; 8AB0  entries $30-$3F
        .byte   $B0,$10,$F0,$10,$B0,$10,$10,$F0,$20,$00,$E0,$00,$00,$D8,$FF,$00 ; 8AC0  entries $40-$4F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8AD0  entries $50-$5F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$00,$00,$00,$00,$00,$00 ; 8AE0  entries $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$04,$00,$40 ; 8AF0  entries $70-$7F
; --- $8B00 (rt $AB00): spawn Y px ---
        .byte   $81,$40,$C0,$81,$B0,$AC,$90,$70,$58,$98,$A0,$96,$90,$90,$00,$B0 ; 8B00  entries $00-$0F
        .byte   $D6,$D0,$B6,$00,$B0,$F0,$F0,$00,$00,$84,$8C,$8C,$8C,$8C,$8C,$8C ; 8B10  entries $10-$1F
        .byte   $8C,$8C,$8C,$8C,$8C,$8C,$88,$88,$8C,$8C,$80,$88,$88,$8C,$A0,$30 ; 8B20  entries $20-$2F
        .byte   $8C,$80,$70,$8C,$70,$80,$60,$8C,$80,$8C,$8C,$8C,$60,$30,$88,$80 ; 8B30  entries $30-$3F
        .byte   $58,$8C,$30,$80,$88,$80,$8C,$30,$8C,$00,$B4,$00,$00,$00,$FF,$00 ; 8B40  entries $40-$4F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8B50  entries $50-$5F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8B60  entries $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8B70  entries $70-$7F
; --- $8B80 (rt $AB80): spawn codes (< $C0 enemy id, >= $C0 palette/CHR command) ---
        .byte   $13,$0E,$13,$0E,$13,$0F,$41,$41,$84,$83,$13,$30,$13,$13,$C8,$30 ; 8B80  entries $00-$0F
        .byte   $30,$13,$30,$C9,$4A,$4A,$4A,$EA,$EB,$4E,$0B,$0B,$0B,$0B,$17,$0B ; 8B90  entries $10-$1F
        .byte   $0B,$28,$0B,$0B,$28,$0B,$3A,$3A,$0B,$28,$3A,$3A,$3A,$0B,$50,$3A ; 8BA0  entries $20-$2F
        .byte   $28,$3A,$3A,$28,$3A,$3A,$3A,$28,$3A,$17,$28,$28,$3A,$3A,$3A,$3A ; 8BB0  entries $30-$3F
        .byte   $89,$17,$3A,$3A,$3A,$3A,$17,$3A,$3A,$EA,$1D,$CE,$C8,$67,$FF,$00 ; 8BC0  entries $40-$4F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8BD0  entries $50-$5F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8BE0  entries $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8BF0  entries $70-$7F
; --- $8C00 (rt $AC00): per-screen spawn-list start index ---
        .byte   $00,$00,$04,$06,$09,$09,$0B,$0F,$14,$15,$16,$17,$17,$18,$1A,$1A ; 8C00  screens $00-$0F
        .byte   $1B,$1C,$1D,$1E,$1F,$20,$21,$22,$23,$24,$25,$26,$27,$28,$2A,$2A ; 8C10  screens $10-$1F
        .byte   $2B,$2C,$2D,$2E,$2E,$2F,$2F,$30,$30,$31,$32,$33,$34,$35,$36,$37 ; 8C20  screens $20-$2F
        .byte   $39,$39,$3B,$3B,$3B,$3D,$3D,$3E,$3E,$41,$43,$43,$44,$45,$46,$48 ; 8C30  screens $30-$3F
        .byte   $49,$49,$4B,$4D,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8C40  screens $40-$4F
        .byte   $00,$00,$00,$00,$10,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8C50  screens $50-$5F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8C60  screens $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$80,$00,$00,$00,$00,$00,$00,$00,$80,$00 ; 8C70  screens $70-$7F
        .byte   $00,$00,$00,$00,$00,$00,$08,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8C80  screens $80-$8F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8C90  screens $90-$9F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8CA0  screens $A0-$AF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8CB0  screens $B0-$BF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8CC0  screens $C0-$CF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8CD0  screens $D0-$DF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8CE0  screens $E0-$EF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8CF0  screens $F0-$FF
; --- $8D00 (rt $AD00): metatile top-left tile ids ---
        .byte   $00,$E1,$02,$04,$C0,$00,$2C,$CE,$01,$74,$3F,$24,$E0,$0E,$EF,$DF ; 8D00  metatiles $00-$0F
        .byte   $80,$82,$84,$86,$88,$8A,$8C,$8E,$A0,$A2,$A4,$A6,$A8,$AA,$AC,$AE ; 8D10  metatiles $10-$1F
        .byte   $00,$3E,$05,$04,$30,$32,$36,$5E,$20,$22,$25,$24,$20,$22,$00,$00 ; 8D20  metatiles $20-$2F
        .byte   $C1,$D1,$20,$22,$04,$C3,$C3,$E6,$C1,$D1,$C1,$D1,$24,$E3,$E3,$EC ; 8D30  metatiles $30-$3F
        .byte   $40,$42,$44,$44,$46,$46,$48,$4A,$68,$06,$26,$00,$6A,$4A,$68,$6A ; 8D40  metatiles $40-$4F
        .byte   $60,$62,$64,$64,$66,$66,$6A,$6A,$D4,$01,$D4,$0C,$4E,$6C,$10,$B6 ; 8D50  metatiles $50-$5F
        .byte   $08,$0A,$01,$D6,$4D,$2E,$2E,$00,$28,$2A,$01,$01,$5D,$3E,$3E,$00 ; 8D60  metatiles $60-$6F
        .byte   $2E,$C5,$D4,$C6,$E4,$E6,$00,$00,$3E,$D4,$D4,$C7,$EA,$EC,$6F,$6E ; 8D70  metatiles $70-$7F
        .byte   $11,$10,$11,$81,$11,$11,$11,$B4,$11,$11,$01,$01,$89,$83,$01,$86 ; 8D80  metatiles $80-$8F
        .byte   $92,$01,$01,$01,$10,$95,$97,$98,$8F,$01,$11,$A7,$11,$11,$81,$11 ; 8D90  metatiles $90-$9F
        .byte   $CA,$EA,$EB,$CB,$B6,$B6,$AA,$B6,$C2,$E2,$C0,$01,$E8,$E7,$AC,$AE ; 8DA0  metatiles $A0-$AF
        .byte   $E1,$C3,$E3,$C1,$EE,$EE,$B0,$B0,$01,$01,$EC,$E0,$B6,$00,$B2,$B2 ; 8DB0  metatiles $B0-$BF
        .byte   $00,$00,$05,$07,$09,$00,$CE,$2E,$00,$23,$25,$27,$29,$2B,$00,$4E ; 8DC0  metatiles $C0-$CF
        .byte   $C8,$43,$45,$47,$49,$4B,$4D,$6E,$E8,$63,$65,$67,$69,$6B,$6D,$1D ; 8DD0  metatiles $D0-$DF
        .byte   $D4,$83,$85,$87,$89,$8B,$8D,$00,$00,$A3,$A5,$A7,$A9,$AB,$00,$03 ; 8DE0  metatiles $E0-$EF
        .byte   $00,$81,$C5,$C7,$C9,$CD,$A0,$40,$00,$A1,$E5,$E7,$E9,$ED,$EF,$60 ; 8DF0  metatiles $F0-$FF
; --- $8E00 (rt $AE00): metatile bottom-left tile ids ---
        .byte   $00,$E2,$03,$04,$04,$00,$2D,$CF,$01,$2E,$3E,$24,$24,$0D,$CF,$DE ; 8E00  metatiles $00-$0F
        .byte   $81,$83,$85,$87,$89,$8B,$8D,$8F,$A1,$A3,$A5,$A7,$A9,$AB,$AD,$AF ; 8E10  metatiles $10-$1F
        .byte   $00,$3E,$04,$05,$31,$33,$36,$36,$21,$23,$24,$25,$21,$23,$00,$00 ; 8E20  metatiles $20-$2F
        .byte   $C2,$D2,$21,$23,$C3,$04,$C3,$C9,$C2,$D2,$C2,$D2,$E3,$24,$E3,$E9 ; 8E30  metatiles $30-$3F
        .byte   $41,$43,$43,$45,$47,$41,$49,$4B,$69,$07,$27,$00,$6B,$49,$69,$6B ; 8E40  metatiles $40-$4F
        .byte   $61,$63,$63,$65,$67,$61,$69,$69,$D5,$01,$D7,$0F,$4F,$6D,$10,$B6 ; 8E50  metatiles $50-$5F
        .byte   $09,$0B,$01,$D7,$2E,$2E,$4C,$00,$29,$2B,$01,$01,$3E,$3E,$5C,$00 ; 8E60  metatiles $60-$6F
        .byte   $C4,$C5,$D5,$2E,$E5,$E7,$00,$00,$C7,$D5,$D5,$3E,$EB,$ED,$6F,$6F ; 8E70  metatiles $70-$7F
        .byte   $11,$A6,$80,$82,$11,$11,$11,$B0,$11,$87,$01,$88,$8A,$84,$85,$11 ; 8E80  metatiles $80-$8F
        .byte   $93,$01,$01,$94,$10,$96,$10,$99,$01,$90,$87,$A8,$11,$80,$82,$11 ; 8E90  metatiles $90-$9F
        .byte   $CB,$EB,$CA,$EA,$B6,$B6,$AB,$B6,$C3,$E3,$C1,$E1,$E9,$AF,$AD,$AF ; 8EA0  metatiles $A0-$AF
        .byte   $C2,$E2,$C0,$01,$E7,$EE,$B0,$B1,$01,$01,$ED,$11,$B6,$00,$B2,$B3 ; 8EB0  metatiles $B0-$BF
        .byte   $00,$00,$06,$08,$0A,$00,$CF,$2F,$12,$24,$26,$28,$2A,$2C,$00,$4F ; 8EC0  metatiles $C0-$CF
        .byte   $E5,$44,$46,$48,$4A,$4C,$82,$6F,$EB,$64,$66,$68,$6A,$6C,$A2,$00 ; 8ED0  metatiles $D0-$DF
        .byte   $D5,$84,$86,$88,$8A,$8C,$BD,$00,$80,$A4,$A6,$A8,$AA,$AC,$00,$21 ; 8EE0  metatiles $E0-$EF
        .byte   $42,$C4,$C6,$C8,$CC,$AE,$00,$41,$62,$E4,$E6,$E8,$EC,$EE,$00,$61 ; 8EF0  metatiles $F0-$FF
; --- $8F00 (rt $AF00): metatile top-right tile ids ---
        .byte   $00,$F1,$02,$14,$D0,$3F,$3C,$DE,$01,$3F,$74,$34,$F0,$1E,$EE,$DE ; 8F00  metatiles $00-$0F
        .byte   $90,$92,$94,$96,$98,$9A,$9C,$9E,$B0,$B2,$B4,$B6,$B8,$BA,$BC,$BE ; 8F10  metatiles $10-$1F
        .byte   $2F,$2F,$15,$14,$20,$22,$37,$7E,$20,$22,$35,$34,$30,$32,$13,$12 ; 8F20  metatiles $20-$2F
        .byte   $C1,$D1,$C1,$D1,$14,$D3,$D3,$F6,$30,$32,$20,$22,$34,$F3,$F3,$FC ; 8F30  metatiles $30-$3F
        .byte   $50,$52,$54,$54,$56,$56,$58,$5A,$58,$16,$CC,$3E,$5A,$5A,$78,$7A ; 8F40  metatiles $40-$4F
        .byte   $70,$72,$73,$73,$76,$76,$5A,$7A,$11,$D4,$11,$1C,$4E,$7C,$10,$B7 ; 8F50  metatiles $50-$5F
        .byte   $18,$1A,$D6,$11,$5D,$3E,$3E,$3E,$38,$3A,$01,$E5,$4D,$2E,$2E,$5D ; 8F60  metatiles $60-$6F
        .byte   $3E,$FE,$DC,$C7,$F4,$F6,$5F,$5E,$2E,$DA,$DC,$D7,$FA,$FC,$7F,$7E ; 8F70  metatiles $70-$7F
        .byte   $11,$10,$83,$01,$86,$11,$81,$B5,$11,$8C,$01,$01,$10,$8F,$01,$91 ; 8F80  metatiles $80-$8F
        .byte   $9A,$9C,$9E,$A0,$10,$10,$10,$A2,$95,$97,$A9,$10,$A4,$83,$01,$86 ; 8F90  metatiles $90-$9F
        .byte   $DA,$FA,$FB,$DB,$D8,$B7,$BA,$B8,$D2,$10,$11,$F0,$F8,$F7,$BC,$BE ; 8FA0  metatiles $A0-$AF
        .byte   $01,$D3,$F3,$D1,$FE,$FE,$B2,$B2,$C6,$C4,$FC,$F1,$B7,$B2,$B2,$B2 ; 8FB0  metatiles $B0-$BF
        .byte   $00,$00,$15,$17,$19,$1B,$DE,$3E,$00,$33,$35,$37,$39,$3B,$3D,$5E ; 8FC0  metatiles $C0-$CF
        .byte   $D8,$53,$55,$57,$59,$5B,$5D,$0D,$F8,$73,$75,$77,$79,$7B,$7D,$2D ; 8FD0  metatiles $D0-$DF
        .byte   $CA,$93,$95,$97,$99,$9B,$9D,$00,$00,$B3,$B5,$B7,$B9,$BB,$00,$30 ; 8FE0  metatiles $E0-$EF
        .byte   $00,$91,$D5,$D7,$D9,$DD,$B0,$50,$00,$B1,$F5,$F7,$F9,$FD,$FF,$70 ; 8FF0  metatiles $F0-$FF
; --- $9000 (rt $B000): metatile bottom-right tile ids ---
        .byte   $00,$F2,$03,$14,$14,$3E,$3D,$DF,$01,$3E,$2E,$34,$34,$1D,$DF,$DF ; 9000  metatiles $00-$0F
        .byte   $91,$93,$95,$97,$99,$9B,$9D,$9F,$B1,$B3,$B5,$B7,$B9,$BB,$BD,$BF ; 9010  metatiles $10-$1F
        .byte   $2F,$2F,$14,$15,$21,$23,$37,$37,$21,$23,$34,$35,$31,$33,$13,$13 ; 9020  metatiles $20-$2F
        .byte   $C2,$D2,$C2,$D2,$D3,$14,$D3,$D9,$31,$33,$21,$23,$F3,$34,$F3,$F9 ; 9030  metatiles $30-$3F
        .byte   $51,$53,$53,$55,$57,$51,$59,$5B,$59,$17,$CD,$5C,$5B,$59,$79,$7B ; 9040  metatiles $40-$4F
        .byte   $71,$73,$73,$75,$77,$71,$59,$79,$11,$D5,$11,$1F,$4F,$7D,$10,$B7 ; 9050  metatiles $50-$5F
        .byte   $19,$1B,$D7,$11,$3E,$3E,$5C,$3E,$39,$3B,$E4,$E6,$2E,$2E,$4C,$3E ; 9060  metatiles $60-$6F
        .byte   $C7,$FE,$CB,$3E,$F5,$F7,$5F,$5F,$D6,$DB,$DD,$2E,$FB,$FD,$7F,$7F ; 9070  metatiles $70-$7F
        .byte   $11,$10,$84,$85,$11,$80,$82,$B2,$8B,$01,$01,$8D,$8E,$01,$90,$8A ; 9080  metatiles $80-$8F
        .byte   $9B,$9D,$9F,$A1,$10,$10,$10,$A3,$96,$10,$01,$10,$A5,$84,$85,$11 ; 9090  metatiles $90-$9F
        .byte   $DB,$FB,$DA,$FA,$D9,$B9,$BB,$B9,$D3,$F3,$D1,$01,$F9,$BF,$BD,$BF ; 90A0  metatiles $A0-$AF
        .byte   $D2,$10,$11,$F0,$F7,$FE,$B2,$B3,$C7,$C5,$FD,$F2,$B9,$B2,$B2,$B3 ; 90B0  metatiles $B0-$BF
        .byte   $02,$14,$16,$18,$1A,$13,$DF,$3F,$22,$34,$36,$38,$3A,$3C,$00,$5F ; 90C0  metatiles $C0-$CF
        .byte   $F5,$54,$56,$58,$5A,$5C,$92,$00,$FB,$74,$76,$78,$7A,$7C,$B2,$00 ; 90D0  metatiles $D0-$DF
        .byte   $DB,$94,$96,$98,$9A,$9C,$00,$03,$90,$B4,$B6,$B8,$BA,$BC,$00,$31 ; 90E0  metatiles $E0-$EF
        .byte   $52,$D4,$D6,$D8,$DC,$BE,$00,$51,$72,$F4,$F6,$F8,$FC,$FE,$00,$71 ; 90F0  metatiles $F0-$FF
; --- $9100 (rt $B100): metatile attributes: palette (bits 0-1) | collision (high nibble: ---
; $20 solid, $40 ladder, >= $D0 spikes; see DATA_REFERENCE section 11)
        .byte   $00,$11,$00,$11,$01,$03,$F0,$10,$05,$03,$03,$11,$01,$10,$00,$10 ; 9100  metatiles $00-$0F
        .byte   $11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11 ; 9110  metatiles $10-$1F
        .byte   $03,$03,$11,$11,$11,$11,$03,$03,$11,$11,$11,$11,$11,$11,$03,$03 ; 9120  metatiles $20-$2F
        .byte   $11,$11,$11,$11,$11,$11,$11,$02,$11,$11,$11,$11,$11,$11,$11,$02 ; 9130  metatiles $30-$3F
        .byte   $10,$10,$10,$10,$10,$10,$10,$10,$10,$12,$12,$03,$10,$10,$10,$10 ; 9140  metatiles $40-$4F
        .byte   $10,$10,$10,$10,$10,$10,$10,$10,$11,$11,$11,$10,$10,$10,$10,$02 ; 9150  metatiles $50-$5F
        .byte   $10,$10,$11,$11,$03,$03,$03,$03,$10,$10,$11,$11,$03,$03,$03,$03 ; 9160  metatiles $60-$6F
        .byte   $03,$03,$02,$03,$02,$02,$03,$03,$03,$02,$02,$03,$02,$02,$03,$03 ; 9170  metatiles $70-$7F
        .byte   $01,$01,$01,$01,$01,$01,$01,$02,$01,$01,$01,$01,$01,$01,$01,$01 ; 9180  metatiles $80-$8F
        .byte   $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01 ; 9190  metatiles $90-$9F
        .byte   $13,$13,$13,$13,$02,$02,$02,$02,$13,$13,$13,$13,$02,$02,$02,$02 ; 91A0  metatiles $A0-$AF
        .byte   $13,$13,$13,$13,$02,$02,$02,$02,$01,$01,$01,$01,$02,$02,$02,$02 ; 91B0  metatiles $B0-$BF
        .byte   $00,$D1,$D1,$D1,$D1,$D1,$13,$D0,$00,$D1,$D1,$D1,$D1,$D1,$D1,$D0 ; 91C0  metatiles $C0-$CF
        .byte   $02,$D1,$D1,$D1,$D1,$D1,$D1,$00,$02,$01,$D2,$D1,$D1,$D1,$D1,$00 ; 91D0  metatiles $D0-$DF
        .byte   $02,$D1,$D1,$D1,$D1,$01,$01,$00,$02,$D0,$D0,$D0,$D0,$00,$00,$D0 ; 91E0  metatiles $E0-$EF
        .byte   $01,$D0,$D0,$D2,$D2,$D2,$D2,$D0,$01,$D0,$D0,$D0,$D0,$D0,$D0,$D0 ; 91F0  metatiles $F0-$FF
; --- $9200 (rt $B200): 32px block defs: 4 metatile ids [TL,BL,TR,BR] per block ---
        .byte   $14,$15,$1C,$1D,$03,$23,$0B,$2B,$4E,$4A,$50,$51,$4A,$4A,$52,$53 ; 9200  blocks $00-$03
        .byte   $56,$4A,$55,$51,$4A,$4A,$52,$52,$28,$29,$28,$29,$67,$67,$6D,$6D ; 9210  blocks $04-$07
        .byte   $05,$4B,$0A,$6E,$00,$00,$00,$00,$6F,$67,$6C,$6D,$05,$67,$0A,$6D ; 9220  blocks $08-$0B
        .byte   $12,$13,$1A,$1B,$65,$65,$6D,$6D,$09,$66,$0A,$6E,$76,$77,$7E,$7F ; 9230  blocks $0C-$0F
        .byte   $64,$65,$6C,$6D,$09,$65,$0A,$6D,$16,$17,$1E,$1F,$65,$65,$65,$65 ; 9240  blocks $10-$13
        .byte   $09,$66,$09,$66,$26,$27,$2E,$2F,$64,$65,$64,$65,$09,$65,$09,$65 ; 9250  blocks $14-$17
        .byte   $2E,$2F,$26,$27,$40,$41,$46,$49,$42,$42,$49,$49,$42,$43,$49,$49 ; 9260  blocks $18-$1B
        .byte   $45,$41,$4D,$49,$45,$41,$4D,$5B,$42,$42,$5B,$60,$48,$4A,$48,$4A ; 9270  blocks $1C-$1F
        .byte   $4A,$4A,$4A,$4A,$56,$4A,$56,$4A,$56,$5C,$56,$5C,$5C,$68,$5C,$60 ; 9280  blocks $20-$23
        .byte   $4A,$4F,$53,$54,$2E,$48,$26,$48,$10,$11,$18,$19,$03,$03,$0B,$0B ; 9290  blocks $24-$27
        .byte   $00,$48,$00,$48,$23,$48,$2B,$48,$67,$4B,$65,$66,$00,$4E,$00,$50 ; 92A0  blocks $28-$2B
        .byte   $4A,$4A,$51,$52,$40,$41,$46,$0E,$43,$44,$07,$47,$65,$66,$6D,$6E ; 92B0  blocks $2C-$2F
        .byte   $48,$49,$48,$4A,$49,$4C,$4A,$4C,$43,$44,$61,$47,$4A,$4C,$4A,$4C ; 92C0  blocks $30-$33
        .byte   $40,$41,$46,$5B,$69,$4C,$61,$4C,$48,$5C,$48,$5C,$4C,$2F,$4C,$27 ; 92D0  blocks $34-$37
        .byte   $4C,$00,$4C,$00,$67,$4B,$6D,$6E,$4C,$22,$4C,$2A,$22,$03,$2A,$0B ; 92E0  blocks $38-$3B
        .byte   $4F,$00,$54,$00,$67,$67,$65,$65,$05,$67,$09,$65,$65,$66,$65,$66 ; 92F0  blocks $3C-$3F
        .byte   $64,$65,$40,$41,$09,$65,$42,$42,$65,$65,$42,$42,$65,$66,$43,$44 ; 9300  blocks $40-$43
        .byte   $00,$00,$22,$03,$00,$00,$03,$23,$46,$0E,$48,$49,$07,$07,$49,$49 ; 9310  blocks $44-$47
        .byte   $07,$47,$49,$4C,$2A,$0B,$67,$67,$0B,$2B,$67,$4B,$04,$03,$0C,$0B ; 9320  blocks $48-$4B
        .byte   $32,$33,$30,$31,$30,$31,$30,$31,$34,$36,$3C,$3E,$36,$36,$3E,$3E ; 9330  blocks $4C-$4F
        .byte   $36,$35,$3E,$3D,$30,$31,$3A,$3B,$32,$33,$38,$39,$32,$33,$3A,$3B ; 9340  blocks $50-$53
        .byte   $00,$00,$42,$42,$2C,$2D,$43,$44,$49,$49,$4A,$4A,$49,$47,$4A,$4C ; 9350  blocks $54-$57
        .byte   $30,$31,$38,$39,$24,$25,$28,$29,$28,$29,$2C,$2D,$42,$42,$07,$07 ; 9360  blocks $58-$5B
        .byte   $20,$20,$6D,$6D,$2C,$2D,$42,$42,$65,$65,$43,$44,$00,$00,$40,$41 ; 9370  blocks $5C-$5F
        .byte   $00,$00,$42,$43,$61,$60,$69,$68,$61,$47,$69,$4C,$6D,$6D,$22,$03 ; 9380  blocks $60-$63
        .byte   $6D,$6E,$03,$23,$61,$5B,$69,$5C,$5B,$60,$5C,$68,$61,$4C,$69,$4C ; 9390  blocks $64-$67
        .byte   $61,$5C,$69,$5C,$5C,$60,$5C,$68,$48,$68,$48,$60,$69,$68,$61,$60 ; 93A0  blocks $68-$6B
        .byte   $4F,$22,$54,$2A,$4E,$68,$50,$51,$69,$4F,$53,$54,$69,$68,$52,$52 ; 93B0  blocks $6C-$6F
        .byte   $00,$00,$44,$00,$47,$00,$4C,$22,$64,$65,$03,$03,$09,$65,$16,$17 ; 93C0  blocks $70-$73
        .byte   $00,$00,$14,$15,$4C,$2A,$4C,$00,$0B,$0B,$6F,$67,$1E,$1F,$28,$29 ; 93D0  blocks $74-$77
        .byte   $65,$65,$40,$41,$09,$66,$42,$42,$00,$00,$43,$44,$1C,$1D,$28,$29 ; 93E0  blocks $78-$7B
        .byte   $0B,$0B,$00,$00,$46,$60,$48,$68,$D8,$7D,$D0,$75,$7C,$7D,$74,$75 ; 93F0  blocks $7C-$7F
        .byte   $7C,$3F,$74,$37,$00,$00,$0D,$0D,$D8,$7D,$0D,$0D,$0D,$0D,$06,$06 ; 9400  blocks $80-$83
        .byte   $09,$66,$03,$03,$09,$66,$01,$03,$09,$66,$03,$01,$7C,$3F,$03,$03 ; 9410  blocks $84-$87
        .byte   $00,$00,$01,$03,$D8,$7D,$03,$01,$0B,$0B,$D0,$75,$0B,$0B,$74,$75 ; 9420  blocks $88-$8B
        .byte   $0B,$0B,$74,$37,$65,$70,$6D,$78,$71,$71,$E0,$79,$71,$71,$79,$7A ; 9430  blocks $8C-$8F
        .byte   $71,$71,$79,$72,$73,$65,$7B,$6D,$D0,$75,$D8,$7D,$74,$75,$7C,$7D ; 9440  blocks $90-$93
        .byte   $74,$37,$7C,$3F,$21,$21,$00,$00,$0D,$0D,$0D,$0D,$20,$20,$65,$65 ; 9450  blocks $94-$97
        .byte   $06,$06,$67,$67,$6B,$08,$63,$5A,$6B,$B8,$5A,$BA,$59,$62,$BB,$80 ; 9460  blocks $98-$9B
        .byte   $B9,$6A,$80,$58,$80,$80,$80,$80,$80,$80,$BA,$BB,$86,$80,$8E,$8F ; 9470  blocks $9C-$9F
        .byte   $80,$82,$9A,$8A,$83,$84,$8B,$8C,$80,$80,$9C,$9D,$80,$80,$9E,$9F ; 9480  blocks $A0-$A3
        .byte   $96,$97,$A4,$A5,$91,$92,$A4,$5F,$9B,$94,$A6,$A7,$81,$98,$5F,$5F ; 9490  blocks $A4-$A7
        .byte   $99,$8C,$5F,$BC,$64,$65,$0D,$0D,$B6,$B7,$BE,$BF,$B6,$B6,$BE,$BE ; 94A0  blocks $A8-$AB
        .byte   $BE,$BF,$BE,$BF,$BE,$BE,$BE,$BE,$42,$42,$60,$61,$42,$43,$5B,$5B ; 94B0  blocks $AC-$AF
        .byte   $42,$43,$60,$61,$68,$69,$60,$61,$5C,$5C,$5C,$5C,$BA,$BB,$80,$80 ; 94C0  blocks $B0-$B3
        .byte   $80,$80,$88,$89,$82,$83,$8A,$8B,$84,$85,$8C,$8D,$90,$91,$A4,$A5 ; 94D0  blocks $B4-$B7
        .byte   $92,$93,$A6,$A7,$94,$95,$5F,$5F,$B6,$B6,$40,$41,$B6,$B7,$42,$43 ; 94E0  blocks $B8-$BB
        .byte   $BE,$BF,$0D,$0D,$46,$5B,$48,$5C,$60,$61,$68,$69,$42,$42,$61,$60 ; 94F0  blocks $BC-$BF
        .byte   $AC,$AD,$45,$41,$AE,$AF,$42,$42,$B4,$B5,$42,$43,$AC,$B5,$42,$42 ; 9500  blocks $C0-$C3
        .byte   $AE,$AF,$43,$44,$B4,$B5,$C6,$C6,$B4,$AD,$C6,$C6,$4D,$5B,$56,$5C ; 9510  blocks $C4-$C7
        .byte   $A0,$A1,$A2,$A3,$5B,$5B,$5C,$5C,$A8,$A9,$B0,$B1,$AA,$AB,$B2,$B3 ; 9520  blocks $C8-$CB
        .byte   $AB,$A8,$B3,$B0,$A9,$AA,$B1,$B2,$AC,$AD,$C6,$C6,$AE,$AF,$C6,$C6 ; 9530  blocks $CC-$CF
        .byte   $AC,$B5,$C6,$C6,$00,$C1,$00,$C9,$C2,$C3,$CA,$CB,$C4,$C5,$CC,$CD ; 9540  blocks $D0-$D3
        .byte   $00,$00,$CE,$00,$F0,$D1,$F8,$D9,$D2,$D3,$DA,$DB,$D4,$D5,$DC,$DD ; 9550  blocks $D4-$D7
        .byte   $D6,$00,$DE,$00,$00,$E1,$00,$E9,$E2,$E3,$EA,$EB,$E4,$E5,$EC,$ED ; 9560  blocks $D8-$DB
        .byte   $E6,$00,$EE,$00,$E8,$F1,$00,$F9,$F2,$F3,$FA,$FB,$F4,$F5,$FC,$FD ; 9570  blocks $DC-$DF
        .byte   $F6,$00,$FE,$00,$AC,$AD,$40,$41,$87,$B6,$42,$42,$B6,$B7,$43,$44 ; 9580  blocks $E0-$E3
        .byte   $BE,$BE,$0D,$0D,$48,$60,$48,$68,$48,$5C,$4E,$5D,$50,$51,$BD,$02 ; 9590  blocks $E4-$E7
        .byte   $BE,$02,$BE,$02,$5C,$5C,$5D,$5D,$56,$5C,$57,$5D,$52,$52,$67,$67 ; 95A0  blocks $E8-$EB
        .byte   $52,$53,$05,$67,$55,$51,$05,$4B,$52,$53,$2E,$2F,$55,$51,$2E,$2F ; 95B0  blocks $EC-$EF
        .byte   $51,$53,$2E,$02,$2E,$02,$26,$02,$4C,$4B,$4C,$6E,$67,$48,$6D,$48 ; 95C0  blocks $F0-$F3
        .byte   $4C,$66,$4C,$66,$65,$48,$65,$48,$4C,$66,$4F,$6E,$65,$48,$6D,$48 ; 95D0  blocks $F4-$F7
        .byte   $54,$66,$67,$66,$65,$4E,$6D,$50,$43,$45,$61,$4D,$69,$56,$61,$56 ; 95E0  blocks $F8-$FB
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 95F0  blocks $FC-$FF
; --- $9600 (rt $B600): screen layouts: 64 block ids (8x8) each; ptr = $B600 + layout*64 ---
; layout $00
        .byte   $00,$01,$02,$03,$04,$05,$03,$04,$06,$07,$08,$09,$09,$0A,$0B,$08 ; 9600
        .byte   $0C,$0D,$0E,$0F,$0F,$10,$11,$0E,$12,$13,$14,$15,$15,$16,$17,$14 ; 9610
        .byte   $06,$0D,$0E,$18,$18,$10,$11,$0E,$0C,$0D,$0E,$0F,$0F,$10,$11,$0E ; 9620
        .byte   $01,$19,$1A,$1B,$1C,$1B,$1D,$1E,$09,$1F,$20,$20,$21,$20,$22,$23 ; 9630
; layout $01
        .byte   $05,$24,$06,$18,$18,$18,$25,$20,$09,$09,$26,$27,$27,$12,$28,$20 ; 9640
        .byte   $0F,$0F,$0F,$0A,$07,$26,$29,$20,$15,$15,$15,$16,$13,$2A,$2B,$2C ; 9650
        .byte   $18,$18,$2D,$2E,$0D,$2F,$18,$18,$0F,$00,$30,$31,$12,$2F,$15,$15 ; 9660
        .byte   $32,$06,$1F,$33,$06,$34,$1E,$32,$35,$06,$1F,$33,$06,$36,$23,$35 ; 9670
; layout $02
        .byte   $20,$37,$1F,$33,$13,$00,$27,$27,$20,$38,$1F,$33,$0D,$06,$39,$0F ; 9680
        .byte   $20,$3A,$1F,$33,$3B,$0C,$2F,$15,$03,$3C,$02,$24,$3D,$3E,$3F,$09 ; 9690
        .byte   $18,$18,$0A,$0B,$0D,$11,$2F,$18,$15,$15,$40,$41,$42,$41,$43,$15 ; 96A0
        .byte   $44,$45,$46,$47,$47,$47,$48,$3B,$49,$4A,$1F,$20,$20,$20,$33,$09 ; 96B0
; layout $03
        .byte   $27,$27,$27,$27,$27,$27,$27,$12,$0F,$0A,$39,$0F,$0F,$0F,$0F,$06 ; 96C0
        .byte   $15,$10,$2F,$15,$15,$15,$15,$06,$09,$16,$3F,$09,$09,$4B,$12,$06 ; 96D0
        .byte   $18,$10,$2F,$09,$4B,$12,$4C,$06,$15,$10,$00,$27,$12,$4C,$4D,$06 ; 96E0
        .byte   $27,$27,$0C,$09,$4C,$4D,$4D,$06,$09,$0A,$39,$09,$4D,$4D,$4D,$06 ; 96F0
; layout $04
        .byte   $00,$4E,$4F,$50,$0C,$51,$4D,$06,$4C,$00,$4E,$4F,$50,$0C,$4D,$26 ; 9700
        .byte   $4D,$26,$12,$15,$4D,$15,$51,$00,$51,$18,$26,$12,$4D,$00,$0C,$06 ; 9710
        .byte   $26,$12,$09,$52,$4D,$53,$09,$06,$09,$06,$09,$09,$4D,$26,$12,$06 ; 9720
        .byte   $54,$55,$09,$09,$4D,$09,$4C,$06,$56,$57,$15,$15,$4D,$15,$4D,$06 ; 9730
; layout $05
        .byte   $20,$33,$0F,$0F,$4D,$0F,$4D,$06,$05,$24,$09,$09,$4D,$09,$58,$06 ; 9740
        .byte   $07,$59,$09,$00,$0C,$09,$09,$06,$13,$06,$15,$52,$15,$15,$15,$06 ; 9750
        .byte   $0D,$06,$18,$18,$18,$18,$18,$5A,$00,$0C,$09,$09,$2D,$5B,$5B,$5B ; 9760
        .byte   $06,$0F,$0F,$0F,$30,$56,$56,$56,$06,$15,$15,$15,$1F,$20,$20,$20 ; 9770
; layout $06
        .byte   $06,$0F,$0F,$0F,$1F,$20,$20,$20,$06,$5C,$5C,$5C,$1F,$20,$20,$20 ; 9780
        .byte   $06,$0D,$0D,$0D,$02,$05,$05,$03,$26,$12,$0D,$0D,$39,$18,$18,$18 ; 9790
        .byte   $54,$5D,$5E,$0D,$2F,$5F,$54,$60,$61,$61,$62,$63,$64,$46,$47,$47 ; 97A0
        .byte   $65,$66,$67,$49,$4A,$1F,$20,$20,$68,$69,$67,$0D,$2F,$1F,$20,$20 ; 97B0
; layout $07
        .byte   $3A,$27,$01,$6A,$6B,$35,$6A,$35,$38,$0A,$0B,$6A,$6B,$35,$6A,$35 ; 97C0
        .byte   $6C,$27,$01,$6A,$6B,$35,$6D,$6E,$18,$0A,$0B,$6D,$6F,$6E,$15,$0A ; 97D0
        .byte   $70,$10,$11,$07,$08,$18,$18,$10,$71,$72,$73,$13,$14,$09,$74,$72 ; 97E0
        .byte   $75,$76,$77,$78,$79,$7A,$7B,$7C,$38,$10,$26,$7D,$61,$62,$0C,$09 ; 97F0
; layout $08
        .byte   $15,$7E,$7F,$80,$15,$7E,$80,$15,$81,$82,$7F,$80,$09,$7E,$80,$09 ; 9800
        .byte   $83,$83,$83,$80,$0F,$7E,$80,$0F,$08,$08,$08,$80,$18,$7E,$80,$18 ; 9810
        .byte   $0E,$0E,$0E,$80,$15,$7E,$80,$15,$84,$85,$86,$87,$88,$89,$87,$88 ; 9820
        .byte   $7C,$8A,$8B,$8C,$7C,$8A,$8C,$7C,$09,$7E,$7F,$80,$09,$7E,$80,$09 ; 9830
; layout $09
        .byte   $8D,$8E,$8F,$90,$91,$0D,$0D,$0D,$0D,$92,$93,$94,$0D,$0D,$0D,$0D ; 9840
        .byte   $0D,$92,$93,$94,$8D,$8E,$90,$91,$0D,$92,$93,$94,$0D,$92,$94,$0D ; 9850
        .byte   $95,$92,$93,$94,$95,$92,$94,$95,$15,$92,$93,$94,$15,$92,$94,$15 ; 9860
        .byte   $0F,$92,$93,$94,$0F,$92,$94,$0F,$18,$92,$93,$94,$18,$92,$94,$18 ; 9870
; layout $0A
        .byte   $96,$96,$96,$96,$96,$96,$96,$96,$83,$83,$83,$83,$83,$83,$83,$83 ; 9880
        .byte   $0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$18,$18,$18,$18,$18,$18,$18,$18 ; 9890
        .byte   $09,$09,$09,$09,$81,$81,$81,$81,$97,$97,$97,$97,$98,$83,$83,$96 ; 98A0
        .byte   $0D,$0D,$0D,$0D,$0D,$07,$07,$98,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D ; 98B0
; layout $0B
        .byte   $96,$6A,$35,$99,$9A,$9B,$9C,$99,$83,$6D,$6E,$9D,$9D,$9D,$9E,$9D ; 98C0
        .byte   $0A,$07,$39,$9F,$A0,$A1,$A2,$A3,$16,$13,$3F,$A4,$A5,$A6,$A7,$A8 ; 98D0
        .byte   $A9,$0D,$2F,$AA,$AB,$AA,$AB,$AA,$96,$96,$2F,$AC,$AD,$AC,$AD,$AC ; 98E0
        .byte   $34,$AE,$AF,$1D,$AE,$B0,$1D,$AE,$36,$B1,$B2,$22,$B1,$B1,$22,$B1 ; 98F0
; layout $0C
        .byte   $9A,$9B,$9C,$99,$9A,$9B,$9C,$99,$9D,$9D,$B3,$9D,$9D,$9D,$9E,$9D ; 9900
        .byte   $B4,$B5,$B6,$9F,$A0,$A1,$A2,$A3,$B7,$B8,$B9,$A4,$A5,$A6,$A7,$A8 ; 9910
        .byte   $AB,$AA,$AB,$AA,$AB,$AA,$BA,$BB,$AD,$AC,$AD,$BC,$96,$96,$BD,$BE ; 9920
        .byte   $AE,$AF,$1D,$1E,$BF,$32,$36,$BE,$B1,$B2,$22,$23,$6B,$35,$36,$BE ; 9930
; layout $0D
        .byte   $9A,$9B,$9C,$99,$9A,$9B,$9C,$99,$9D,$9D,$B3,$9D,$9D,$9D,$9E,$9D ; 9940
        .byte   $B4,$B5,$B6,$9F,$A0,$A1,$A2,$A3,$B7,$B8,$B9,$A4,$A5,$A6,$A7,$A8 ; 9950
        .byte   $C0,$C1,$C2,$C0,$C3,$C4,$C5,$C6,$C7,$BE,$BE,$C7,$66,$62,$C8,$C8 ; 9960
        .byte   $22,$BE,$C9,$22,$69,$67,$CA,$CB,$22,$B2,$B2,$22,$69,$67,$CC,$CD ; 9970
; layout $0E
        .byte   $9A,$9B,$9C,$99,$9A,$9B,$9C,$99,$9D,$9D,$B3,$9D,$9D,$9D,$9E,$9D ; 9980
        .byte   $B4,$B5,$B6,$9F,$A0,$A1,$A2,$A3,$B7,$B8,$B9,$A4,$A5,$A6,$A7,$A8 ; 9990
        .byte   $CE,$CF,$C5,$CE,$D0,$CF,$C5,$C6,$C8,$C8,$C8,$C8,$C8,$C8,$C8,$C8 ; 99A0
        .byte   $CA,$CB,$CA,$CB,$CA,$CB,$CA,$CB,$CC,$CD,$CC,$CD,$CC,$CD,$CC,$CD ; 99B0
; layout $0F
        .byte   $9A,$9B,$9C,$99,$9A,$9B,$9C,$99,$9D,$9D,$B3,$9D,$9D,$9D,$9E,$9D ; 99C0
        .byte   $B4,$B5,$B6,$9F,$A0,$A1,$A2,$A3,$B7,$B8,$B9,$A4,$A5,$A6,$A7,$A8 ; 99D0
        .byte   $CE,$CF,$C5,$CE,$D0,$CF,$C5,$C6,$C8,$C8,$C8,$C8,$C8,$C8,$C8,$C8 ; 99E0
        .byte   $CA,$CB,$CA,$CB,$CA,$CB,$CA,$CB,$CC,$CD,$CC,$CD,$CC,$CD,$CC,$CD ; 99F0
; layout $10
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9A00
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$D1,$D2,$D3,$D4 ; 9A10
        .byte   $09,$09,$09,$09,$D5,$D6,$D7,$D8,$09,$09,$09,$09,$D9,$DA,$DB,$DC ; 9A20
        .byte   $09,$09,$09,$09,$DD,$DE,$DF,$E0,$09,$09,$09,$09,$09,$09,$09,$09 ; 9A30
; layout $11
        .byte   $9A,$9B,$9C,$99,$9A,$9B,$9C,$99,$9D,$9D,$B3,$9D,$9D,$9D,$9E,$9D ; 9A40
        .byte   $B4,$B5,$B6,$9F,$A0,$A1,$A2,$A3,$B7,$B8,$B9,$A4,$A5,$A6,$A7,$A8 ; 9A50
        .byte   $CE,$CF,$C5,$CE,$D0,$CF,$C5,$C6,$C8,$C8,$C8,$C8,$C8,$C8,$C8,$C8 ; 9A60
        .byte   $CA,$CB,$CA,$CB,$CA,$CB,$CA,$CB,$CC,$CD,$CC,$CD,$CC,$CD,$CC,$CD ; 9A70
; layout $12
        .byte   $9A,$9B,$9C,$99,$9A,$9B,$9C,$99,$9D,$9D,$B3,$9D,$9D,$9D,$9E,$9D ; 9A80
        .byte   $B4,$B5,$B6,$9F,$A0,$A1,$A2,$A3,$B7,$B8,$B9,$A4,$A5,$A6,$A7,$A8 ; 9A90
        .byte   $CE,$CF,$C5,$E1,$E2,$E3,$AB,$AA,$C8,$C8,$C8,$7D,$61,$62,$E4,$BC ; 9AA0
        .byte   $CA,$CB,$CA,$E5,$61,$67,$34,$B0,$CC,$CD,$CC,$E5,$61,$67,$36,$B1 ; 9AB0
; layout $13
        .byte   $9A,$9B,$9C,$99,$9A,$9B,$9C,$36,$9D,$9D,$B3,$9D,$9D,$9D,$9E,$36 ; 9AC0
        .byte   $B4,$B5,$B6,$9F,$A0,$A1,$A2,$36,$B7,$B8,$B9,$A4,$A5,$A6,$A7,$E6 ; 9AD0
        .byte   $AB,$AA,$AB,$AA,$AB,$AA,$AB,$E7,$E4,$BC,$E4,$BC,$AD,$AC,$AD,$E8 ; 9AE0
        .byte   $1D,$B0,$1D,$AE,$AF,$1D,$B0,$1D,$22,$B1,$22,$B1,$B2,$22,$B1,$22 ; 9AF0
; layout $14
        .byte   $BE,$BE,$22,$B2,$22,$E9,$22,$BE,$BE,$C9,$22,$E9,$22,$BE,$22,$C9 ; 9B00
        .byte   $BE,$E9,$22,$BE,$22,$BE,$22,$B2,$BE,$BE,$EA,$BE,$EA,$BE,$EA,$E9 ; 9B10
        .byte   $EB,$EC,$ED,$EE,$EF,$EE,$EF,$F0,$0D,$11,$0E,$18,$18,$18,$18,$F1 ; 9B20
        .byte   $AE,$B0,$1D,$AE,$B0,$1D,$AE,$AF,$B1,$B1,$22,$B1,$B1,$22,$B1,$B2 ; 9B30
; layout $15
        .byte   $3A,$27,$0C,$26,$27,$27,$27,$29,$F2,$0F,$0A,$39,$0F,$0F,$0A,$F3 ; 9B40
        .byte   $F4,$09,$16,$3F,$09,$09,$16,$F5,$F6,$15,$10,$2F,$15,$15,$10,$F7 ; 9B50
        .byte   $F8,$18,$16,$3F,$18,$18,$16,$F5,$2F,$0F,$10,$2F,$0F,$0F,$10,$F9 ; 9B60
        .byte   $1C,$1B,$1C,$1A,$1B,$1D,$1E,$FA,$21,$20,$21,$20,$20,$22,$23,$FB ; 9B70
; layout $16
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9B80
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9B90
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9BA0
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9BB0
; layout $17
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9BC0
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9BD0
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9BE0
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9BF0
; layout $18
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9C00
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9C10
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9C20
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9C30
; layout $19
L9C40:  .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9C40
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9C50
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9C60
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9C70
; layout $1A
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9C80
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9C90
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9CA0
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9CB0
; layout $1B
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9CC0
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9CD0
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9CE0
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9CF0
; layout $1C
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9D00
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9D10
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9D20
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9D30
; layout $1D
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9D40
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9D50
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9D60
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9D70
; layout $1E
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9D80
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9D90
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9DA0
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9DB0
; layout $1F
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9DC0
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9DD0
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9DE0
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9DF0
; layout $20
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9E00
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9E10
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9E20
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9E30
; layout $21
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9E40
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9E50
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9E60
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9E70
; layout $22
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9E80
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9E90
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9EA0
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9EB0
; layout $23
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9EC0
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9ED0
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9EE0
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9EF0
; layout $24
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9F00
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9F10
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9F20
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9F30
; layout $25
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9F40
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9F50
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9F60
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9F70
; layout $26
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9F80
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9F90
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9FA0
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9FB0
; layout $27
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9FC0
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9FD0
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9FE0
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09 ; 9FF0
