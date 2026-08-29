.setcpu "6502"
.include "include/hardware.inc"
.include "include/zeropage.inc"
.include "include/constants.inc"
.include "include/fixed_bank.inc"

.segment "BANK0C"

; =============================================================================
; BANK $0C (mapped at $A000) — STORY INTRO + WILY 1 STAGE DATA
;
; $A000-$A625: the attract-mode story intro, run from the title screen
; (bank $17:807D calls $A000 with the $17/$0C pair mapped). A scripted
; slideshow: story text pages, city/lab scenes drawn from the menu
; pseudo-stage ($26=$10) with menu-actor entities (type $6D/etc.) hopping
; and pacing through them. Start skips at any wait (LA1D4 checks).
;
; $A626-$BFFF: Wily 1 stage data — this IS stage $0C's data bank (mapped
; at $A000 during play; screen table at $A900 via screen_layout_ptr,
; metatile strips from $B600+). Format documentation belongs to the
; stage-data pass with banks $10-$16.
; =============================================================================
L0000           := $0000
L0002           := $0002
L0008           := $0008
L000A           := $000A
L005C           := $005C
L006E           := $006E
L0100           := $0100
L0200           := $0200
L0810           := $0810
L0900           := $0900
L0F25           := $0F25
L0F37           := $0F37
L10F3           := $10F3
L1121           := $1121
L1322           := $1322
L1614           := $1614
L1621           := $1621
L165D           := $165D
L192A           := $192A
L2000           := $2000
L2028           := $2028
L2144           := $2144
L2422           := $2422
L2680           := $2680
L3032           := $3032
L3921           := $3921
L4040           := $4040
L4441           := $4441
L4542           := $4542
L4544           := $4544
L4854           := $4854
L4C16           := $4C16
L4E16           := $4E16
L5241           := $5241
L5349           := $5349
L6032           := $6032
L676D           := $676D
L6916           := $6916
L6A6D           := $6A6D
L6A70           := $6A70
L8C6C           := $8C6C
LDAFC           := $DAFC
LE620           := $E620
; ----------------------------------------------------------------------------
; --- $A000: STORY INTRO entry. Intro music ($0B), then the scene list;
; each step is draw screen / spawn actors / timed wait, and any nonzero
; return from a wait means Start was pressed -> abort via LA1C6.
;   page 0 text -> city scene -> robot parade -> whistler close-up ->
;   page 1 -> city again -> highlights blacked out -> page 2 -> attack
;   scene -> lab scene (pacing actor) -> finale card -> long fade, rts.
        lda     #$0B                            ; A000 A9 0B                    ..
        jsr     queue_sound_param                           ; A002 20 5B EC                  [.
        lda     #$00                            ; A005 A9 00                    ..
        jsr     LA53F                           ; A007 20 3F A5                  ?.
        ldx     #$3C                            ; A00A A2 3C                    .<
        jsr     LA50A                           ; A00C 20 0A A5                  ..
        beq     LA014                           ; A00F F0 03                    ..
        jmp     LA1C6                           ; A011 4C C6 A1                 L..

; ----------------------------------------------------------------------------
LA014:  jsr     LA2F7                           ; A014 20 F7 A2                  ..
        ldx     #$B4                            ; A017 A2 B4                    ..
        jsr     LA50A                           ; A019 20 0A A5                  ..
        beq     LA021                           ; A01C F0 03                    ..
        jmp     LA1C6                           ; A01E 4C C6 A1                 L..

; ----------------------------------------------------------------------------
; --- LA021: robot parade: palette record 4, 9 actors from record $01
; (the robot masters' rampage), hop loop LA315 until all despawn.
LA021:  jsr     palette_fade_out                           ; A021 20 F1 C3                  ..
        jsr     oam_clear                           ; A024 20 8F C3                  ..
        lda     #$00                            ; A027 A9 00                    ..
        sta     $0300                           ; A029 8D 00 03                 ...
        lda     #$04                            ; A02C A9 04                    ..
        jsr     LA373                           ; A02E 20 73 A3                  s.
        jsr     palette_fade_in                           ; A031 20 EB C3                  ..
        ldx     #$09                            ; A034 A2 09                    ..
        ldy     #$01                            ; A036 A0 01                    ..
        jsr     LA3A8                           ; A038 20 A8 A3                  ..
        jsr     LA315                           ; A03B 20 15 A3                  ..
        beq     LA043                           ; A03E F0 03                    ..
        jmp     LA1C6                           ; A040 4C C6 A1                 L..

; ----------------------------------------------------------------------------
LA043:  ldx     #$1E                            ; A043 A2 1E                    ..
        jsr     LA50A                           ; A045 20 0A A5                  ..
        beq     LA04D                           ; A048 F0 03                    ..
        jmp     LA1C6                           ; A04A 4C C6 A1                 L..

; ----------------------------------------------------------------------------
; --- LA04D: whistler close-up: screen $01, one actor (record $0A);
; LA516 blows the whistle ($2B) on each anim phase $0C.
LA04D:  jsr     palette_fade_out                           ; A04D 20 F1 C3                  ..
        jsr     frame_wait                           ; A050 20 22 FF                  ".
        jsr     disable_rendering                           ; A053 20 D1 C2                  ..
        lda     #$01                            ; A056 A9 01                    ..
        jsr     LA364                           ; A058 20 64 A3                  d.
        ldx     #$01                            ; A05B A2 01                    ..
        ldy     #$0A                            ; A05D A0 0A                    ..
        jsr     LA3A8                           ; A05F 20 A8 A3                  ..
        jsr     enable_rendering                           ; A062 20 DB C2                  ..
        jsr     frame_wait                           ; A065 20 22 FF                  ".
        jsr     palette_fade_in                           ; A068 20 EB C3                  ..
        lda     #$2B                            ; A06B A9 2B                    .+
        jsr     queue_sound                           ; A06D 20 5D EC                  ].
        ldx     #$B4                            ; A070 A2 B4                    ..
        jsr     LA516                           ; A072 20 16 A5                  ..
        beq     LA07A                           ; A075 F0 03                    ..
        jmp     LA1C6                           ; A077 4C C6 A1                 L..

; ----------------------------------------------------------------------------
LA07A:  lda     #$01                            ; A07A A9 01                    ..
        jsr     LA53F                           ; A07C 20 3F A5                  ?.
        ldx     #$78                            ; A07F A2 78                    .x
        jsr     LA50A                           ; A081 20 0A A5                  ..
        beq     LA089                           ; A084 F0 03                    ..
        jmp     LA1C6                           ; A086 4C C6 A1                 L..

; ----------------------------------------------------------------------------
LA089:  jsr     LA2F7                           ; A089 20 F7 A2                  ..
        ldx     #$3C                            ; A08C A2 3C                    .<
        jsr     LA50A                           ; A08E 20 0A A5                  ..
        beq     LA096                           ; A091 F0 03                    ..
        jmp     LA1C6                           ; A093 4C C6 A1                 L..

; ----------------------------------------------------------------------------
; --- LA096: black out the palette highlight entries (5/7/B/F of both
; rows) and hold the darkened city $B4 frames.
LA096:  lda     #$0F                            ; A096 A9 0F                    ..
        sta     $0605                           ; A098 8D 05 06                 ...
        sta     $0625                           ; A09B 8D 25 06                 .%.
        sta     $0607                           ; A09E 8D 07 06                 ...
        sta     $0627                           ; A0A1 8D 27 06                 .'.
        sta     $060B                           ; A0A4 8D 0B 06                 ...
        sta     $062B                           ; A0A7 8D 2B 06                 .+.
        sta     $060F                           ; A0AA 8D 0F 06                 ...
        sta     $062F                           ; A0AD 8D 2F 06                 ./.
        lda     #$FF                            ; A0B0 A9 FF                    ..
        sta     $18                             ; A0B2 85 18                    ..
        ldx     #$B4                            ; A0B4 A2 B4                    ..
        jsr     LA50A                           ; A0B6 20 0A A5                  ..
        .byte   $F0                             ; A0B9 F0                       .
LA0BA:  .byte   $03                             ; A0BA 03                       .
        jmp     LA1C6                           ; A0BB 4C C6 A1                 L..

; ----------------------------------------------------------------------------
; --- LA0BE: story page 2, then the attack scene: screen $00, sprite
; palette row $1F, 3 actors from record $0B; slot 2 charges in from the
; left under gravity (LA21A script).
LA0BE:  lda     #$02                            ; A0BE A9 02                    ..
        jsr     LA53F                           ; A0C0 20 3F A5                  ?.
        ldx     #$78                            ; A0C3 A2 78                    .x
        jsr     LA50A                           ; A0C5 20 0A A5                  ..
        beq     LA0CD                           ; A0C8 F0 03                    ..
        jmp     LA1C6                           ; A0CA 4C C6 A1                 L..

; ----------------------------------------------------------------------------
LA0CD:  jsr     palette_fade_out                           ; A0CD 20 F1 C3                  ..
        jsr     frame_wait                           ; A0D0 20 22 FF                  ".
        jsr     disable_rendering                           ; A0D3 20 D1 C2                  ..
        lda     #$00                            ; A0D6 A9 00                    ..
        jsr     LA364                           ; A0D8 20 64 A3                  d.
        ldy     #$1F                            ; A0DB A0 1F                    ..
        jsr     LA39B                           ; A0DD 20 9B A3                  ..
        ldx     #$03                            ; A0E0 A2 03                    ..
        ldy     #$0B                            ; A0E2 A0 0B                    ..
        jsr     LA3A8                           ; A0E4 20 A8 A3                  ..
        lda     $052A                           ; A0E7 AD 2A 05                 .*.
        ora     #$20                            ; A0EA 09 20                    . 
        sta     $052A                           ; A0EC 8D 2A 05                 .*.
        lda     #$00                            ; A0EF A9 00                    ..
        sta     $03AA                           ; A0F1 8D AA 03                 ...
        sta     $03DA                           ; A0F4 8D DA 03                 ...
        sta     $03F2                           ; A0F7 8D F2 03                 ...
        lda     #$03                            ; A0FA A9 03                    ..
        sta     $03C2                           ; A0FC 8D C2 03                 ...
        jsr     enable_rendering                           ; A0FF 20 DB C2                  ..
        jsr     frame_wait                           ; A102 20 22 FF                  ".
        jsr     palette_fade_in                           ; A105 20 EB C3                  ..
        ldx     #$3C                            ; A108 A2 3C                    .<
        jsr     LA50A                           ; A10A 20 0A A5                  ..
        beq     LA112                           ; A10D F0 03                    ..
        jmp     LA1C6                           ; A10F 4C C6 A1                 L..

; ----------------------------------------------------------------------------
LA112:  jsr     LA21A                           ; A112 20 1A A2                  ..
        beq     LA11A                           ; A115 F0 03                    ..
        jmp     LA1C6                           ; A117 4C C6 A1                 L..

; ----------------------------------------------------------------------------
LA11A:  ldx     #$1E                            ; A11A A2 1E                    ..
        jsr     LA50A                           ; A11C 20 0A A5                  ..
        beq     LA124                           ; A11F F0 03                    ..
        jmp     LA1C6                           ; A121 4C C6 A1                 L..

; ----------------------------------------------------------------------------
; --- LA124: lab scene: screen $03, actor record $0E paces — walks $33
; frames, pauses, turns (dir ^= 3), 3 lengths (LA1E3).
LA124:  jsr     palette_fade_out                           ; A124 20 F1 C3                  ..
        jsr     frame_wait                           ; A127 20 22 FF                  ".
        jsr     disable_rendering                           ; A12A 20 D1 C2                  ..
        lda     #$03                            ; A12D A9 03                    ..
        jsr     LA364                           ; A12F 20 64 A3                  d.
        ldx     #$03                            ; A132 A2 03                    ..
        ldy     #$0E                            ; A134 A0 0E                    ..
        jsr     LA3A8                           ; A136 20 A8 A3                  ..
        ldy     #$2F                            ; A139 A0 2F                    ./
        jsr     LA39B                           ; A13B 20 9B A3                  ..
        lda     #$00                            ; A13E A9 00                    ..
        sta     $03C1                           ; A140 8D C1 03                 ...
        sta     $03F1                           ; A143 8D F1 03                 ...
        lda     #$C8                            ; A146 A9 C8                    ..
        sta     $03A9                           ; A148 8D A9 03                 ...
        lda     #$78                            ; A14B A9 78                    .x
        sta     $03D9                           ; A14D 8D D9 03                 ...
        lda     #$33                            ; A150 A9 33                    .3
        sta     $0469                           ; A152 8D 69 04                 .i.
        lda     #$03                            ; A155 A9 03                    ..
        sta     $0481                           ; A157 8D 81 04                 ...
        lda     #$00                            ; A15A A9 00                    ..
        sta     $0499                           ; A15C 8D 99 04                 ...
        lda     #$05                            ; A15F A9 05                    ..
        sta     $0421                           ; A161 8D 21 04                 .!.
        jsr     enable_rendering                           ; A164 20 DB C2                  ..
        jsr     frame_wait                           ; A167 20 22 FF                  ".
        jsr     palette_fade_in                           ; A16A 20 EB C3                  ..
        jsr     LA1E3                           ; A16D 20 E3 A1                  ..
        beq     LA175                           ; A170 F0 03                    ..
        jmp     LA1C6                           ; A172 4C C6 A1                 L..

; ----------------------------------------------------------------------------
; --- LA175: finale: palette record 5 over a cleared screen, actor
; record $11 holds $EC frames, then everything fades and the palette is
; forced dark ($A9=$10, $27=$0F restored) before returning to the title.
LA175:  ldx     #$0C                            ; A175 A2 0C                    ..
        jsr     LA50A                           ; A177 20 0A A5                  ..
        beq     LA17F                           ; A17A F0 03                    ..
        jmp     LA1C6                           ; A17C 4C C6 A1                 L..

; ----------------------------------------------------------------------------
LA17F:  jsr     palette_fade_out                           ; A17F 20 F1 C3                  ..
        jsr     oam_clear                           ; A182 20 8F C3                  ..
        jsr     entity_clear_all                           ; A185 20 9D C3                  ..
        lda     #$00                            ; A188 A9 00                    ..
        sta     $FD                             ; A18A 85 FD                    ..
        lda     #$05                            ; A18C A9 05                    ..
        jsr     LA373                           ; A18E 20 73 A3                  s.
        lda     #$E0                            ; A191 A9 E0                    ..
        sta     $A9                             ; A193 85 A9                    ..
        jsr     palette_fade_in                           ; A195 20 EB C3                  ..
        ldx     #$3C                            ; A198 A2 3C                    .<
        jsr     LA50A                           ; A19A 20 0A A5                  ..
        beq     LA1A2                           ; A19D F0 03                    ..
        .byte   $4C                             ; A19F 4C                       L
LA1A0:  dec     $A1                             ; A1A0 C6 A1                    ..
LA1A2:  ldx     #$01                            ; A1A2 A2 01                    ..
        ldy     #$11                            ; A1A4 A0 11                    ..
        jsr     LA3A8                           ; A1A6 20 A8 A3                  ..
        ldx     #$EC                            ; A1A9 A2 EC                    ..
        jsr     LA50A                           ; A1AB 20 0A A5                  ..
        lda     #$00                            ; A1AE A9 00                    ..
        sta     $0300                           ; A1B0 8D 00 03                 ...
        jsr     oam_clear                           ; A1B3 20 8F C3                  ..
        lda     #$F0                            ; A1B6 A9 F0                    ..
        sta     $A9                             ; A1B8 85 A9                    ..
        jsr     palette_fade_out                           ; A1BA 20 F1 C3                  ..
        lda     #$10                            ; A1BD A9 10                    ..
        sta     $A9                             ; A1BF 85 A9                    ..
        lda     #$0F                            ; A1C1 A9 0F                    ..
        sta     $27                             ; A1C3 85 27                    .'
        rts                                     ; A1C5 60                       `

; ----------------------------------------------------------------------------
; --- LA1C6: abort (Start pressed): fade, clear sprites/entities,
; restore $27=$0F, back to the title loop.
LA1C6:  jsr     palette_fade_out                           ; A1C6 20 F1 C3                  ..
        jsr     oam_clear                           ; A1C9 20 8F C3                  ..
        jsr     entity_clear_all                           ; A1CC 20 9D C3                  ..
        lda     #$0F                            ; A1CF A9 0F                    ..
        sta     $27                             ; A1D1 85 27                    .'
        rts                                     ; A1D3 60                       `

; ----------------------------------------------------------------------------
; --- LA1D4: scene frame tick: read pads + render; returns NZ if Start
; was newly pressed.
LA1D4:  lda     #$01                            ; A1D4 A9 01                    ..
        sta     $9D                             ; A1D6 85 9D                    ..
        jsr     read_controllers                           ; A1D8 20 E5 C2                  ..
        jsr     render_tick_frame                           ; A1DB 20 63 F3                  c.
        lda     $16                             ; A1DE A5 16                    ..
        and     #$10                            ; A1E0 29 10                    ).
        rts                                     ; A1E2 60                       `

; ----------------------------------------------------------------------------
; --- LA1E3: pacing-actor animator: move $33 frames, pause $19 frames
; while facing flips (dir ^= 3), repeat 3 times or until Start.
LA1E3:  lda     $0499                           ; A1E3 AD 99 04                 ...
        beq     LA1ED                           ; A1E6 F0 05                    ..
        dec     $0499                           ; A1E8 CE 99 04                 ...
        bne     LA20F                           ; A1EB D0 22                    ."
LA1ED:  ldx     #$01                            ; A1ED A2 01                    ..
        jsr     entity_facing_dispatch                           ; A1EF 20 65 EA                  e.
        jsr     entity_vert_dispatch_raw                           ; A1F2 20 86 EA                  ..
        dec     $0469                           ; A1F5 CE 69 04                 .i.
        bne     LA20F                           ; A1F8 D0 15                    ..
        lda     #$33                            ; A1FA A9 33                    .3
        sta     $0469                           ; A1FC 8D 69 04                 .i.
        lda     $0421                           ; A1FF AD 21 04                 .!.
        eor     #$03                            ; A202 49 03                    I.
        sta     $0421                           ; A204 8D 21 04                 .!.
        lda     #$19                            ; A207 A9 19                    ..
        sta     $0499                           ; A209 8D 99 04                 ...
        dec     $0481                           ; A20C CE 81 04                 ...
LA20F:  jsr     LA1D4                           ; A20F 20 D4 A1                  ..
        bne     LA219                           ; A212 D0 05                    ..
        lda     $0481                           ; A214 AD 81 04                 ...
        bne     LA1E3                           ; A217 D0 CA                    ..
LA219:  rts                                     ; A219 60                       `

; ----------------------------------------------------------------------------
; --- LA21A: attack-scene script: slot 2 bounds in rightward under
; gravity (floor at Y=$93), morphs to sub $A4 on arrival; slot 1 (sub
; $17) launches upward off-screen, then re-enters as sub $04 sliding
; right along Y=$93 until X=$64, ending on sub $01.
LA21A:  ldx     #$02                            ; A21A A2 02                    ..
        jsr     entity_gravity_collide                           ; A21C 20 B7 E7                  ..
        jsr     entity_move_right_collide                           ; A21F 20 E6 E8                  ..
        lda     #$93                            ; A222 A9 93                    ..
        cmp     $037A                           ; A224 CD 7A 03                 .z.
        bcs     LA231                           ; A227 B0 08                    ..
        sta     $037A                           ; A229 8D 7A 03                 .z.
        lda     #$64                            ; A22C A9 64                    .d
        sta     $0332                           ; A22E 8D 32 03                 .2.
LA231:  lda     $0332                           ; A231 AD 32 03                 .2.
        cmp     #$50                            ; A234 C9 50                    .P
        bcc     LA23D                           ; A236 90 05                    ..
        lda     #$C0                            ; A238 A9 C0                    ..
        sta     $0378                           ; A23A 8D 78 03                 .x.
LA23D:  jsr     LA1D4                           ; A23D 20 D4 A1                  ..
        bne     LA219                           ; A240 D0 D7                    ..
        lda     $037A                           ; A242 AD 7A 03                 .z.
        cmp     #$93                            ; A245 C9 93                    ..
        bne     LA21A                           ; A247 D0 D1                    ..
        lda     #$64                            ; A249 A9 64                    .d
        sta     $0332                           ; A24B 8D 32 03                 .2.
        ldx     #$02                            ; A24E A2 02                    ..
        lda     $052A                           ; A250 AD 2A 05                 .*.
        and     #$DF                            ; A253 29 DF                    ).
        sta     $052A                           ; A255 8D 2A 05                 .*.
        lda     #$60                            ; A258 A9 60                    .`
        sta     $0330                           ; A25A 8D 30 03                 .0.
        lda     #$3F                            ; A25D A9 3F                    .?
        sta     $0378                           ; A25F 8D 78 03                 .x.
        lda     #$A4                            ; A262 A9 A4                    ..
        jsr     entity_set_subtype                           ; A264 20 98 EA                  ..
        ldx     #$1E                            ; A267 A2 1E                    ..
        jsr     LA50A                           ; A269 20 0A A5                  ..
        lda     #$00                            ; A26C A9 00                    ..
        sta     $0302                           ; A26E 8D 02 03                 ...
        sta     $03D9                           ; A271 8D D9 03                 ...
        lda     #$04                            ; A274 A9 04                    ..
        sta     $03F1                           ; A276 8D F1 03                 ...
        lda     #$17                            ; A279 A9 17                    ..
        ldx     #$01                            ; A27B A2 01                    ..
        jsr     entity_set_subtype                           ; A27D 20 98 EA                  ..
        lda     #$1E                            ; A280 A9 1E                    ..
        sta     $0301                           ; A282 8D 01 03                 ...
LA285:  ldx     #$01                            ; A285 A2 01                    ..
        jsr     entity_move_up_nofacing                           ; A287 20 4A E9                  J.
        jsr     LA1D4                           ; A28A 20 D4 A1                  ..
        bne     LA2F6                           ; A28D D0 67                    .g
        lda     $0379                           ; A28F AD 79 03                 .y.
        cmp     #$50                            ; A292 C9 50                    .P
        bcs     LA285                           ; A294 B0 EF                    ..
        ldx     #$01                            ; A296 A2 01                    ..
        stx     $0301                           ; A298 8E 01 03                 ...
        lda     #$00                            ; A29B A9 00                    ..
        jsr     entity_set_subtype                           ; A29D 20 98 EA                  ..
        ldx     #$0F                            ; A2A0 A2 0F                    ..
        jsr     LA50A                           ; A2A2 20 0A A5                  ..
        lda     #$30                            ; A2A5 A9 30                    .0
        sta     $0330                           ; A2A7 8D 30 03                 .0.
        sta     $0331                           ; A2AA 8D 31 03                 .1.
        lda     #$8F                            ; A2AD A9 8F                    ..
        sta     $0378                           ; A2AF 8D 78 03                 .x.
        lda     #$04                            ; A2B2 A9 04                    ..
        ldx     #$01                            ; A2B4 A2 01                    ..
        jsr     entity_set_subtype                           ; A2B6 20 98 EA                  ..
        lda     #$93                            ; A2B9 A9 93                    ..
        sta     $0379                           ; A2BB 8D 79 03                 .y.
        lda     #$4C                            ; A2BE A9 4C                    .L
        sta     $03A9                           ; A2C0 8D A9 03                 ...
        lda     #$01                            ; A2C3 A9 01                    ..
        sta     $03C1                           ; A2C5 8D C1 03                 ...
        lda     $0529                           ; A2C8 AD 29 05                 .).
        .byte   $09                             ; A2CB 09                       .
LA2CC:  jsr     $298D                           ; A2CC 20 8D 29                  .)
        .byte   $05                             ; A2CF 05                       .
LA2D0:  ldx     #$01                            ; A2D0 A2 01                    ..
        jsr     entity_move_right_collide                           ; A2D2 20 E6 E8                  ..
        jsr     LA1D4                           ; A2D5 20 D4 A1                  ..
        bne     LA2F6                           ; A2D8 D0 1C                    ..
        lda     $0331                           ; A2DA AD 31 03                 .1.
        cmp     #$50                            ; A2DD C9 50                    .P
        bcc     LA2E6                           ; A2DF 90 05                    ..
        lda     #$C0                            ; A2E1 A9 C0                    ..
        sta     $0378                           ; A2E3 8D 78 03                 .x.
LA2E6:  lda     $0331                           ; A2E6 AD 31 03                 .1.
        cmp     #$64                            ; A2E9 C9 64                    .d
        bcc     LA2D0                           ; A2EB 90 E3                    ..
        ldx     #$01                            ; A2ED A2 01                    ..
        lda     #$01                            ; A2EF A9 01                    ..
        jsr     entity_set_subtype                           ; A2F1 20 98 EA                  ..
        lda     #$00                            ; A2F4 A9 00                    ..
LA2F6:  rts                                     ; A2F6 60                       `

; ----------------------------------------------------------------------------
; --- LA2F7: draw the city scene: screen $02 + palette record 2.
LA2F7:  jsr     palette_fade_out                           ; A2F7 20 F1 C3                  ..
        jsr     frame_wait                           ; A2FA 20 22 FF                  ".
        jsr     disable_rendering                           ; A2FD 20 D1 C2                  ..
        lda     #$02                            ; A300 A9 02                    ..
        jsr     LA364                           ; A302 20 64 A3                  d.
        ldx     #$01                            ; A305 A2 01                    ..
        ldy     #$00                            ; A307 A0 00                    ..
        jsr     LA3A8                           ; A309 20 A8 A3                  ..
        jsr     enable_rendering                           ; A30C 20 DB C2                  ..
        jsr     frame_wait                           ; A30F 20 22 FF                  ".
        jmp     palette_fade_in                           ; A312 4C EB C3                 L..

; ----------------------------------------------------------------------------
; --- LA315: hop parade: 9 actors leap on staggered 16-frame cycles
; (dir from $0480 advanced by the LA501 step table, velocity preset
; $28), until every slot has despawned or Start.
LA315:  ldx     #$08                            ; A315 A2 08                    ..
LA317:  lda     $0468,x                         ; A317 BD 68 04                 .h.
        bne     LA335                           ; A31A D0 19                    ..
        lda     #$10                            ; A31C A9 10                    ..
        sta     $0468,x                         ; A31E 9D 68 04                 .h.
        ldy     $0480,x                         ; A321 BC 80 04                 ...
        lda     #$28                            ; A324 A9 28                    .(
        jsr     entity_set_dir_velocity                           ; A326 20 70 F4                  p.
        lda     $0480,x                         ; A329 BD 80 04                 ...
        clc                                     ; A32C 18                       .
        adc     LA501,x                         ; A32D 7D 01 A5                 }..
        and     #$0F                            ; A330 29 0F                    ).
        sta     $0480,x                         ; A332 9D 80 04                 ...
LA335:  dec     $0468,x                         ; A335 DE 68 04                 .h.
        jsr     entity_facing_dispatch                           ; A338 20 65 EA                  e.
        jsr     entity_vert_dispatch_raw                           ; A33B 20 86 EA                  ..
        dex                                     ; A33E CA                       .
        bpl     LA317                           ; A33F 10 D6                    ..
        jsr     LA1D4                           ; A341 20 D4 A1                  ..
        bne     LA363                           ; A344 D0 1D                    ..
        lda     $0300                           ; A346 AD 00 03                 ...
        ora     $0301                           ; A349 0D 01 03                 ...
        ora     $0302                           ; A34C 0D 02 03                 ...
        ora     $0303                           ; A34F 0D 03 03                 ...
        ora     $0304                           ; A352 0D 04 03                 ...
        ora     $0305                           ; A355 0D 05 03                 ...
        ora     $0306                           ; A358 0D 06 03                 ...
        ora     $0307                           ; A35B 0D 07 03                 ...
        ora     $0308                           ; A35E 0D 08 03                 ...
        bne     LA315                           ; A361 D0 B2                    ..
LA363:  rts                                     ; A363 60                       `

; ----------------------------------------------------------------------------
; --- LA364: draw intro screen A ($23) via LDAFC ($27=$0B while drawing)
; and fall through to load palette record A.
LA364:  sta     $23                             ; A364 85 23                    .#
        lda     #$0B                            ; A366 A9 0B                    ..
        sta     $27                             ; A368 85 27                    .'
        lda     #$08                            ; A36A A9 08                    ..
        sta     $10                             ; A36C 85 10                    ..
        jsr     LDAFC                           ; A36E 20 FC DA                  ..
        lda     $23                             ; A371 A5 23                    .#
; --- LA373: palette record loader: LA3FB + A*$12 = 2 CHR banks ($EA/$EB)
; + 16 BG colors; sprite rows fixed from LA467.
LA373:  asl     a                               ; A373 0A                       .
        sta     L0000                           ; A374 85 00                    ..
        asl     a                               ; A376 0A                       .
        asl     a                               ; A377 0A                       .
        asl     a                               ; A378 0A                       .
        adc     L0000                           ; A379 65 00                    e.
        tay                                     ; A37B A8                       .
        lda     LA3FB,y                         ; A37C B9 FB A3                 ...
        sta     $EA                             ; A37F 85 EA                    ..
        lda     LA3FC,y                         ; A381 B9 FC A3                 ...
        sta     $EB                             ; A384 85 EB                    ..
        ldx     #$00                            ; A386 A2 00                    ..
LA388:  lda     LA3FD,y                         ; A388 B9 FD A3                 ...
        sta     $0620,x                         ; A38B 9D 20 06                 . .
        lda     LA467,x                         ; A38E BD 67 A4                 .g.
        sta     $0630,x                         ; A391 9D 30 06                 .0.
        iny                                     ; A394 C8                       .
        inx                                     ; A395 E8                       .
        cpx     #$10                            ; A396 E0 10                    ..
        bne     LA388                           ; A398 D0 EE                    ..
        rts                                     ; A39A 60                       `

; ----------------------------------------------------------------------------
; --- LA39B: load 16 sprite-palette bytes from LA467+Y.
LA39B:  ldx     #$0F                            ; A39B A2 0F                    ..
LA39D:  lda     LA467,y                         ; A39D B9 67 A4                 .g.
        .byte   $9D                             ; A3A0 9D                       .
        .byte   $30                             ; A3A1 30                       0
LA3A2:  asl     $88                             ; A3A2 06 88                    ..
        dex                                     ; A3A4 CA                       .
        bpl     LA39D                           ; A3A5 10 F6                    ..
        rts                                     ; A3A7 60                       `

; ----------------------------------------------------------------------------
; --- LA3A8: spawn X scene actors from record Y: per-actor type LA4A7,
; sub_type LA4B9, X LA4CB, Y LA4DD, hop phase LA4EF -> $0480; $0498
; keeps the record index; all other fields cleared.
LA3A8:  stx     L0000                           ; A3A8 86 00                    ..
        ldx     #$00                            ; A3AA A2 00                    ..
LA3AC:  lda     LA4A7,y                         ; A3AC B9 A7 A4                 ...
        sta     $0300,x                         ; A3AF 9D 00 03                 ...
        lda     LA4B9,y                         ; A3B2 B9 B9 A4                 ...
        jsr     entity_set_subtype                           ; A3B5 20 98 EA                  ..
        lda     LA4CB,y                         ; A3B8 B9 CB A4                 ...
        sta     $0330,x                         ; A3BB 9D 30 03                 .0.
        lda     LA4DD,y                         ; A3BE B9 DD A4                 ...
        sta     $0378,x                         ; A3C1 9D 78 03                 .x.
        lda     LA4EF,y                         ; A3C4 B9 EF A4                 ...
        sta     $0480,x                         ; A3C7 9D 80 04                 ...
        tya                                     ; A3CA 98                       .
        sta     $0498,x                         ; A3CB 9D 98 04                 ...
        lda     #$00                            ; A3CE A9 00                    ..
        sta     $0348,x                         ; A3D0 9D 48 03                 .H.
        sta     $0318,x                         ; A3D3 9D 18 03                 ...
        sta     $0390,x                         ; A3D6 9D 90 03                 ...
        sta     $0360,x                         ; A3D9 9D 60 03                 .`.
        sta     $0468,x                         ; A3DC 9D 68 04                 .h.
        sta     $04B0,x                         ; A3DF 9D B0 04                 ...
        sta     $04C8,x                         ; A3E2 9D C8 04                 ...
        sta     $04E0,x                         ; A3E5 9D E0 04                 ...
        sta     $04F8,x                         ; A3E8 9D F8 04                 ...
        sta     $0510,x                         ; A3EB 9D 10 05                 ...
        inx                                     ; A3EE E8                       .
        iny                                     ; A3EF C8                       .
        dec     L0000                           ; A3F0 C6 00                    ..
        bne     LA3AC                           ; A3F2 D0 B8                    ..
        lda     #$01                            ; A3F4 A9 01                    ..
        sta     $9D                             ; A3F6 85 9D                    ..
        jmp     render_tick_frame                           ; A3F8 4C 63 F3                 Lc.

; ----------------------------------------------------------------------------
; --- LA3FB: intro data: palette records (LA373), LA467 sprite rows,
; LA4A7/LA4B9/LA4CB/LA4DD/LA4EF actor spawn records (LA3A8),
; LA501 hop-direction step table.
LA3FB:  .byte   $D4                             ; A3FB D4                       .
LA3FC:  .byte   $D6                             ; A3FC D6                       .
LA3FD:  .byte   $0F                             ; A3FD 0F                       .
        .byte   $27                             ; A3FE 27                       '
        .byte   $2B                             ; A3FF 2B                       +
        .byte   $1A                             ; A400 1A                       .
        .byte   $0F                             ; A401 0F                       .
        jsr     L1121                           ; A402 20 21 11                  !.
        .byte   $0F                             ; A405 0F                       .
        jsr     L1614                           ; A406 20 14 16                  ..
        .byte   $0F                             ; A409 0F                       .
        brk                                     ; A40A 00                       .
        brk                                     ; A40B 00                       .
        brk                                     ; A40C 00                       .
        .byte   $D4                             ; A40D D4                       .
        dec     $0F,x                           ; A40E D6 0F                    ..
        jsr     L192A                           ; A410 20 2A 19                  *.
        .byte   $0F                             ; A413 0F                       .
        jsr     L1322                           ; A414 20 22 13                  ".
        .byte   $0F                             ; A417 0F                       .
        brk                                     ; A418 00                       .
        brk                                     ; A419 00                       .
        brk                                     ; A41A 00                       .
        .byte   $0F                             ; A41B 0F                       .
        brk                                     ; A41C 00                       .
        brk                                     ; A41D 00                       .
        brk                                     ; A41E 00                       .
        cpx     #$E2                            ; A41F E0 E2                    ..
        .byte   $0F                             ; A421 0F                       .
        and     ($12,x)                         ; A422 21 12                    !.
        .byte   $03                             ; A424 03                       .
        .byte   $0F                             ; A425 0F                       .
        ora     ($0F),y                         ; A426 11 0F                    ..
        ora     ($0F,x)                         ; A428 01 0F                    ..
        and     ($12,x)                         ; A42A 21 12                    !.
        ora     ($0F,x)                         ; A42C 01 0F                    ..
        .byte   $12                             ; A42E 12                       .
        .byte   $03                             ; A42F 03                       .
        ora     ($AC,x)                         ; A430 01 AC                    ..
        ldx     $210F                           ; A432 AE 0F 21                 ..!
        ora     ($01),y                         ; A435 11 01                    ..
        .byte   $0F                             ; A437 0F                       .
        ora     ($29),y                         ; A438 11 29                    .)
        ora     $200F,y                         ; A43A 19 0F 20                 .. 
LA43D:  ora     ($01),y                         ; A43D 11 01                    ..
        .byte   $0F                             ; A43F 0F                       .
        jsr     L1121                           ; A440 20 21 11                  !.
        cpx     #$E2                            ; A443 E0 E2                    ..
        bmi     LA477                           ; A445 30 30                    00
        bmi     LA479                           ; A447 30 30                    00
        bmi     LA47B                           ; A449 30 30                    00
        bmi     LA47D                           ; A44B 30 30                    00
        bmi     LA47F                           ; A44D 30 30                    00
        bmi     LA481                           ; A44F 30 30                    00
        bmi     LA483                           ; A451 30 30                    00
        bmi     LA485                           ; A453 30 30                    00
        cpy     $C6                             ; A455 C4 C6                    ..
        .byte   $0F                             ; A457 0F                       .
        ora     ($21),y                         ; A458 11 21                    .!
        asl     $0F,x                           ; A45A 16 0F                    ..
        bmi     LA47F                           ; A45C 30 21                    0!
        asl     $0F,x                           ; A45E 16 0F                    ..
        rol     $28                             ; A460 26 28                    &(
        asl     $0F,x                           ; A462 16 0F                    ..
        .byte   $17                             ; A464 17                       .
        .byte   $27                             ; A465 27                       '
        .byte   $06                             ; A466 06                       .
LA467:  .byte   $0F                             ; A467 0F                       .
        .byte   $0F                             ; A468 0F                       .
        bit     $0F11                           ; A469 2C 11 0F                 ,..
        .byte   $0F                             ; A46C 0F                       .
        jsr     L0F37                           ; A46D 20 37 0F                  7.
        .byte   $0F                             ; A470 0F                       .
        .byte   $27                             ; A471 27                       '
        .byte   $17                             ; A472 17                       .
        .byte   $0F                             ; A473 0F                       .
        .byte   $0F                             ; A474 0F                       .
        .byte   $20                             ; A475 20                        
        .byte   $25                             ; A476 25                       %
LA477:  .byte   $0F                             ; A477 0F                       .
        .byte   $0F                             ; A478 0F                       .
LA479:  .byte   $2C                             ; A479 2C                       ,
        .byte   $11                             ; A47A 11                       .
LA47B:  .byte   $0F                             ; A47B 0F                       .
        .byte   $0F                             ; A47C 0F                       .
LA47D:  .byte   $20                             ; A47D 20                        
        .byte   $37                             ; A47E 37                       7
LA47F:  .byte   $0F                             ; A47F 0F                       .
        .byte   $0F                             ; A480 0F                       .
LA481:  .byte   $20                             ; A481 20                        
        .byte   $16                             ; A482 16                       .
LA483:  .byte   $0F                             ; A483 0F                       .
        .byte   $0F                             ; A484 0F                       .
LA485:  jsr     L0F25                           ; A485 20 25 0F                  %.
        .byte   $0F                             ; A488 0F                       .
        bit     $0F11                           ; A489 2C 11 0F                 ,..
        .byte   $0F                             ; A48C 0F                       .
        rol     $26,x                           ; A48D 36 26                    6&
        .byte   $0F                             ; A48F 0F                       .
        .byte   $0F                             ; A490 0F                       .
        .byte   $27                             ; A491 27                       '
        .byte   $17                             ; A492 17                       .
        .byte   $0F                             ; A493 0F                       .
        .byte   $0F                             ; A494 0F                       .
        jsr     L0F25                           ; A495 20 25 0F                  %.
        brk                                     ; A498 00                       .
        brk                                     ; A499 00                       .
        brk                                     ; A49A 00                       .
        .byte   $0F                             ; A49B 0F                       .
        brk                                     ; A49C 00                       .
        brk                                     ; A49D 00                       .
        brk                                     ; A49E 00                       .
        .byte   $0F                             ; A49F 0F                       .
        ora     ($21),y                         ; A4A0 11 21                    .!
        asl     $0F,x                           ; A4A2 16 0F                    ..
        brk                                     ; A4A4 00                       .
        brk                                     ; A4A5 00                       .
        brk                                     ; A4A6 00                       .
LA4A7:  asl     $1E1E,x                         ; A4A7 1E 1E 1E                 ...
        asl     $1E1E,x                         ; A4AA 1E 1E 1E                 ...
        asl     $1E1E,x                         ; A4AD 1E 1E 1E                 ...
        asl     $1E1E,x                         ; A4B0 1E 1E 1E                 ...
        adc     $1E01                           ; A4B3 6D 01 1E                 m..
        asl     $1E1E,x                         ; A4B6 1E 1E 1E                 ...
LA4B9:  .byte   $13                             ; A4B9 13                       .
        ora     $14,x                           ; A4BA 15 14                    ..
        ora     $14,x                           ; A4BC 15 14                    ..
        .byte   $14                             ; A4BE 14                       .
        ora     $14,x                           ; A4BF 15 14                    ..
        .byte   $14                             ; A4C1 14                       .
        ora     $1A,x                           ; A4C2 15 1A                    ..
        clc                                     ; A4C4 18                       .
        adc     $A2                             ; A4C5 65 A2                    e.
        .byte   $12                             ; A4C7 12                       .
        ora     ($16),y                         ; A4C8 11 16                    ..
        .byte   $19                             ; A4CA 19                       .
LA4CB:  .byte   $80                             ; A4CB 80                       .
        .byte   $80                             ; A4CC 80                       .
        .byte   $80                             ; A4CD 80                       .
        .byte   $80                             ; A4CE 80                       .
        .byte   $80                             ; A4CF 80                       .
        .byte   $80                             ; A4D0 80                       .
        .byte   $80                             ; A4D1 80                       .
        .byte   $80                             ; A4D2 80                       .
        .byte   $80                             ; A4D3 80                       .
        .byte   $80                             ; A4D4 80                       .
        .byte   $80                             ; A4D5 80                       .
        bmi     LA534                           ; A4D6 30 5C                    0\
        .byte   $34                             ; A4D8 34                       4
        bvc     LA52B                           ; A4D9 50 50                    PP
        sty     $58,x                           ; A4DB 94 58                    .X
LA4DD:  .byte   $7B                             ; A4DD 7B                       {
        sei                                     ; A4DE 78                       x
        sei                                     ; A4DF 78                       x
        sei                                     ; A4E0 78                       x
        sei                                     ; A4E1 78                       x
        sei                                     ; A4E2 78                       x
        sei                                     ; A4E3 78                       x
        sei                                     ; A4E4 78                       x
        sei                                     ; A4E5 78                       x
        sei                                     ; A4E6 78                       x
        .byte   $80                             ; A4E7 80                       .
        .byte   $77                             ; A4E8 77                       w
        .byte   $93                             ; A4E9 93                       .
        .byte   $73                             ; A4EA 73                       s
        .byte   $43                             ; A4EB 43                       C
        .byte   $4B                             ; A4EC 4B                       K
        sta     $6B                             ; A4ED 85 6B                    .k
LA4EF:  brk                                     ; A4EF 00                       .
        .byte   $0C                             ; A4F0 0C                       .
        ora     $0F0E                           ; A4F1 0D 0E 0F                 ...
        brk                                     ; A4F4 00                       .
        ora     (L0002,x)                       ; A4F5 01 02                    ..
        .byte   $03                             ; A4F7 03                       .
        .byte   $04                             ; A4F8 04                       .
        brk                                     ; A4F9 00                       .
        brk                                     ; A4FA 00                       .
        brk                                     ; A4FB 00                       .
        brk                                     ; A4FC 00                       .
        brk                                     ; A4FD 00                       .
        brk                                     ; A4FE 00                       .
        brk                                     ; A4FF 00                       .
        brk                                     ; A500 00                       .
LA501:  .byte   $FF                             ; A501 FF                       .
        .byte   $FF                             ; A502 FF                       .
        .byte   $FF                             ; A503 FF                       .
        .byte   $FF                             ; A504 FF                       .
        brk                                     ; A505 00                       .
        ora     ($01,x)                         ; A506 01 01                    ..
        ora     ($01,x)                         ; A508 01 01                    ..
; --- LA50A: wait X frames; returns NZ if Start pressed.
LA50A:  stx     $0F                             ; A50A 86 0F                    ..
LA50C:  jsr     LA1D4                           ; A50C 20 D4 A1                  ..
        bne     LA515                           ; A50F D0 04                    ..
        dec     $0F                             ; A511 C6 0F                    ..
        bne     LA50C                           ; A513 D0 F7                    ..
LA515:  rts                                     ; A515 60                       `

; ----------------------------------------------------------------------------
; --- LA516: wait X frames, whistling: each time the actor's anim phase
; reaches $0C, bump its sub_type and play the whistle ($2B).
LA516:  stx     $0F                             ; A516 86 0F                    ..
LA518:  jsr     LA1D4                           ; A518 20 D4 A1                  ..
        bne     LA53E                           ; A51B D0 21                    .!
        lda     $0540                           ; A51D AD 40 05                 .@.
        cmp     #$0C                            ; A520 C9 0C                    ..
        bne     LA53A                           ; A522 D0 16                    ..
        inc     $0558                           ; A524 EE 58 05                 .X.
        lda     $0558                           ; A527 AD 58 05                 .X.
        .byte   $C9                             ; A52A C9                       .
LA52B:  ora     $02D0,x                         ; A52B 1D D0 02                 ...
        lda     #$1A                            ; A52E A9 1A                    ..
        ldx     #$00                            ; A530 A2 00                    ..
        .byte   $20                             ; A532 20                        
        tya                                     ; A533 98                       .
LA534:  nop                                     ; A534 EA                       .
        lda     #$2B                            ; A535 A9 2B                    .+
        jsr     queue_sound                           ; A537 20 5D EC                  ].
LA53A:  dec     $0F                             ; A53A C6 0F                    ..
        bne     LA518                           ; A53C D0 DA                    ..
LA53E:  rts                                     ; A53E 60                       `

; ----------------------------------------------------------------------------
; --- LA53F: story text page A: full clear to tile $28 on NT $2800,
; dialog palette LA59C, page text from LA5A3 (offsets LA5A0) flushed in
; one go, fade in.
LA53F:  pha                                     ; A53F 48                       H
        jsr     palette_fade_out                           ; A540 20 F1 C3                  ..
        jsr     oam_clear                           ; A543 20 8F C3                  ..
        jsr     entity_clear_all                           ; A546 20 9D C3                  ..
        jsr     frame_wait                           ; A549 20 22 FF                  ".
        jsr     disable_rendering                           ; A54C 20 D1 C2                  ..
        lda     #$02                            ; A54F A9 02                    ..
        sta     $FD                             ; A551 85 FD                    ..
        ldy     #$03                            ; A553 A0 03                    ..
LA555:  lda     LA59C,y                         ; A555 B9 9C A5                 ...
        sta     $0620,y                         ; A558 99 20 06                 . .
        sta     $0624,y                         ; A55B 99 24 06                 .$.
        sta     $0628,y                         ; A55E 99 28 06                 .(.
        sta     $062C,y                         ; A561 99 2C 06                 .,.
        dey                                     ; A564 88                       .
        bpl     LA555                           ; A565 10 EE                    ..
        lda     #$C2                            ; A567 A9 C2                    ..
        sta     $EA                             ; A569 85 EA                    ..
        lda     #$C0                            ; A56B A9 C0                    ..
        sta     $EB                             ; A56D 85 EB                    ..
        lda     #$28                            ; A56F A9 28                    .(
        ldx     #$00                            ; A571 A2 00                    ..
        ldy     #$00                            ; A573 A0 00                    ..
        jsr     ppu_fill_nametable                           ; A575 20 43 C3                  C.
        pla                                     ; A578 68                       h
        tax                                     ; A579 AA                       .
        ldy     LA5A0,x                         ; A57A BC A0 A5                 ...
        ldx     #$00                            ; A57D A2 00                    ..
        stx     $0300                           ; A57F 8E 00 03                 ...
LA582:  lda     LA5A3,y                         ; A582 B9 A3 A5                 ...
        sta     $0780,x                         ; A585 9D 80 07                 ...
        cmp     #$FF                            ; A588 C9 FF                    ..
        beq     LA590                           ; A58A F0 04                    ..
        inx                                     ; A58C E8                       .
        iny                                     ; A58D C8                       .
        bne     LA582                           ; A58E D0 F2                    ..
LA590:  jsr     nametable_flush                           ; A590 20 98 C2                  ..
        jsr     enable_rendering                           ; A593 20 DB C2                  ..
        jsr     frame_wait                           ; A596 20 22 FF                  ".
        jmp     palette_fade_in                           ; A599 4C EB C3                 L..

; ----------------------------------------------------------------------------
LA59C:  .byte   $0F                             ; A59C 0F                       .
        bmi     LA5CF                           ; A59D 30 30                    00
        .byte   $30                             ; A59F 30                       0
LA5A0:  brk                                     ; A5A0 00                       .
        .byte   $1A                             ; A5A1 1A                       .
        .byte   $5C                             ; A5A2 5C                       \
; --- LA5A3: story page text (ASCII), 3 pages, $FF-terminated:
; "IN THE YEAR 20XX..".
LA5A3:  and     #$A6                            ; A5A3 29 A6                    ).
        ora     $49,x                           ; A5A5 15 49                    .I
        lsr     $5420                           ; A5A7 4E 20 54                 N T
        pha                                     ; A5AA 48                       H
        eor     $20                             ; A5AB 45 20                    E 
        eor     $4145,y                         ; A5AD 59 45 41                 YEA
        .byte   $52                             ; A5B0 52                       R
        jsr     L3032                           ; A5B1 20 32 30                  20
        cli                                     ; A5B4 58                       X
        cli                                     ; A5B5 58                       X
        jsr     L4441                           ; A5B6 20 41 44                  AD
        rol     $2E2E                           ; A5B9 2E 2E 2E                 ...
        .byte   $FF                             ; A5BC FF                       .
        and     #$69                            ; A5BD 29 69                    )i
        ora     $2041                           ; A5BF 0D 41 20                 .A 
        lsr     $49,x                           ; A5C2 56 49                    VI
        .byte   $43                             ; A5C4 43                       C
        eor     #$4F                            ; A5C5 49 4F                    IO
        eor     $53,x                           ; A5C7 55 53                    US
        jsr     L5241                           ; A5C9 20 41 52                  AR
        eor     $2959                           ; A5CC 4D 59 29                 MY)
LA5CF:  ldx     $13                             ; A5CF A6 13                    ..
        .byte   $4F                             ; A5D1 4F                       O
        lsr     $20                             ; A5D2 46 20                    F 
        .byte   $52                             ; A5D4 52                       R
        .byte   $4F                             ; A5D5 4F                       O
        .byte   $42                             ; A5D6 42                       B
        .byte   $4F                             ; A5D7 4F                       O
        .byte   $54                             ; A5D8 54                       T
        .byte   $53                             ; A5D9 53                       S
        jsr     L5349                           ; A5DA 20 49 53                  IS
        jsr     L4542                           ; A5DD 20 42 45                  BE
        lsr     $2054                           ; A5E0 4E 54 20                 NT 
        .byte   $4F                             ; A5E3 4F                       O
        lsr     $E629                           ; A5E4 4E 29 E6                 N).
        ora     $44,x                           ; A5E7 15 44                    .D
        eor     $53                             ; A5E9 45 53                    ES
        .byte   $54                             ; A5EB 54                       T
        .byte   $52                             ; A5EC 52                       R
        .byte   $4F                             ; A5ED 4F                       O
        eor     $4E49,y                         ; A5EE 59 49 4E                 YIN
        .byte   $47                             ; A5F1 47                       G
        jsr     L4854                           ; A5F2 20 54 48                  TH
        eor     $20                             ; A5F5 45 20                    E 
        .byte   $57                             ; A5F7 57                       W
        .byte   $4F                             ; A5F8 4F                       O
        .byte   $52                             ; A5F9 52                       R
        jmp     L2144                           ; A5FA 4C 44 21                 LD!

; ----------------------------------------------------------------------------
        and     ($FF,x)                         ; A5FD 21 FF                    !.
        and     #$8A                            ; A5FF 29 8A                    ).
        ora     #$41                            ; A601 09 41                    .A
        lsr     $2044                           ; A603 4E 44 20                 ND 
        .byte   $42                             ; A606 42                       B
        eor     $48                             ; A607 45 48                    EH
        eor     #$4E                            ; A609 49 4E                    IN
        .byte   $44                             ; A60B 44                       D
        and     #$E6                            ; A60C 29 E6                    ).
        ora     $54,x                           ; A60E 15 54                    .T
        pha                                     ; A610 48                       H
        eor     #$53                            ; A611 49 53                    IS
        jsr     L4544                           ; A613 20 44 45                  DE
        .byte   $53                             ; A616 53                       S
        .byte   $54                             ; A617 54                       T
        .byte   $52                             ; A618 52                       R
        eor     $43,x                           ; A619 55 43                    UC
        .byte   $54                             ; A61B 54                       T
        eor     #$4F                            ; A61C 49 4F                    IO
        lsr     $4920                           ; A61E 4E 20 49                 N I
        .byte   $53                             ; A621 53                       S
        rol     $2E2E                           ; A622 2E 2E 2E                 ...
        .byte   $FF                             ; A625 FF                       .
; =============================================================================
; WILY 1 STAGE DATA — $A626-$BFFF (stage $0C's data bank; screen table
; at $A900, metatile strips $B600+; see the stage-data format pass)
; =============================================================================
        sbc     $C7D1,x                         ; A626 FD D1 C7                 ...
        adc     $FF,x                           ; A629 75 FF                    u.
        eor     $FF,x                           ; A62B 55 FF                    U.
        .byte   $5B                             ; A62D 5B                       [
        inc     $DD75,x                         ; A62E FE 75 DD                 .u.
        adc     $DFFF,x                         ; A631 7D FF DF                 }..
        .byte   $FF                             ; A634 FF                       .
        .byte   $5F                             ; A635 5F                       _
        .byte   $FF                             ; A636 FF                       .
        .byte   $FF                             ; A637 FF                       .
        .byte   $FF                             ; A638 FF                       .
        .byte   $DF                             ; A639 DF                       .
        .byte   $FF                             ; A63A FF                       .
        .byte   $FF                             ; A63B FF                       .
        .byte   $FF                             ; A63C FF                       .
        .byte   $FF                             ; A63D FF                       .
        .byte   $FF                             ; A63E FF                       .
        .byte   $FF                             ; A63F FF                       .
        inc     $55,x                           ; A640 F6 55                    .U
        .byte   $FF                             ; A642 FF                       .
        .byte   $5C                             ; A643 5C                       \
        .byte   $FF                             ; A644 FF                       .
        ora     $D5FF,x                         ; A645 1D FF D5                 ...
        .byte   $77                             ; A648 77                       w
        sbc     $EE,x                           ; A649 F5 EE                    ..
        adc     $FF,x                           ; A64B 75 FF                    u.
        adc     $FF,x                           ; A64D 75 FF                    u.
        adc     $F7FF,x                         ; A64F 7D FF F7                 }..
        sbc     $FF7F,x                         ; A652 FD 7F FF                 ...
        .byte   $FF                             ; A655 FF                       .
        .byte   $FF                             ; A656 FF                       .
        .byte   $FF                             ; A657 FF                       .
        .byte   $FF                             ; A658 FF                       .
        .byte   $FF                             ; A659 FF                       .
        .byte   $FF                             ; A65A FF                       .
        .byte   $FF                             ; A65B FF                       .
        .byte   $FF                             ; A65C FF                       .
        .byte   $DF                             ; A65D DF                       .
        .byte   $FF                             ; A65E FF                       .
        sbc     $55FE,x                         ; A65F FD FE 55                 ..U
        .byte   $FB                             ; A662 FB                       .
        eor     $FF                             ; A663 45 FF                    E.
        cmp     $15,x                           ; A665 D5 15                    ..
        eor     $FF,x                           ; A667 55 FF                    U.
        .byte   $54                             ; A669 54                       T
        .byte   $DF                             ; A66A DF                       .
        eor     ($FB,x)                         ; A66B 41 FB                    A.
        eor     $BB,x                           ; A66D 55 BB                    U.
        eor     $F9,x                           ; A66F 55 F9                    U.
        cmp     $FF,x                           ; A671 D5 FF                    ..
        cmp     $FF,x                           ; A673 D5 FF                    ..
        eor     $FF,x                           ; A675 55 FF                    U.
        cmp     $DDFF,x                         ; A677 DD FF DD                 ...
        .byte   $FF                             ; A67A FF                       .
        sbc     $F7FF,x                         ; A67B FD FF F7                 ...
        .byte   $FF                             ; A67E FF                       .
        sbc     $58BF,x                         ; A67F FD BF 58                 ..X
        inc     $FB59,x                         ; A682 FE 59 FB                 .Y.
        .byte   $DC                             ; A685 DC                       .
        .byte   $FF                             ; A686 FF                       .
        .byte   $5F                             ; A687 5F                       _
        .byte   $77                             ; A688 77                       w
        eor     $FF,x                           ; A689 55 FF                    U.
        .byte   $F7                             ; A68B F7                       .
        .byte   $FF                             ; A68C FF                       .
        cmp     $FDFF,x                         ; A68D DD FF FD                 ...
        .byte   $FF                             ; A690 FF                       .
        .byte   $53                             ; A691 53                       S
        .byte   $FF                             ; A692 FF                       .
        .byte   $DF                             ; A693 DF                       .
        .byte   $FF                             ; A694 FF                       .
        .byte   $FF                             ; A695 FF                       .
        .byte   $FF                             ; A696 FF                       .
        sbc     $FFFF,x                         ; A697 FD FF FF                 ...
        .byte   $FF                             ; A69A FF                       .
        .byte   $FF                             ; A69B FF                       .
        .byte   $FF                             ; A69C FF                       .
        sbc     $FDFF,x                         ; A69D FD FF FD                 ...
        .byte   $D7                             ; A6A0 D7                       .
        ora     ($FF),y                         ; A6A1 11 FF                    ..
        .byte   $57                             ; A6A3 57                       W
        .byte   $FF                             ; A6A4 FF                       .
        eor     $E6,x                           ; A6A5 55 E6                    U.
        eor     $FB,x                           ; A6A7 55 FB                    U.
        eor     $FF,x                           ; A6A9 55 FF                    U.
        .byte   $5F                             ; A6AB 5F                       _
        .byte   $B7                             ; A6AC B7                       .
        eor     $FF,x                           ; A6AD 55 FF                    U.
        .byte   $77                             ; A6AF 77                       w
        .byte   $FF                             ; A6B0 FF                       .
        sta     $FF,x                           ; A6B1 95 FF                    ..
        adc     $75FF,x                         ; A6B3 7D FF 75                 }.u
        .byte   $FF                             ; A6B6 FF                       .
        .byte   $DF                             ; A6B7 DF                       .
        .byte   $FF                             ; A6B8 FF                       .
        .byte   $77                             ; A6B9 77                       w
        .byte   $FF                             ; A6BA FF                       .
        .byte   $5F                             ; A6BB 5F                       _
        .byte   $FF                             ; A6BC FF                       .
        sbc     $FFFF,x                         ; A6BD FD FF FF                 ...
        .byte   $FF                             ; A6C0 FF                       .
        adc     $FB,x                           ; A6C1 75 FB                    u.
        adc     $F7,x                           ; A6C3 75 F7                    u.
        eor     $DF,x                           ; A6C5 55 DF                    U.
        sbc     $5F,x                           ; A6C7 F5 5F                    ._
        eor     $FD,x                           ; A6C9 55 FD                    U.
        .byte   $7F                             ; A6CB 7F                       .
        .byte   $FF                             ; A6CC FF                       .
        .byte   $F4                             ; A6CD F4                       .
        .byte   $EF                             ; A6CE EF                       .
        eor     $7F,x                           ; A6CF 55 7F                    U.
        .byte   $DF                             ; A6D1 DF                       .
        .byte   $FF                             ; A6D2 FF                       .
        .byte   $D7                             ; A6D3 D7                       .
        .byte   $FF                             ; A6D4 FF                       .
        .byte   $FF                             ; A6D5 FF                       .
        .byte   $FF                             ; A6D6 FF                       .
        .byte   $F7                             ; A6D7 F7                       .
        .byte   $FF                             ; A6D8 FF                       .
        .byte   $FF                             ; A6D9 FF                       .
        .byte   $FF                             ; A6DA FF                       .
        .byte   $FF                             ; A6DB FF                       .
        .byte   $FF                             ; A6DC FF                       .
        .byte   $FF                             ; A6DD FF                       .
        .byte   $FF                             ; A6DE FF                       .
        sbc     $65FF,x                         ; A6DF FD FF 65                 ..e
        .byte   $BF                             ; A6E2 BF                       .
        eor     $ED                             ; A6E3 45 ED                    E.
        eor     $F9,x                           ; A6E5 55 F9                    U.
        adc     $FF,x                           ; A6E7 75 FF                    u.
        .byte   $54                             ; A6E9 54                       T
        .byte   $DB                             ; A6EA DB                       .
        .byte   $57                             ; A6EB 57                       W
        .byte   $FF                             ; A6EC FF                       .
        cmp     $F7,x                           ; A6ED D5 F7                    ..
        eor     $54EB,x                         ; A6EF 5D EB 54                 ].T
        .byte   $AF                             ; A6F2 AF                       .
        rti                                     ; A6F3 40                       @

; ----------------------------------------------------------------------------
        .byte   $FF                             ; A6F4 FF                       .
        .byte   $34                             ; A6F5 34                       4
        .byte   $FF                             ; A6F6 FF                       .
        .byte   $74                             ; A6F7 74                       t
        .byte   $FF                             ; A6F8 FF                       .
        and     $7F,x                           ; A6F9 35 7F                    5.
        eor     $FF,x                           ; A6FB 55 FF                    U.
        .byte   $77                             ; A6FD 77                       w
        .byte   $FF                             ; A6FE FF                       .
        .byte   $FF                             ; A6FF FF                       .
        .byte   $FF                             ; A700 FF                       .
        eor     $FF                             ; A701 45 FF                    E.
        adc     $FB,x                           ; A703 75 FB                    u.
        .byte   $D4                             ; A705 D4                       .
        .byte   $FF                             ; A706 FF                       .
        eor     $B7,x                           ; A707 55 B7                    U.
        .byte   $D7                             ; A709 D7                       .
        .byte   $FF                             ; A70A FF                       .
        .byte   $7F                             ; A70B 7F                       .
        inc     $FEFF,x                         ; A70C FE FF FE                 ...
        sbc     $FF,x                           ; A70F F5 FF                    ..
        cmp     $FFFF,x                         ; A711 DD FF FF                 ...
        .byte   $FF                             ; A714 FF                       .
        .byte   $FF                             ; A715 FF                       .
        .byte   $FF                             ; A716 FF                       .
        .byte   $7F                             ; A717 7F                       .
        .byte   $FF                             ; A718 FF                       .
        .byte   $FF                             ; A719 FF                       .
        .byte   $FF                             ; A71A FF                       .
        sbc     $FF,x                           ; A71B F5 FF                    ..
        .byte   $FF                             ; A71D FF                       .
        .byte   $FF                             ; A71E FF                       .
        .byte   $FF                             ; A71F FF                       .
        .byte   $EF                             ; A720 EF                       .
        eor     $FF                             ; A721 45 FF                    E.
        and     $FB,x                           ; A723 35 FB                    5.
        eor     $FF,x                           ; A725 55 FF                    U.
        ora     $5F,x                           ; A727 15 5F                    ._
        cmp     $FF,x                           ; A729 D5 FF                    ..
        adc     $BF,x                           ; A72B 75 BF                    u.
        .byte   $57                             ; A72D 57                       W
        .byte   $FF                             ; A72E FF                       .
        cmp     $FF,x                           ; A72F D5 FF                    ..
        .byte   $D3                             ; A731 D3                       .
        .byte   $FF                             ; A732 FF                       .
        adc     $FDFF,x                         ; A733 7D FF FD                 }..
        .byte   $FF                             ; A736 FF                       .
        .byte   $D7                             ; A737 D7                       .
        .byte   $FF                             ; A738 FF                       .
        .byte   $FF                             ; A739 FF                       .
        .byte   $FF                             ; A73A FF                       .
        adc     $FF,x                           ; A73B 75 FF                    u.
        .byte   $F7                             ; A73D F7                       .
        .byte   $FF                             ; A73E FF                       .
        sbc     $41DE,x                         ; A73F FD DE 41                 ..A
        .byte   $FF                             ; A742 FF                       .
        .byte   $F7                             ; A743 F7                       .
        .byte   $FF                             ; A744 FF                       .
        eor     $FF,x                           ; A745 55 FF                    U.
        eor     $757B,y                         ; A747 59 7B 75                 Y{u
        .byte   $EF                             ; A74A EF                       .
        eor     $DF,x                           ; A74B 55 DF                    U.
        .byte   $77                             ; A74D 77                       w
        .byte   $FF                             ; A74E FF                       .
        .byte   $7F                             ; A74F 7F                       .
        .byte   $FF                             ; A750 FF                       .
        .byte   $DF                             ; A751 DF                       .
        .byte   $FF                             ; A752 FF                       .
        .byte   $F7                             ; A753 F7                       .
        .byte   $FF                             ; A754 FF                       .
        .byte   $7F                             ; A755 7F                       .
        .byte   $FF                             ; A756 FF                       .
        .byte   $7F                             ; A757 7F                       .
        sbc     $FFF5,x                         ; A758 FD F5 FF                 ...
        adc     $FFFF,x                         ; A75B 7D FF FF                 }..
        .byte   $FF                             ; A75E FF                       .
        .byte   $FF                             ; A75F FF                       .
        .byte   $7F                             ; A760 7F                       .
        eor     $7D,x                           ; A761 55 7D                    U}
        adc     $DF,x                           ; A763 75 DF                    u.
        adc     $E3                             ; A765 65 E3                    e.
        eor     ($EF,x)                         ; A767 41 EF                    A.
        .byte   $14                             ; A769 14                       .
        .byte   $FB                             ; A76A FB                       .
        ora     $F5,x                           ; A76B 15 F5                    ..
        eor     $FC,x                           ; A76D 55 FC                    U.
        .byte   $5F                             ; A76F 5F                       _
        .byte   $7B                             ; A770 7B                       {
        .byte   $57                             ; A771 57                       W
        sbc     $57                             ; A772 E5 57                    .W
        .byte   $EF                             ; A774 EF                       .
        cmp     $FF,x                           ; A775 D5 FF                    ..
        cmp     $DFFF,x                         ; A777 DD FF DF                 ...
        .byte   $FF                             ; A77A FF                       .
        .byte   $FF                             ; A77B FF                       .
        .byte   $FF                             ; A77C FF                       .
        cmp     $FFFF,x                         ; A77D DD FF FF                 ...
        sbc     $7D76,x                         ; A780 FD 76 7D                 .v}
        .byte   $D4                             ; A783 D4                       .
        inc     $FF55,x                         ; A784 FE 55 FF                 .U.
        .byte   $DF                             ; A787 DF                       .
        .byte   $FF                             ; A788 FF                       .
        eor     $FF,x                           ; A789 55 FF                    U.
        .byte   $DC                             ; A78B DC                       .
        .byte   $FF                             ; A78C FF                       .
        .byte   $DF                             ; A78D DF                       .
        .byte   $FF                             ; A78E FF                       .
        .byte   $FF                             ; A78F FF                       .
        inc     $FF7D,x                         ; A790 FE 7D FF                 .}.
        .byte   $7F                             ; A793 7F                       .
        .byte   $FF                             ; A794 FF                       .
        sbc     $DFFF,x                         ; A795 FD FF DF                 ...
        .byte   $FF                             ; A798 FF                       .
        sbc     $FFFF,x                         ; A799 FD FF FF                 ...
        .byte   $FF                             ; A79C FF                       .
        .byte   $FF                             ; A79D FF                       .
        .byte   $FF                             ; A79E FF                       .
        sbc     $F5BF,x                         ; A79F FD BF F5                 ...
        .byte   $7F                             ; A7A2 7F                       .
        and     ($FE),y                         ; A7A3 31 FE                    1.
        eor     $77,x                           ; A7A5 55 77                    Uw
        eor     $15FE,x                         ; A7A7 5D FE 15                 ]..
        .byte   $6B                             ; A7AA 6B                       k
        .byte   $D3                             ; A7AB D3                       .
        .byte   $F7                             ; A7AC F7                       .
        adc     $55FB,x                         ; A7AD 7D FB 55                 }.U
        .byte   $FB                             ; A7B0 FB                       .
        adc     $FF,x                           ; A7B1 75 FF                    u.
        eor     $FF,x                           ; A7B3 55 FF                    U.
        cmp     $FF,x                           ; A7B5 D5 FF                    ..
        sbc     $FF,x                           ; A7B7 F5 FF                    ..
        cmp     $F7FF,x                         ; A7B9 DD FF F7                 ...
        .byte   $F7                             ; A7BC F7                       .
        .byte   $7F                             ; A7BD 7F                       .
        .byte   $FF                             ; A7BE FF                       .
        .byte   $FF                             ; A7BF FF                       .
        inc     $FF55,x                         ; A7C0 FE 55 FF                 .U.
        cmp     $FD                             ; A7C3 C5 FD                    ..
        adc     $FF,x                           ; A7C5 75 FF                    u.
        eor     $F5FF,x                         ; A7C7 5D FF F5                 ]..
        .byte   $FF                             ; A7CA FF                       .
        sta     $75FF,x                         ; A7CB 9D FF 75                 ..u
        .byte   $FF                             ; A7CE FF                       .
        sbc     $FF,x                           ; A7CF F5 FF                    ..
        .byte   $5F                             ; A7D1 5F                       _
        .byte   $FF                             ; A7D2 FF                       .
        .byte   $77                             ; A7D3 77                       w
        .byte   $FF                             ; A7D4 FF                       .
        .byte   $7F                             ; A7D5 7F                       .
        .byte   $FF                             ; A7D6 FF                       .
        .byte   $FF                             ; A7D7 FF                       .
        .byte   $FF                             ; A7D8 FF                       .
        .byte   $FF                             ; A7D9 FF                       .
        .byte   $FF                             ; A7DA FF                       .
        .byte   $FF                             ; A7DB FF                       .
        .byte   $FF                             ; A7DC FF                       .
        .byte   $F7                             ; A7DD F7                       .
        .byte   $FF                             ; A7DE FF                       .
        .byte   $F7                             ; A7DF F7                       .
        .byte   $FF                             ; A7E0 FF                       .
        eor     $FF,x                           ; A7E1 55 FF                    U.
        eor     ($FF),y                         ; A7E3 51 FF                    Q.
        adc     $3D,x                           ; A7E5 75 3D                    u=
        sta     $14FF,x                         ; A7E7 9D FF 14                 ...
        .byte   $FC                             ; A7EA FC                       .
        eor     $17,x                           ; A7EB 55 17                    U.
        .byte   $54                             ; A7ED 54                       T
        .byte   $6B                             ; A7EE 6B                       k
        eor     ($DA,x)                         ; A7EF 41 DA                    A.
        .byte   $44                             ; A7F1 44                       D
        .byte   $FF                             ; A7F2 FF                       .
        ora     $2F,x                           ; A7F3 15 2F                    ./
        .byte   $54                             ; A7F5 54                       T
        .byte   $F7                             ; A7F6 F7                       .
        ora     $EF                             ; A7F7 05 EF                    ..
        .byte   $4F                             ; A7F9 4F                       O
        .byte   $FF                             ; A7FA FF                       .
        eor     $FF,x                           ; A7FB 55 FF                    U.
        lda     $FF,x                           ; A7FD B5 FF                    ..
        sbc     L0000,x                         ; A7FF F5 00                    ..
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
        .byte   $02                             ; A816 02                       .
        .byte   $02                             ; A817 02                       .
        asl     $01                             ; A818 06 01                    ..
        ora     ($04,x)                         ; A81A 01 04                    ..
        ora     ($01,x)                         ; A81C 01 01                    ..
        brk                                     ; A81E 00                       .
        brk                                     ; A81F 00                       .
        .byte   $04                             ; A820 04                       .
        .byte   $02                             ; A821 02                       .
        brk                                     ; A822 00                       .
        brk                                     ; A823 00                       .
        brk                                     ; A824 00                       .
        ora     (L0000,x)                       ; A825 01 00                    ..
        brk                                     ; A827 00                       .
        .byte   $03                             ; A828 03                       .
        ora     (L0002,x)                       ; A829 01 02                    ..
        ora     (L0000,x)                       ; A82B 01 00                    ..
        brk                                     ; A82D 00                       .
        brk                                     ; A82E 00                       .
        brk                                     ; A82F 00                       .
        brk                                     ; A830 00                       .
        .byte   $03                             ; A831 03                       .
        ora     ($03,x)                         ; A832 01 03                    ..
        ora     ($01,x)                         ; A834 01 01                    ..
        .byte   $03                             ; A836 03                       .
        brk                                     ; A837 00                       .
        brk                                     ; A838 00                       .
        ora     ($03,x)                         ; A839 01 03                    ..
        .byte   $02                             ; A83B 02                       .
        brk                                     ; A83C 00                       .
        ora     (L0002,x)                       ; A83D 01 02                    ..
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
        brk                                     ; A85A 00                       .
        brk                                     ; A85B 00                       .
        .byte   $03                             ; A85C 03                       .
        .byte   $04                             ; A85D 04                       .
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
        .byte   $03                             ; A891 03                       .
        brk                                     ; A892 00                       .
        .byte   $03                             ; A893 03                       .
        brk                                     ; A894 00                       .
        brk                                     ; A895 00                       .
        .byte   $03                             ; A896 03                       .
        brk                                     ; A897 00                       .
        .byte   $03                             ; A898 03                       .
        brk                                     ; A899 00                       .
        brk                                     ; A89A 00                       .
        brk                                     ; A89B 00                       .
        .byte   $02                             ; A89C 02                       .
        brk                                     ; A89D 00                       .
        ora     (L0000,x)                       ; A89E 01 00                    ..
        ora     (L0000,x)                       ; A8A0 01 00                    ..
        brk                                     ; A8A2 00                       .
        brk                                     ; A8A3 00                       .
        brk                                     ; A8A4 00                       .
        brk                                     ; A8A5 00                       .
        brk                                     ; A8A6 00                       .
        brk                                     ; A8A7 00                       .
        brk                                     ; A8A8 00                       .
        brk                                     ; A8A9 00                       .
        .byte   $02                             ; A8AA 02                       .
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
        .byte   $04                             ; A8BD 04                       .
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
        ora     (L0002,x)                       ; A901 01 02                    ..
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
        ora     a:L0000,x                       ; A91D 1D 00 00                 ...
        .byte   $80                             ; A920 80                       .
        brk                                     ; A921 00                       .
        brk                                     ; A922 00                       .
LA923:  bpl     LA92D                           ; A923 10 08                    ..
        .byte   $04                             ; A925 04                       .
        brk                                     ; A926 00                       .
        brk                                     ; A927 00                       .
        jsr     L2028                           ; A928 20 28 20                  ( 
        .byte   $80                             ; A92B 80                       .
        brk                                     ; A92C 00                       .
LA92D:  brk                                     ; A92D 00                       .
        brk                                     ; A92E 00                       .
        brk                                     ; A92F 00                       .
        brk                                     ; A930 00                       .
        brk                                     ; A931 00                       .
        brk                                     ; A932 00                       .
        brk                                     ; A933 00                       .
LA934:  brk                                     ; A934 00                       .
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
        jsr     L0000                           ; A940 20 00 00                  ..
        brk                                     ; A943 00                       .
        .byte   $02                             ; A944 02                       .
        .byte   $02                             ; A945 02                       .
        .byte   $02                             ; A946 02                       .
        brk                                     ; A947 00                       .
        brk                                     ; A948 00                       .
        brk                                     ; A949 00                       .
        brk                                     ; A94A 00                       .
        brk                                     ; A94B 00                       .
        brk                                     ; A94C 00                       .
        brk                                     ; A94D 00                       .
        brk                                     ; A94E 00                       .
        brk                                     ; A94F 00                       .
        jsr     L4040                           ; A950 20 40 40                  @@
        rti                                     ; A953 40                       @

; ----------------------------------------------------------------------------
        rti                                     ; A954 40                       @

; ----------------------------------------------------------------------------
        .byte   $62                             ; A955 62                       b
        .byte   $80                             ; A956 80                       .
        ldx     #$80                            ; A957 A2 80                    ..
        .byte   $A3                             ; A959 A3                       .
        bit     $20                             ; A95A 24 20                    $ 
        .byte   $80                             ; A95C 80                       .
        lda     ($20,x)                         ; A95D A1 20                    . 
        jsr     L0900                           ; A95F 20 00 09                  ..
        brk                                     ; A962 00                       .
        brk                                     ; A963 00                       .
        .byte   $02                             ; A964 02                       .
        rti                                     ; A965 40                       @

; ----------------------------------------------------------------------------
        .byte   $02                             ; A966 02                       .
        brk                                     ; A967 00                       .
        brk                                     ; A968 00                       .
        brk                                     ; A969 00                       .
        brk                                     ; A96A 00                       .
        brk                                     ; A96B 00                       .
        brk                                     ; A96C 00                       .
        plp                                     ; A96D 28                       (
        .byte   $1C                             ; A96E 1C                       .
        plp                                     ; A96F 28                       (
        .byte   $1B                             ; A970 1B                       .
        asl     a                               ; A971 0A                       .
        .byte   $1C                             ; A972 1C                       .
        ora     $191C,y                         ; A973 19 1C 19                 ...
        .byte   $80                             ; A976 80                       .
        .byte   $80                             ; A977 80                       .
        brk                                     ; A978 00                       .
        brk                                     ; A979 00                       .
        brk                                     ; A97A 00                       .
        brk                                     ; A97B 00                       .
        brk                                     ; A97C 00                       .
        brk                                     ; A97D 00                       .
        brk                                     ; A97E 00                       .
        brk                                     ; A97F 00                       .
        bcs     LA934                           ; A980 B0 B2                    ..
        brk                                     ; A982 00                       .
        brk                                     ; A983 00                       .
        jsr     L2000                           ; A984 20 00 20                  . 
        brk                                     ; A987 00                       .
        .byte   $0F                             ; A988 0F                       .
        bmi     LA9AE                           ; A989 30 23                    0#
        .byte   $04                             ; A98B 04                       .
        .byte   $0F                             ; A98C 0F                       .
        bmi     LA9B5                           ; A98D 30 26                    0&
        asl     $0F                             ; A98F 06 0F                    ..
        bmi     LA9A3                           ; A991 30 10                    0.
        brk                                     ; A993 00                       .
        .byte   $0F                             ; A994 0F                       .
        bmi     LA9B3                           ; A995 30 1C                    0.
        .byte   $02                             ; A997 02                       .
        brk                                     ; A998 00                       .
        brk                                     ; A999 00                       .
        brk                                     ; A99A 00                       .
        brk                                     ; A99B 00                       .
        brk                                     ; A99C 00                       .
        brk                                     ; A99D 00                       .
        brk                                     ; A99E 00                       .
        brk                                     ; A99F 00                       .
        brk                                     ; A9A0 00                       .
        php                                     ; A9A1 08                       .
        .byte   $02                             ; A9A2 02                       .
LA9A3:  brk                                     ; A9A3 00                       .
        asl     a                               ; A9A4 0A                       .
        brk                                     ; A9A5 00                       .
        .byte   $80                             ; A9A6 80                       .
        jsr     L2000                           ; A9A7 20 00 20                  . 
        brk                                     ; A9AA 00                       .
        brk                                     ; A9AB 00                       .
        brk                                     ; A9AC 00                       .
        .byte   $24                             ; A9AD 24                       $
LA9AE:  brk                                     ; A9AE 00                       .
        brk                                     ; A9AF 00                       .
        txa                                     ; A9B0 8A                       .
        .byte   $04                             ; A9B1 04                       .
        brk                                     ; A9B2 00                       .
LA9B3:  brk                                     ; A9B3 00                       .
        brk                                     ; A9B4 00                       .
LA9B5:  brk                                     ; A9B5 00                       .
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
        ora     (L0000,x)                       ; A9C1 01 00                    ..
        brk                                     ; A9C3 00                       .
        brk                                     ; A9C4 00                       .
        brk                                     ; A9C5 00                       .
        brk                                     ; A9C6 00                       .
        plp                                     ; A9C7 28                       (
        brk                                     ; A9C8 00                       .
        brk                                     ; A9C9 00                       .
        brk                                     ; A9CA 00                       .
        .byte   $02                             ; A9CB 02                       .
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
        bpl     LAA03                           ; A9E1 10 20                    . 
        ldy     $2502                           ; A9E3 AC 02 25                 ..%
        brk                                     ; A9E6 00                       .
        brk                                     ; A9E7 00                       .
        php                                     ; A9E8 08                       .
        plp                                     ; A9E9 28                       (
        php                                     ; A9EA 08                       .
        php                                     ; A9EB 08                       .
        brk                                     ; A9EC 00                       .
        pha                                     ; A9ED 48                       H
        jsr     L0008                           ; A9EE 20 08 00                  ..
        brk                                     ; A9F1 00                       .
        ldx     #$06                            ; A9F2 A2 06                    ..
        brk                                     ; A9F4 00                       .
        ora     (L0002,x)                       ; A9F5 01 02                    ..
        rti                                     ; A9F7 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; A9F8 00                       .
        brk                                     ; A9F9 00                       .
        brk                                     ; A9FA 00                       .
        brk                                     ; A9FB 00                       .
        brk                                     ; A9FC 00                       .
        rti                                     ; A9FD 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; A9FE 00                       .
        brk                                     ; A9FF 00                       .
        brk                                     ; AA00 00                       .
        brk                                     ; AA01 00                       .
        .byte   $06                             ; AA02 06                       .
LAA03:  asl     $06                             ; AA03 06 06                    ..
        asl     $06                             ; AA05 06 06                    ..
        .byte   $07                             ; AA07 07                       .
        .byte   $07                             ; AA08 07                       .
        .byte   $07                             ; AA09 07                       .
        php                                     ; AA0A 08                       .
        php                                     ; AA0B 08                       .
        php                                     ; AA0C 08                       .
        php                                     ; AA0D 08                       .
        php                                     ; AA0E 08                       .
        php                                     ; AA0F 08                       .
        php                                     ; AA10 08                       .
        ora     #$0A                            ; AA11 09 0A                    ..
        asl     a                               ; AA13 0A                       .
        asl     a                               ; AA14 0A                       .
        .byte   $0B                             ; AA15 0B                       .
        .byte   $0C                             ; AA16 0C                       .
        .byte   $0C                             ; AA17 0C                       .
        .byte   $0C                             ; AA18 0C                       .
LAA19:  .byte   $0C                             ; AA19 0C                       .
        .byte   $0C                             ; AA1A 0C                       .
        ora     $0E0E                           ; AA1B 0D 0E 0E                 ...
        .byte   $0F                             ; AA1E 0F                       .
        .byte   $0F                             ; AA1F 0F                       .
        .byte   $0F                             ; AA20 0F                       .
        .byte   $0F                             ; AA21 0F                       .
        .byte   $0F                             ; AA22 0F                       .
        bpl     LAA36                           ; AA23 10 11                    ..
        ora     ($12),y                         ; AA25 11 12                    ..
        .byte   $14                             ; AA27 14                       .
        .byte   $14                             ; AA28 14                       .
        asl     $16,x                           ; AA29 16 16                    ..
        .byte   $17                             ; AA2B 17                       .
        .byte   $17                             ; AA2C 17                       .
        .byte   $17                             ; AA2D 17                       .
        .byte   $17                             ; AA2E 17                       .
        clc                                     ; AA2F 18                       .
        clc                                     ; AA30 18                       .
        clc                                     ; AA31 18                       .
        clc                                     ; AA32 18                       .
        ora     $1919,y                         ; AA33 19 19 19                 ...
LAA36:  .byte   $19                             ; AA36 19                       .
LAA37:  .byte   $1B                             ; AA37 1B                       .
        .byte   $1B                             ; AA38 1B                       .
        .byte   $1B                             ; AA39 1B                       .
        .byte   $1B                             ; AA3A 1B                       .
        .byte   $FF                             ; AA3B FF                       .
        brk                                     ; AA3C 00                       .
        brk                                     ; AA3D 00                       .
        brk                                     ; AA3E 00                       .
        brk                                     ; AA3F 00                       .
        .byte   $82                             ; AA40 82                       .
        .byte   $22                             ; AA41 22                       "
        php                                     ; AA42 08                       .
        .byte   $04                             ; AA43 04                       .
        brk                                     ; AA44 00                       .
        brk                                     ; AA45 00                       .
        brk                                     ; AA46 00                       .
        brk                                     ; AA47 00                       .
        brk                                     ; AA48 00                       .
LAA49:  brk                                     ; AA49 00                       .
        brk                                     ; AA4A 00                       .
        brk                                     ; AA4B 00                       .
        brk                                     ; AA4C 00                       .
        brk                                     ; AA4D 00                       .
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
        .byte   $8C                             ; AA61 8C                       .
LAA62:  brk                                     ; AA62 00                       .
        .byte   $80                             ; AA63 80                       .
        brk                                     ; AA64 00                       .
        .byte   $42                             ; AA65 42                       B
        brk                                     ; AA66 00                       .
        .byte   $80                             ; AA67 80                       .
LAA68:  .byte   $80                             ; AA68 80                       .
        brk                                     ; AA69 00                       .
        brk                                     ; AA6A 00                       .
        brk                                     ; AA6B 00                       .
        brk                                     ; AA6C 00                       .
        .byte   $80                             ; AA6D 80                       .
        brk                                     ; AA6E 00                       .
        brk                                     ; AA6F 00                       .
        .byte   $02                             ; AA70 02                       .
        brk                                     ; AA71 00                       .
        .byte   $80                             ; AA72 80                       .
        bcc     LAA75                           ; AA73 90 00                    ..
LAA75:  brk                                     ; AA75 00                       .
        brk                                     ; AA76 00                       .
        brk                                     ; AA77 00                       .
        brk                                     ; AA78 00                       .
        brk                                     ; AA79 00                       .
        brk                                     ; AA7A 00                       .
LAA7B:  brk                                     ; AA7B 00                       .
        brk                                     ; AA7C 00                       .
        brk                                     ; AA7D 00                       .
        brk                                     ; AA7E 00                       .
LAA7F:  brk                                     ; AA7F 00                       .
        rti                                     ; AA80 40                       @

; ----------------------------------------------------------------------------
        bcs     LAAB3                           ; AA81 B0 30                    .0
        bvc     LAAF5                           ; AA83 50 70                    Pp
        bcc     LAA37                           ; AA85 90 B0                    ..
        bmi     LAA49                           ; AA87 30 C0                    0.
        .byte   $D0                             ; AA89 D0                       .
LAA8A:  pha                                     ; AA8A 48                       H
        jmp     L8C6C                           ; AA8B 4C 6C 8C                 Ll.

; ----------------------------------------------------------------------------
        ldy     $E0D0                           ; AA8E AC D0 E0                 ...
        brk                                     ; AA91 00                       .
        brk                                     ; AA92 00                       .
        bvc     LAA75                           ; AA93 50 E0                    P.
        bvc     LAAF7                           ; AA95 50 60                    P`
        bvs     LAA19                           ; AA97 70 80                    p.
        bcs     LAA7B                           ; AA99 B0 E0                    ..
        iny                                     ; AA9B C8                       .
        plp                                     ; AA9C 28                       (
        cli                                     ; AA9D 58                       X
        clc                                     ; AA9E 18                       .
        pha                                     ; AA9F 48                       H
        bcc     LAA8A                           ; AAA0 90 E8                    ..
        .byte   $FF                             ; AAA2 FF                       .
        .byte   $FF                             ; AAA3 FF                       .
LAAA4:  brk                                     ; AAA4 00                       .
        cpy     #$F0                            ; AAA5 C0 F0                    ..
        bpl     LAB19                           ; AAA7 10 70                    .p
        brk                                     ; AAA9 00                       .
        bcs     LAAFC                           ; AAAA B0 50                    .P
        cli                                     ; AAAC 58                       X
        bcc     LAA7F                           ; AAAD 90 D0                    ..
        bcs     LAA62                           ; AAAF B0 B1                    ..
        beq     LAAA4                           ; AAB1 F0 F1                    ..
LAAB3:  dey                                     ; AAB3 88                       .
        .byte   $89                             ; AAB4 89                       .
        bcs     LAA68                           ; AAB5 B0 B1                    ..
        .byte   $D4                             ; AAB7 D4                       .
        cld                                     ; AAB8 D8                       .
        cld                                     ; AAB9 D8                       .
LAABA:  cld                                     ; AABA D8                       .
        .byte   $FF                             ; AABB FF                       .
        brk                                     ; AABC 00                       .
        brk                                     ; AABD 00                       .
        brk                                     ; AABE 00                       .
        brk                                     ; AABF 00                       .
        brk                                     ; AAC0 00                       .
        brk                                     ; AAC1 00                       .
        brk                                     ; AAC2 00                       .
        brk                                     ; AAC3 00                       .
        php                                     ; AAC4 08                       .
        asl     L0000                           ; AAC5 06 00                    ..
        rti                                     ; AAC7 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; AAC8 00                       .
        brk                                     ; AAC9 00                       .
        brk                                     ; AACA 00                       .
        brk                                     ; AACB 00                       .
        brk                                     ; AACC 00                       .
        bpl     LAACF                           ; AACD 10 00                    ..
LAACF:  .byte   $02                             ; AACF 02                       .
        brk                                     ; AAD0 00                       .
        brk                                     ; AAD1 00                       .
        brk                                     ; AAD2 00                       .
LAAD3:  brk                                     ; AAD3 00                       .
        brk                                     ; AAD4 00                       .
        jsr     L0000                           ; AAD5 20 00 00                  ..
        brk                                     ; AAD8 00                       .
        brk                                     ; AAD9 00                       .
        brk                                     ; AADA 00                       .
        brk                                     ; AADB 00                       .
        brk                                     ; AADC 00                       .
        brk                                     ; AADD 00                       .
        brk                                     ; AADE 00                       .
        brk                                     ; AADF 00                       .
        .byte   $80                             ; AAE0 80                       .
        brk                                     ; AAE1 00                       .
        brk                                     ; AAE2 00                       .
        .byte   $04                             ; AAE3 04                       .
        brk                                     ; AAE4 00                       .
        rti                                     ; AAE5 40                       @

; ----------------------------------------------------------------------------
        .byte   $80                             ; AAE6 80                       .
        jsr     L0100                           ; AAE7 20 00 01                  ..
LAAEA:  .byte   $82                             ; AAEA 82                       .
        jsr     L6032                           ; AAEB 20 32 60                  2`
        brk                                     ; AAEE 00                       .
        ora     ($20),y                         ; AAEF 11 20                    . 
        brk                                     ; AAF1 00                       .
        .byte   $02                             ; AAF2 02                       .
        php                                     ; AAF3 08                       .
        brk                                     ; AAF4 00                       .
LAAF5:  .byte   $14                             ; AAF5 14                       .
        .byte   $80                             ; AAF6 80                       .
LAAF7:  brk                                     ; AAF7 00                       .
        .byte   $02                             ; AAF8 02                       .
        .byte   $80                             ; AAF9 80                       .
        brk                                     ; AAFA 00                       .
        brk                                     ; AAFB 00                       .
LAAFC:  jsr     L0200                           ; AAFC 20 00 02                  ..
        brk                                     ; AAFF 00                       .
        dey                                     ; AB00 88                       .
        sei                                     ; AB01 78                       x
        dec     $A6                             ; AB02 C6 A6                    ..
        tya                                     ; AB04 98                       .
        stx     $78                             ; AB05 86 78                    .x
        cli                                     ; AB07 58                       X
        dec     $B8                             ; AB08 C6 B8                    ..
        plp                                     ; AB0A 28                       (
        sta     LBDAD                           ; AB0B 8D AD BD                 ...
        cmp     $4888                           ; AB0E CD 88 48                 ..H
        brk                                     ; AB11 00                       .
        brk                                     ; AB12 00                       .
        clv                                     ; AB13 B8                       .
        clv                                     ; AB14 B8                       .
        clv                                     ; AB15 B8                       .
        bcc     LAB78                           ; AB16 90 60                    .`
        rti                                     ; AB18 40                       @

; ----------------------------------------------------------------------------
LAB19:  bmi     LAB4B                           ; AB19 30 30                    00
        stx     $C8                             ; AB1B 86 C8                    ..
        stx     $A6                             ; AB1D 86 A6                    ..
        stx     $C6                             ; AB1F 86 C6                    ..
        ldx     L0000                           ; AB21 A6 00                    ..
        brk                                     ; AB23 00                       .
        cld                                     ; AB24 D8                       .
        cpy     #$C0                            ; AB25 C0 C0                    ..
        cpy     #$C0                            ; AB27 C0 C0                    ..
        brk                                     ; AB29 00                       .
        rts                                     ; AB2A 60                       `

; ----------------------------------------------------------------------------
        eor     $9D18,x                         ; AB2B 5D 18 9D                 ]..
        clc                                     ; AB2E 18                       .
        dey                                     ; AB2F 88                       .
        bcs     LAABA                           ; AB30 B0 88                    ..
        bcs     LAB9C                           ; AB32 B0 68                    .h
        bcc     LAB9E                           ; AB34 90 68                    .h
        bcc     LAB8A                           ; AB36 90 52                    .R
        bcc     LAAEA                           ; AB38 90 B0                    ..
        .byte   $70                             ; AB3A 70                       p
LAB3B:  .byte   $FF                             ; AB3B FF                       .
        brk                                     ; AB3C 00                       .
        brk                                     ; AB3D 00                       .
        brk                                     ; AB3E 00                       .
        brk                                     ; AB3F 00                       .
        brk                                     ; AB40 00                       .
        php                                     ; AB41 08                       .
        brk                                     ; AB42 00                       .
        brk                                     ; AB43 00                       .
        brk                                     ; AB44 00                       .
        brk                                     ; AB45 00                       .
        brk                                     ; AB46 00                       .
        rts                                     ; AB47 60                       `

; ----------------------------------------------------------------------------
        brk                                     ; AB48 00                       .
        brk                                     ; AB49 00                       .
        brk                                     ; AB4A 00                       .
LAB4B:  brk                                     ; AB4B 00                       .
        brk                                     ; AB4C 00                       .
        ora     (L0000,x)                       ; AB4D 01 00                    ..
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
        .byte   $02                             ; AB61 02                       .
        ldy     #$08                            ; AB62 A0 08                    ..
        brk                                     ; AB64 00                       .
        .byte   $80                             ; AB65 80                       .
        plp                                     ; AB66 28                       (
        cpy     #$00                            ; AB67 C0 00                    ..
        brk                                     ; AB69 00                       .
        .byte   $22                             ; AB6A 22                       "
        .byte   $03                             ; AB6B 03                       .
        brk                                     ; AB6C 00                       .
        .byte   $02                             ; AB6D 02                       .
        jsr     L000A                           ; AB6E 20 0A 00                  ..
        .byte   $02                             ; AB71 02                       .
        asl     a                               ; AB72 0A                       .
        brk                                     ; AB73 00                       .
        brk                                     ; AB74 00                       .
        jsr     L0008                           ; AB75 20 08 00                  ..
LAB78:  brk                                     ; AB78 00                       .
        brk                                     ; AB79 00                       .
        brk                                     ; AB7A 00                       .
        brk                                     ; AB7B 00                       .
        brk                                     ; AB7C 00                       .
        brk                                     ; AB7D 00                       .
        brk                                     ; AB7E 00                       .
        brk                                     ; AB7F 00                       .
        sta     ($82,x)                         ; AB80 81 82                    ..
        rol     $2C2E                           ; AB82 2E 2E 2C                 ..,
        rol     $2C2C                           ; AB85 2E 2C 2C                 .,,
        bmi     LABB6                           ; AB88 30 2C                    0,
LAB8A:  .byte   $34                             ; AB8A 34                       4
        .byte   $3B                             ; AB8B 3B                       ;
        .byte   $3B                             ; AB8C 3B                       ;
        .byte   $3B                             ; AB8D 3B                       ;
        .byte   $3B                             ; AB8E 3B                       ;
        .byte   $34                             ; AB8F 34                       4
        sty     $C3                             ; AB90 84 C3                    ..
        cpy     #$2C                            ; AB92 C0 2C                    .,
        bit     $3F2C                           ; AB94 2C 2C 3F                 ,,?
        .byte   $3F                             ; AB97 3F                       ?
        .byte   $3F                             ; AB98 3F                       ?
        .byte   $3F                             ; AB99 3F                       ?
        .byte   $3F                             ; AB9A 3F                       ?
        .byte   $3C                             ; AB9B 3C                       <
LAB9C:  ora     $3D,x                           ; AB9C 15 3D                    .=
LAB9E:  .byte   $3C                             ; AB9E 3C                       <
        and     $7F3E,x                         ; AB9F 3D 3E 7F                 =>.
        cpy     #$C1                            ; ABA2 C0 C1                    ..
        .byte   $4B                             ; ABA4 4B                       K
        php                                     ; ABA5 08                       .
        php                                     ; ABA6 08                       .
        php                                     ; ABA7 08                       .
        php                                     ; ABA8 08                       .
        .byte   $C3                             ; ABA9 C3                       .
        and     $363B,y                         ; ABAA 39 3B 36                 9;6
        .byte   $3B                             ; ABAD 3B                       ;
        rol     $61,x                           ; ABAE 36 61                    6a
        .byte   $14                             ; ABB0 14                       .
        adc     ($14,x)                         ; ABB1 61 14                    a.
        adc     ($14,x)                         ; ABB3 61 14                    a.
        .byte   $61                             ; ABB5 61                       a
LABB6:  .byte   $14                             ; ABB6 14                       .
        eor     $5B5B,y                         ; ABB7 59 5B 5B                 Y[[
        .byte   $5A                             ; ABBA 5A                       Z
        .byte   $FF                             ; ABBB FF                       .
        brk                                     ; ABBC 00                       .
        brk                                     ; ABBD 00                       .
        brk                                     ; ABBE 00                       .
        brk                                     ; ABBF 00                       .
        jsr     L0810                           ; ABC0 20 10 08                  ..
        brk                                     ; ABC3 00                       .
        brk                                     ; ABC4 00                       .
        brk                                     ; ABC5 00                       .
        .byte   $02                             ; ABC6 02                       .
        jsr     L0002                           ; ABC7 20 02 00                  ..
        brk                                     ; ABCA 00                       .
        .byte   $04                             ; ABCB 04                       .
        brk                                     ; ABCC 00                       .
        brk                                     ; ABCD 00                       .
        brk                                     ; ABCE 00                       .
        .byte   $80                             ; ABCF 80                       .
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
        .byte   $04                             ; ABE3 04                       .
        brk                                     ; ABE4 00                       .
        asl     L0000                           ; ABE5 06 00                    ..
        ora     ($80,x)                         ; ABE7 01 80                    ..
        sta     (L0000,x)                       ; ABE9 81 00                    ..
        cpy     L0000                           ; ABEB C4 00                    ..
        brk                                     ; ABED 00                       .
        dey                                     ; ABEE 88                       .
        brk                                     ; ABEF 00                       .
        brk                                     ; ABF0 00                       .
        bit     L0000                           ; ABF1 24 00                    $.
        brk                                     ; ABF3 00                       .
        .byte   $02                             ; ABF4 02                       .
        .byte   $04                             ; ABF5 04                       .
        brk                                     ; ABF6 00                       .
        .byte   $82                             ; ABF7 82                       .
        brk                                     ; ABF8 00                       .
        brk                                     ; ABF9 00                       .
        brk                                     ; ABFA 00                       .
        brk                                     ; ABFB 00                       .
        brk                                     ; ABFC 00                       .
        brk                                     ; ABFD 00                       .
        brk                                     ; ABFE 00                       .
        brk                                     ; ABFF 00                       .
        brk                                     ; AC00 00                       .
        .byte   $02                             ; AC01 02                       .
        .byte   $02                             ; AC02 02                       .
        .byte   $02                             ; AC03 02                       .
        .byte   $02                             ; AC04 02                       .
        .byte   $02                             ; AC05 02                       .
        .byte   $02                             ; AC06 02                       .
        .byte   $07                             ; AC07 07                       .
        asl     a                               ; AC08 0A                       .
        ora     ($12),y                         ; AC09 11 12                    ..
        ora     $16,x                           ; AC0B 15 16                    ..
        .byte   $1B                             ; AC0D 1B                       .
        .byte   $1C                             ; AC0E 1C                       .
        asl     $2423,x                         ; AC0F 1E 23 24                 .#$
        rol     $27                             ; AC12 26 27                    &'
        .byte   $27                             ; AC14 27                       '
        and     #$29                            ; AC15 29 29                    ))
        .byte   $2B                             ; AC17 2B                       +
        .byte   $2F                             ; AC18 2F                       /
        .byte   $33                             ; AC19 33                       3
        .byte   $37                             ; AC1A 37                       7
        .byte   $37                             ; AC1B 37                       7
        brk                                     ; AC1C 00                       .
        brk                                     ; AC1D 00                       .
        brk                                     ; AC1E 00                       .
        brk                                     ; AC1F 00                       .
        rti                                     ; AC20 40                       @

; ----------------------------------------------------------------------------
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
        brk                                     ; AC60 00                       .
        brk                                     ; AC61 00                       .
        brk                                     ; AC62 00                       .
        brk                                     ; AC63 00                       .
        brk                                     ; AC64 00                       .
        brk                                     ; AC65 00                       .
        brk                                     ; AC66 00                       .
        brk                                     ; AC67 00                       .
        .byte   $04                             ; AC68 04                       .
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
        .byte   $80                             ; ACA2 80                       .
        brk                                     ; ACA3 00                       .
        brk                                     ; ACA4 00                       .
        brk                                     ; ACA5 00                       .
        ora     (L0000,x)                       ; ACA6 01 00                    ..
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
        rti                                     ; ACB3 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; ACB4 00                       .
        .byte   $04                             ; ACB5 04                       .
        ora     (L0000,x)                       ; ACB6 01 00                    ..
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
        .byte   $04                             ; ACE4 04                       .
        brk                                     ; ACE5 00                       .
        rti                                     ; ACE6 40                       @

; ----------------------------------------------------------------------------
        .byte   $04                             ; ACE7 04                       .
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
        brk                                     ; ACF4 00                       .
        brk                                     ; ACF5 00                       .
        brk                                     ; ACF6 00                       .
        ora     (L0000,x)                       ; ACF7 01 00                    ..
        brk                                     ; ACF9 00                       .
        brk                                     ; ACFA 00                       .
        brk                                     ; ACFB 00                       .
        brk                                     ; ACFC 00                       .
        brk                                     ; ACFD 00                       .
        brk                                     ; ACFE 00                       .
        brk                                     ; ACFF 00                       .
        brk                                     ; AD00 00                       .
        .byte   $9C                             ; AD01 9C                       .
        .byte   $9C                             ; AD02 9C                       .
        stx     $C4C2                           ; AD03 8E C2 C4                 ...
        rts                                     ; AD06 60                       `

; ----------------------------------------------------------------------------
        jsr     LE620                           ; AD07 20 20 E6                   .
        dec     $D8,x                           ; AD0A D6 D8                    ..
        .byte   $E2                             ; AD0C E2                       .
        cpx     $28                             ; AD0D E4 28                    .(
        lsr     $C4C2                           ; AD0F 4E C2 C4                 N..
        cpy     #$C4                            ; AD12 C0 C4                    ..
        cpy     #$C4                            ; AD14 C0 C4                    ..
        brk                                     ; AD16 00                       .
        ldy     #$E2                            ; AD17 A0 E2                    ..
        cpx     $E0                             ; AD19 E4 E0                    ..
        cpx     $E0                             ; AD1B E4 E0                    ..
        cpx     $2A                             ; AD1D E4 2A                    .*
        bcs     LAD62                           ; AD1F B0 41                    .A
        rti                                     ; AD21 40                       @

; ----------------------------------------------------------------------------
        .byte   $43                             ; AD22 43                       C
        .byte   $44                             ; AD23 44                       D
        ror     $6A,x                           ; AD24 76 6A                    vj
        .byte   $0C                             ; AD26 0C                       .
        asl     a:L0000                         ; AD27 0E 00 00                 ...
        brk                                     ; AD2A 00                       .
        .byte   $73                             ; AD2B 73                       s
        brk                                     ; AD2C 00                       .
        brk                                     ; AD2D 00                       .
        bit     $0A2E                           ; AD2E 2C 2E 0A                 ,..
        php                                     ; AD31 08                       .
        cld                                     ; AD32 D8                       .
        ror     a                               ; AD33 6A                       j
        ror     $62,x                           ; AD34 76 62                    vb
        rol     $06                             ; AD36 26 06                    &.
        dex                                     ; AD38 CA                       .
        .byte   $44                             ; AD39 44                       D
        brk                                     ; AD3A 00                       .
        .byte   $6B                             ; AD3B 6B                       k
        brk                                     ; AD3C 00                       .
        .byte   $63                             ; AD3D 63                       c
        brk                                     ; AD3E 00                       .
        rol     $80                             ; AD3F 26 80                    &.
        .byte   $82                             ; AD41 82                       .
        .byte   $82                             ; AD42 82                       .
        brk                                     ; AD43 00                       .
        iny                                     ; AD44 C8                       .
        brk                                     ; AD45 00                       .
        dec     $D8,x                           ; AD46 D6 D8                    ..
        ora     #$46                            ; AD48 09 46                    .F
        brk                                     ; AD4A 00                       .
        brk                                     ; AD4B 00                       .
        inx                                     ; AD4C E8                       .
        brk                                     ; AD4D 00                       .
        cpx     #$E4                            ; AD4E E0 E4                    ..
        .byte   $02                             ; AD50 02                       .
        .byte   $04                             ; AD51 04                       .
        bmi     LAD54                           ; AD52 30 00                    0.
LAD54:  brk                                     ; AD54 00                       .
        brk                                     ; AD55 00                       .
        lda     $22AB                           ; AD56 AD AB 22                 .."
        bit     $5A                             ; AD59 24 5A                    $Z
        dey                                     ; AD5B 88                       .
        txa                                     ; AD5C 8A                       .
        brk                                     ; AD5D 00                       .
        .byte   $B2                             ; AD5E B2                       .
        inx                                     ; AD5F E8                       .
        ldx     #$A4                            ; AD60 A2 A4                    ..
LAD62:  ldx     $A8                             ; AD62 A6 A8                    ..
        lda     #$64                            ; AD64 A9 64                    .d
        ror     $68                             ; AD66 66 68                    fh
        .byte   $BB                             ; AD68 BB                       .
        ora     ($B4),y                         ; AD69 11 B4                    ..
        .byte   $BB                             ; AD6B BB                       .
        .byte   $BB                             ; AD6C BB                       .
        .byte   $74                             ; AD6D 74                       t
        ora     ($78),y                         ; AD6E 11 78                    .x
        dey                                     ; AD70 88                       .
        txa                                     ; AD71 8A                       .
        .byte   $BB                             ; AD72 BB                       .
        .byte   $BB                             ; AD73 BB                       .
        .byte   $BB                             ; AD74 BB                       .
        lda     #$AB                            ; AD75 A9 AB                    ..
        .byte   $AB                             ; AD77 AB                       .
        .byte   $23                             ; AD78 23                       #
        and     $7A                             ; AD79 25 7A                    %z
        .byte   $7C                             ; AD7B 7C                       |
        dey                                     ; AD7C 88                       .
        txa                                     ; AD7D 8A                       .
        sty     $86                             ; AD7E 84 86                    ..
        jmp     L005C                           ; AD80 4C 5C 00                 L\.

; ----------------------------------------------------------------------------
        brk                                     ; AD83 00                       .
        ror     $66                             ; AD84 66 66                    ff
        sta     $86                             ; AD86 85 86                    ..
        jmp     (L0000)                         ; AD88 6C 00 00                 l..

; ----------------------------------------------------------------------------
        brk                                     ; AD8B 00                       .
        sec                                     ; AD8C 38                       8
        .byte   $3A                             ; AD8D 3A                       :
        brk                                     ; AD8E 00                       .
        brk                                     ; AD8F 00                       .
        dec     $DCCC                           ; AD90 CE CC DC                 ...
        dec     $EAAC,x                         ; AD93 DE AC EA                 ...
        brk                                     ; AD96 00                       .
        brk                                     ; AD97 00                       .
        ldy     $FCAC                           ; AD98 AC AC FC                 ...
        inc     a:$CE,x                         ; AD9B FE CE 00                 ...
        brk                                     ; AD9E 00                       .
        brk                                     ; AD9F 00                       .
        sty     L006E                           ; ADA0 84 6E                    .n
        .byte   $6F                             ; ADA2 6F                       o
        stx     $ED                             ; ADA3 86 ED                    ..
        .byte   $EF                             ; ADA5 EF                       .
        ror     a                               ; ADA6 6A                       j
        sty     $1148                           ; ADA7 8C 48 11                 .H.
        cli                                     ; ADAA 58                       X
        lsr     a                               ; ADAB 4A                       J
        brk                                     ; ADAC 00                       .
        inc     $EFED                           ; ADAD EE ED EF                 ...
        pha                                     ; ADB0 48                       H
        ora     ($58),y                         ; ADB1 11 58                    .X
        lsr     a                               ; ADB3 4A                       J
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
        .byte   $82                             ; ADD1 82                       .
        sty     $86                             ; ADD2 84 86                    ..
        brk                                     ; ADD4 00                       .
        brk                                     ; ADD5 00                       .
        brk                                     ; ADD6 00                       .
        brk                                     ; ADD7 00                       .
        brk                                     ; ADD8 00                       .
        ldx     #$A4                            ; ADD9 A2 A4                    ..
        ldx     L0000                           ; ADDB A6 00                    ..
        brk                                     ; ADDD 00                       .
        brk                                     ; ADDE 00                       .
        brk                                     ; ADDF 00                       .
        cpy     #$C2                            ; ADE0 C0 C2                    ..
        cpy     $C6                             ; ADE2 C4 C6                    ..
        .byte   $80                             ; ADE4 80                       .
        brk                                     ; ADE5 00                       .
        brk                                     ; ADE6 00                       .
        brk                                     ; ADE7 00                       .
        cpx     #$E2                            ; ADE8 E0 E2                    ..
        cpx     $E6                             ; ADEA E4 E6                    ..
        ldy     #$00                            ; ADEC A0 00                    ..
        brk                                     ; ADEE 00                       .
        brk                                     ; ADEF 00                       .
        brk                                     ; ADF0 00                       .
        .byte   $89                             ; ADF1 89                       .
        .byte   $8B                             ; ADF2 8B                       .
        sta     a:$8F                           ; ADF3 8D 8F 00                 ...
        brk                                     ; ADF6 00                       .
        brk                                     ; ADF7 00                       .
        brk                                     ; ADF8 00                       .
        lda     #$AB                            ; ADF9 A9 AB                    ..
        lda     a:$AF                           ; ADFB AD AF 00                 ...
        brk                                     ; ADFE 00                       .
        brk                                     ; ADFF 00                       .
        brk                                     ; AE00 00                       .
        sta     $8F9D,x                         ; AE01 9D 9D 8F                 ...
        .byte   $C3                             ; AE04 C3                       .
        cmp     $61                             ; AE05 C5 61                    .a
        and     ($21,x)                         ; AE07 21 21                    !!
        .byte   $E7                             ; AE09 E7                       .
        .byte   $D7                             ; AE0A D7                       .
        cmp     $E5E3,y                         ; AE0B D9 E3 E5                 ...
        and     #$4F                            ; AE0E 29 4F                    )O
        .byte   $C3                             ; AE10 C3                       .
        cmp     $C3                             ; AE11 C5 C3                    ..
        cmp     ($C3,x)                         ; AE13 C1 C3                    ..
        cmp     (L0000,x)                       ; AE15 C1 00                    ..
        lda     ($E3,x)                         ; AE17 A1 E3                    ..
        sbc     $E3                             ; AE19 E5 E3                    ..
        sbc     ($E3,x)                         ; AE1B E1 E3                    ..
        sbc     ($2B,x)                         ; AE1D E1 2B                    .+
        lda     ($42),y                         ; AE1F B1 42                    .B
        rti                                     ; AE21 40                       @

; ----------------------------------------------------------------------------
        rti                                     ; AE22 40                       @

; ----------------------------------------------------------------------------
        ror     $76,x                           ; AE23 76 76                    vv
        .byte   $6B                             ; AE25 6B                       k
        ora     a:$0F                           ; AE26 0D 0F 00                 ...
        brk                                     ; AE29 00                       .
        brk                                     ; AE2A 00                       .
        brk                                     ; AE2B 00                       .
        brk                                     ; AE2C 00                       .
        brk                                     ; AE2D 00                       .
        and     $0B2F                           ; AE2E 2D 2F 0B                 -/.
        cmp     $6AD9,y                         ; AE31 D9 D9 6A                 ..j
        ror     $62,x                           ; AE34 76 62                    vb
        .byte   $27                             ; AE36 27                       '
        .byte   $07                             ; AE37 07                       .
        cmp     a:$0B                           ; AE38 CD 0B 00                 ...
        .byte   $6B                             ; AE3B 6B                       k
        brk                                     ; AE3C 00                       .
        .byte   $63                             ; AE3D 63                       c
        brk                                     ; AE3E 00                       .
        .byte   $27                             ; AE3F 27                       '
        sta     ($81,x)                         ; AE40 81 81                    ..
        .byte   $83                             ; AE42 83                       .
        brk                                     ; AE43 00                       .
        cmp     #$00                            ; AE44 C9 00                    ..
        .byte   $D7                             ; AE46 D7                       .
        cmp     $4745,y                         ; AE47 D9 45 47                 .EG
        brk                                     ; AE4A 00                       .
        brk                                     ; AE4B 00                       .
        sbc     #$00                            ; AE4C E9 00                    ..
        .byte   $E3                             ; AE4E E3                       .
        sbc     ($03,x)                         ; AE4F E1 03                    ..
        ora     $31                             ; AE51 05 31                    .1
        brk                                     ; AE53 00                       .
        brk                                     ; AE54 00                       .
        brk                                     ; AE55 00                       .
        .byte   $AB                             ; AE56 AB                       .
        ldx     $2523                           ; AE57 AE 23 25                 .#%
        .byte   $5B                             ; AE5A 5B                       [
        .byte   $89                             ; AE5B 89                       .
        .byte   $8B                             ; AE5C 8B                       .
        brk                                     ; AE5D 00                       .
        .byte   $B3                             ; AE5E B3                       .
        sbc     #$A3                            ; AE5F E9 A3                    ..
        lda     $A7                             ; AE61 A5 A7                    ..
        ldx     $AA                             ; AE63 A6 AA                    ..
        adc     $67                             ; AE65 65 67                    eg
        adc     #$B3                            ; AE67 69 B3                    i.
        ora     ($BA),y                         ; AE69 11 BA                    ..
        ora     ($11),y                         ; AE6B 11 11                    ..
        adc     $BA,x                           ; AE6D 75 BA                    u.
        adc     $8B89,y                         ; AE6F 79 89 8B                 y..
        .byte   $BB                             ; AE72 BB                       .
        .byte   $BB                             ; AE73 BB                       .
        brk                                     ; AE74 00                       .
        .byte   $AB                             ; AE75 AB                       .
        lda     $AB                             ; AE76 A5 AB                    ..
        bit     $26                             ; AE78 24 26                    $&
        .byte   $7B                             ; AE7A 7B                       {
        adc     $8B89,x                         ; AE7B 7D 89 8B                 }..
        sta     $87                             ; AE7E 85 87                    ..
        eor     a:$5D                           ; AE80 4D 5D 00                 M].
        brk                                     ; AE83 00                       .
        ror     $66                             ; AE84 66 66                    ff
        stx     $85                             ; AE86 86 85                    ..
        adc     a:L0000                         ; AE88 6D 00 00                 m..
        brk                                     ; AE8B 00                       .
        and     $3B,y                           ; AE8C 39 3B 00                 9;.
        brk                                     ; AE8F 00                       .
        .byte   $CF                             ; AE90 CF                       .
        dec     $DFDE                           ; AE91 CE DE DF                 ...
        .byte   $CB                             ; AE94 CB                       .
        .byte   $EB                             ; AE95 EB                       .
        brk                                     ; AE96 00                       .
        brk                                     ; AE97 00                       .
        ldy     $FDAC                           ; AE98 AC AC FD                 ...
        .byte   $FF                             ; AE9B FF                       .
        .byte   $DB                             ; AE9C DB                       .
        brk                                     ; AE9D 00                       .
        brk                                     ; AE9E 00                       .
        brk                                     ; AE9F 00                       .
        sta     $6F                             ; AEA0 85 6F                    .o
        ror     $EE87                           ; AEA2 6E 87 EE                 n..
        ror     a                               ; AEA5 6A                       j
        .byte   $6B                             ; AEA6 6B                       k
        sta     $5849                           ; AEA7 8D 49 58                 .IX
        ora     ($4B),y                         ; AEAA 11 4B                    .K
        sbc     $EEEF                           ; AEAC ED EF EE                 ...
        brk                                     ; AEAF 00                       .
        eor     #$58                            ; AEB0 49 58                    IX
        eor     $4B,y                           ; AEB2 59 4B 00                 YK.
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
        .byte   $83                             ; AED1 83                       .
        sta     $87                             ; AED2 85 87                    ..
        brk                                     ; AED4 00                       .
        brk                                     ; AED5 00                       .
        brk                                     ; AED6 00                       .
        brk                                     ; AED7 00                       .
        brk                                     ; AED8 00                       .
        .byte   $A3                             ; AED9 A3                       .
        lda     $A7                             ; AEDA A5 A7                    ..
        brk                                     ; AEDC 00                       .
        brk                                     ; AEDD 00                       .
        brk                                     ; AEDE 00                       .
        brk                                     ; AEDF 00                       .
LAEE0:  cmp     ($C3,x)                         ; AEE0 C1 C3                    ..
        cmp     $C7                             ; AEE2 C5 C7                    ..
        sta     (L0000,x)                       ; AEE4 81 00                    ..
        brk                                     ; AEE6 00                       .
        brk                                     ; AEE7 00                       .
        sbc     ($E3,x)                         ; AEE8 E1 E3                    ..
LAEEA:  sbc     $E7                             ; AEEA E5 E7                    ..
        lda     (L0000,x)                       ; AEEC A1 00                    ..
        brk                                     ; AEEE 00                       .
        brk                                     ; AEEF 00                       .
        dey                                     ; AEF0 88                       .
        txa                                     ; AEF1 8A                       .
        sty     a:$8E                           ; AEF2 8C 8E 00                 ...
        brk                                     ; AEF5 00                       .
        brk                                     ; AEF6 00                       .
        brk                                     ; AEF7 00                       .
        tay                                     ; AEF8 A8                       .
        tax                                     ; AEF9 AA                       .
        ldy     a:$AE                           ; AEFA AC AE 00                 ...
        brk                                     ; AEFD 00                       .
        brk                                     ; AEFE 00                       .
        brk                                     ; AEFF 00                       .
LAF00:  brk                                     ; AF00 00                       .
        .byte   $9C                             ; AF01 9C                       .
        .byte   $9C                             ; AF02 9C                       .
        .byte   $9E                             ; AF03 9E                       .
        .byte   $D2                             ; AF04 D2                       .
        .byte   $D4                             ; AF05 D4                       .
        bvs     LAF28                           ; AF06 70 20                    p 
        bmi     LAF00                           ; AF08 30 F6                    0.
        bne     LAEE0                           ; AF0A D0 D4                    ..
        .byte   $F2                             ; AF0C F2                       .
        .byte   $F4                             ; AF0D F4                       .
        sec                                     ; AF0E 38                       8
        lsr     $F6F6,x                         ; AF0F 5E F6 F6                 ^..
        inc     $F6,x                           ; AF12 F6 F6                    ..
        bne     LAEEA                           ; AF14 D0 D4                    ..
        brk                                     ; AF16 00                       .
        ldy     #$F6                            ; AF17 A0 F6                    ..
        inc     $F6,x                           ; AF19 F6 F6                    ..
        .byte   $F6                             ; AF1B F6                       .
LAF1C:  .byte   $F0,$F4                    ; AF1C F0 F4   (branch out of range for ca65: target has no local label)
        .byte   $3A                             ; AF1E 3A                       :
        .byte   $D4                             ; AF1F D4                       .
        eor     ($50),y                         ; AF20 51 50                    QP
        .byte   $53                             ; AF22 53                       S
        .byte   $44                             ; AF23 44                       D
        ror     $7A,x                           ; AF24 76 7A                    vz
        .byte   $1C                             ; AF26 1C                       .
        .byte   $1E                             ; AF27 1E                       .
LAF28:  eor     ($50),y                         ; AF28 51 50                    QP
        .byte   $53                             ; AF2A 53                       S
        .byte   $44                             ; AF2B 44                       D
        lsr     $6A,x                           ; AF2C 56 6A                    Vj
        .byte   $3C                             ; AF2E 3C                       <
        rol     $181A,x                         ; AF2F 3E 1A 18                 >..
        iny                                     ; AF32 C8                       .
        .byte   $7A                             ; AF33 7A                       z
        cpx     $1672                           ; AF34 EC 72 16                 .r.
        asl     $DA,x                           ; AF37 16 DA                    ..
        .byte   $44                             ; AF39 44                       D
        brk                                     ; AF3A 00                       .
        .byte   $7B                             ; AF3B 7B                       {
        brk                                     ; AF3C 00                       .
        .byte   $63                             ; AF3D 63                       c
        brk                                     ; AF3E 00                       .
        rol     $90,x                           ; AF3F 36 90                    6.
        .byte   $92                             ; AF41 92                       .
        sta     (L0000),y                       ; AF42 91 00                    ..
LAF44:  cld                                     ; AF44 D8                       .
        brk                                     ; AF45 00                       .
        bne     LAF1C                           ; AF46 D0 D4                    ..
        .byte   $54                             ; AF48 54                       T
        ora     L0000,y                         ; AF49 19 00 00                 ...
        sed                                     ; AF4C F8                       .
        brk                                     ; AF4D 00                       .
        beq     LAF44                           ; AF4E F0 F4                    ..
        .byte   $12                             ; AF50 12                       .
        .byte   $14                             ; AF51 14                       .
        bmi     LAF54                           ; AF52 30 00                    0.
LAF54:  brk                                     ; AF54 00                       .
        brk                                     ; AF55 00                       .
        .byte   $B2                             ; AF56 B2                       .
        .byte   $B3                             ; AF57 B3                       .
        .byte   $32                             ; AF58 32                       2
        .byte   $34                             ; AF59 34                       4
        .byte   $5A                             ; AF5A 5A                       Z
        ora     #$46                            ; AF5B 09 46                    .F
        brk                                     ; AF5D 00                       .
        .byte   $AF                             ; AF5E AF                       .
        sed                                     ; AF5F F8                       .
        .byte   $B2                             ; AF60 B2                       .
        ora     ($B6),y                         ; AF61 11 B6                    ..
        clv                                     ; AF63 B8                       .
        lda     $1174,y                         ; AF64 B9 74 11                 .t.
        sei                                     ; AF67 78                       x
        .byte   $BB                             ; AF68 BB                       .
        ora     ($11),y                         ; AF69 11 11                    ..
        .byte   $BB                             ; AF6B BB                       .
        .byte   $BB                             ; AF6C BB                       .
        .byte   $74                             ; AF6D 74                       t
        ora     ($78),y                         ; AF6E 11 78                    .x
        dey                                     ; AF70 88                       .
        txa                                     ; AF71 8A                       .
        brk                                     ; AF72 00                       .
        brk                                     ; AF73 00                       .
        brk                                     ; AF74 00                       .
        lda     $1111,y                         ; AF75 B9 11 11                 ...
        .byte   $33                             ; AF78 33                       3
        and     $88,x                           ; AF79 35 88                    5.
        txa                                     ; AF7B 8A                       .
        tya                                     ; AF7C 98                       .
        txs                                     ; AF7D 9A                       .
        sty     $96,x                           ; AF7E 94 96                    ..
        .byte   $5C                             ; AF80 5C                       \
        jmp     L0000                           ; AF81 4C 00 00                 L..

; ----------------------------------------------------------------------------
        plp                                     ; AF84 28                       (
        rol     a                               ; AF85 2A                       *
        sta     $96,x                           ; AF86 95 96                    ..
        jmp     (L0000)                         ; AF88 6C 00 00                 l..

; ----------------------------------------------------------------------------
        brk                                     ; AF8B 00                       .
        sec                                     ; AF8C 38                       8
        .byte   $3A                             ; AF8D 3A                       :
        brk                                     ; AF8E 00                       .
        brk                                     ; AF8F 00                       .
        cpy     $ECCE                           ; AF90 CC CE EC                 ...
        cpx     $FABE                           ; AF93 EC BE FA                 ...
        brk                                     ; AF96 00                       .
        brk                                     ; AF97 00                       .
        .byte   $BF                             ; AF98 BF                       .
        ldx     $CCCE,y                         ; AF99 BE CE CC                 ...
        cpy     a:L0000                         ; AF9C CC 00 00                 ...
        brk                                     ; AF9F 00                       .
        pha                                     ; AFA0 48                       H
        ora     ($58),y                         ; AFA1 11 58                    .X
        lsr     a                               ; AFA3 4A                       J
        sbc     $6AEF                           ; AFA4 ED EF 6A                 ..j
        sty     $7E94                           ; AFA7 8C 94 7E                 ..~
        .byte   $7F                             ; AFAA 7F                       .
        stx     L0000,y                         ; AFAB 96 00                    ..
        .byte   $11                             ; AFAD 11                       .
LAFAE:  sty     $488D                           ; AFAE 8C 8D 48                 ..H
        ora     ($58),y                         ; AFB1 11 58                    .X
        lsr     a                               ; AFB3 4A                       J
LAFB4:  brk                                     ; AFB4 00                       .
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
        iny                                     ; AFCA C8                       .
        brk                                     ; AFCB 00                       .
        brk                                     ; AFCC 00                       .
        brk                                     ; AFCD 00                       .
        brk                                     ; AFCE 00                       .
        brk                                     ; AFCF 00                       .
        brk                                     ; AFD0 00                       .
        .byte   $92                             ; AFD1 92                       .
        sty     $96,x                           ; AFD2 94 96                    ..
        brk                                     ; AFD4 00                       .
        brk                                     ; AFD5 00                       .
        brk                                     ; AFD6 00                       .
        brk                                     ; AFD7 00                       .
        brk                                     ; AFD8 00                       .
        .byte   $B2                             ; AFD9 B2                       .
        ldy     $B6,x                           ; AFDA B4 B6                    ..
LAFDC:  brk                                     ; AFDC 00                       .
        brk                                     ; AFDD 00                       .
        brk                                     ; AFDE 00                       .
        brk                                     ; AFDF 00                       .
        bne     LAFB4                           ; AFE0 D0 D2                    ..
        .byte   $D4                             ; AFE2 D4                       .
        dec     $90,x                           ; AFE3 D6 90                    ..
        brk                                     ; AFE5 00                       .
        brk                                     ; AFE6 00                       .
        brk                                     ; AFE7 00                       .
        beq     LAFDC                           ; AFE8 F0 F2                    ..
        .byte   $F4                             ; AFEA F4                       .
        inc     $B0,x                           ; AFEB F6 B0                    ..
        brk                                     ; AFED 00                       .
        brk                                     ; AFEE 00                       .
        brk                                     ; AFEF 00                       .
        brk                                     ; AFF0 00                       .
        sta     $9D9B,y                         ; AFF1 99 9B 9D                 ...
        .byte   $9F                             ; AFF4 9F                       .
        brk                                     ; AFF5 00                       .
        brk                                     ; AFF6 00                       .
        brk                                     ; AFF7 00                       .
        clv                                     ; AFF8 B8                       .
        lda     LBDBB,y                         ; AFF9 B9 BB BD                 ...
        .byte   $BF                             ; AFFC BF                       .
        brk                                     ; AFFD 00                       .
        brk                                     ; AFFE 00                       .
        brk                                     ; AFFF 00                       .
        brk                                     ; B000 00                       .
        sta     $9F9D,x                         ; B001 9D 9D 9F                 ...
        .byte   $D3                             ; B004 D3                       .
        cmp     $71,x                           ; B005 D5 71                    .q
        and     ($31,x)                         ; B007 21 31                    !1
        .byte   $F7                             ; B009 F7                       .
        .byte   $D3                             ; B00A D3                       .
        cmp     ($F3),y                         ; B00B D1 F3                    ..
        sbc     $39,x                           ; B00D F5 39                    .9
        .byte   $5F                             ; B00F 5F                       _
        .byte   $F7                             ; B010 F7                       .
        .byte   $F7                             ; B011 F7                       .
        .byte   $F7                             ; B012 F7                       .
        .byte   $F7                             ; B013 F7                       .
        .byte   $D3                             ; B014 D3                       .
        cmp     (L0000),y                       ; B015 D1 00                    ..
        lda     ($F7,x)                         ; B017 A1 F7                    ..
        .byte   $F7                             ; B019 F7                       .
        .byte   $F7                             ; B01A F7                       .
        .byte   $F7                             ; B01B F7                       .
        .byte   $F3                             ; B01C F3                       .
        sbc     ($3B),y                         ; B01D F1 3B                    .;
        cmp     $52,x                           ; B01F D5 52                    .R
        bvc     LB073                           ; B021 50 50                    PP
        ror     $76,x                           ; B023 76 76                    vv
        .byte   $7B                             ; B025 7B                       {
        ora     $521F,x                         ; B026 1D 1F 52                 ..R
        bvc     LB07B                           ; B029 50 50                    PP
        lsr     $56,x                           ; B02B 56 56                    VV
        .byte   $6B                             ; B02D 6B                       k
        and     $1B3F,x                         ; B02E 3D 3F 1B                 =?.
        cmp     #$C9                            ; B031 C9 C9                    ..
        .byte   $7A                             ; B033 7A                       z
        cpx     $1772                           ; B034 EC 72 17                 .r.
        .byte   $17                             ; B037 17                       .
        cmp     a:$1B,x                         ; B038 DD 1B 00                 ...
        .byte   $7B                             ; B03B 7B                       {
        brk                                     ; B03C 00                       .
        .byte   $63                             ; B03D 63                       c
        brk                                     ; B03E 00                       .
        .byte   $37                             ; B03F 37                       7
        sta     ($91),y                         ; B040 91 91                    ..
        .byte   $93                             ; B042 93                       .
        brk                                     ; B043 00                       .
        cmp     $D300,y                         ; B044 D9 00 D3                 ...
        cmp     ($55),y                         ; B047 D1 55                    .U
        .byte   $57                             ; B049 57                       W
        brk                                     ; B04A 00                       .
        brk                                     ; B04B 00                       .
        sbc     $F300,y                         ; B04C F9 00 F3                 ...
        sbc     ($13),y                         ; B04F F1 13                    ..
        ora     $31,x                           ; B051 15 31                    .1
        tay                                     ; B053 A8                       .
        brk                                     ; B054 00                       .
        brk                                     ; B055 00                       .
        ldy     $BA,x                           ; B056 B4 BA                    ..
        .byte   $33                             ; B058 33                       3
        and     $5B,x                           ; B059 35 5B                    5[
        eor     $47                             ; B05B 45 47                    EG
        brk                                     ; B05D 00                       .
        ldy     LB3F9,x                         ; B05E BC F9 B3                 ...
        lda     $B7,x                           ; B061 B5 B7                    ..
        ldx     $BA,y                           ; B063 B6 BA                    ..
        adc     $11,x                           ; B065 75 11                    u.
        adc     $1111,y                         ; B067 79 11 11                 y..
        tsx                                     ; B06A BA                       .
        ldy     $11,x                           ; B06B B4 11                    ..
        adc     $BA,x                           ; B06D 75 BA                    u.
        adc     $8B89,y                         ; B06F 79 89 8B                 y..
        brk                                     ; B072 00                       .
LB073:  brk                                     ; B073 00                       .
        brk                                     ; B074 00                       .
        ora     ($B5),y                         ; B075 11 B5                    ..
        ora     ($34),y                         ; B077 11 34                    .4
        rol     $89,x                           ; B079 36 89                    6.
LB07B:  .byte   $8B                             ; B07B 8B                       .
        sta     $959B,y                         ; B07C 99 9B 95                 ...
        .byte   $97                             ; B07F 97                       .
        eor     a:$4D,x                         ; B080 5D 4D 00                 ]M.
        brk                                     ; B083 00                       .
        and     #$2B                            ; B084 29 2B                    )+
        stx     $95,y                           ; B086 96 95                    ..
        adc     a:L0000                         ; B088 6D 00 00                 m..
        brk                                     ; B08B 00                       .
        and     $3B,y                           ; B08C 39 3B 00                 9;.
        brk                                     ; B08F 00                       .
        dec     $ECCF                           ; B090 CE CF EC                 ...
        cpx     $FBDB                           ; B093 EC DB FB                 ...
        brk                                     ; B096 00                       .
        brk                                     ; B097 00                       .
        .byte   $BD                             ; B098 BD                       .
        .byte   $BF                             ; B099 BF                       .
LB09A:  .byte   $CF                             ; B09A CF                       .
        dec     a:$DB                           ; B09B CE DB 00                 ...
        brk                                     ; B09E 00                       .
        brk                                     ; B09F 00                       .
        eor     #$58                            ; B0A0 49 58                    IX
        eor     $EE4B,y                         ; B0A2 59 4B EE                 YK.
        ror     a                               ; B0A5 6A                       j
        .byte   $6B                             ; B0A6 6B                       k
        sta     $7F95                           ; B0A7 8D 95 7F                 ...
        ror     $8C97,x                         ; B0AA 7E 97 8C                 ~..
        sta     a:$11                           ; B0AD 8D 11 00                 ...
        eor     #$58                            ; B0B0 49 58                    IX
        ora     ($4B),y                         ; B0B2 11 4B                    .K
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
        cmp     #$00                            ; B0CA C9 00                    ..
        brk                                     ; B0CC 00                       .
        brk                                     ; B0CD 00                       .
        brk                                     ; B0CE 00                       .
        brk                                     ; B0CF 00                       .
        brk                                     ; B0D0 00                       .
        .byte   $93                             ; B0D1 93                       .
        sta     $97,x                           ; B0D2 95 97                    ..
        brk                                     ; B0D4 00                       .
        brk                                     ; B0D5 00                       .
        brk                                     ; B0D6 00                       .
        brk                                     ; B0D7 00                       .
        brk                                     ; B0D8 00                       .
        .byte   $B3                             ; B0D9 B3                       .
        lda     $B7,x                           ; B0DA B5 B7                    ..
        brk                                     ; B0DC 00                       .
        brk                                     ; B0DD 00                       .
        brk                                     ; B0DE 00                       .
        brk                                     ; B0DF 00                       .
        cmp     ($D3),y                         ; B0E0 D1 D3                    ..
        cmp     $D7,x                           ; B0E2 D5 D7                    ..
        sta     (L0000),y                       ; B0E4 91 00                    ..
        brk                                     ; B0E6 00                       .
        brk                                     ; B0E7 00                       .
        sbc     ($F3),y                         ; B0E8 F1 F3                    ..
        sbc     $F7,x                           ; B0EA F5 F7                    ..
        lda     (L0000),y                       ; B0EC B1 00                    ..
        brk                                     ; B0EE 00                       .
        brk                                     ; B0EF 00                       .
        tya                                     ; B0F0 98                       .
        txs                                     ; B0F1 9A                       .
        .byte   $9C                             ; B0F2 9C                       .
        .byte   $9E                             ; B0F3 9E                       .
        brk                                     ; B0F4 00                       .
        brk                                     ; B0F5 00                       .
        brk                                     ; B0F6 00                       .
        brk                                     ; B0F7 00                       .
LB0F8:  clv                                     ; B0F8 B8                       .
        tsx                                     ; B0F9 BA                       .
        ldy     a:$BE,x                         ; B0FA BC BE 00                 ...
        brk                                     ; B0FD 00                       .
        brk                                     ; B0FE 00                       .
        brk                                     ; B0FF 00                       .
        brk                                     ; B100 00                       .
        rti                                     ; B101 40                       @

; ----------------------------------------------------------------------------
        jsr     L10F3                           ; B102 20 F3 10                  ..
        bpl     LB0F8                           ; B105 10 F1                    ..
        ora     ($10,x)                         ; B107 01 10                    ..
        bpl     LB11B                           ; B109 10 10                    ..
        bpl     LB11D                           ; B10B 10 10                    ..
        bpl     LB181                           ; B10D 10 72                    .r
        bmi     LB121                           ; B10F 30 10                    0.
        bpl     LB123                           ; B111 10 10                    ..
        bpl     LB125                           ; B113 10 10                    ..
        bpl     LB117                           ; B115 10 00                    ..
LB117:  bpl     LB129                           ; B117 10 10                    ..
        bpl     LB12B                           ; B119 10 10                    ..
LB11B:  bpl     LB12D                           ; B11B 10 10                    ..
LB11D:  bpl     LB171                           ; B11D 10 52                    .R
        bpl     LB124                           ; B11F 10 03                    ..
LB121:  .byte   $03                             ; B121 03                       .
        .byte   $03                             ; B122 03                       .
LB123:  .byte   $03                             ; B123 03                       .
LB124:  .byte   $03                             ; B124 03                       .
LB125:  brk                                     ; B125 00                       .
        .byte   $12                             ; B126 12                       .
        .byte   $12                             ; B127 12                       .
        .byte   $03                             ; B128 03                       .
LB129:  .byte   $03                             ; B129 03                       .
        .byte   $03                             ; B12A 03                       .
LB12B:  .byte   $03                             ; B12B 03                       .
        .byte   $03                             ; B12C 03                       .
LB12D:  brk                                     ; B12D 00                       .
        .byte   $12                             ; B12E 12                       .
        .byte   $12                             ; B12F 12                       .
        .byte   $03                             ; B130 03                       .
        bpl     LB143                           ; B131 10 10                    ..
        bpl     LB138                           ; B133 10 03                    ..
        bpl     LB149                           ; B135 10 12                    ..
        .byte   $12                             ; B137 12                       .
LB138:  sbc     ($03),y                         ; B138 F1 03                    ..
        brk                                     ; B13A 00                       .
        bpl     LB13D                           ; B13B 10 00                    ..
LB13D:  bpl     LB13F                           ; B13D 10 00                    ..
LB13F:  .byte   $12                             ; B13F 12                       .
        .byte   $12                             ; B140 12                       .
        .byte   $12                             ; B141 12                       .
        .byte   $12                             ; B142 12                       .
LB143:  bpl     LB146                           ; B143 10 01                    ..
        brk                                     ; B145 00                       .
LB146:  ora     ($11),y                         ; B146 11 11                    ..
        .byte   $12                             ; B148 12                       .
LB149:  .byte   $12                             ; B149 12                       .
        brk                                     ; B14A 00                       .
        brk                                     ; B14B 00                       .
        ora     (L0000,x)                       ; B14C 01 00                    ..
        ora     ($11),y                         ; B14E 11 11                    ..
        ora     ($11),y                         ; B150 11 11                    ..
        bpl     LB165                           ; B152 10 11                    ..
        brk                                     ; B154 00                       .
        brk                                     ; B155 00                       .
        ora     ($11),y                         ; B156 11 11                    ..
        ora     ($11),y                         ; B158 11 11                    ..
        bpl     LB16C                           ; B15A 10 10                    ..
        bpl     LB15E                           ; B15C 10 00                    ..
LB15E:  ora     ($01),y                         ; B15E 11 01                    ..
        ora     ($11),y                         ; B160 11 11                    ..
        ora     ($11),y                         ; B162 11 11                    ..
        .byte   $11                             ; B164 11                       .
LB165:  ora     ($11),y                         ; B165 11 11                    ..
        ora     ($11),y                         ; B167 11 11                    ..
        ora     ($11),y                         ; B169 11 11                    ..
        .byte   $11                             ; B16B 11                       .
LB16C:  ora     ($11),y                         ; B16C 11 11                    ..
        ora     ($11),y                         ; B16E 11 11                    ..
        .byte   $12                             ; B170 12                       .
LB171:  .byte   $12                             ; B171 12                       .
        ora     ($11),y                         ; B172 11 11                    ..
        ora     ($11),y                         ; B174 11 11                    ..
        ora     ($11),y                         ; B176 11 11                    ..
        bpl     LB18A                           ; B178 10 10                    ..
        .byte   $12                             ; B17A 12                       .
        .byte   $12                             ; B17B 12                       .
        .byte   $12                             ; B17C 12                       .
        .byte   $12                             ; B17D 12                       .
        bpl     LB190                           ; B17E 10 10                    ..
        .byte   $11                             ; B180 11                       .
LB181:  ora     (L0000),y                       ; B181 11 00                    ..
        brk                                     ; B183 00                       .
        ora     ($11),y                         ; B184 11 11                    ..
        bpl     LB198                           ; B186 10 10                    ..
        ora     (L0000),y                       ; B188 11 00                    ..
LB18A:  brk                                     ; B18A 00                       .
        brk                                     ; B18B 00                       .
        ora     ($11),y                         ; B18C 11 11                    ..
        brk                                     ; B18E 00                       .
        brk                                     ; B18F 00                       .
LB190:  .byte   $03                             ; B190 03                       .
        .byte   $03                             ; B191 03                       .
        .byte   $03                             ; B192 03                       .
        .byte   $03                             ; B193 03                       .
        .byte   $03                             ; B194 03                       .
        .byte   $03                             ; B195 03                       .
        brk                                     ; B196 00                       .
        brk                                     ; B197 00                       .
LB198:  .byte   $03                             ; B198 03                       .
        .byte   $03                             ; B199 03                       .
        .byte   $03                             ; B19A 03                       .
        .byte   $03                             ; B19B 03                       .
        .byte   $03                             ; B19C 03                       .
        brk                                     ; B19D 00                       .
        brk                                     ; B19E 00                       .
        brk                                     ; B19F 00                       .
        bpl     LB1B2                           ; B1A0 10 10                    ..
        bpl     LB1B4                           ; B1A2 10 10                    ..
        .byte   $12                             ; B1A4 12                       .
        .byte   $12                             ; B1A5 12                       .
        .byte   $12                             ; B1A6 12                       .
        .byte   $12                             ; B1A7 12                       .
        bpl     LB1BA                           ; B1A8 10 10                    ..
        bpl     LB1BC                           ; B1AA 10 10                    ..
        .byte   $03                             ; B1AC 03                       .
        .byte   $03                             ; B1AD 03                       .
        .byte   $03                             ; B1AE 03                       .
        .byte   $03                             ; B1AF 03                       .
        bpl     LB1C2                           ; B1B0 10 10                    ..
LB1B2:  bpl     LB1C4                           ; B1B2 10 10                    ..
LB1B4:  brk                                     ; B1B4 00                       .
        brk                                     ; B1B5 00                       .
        brk                                     ; B1B6 00                       .
        brk                                     ; B1B7 00                       .
        brk                                     ; B1B8 00                       .
        brk                                     ; B1B9 00                       .
LB1BA:  brk                                     ; B1BA 00                       .
        brk                                     ; B1BB 00                       .
LB1BC:  brk                                     ; B1BC 00                       .
        brk                                     ; B1BD 00                       .
        brk                                     ; B1BE 00                       .
        brk                                     ; B1BF 00                       .
        brk                                     ; B1C0 00                       .
        brk                                     ; B1C1 00                       .
LB1C2:  brk                                     ; B1C2 00                       .
        brk                                     ; B1C3 00                       .
LB1C4:  brk                                     ; B1C4 00                       .
        brk                                     ; B1C5 00                       .
        brk                                     ; B1C6 00                       .
        brk                                     ; B1C7 00                       .
        brk                                     ; B1C8 00                       .
        .byte   $03                             ; B1C9 03                       .
        .byte   $03                             ; B1CA 03                       .
        .byte   $03                             ; B1CB 03                       .
        brk                                     ; B1CC 00                       .
        brk                                     ; B1CD 00                       .
        brk                                     ; B1CE 00                       .
        brk                                     ; B1CF 00                       .
        brk                                     ; B1D0 00                       .
        .byte   $03                             ; B1D1 03                       .
        .byte   $03                             ; B1D2 03                       .
        .byte   $03                             ; B1D3 03                       .
        brk                                     ; B1D4 00                       .
        brk                                     ; B1D5 00                       .
        brk                                     ; B1D6 00                       .
        brk                                     ; B1D7 00                       .
        brk                                     ; B1D8 00                       .
        .byte   $03                             ; B1D9 03                       .
        .byte   $03                             ; B1DA 03                       .
        .byte   $03                             ; B1DB 03                       .
        brk                                     ; B1DC 00                       .
        brk                                     ; B1DD 00                       .
        brk                                     ; B1DE 00                       .
        brk                                     ; B1DF 00                       .
        ora     ($01,x)                         ; B1E0 01 01                    ..
        ora     ($01,x)                         ; B1E2 01 01                    ..
        ora     (L0000,x)                       ; B1E4 01 00                    ..
        brk                                     ; B1E6 00                       .
        brk                                     ; B1E7 00                       .
        .byte   $02                             ; B1E8 02                       .
        .byte   $02                             ; B1E9 02                       .
        .byte   $02                             ; B1EA 02                       .
        .byte   $02                             ; B1EB 02                       .
        .byte   $02                             ; B1EC 02                       .
        brk                                     ; B1ED 00                       .
        brk                                     ; B1EE 00                       .
        brk                                     ; B1EF 00                       .
        .byte   $03                             ; B1F0 03                       .
        .byte   $03                             ; B1F1 03                       .
        .byte   $03                             ; B1F2 03                       .
        .byte   $03                             ; B1F3 03                       .
        .byte   $03                             ; B1F4 03                       .
        brk                                     ; B1F5 00                       .
        brk                                     ; B1F6 00                       .
        brk                                     ; B1F7 00                       .
        .byte   $02                             ; B1F8 02                       .
        .byte   $02                             ; B1F9 02                       .
        .byte   $02                             ; B1FA 02                       .
        .byte   $02                             ; B1FB 02                       .
        .byte   $02                             ; B1FC 02                       .
        brk                                     ; B1FD 00                       .
        brk                                     ; B1FE 00                       .
        brk                                     ; B1FF 00                       .
        .byte   $04                             ; B200 04                       .
        ora     $18                             ; B201 05 18                    ..
        ora     $0B0A,y                         ; B203 19 0A 0B                 ...
        .byte   $1C                             ; B206 1C                       .
        ora     $2C2B,x                         ; B207 1D 2B 2C                 .+,
        .byte   $23                             ; B20A 23                       #
        bit     $2B                             ; B20B 24 2B                    $+
        .byte   $2B                             ; B20D 2B                       +
        .byte   $23                             ; B20E 23                       #
        .byte   $23                             ; B20F 23                       #
        bit     $242C                           ; B210 2C 2C 24                 ,,$
        bit     $14                             ; B213 24 14                    $.
        ora     $1C                             ; B215 05 1C                    ..
        ora     $1504                           ; B217 0D 04 15                 ...
        .byte   $0C                             ; B21A 0C                       .
        ora     $3039,x                         ; B21B 1D 39 30                 .90
        jsr     L3921                           ; B21E 20 21 39                  !9
        and     $2220,y                         ; B221 39 20 22                 9 "
        bmi     LB256                           ; B224 30 30                    00
        and     ($21,x)                         ; B226 21 21                    !!
        and     $2330,y                         ; B228 39 30 23                 90#
        bit     $10                             ; B22B 24 10                    $.
        .byte   $13                             ; B22D 13                       .
        .byte   $0B                             ; B22E 0B                       .
        .byte   $0B                             ; B22F 0B                       .
        .byte   $23                             ; B230 23                       #
        bit     $32                             ; B231 24 32                    $2
        .byte   $32                             ; B233 32                       2
        .byte   $23                             ; B234 23                       #
        .byte   $23                             ; B235 23                       #
        .byte   $32                             ; B236 32                       2
        .byte   $23                             ; B237 23                       #
        bit     $31                             ; B238 24 31                    $1
        bit     $2C                             ; B23A 24 2C                    $,
        .byte   $32                             ; B23C 32                       2
        .byte   $32                             ; B23D 32                       2
        .byte   $2B                             ; B23E 2B                       +
        bit     $232B                           ; B23F 2C 2B 23                 ,+#
        .byte   $23                             ; B242 23                       #
        .byte   $23                             ; B243 23                       #
        bit     $24                             ; B244 24 24                    $$
        bit     $24                             ; B246 24 24                    $$
        .byte   $23                             ; B248 23                       #
        bit     $23                             ; B249 24 23                    $#
        bit     $0B                             ; B24B 24 0B                    $.
        ora     ($1D,x)                         ; B24D 01 1D                    ..
        .byte   $02                             ; B24F 02                       .
        .byte   $04                             ; B250 04                       .
        ora     $0C                             ; B251 05 0C                    ..
        ora     $0215                           ; B253 0D 15 02                 ...
LB256:  ora     $1402,x                         ; B256 1D 02 14                 ...
        ora     $1C,x                           ; B259 15 1C                    ..
        ora     $1918,x                         ; B25B 1D 18 19                 ...
        .byte   $03                             ; B25E 03                       .
        bit     $1918                           ; B25F 2C 18 19                 ,..
        .byte   $2B                             ; B262 2B                       +
        bit     $1918                           ; B263 2C 18 19                 ,..
        .byte   $2B                             ; B266 2B                       +
        .byte   $2B                             ; B267 2B                       +
        clc                                     ; B268 18                       .
        ora     $2C2C,y                         ; B269 19 2C 2C                 .,,
        .byte   $1B                             ; B26C 1B                       .
        .byte   $02                             ; B26D 02                       .
        bit     $0302                           ; B26E 2C 02 03                 ,..
        bit     $03                             ; B271 24 03                    $.
        and     ($23,x)                         ; B273 21 23                    !#
        bit     $22                             ; B275 24 22                    $"
        and     ($23,x)                         ; B277 21 23                    !#
        .byte   $23                             ; B279 23                       #
        jsr     L2422                           ; B27A 20 22 24                  "$
        bit     $21                             ; B27D 24 21                    $!
        and     ($23),y                         ; B27F 31 23                    1#
        bit     L000A                           ; B281 24 0A                    $.
        .byte   $0B                             ; B283 0B                       .
        bit     L0002                           ; B284 24 02                    $.
        asl     a                               ; B286 0A                       .
        .byte   $0B                             ; B287 0B                       .
        bit     $12                             ; B288 24 12                    $.
        and     ($03,x)                         ; B28A 21 03                    !.
        .byte   $03                             ; B28C 03                       .
        bit     $03                             ; B28D 24 03                    $.
        bit     $23                             ; B28F 24 23                    $#
        .byte   $23                             ; B291 23                       #
        .byte   $23                             ; B292 23                       #
        .byte   $23                             ; B293 23                       #
        bit     $03                             ; B294 24 03                    $.
        bit     $2C                             ; B296 24 2C                    $,
        .byte   $12                             ; B298 12                       .
        .byte   $13                             ; B299 13                       .
        .byte   $2B                             ; B29A 2B                       +
        .byte   $03                             ; B29B 03                       .
        .byte   $23                             ; B29C 23                       #
        .byte   $03                             ; B29D 03                       .
        .byte   $23                             ; B29E 23                       #
        .byte   $03                             ; B29F 03                       .
        .byte   $03                             ; B2A0 03                       .
        bmi     LB2A6                           ; B2A1 30 03                    0.
        and     ($39,x)                         ; B2A3 21 39                    !9
        .byte   $30                             ; B2A5 30                       0
LB2A6:  .byte   $22                             ; B2A6 22                       "
        and     ($39,x)                         ; B2A7 21 39                    !9
        .byte   $03                             ; B2A9 03                       .
        .byte   $22                             ; B2AA 22                       "
        .byte   $03                             ; B2AB 03                       .
        .byte   $03                             ; B2AC 03                       .
        bit     $0B                             ; B2AD 24 0B                    $.
        .byte   $03                             ; B2AF 03                       .
        .byte   $23                             ; B2B0 23                       #
        .byte   $03                             ; B2B1 03                       .
        .byte   $23                             ; B2B2 23                       #
        bit     $1414                           ; B2B3 2C 14 14                 ,..
        .byte   $03                             ; B2B6 03                       .
        .byte   $1C                             ; B2B7 1C                       .
        ora     $03,x                           ; B2B8 15 03                    ..
        ora     $0303,x                         ; B2BA 1D 03 03                 ...
        .byte   $14                             ; B2BD 14                       .
        .byte   $03                             ; B2BE 03                       .
        .byte   $1C                             ; B2BF 1C                       .
        .byte   $04                             ; B2C0 04                       .
        ora     L000A                           ; B2C1 05 0A                    ..
        .byte   $0B                             ; B2C3 0B                       .
        ora     $03,x                           ; B2C4 15 03                    ..
        asl     a                               ; B2C6 0A                       .
        .byte   $0B                             ; B2C7 0B                       .
        .byte   $23                             ; B2C8 23                       #
        bit     $03                             ; B2C9 24 03                    $.
        bit     $23                             ; B2CB 24 23                    $#
        and     ($23),y                         ; B2CD 31 23                    1#
        .byte   $2B                             ; B2CF 2B                       +
        .byte   $32                             ; B2D0 32                       2
        bit     $2C                             ; B2D1 24 2C                    $,
        bit     $24                             ; B2D3 24 24                    $$
        bit     $21                             ; B2D5 24 21                    $!
        and     ($24,x)                         ; B2D7 21 24                    !$
        .byte   $03                             ; B2D9 03                       .
        bit     $03                             ; B2DA 24 03                    $.
        .byte   $03                             ; B2DC 03                       .
        .byte   $03                             ; B2DD 03                       .
        asl     a                               ; B2DE 0A                       .
        .byte   $0B                             ; B2DF 0B                       .
        .byte   $03                             ; B2E0 03                       .
        .byte   $12                             ; B2E1 12                       .
        asl     a                               ; B2E2 0A                       .
        .byte   $0B                             ; B2E3 0B                       .
        bpl     LB2F7                           ; B2E4 10 11                    ..
        asl     a                               ; B2E6 0A                       .
        .byte   $0B                             ; B2E7 0B                       .
        bit     $03                             ; B2E8 24 03                    $.
        and     ($03,x)                         ; B2EA 21 03                    !.
        .byte   $14                             ; B2EC 14                       .
        ora     $1A                             ; B2ED 05 1A                    ..
        ora     $2C24,y                         ; B2EF 19 24 2C                 .$,
        bit     $24                             ; B2F2 24 24                    $$
        asl     a                               ; B2F4 0A                       .
        .byte   $0B                             ; B2F5 0B                       .
        .byte   $0C                             ; B2F6 0C                       .
LB2F7:  ora     $3203                           ; B2F7 0D 03 32                 ..2
        bit     $3003                           ; B2FA 2C 03 30                 ,.0
        .byte   $03                             ; B2FD 03                       .
        and     ($03,x)                         ; B2FE 21 03                    !.
        and     $2339,y                         ; B300 39 39 23                 99#
        .byte   $23                             ; B303 23                       #
        bmi     LB336                           ; B304 30 30                    00
        bit     $24                             ; B306 24 24                    $$
        bmi     LB30D                           ; B308 30 03                    0.
        bit     $03                             ; B30A 24 03                    $.
        .byte   $03                             ; B30C 03                       .
LB30D:  .byte   $23                             ; B30D 23                       #
        .byte   $03                             ; B30E 03                       .
        .byte   $23                             ; B30F 23                       #
        .byte   $03                             ; B310 03                       .
        .byte   $39                             ; B311 39                       9
        .byte   $03                             ; B312 03                       .
LB313:  .byte   $23                             ; B313 23                       #
        .byte   $03                             ; B314 03                       .
LB315:  .byte   $23                             ; B315 23                       #
        .byte   $03                             ; B316 03                       .
        .byte   $03                             ; B317 03                       .
        bit     $24                             ; B318 24 24                    $$
        .byte   $03                             ; B31A 03                       .
        .byte   $03                             ; B31B 03                       .
        .byte   $23                             ; B31C 23                       #
        .byte   $37                             ; B31D 37                       7
        .byte   $03                             ; B31E 03                       .
        .byte   $3F                             ; B31F 3F                       ?
        .byte   $37                             ; B320 37                       7
        .byte   $37                             ; B321 37                       7
        .byte   $3F                             ; B322 3F                       ?
LB323:  .byte   $3F                             ; B323 3F                       ?
        .byte   $2B                             ; B324 2B                       +
        .byte   $37                             ; B325 37                       7
        .byte   $03                             ; B326 03                       .
        .byte   $3F                             ; B327 3F                       ?
        .byte   $04                             ; B328 04                       .
        ora     $18,x                           ; B329 15 18                    ..
        .byte   $1B                             ; B32B 1B                       .
        .byte   $23                             ; B32C 23                       #
        bit     $20                             ; B32D 24 20                    $ 
        and     ($5E,x)                         ; B32F 21 5E                    !^
        .byte   $5F                             ; B331 5F                       _
        asl     a                               ; B332 0A                       .
        .byte   $0B                             ; B333 0B                       .
        .byte   $02                             ; B334 02                       .
        .byte   $6D                             ; B335 6D                       m
LB336:  .byte   $02                             ; B336 02                       .
        adc     $5756                           ; B337 6D 56 57                 mVW
        .byte   $6B                             ; B33A 6B                       k
        ror     a                               ; B33B 6A                       j
        bit     $212C                           ; B33C 2C 2C 21                 ,,!
        and     ($2B,x)                         ; B33F 21 2B                    !+
        bit     $2120                           ; B341 2C 20 21                 , !
        .byte   $02                             ; B344 02                       .
        .byte   $14                             ; B345 14                       .
        .byte   $02                             ; B346 02                       .
        .byte   $1A                             ; B347 1A                       .
        .byte   $02                             ; B348 02                       .
        bit     $2402                           ; B349 2C 02 24                 ,.$
        bit     $246D                           ; B34C 2C 6D 24                 ,m$
        adc     $3002                           ; B34F 6D 02 30                 m.0
        .byte   $02                             ; B352 02                       .
        and     ($30,x)                         ; B353 21 30                    !0
        bmi     LB378                           ; B355 30 21                    0!
        asl     a                               ; B357 0A                       .
        and     $0A30,y                         ; B358 39 30 0A                 90.
        .byte   $0B                             ; B35B 0B                       .
        bmi     LB3CB                           ; B35C 30 6D                    0m
        asl     a                               ; B35E 0A                       .
        .byte   $0B                             ; B35F 0B                       .
        .byte   $02                             ; B360 02                       .
        bmi     LB36D                           ; B361 30 0A                    0.
        .byte   $0B                             ; B363 0B                       .
        bmi     LB37A                           ; B364 30 14                    0.
        and     ($1A,x)                         ; B366 21 1A                    !.
        .byte   $30                             ; B368 30                       0
LB369:  .byte   $30,$0A                    ; B369 30 0A   (branch out of range for ca65: target has no local label)
        .byte   $0B                             ; B36B 0B                       .
        .byte   $30                             ; B36C 30                       0
LB36D:  adc     $6D24                           ; B36D 6D 24 6D                 m$m
        bit     $24                             ; B370 24 24                    $$
        asl     a                               ; B372 0A                       .
        .byte   $0B                             ; B373 0B                       .
        bit     $6D                             ; B374 24 6D                    $m
        ora     ($6D,x)                         ; B376 01 6D                    .m
LB378:  brk                                     ; B378 00                       .
        brk                                     ; B379 00                       .
LB37A:  sta     $1298,y                         ; B37A 99 98 12                 ...
        .byte   $13                             ; B37D 13                       .
        brk                                     ; B37E 00                       .
        brk                                     ; B37F 00                       .
        bcc     LB313                           ; B380 90 91                    ..
        bcc     LB315                           ; B382 90 91                    ..
        sta     $9098,y                         ; B384 99 98 90                 ...
        sta     ($14),y                         ; B387 91 14                    ..
LB389:  ora     ($1C),y                         ; B389 11 1C                    ..
        sec                                     ; B38B 38                       8
        sty     L0000,x                         ; B38C 94 00                    ..
        .byte   $9C                             ; B38E 9C                       .
        brk                                     ; B38F 00                       .
        bcc     LB323                           ; B390 90 91                    ..
        .byte   $93                             ; B392 93                       .
        .byte   $92                             ; B393 92                       .
        .byte   $93                             ; B394 93                       .
        .byte   $92                             ; B395 92                       .
        asl     a                               ; B396 0A                       .
        .byte   $0B                             ; B397 0B                       .
        ora     (L000A,x)                       ; B398 01 0A                    ..
LB39A:  .byte   $02                             ; B39A 02                       .
        .byte   $1C                             ; B39B 1C                       .
        .byte   $02                             ; B39C 02                       .
        .byte   $14                             ; B39D 14                       .
        .byte   $02                             ; B39E 02                       .
LB39F:  .byte   $1C                             ; B39F 1C                       .
        .byte   $12                             ; B3A0 12                       .
        .byte   $13                             ; B3A1 13                       .
        sec                                     ; B3A2 38                       8
LB3A3:  sec                                     ; B3A3 38                       8
        brk                                     ; B3A4 00                       .
LB3A5:  brk                                     ; B3A5 00                       .
        brk                                     ; B3A6 00                       .
        brk                                     ; B3A7 00                       .
        sta     $95,x                           ; B3A8 95 95                    ..
        brk                                     ; B3AA 00                       .
        brk                                     ; B3AB 00                       .
        asl     $400E                           ; B3AC 0E 0E 40                 ..@
        eor     ($0E,x)                         ; B3AF 41 0E                    A.
        asl     $4141                           ; B3B1 0E 41 41                 .AA
        asl     $4295                           ; B3B4 0E 95 42                 ..B
        brk                                     ; B3B7 00                       .
        sta     $0E,x                           ; B3B8 95 0E                    ..
LB3BA:  brk                                     ; B3BA 00                       .
        rti                                     ; B3BB 40                       @

; ----------------------------------------------------------------------------
        .byte   $32                             ; B3BC 32                       2
        .byte   $32                             ; B3BD 32                       2
        brk                                     ; B3BE 00                       .
LB3BF:  brk                                     ; B3BF 00                       .
        asl     $410E                           ; B3C0 0E 0E 41                 ..A
        .byte   $42                             ; B3C3 42                       B
        clc                                     ; B3C4 18                       .
        ora     L0000,y                         ; B3C5 19 00 00                 ...
        clc                                     ; B3C8 18                       .
        .byte   $14                             ; B3C9 14                       .
        brk                                     ; B3CA 00                       .
LB3CB:  .byte   $1C                             ; B3CB 1C                       .
        sta     $9014,y                         ; B3CC 99 14 90                 ...
        .byte   $1C                             ; B3CF 1C                       .
        .byte   $13                             ; B3D0 13                       .
        .byte   $02                             ; B3D1 02                       .
        asl     a                               ; B3D2 0A                       .
        .byte   $0B                             ; B3D3 0B                       .
        sta     $95,x                           ; B3D4 95 95                    ..
        bcc     LB369                           ; B3D6 90 91                    ..
        sta     $14,x                           ; B3D8 95 14                    ..
        bcc     LB3F8                           ; B3DA 90 1C                    ..
        .byte   $12                             ; B3DC 12                       .
        .byte   $13                             ; B3DD 13                       .
        asl     a                               ; B3DE 0A                       .
        .byte   $0B                             ; B3DF 0B                       .
        .byte   $93                             ; B3E0 93                       .
        .byte   $14                             ; B3E1 14                       .
        ora     ($1C,x)                         ; B3E2 01 1C                    ..
        ora     L0000,x                         ; B3E4 15 00                    ..
        ora     $1598,x                         ; B3E6 1D 98 15                 ...
        sta     ($1D),y                         ; B3E9 91 1D                    ..
        sta     ($90),y                         ; B3EB 91 90                    ..
        sta     ($95),y                         ; B3ED 91 95                    ..
        asl     $950E,x                         ; B3EF 1E 0E 95                 ...
        .byte   $9B                             ; B3F2 9B                       .
        sta     ($90),y                         ; B3F3 91 90                    ..
        txs                                     ; B3F5 9A                       .
        bcc     LB389                           ; B3F6 90 91                    ..
LB3F8:  .byte   $1E                             ; B3F8 1E                       .
LB3F9:  sta     $9B,x                           ; B3F9 95 9B                    ..
        sta     ($15),y                         ; B3FB 91 15                    ..
        .byte   $92                             ; B3FD 92                       .
        .byte   $32                             ; B3FE 32                       2
        .byte   $32                             ; B3FF 32                       2
        .byte   $93                             ; B400 93                       .
        .byte   $92                             ; B401 92                       .
        .byte   $0B                             ; B402 0B                       .
        ora     ($95,x)                         ; B403 01 95                    ..
        asl     $9A90                           ; B405 0E 90 9A                 ...
        asl     $9B0E                           ; B408 0E 0E 9B                 ...
        txs                                     ; B40B 9A                       .
        bcc     LB39F                           ; B40C 90 91                    ..
        bcc     LB3A5                           ; B40E 90 95                    ..
        .byte   $90                             ; B410 90                       .
LB411:  sta     ($0E),y                         ; B411 91 0E                    ..
        sta     $95,x                           ; B413 95 95                    ..
        asl     $9293,x                         ; B415 1E 93 92                 ...
        .byte   $9B                             ; B418 9B                       .
        sta     ($93),y                         ; B419 91 93                    ..
        .byte   $92                             ; B41B 92                       .
        sta     $1E,x                           ; B41C 95 1E                    ..
        bcc     LB3BA                           ; B41E 90 9A                    ..
        sta     $95,x                           ; B420 95 95                    ..
        .byte   $93                             ; B422 93                       .
        .byte   $92                             ; B423 92                       .
        asl     $930E                           ; B424 0E 0E 93                 ...
        .byte   $92                             ; B427 92                       .
        .byte   $9C                             ; B428 9C                       .
        brk                                     ; B429 00                       .
        .byte   $9C                             ; B42A 9C                       .
        brk                                     ; B42B 00                       .
        bcc     LB3BF                           ; B42C 90 91                    ..
        rts                                     ; B42E 60                       `

; ----------------------------------------------------------------------------
        adc     ($90,x)                         ; B42F 61 90                    a.
        sta     ($62),y                         ; B431 91 62                    .b
        .byte   $63                             ; B433 63                       c
        .byte   $9C                             ; B434 9C                       .
        brk                                     ; B435 00                       .
        .byte   $62                             ; B436 62                       b
        .byte   $63                             ; B437 63                       c
        brk                                     ; B438 00                       .
        brk                                     ; B439 00                       .
        .byte   $62                             ; B43A 62                       b
        .byte   $63                             ; B43B 63                       c
        pla                                     ; B43C 68                       h
        adc     #$00                            ; B43D 69 00                    i.
        brk                                     ; B43F 00                       .
        ror     a:$6C                           ; B440 6E 6C 00                 nl.
        brk                                     ; B443 00                       .
        .byte   $52                             ; B444 52                       R
        bvc     LB499                           ; B445 50 52                    PR
        cli                                     ; B447 58                       X
        eor     ($5A),y                         ; B448 51 5A                    QZ
        eor     $705A,y                         ; B44A 59 5A 70                 YZp
        adc     ($70),y                         ; B44D 71 70                    qp
        adc     ($70),y                         ; B44F 71 70                    qp
        adc     ($7C),y                         ; B451 71 7C                    q|
        adc     LA1A0,x                         ; B453 7D A0 A1                 }..
        tay                                     ; B456 A8                       .
        lda     #$A2                            ; B457 A9 A2                    ..
        .byte   $A3                             ; B459 A3                       .
        tax                                     ; B45A AA                       .
        .byte   $AB                             ; B45B AB                       .
        ldy     #$A1                            ; B45C A0 A1                    ..
        bcs     LB411                           ; B45E B0 B1                    ..
        ldx     #$A3                            ; B460 A2 A3                    ..
        .byte   $B2                             ; B462 B2                       .
        .byte   $B3                             ; B463 B3                       .
        tay                                     ; B464 A8                       .
        lda     #$00                            ; B465 A9 00                    ..
        brk                                     ; B467 00                       .
        tax                                     ; B468 AA                       .
        .byte   $AB                             ; B469 AB                       .
LB46A:  brk                                     ; B46A 00                       .
        brk                                     ; B46B 00                       .
        .byte   $7C                             ; B46C 7C                       |
        adc     $4948,x                         ; B46D 7D 48 49                 }HI
        pha                                     ; B470 48                       H
        eor     #$00                            ; B471 49 00                    I.
        brk                                     ; B473 00                       .
        brk                                     ; B474 00                       .
        brk                                     ; B475 00                       .
        .byte   $64                             ; B476 64                       d
        rts                                     ; B477 60                       `

; ----------------------------------------------------------------------------
        brk                                     ; B478 00                       .
        brk                                     ; B479 00                       .
        adc     ($62,x)                         ; B47A 61 62                    ab
        brk                                     ; B47C 00                       .
        brk                                     ; B47D 00                       .
        .byte   $63                             ; B47E 63                       c
        .byte   $64                             ; B47F 64                       d
        brk                                     ; B480 00                       .
        brk                                     ; B481 00                       .
        rts                                     ; B482 60                       `

; ----------------------------------------------------------------------------
        adc     (L006E,x)                       ; B483 61 6E                    an
        pla                                     ; B485 68                       h
        brk                                     ; B486 00                       .
        brk                                     ; B487 00                       .
        adc     #$6E                            ; B488 69 6E                    in
        brk                                     ; B48A 00                       .
        brk                                     ; B48B 00                       .
LB48C:  jmp     (L006E)                         ; B48C 6C 6E 00                 ln.

; ----------------------------------------------------------------------------
        brk                                     ; B48F 00                       .
        ldy     #$A2                            ; B490 A0 A2                    ..
        tay                                     ; B492 A8                       .
        tax                                     ; B493 AA                       .
        lda     ($A2,x)                         ; B494 A1 A2                    ..
        lda     #$AA                            ; B496 A9 AA                    ..
        .byte   $A1                             ; B498 A1                       .
LB499:  .byte   $A3                             ; B499 A3                       .
        lda     #$AB                            ; B49A A9 AB                    ..
        .byte   $17                             ; B49C 17                       .
        .byte   $7A                             ; B49D 7A                       z
        sta     ($70,x)                         ; B49E 81 70                    .p
        .byte   $7B                             ; B4A0 7B                       {
        .byte   $7A                             ; B4A1 7A                       z
        adc     ($70),y                         ; B4A2 71 70                    qp
        .byte   $7B                             ; B4A4 7B                       {
        .byte   $17                             ; B4A5 17                       .
        adc     ($17),y                         ; B4A6 71 17                    q.
        .byte   $17                             ; B4A8 17                       .
        ldy     #$81                            ; B4A9 A0 81                    ..
        tay                                     ; B4AB A8                       .
        .byte   $A3                             ; B4AC A3                       .
        .byte   $17                             ; B4AD 17                       .
        .byte   $AB                             ; B4AE AB                       .
        sta     ($A8,x)                         ; B4AF 81 A8                    ..
        lda     #$17                            ; B4B1 A9 17                    ..
        brk                                     ; B4B3 00                       .
        .byte   $80                             ; B4B4 80                       .
        .byte   $52                             ; B4B5 52                       R
        sta     ($52,x)                         ; B4B6 81 52                    .R
        bvc     LB50B                           ; B4B8 50 51                    PQ
        cli                                     ; B4BA 58                       X
        eor     $805A,y                         ; B4BB 59 5A 80                 YZ.
        .byte   $5A                             ; B4BE 5A                       Z
        brk                                     ; B4BF 00                       .
        sta     (L0000,x)                       ; B4C0 81 00                    ..
        brk                                     ; B4C2 00                       .
        brk                                     ; B4C3 00                       .
        .byte   $80                             ; B4C4 80                       .
        ldy     #$00                            ; B4C5 A0 00                    ..
        bcs     LB46A                           ; B4C7 B0 A1                    ..
        ldx     #$B1                            ; B4C9 A2 B1                    ..
        .byte   $B2                             ; B4CB B2                       .
        .byte   $A3                             ; B4CC A3                       .
        brk                                     ; B4CD 00                       .
        .byte   $B3                             ; B4CE B3                       .
        brk                                     ; B4CF 00                       .
        brk                                     ; B4D0 00                       .
        tay                                     ; B4D1 A8                       .
        brk                                     ; B4D2 00                       .
        .byte   $0F                             ; B4D3 0F                       .
        lda     #$AA                            ; B4D4 A9 AA                    ..
        .byte   $0F                             ; B4D6 0F                       .
        .byte   $0F                             ; B4D7 0F                       .
        .byte   $AB                             ; B4D8 AB                       .
        brk                                     ; B4D9 00                       .
        .byte   $0F                             ; B4DA 0F                       .
        brk                                     ; B4DB 00                       .
        brk                                     ; B4DC 00                       .
        brk                                     ; B4DD 00                       .
        .byte   $80                             ; B4DE 80                       .
        rts                                     ; B4DF 60                       `

; ----------------------------------------------------------------------------
        brk                                     ; B4E0 00                       .
        .byte   $0F                             ; B4E1 0F                       .
        adc     $66                             ; B4E2 65 66                    ef
        .byte   $0F                             ; B4E4 0F                       .
        .byte   $0F                             ; B4E5 0F                       .
        sty     $85                             ; B4E6 84 85                    ..
        .byte   $0F                             ; B4E8 0F                       .
        brk                                     ; B4E9 00                       .
        ror     $67                             ; B4EA 66 67                    fg
        brk                                     ; B4EC 00                       .
        brk                                     ; B4ED 00                       .
        adc     $65,x                           ; B4EE 75 65                    ue
        sta     ($68,x)                         ; B4F0 81 68                    .h
        brk                                     ; B4F2 00                       .
        brk                                     ; B4F3 00                       .
        adc     a:$69                           ; B4F4 6D 69 00                 mi.
        brk                                     ; B4F7 00                       .
        sty     a:$8D                           ; B4F8 8C 8D 00                 ...
        brk                                     ; B4FB 00                       .
        adc     #$6F                            ; B4FC 69 6F                    io
        brk                                     ; B4FE 00                       .
        brk                                     ; B4FF 00                       .
        adc     #$6D                            ; B500 69 6D                    im
        brk                                     ; B502 00                       .
        brk                                     ; B503 00                       .
        .byte   $7A                             ; B504 7A                       z
        .byte   $7B                             ; B505 7B                       {
        bvs     LB579                           ; B506 70 71                    pq
        .byte   $17                             ; B508 17                       .
        bvs     LB48C                           ; B509 70 81                    p.
LB50B:  .byte   $7C                             ; B50B 7C                       |
        adc     ($17),y                         ; B50C 71 17                    q.
        adc     a:$81,x                         ; B50E 7D 81 00                 }..
        bvs     LB513                           ; B511 70 00                    p.
LB513:  bvs     LB586                           ; B513 70 71                    pq
        brk                                     ; B515 00                       .
        adc     (L0000),y                       ; B516 71 00                    q.
        brk                                     ; B518 00                       .
        .byte   $7C                             ; B519 7C                       |
        brk                                     ; B51A 00                       .
        pha                                     ; B51B 48                       H
        adc     $4900,x                         ; B51C 7D 00 49                 }.I
        brk                                     ; B51F 00                       .
        brk                                     ; B520 00                       .
        .byte   $0F                             ; B521 0F                       .
        brk                                     ; B522 00                       .
        .byte   $0F                             ; B523 0F                       .
        .byte   $0F                             ; B524 0F                       .
        brk                                     ; B525 00                       .
        .byte   $0F                             ; B526 0F                       .
        brk                                     ; B527 00                       .
        brk                                     ; B528 00                       .
        brk                                     ; B529 00                       .
        sty     $85                             ; B52A 84 85                    ..
        brk                                     ; B52C 00                       .
        brk                                     ; B52D 00                       .
        .byte   $67                             ; B52E 67                       g
        rts                                     ; B52F 60                       `

; ----------------------------------------------------------------------------
        .byte   $6F                             ; B530 6F                       o
        pla                                     ; B531 68                       h
        brk                                     ; B532 00                       .
        brk                                     ; B533 00                       .
        adc     $4981,x                         ; B534 7D 81 49                 }.I
        .byte   $80                             ; B537 80                       .
        .byte   $0F                             ; B538 0F                       .
        .byte   $0F                             ; B539 0F                       .
        .byte   $0F                             ; B53A 0F                       .
        .byte   $0F                             ; B53B 0F                       .
        .byte   $7A                             ; B53C 7A                       z
        .byte   $7B                             ; B53D 7B                       {
        .byte   $7C                             ; B53E 7C                       |
        adc     $7170,x                         ; B53F 7D 70 71                 }pq
        ror     a:$7F,x                         ; B542 7E 7F 00                 ~..
        .byte   $17                             ; B545 17                       .
        brk                                     ; B546 00                       .
        sta     (L0000,x)                       ; B547 81 00                    ..
        brk                                     ; B549 00                       .
        adc     $66                             ; B54A 65 66                    ef
        brk                                     ; B54C 00                       .
        brk                                     ; B54D 00                       .
        ror     $67                             ; B54E 66 67                    fg
        .byte   $80                             ; B550 80                       .
        .byte   $02                             ; B551 02                       .
        dey                                     ; B552 88                       .
        .byte   $02                             ; B553 02                       .
        bit     $2402                           ; B554 2C 02 24                 ,.$
        .byte   $02                             ; B557 02                       .
        bmi     LB55C                           ; B558 30 02                    0.
        asl     a                               ; B55A 0A                       .
        .byte   $0B                             ; B55B 0B                       .
LB55C:  and     $0A39,y                         ; B55C 39 39 0A                 99.
        .byte   $0B                             ; B55F 0B                       .
        .byte   $23                             ; B560 23                       #
        bit     $62                             ; B561 24 62                    $b
        .byte   $63                             ; B563 63                       c
        .byte   $12                             ; B564 12                       .
        .byte   $13                             ; B565 13                       .
        .byte   $62                             ; B566 62                       b
        .byte   $63                             ; B567 63                       c
        .byte   $02                             ; B568 02                       .
        .byte   $12                             ; B569 12                       .
        .byte   $02                             ; B56A 02                       .
        bit     $1110                           ; B56B 2C 10 11                 ,..
        .byte   $2B                             ; B56E 2B                       +
        bit     $1110                           ; B56F 2C 10 11                 ,..
        bit     $0B2C                           ; B572 2C 2C 0B                 ,,.
        ora     ($80,x)                         ; B575 01 80                    ..
        .byte   $02                             ; B577 02                       .
        .byte   $24                             ; B578 24                       $
LB579:  .byte   $80                             ; B579 80                       .
        and     ($17,x)                         ; B57A 21 17                    !.
        bit     $80                             ; B57C 24 80                    $.
        and     ($88,x)                         ; B57E 21 88                    !.
        bit     $2117                           ; B580 2C 17 21                 ,.!
        .byte   $80                             ; B583 80                       .
        .byte   $14                             ; B584 14                       .
        .byte   $80                             ; B585 80                       .
LB586:  .byte   $1C                             ; B586 1C                       .
        .byte   $80                             ; B587 80                       .
        bit     $17                             ; B588 24 17                    $.
        bit     $17                             ; B58A 24 17                    $.
        .byte   $04                             ; B58C 04                       .
        .byte   $1F                             ; B58D 1F                       .
        .byte   $0C                             ; B58E 0C                       .
        ora     $1F04                           ; B58F 0D 04 1F                 ...
        .byte   $0C                             ; B592 0C                       .
        ora     $1312,y                         ; B593 19 12 13                 ...
        .byte   $2B                             ; B596 2B                       +
        bit     $2C1B                           ; B597 2C 1B 2C                 ,.,
        .byte   $2B                             ; B59A 2B                       +
        bit     $30                             ; B59B 24 30                    $0
        dey                                     ; B59D 88                       .
        and     ($80,x)                         ; B59E 21 80                    !.
        .byte   $34                             ; B5A0 34                       4
        .byte   $34                             ; B5A1 34                       4
        asl     $06                             ; B5A2 06 06                    ..
        .byte   $23                             ; B5A4 23                       #
        .byte   $80                             ; B5A5 80                       .
        jsr     L2680                           ; B5A6 20 80 26                  .&
        .byte   $27                             ; B5A9 27                       '
        rol     $122F                           ; B5AA 2E 2F 12                 ./.
        .byte   $13                             ; B5AD 13                       .
        bit     $0B07                           ; B5AE 2C 07 0B                 ,..
        .byte   $34                             ; B5B1 34                       4
        ora     $2406,x                         ; B5B2 1D 06 24                 ..$
        .byte   $07                             ; B5B5 07                       .
        and     ($07,x)                         ; B5B6 21 07                    !.
        .byte   $14                             ; B5B8 14                       .
        .byte   $80                             ; B5B9 80                       .
        .byte   $1C                             ; B5BA 1C                       .
        dey                                     ; B5BB 88                       .
        .byte   $12                             ; B5BC 12                       .
        .byte   $13                             ; B5BD 13                       .
        bit     $352C                           ; B5BE 2C 2C 35                 ,,5
        and     $3D,x                           ; B5C1 35 3D                    5=
        and     $3D3D,x                         ; B5C3 3D 3D 3D                 ===
        and     LA43D,x                         ; B5C6 3D 3D A4                 ==.
        lda     $70                             ; B5C9 A5 70                    .p
        adc     ($A6),y                         ; B5CB 71 A6                    q.
        .byte   $A7                             ; B5CD A7                       .
        bvs     LB641                           ; B5CE 70 71                    pq
        brk                                     ; B5D0 00                       .
        brk                                     ; B5D1 00                       .
        brk                                     ; B5D2 00                       .
        dex                                     ; B5D3 CA                       .
        cmp     ($D2),y                         ; B5D4 D1 D2                    ..
        cmp     $D3DA,y                         ; B5D6 D9 DA D3                 ...
        brk                                     ; B5D9 00                       .
        .byte   $DB                             ; B5DA DB                       .
        brk                                     ; B5DB 00                       .
        brk                                     ; B5DC 00                       .
        cpx     #$00                            ; B5DD E0 00                    ..
        inx                                     ; B5DF E8                       .
        sbc     ($E2,x)                         ; B5E0 E1 E2                    ..
        sbc     #$EA                            ; B5E2 E9 EA                    ..
        .byte   $E3                             ; B5E4 E3                       .
        cpx     $EB                             ; B5E5 E4 EB                    ..
        cpx     $F000                           ; B5E7 EC 00 F0                 ...
        brk                                     ; B5EA 00                       .
        sed                                     ; B5EB F8                       .
        sbc     ($F2),y                         ; B5EC F1 F2                    ..
        sbc     $F3FA,y                         ; B5EE F9 FA F3                 ...
        .byte   $F4                             ; B5F1 F4                       .
        .byte   $FB                             ; B5F2 FB                       .
        .byte   $FC                             ; B5F3 FC                       .
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
        brk                                     ; B5FF 00                       .
        brk                                     ; B600 00                       .
        brk                                     ; B601 00                       .
        brk                                     ; B602 00                       .
        ora     (L0000,x)                       ; B603 01 00                    ..
        brk                                     ; B605 00                       .
        brk                                     ; B606 00                       .
        brk                                     ; B607 00                       .
        ora     (L0002,x)                       ; B608 01 02                    ..
        .byte   $02                             ; B60A 02                       .
        .byte   $03                             ; B60B 03                       .
        .byte   $04                             ; B60C 04                       .
        .byte   $02                             ; B60D 02                       .
        .byte   $04                             ; B60E 04                       .
        ora     $06                             ; B60F 05 06                    ..
        .byte   $07                             ; B611 07                       .
        .byte   $07                             ; B612 07                       .
        php                                     ; B613 08                       .
        ora     #$07                            ; B614 09 07                    ..
        ora     #$05                            ; B616 09 05                    ..
        asl     L000A                           ; B618 06 0A                    ..
        asl     a                               ; B61A 0A                       .
        php                                     ; B61B 08                       .
        ora     #$07                            ; B61C 09 07                    ..
        ora     #$05                            ; B61E 09 05                    ..
        .byte   $0B                             ; B620 0B                       .
        .byte   $0C                             ; B621 0C                       .
        .byte   $0C                             ; B622 0C                       .
        ora     $0F0E                           ; B623 0D 0E 0F                 ...
        ora     ($01,x)                         ; B626 01 01                    ..
        asl     L0002                           ; B628 06 02                    ..
        .byte   $02                             ; B62A 02                       .
        bpl     LB63E                           ; B62B 10 11                    ..
        .byte   $12                             ; B62D 12                       .
        .byte   $04                             ; B62E 04                       .
        ora     $01                             ; B62F 05 01                    ..
        ora     ($01,x)                         ; B631 01 01                    ..
        ora     ($01,x)                         ; B633 01 01                    ..
        ora     ($13,x)                         ; B635 01 13                    ..
        ora     $14                             ; B637 05 14                    ..
        .byte   $14                             ; B639 14                       .
        .byte   $14                             ; B63A 14                       .
        .byte   $14                             ; B63B 14                       .
        .byte   $14                             ; B63C 14                       .
        .byte   $14                             ; B63D 14                       .
LB63E:  ora     $16,x                           ; B63E 15 16                    ..
        .byte   $06                             ; B640 06                       .
LB641:  .byte   $17                             ; B641 17                       .
        clc                                     ; B642 18                       .
        ora     $181A,y                         ; B643 19 1A 18                 ...
        .byte   $1B                             ; B646 1B                       .
        asl     $06,x                           ; B647 16 06                    ..
        .byte   $1C                             ; B649 1C                       .
        ora     $1F1E,x                         ; B64A 1D 1E 1F                 ...
        jsr     L1621                           ; B64D 20 21 16                  !.
        asl     $1C                             ; B650 06 1C                    ..
        ora     $221E,x                         ; B652 1D 1E 22                 .."
        ora     $14                             ; B655 05 14                    ..
        .byte   $14                             ; B657 14                       .
        asl     $23                             ; B658 06 23                    .#
        .byte   $12                             ; B65A 12                       .
        bit     $25                             ; B65B 24 25                    $%
        rol     $05                             ; B65D 26 05                    &.
        .byte   $14                             ; B65F 14                       .
        asl     $23                             ; B660 06 23                    .#
        .byte   $12                             ; B662 12                       .
        bit     $11                             ; B663 24 11                    $.
        .byte   $27                             ; B665 27                       '
        ora     $14                             ; B666 05 14                    ..
        asl     $28                             ; B668 06 28                    .(
        and     #$08                            ; B66A 29 08                    ).
        ora     #$2A                            ; B66C 09 2A                    .*
        ora     $14                             ; B66E 05 14                    ..
        asl     $28                             ; B670 06 28                    .(
        and     #$08                            ; B672 29 08                    ).
        ora     #$2A                            ; B674 09 2A                    .*
        ora     $14                             ; B676 05 14                    ..
        asl     $23,x                           ; B678 16 23                    .#
        .byte   $12                             ; B67A 12                       .
        bit     $11                             ; B67B 24 11                    $.
        .byte   $27                             ; B67D 27                       '
        asl     $16,x                           ; B67E 16 16                    ..
        asl     $23,x                           ; B680 16 23                    .#
        .byte   $12                             ; B682 12                       .
        bit     $11                             ; B683 24 11                    $.
        .byte   $27                             ; B685 27                       '
        asl     $16,x                           ; B686 16 16                    ..
        asl     $28                             ; B688 06 28                    .(
        .byte   $07                             ; B68A 07                       .
        php                                     ; B68B 08                       .
        ora     #$2A                            ; B68C 09 2A                    .*
        ora     $14                             ; B68E 05 14                    ..
        asl     $28                             ; B690 06 28                    .(
        and     #$08                            ; B692 29 08                    ).
        ora     #$2A                            ; B694 09 2A                    .*
        ora     $14                             ; B696 05 14                    ..
        asl     $2B                             ; B698 06 2B                    .+
        .byte   $12                             ; B69A 12                       .
        bit     $11                             ; B69B 24 11                    $.
        bit     $052D                           ; B69D 2C 2D 05                 ,-.
        .byte   $14                             ; B6A0 14                       .
        rol     $0807                           ; B6A1 2E 07 08                 ...
        ora     #$29                            ; B6A4 09 29                    .)
        .byte   $2F                             ; B6A6 2F                       /
        ora     $30                             ; B6A7 05 30                    .0
        and     ($32),y                         ; B6A9 31 32                    12
        .byte   $33                             ; B6AB 33                       3
        .byte   $34                             ; B6AC 34                       4
        .byte   $12                             ; B6AD 12                       .
        .byte   $2F                             ; B6AE 2F                       /
        ora     $14                             ; B6AF 05 14                    ..
        asl     $28                             ; B6B1 06 28                    .(
        php                                     ; B6B3 08                       .
        ora     #$07                            ; B6B4 09 07                    ..
        .byte   $2F                             ; B6B6 2F                       /
        ora     $16                             ; B6B7 05 16                    ..
        asl     $1C,x                           ; B6B9 16 1C                    ..
        asl     $1D35,x                         ; B6BB 1E 35 1D                 .5.
        .byte   $2F                             ; B6BE 2F                       /
        asl     $16,x                           ; B6BF 16 16                    ..
        asl     $28,x                           ; B6C1 16 28                    .(
        php                                     ; B6C3 08                       .
        ora     #$29                            ; B6C4 09 29                    .)
        .byte   $2F                             ; B6C6 2F                       /
        asl     $14,x                           ; B6C7 16 14                    ..
        asl     $23                             ; B6C9 06 23                    .#
        bit     $36                             ; B6CB 24 36                    $6
        .byte   $37                             ; B6CD 37                       7
        sec                                     ; B6CE 38                       8
        and     $0614,y                         ; B6CF 39 14 06                 9..
        .byte   $1C                             ; B6D2 1C                       .
        asl     $3B3A,x                         ; B6D3 1E 3A 3B                 .:;
        brk                                     ; B6D6 00                       .
        brk                                     ; B6D7 00                       .
        .byte   $14                             ; B6D8 14                       .
        asl     $23                             ; B6D9 06 23                    .#
        bit     $3C                             ; B6DB 24 3C                    $<
        .byte   $02                             ; B6DD 02                       .
        .byte   $2F                             ; B6DE 2F                       /
        ora     $3D                             ; B6DF 05 3D                    .=
        and     $242E,x                         ; B6E1 3D 2E 24                 =.$
        ora     ($12),y                         ; B6E4 11 12                    ..
        rol     $1401,x                         ; B6E6 3E 01 14                 >..
        .byte   $14                             ; B6E9 14                       .
        rol     $0908                           ; B6EA 2E 08 09                 ...
        and     #$3F                            ; B6ED 29 3F                    )?
        ora     $14                             ; B6EF 05 14                    ..
        .byte   $14                             ; B6F1 14                       .
        rol     $1124                           ; B6F2 2E 24 11                 .$.
        .byte   $12                             ; B6F5 12                       .
        rol     $05,x                           ; B6F6 36 05                    6.
        .byte   $14                             ; B6F8 14                       .
        .byte   $14                             ; B6F9 14                       .
        rol     $1124                           ; B6FA 2E 24 11                 .$.
        .byte   $12                             ; B6FD 12                       .
        rol     $05,x                           ; B6FE 36 05                    6.
        .byte   $14                             ; B700 14                       .
        .byte   $14                             ; B701 14                       .
        rol     $1124                           ; B702 2E 24 11                 .$.
        .byte   $12                             ; B705 12                       .
        rol     $05,x                           ; B706 36 05                    6.
        .byte   $14                             ; B708 14                       .
        .byte   $14                             ; B709 14                       .
        rol     $4140                           ; B70A 2E 40 41                 .@A
        asl     a                               ; B70D 0A                       .
        .byte   $42                             ; B70E 42                       B
        ora     $14                             ; B70F 05 14                    ..
        .byte   $14                             ; B711 14                       .
        rol     $4140                           ; B712 2E 40 41                 .@A
        asl     a                               ; B715 0A                       .
        .byte   $42                             ; B716 42                       B
        ora     $14                             ; B717 05 14                    ..
        .byte   $14                             ; B719 14                       .
        rol     $4140                           ; B71A 2E 40 41                 .@A
        asl     a                               ; B71D 0A                       .
        .byte   $42                             ; B71E 42                       B
        ora     $14                             ; B71F 05 14                    ..
        .byte   $14                             ; B721 14                       .
        rol     $0908                           ; B722 2E 08 09                 ...
        .byte   $07                             ; B725 07                       .
        .byte   $3F                             ; B726 3F                       ?
        ora     $14                             ; B727 05 14                    ..
        .byte   $14                             ; B729 14                       .
        rol     $1124                           ; B72A 2E 24 11                 .$.
        .byte   $12                             ; B72D 12                       .
        rol     $05,x                           ; B72E 36 05                    6.
        ora     ($01,x)                         ; B730 01 01                    ..
        ora     ($43,x)                         ; B732 01 43                    .C
        ora     ($12),y                         ; B734 11 12                    ..
        rol     $05,x                           ; B736 36 05                    6.
        asl     $16,x                           ; B738 16 16                    ..
        asl     $43,x                           ; B73A 16 43                    .C
        ora     ($12),y                         ; B73C 11 12                    ..
        rol     $16,x                           ; B73E 36 16                    6.
        asl     $16,x                           ; B740 16 16                    ..
        asl     $43,x                           ; B742 16 43                    .C
        ora     ($12),y                         ; B744 11 12                    ..
        rol     $16,x                           ; B746 36 16                    6.
        .byte   $14                             ; B748 14                       .
        .byte   $14                             ; B749 14                       .
        asl     $43                             ; B74A 06 43                    .C
        ora     ($12),y                         ; B74C 11 12                    ..
        rol     $05,x                           ; B74E 36 05                    6.
        .byte   $14                             ; B750 14                       .
        .byte   $14                             ; B751 14                       .
        asl     $44                             ; B752 06 44                    .D
        eor     ($07,x)                         ; B754 41 07                    A.
        .byte   $3F                             ; B756 3F                       ?
        ora     $14                             ; B757 05 14                    ..
        .byte   $14                             ; B759 14                       .
        asl     $44                             ; B75A 06 44                    .D
        eor     (L000A,x)                       ; B75C 41 0A                    A.
        .byte   $42                             ; B75E 42                       B
        .byte   $3B                             ; B75F 3B                       ;
        .byte   $14                             ; B760 14                       .
        .byte   $14                             ; B761 14                       .
        asl     $43                             ; B762 06 43                    .C
        ora     ($12),y                         ; B764 11 12                    ..
        .byte   $3C                             ; B766 3C                       <
        .byte   $02                             ; B767 02                       .
        .byte   $14                             ; B768 14                       .
        .byte   $14                             ; B769 14                       .
        asl     $44                             ; B76A 06 44                    .D
        eor     ($07,x)                         ; B76C 41 07                    A.
        ora     #$07                            ; B76E 09 07                    ..
        .byte   $14                             ; B770 14                       .
        .byte   $14                             ; B771 14                       .
        asl     $45                             ; B772 06 45                    .E
        lsr     $47                             ; B774 46 47                    FG
        pha                                     ; B776 48                       H
        pha                                     ; B777 48                       H
        .byte   $14                             ; B778 14                       .
        .byte   $14                             ; B779 14                       .
        asl     $03                             ; B77A 06 03                    ..
        .byte   $04                             ; B77C 04                       .
        eor     #$48                            ; B77D 49 48                    IH
        pha                                     ; B77F 48                       H
        ora     $14                             ; B780 05 14                    ..
        .byte   $14                             ; B782 14                       .
        asl     $48                             ; B783 06 48                    .H
        pha                                     ; B785 48                       H
        ora     $06                             ; B786 05 06                    ..
        .byte   $14                             ; B788 14                       .
        .byte   $14                             ; B789 14                       .
        .byte   $14                             ; B78A 14                       .
        asl     $48                             ; B78B 06 48                    .H
        pha                                     ; B78D 48                       H
        ora     $06                             ; B78E 05 06                    ..
        asl     $04                             ; B790 06 04                    ..
        .byte   $02                             ; B792 02                       .
        .byte   $02                             ; B793 02                       .
        .byte   $04                             ; B794 04                       .
        .byte   $02                             ; B795 02                       .
        .byte   $04                             ; B796 04                       .
        .byte   $02                             ; B797 02                       .
        lsr     a                               ; B798 4A                       J
        eor     ($07,x)                         ; B799 41 07                    A.
        and     #$09                            ; B79B 29 09                    ).
        and     #$01                            ; B79D 29 01                    ).
        ora     ($04,x)                         ; B79F 01 04                    ..
        ora     ($4B),y                         ; B7A1 11 4B                    .K
        ora     $0101,x                         ; B7A3 1D 01 01                 ...
        ora     $14                             ; B7A6 05 14                    ..
        ora     #$09                            ; B7A8 09 09                    ..
        ora     ($01,x)                         ; B7AA 01 01                    ..
        ora     $06                             ; B7AC 05 06                    ..
        ora     $14                             ; B7AE 05 14                    ..
        pha                                     ; B7B0 48                       H
        pha                                     ; B7B1 48                       H
        ora     $06                             ; B7B2 05 06                    ..
        pha                                     ; B7B4 48                       H
        pha                                     ; B7B5 48                       H
        ora     $14                             ; B7B6 05 14                    ..
        pha                                     ; B7B8 48                       H
        pha                                     ; B7B9 48                       H
        ora     $06                             ; B7BA 05 06                    ..
        pha                                     ; B7BC 48                       H
        pha                                     ; B7BD 48                       H
        ora     $14                             ; B7BE 05 14                    ..
        ora     ($01,x)                         ; B7C0 01 01                    ..
        asl     $4C,x                           ; B7C2 16 4C                    .L
        asl     $4C,x                           ; B7C4 16 4C                    .L
        asl     $4D,x                           ; B7C6 16 4D                    .M
        asl     $16,x                           ; B7C8 16 16                    ..
        asl     $4E,x                           ; B7CA 16 4E                    .N
        asl     $4E,x                           ; B7CC 16 4E                    .N
        asl     $4D,x                           ; B7CE 16 4D                    .M
        .byte   $02                             ; B7D0 02                       .
        .byte   $04                             ; B7D1 04                       .
        .byte   $02                             ; B7D2 02                       .
        jmp     L4C16                           ; B7D3 4C 16 4C                 L.L

; ----------------------------------------------------------------------------
        asl     $4D,x                           ; B7D6 16 4D                    .M
        ora     ($01,x)                         ; B7D8 01 01                    ..
        and     #$16                            ; B7DA 29 16                    ).
        asl     $16,x                           ; B7DC 16 16                    ..
        asl     $4D,x                           ; B7DE 16 4D                    .M
        .byte   $14                             ; B7E0 14                       .
        asl     $4B                             ; B7E1 06 4B                    .K
        .byte   $4F                             ; B7E3 4F                       O
        bvc     LB835                           ; B7E4 50 4F                    PO
        .byte   $4F                             ; B7E6 4F                       O
        eor     $0614                           ; B7E7 4D 14 06                 M..
        ora     $1D35,x                         ; B7EA 1D 35 1D                 .5.
        and     $35,x                           ; B7ED 35 35                    55
        eor     $0614                           ; B7EF 4D 14 06                 M..
        pha                                     ; B7F2 48                       H
        pha                                     ; B7F3 48                       H
        pha                                     ; B7F4 48                       H
        pha                                     ; B7F5 48                       H
        pha                                     ; B7F6 48                       H
        pha                                     ; B7F7 48                       H
        .byte   $14                             ; B7F8 14                       .
        asl     $48                             ; B7F9 06 48                    .H
        pha                                     ; B7FB 48                       H
        pha                                     ; B7FC 48                       H
        pha                                     ; B7FD 48                       H
        pha                                     ; B7FE 48                       H
        pha                                     ; B7FF 48                       H
        asl     $51                             ; B800 06 51                    .Q
        brk                                     ; B802 00                       .
        brk                                     ; B803 00                       .
        brk                                     ; B804 00                       .
        brk                                     ; B805 00                       .
        brk                                     ; B806 00                       .
        brk                                     ; B807 00                       .
        asl     $52                             ; B808 06 52                    .R
        .byte   $02                             ; B80A 02                       .
        .byte   $04                             ; B80B 04                       .
        .byte   $03                             ; B80C 03                       .
        .byte   $04                             ; B80D 04                       .
        .byte   $02                             ; B80E 02                       .
        .byte   $53                             ; B80F 53                       S
        asl     $54                             ; B810 06 54                    .T
        and     #$09                            ; B812 29 09                    ).
        php                                     ; B814 08                       .
        eor     $56,x                           ; B815 55 56                    UV
        .byte   $57                             ; B817 57                       W
        asl     $58                             ; B818 06 58                    .X
        asl     a                               ; B81A 0A                       .
        eor     (L0008,x)                       ; B81B 41 08                    A.
        eor     L0000,y                         ; B81D 59 00 00                 Y..
        .byte   $14                             ; B820 14                       .
        asl     $20                             ; B821 06 20                    . 
        ora     ($24),y                         ; B823 11 24                    .$
        .byte   $3C                             ; B825 3C                       <
        .byte   $02                             ; B826 02                       .
        .byte   $53                             ; B827 53                       S
        asl     $16,x                           ; B828 16 16                    ..
        asl     $5A,x                           ; B82A 16 5A                    .Z
        rti                                     ; B82C 40                       @

; ----------------------------------------------------------------------------
        eor     (L000A,x)                       ; B82D 41 0A                    A.
        .byte   $5B                             ; B82F 5B                       [
        asl     $4E,x                           ; B830 16 4E                    .N
        ora     $06                             ; B832 05 06                    ..
        .byte   $01                             ; B834 01                       .
LB835:  .byte   $5C                             ; B835 5C                       \
        jsr     L165D                           ; B836 20 5D 16                  ].
        jmp     L4E16                           ; B839 4C 16 4E                 L.N

; ----------------------------------------------------------------------------
        asl     $4E,x                           ; B83C 16 4E                    .N
        asl     $4D,x                           ; B83E 16 4D                    .M
        .byte   $14                             ; B840 14                       .
        .byte   $14                             ; B841 14                       .
        .byte   $14                             ; B842 14                       .
        .byte   $14                             ; B843 14                       .
        .byte   $14                             ; B844 14                       .
        .byte   $14                             ; B845 14                       .
        .byte   $14                             ; B846 14                       .
        .byte   $14                             ; B847 14                       .
        .byte   $14                             ; B848 14                       .
        asl     $5E                             ; B849 06 5E                    .^
        lsr     $5E5E,x                         ; B84B 5E 5E 5E                 ^^^
        lsr     $0605,x                         ; B84E 5E 05 06                 ^..
        .byte   $5F                             ; B851 5F                       _
        rts                                     ; B852 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; B853 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; B854 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; B855 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; B856 60                       `

; ----------------------------------------------------------------------------
        ora     $06                             ; B857 05 06                    ..
        adc     ($60,x)                         ; B859 61 60                    a`
        rts                                     ; B85B 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; B85C 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; B85D 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; B85E 60                       `

; ----------------------------------------------------------------------------
        .byte   $62                             ; B85F 62                       b
        asl     $60                             ; B860 06 60                    .`
        rts                                     ; B862 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; B863 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; B864 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; B865 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; B866 60                       `

; ----------------------------------------------------------------------------
        .byte   $63                             ; B867 63                       c
        asl     $64                             ; B868 06 64                    .d
        .byte   $64                             ; B86A 64                       d
        .byte   $64                             ; B86B 64                       d
        adc     $65                             ; B86C 65 65                    ee
        ora     ($01,x)                         ; B86E 01 01                    ..
        asl     $66                             ; B870 06 66                    .f
        ora     ($01,x)                         ; B872 01 01                    ..
        asl     $16,x                           ; B874 16 16                    ..
        asl     $16,x                           ; B876 16 16                    ..
        asl     $67                             ; B878 06 67                    .g
        asl     $16,x                           ; B87A 16 16                    ..
        asl     $16,x                           ; B87C 16 16                    ..
        asl     $16,x                           ; B87E 16 16                    ..
        asl     $16                             ; B880 06 16                    ..
        asl     $16,x                           ; B882 16 16                    ..
        ora     $14                             ; B884 05 14                    ..
        asl     $16                             ; B886 06 16                    ..
        asl     $4E                             ; B888 06 4E                    .N
        asl     $4E,x                           ; B88A 16 4E                    .N
        ora     $14                             ; B88C 05 14                    ..
        asl     $4E                             ; B88E 06 4E                    .N
        asl     $4C                             ; B890 06 4C                    .L
        asl     $4C,x                           ; B892 16 4C                    .L
        ora     $14                             ; B894 05 14                    ..
        asl     $4C                             ; B896 06 4C                    .L
        pla                                     ; B898 68                       h
        pla                                     ; B899 68                       h
        pla                                     ; B89A 68                       h
        pla                                     ; B89B 68                       h
        pla                                     ; B89C 68                       h
        pla                                     ; B89D 68                       h
        pla                                     ; B89E 68                       h
        pla                                     ; B89F 68                       h
        adc     #$69                            ; B8A0 69 69                    ii
        adc     #$69                            ; B8A2 69 69                    ii
        adc     #$69                            ; B8A4 69 69                    ii
        adc     #$69                            ; B8A6 69 69                    ii
        ora     ($6A,x)                         ; B8A8 01 6A                    .j
        ror     a                               ; B8AA 6A                       j
        .byte   $6B                             ; B8AB 6B                       k
        jmp     (L6A6D)                         ; B8AC 6C 6D 6A                 lmj

; ----------------------------------------------------------------------------
        ror     $6F01                           ; B8AF 6E 01 6F                 n.o
        .byte   $6F                             ; B8B2 6F                       o
        .byte   $6F                             ; B8B3 6F                       o
        .byte   $6F                             ; B8B4 6F                       o
        .byte   $6F                             ; B8B5 6F                       o
        .byte   $6F                             ; B8B6 6F                       o
        .byte   $6F                             ; B8B7 6F                       o
        asl     $69,x                           ; B8B8 16 69                    .i
        adc     #$69                            ; B8BA 69 69                    ii
        adc     #$69                            ; B8BC 69 69                    ii
        adc     #$69                            ; B8BE 69 69                    ii
        asl     $01,x                           ; B8C0 16 01                    ..
        asl     $01,x                           ; B8C2 16 01                    ..
        asl     $16,x                           ; B8C4 16 16                    ..
        asl     $67,x                           ; B8C6 16 67                    .g
        asl     $4E,x                           ; B8C8 16 4E                    .N
        asl     $4E,x                           ; B8CA 16 4E                    .N
        ora     $14                             ; B8CC 05 14                    ..
        asl     $67                             ; B8CE 06 67                    .g
        asl     $4C,x                           ; B8D0 16 4C                    .L
        asl     $4C,x                           ; B8D2 16 4C                    .L
        ora     $14                             ; B8D4 05 14                    ..
        asl     $67                             ; B8D6 06 67                    .g
        pla                                     ; B8D8 68                       h
        pla                                     ; B8D9 68                       h
        pla                                     ; B8DA 68                       h
        pla                                     ; B8DB 68                       h
        pla                                     ; B8DC 68                       h
        pla                                     ; B8DD 68                       h
        asl     $67,x                           ; B8DE 16 67                    .g
        adc     #$69                            ; B8E0 69 69                    ii
        adc     #$69                            ; B8E2 69 69                    ii
        adc     #$69                            ; B8E4 69 69                    ii
        adc     #$67                            ; B8E6 69 67                    ig
        jmp     (L6A70)                         ; B8E8 6C 70 6A                 lpj

; ----------------------------------------------------------------------------
        ror     a                               ; B8EB 6A                       j
        .byte   $6B                             ; B8EC 6B                       k
        jmp     (L676D)                         ; B8ED 6C 6D 67                 lmg

; ----------------------------------------------------------------------------
        .byte   $6F                             ; B8F0 6F                       o
        .byte   $6F                             ; B8F1 6F                       o
        .byte   $6F                             ; B8F2 6F                       o
        .byte   $6F                             ; B8F3 6F                       o
        ora     ($01,x)                         ; B8F4 01 01                    ..
        ora     ($01,x)                         ; B8F6 01 01                    ..
        adc     #$69                            ; B8F8 69 69                    ii
        adc     #$69                            ; B8FA 69 69                    ii
        asl     $16,x                           ; B8FC 16 16                    ..
        asl     $16,x                           ; B8FE 16 16                    ..
        .byte   $14                             ; B900 14                       .
        ora     $71,x                           ; B901 15 71                    .q
        adc     ($71),y                         ; B903 71 71                    qq
        adc     ($71),y                         ; B905 71 71                    qq
        .byte   $72                             ; B907 72                       r
        .byte   $14                             ; B908 14                       .
        ora     $61,x                           ; B909 15 61                    .a
        adc     ($61,x)                         ; B90B 61 61                    aa
        adc     ($61,x)                         ; B90D 61 61                    aa
        .byte   $73                             ; B90F 73                       s
        and     $6074,y                         ; B910 39 74 60                 9t`
        rts                                     ; B913 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; B914 60                       `

; ----------------------------------------------------------------------------
        adc     $75,x                           ; B915 75 75                    uu
        ror     $14,x                           ; B917 76 14                    v.
        asl     $75                             ; B919 06 75                    .u
        rts                                     ; B91B 60                       `

; ----------------------------------------------------------------------------
        adc     $75,x                           ; B91C 75 75                    uu
        adc     $76,x                           ; B91E 75 76                    uv
        .byte   $14                             ; B920 14                       .
        asl     $60                             ; B921 06 60                    .`
        adc     $75,x                           ; B923 75 75                    uu
        adc     $75,x                           ; B925 75 75                    uu
        ror     $77,x                           ; B927 76 77                    vw
        .byte   $77                             ; B929 77                       w
        adc     $65                             ; B92A 65 65                    ee
        adc     $65                             ; B92C 65 65                    ee
        adc     $78                             ; B92E 65 78                    ex
        asl     $4E                             ; B930 06 4E                    .N
        asl     $4E,x                           ; B932 16 4E                    .N
        ora     $14                             ; B934 05 14                    ..
        asl     $67                             ; B936 06 67                    .g
        asl     $4C,x                           ; B938 16 4C                    .L
        asl     $4C,x                           ; B93A 16 4C                    .L
        asl     $16,x                           ; B93C 16 16                    ..
        asl     $67,x                           ; B93E 16 67                    .g
        .byte   $14                             ; B940 14                       .
        .byte   $14                             ; B941 14                       .
        .byte   $14                             ; B942 14                       .
        .byte   $14                             ; B943 14                       .
        .byte   $14                             ; B944 14                       .
        .byte   $14                             ; B945 14                       .
        .byte   $14                             ; B946 14                       .
        .byte   $14                             ; B947 14                       .
        adc     $5E5E,y                         ; B948 79 5E 5E                 y^^
        lsr     $5E5E,x                         ; B94B 5E 5E 5E                 ^^^
        lsr     $7A5E,x                         ; B94E 5E 5E 7A                 ^^z
        rts                                     ; B951 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; B952 60                       `

; ----------------------------------------------------------------------------
        adc     $60,x                           ; B953 75 60                    u`
        rts                                     ; B955 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; B956 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; B957 60                       `

; ----------------------------------------------------------------------------
        .byte   $7A                             ; B958 7A                       z
        adc     $75,x                           ; B959 75 75                    uu
        rts                                     ; B95B 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; B95C 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; B95D 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; B95E 60                       `

; ----------------------------------------------------------------------------
        .byte   $7B                             ; B95F 7B                       {
        .byte   $7A                             ; B960 7A                       z
        rts                                     ; B961 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; B962 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; B963 60                       `

; ----------------------------------------------------------------------------
        .byte   $7B                             ; B964 7B                       {
        adc     $7C,x                           ; B965 75 7C                    u|
        adc     $607A,x                         ; B967 7D 7A 60                 }z`
        rts                                     ; B96A 60                       `

; ----------------------------------------------------------------------------
        ror     $607D,x                         ; B96B 7E 7D 60                 ~}`
        rts                                     ; B96E 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; B96F 60                       `

; ----------------------------------------------------------------------------
        .byte   $7F                             ; B970 7F                       .
        .byte   $80                             ; B971 80                       .
        adc     $65                             ; B972 65 65                    ee
        adc     $65                             ; B974 65 65                    ee
        adc     $65                             ; B976 65 65                    ee
        .byte   $14                             ; B978 14                       .
        ora     $14,x                           ; B979 15 14                    ..
        .byte   $14                             ; B97B 14                       .
        .byte   $14                             ; B97C 14                       .
        .byte   $14                             ; B97D 14                       .
        .byte   $14                             ; B97E 14                       .
        .byte   $14                             ; B97F 14                       .
        .byte   $14                             ; B980 14                       .
        .byte   $14                             ; B981 14                       .
        .byte   $14                             ; B982 14                       .
        .byte   $14                             ; B983 14                       .
        .byte   $14                             ; B984 14                       .
        .byte   $14                             ; B985 14                       .
        .byte   $14                             ; B986 14                       .
        .byte   $14                             ; B987 14                       .
        lsr     $5E5E,x                         ; B988 5E 5E 5E                 ^^^
        lsr     $5E5E,x                         ; B98B 5E 5E 5E                 ^^^
        lsr     $605E,x                         ; B98E 5E 5E 60                 ^^`
        rts                                     ; B991 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; B992 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; B993 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; B994 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; B995 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; B996 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; B997 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; B998 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; B999 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; B99A 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; B99B 60                       `

; ----------------------------------------------------------------------------
        sta     ($82,x)                         ; B99C 81 82                    ..
        .byte   $82                             ; B99E 82                       .
        .byte   $82                             ; B99F 82                       .
        adc     $7E,x                           ; B9A0 75 7E                    u~
        sta     ($75,x)                         ; B9A2 81 75                    .u
        rts                                     ; B9A4 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; B9A5 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; B9A6 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; B9A7 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; B9A8 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; B9A9 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; B9AA 60                       `

; ----------------------------------------------------------------------------
        adc     $7E,x                           ; B9AB 75 7E                    u~
        rts                                     ; B9AD 60                       `

; ----------------------------------------------------------------------------
        .byte   $83                             ; B9AE 83                       .
        sty     $65                             ; B9AF 84 65                    .e
        adc     $64                             ; B9B1 65 64                    ed
        .byte   $64                             ; B9B3 64                       d
        .byte   $64                             ; B9B4 64                       d
        sta     $64                             ; B9B5 85 64                    .d
        stx     $14                             ; B9B7 86 14                    ..
        asl     $69                             ; B9B9 06 69                    .i
        adc     #$69                            ; B9BB 69 69                    ii
        adc     #$69                            ; B9BD 69 69                    ii
        adc     #$14                            ; B9BF 69 14                    i.
        .byte   $14                             ; B9C1 14                       .
        .byte   $14                             ; B9C2 14                       .
        .byte   $14                             ; B9C3 14                       .
        .byte   $14                             ; B9C4 14                       .
        .byte   $14                             ; B9C5 14                       .
        .byte   $14                             ; B9C6 14                       .
        .byte   $14                             ; B9C7 14                       .
        lsr     $5E5E,x                         ; B9C8 5E 5E 5E                 ^^^
        .byte   $5E                             ; B9CB 5E                       ^
LB9CC:  .byte   $5E                             ; B9CC 5E                       ^
        .byte   $5E                             ; B9CD 5E                       ^
LB9CE:  .byte   $5E                             ; B9CE 5E                       ^
        .byte   $5E                             ; B9CF 5E                       ^
LB9D0:  rts                                     ; B9D0 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; B9D1 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; B9D2 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; B9D3 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; B9D4 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; B9D5 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; B9D6 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; B9D7 60                       `

; ----------------------------------------------------------------------------
        adc     $60,x                           ; B9D8 75 60                    u`
        rts                                     ; B9DA 60                       `

; ----------------------------------------------------------------------------
        .byte   $87                             ; B9DB 87                       .
        rts                                     ; B9DC 60                       `

; ----------------------------------------------------------------------------
        sta     ($75,x)                         ; B9DD 81 75                    .u
        rts                                     ; B9DF 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; B9E0 60                       `

; ----------------------------------------------------------------------------
        adc     $7E,x                           ; B9E1 75 7E                    u~
        rts                                     ; B9E3 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; B9E4 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; B9E5 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; B9E6 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; B9E7 60                       `

; ----------------------------------------------------------------------------
        .byte   $87                             ; B9E8 87                       .
        adc     $60,x                           ; B9E9 75 60                    u`
        rts                                     ; B9EB 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; B9EC 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; B9ED 60                       `

; ----------------------------------------------------------------------------
        adc     $82,x                           ; B9EE 75 82                    u.
        .byte   $64                             ; B9F0 64                       d
        .byte   $64                             ; B9F1 64                       d
        dey                                     ; B9F2 88                       .
        .byte   $89                             ; B9F3 89                       .
        .byte   $89                             ; B9F4 89                       .
        .byte   $89                             ; B9F5 89                       .
        dey                                     ; B9F6 88                       .
        .byte   $64                             ; B9F7 64                       d
        adc     #$69                            ; B9F8 69 69                    ii
        adc     #$69                            ; B9FA 69 69                    ii
        adc     #$69                            ; B9FC 69 69                    ii
        adc     #$69                            ; B9FE 69 69                    ii
        .byte   $14                             ; BA00 14                       .
        asl     $4E                             ; BA01 06 4E                    .N
        ora     $06                             ; BA03 05 06                    ..
        lsr     L6916                           ; BA05 4E 16 69                 N.i
        lsr     L4C16,x                         ; BA08 5E 16 4C                 ^.L
        ora     $06                             ; BA0B 05 06                    ..
        jmp     L6916                           ; BA0D 4C 16 69                 L.i

; ----------------------------------------------------------------------------
        rts                                     ; BA10 60                       `

; ----------------------------------------------------------------------------
        asl     $4E,x                           ; BA11 16 4E                    .N
        ora     $06                             ; BA13 05 06                    ..
        lsr     L6916                           ; BA15 4E 16 69                 N.i
        rts                                     ; BA18 60                       `

; ----------------------------------------------------------------------------
        asl     $4C,x                           ; BA19 16 4C                    .L
        ora     $06                             ; BA1B 05 06                    ..
        .byte   $4C                             ; BA1D 4C                       L
        .byte   $16                             ; BA1E 16                       .
LBA1F:  adc     #$60                            ; BA1F 69 60                    i`
        adc     ($61,x)                         ; BA21 61 61                    aa
        adc     ($63,x)                         ; BA23 61 63                    ac
        adc     #$69                            ; BA25 69 69                    ii
        adc     #$75                            ; BA27 69 75                    iu
        rts                                     ; BA29 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; BA2A 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; BA2B 60                       `

; ----------------------------------------------------------------------------
        txa                                     ; BA2C 8A                       .
        adc     #$69                            ; BA2D 69 69                    ii
        adc     #$64                            ; BA2F 69 64                    id
        .byte   $8B                             ; BA31 8B                       .
        sty     $8D8C                           ; BA32 8C 8C 8D                 ...
        stx     $8E8E                           ; BA35 8E 8E 8E                 ...
        adc     #$8F                            ; BA38 69 8F                    i.
        bcc     LB9CC                           ; BA3A 90 90                    ..
        bcc     LB9CE                           ; BA3C 90 90                    ..
        bcc     LB9D0                           ; BA3E 90 90                    ..
        sta     ($92),y                         ; BA40 91 92                    ..
        .byte   $93                             ; BA42 93                       .
        sty     $93,x                           ; BA43 94 93                    ..
        sta     $96,x                           ; BA45 95 96                    ..
        .byte   $93                             ; BA47 93                       .
        sta     $96,x                           ; BA48 95 96                    ..
        sty     $97,x                           ; BA4A 94 97                    ..
        tya                                     ; BA4C 98                       .
        sta     ($92),y                         ; BA4D 91 92                    ..
        .byte   $93                             ; BA4F 93                       .
        adc     #$69                            ; BA50 69 69                    ii
        .byte   $93                             ; BA52 93                       .
        sta     $959A,y                         ; BA53 99 9A 95                 ...
        stx     $93,y                           ; BA56 96 93                    ..
        adc     #$69                            ; BA58 69 69                    ii
        .byte   $9B                             ; BA5A 9B                       .
        adc     #$69                            ; BA5B 69 69                    ii
        adc     #$69                            ; BA5D 69 69                    ii
        sty     $69,x                           ; BA5F 94 69                    .i
        adc     #$69                            ; BA61 69 69                    ii
        adc     #$69                            ; BA63 69 69                    ii
        adc     #$69                            ; BA65 69 69                    ii
        .byte   $9C                             ; BA67 9C                       .
        adc     #$69                            ; BA68 69 69                    ii
        adc     #$69                            ; BA6A 69 69                    ii
        adc     #$69                            ; BA6C 69 69                    ii
        adc     #$69                            ; BA6E 69 69                    ii
        sta     $9F9E,x                         ; BA70 9D 9E 9F                 ...
        ldy     #$8E                            ; BA73 A0 8E                    ..
        sta     $9F9E,x                         ; BA75 9D 9E 9F                 ...
        lda     ($A2,x)                         ; BA78 A1 A2                    ..
        .byte   $A3                             ; BA7A A3                       .
        .byte   $8F                             ; BA7B 8F                       .
        bcc     LBA1F                           ; BA7C 90 A1                    ..
        ldx     #$A3                            ; BA7E A2 A3                    ..
        sta     $96,x                           ; BA80 95 96                    ..
        .byte   $93                             ; BA82 93                       .
        ldy     $A5                             ; BA83 A4 A5                    ..
        ldx     $95                             ; BA85 A6 95                    ..
        stx     $91,y                           ; BA87 96 91                    ..
        .byte   $92                             ; BA89 92                       .
        .byte   $93                             ; BA8A 93                       .
        .byte   $A7                             ; BA8B A7                       .
        tay                                     ; BA8C A8                       .
        lda     #$91                            ; BA8D A9 91                    ..
        .byte   $92                             ; BA8F 92                       .
        .byte   $97                             ; BA90 97                       .
        tya                                     ; BA91 98                       .
        .byte   $93                             ; BA92 93                       .
        tax                                     ; BA93 AA                       .
        lda     $AB                             ; BA94 A5 AB                    ..
        .byte   $97                             ; BA96 97                       .
        tya                                     ; BA97 98                       .
        ldy     $949A                           ; BA98 AC 9A 94                 ...
        lda     LAFAE                           ; BA9B AD AE AF                 ...
        sta     LB09A,y                         ; BA9E 99 9A B0                 ...
        adc     #$9C                            ; BAA1 69 9C                    i.
        lda     ($B2),y                         ; BAA3 B1 B2                    ..
        .byte   $B3                             ; BAA5 B3                       .
        adc     #$69                            ; BAA6 69 69                    ii
        adc     #$69                            ; BAA8 69 69                    ii
        adc     #$B4                            ; BAAA 69 B4                    i.
        lda     $B6,x                           ; BAAC B5 B6                    ..
        adc     #$69                            ; BAAE 69 69                    ii
        .byte   $B7                             ; BAB0 B7                       .
        .byte   $9E                             ; BAB1 9E                       .
        .byte   $9F                             ; BAB2 9F                       .
        clv                                     ; BAB3 B8                       .
        lda     LA0BA,y                         ; BAB4 B9 BA A0                 ...
        .byte   $BB                             ; BAB7 BB                       .
        ldy     LA3A2,x                         ; BAB8 BC A2 A3                 ...
        lda     LBFBE,x                         ; BABB BD BE BF                 ...
        .byte   $8F                             ; BABE 8F                       .
        cpy     #$C1                            ; BABF C0 C1                    ..
        cmp     ($93,x)                         ; BAC1 C1 93                    ..
        .byte   $93                             ; BAC3 93                       .
        .byte   $93                             ; BAC4 93                       .
        sta     $AB,x                           ; BAC5 95 AB                    ..
        .byte   $93                             ; BAC7 93                       .
        .byte   $93                             ; BAC8 93                       .
        .byte   $93                             ; BAC9 93                       .
        .byte   $9B                             ; BACA 9B                       .
        .byte   $9B                             ; BACB 9B                       .
        .byte   $93                             ; BACC 93                       .
        .byte   $A7                             ; BACD A7                       .
        lda     #$93                            ; BACE A9 93                    ..
        sta     $96,x                           ; BAD0 95 96                    ..
        adc     #$69                            ; BAD2 69 69                    ii
        .byte   $9B                             ; BAD4 9B                       .
        .byte   $C2                             ; BAD5 C2                       .
        .byte   $C3                             ; BAD6 C3                       .
        .byte   $9B                             ; BAD7 9B                       .
        sta     ($92),y                         ; BAD8 91 92                    ..
        adc     #$69                            ; BADA 69 69                    ii
        adc     #$C4                            ; BADC 69 C4                    i.
        cmp     $69                             ; BADE C5 69                    .i
        .byte   $97                             ; BAE0 97                       .
        tya                                     ; BAE1 98                       .
        adc     #$69                            ; BAE2 69 69                    ii
        adc     #$C6                            ; BAE4 69 C6                    i.
        .byte   $C7                             ; BAE6 C7                       .
        adc     #$99                            ; BAE7 69 99                    i.
        txs                                     ; BAE9 9A                       .
        adc     #$69                            ; BAEA 69 69                    ii
        adc     #$C8                            ; BAEC 69 C8                    i.
        cmp     #$69                            ; BAEE C9 69                    .i
        dex                                     ; BAF0 CA                       .
        dex                                     ; BAF1 CA                       .
        .byte   $CB                             ; BAF2 CB                       .
        .byte   $9E                             ; BAF3 9E                       .
        .byte   $9F                             ; BAF4 9F                       .
        clv                                     ; BAF5 B8                       .
        tsx                                     ; BAF6 BA                       .
        ldy     #$BE                            ; BAF7 A0 BE                    ..
        ldx     LA2CC,y                         ; BAF9 BE CC A2                 ...
        .byte   $A3                             ; BAFC A3                       .
        lda     $8FBF,x                         ; BAFD BD BF 8F                 ...
        sta     $96,x                           ; BB00 95 96                    ..
        sta     $96,x                           ; BB02 95 96                    ..
        .byte   $93                             ; BB04 93                       .
        sta     $96,x                           ; BB05 95 96                    ..
        .byte   $93                             ; BB07 93                       .
        sta     ($92),y                         ; BB08 91 92                    ..
        sta     ($92),y                         ; BB0A 91 92                    ..
        .byte   $93                             ; BB0C 93                       .
        sta     ($92),y                         ; BB0D 91 92                    ..
        .byte   $93                             ; BB0F 93                       .
        sta     $96,x                           ; BB10 95 96                    ..
        sta     $96,x                           ; BB12 95 96                    ..
        .byte   $93                             ; BB14 93                       .
        sta     $96,x                           ; BB15 95 96                    ..
        .byte   $93                             ; BB17 93                       .
        adc     #$C1                            ; BB18 69 C1                    i.
        adc     #$69                            ; BB1A 69 69                    ii
        .byte   $9B                             ; BB1C 9B                       .
        .byte   $A7                             ; BB1D A7                       .
        lda     #$93                            ; BB1E A9 93                    ..
LBB20:  adc     #$9B                            ; BB20 69 9B                    i.
        adc     #$69                            ; BB22 69 69                    ii
        adc     #$C6                            ; BB24 69 C6                    i.
        cmp     $699B                           ; BB26 CD 9B 69                 ..i
        dec     $6969                           ; BB29 CE 69 69                 .ii
        adc     #$C8                            ; BB2C 69 C8                    i.
        dec     LBBCE                           ; BB2E CE CE BB                 ...
        lda     $9ECB,y                         ; BB31 B9 CB 9E                 ...
        .byte   $9F                             ; BB34 9F                       .
        clv                                     ; BB35 B8                       .
        lda     $C0B9,y                         ; BB36 B9 B9 C0                 ...
        ldx     LA2CC,y                         ; BB39 BE CC A2                 ...
        .byte   $A3                             ; BB3C A3                       .
        lda     LBEBE,x                         ; BB3D BD BE BE                 ...
        sta     ($92),y                         ; BB40 91 92                    ..
        .byte   $93                             ; BB42 93                       .
        .byte   $93                             ; BB43 93                       .
        .byte   $93                             ; BB44 93                       .
        sta     $96,x                           ; BB45 95 96                    ..
        sty     $95,x                           ; BB47 94 95                    ..
        stx     $94,y                           ; BB49 96 94                    ..
LBB4B:  .byte   $93                             ; BB4B 93                       .
        .byte   $93                             ; BB4C 93                       .
LBB4D:  cmp     ($C1,x)                         ; BB4D C1 C1                    ..
LBB4F:  .byte   $93                             ; BB4F 93                       .
        .byte   $CF                             ; BB50 CF                       .
        cmp     ($D0,x)                         ; BB51 C1 D0                    ..
        sta     $96,x                           ; BB53 95 96                    ..
        sty     $95,x                           ; BB55 94 95                    ..
        stx     $93,y                           ; BB57 96 93                    ..
        .byte   $9B                             ; BB59 9B                       .
        ora     ($91,x)                         ; BB5A 01 91                    ..
        .byte   $92                             ; BB5C 92                       .
        .byte   $93                             ; BB5D 93                       .
        sta     ($92),y                         ; BB5E 91 92                    ..
        .byte   $9B                             ; BB60 9B                       .
        adc     #$D1                            ; BB61 69 D1                    i.
        sta     $96,x                           ; BB63 95 96                    ..
        .byte   $9B                             ; BB65 9B                       .
        sta     $96,x                           ; BB66 95 96                    ..
        dec     $6969                           ; BB68 CE 69 69                 .ii
        adc     #$69                            ; BB6B 69 69                    ii
        adc     #$69                            ; BB6D 69 69                    ii
        adc     #$B9                            ; BB6F 69 B9                    i.
        .byte   $CB                             ; BB71 CB                       .
        .byte   $D2                             ; BB72 D2                       .
        .byte   $D3                             ; BB73 D3                       .
        ldy     #$8E                            ; BB74 A0 8E                    ..
        sta     LBE9E,x                         ; BB76 9D 9E BE                 ...
        cpy     LBFBD                           ; BB79 CC BD BF                 ...
        .byte   $8F                             ; BB7C 8F                       .
        bcc     LBB20                           ; BB7D 90 A1                    ..
        ldx     #$16                            ; BB7F A2 16                    ..
        ora     ($16,x)                         ; BB81 01 16                    ..
        ora     ($16,x)                         ; BB83 01 16                    ..
        asl     $D4,x                           ; BB85 16 D4                    ..
        asl     L0002,x                         ; BB87 16 02                    ..
        .byte   $02                             ; BB89 02                       .
        .byte   $02                             ; BB8A 02                       .
        .byte   $04                             ; BB8B 04                       .
        .byte   $03                             ; BB8C 03                       .
        .byte   $04                             ; BB8D 04                       .
        cmp     $16,x                           ; BB8E D5 16                    ..
        .byte   $07                             ; BB90 07                       .
        and     #$07                            ; BB91 29 07                    ).
        ora     #$08                            ; BB93 09 08                    ..
        ora     #$D6                            ; BB95 09 D6                    ..
        ora     $12                             ; BB97 05 12                    ..
        .byte   $12                             ; BB99 12                       .
        .byte   $12                             ; BB9A 12                       .
        ora     ($1E),y                         ; BB9B 11 1E                    ..
        .byte   $5C                             ; BB9D 5C                       \
        asl     $05,x                           ; BB9E 16 05                    ..
        .byte   $07                             ; BBA0 07                       .
        .byte   $07                             ; BBA1 07                       .
        and     #$09                            ; BBA2 29 09                    ).
        .byte   $D7                             ; BBA4 D7                       .
        asl     $05,x                           ; BBA5 16 05                    ..
        .byte   $14                             ; BBA7 14                       .
        .byte   $12                             ; BBA8 12                       .
        .byte   $12                             ; BBA9 12                       .
        .byte   $12                             ; BBAA 12                       .
        .byte   $5C                             ; BBAB 5C                       \
        asl     $16,x                           ; BBAC 16 16                    ..
        ora     $14                             ; BBAE 05 14                    ..
        cld                                     ; BBB0 D8                       .
        cld                                     ; BBB1 D8                       .
        cld                                     ; BBB2 D8                       .
        cmp     $D9D9,y                         ; BBB3 D9 D9 D9                 ...
        cmp     $90D9,y                         ; BBB6 D9 D9 90                 ...
        bcc     LBB4B                           ; BBB9 90 90                    ..
        bcc     LBB4D                           ; BBBB 90 90                    ..
        bcc     LBB4F                           ; BBBD 90 90                    ..
        bcc     LBBC7                           ; BBBF 90 06                    ..
        .byte   $DA                             ; BBC1 DA                       .
        .byte   $DB                             ; BBC2 DB                       .
        .byte   $DC                             ; BBC3 DC                       .
        .byte   $DB                             ; BBC4 DB                       .
        .byte   $DB                             ; BBC5 DB                       .
        .byte   $DC                             ; BBC6 DC                       .
LBBC7:  asl     $06,x                           ; BBC7 16 06                    ..
        .byte   $54                             ; BBC9 54                       T
        and     #$09                            ; BBCA 29 09                    ).
        and     #$07                            ; BBCC 29 07                    ).
LBBCE:  ora     #$16                            ; BBCE 09 16                    ..
        ora     ($01,x)                         ; BBD0 01 01                    ..
        .byte   $12                             ; BBD2 12                       .
        ora     ($4B),y                         ; BBD3 11 4B                    .K
        ora     $1635,x                         ; BBD5 1D 35 16                 .5.
        .byte   $14                             ; BBD8 14                       .
        asl     $01                             ; BBD9 06 01                    ..
        ora     #$29                            ; BBDB 09 29                    .)
        .byte   $07                             ; BBDD 07                       .
        ora     #$16                            ; BBDE 09 16                    ..
        .byte   $14                             ; BBE0 14                       .
        asl     $16                             ; BBE1 06 16                    ..
        ora     (L000A,x)                       ; BBE3 01 0A                    ..
        .byte   $07                             ; BBE5 07                       .
        ora     #$16                            ; BBE6 09 16                    ..
        .byte   $14                             ; BBE8 14                       .
        .byte   $14                             ; BBE9 14                       .
        .byte   $14                             ; BBEA 14                       .
        asl     $01                             ; BBEB 06 01                    ..
        .byte   $12                             ; BBED 12                       .
        ora     ($16),y                         ; BBEE 11 16                    ..
        asl     $4E,x                           ; BBF0 16 4E                    .N
        asl     $4E,x                           ; BBF2 16 4E                    .N
        asl     $01,x                           ; BBF4 16 01                    ..
        cmp     $1616,x                         ; BBF6 DD 16 16                 ...
        jmp     L4C16                           ; BBF9 4C 16 4C                 L.L

; ----------------------------------------------------------------------------
        asl     $16,x                           ; BBFC 16 16                    ..
        .byte   $D4                             ; BBFE D4                       .
        asl     $14,x                           ; BBFF 16 14                    ..
        asl     $DE                             ; BC01 06 DE                    ..
        dec     $1405,x                         ; BC03 DE 05 14                 ...
        .byte   $14                             ; BC06 14                       .
        asl     $14                             ; BC07 06 14                    ..
        asl     $DE                             ; BC09 06 DE                    ..
        .byte   $DF                             ; BC0B DF                       .
        cpx     #$E0                            ; BC0C E0 E0                    ..
        sbc     ($05,x)                         ; BC0E E1 05                    ..
        .byte   $14                             ; BC10 14                       .
        asl     $E2                             ; BC11 06 E2                    ..
        sbc     ($E3,x)                         ; BC13 E1 E3                    ..
        .byte   $E3                             ; BC15 E3                       .
        .byte   $14                             ; BC16 14                       .
        .byte   $14                             ; BC17 14                       .
        .byte   $14                             ; BC18 14                       .
        .byte   $14                             ; BC19 14                       .
        cpx     L0000                           ; BC1A E4 00                    ..
        brk                                     ; BC1C 00                       .
        brk                                     ; BC1D 00                       .
        brk                                     ; BC1E 00                       .
        lsr     a                               ; BC1F 4A                       J
        cpx     #$E5                            ; BC20 E0 E5                    ..
        inc     $04                             ; BC22 E6 04                    ..
        .byte   $04                             ; BC24 04                       .
        .byte   $03                             ; BC25 03                       .
        .byte   $04                             ; BC26 04                       .
        .byte   $04                             ; BC27 04                       .
        .byte   $E7                             ; BC28 E7                       .
        and     #$29                            ; BC29 29 29                    ))
        ora     #$09                            ; BC2B 09 09                    ..
        php                                     ; BC2D 08                       .
        ora     #$09                            ; BC2E 09 09                    ..
        ora     ($66,x)                         ; BC30 01 66                    .f
        ora     ($E8,x)                         ; BC32 01 E8                    ..
        ora     ($01,x)                         ; BC34 01 01                    ..
        inx                                     ; BC36 E8                       .
        ora     ($06,x)                         ; BC37 01 06                    ..
        .byte   $67                             ; BC39 67                       g
        asl     $01,x                           ; BC3A 16 01                    ..
        asl     $16,x                           ; BC3C 16 16                    ..
        ora     ($16,x)                         ; BC3E 01 16                    ..
        dec     $DEE9,x                         ; BC40 DE E9 DE                 ...
        sbc     #$DE                            ; BC43 E9 DE                    ..
        dec     $48DE,x                         ; BC45 DE DE 48                 ..H
        .byte   $E3                             ; BC48 E3                       .
        .byte   $E3                             ; BC49 E3                       .
        .byte   $E3                             ; BC4A E3                       .
        .byte   $E3                             ; BC4B E3                       .
        .byte   $E3                             ; BC4C E3                       .
        .byte   $E3                             ; BC4D E3                       .
        .byte   $E3                             ; BC4E E3                       .
        nop                                     ; BC4F EA                       .
        brk                                     ; BC50 00                       .
        brk                                     ; BC51 00                       .
        brk                                     ; BC52 00                       .
        brk                                     ; BC53 00                       .
        brk                                     ; BC54 00                       .
        brk                                     ; BC55 00                       .
        brk                                     ; BC56 00                       .
        pha                                     ; BC57 48                       H
        .byte   $04                             ; BC58 04                       .
        .byte   $02                             ; BC59 02                       .
        .byte   $02                             ; BC5A 02                       .
        .byte   $04                             ; BC5B 04                       .
        .byte   $02                             ; BC5C 02                       .
        .byte   $04                             ; BC5D 04                       .
        .byte   $03                             ; BC5E 03                       .
        ora     $11                             ; BC5F 05 11                    ..
        .byte   $12                             ; BC61 12                       .
        .byte   $12                             ; BC62 12                       .
        ora     ($12),y                         ; BC63 11 12                    ..
        ora     ($24),y                         ; BC65 11 24                    .$
        .byte   $EB                             ; BC67 EB                       .
        ora     #$01                            ; BC68 09 01                    ..
        ora     ($EC,x)                         ; BC6A 01 EC                    ..
        cpx     $1E01                           ; BC6C EC 01 1E                 ...
        sbc     $E101                           ; BC6F ED 01 E1                 ...
        asl     $EE,x                           ; BC72 16 EE                    ..
        inc     $0116                           ; BC74 EE 16 01                 ...
        ora     ($06,x)                         ; BC77 01 06                    ..
        asl     $16,x                           ; BC79 16 16                    ..
        inc     $16EE                           ; BC7B EE EE 16                 ...
        ora     $14                             ; BC7E 05 14                    ..
        asl     $4E,x                           ; BC80 16 4E                    .N
        asl     $4E,x                           ; BC82 16 4E                    .N
        asl     $4E,x                           ; BC84 16 4E                    .N
        ora     $06                             ; BC86 05 06                    ..
        asl     $4C,x                           ; BC88 16 4C                    .L
        asl     $4C,x                           ; BC8A 16 4C                    .L
        asl     $4C,x                           ; BC8C 16 4C                    .L
        ora     $06                             ; BC8E 05 06                    ..
        asl     $4E,x                           ; BC90 16 4E                    .N
        asl     $4E,x                           ; BC92 16 4E                    .N
        asl     $4E,x                           ; BC94 16 4E                    .N
        ora     $06                             ; BC96 05 06                    ..
        asl     $4C                             ; BC98 06 4C                    .L
        asl     $4C,x                           ; BC9A 16 4C                    .L
        asl     $4C,x                           ; BC9C 16 4C                    .L
        ora     $06                             ; BC9E 05 06                    ..
        .byte   $EF                             ; BCA0 EF                       .
        .byte   $E5                             ; BCA1 E5                       .
LBCA2:  .byte   $EF                             ; BCA2 EF                       .
        .byte   $E5                             ; BCA3 E5                       .
LBCA4:  .byte   $EF                             ; BCA4 EF                       .
        .byte   $E5                             ; BCA5 E5                       .
LBCA6:  .byte   $EF                             ; BCA6 EF                       .
        .byte   $EB                             ; BCA7 EB                       .
LBCA8:  and     $4B,x                           ; BCA8 35 4B                    5K
        and     $4B,x                           ; BCAA 35 4B                    5K
        and     $4B,x                           ; BCAC 35 4B                    5K
        and     $ED,x                           ; BCAE 35 ED                    5.
        beq     LBCA2                           ; BCB0 F0 F0                    ..
        beq     LBCA4                           ; BCB2 F0 F0                    ..
        beq     LBCA6                           ; BCB4 F0 F0                    ..
        beq     LBCA8                           ; BCB6 F0 F0                    ..
        sbc     ($F1),y                         ; BCB8 F1 F1                    ..
        sbc     ($F1),y                         ; BCBA F1 F1                    ..
        sbc     ($F1),y                         ; BCBC F1 F1                    ..
        sbc     ($F1),y                         ; BCBE F1 F1                    ..
        adc     #$69                            ; BCC0 69 69                    ii
        adc     #$69                            ; BCC2 69 69                    ii
        adc     #$69                            ; BCC4 69 69                    ii
        adc     #$69                            ; BCC6 69 69                    ii
        adc     #$69                            ; BCC8 69 69                    ii
        adc     #$69                            ; BCCA 69 69                    ii
        adc     #$69                            ; BCCC 69 69                    ii
        adc     #$69                            ; BCCE 69 69                    ii
        adc     #$69                            ; BCD0 69 69                    ii
        adc     #$69                            ; BCD2 69 69                    ii
        adc     #$69                            ; BCD4 69 69                    ii
        adc     #$69                            ; BCD6 69 69                    ii
        adc     #$69                            ; BCD8 69 69                    ii
        adc     #$69                            ; BCDA 69 69                    ii
        adc     #$69                            ; BCDC 69 69                    ii
        adc     #$69                            ; BCDE 69 69                    ii
        adc     #$69                            ; BCE0 69 69                    ii
LBCE2:  adc     #$69                            ; BCE2 69 69                    ii
LBCE4:  adc     #$69                            ; BCE4 69 69                    ii
LBCE6:  adc     #$69                            ; BCE6 69 69                    ii
LBCE8:  adc     #$69                            ; BCE8 69 69                    ii
        adc     #$69                            ; BCEA 69 69                    ii
        adc     #$69                            ; BCEC 69 69                    ii
        adc     #$69                            ; BCEE 69 69                    ii
        beq     LBCE2                           ; BCF0 F0 F0                    ..
        beq     LBCE4                           ; BCF2 F0 F0                    ..
        beq     LBCE6                           ; BCF4 F0 F0                    ..
        beq     LBCE8                           ; BCF6 F0 F0                    ..
        sbc     ($F1),y                         ; BCF8 F1 F1                    ..
        sbc     ($F1),y                         ; BCFA F1 F1                    ..
        sbc     ($F1),y                         ; BCFC F1 F1                    ..
        sbc     ($F1),y                         ; BCFE F1 F1                    ..
        adc     #$69                            ; BD00 69 69                    ii
        adc     #$69                            ; BD02 69 69                    ii
        adc     #$69                            ; BD04 69 69                    ii
        adc     #$69                            ; BD06 69 69                    ii
        adc     #$69                            ; BD08 69 69                    ii
        adc     #$69                            ; BD0A 69 69                    ii
        adc     #$69                            ; BD0C 69 69                    ii
        adc     #$69                            ; BD0E 69 69                    ii
        adc     #$69                            ; BD10 69 69                    ii
        adc     #$69                            ; BD12 69 69                    ii
        adc     #$69                            ; BD14 69 69                    ii
        adc     #$69                            ; BD16 69 69                    ii
        adc     #$69                            ; BD18 69 69                    ii
        adc     #$69                            ; BD1A 69 69                    ii
        adc     #$69                            ; BD1C 69 69                    ii
        adc     #$69                            ; BD1E 69 69                    ii
        adc     #$69                            ; BD20 69 69                    ii
        adc     #$69                            ; BD22 69 69                    ii
        adc     #$69                            ; BD24 69 69                    ii
        adc     #$69                            ; BD26 69 69                    ii
        adc     #$69                            ; BD28 69 69                    ii
        adc     #$69                            ; BD2A 69 69                    ii
        adc     #$69                            ; BD2C 69 69                    ii
        adc     #$69                            ; BD2E 69 69                    ii
        .byte   $97                             ; BD30 97                       .
        tya                                     ; BD31 98                       .
        sty     $93,x                           ; BD32 94 93                    ..
        .byte   $93                             ; BD34 93                       .
        asl     $16,x                           ; BD35 16 16                    ..
        .byte   $93                             ; BD37 93                       .
        sta     $F29A,y                         ; BD38 99 9A F2                 ...
        .byte   $F3                             ; BD3B F3                       .
        .byte   $93                             ; BD3C 93                       .
        asl     $16,x                           ; BD3D 16 16                    ..
        .byte   $93                             ; BD3F 93                       .
        adc     #$69                            ; BD40 69 69                    ii
        adc     #$69                            ; BD42 69 69                    ii
        adc     #$69                            ; BD44 69 69                    ii
        adc     #$69                            ; BD46 69 69                    ii
        adc     #$69                            ; BD48 69 69                    ii
        adc     #$69                            ; BD4A 69 69                    ii
        adc     #$69                            ; BD4C 69 69                    ii
        .byte   $F4                             ; BD4E F4                       .
        adc     #$69                            ; BD4F 69 69                    ii
        adc     #$69                            ; BD51 69 69                    ii
        adc     #$69                            ; BD53 69 69                    ii
        adc     #$F5                            ; BD55 69 F5                    i.
        inc     $69,x                           ; BD57 F6 69                    .i
        adc     #$69                            ; BD59 69 69                    ii
        adc     #$69                            ; BD5B 69 69                    ii
        .byte   $F7                             ; BD5D F7                       .
        sed                                     ; BD5E F8                       .
        sbc     $6969,y                         ; BD5F F9 69 69                 .ii
LBD62:  adc     #$69                            ; BD62 69 69                    ii
LBD64:  adc     #$FA                            ; BD64 69 FA                    i.
LBD66:  .byte   $FB                             ; BD66 FB                       .
        .byte   $FC                             ; BD67 FC                       .
LBD68:  adc     #$69                            ; BD68 69 69                    ii
        adc     #$69                            ; BD6A 69 69                    ii
        adc     #$FA                            ; BD6C 69 FA                    i.
        .byte   $FB                             ; BD6E FB                       .
        .byte   $FC                             ; BD6F FC                       .
        beq     LBD62                           ; BD70 F0 F0                    ..
        beq     LBD64                           ; BD72 F0 F0                    ..
        beq     LBD66                           ; BD74 F0 F0                    ..
        beq     LBD68                           ; BD76 F0 F0                    ..
        sbc     ($F1),y                         ; BD78 F1 F1                    ..
        sbc     ($F1),y                         ; BD7A F1 F1                    ..
        sbc     ($F1),y                         ; BD7C F1 F1                    ..
        sbc     ($F1),y                         ; BD7E F1 F1                    ..
        adc     #$69                            ; BD80 69 69                    ii
        adc     #$69                            ; BD82 69 69                    ii
        adc     #$69                            ; BD84 69 69                    ii
        adc     #$69                            ; BD86 69 69                    ii
        adc     #$69                            ; BD88 69 69                    ii
        adc     #$69                            ; BD8A 69 69                    ii
        adc     #$69                            ; BD8C 69 69                    ii
        adc     #$69                            ; BD8E 69 69                    ii
        adc     #$69                            ; BD90 69 69                    ii
        adc     #$69                            ; BD92 69 69                    ii
        adc     #$69                            ; BD94 69 69                    ii
        adc     #$69                            ; BD96 69 69                    ii
        adc     #$69                            ; BD98 69 69                    ii
        adc     #$69                            ; BD9A 69 69                    ii
        adc     #$69                            ; BD9C 69 69                    ii
        adc     #$69                            ; BD9E 69 69                    ii
        adc     #$69                            ; BDA0 69 69                    ii
        adc     #$69                            ; BDA2 69 69                    ii
        adc     #$69                            ; BDA4 69 69                    ii
        adc     #$69                            ; BDA6 69 69                    ii
        adc     #$69                            ; BDA8 69 69                    ii
        adc     #$69                            ; BDAA 69 69                    ii
        .byte   $69                             ; BDAC 69                       i
LBDAD:  adc     #$69                            ; BDAD 69 69                    ii
        adc     #$69                            ; BDAF 69 69                    ii
        adc     #$69                            ; BDB1 69 69                    ii
        adc     #$69                            ; BDB3 69 69                    ii
        adc     #$69                            ; BDB5 69 69                    ii
        adc     #$69                            ; BDB7 69 69                    ii
        adc     #$69                            ; BDB9 69 69                    ii
LBDBB:  adc     #$69                            ; BDBB 69 69                    ii
        adc     #$69                            ; BDBD 69 69                    ii
        adc     #$69                            ; BDBF 69 69                    ii
        adc     #$69                            ; BDC1 69 69                    ii
        adc     #$69                            ; BDC3 69 69                    ii
        adc     #$69                            ; BDC5 69 69                    ii
        adc     #$69                            ; BDC7 69 69                    ii
        adc     #$69                            ; BDC9 69 69                    ii
        adc     #$69                            ; BDCB 69 69                    ii
        adc     #$69                            ; BDCD 69 69                    ii
        adc     #$69                            ; BDCF 69 69                    ii
        adc     #$69                            ; BDD1 69 69                    ii
        adc     #$69                            ; BDD3 69 69                    ii
        adc     #$69                            ; BDD5 69 69                    ii
        adc     #$69                            ; BDD7 69 69                    ii
        adc     #$69                            ; BDD9 69 69                    ii
        adc     #$69                            ; BDDB 69 69                    ii
        adc     #$69                            ; BDDD 69 69                    ii
        adc     #$69                            ; BDDF 69 69                    ii
        adc     #$69                            ; BDE1 69 69                    ii
        adc     #$69                            ; BDE3 69 69                    ii
        adc     #$69                            ; BDE5 69 69                    ii
        adc     #$69                            ; BDE7 69 69                    ii
        adc     #$69                            ; BDE9 69 69                    ii
        adc     #$69                            ; BDEB 69 69                    ii
        adc     #$69                            ; BDED 69 69                    ii
        adc     #$69                            ; BDEF 69 69                    ii
        adc     #$69                            ; BDF1 69 69                    ii
        adc     #$69                            ; BDF3 69 69                    ii
        adc     #$69                            ; BDF5 69 69                    ii
        adc     #$69                            ; BDF7 69 69                    ii
        adc     #$69                            ; BDF9 69 69                    ii
        adc     #$69                            ; BDFB 69 69                    ii
        adc     #$69                            ; BDFD 69 69                    ii
        adc     #$00                            ; BDFF 69 00                    i.
        brk                                     ; BE01 00                       .
        brk                                     ; BE02 00                       .
        ora     (L0000,x)                       ; BE03 01 00                    ..
        brk                                     ; BE05 00                       .
        brk                                     ; BE06 00                       .
        brk                                     ; BE07 00                       .
        ora     (L0002,x)                       ; BE08 01 02                    ..
        .byte   $02                             ; BE0A 02                       .
        .byte   $03                             ; BE0B 03                       .
        .byte   $04                             ; BE0C 04                       .
        .byte   $02                             ; BE0D 02                       .
        .byte   $04                             ; BE0E 04                       .
        ora     $06                             ; BE0F 05 06                    ..
        .byte   $07                             ; BE11 07                       .
        .byte   $07                             ; BE12 07                       .
        php                                     ; BE13 08                       .
        ora     #$07                            ; BE14 09 07                    ..
        ora     #$05                            ; BE16 09 05                    ..
        asl     L000A                           ; BE18 06 0A                    ..
        asl     a                               ; BE1A 0A                       .
        php                                     ; BE1B 08                       .
        ora     #$07                            ; BE1C 09 07                    ..
        ora     #$05                            ; BE1E 09 05                    ..
        .byte   $0B                             ; BE20 0B                       .
        .byte   $0C                             ; BE21 0C                       .
        .byte   $0C                             ; BE22 0C                       .
        ora     $0F0E                           ; BE23 0D 0E 0F                 ...
        ora     ($01,x)                         ; BE26 01 01                    ..
        asl     L0002                           ; BE28 06 02                    ..
        .byte   $02                             ; BE2A 02                       .
        bpl     LBE3E                           ; BE2B 10 11                    ..
        .byte   $12                             ; BE2D 12                       .
        .byte   $04                             ; BE2E 04                       .
        ora     $01                             ; BE2F 05 01                    ..
        ora     ($01,x)                         ; BE31 01 01                    ..
        ora     ($01,x)                         ; BE33 01 01                    ..
        ora     ($13,x)                         ; BE35 01 13                    ..
        ora     $14                             ; BE37 05 14                    ..
        .byte   $14                             ; BE39 14                       .
        .byte   $14                             ; BE3A 14                       .
        .byte   $14                             ; BE3B 14                       .
        .byte   $14                             ; BE3C 14                       .
        .byte   $14                             ; BE3D 14                       .
LBE3E:  ora     $16,x                           ; BE3E 15 16                    ..
        adc     #$69                            ; BE40 69 69                    ii
        adc     #$69                            ; BE42 69 69                    ii
        adc     #$69                            ; BE44 69 69                    ii
        adc     #$69                            ; BE46 69 69                    ii
        adc     #$69                            ; BE48 69 69                    ii
        adc     #$69                            ; BE4A 69 69                    ii
        adc     #$69                            ; BE4C 69 69                    ii
        adc     #$69                            ; BE4E 69 69                    ii
        adc     #$69                            ; BE50 69 69                    ii
        adc     #$69                            ; BE52 69 69                    ii
        adc     #$69                            ; BE54 69 69                    ii
        adc     #$69                            ; BE56 69 69                    ii
        adc     #$69                            ; BE58 69 69                    ii
        adc     #$69                            ; BE5A 69 69                    ii
        adc     #$69                            ; BE5C 69 69                    ii
        adc     #$69                            ; BE5E 69 69                    ii
        adc     #$69                            ; BE60 69 69                    ii
        adc     #$69                            ; BE62 69 69                    ii
        adc     #$69                            ; BE64 69 69                    ii
        adc     #$69                            ; BE66 69 69                    ii
        adc     #$69                            ; BE68 69 69                    ii
        adc     #$69                            ; BE6A 69 69                    ii
        adc     #$69                            ; BE6C 69 69                    ii
        adc     #$69                            ; BE6E 69 69                    ii
        adc     #$69                            ; BE70 69 69                    ii
        adc     #$69                            ; BE72 69 69                    ii
        adc     #$69                            ; BE74 69 69                    ii
        adc     #$69                            ; BE76 69 69                    ii
        adc     #$69                            ; BE78 69 69                    ii
        adc     #$69                            ; BE7A 69 69                    ii
        adc     #$69                            ; BE7C 69 69                    ii
        adc     #$69                            ; BE7E 69 69                    ii
        adc     #$69                            ; BE80 69 69                    ii
        adc     #$69                            ; BE82 69 69                    ii
        adc     #$69                            ; BE84 69 69                    ii
        adc     #$69                            ; BE86 69 69                    ii
        adc     #$69                            ; BE88 69 69                    ii
        adc     #$69                            ; BE8A 69 69                    ii
        adc     #$69                            ; BE8C 69 69                    ii
        adc     #$69                            ; BE8E 69 69                    ii
        adc     #$69                            ; BE90 69 69                    ii
        adc     #$69                            ; BE92 69 69                    ii
        adc     #$69                            ; BE94 69 69                    ii
        adc     #$69                            ; BE96 69 69                    ii
        adc     #$69                            ; BE98 69 69                    ii
        adc     #$69                            ; BE9A 69 69                    ii
        adc     #$69                            ; BE9C 69 69                    ii
LBE9E:  adc     #$69                            ; BE9E 69 69                    ii
        adc     #$69                            ; BEA0 69 69                    ii
        adc     #$69                            ; BEA2 69 69                    ii
        adc     #$69                            ; BEA4 69 69                    ii
        adc     #$69                            ; BEA6 69 69                    ii
        adc     #$69                            ; BEA8 69 69                    ii
        adc     #$69                            ; BEAA 69 69                    ii
        adc     #$69                            ; BEAC 69 69                    ii
        adc     #$69                            ; BEAE 69 69                    ii
        adc     #$69                            ; BEB0 69 69                    ii
        adc     #$69                            ; BEB2 69 69                    ii
        adc     #$69                            ; BEB4 69 69                    ii
        adc     #$69                            ; BEB6 69 69                    ii
        adc     #$69                            ; BEB8 69 69                    ii
        adc     #$69                            ; BEBA 69 69                    ii
        adc     #$69                            ; BEBC 69 69                    ii
LBEBE:  adc     #$69                            ; BEBE 69 69                    ii
        adc     #$69                            ; BEC0 69 69                    ii
        adc     #$69                            ; BEC2 69 69                    ii
        adc     #$69                            ; BEC4 69 69                    ii
        adc     #$69                            ; BEC6 69 69                    ii
        adc     #$69                            ; BEC8 69 69                    ii
        adc     #$69                            ; BECA 69 69                    ii
        adc     #$69                            ; BECC 69 69                    ii
        adc     #$69                            ; BECE 69 69                    ii
        adc     #$69                            ; BED0 69 69                    ii
        adc     #$69                            ; BED2 69 69                    ii
        adc     #$69                            ; BED4 69 69                    ii
        adc     #$69                            ; BED6 69 69                    ii
        adc     #$69                            ; BED8 69 69                    ii
        adc     #$69                            ; BEDA 69 69                    ii
        adc     #$69                            ; BEDC 69 69                    ii
        adc     #$69                            ; BEDE 69 69                    ii
        adc     #$69                            ; BEE0 69 69                    ii
        adc     #$69                            ; BEE2 69 69                    ii
        adc     #$69                            ; BEE4 69 69                    ii
        adc     #$69                            ; BEE6 69 69                    ii
        adc     #$69                            ; BEE8 69 69                    ii
        adc     #$69                            ; BEEA 69 69                    ii
        adc     #$69                            ; BEEC 69 69                    ii
        adc     #$69                            ; BEEE 69 69                    ii
        adc     #$69                            ; BEF0 69 69                    ii
        adc     #$69                            ; BEF2 69 69                    ii
        adc     #$69                            ; BEF4 69 69                    ii
        adc     #$69                            ; BEF6 69 69                    ii
        adc     #$69                            ; BEF8 69 69                    ii
        adc     #$69                            ; BEFA 69 69                    ii
        adc     #$69                            ; BEFC 69 69                    ii
        adc     #$69                            ; BEFE 69 69                    ii
        adc     #$69                            ; BF00 69 69                    ii
        adc     #$69                            ; BF02 69 69                    ii
        adc     #$69                            ; BF04 69 69                    ii
        adc     #$69                            ; BF06 69 69                    ii
        adc     #$69                            ; BF08 69 69                    ii
        adc     #$69                            ; BF0A 69 69                    ii
        adc     #$69                            ; BF0C 69 69                    ii
        adc     #$69                            ; BF0E 69 69                    ii
        adc     #$69                            ; BF10 69 69                    ii
        adc     #$69                            ; BF12 69 69                    ii
        adc     #$69                            ; BF14 69 69                    ii
        adc     #$69                            ; BF16 69 69                    ii
        adc     #$69                            ; BF18 69 69                    ii
        adc     #$69                            ; BF1A 69 69                    ii
        adc     #$69                            ; BF1C 69 69                    ii
        adc     #$69                            ; BF1E 69 69                    ii
        adc     #$69                            ; BF20 69 69                    ii
        adc     #$69                            ; BF22 69 69                    ii
        adc     #$69                            ; BF24 69 69                    ii
        adc     #$69                            ; BF26 69 69                    ii
        adc     #$69                            ; BF28 69 69                    ii
        adc     #$69                            ; BF2A 69 69                    ii
        adc     #$69                            ; BF2C 69 69                    ii
        adc     #$69                            ; BF2E 69 69                    ii
        adc     #$69                            ; BF30 69 69                    ii
        adc     #$69                            ; BF32 69 69                    ii
        adc     #$69                            ; BF34 69 69                    ii
        adc     #$69                            ; BF36 69 69                    ii
        adc     #$69                            ; BF38 69 69                    ii
        adc     #$69                            ; BF3A 69 69                    ii
        adc     #$69                            ; BF3C 69 69                    ii
        adc     #$69                            ; BF3E 69 69                    ii
        adc     #$69                            ; BF40 69 69                    ii
        adc     #$69                            ; BF42 69 69                    ii
        adc     #$69                            ; BF44 69 69                    ii
        adc     #$69                            ; BF46 69 69                    ii
        adc     #$69                            ; BF48 69 69                    ii
        adc     #$69                            ; BF4A 69 69                    ii
        adc     #$69                            ; BF4C 69 69                    ii
        adc     #$69                            ; BF4E 69 69                    ii
        adc     #$69                            ; BF50 69 69                    ii
        adc     #$69                            ; BF52 69 69                    ii
        adc     #$69                            ; BF54 69 69                    ii
        adc     #$69                            ; BF56 69 69                    ii
        adc     #$69                            ; BF58 69 69                    ii
        adc     #$69                            ; BF5A 69 69                    ii
        adc     #$69                            ; BF5C 69 69                    ii
        adc     #$69                            ; BF5E 69 69                    ii
        adc     #$69                            ; BF60 69 69                    ii
        adc     #$69                            ; BF62 69 69                    ii
        adc     #$69                            ; BF64 69 69                    ii
        adc     #$69                            ; BF66 69 69                    ii
        adc     #$69                            ; BF68 69 69                    ii
        adc     #$69                            ; BF6A 69 69                    ii
        adc     #$69                            ; BF6C 69 69                    ii
        adc     #$69                            ; BF6E 69 69                    ii
        adc     #$69                            ; BF70 69 69                    ii
        adc     #$69                            ; BF72 69 69                    ii
        adc     #$69                            ; BF74 69 69                    ii
        adc     #$69                            ; BF76 69 69                    ii
        adc     #$69                            ; BF78 69 69                    ii
        adc     #$69                            ; BF7A 69 69                    ii
        adc     #$69                            ; BF7C 69 69                    ii
        adc     #$69                            ; BF7E 69 69                    ii
        adc     #$69                            ; BF80 69 69                    ii
        adc     #$69                            ; BF82 69 69                    ii
        adc     #$69                            ; BF84 69 69                    ii
        adc     #$69                            ; BF86 69 69                    ii
        adc     #$69                            ; BF88 69 69                    ii
        adc     #$69                            ; BF8A 69 69                    ii
        adc     #$69                            ; BF8C 69 69                    ii
        adc     #$69                            ; BF8E 69 69                    ii
        adc     #$69                            ; BF90 69 69                    ii
        adc     #$69                            ; BF92 69 69                    ii
        adc     #$69                            ; BF94 69 69                    ii
        adc     #$69                            ; BF96 69 69                    ii
        adc     #$69                            ; BF98 69 69                    ii
        adc     #$69                            ; BF9A 69 69                    ii
        adc     #$69                            ; BF9C 69 69                    ii
        adc     #$69                            ; BF9E 69 69                    ii
        adc     #$69                            ; BFA0 69 69                    ii
        adc     #$69                            ; BFA2 69 69                    ii
        adc     #$69                            ; BFA4 69 69                    ii
        adc     #$69                            ; BFA6 69 69                    ii
        adc     #$69                            ; BFA8 69 69                    ii
        adc     #$69                            ; BFAA 69 69                    ii
        adc     #$69                            ; BFAC 69 69                    ii
        adc     #$69                            ; BFAE 69 69                    ii
        adc     #$69                            ; BFB0 69 69                    ii
        adc     #$69                            ; BFB2 69 69                    ii
        adc     #$69                            ; BFB4 69 69                    ii
        adc     #$69                            ; BFB6 69 69                    ii
        adc     #$69                            ; BFB8 69 69                    ii
        adc     #$69                            ; BFBA 69 69                    ii
        .byte   $69                             ; BFBC 69                       i
LBFBD:  .byte   $69                             ; BFBD 69                       i
LBFBE:  adc     #$69                            ; BFBE 69 69                    ii
        adc     #$69                            ; BFC0 69 69                    ii
        adc     #$69                            ; BFC2 69 69                    ii
        adc     #$69                            ; BFC4 69 69                    ii
        adc     #$69                            ; BFC6 69 69                    ii
        adc     #$69                            ; BFC8 69 69                    ii
        adc     #$69                            ; BFCA 69 69                    ii
        adc     #$69                            ; BFCC 69 69                    ii
        adc     #$69                            ; BFCE 69 69                    ii
        adc     #$69                            ; BFD0 69 69                    ii
        adc     #$69                            ; BFD2 69 69                    ii
        adc     #$69                            ; BFD4 69 69                    ii
        adc     #$69                            ; BFD6 69 69                    ii
        adc     #$69                            ; BFD8 69 69                    ii
        adc     #$69                            ; BFDA 69 69                    ii
        adc     #$69                            ; BFDC 69 69                    ii
        adc     #$69                            ; BFDE 69 69                    ii
        adc     #$69                            ; BFE0 69 69                    ii
        adc     #$69                            ; BFE2 69 69                    ii
        adc     #$69                            ; BFE4 69 69                    ii
        adc     #$69                            ; BFE6 69 69                    ii
        adc     #$69                            ; BFE8 69 69                    ii
        adc     #$69                            ; BFEA 69 69                    ii
        adc     #$69                            ; BFEC 69 69                    ii
        adc     #$69                            ; BFEE 69 69                    ii
        adc     #$69                            ; BFF0 69 69                    ii
        adc     #$69                            ; BFF2 69 69                    ii
        adc     #$69                            ; BFF4 69 69                    ii
        adc     #$69                            ; BFF6 69 69                    ii
        adc     #$69                            ; BFF8 69 69                    ii
        adc     #$69                            ; BFFA 69 69                    ii
        adc     #$69                            ; BFFC 69 69                    ii
        adc     #$69                            ; BFFE 69 69                    ii
