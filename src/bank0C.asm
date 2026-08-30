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
; --- LA364: draw intro screen A ($23) via redraw_screen_banksafe ($27=$0B while drawing)
; and fall through to load palette record A.
LA364:  sta     $23                             ; A364 85 23                    .#
        lda     #$0B                            ; A366 A9 0B                    ..
        sta     $27                             ; A368 85 27                    .'
        lda     #$08                            ; A36A A9 08                    ..
        sta     $10                             ; A36C 85 10                    ..
        jsr     redraw_screen_banksafe                           ; A36E 20 FC DA                  ..
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
LA3FB:  .byte   $D4                             ; A3FB
LA3FC:  .byte   $D6                             ; A3FC
LA3FD:  .byte   $0F,$27,$2B,$1A,$0F,$20,$21,$11,$0F,$20,$14,$16,$0F,$00,$00,$00 ; A3FD
        .byte   $D4,$D6,$0F,$20,$2A,$19,$0F,$20,$22,$13,$0F,$00,$00,$00,$0F,$00 ; A40D
        .byte   $00,$00,$E0,$E2,$0F,$21,$12,$03,$0F,$11,$0F,$01,$0F,$21,$12,$01 ; A41D
        .byte   $0F,$12,$03,$01,$AC,$AE,$0F,$21,$11,$01,$0F,$11,$29,$19,$0F,$20 ; A42D
        .byte   $11,$01,$0F,$20,$21,$11,$E0,$E2,$30,$30,$30,$30,$30,$30,$30,$30 ; A43D
        .byte   $30,$30,$30,$30,$30,$30,$30,$30,$C4,$C6,$0F,$11,$21,$16,$0F,$30 ; A44D
        .byte   $21,$16,$0F,$26,$28,$16,$0F,$17,$27,$06 ; A45D
LA467:  .byte   $0F,$0F,$2C,$11,$0F,$0F,$20,$37,$0F,$0F,$27,$17,$0F,$0F,$20,$25 ; A467
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
LA485:  .byte   $20,$25,$0F,$0F,$2C,$11,$0F,$0F,$36,$26,$0F,$0F,$27,$17,$0F,$0F ; A485
        .byte   $20,$25,$0F,$00,$00,$00,$0F,$00,$00,$00,$0F,$11,$21,$16,$0F,$00 ; A495
        .byte   $00,$00                         ; A4A5
LA4A7:  .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$6D,$01,$1E,$1E ; A4A7
        .byte   $1E,$1E                         ; A4B7
LA4B9:  .byte   $13,$15,$14,$15,$14,$14,$15,$14,$14,$15,$1A,$18,$65,$A2,$12,$11 ; A4B9
        .byte   $16,$19                         ; A4C9
LA4CB:  .byte   $80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$30,$5C,$34,$50,$50 ; A4CB
        .byte   $94,$58                         ; A4DB
LA4DD:  .byte   $7B,$78,$78,$78,$78,$78,$78,$78,$78,$78,$80,$77,$93,$73,$43,$4B ; A4DD
        .byte   $85,$6B                         ; A4ED
LA4EF:  .byte   $00,$0C,$0D,$0E,$0F,$00,$01,$02,$03,$04,$00,$00,$00,$00,$00,$00 ; A4EF
        .byte   $00,$00                         ; A4FF
LA501:  .byte   $FF,$FF,$FF,$FF,$00,$01,$01,$01,$01 ; A501
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
LA59C:  .byte   $0F,$30,$30,$30                 ; A59C
LA5A0:  .byte   $00,$1A,$5C                     ; A5A0
LA5A3:  .byte   $29,$A6,$15,$49,$4E,$20,$54,$48,$45,$20,$59,$45,$41,$52,$20,$32 ; A5A3
        .byte   $30,$58,$58,$20,$41,$44,$2E,$2E,$2E,$FF,$29,$69,$0D,$41,$20,$56 ; A5B3
        .byte   $49,$43,$49,$4F,$55,$53,$20,$41,$52,$4D,$59,$29,$A6,$13,$4F,$46 ; A5C3
        .byte   $20,$52,$4F,$42,$4F,$54,$53,$20,$49,$53,$20,$42,$45,$4E,$54,$20 ; A5D3
        .byte   $4F,$4E,$29,$E6,$15,$44,$45,$53,$54,$52,$4F,$59,$49,$4E,$47,$20 ; A5E3
        .byte   $54,$48,$45,$20,$57,$4F,$52,$4C,$44,$21 ; A5F3

; ----------------------------------------------------------------------------
        .byte   $21,$FF,$29,$8A,$09,$41,$4E,$44,$20,$42,$45,$48,$49,$4E,$44,$29 ; A5FD
        .byte   $E6,$15,$54,$48,$49,$53,$20,$44,$45,$53,$54,$52,$55,$43,$54,$49 ; A60D
        .byte   $4F,$4E,$20,$49,$53,$2E,$2E,$2E,$FF ; A61D
; --- $A626: unclassified bytes (no reader identified) ---
        .byte   $FD,$D1,$C7,$75,$FF,$55,$FF,$5B,$FE,$75,$DD,$7D,$FF,$DF,$FF,$5F ; A626
        .byte   $FF,$FF,$FF,$DF,$FF,$FF,$FF,$FF,$FF,$FF,$F6,$55,$FF,$5C,$FF,$1D ; A636
        .byte   $FF,$D5,$77,$F5,$EE,$75,$FF,$75,$FF,$7D,$FF,$F7,$FD,$7F,$FF,$FF ; A646
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$DF,$FF,$FD,$FE,$55,$FB,$45,$FF,$D5 ; A656
        .byte   $15,$55,$FF,$54,$DF,$41,$FB,$55,$BB,$55,$F9,$D5,$FF,$D5,$FF,$55 ; A666
        .byte   $FF,$DD,$FF,$DD,$FF,$FD,$FF,$F7,$FF,$FD,$BF,$58,$FE,$59,$FB,$DC ; A676
        .byte   $FF,$5F,$77,$55,$FF,$F7,$FF,$DD,$FF,$FD,$FF,$53,$FF,$DF,$FF,$FF ; A686
        .byte   $FF,$FD,$FF,$FF,$FF,$FF,$FF,$FD,$FF,$FD,$D7,$11,$FF,$57,$FF,$55 ; A696
        .byte   $E6,$55,$FB,$55,$FF,$5F,$B7,$55,$FF,$77,$FF,$95,$FF,$7D,$FF,$75 ; A6A6
        .byte   $FF,$DF,$FF,$77,$FF,$5F,$FF,$FD,$FF,$FF,$FF,$75,$FB,$75,$F7,$55 ; A6B6
        .byte   $DF,$F5,$5F,$55,$FD,$7F,$FF,$F4,$EF,$55,$7F,$DF,$FF,$D7,$FF,$FF ; A6C6
        .byte   $FF,$F7,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FD,$FF,$65,$BF,$45,$ED,$55 ; A6D6
        .byte   $F9,$75,$FF,$54,$DB,$57,$FF,$D5,$F7,$5D,$EB,$54,$AF,$40,$FF,$34 ; A6E6
        .byte   $FF,$74,$FF,$35,$7F,$55,$FF,$77,$FF,$FF,$FF,$45,$FF,$75,$FB,$D4 ; A6F6
        .byte   $FF,$55,$B7,$D7,$FF,$7F,$FE,$FF,$FE,$F5,$FF,$DD,$FF,$FF,$FF,$FF ; A706
        .byte   $FF,$7F,$FF,$FF,$FF,$F5,$FF,$FF,$FF,$FF,$EF,$45,$FF,$35,$FB,$55 ; A716
        .byte   $FF,$15,$5F,$D5,$FF,$75,$BF,$57,$FF,$D5,$FF,$D3,$FF,$7D,$FF,$FD ; A726
        .byte   $FF,$D7,$FF,$FF,$FF,$75,$FF,$F7,$FF,$FD,$DE,$41,$FF,$F7,$FF,$55 ; A736
        .byte   $FF,$59,$7B,$75,$EF,$55,$DF,$77,$FF,$7F,$FF,$DF,$FF,$F7,$FF,$7F ; A746
        .byte   $FF,$7F,$FD,$F5,$FF,$7D,$FF,$FF,$FF,$FF,$7F,$55,$7D,$75,$DF,$65 ; A756
        .byte   $E3,$41,$EF,$14,$FB,$15,$F5,$55,$FC,$5F,$7B,$57,$E5,$57,$EF,$D5 ; A766
        .byte   $FF,$DD,$FF,$DF,$FF,$FF,$FF,$DD,$FF,$FF,$FD,$76,$7D,$D4,$FE,$55 ; A776
        .byte   $FF,$DF,$FF,$55,$FF,$DC,$FF,$DF,$FF,$FF,$FE,$7D,$FF,$7F,$FF,$FD ; A786
        .byte   $FF,$DF,$FF,$FD,$FF,$FF,$FF,$FF,$FF,$FD,$BF,$F5,$7F,$31,$FE,$55 ; A796
        .byte   $77,$5D,$FE,$15,$6B,$D3,$F7,$7D,$FB,$55,$FB,$75,$FF,$55,$FF,$D5 ; A7A6
        .byte   $FF,$F5,$FF,$DD,$FF,$F7,$F7,$7F,$FF,$FF,$FE,$55,$FF,$C5,$FD,$75 ; A7B6
        .byte   $FF,$5D,$FF,$F5,$FF,$9D,$FF,$75,$FF,$F5,$FF,$5F,$FF,$77,$FF,$7F ; A7C6
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$F7,$FF,$F7,$FF,$55,$FF,$51,$FF,$75 ; A7D6
        .byte   $3D,$9D,$FF,$14,$FC,$55,$17,$54,$6B,$41,$DA,$44,$FF,$15,$2F,$54 ; A7E6
        .byte   $F7,$05,$EF,$4F,$FF,$55,$FF,$B5,$FF,$F5 ; A7F6
; --- $A800: DAMAGE TABLE, weapon $C (Beat) ---
; $A800[ent_type] via damage_engine $1C:809D; low 7 bits = damage,
; bit 7 = special handling; $00 = ricochet. Types $00-$CF.
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A800  types $00-$0F
        .byte   $02,$03,$01,$01,$01,$01,$02,$02,$06,$01,$01,$04,$01,$01,$00,$00 ; A810  types $10-$1F
        .byte   $04,$02,$00,$00,$00,$01,$00,$00,$03,$01,$02,$01,$00,$00,$00,$00 ; A820  types $20-$2F
        .byte   $00,$03,$01,$03,$01,$01,$03,$00,$00,$01,$03,$02,$00,$01,$02,$00 ; A830  types $30-$3F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01 ; A840  types $40-$4F
        .byte   $01,$00,$01,$01,$01,$00,$01,$00,$00,$03,$00,$00,$03,$04,$00,$00 ; A850  types $50-$5F
        .byte   $01,$00,$01,$01,$01,$01,$02,$01,$01,$01,$00,$01,$00,$00,$01,$00 ; A860  types $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01,$00,$00,$00 ; A870  types $70-$7F
        .byte   $00,$01,$00,$01,$00,$00,$01,$00,$00,$01,$00,$00,$00,$01,$00,$00 ; A880  types $80-$8F
        .byte   $00,$03,$00,$03,$00,$00,$03,$00,$03,$00,$00,$00,$02,$00,$01,$00 ; A890  types $90-$9F
        .byte   $01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$00,$00,$00,$00,$00 ; A8A0  types $A0-$AF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$04,$02,$00 ; A8B0  types $B0-$BF
        .byte   $00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A8C0  types $C0-$CF
; --- $A8D0: remainder (beyond type $CF) ---
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A8D0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A8E0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A8F0

; =============================================================================
; WILY 1 STAGE DATA — format: DATA_REFERENCE.md section 11
; =============================================================================
; --- $A900: screen -> layout index ---
        .byte   $00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0A,$0B,$0C,$0D,$0E,$0F ; A900  screens $00-$0F
        .byte   $10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$1A,$1B,$1C,$1D,$00,$00 ; A910  screens $10-$1F
        .byte   $80,$00,$00,$10,$08,$04,$00,$00,$20,$28,$20,$80,$00,$00,$00,$00 ; A920  screens $20-$2F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A930  screens $30-$3F
        .byte   $20,$00,$00,$00,$02,$02,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A940  screens $40-$4F
; --- $A950: section list: start screen (bits 0-4) | flags (bits 5-7) ---
        .byte   $20,$40,$40,$40,$40,$62,$80,$A2,$80,$A3,$24,$20,$80,$A1,$20,$20 ; A950
        .byte   $00,$09,$00,$00,$02,$40,$02,$00 ; A960
; --- $A968: per-section attributes (bit 7 = vertical-scroll room) ---
        .byte   $00,$00,$00,$00,$00,$28,$1C,$28,$1B,$0A,$1C,$19,$1C,$19,$80,$80 ; A968
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A978
; --- $A980: BG CHR banks (MMC3 R0/R1 <- $A980/$A981; rest unreferenced) ---
        .byte   $B0,$B2,$00,$00,$20,$00,$20,$00 ; A980
; --- $A988: palette sets, 20 bytes each [16 BG palette + 4 palette-cycle
; seeds]: set n at +20n; set 0 is loaded by stage_load, later sets are
; switched per section by the bank $00 environment service
; ($A968 attr bits 0-5 -> $00:809E records, ctl bit 7) ---
        .byte   $0F,$30,$23,$04,$0F,$30,$26,$06,$0F,$30,$10,$00,$0F,$30,$1C,$02 ; A988
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A998
        .byte   $00,$08,$02,$00,$0A,$00,$80,$20,$00,$20,$00,$00,$00,$24,$00,$00 ; A9A0
        .byte   $8A,$04,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A9B0
        .byte   $00,$01,$00,$00,$00,$00,$00,$28,$00,$00,$00,$02,$00,$00,$00,$00 ; A9C0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A9D0
; --- $A9E0: screen links [screen, Y band, dest screen, dest section], bit 7 ends ---
        .byte   $FF,$10,$20,$AC,$02,$25,$00,$00,$08,$28,$08,$08,$00,$48,$20,$08 ; A9E0  terminator / filler
        .byte   $00,$00,$A2,$06,$00,$01,$02,$40,$00,$00,$00,$00,$00,$40,$00 ; A9F0  
        .byte   $00                             ; A9FF  -1 base for the spawn arrays
; --- $AA00: spawn screens (ascending) ---
        .byte   $00,$00,$06,$06,$06,$06,$06,$07,$07,$07,$08,$08,$08,$08,$08,$08 ; AA00  entries $00-$0F
        .byte   $08,$09,$0A,$0A,$0A,$0B,$0C,$0C,$0C,$0C,$0C,$0D,$0E,$0E,$0F,$0F ; AA10  entries $10-$1F
        .byte   $0F,$0F,$0F,$10,$11,$11,$12,$14,$14,$16,$16,$17,$17,$17,$17,$18 ; AA20  entries $20-$2F
        .byte   $18,$18,$18,$19,$19,$19,$19,$1B,$1B,$1B,$1B,$FF,$00,$00,$00,$00 ; AA30  entries $30-$3F
        .byte   $82,$22,$08,$04,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AA40  entries $40-$4F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AA50  entries $50-$5F
        .byte   $00,$8C,$00,$80,$00,$42,$00,$80,$80,$00,$00,$00,$00,$80,$00,$00 ; AA60  entries $60-$6F
        .byte   $02,$00,$80,$90,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AA70  entries $70-$7F
; --- $AA80: spawn X px ---
        .byte   $40,$B0,$30,$50,$70,$90,$B0,$30,$C0,$D0,$48,$4C,$6C,$8C,$AC,$D0 ; AA80  entries $00-$0F
        .byte   $E0,$00,$00,$50,$E0,$50,$60,$70,$80,$B0,$E0,$C8,$28,$58,$18,$48 ; AA90  entries $10-$1F
        .byte   $90,$E8,$FF,$FF,$00,$C0,$F0,$10,$70,$00,$B0,$50,$58,$90,$D0,$B0 ; AAA0  entries $20-$2F
        .byte   $B1,$F0,$F1,$88,$89,$B0,$B1,$D4,$D8,$D8,$D8,$FF,$00,$00,$00,$00 ; AAB0  entries $30-$3F
        .byte   $00,$00,$00,$00,$08,$06,$00,$40,$00,$00,$00,$00,$00,$10,$00,$02 ; AAC0  entries $40-$4F
        .byte   $00,$00,$00,$00,$00,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AAD0  entries $50-$5F
        .byte   $80,$00,$00,$04,$00,$40,$80,$20,$00,$01,$82,$20,$32,$60,$00,$11 ; AAE0  entries $60-$6F
        .byte   $20,$00,$02,$08,$00,$14,$80,$00,$02,$80,$00,$00,$20,$00,$02,$00 ; AAF0  entries $70-$7F
; --- $AB00: spawn Y px ---
        .byte   $88,$78,$C6,$A6,$98,$86,$78,$58,$C6,$B8,$28,$8D,$AD,$BD,$CD,$88 ; AB00  entries $00-$0F
        .byte   $48,$00,$00,$B8,$B8,$B8,$90,$60,$40,$30,$30,$86,$C8,$86,$A6,$86 ; AB10  entries $10-$1F
        .byte   $C6,$A6,$00,$00,$D8,$C0,$C0,$C0,$C0,$00,$60,$5D,$18,$9D,$18,$88 ; AB20  entries $20-$2F
        .byte   $B0,$88,$B0,$68,$90,$68,$90,$52,$90,$B0,$70,$FF,$00,$00,$00,$00 ; AB30  entries $30-$3F
        .byte   $00,$08,$00,$00,$00,$00,$00,$60,$00,$00,$00,$00,$00,$01,$00,$00 ; AB40  entries $40-$4F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AB50  entries $50-$5F
        .byte   $00,$02,$A0,$08,$00,$80,$28,$C0,$00,$00,$22,$03,$00,$02,$20,$0A ; AB60  entries $60-$6F
        .byte   $00,$02,$0A,$00,$00,$20,$08,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AB70  entries $70-$7F
; --- $AB80: spawn codes (< $C0 enemy id, >= $C0 palette/CHR command) ---
        .byte   $81,$82,$2E,$2E,$2C,$2E,$2C,$2C,$30,$2C,$34,$3B,$3B,$3B,$3B,$34 ; AB80  entries $00-$0F
        .byte   $84,$C3,$C0,$2C,$2C,$2C,$3F,$3F,$3F,$3F,$3F,$3C,$15,$3D,$3C,$3D ; AB90  entries $10-$1F
        .byte   $3E,$7F,$C0,$C1,$4B,$08,$08,$08,$08,$C3,$39,$3B,$36,$3B,$36,$61 ; ABA0  entries $20-$2F
        .byte   $14,$61,$14,$61,$14,$61,$14,$59,$5B,$5B,$5A,$FF,$00,$00,$00,$00 ; ABB0  entries $30-$3F
        .byte   $20,$10,$08,$00,$00,$00,$02,$20,$02,$00,$00,$04,$00,$00,$00,$80 ; ABC0  entries $40-$4F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ABD0  entries $50-$5F
        .byte   $00,$00,$00,$04,$00,$06,$00,$01,$80,$81,$00,$C4,$00,$00,$88,$00 ; ABE0  entries $60-$6F
        .byte   $00,$24,$00,$00,$02,$04,$00,$82,$00,$00,$00,$00,$00,$00,$00,$00 ; ABF0  entries $70-$7F
; --- $AC00: per-screen spawn-list start index ---
        .byte   $00,$02,$02,$02,$02,$02,$02,$07,$0A,$11,$12,$15,$16,$1B,$1C,$1E ; AC00  screens $00-$0F
        .byte   $23,$24,$26,$27,$27,$29,$29,$2B,$2F,$33,$37,$37,$00,$00,$00,$00 ; AC10  screens $10-$1F
        .byte   $40,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC20  screens $20-$2F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC30  screens $30-$3F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC40  screens $40-$4F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC50  screens $50-$5F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$04,$00,$00,$00,$00,$00,$00,$00 ; AC60  screens $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC70  screens $70-$7F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC80  screens $80-$8F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC90  screens $90-$9F
        .byte   $00,$00,$80,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACA0  screens $A0-$AF
        .byte   $00,$00,$00,$40,$00,$04,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACB0  screens $B0-$BF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACC0  screens $C0-$CF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACD0  screens $D0-$DF
        .byte   $00,$00,$00,$00,$04,$00,$40,$04,$00,$00,$00,$00,$00,$00,$00,$00 ; ACE0  screens $E0-$EF
        .byte   $00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00 ; ACF0  screens $F0-$FF
; --- $AD00: metatile top-left tile ids ---
        .byte   $00,$9C,$9C,$8E,$C2,$C4,$60,$20,$20,$E6,$D6,$D8,$E2,$E4,$28,$4E ; AD00  metatiles $00-$0F
        .byte   $C2,$C4,$C0,$C4,$C0,$C4,$00,$A0,$E2,$E4,$E0,$E4,$E0,$E4,$2A,$B0 ; AD10  metatiles $10-$1F
        .byte   $41,$40,$43,$44,$76,$6A,$0C,$0E,$00,$00,$00,$73,$00,$00,$2C,$2E ; AD20  metatiles $20-$2F
        .byte   $0A,$08,$D8,$6A,$76,$62,$26,$06,$CA,$44,$00,$6B,$00,$63,$00,$26 ; AD30  metatiles $30-$3F
        .byte   $80,$82,$82,$00,$C8,$00,$D6,$D8,$09,$46,$00,$00,$E8,$00,$E0,$E4 ; AD40  metatiles $40-$4F
        .byte   $02,$04,$30,$00,$00,$00,$AD,$AB,$22,$24,$5A,$88,$8A,$00,$B2,$E8 ; AD50  metatiles $50-$5F
        .byte   $A2,$A4,$A6,$A8,$A9,$64,$66,$68,$BB,$11,$B4,$BB,$BB,$74,$11,$78 ; AD60  metatiles $60-$6F
        .byte   $88,$8A,$BB,$BB,$BB,$A9,$AB,$AB,$23,$25,$7A,$7C,$88,$8A,$84,$86 ; AD70  metatiles $70-$7F
        .byte   $4C,$5C,$00,$00,$66,$66,$85,$86,$6C,$00,$00,$00,$38,$3A,$00,$00 ; AD80  metatiles $80-$8F
        .byte   $CE,$CC,$DC,$DE,$AC,$EA,$00,$00,$AC,$AC,$FC,$FE,$CE,$00,$00,$00 ; AD90  metatiles $90-$9F
        .byte   $84,$6E,$6F,$86,$ED,$EF,$6A,$8C,$48,$11,$58,$4A,$00,$EE,$ED,$EF ; ADA0  metatiles $A0-$AF
        .byte   $48,$11,$58,$4A,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ADB0  metatiles $B0-$BF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ADC0  metatiles $C0-$CF
        .byte   $00,$82,$84,$86,$00,$00,$00,$00,$00,$A2,$A4,$A6,$00,$00,$00,$00 ; ADD0  metatiles $D0-$DF
        .byte   $C0,$C2,$C4,$C6,$80,$00,$00,$00,$E0,$E2,$E4,$E6,$A0,$00,$00,$00 ; ADE0  metatiles $E0-$EF
        .byte   $00,$89,$8B,$8D,$8F,$00,$00,$00,$00,$A9,$AB,$AD,$AF,$00,$00,$00 ; ADF0  metatiles $F0-$FF
; --- $AE00: metatile bottom-left tile ids ---
        .byte   $00,$9D,$9D,$8F,$C3,$C5,$61,$21,$21,$E7,$D7,$D9,$E3,$E5,$29,$4F ; AE00  metatiles $00-$0F
        .byte   $C3,$C5,$C3,$C1,$C3,$C1,$00,$A1,$E3,$E5,$E3,$E1,$E3,$E1,$2B,$B1 ; AE10  metatiles $10-$1F
        .byte   $42,$40,$40,$76,$76,$6B,$0D,$0F,$00,$00,$00,$00,$00,$00,$2D,$2F ; AE20  metatiles $20-$2F
        .byte   $0B,$D9,$D9,$6A,$76,$62,$27,$07,$CD,$0B,$00,$6B,$00,$63,$00,$27 ; AE30  metatiles $30-$3F
        .byte   $81,$81,$83,$00,$C9,$00,$D7,$D9,$45,$47,$00,$00,$E9,$00,$E3,$E1 ; AE40  metatiles $40-$4F
        .byte   $03,$05,$31,$00,$00,$00,$AB,$AE,$23,$25,$5B,$89,$8B,$00,$B3,$E9 ; AE50  metatiles $50-$5F
        .byte   $A3,$A5,$A7,$A6,$AA,$65,$67,$69,$B3,$11,$BA,$11,$11,$75,$BA,$79 ; AE60  metatiles $60-$6F
        .byte   $89,$8B,$BB,$BB,$00,$AB,$A5,$AB,$24,$26,$7B,$7D,$89,$8B,$85,$87 ; AE70  metatiles $70-$7F
        .byte   $4D,$5D,$00,$00,$66,$66,$86,$85,$6D,$00,$00,$00,$39,$3B,$00,$00 ; AE80  metatiles $80-$8F
        .byte   $CF,$CE,$DE,$DF,$CB,$EB,$00,$00,$AC,$AC,$FD,$FF,$DB,$00,$00,$00 ; AE90  metatiles $90-$9F
        .byte   $85,$6F,$6E,$87,$EE,$6A,$6B,$8D,$49,$58,$11,$4B,$ED,$EF,$EE,$00 ; AEA0  metatiles $A0-$AF
        .byte   $49,$58,$59,$4B,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AEB0  metatiles $B0-$BF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AEC0  metatiles $C0-$CF
        .byte   $00,$83,$85,$87,$00,$00,$00,$00,$00,$A3,$A5,$A7,$00,$00,$00,$00 ; AED0  metatiles $D0-$DF
        .byte   $C1,$C3,$C5,$C7,$81,$00,$00,$00,$E1,$E3,$E5,$E7,$A1,$00,$00,$00 ; AEE0  metatiles $E0-$EF
        .byte   $88,$8A,$8C,$8E,$00,$00,$00,$00,$A8,$AA,$AC,$AE,$00,$00,$00,$00 ; AEF0  metatiles $F0-$FF
; --- $AF00: metatile top-right tile ids ---
        .byte   $00,$9C,$9C,$9E,$D2,$D4,$70,$20,$30,$F6,$D0,$D4,$F2,$F4,$38,$5E ; AF00  metatiles $00-$0F
        .byte   $F6,$F6,$F6,$F6,$D0,$D4,$00,$A0,$F6,$F6,$F6,$F6,$F0,$F4,$3A,$D4 ; AF10  metatiles $10-$1F
        .byte   $51,$50,$53,$44,$76,$7A,$1C,$1E,$51,$50,$53,$44,$56,$6A,$3C,$3E ; AF20  metatiles $20-$2F
        .byte   $1A,$18,$C8,$7A,$EC,$72,$16,$16,$DA,$44,$00,$7B,$00,$63,$00,$36 ; AF30  metatiles $30-$3F
        .byte   $90,$92,$91,$00,$D8,$00,$D0,$D4,$54,$19,$00,$00,$F8,$00,$F0,$F4 ; AF40  metatiles $40-$4F
        .byte   $12,$14,$30,$00,$00,$00,$B2,$B3,$32,$34,$5A,$09,$46,$00,$AF,$F8 ; AF50  metatiles $50-$5F
        .byte   $B2,$11,$B6,$B8,$B9,$74,$11,$78,$BB,$11,$11,$BB,$BB,$74,$11,$78 ; AF60  metatiles $60-$6F
        .byte   $88,$8A,$00,$00,$00,$B9,$11,$11,$33,$35,$88,$8A,$98,$9A,$94,$96 ; AF70  metatiles $70-$7F
        .byte   $5C,$4C,$00,$00,$28,$2A,$95,$96,$6C,$00,$00,$00,$38,$3A,$00,$00 ; AF80  metatiles $80-$8F
        .byte   $CC,$CE,$EC,$EC,$BE,$FA,$00,$00,$BF,$BE,$CE,$CC,$CC,$00,$00,$00 ; AF90  metatiles $90-$9F
        .byte   $48,$11,$58,$4A,$ED,$EF,$6A,$8C,$94,$7E,$7F,$96,$00,$11,$8C,$8D ; AFA0  metatiles $A0-$AF
        .byte   $48,$11,$58,$4A,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AFB0  metatiles $B0-$BF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$C8,$00,$00,$00,$00,$00 ; AFC0  metatiles $C0-$CF
        .byte   $00,$92,$94,$96,$00,$00,$00,$00,$00,$B2,$B4,$B6,$00,$00,$00,$00 ; AFD0  metatiles $D0-$DF
        .byte   $D0,$D2,$D4,$D6,$90,$00,$00,$00,$F0,$F2,$F4,$F6,$B0,$00,$00,$00 ; AFE0  metatiles $E0-$EF
        .byte   $00,$99,$9B,$9D,$9F,$00,$00,$00,$B8,$B9,$BB,$BD,$BF,$00,$00,$00 ; AFF0  metatiles $F0-$FF
; --- $B000: metatile bottom-right tile ids ---
        .byte   $00,$9D,$9D,$9F,$D3,$D5,$71,$21,$31,$F7,$D3,$D1,$F3,$F5,$39,$5F ; B000  metatiles $00-$0F
        .byte   $F7,$F7,$F7,$F7,$D3,$D1,$00,$A1,$F7,$F7,$F7,$F7,$F3,$F1,$3B,$D5 ; B010  metatiles $10-$1F
        .byte   $52,$50,$50,$76,$76,$7B,$1D,$1F,$52,$50,$50,$56,$56,$6B,$3D,$3F ; B020  metatiles $20-$2F
        .byte   $1B,$C9,$C9,$7A,$EC,$72,$17,$17,$DD,$1B,$00,$7B,$00,$63,$00,$37 ; B030  metatiles $30-$3F
        .byte   $91,$91,$93,$00,$D9,$00,$D3,$D1,$55,$57,$00,$00,$F9,$00,$F3,$F1 ; B040  metatiles $40-$4F
        .byte   $13,$15,$31,$A8,$00,$00,$B4,$BA,$33,$35,$5B,$45,$47,$00,$BC,$F9 ; B050  metatiles $50-$5F
        .byte   $B3,$B5,$B7,$B6,$BA,$75,$11,$79,$11,$11,$BA,$B4,$11,$75,$BA,$79 ; B060  metatiles $60-$6F
        .byte   $89,$8B,$00,$00,$00,$11,$B5,$11,$34,$36,$89,$8B,$99,$9B,$95,$97 ; B070  metatiles $70-$7F
        .byte   $5D,$4D,$00,$00,$29,$2B,$96,$95,$6D,$00,$00,$00,$39,$3B,$00,$00 ; B080  metatiles $80-$8F
        .byte   $CE,$CF,$EC,$EC,$DB,$FB,$00,$00,$BD,$BF,$CF,$CE,$DB,$00,$00,$00 ; B090  metatiles $90-$9F
        .byte   $49,$58,$59,$4B,$EE,$6A,$6B,$8D,$95,$7F,$7E,$97,$8C,$8D,$11,$00 ; B0A0  metatiles $A0-$AF
        .byte   $49,$58,$11,$4B,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B0B0  metatiles $B0-$BF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$C9,$00,$00,$00,$00,$00 ; B0C0  metatiles $C0-$CF
        .byte   $00,$93,$95,$97,$00,$00,$00,$00,$00,$B3,$B5,$B7,$00,$00,$00,$00 ; B0D0  metatiles $D0-$DF
        .byte   $D1,$D3,$D5,$D7,$91,$00,$00,$00,$F1,$F3,$F5,$F7,$B1,$00,$00,$00 ; B0E0  metatiles $E0-$EF
        .byte   $98,$9A,$9C,$9E,$00,$00,$00,$00,$B8,$BA,$BC,$BE,$00,$00,$00,$00 ; B0F0  metatiles $F0-$FF
; --- $B100: metatile attributes: palette (bits 0-1) | collision (high nibble: ---
; $20 solid, $40 ladder, >= $D0 spikes; see DATA_REFERENCE section 11)
        .byte   $00,$40,$20,$F3,$10,$10,$F1,$01,$10,$10,$10,$10,$10,$10,$72,$30 ; B100  metatiles $00-$0F
        .byte   $10,$10,$10,$10,$10,$10,$00,$10,$10,$10,$10,$10,$10,$10,$52,$10 ; B110  metatiles $10-$1F
        .byte   $03,$03,$03,$03,$03,$00,$12,$12,$03,$03,$03,$03,$03,$00,$12,$12 ; B120  metatiles $20-$2F
        .byte   $03,$10,$10,$10,$03,$10,$12,$12,$F1,$03,$00,$10,$00,$10,$00,$12 ; B130  metatiles $30-$3F
        .byte   $12,$12,$12,$10,$01,$00,$11,$11,$12,$12,$00,$00,$01,$00,$11,$11 ; B140  metatiles $40-$4F
        .byte   $11,$11,$10,$11,$00,$00,$11,$11,$11,$11,$10,$10,$10,$00,$11,$01 ; B150  metatiles $50-$5F
        .byte   $11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11 ; B160  metatiles $60-$6F
        .byte   $12,$12,$11,$11,$11,$11,$11,$11,$10,$10,$12,$12,$12,$12,$10,$10 ; B170  metatiles $70-$7F
        .byte   $11,$11,$00,$00,$11,$11,$10,$10,$11,$00,$00,$00,$11,$11,$00,$00 ; B180  metatiles $80-$8F
        .byte   $03,$03,$03,$03,$03,$03,$00,$00,$03,$03,$03,$03,$03,$00,$00,$00 ; B190  metatiles $90-$9F
        .byte   $10,$10,$10,$10,$12,$12,$12,$12,$10,$10,$10,$10,$03,$03,$03,$03 ; B1A0  metatiles $A0-$AF
        .byte   $10,$10,$10,$10,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B1B0  metatiles $B0-$BF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$03,$03,$00,$00,$00,$00 ; B1C0  metatiles $C0-$CF
        .byte   $00,$03,$03,$03,$00,$00,$00,$00,$00,$03,$03,$03,$00,$00,$00,$00 ; B1D0  metatiles $D0-$DF
        .byte   $01,$01,$01,$01,$01,$00,$00,$00,$02,$02,$02,$02,$02,$00,$00,$00 ; B1E0  metatiles $E0-$EF
        .byte   $03,$03,$03,$03,$03,$00,$00,$00,$02,$02,$02,$02,$02,$00,$00,$00 ; B1F0  metatiles $F0-$FF
; --- $B200: 32px block defs: 4 metatile ids [TL,BL,TR,BR] per block ---
        .byte   $04,$05,$18,$19,$0A,$0B,$1C,$1D,$2B,$2C,$23,$24,$2B,$2B,$23,$23 ; B200  blocks $00-$03
        .byte   $2C,$2C,$24,$24,$14,$05,$1C,$0D,$04,$15,$0C,$1D,$39,$30,$20,$21 ; B210  blocks $04-$07
        .byte   $39,$39,$20,$22,$30,$30,$21,$21,$39,$30,$23,$24,$10,$13,$0B,$0B ; B220  blocks $08-$0B
        .byte   $23,$24,$32,$32,$23,$23,$32,$23,$24,$31,$24,$2C,$32,$32,$2B,$2C ; B230  blocks $0C-$0F
        .byte   $2B,$23,$23,$23,$24,$24,$24,$24,$23,$24,$23,$24,$0B,$01,$1D,$02 ; B240  blocks $10-$13
        .byte   $04,$05,$0C,$0D,$15,$02,$1D,$02,$14,$15,$1C,$1D,$18,$19,$03,$2C ; B250  blocks $14-$17
        .byte   $18,$19,$2B,$2C,$18,$19,$2B,$2B,$18,$19,$2C,$2C,$1B,$02,$2C,$02 ; B260  blocks $18-$1B
        .byte   $03,$24,$03,$21,$23,$24,$22,$21,$23,$23,$20,$22,$24,$24,$21,$31 ; B270  blocks $1C-$1F
        .byte   $23,$24,$0A,$0B,$24,$02,$0A,$0B,$24,$12,$21,$03,$03,$24,$03,$24 ; B280  blocks $20-$23
        .byte   $23,$23,$23,$23,$24,$03,$24,$2C,$12,$13,$2B,$03,$23,$03,$23,$03 ; B290  blocks $24-$27
        .byte   $03,$30,$03,$21,$39,$30,$22,$21,$39,$03,$22,$03,$03,$24,$0B,$03 ; B2A0  blocks $28-$2B
        .byte   $23,$03,$23,$2C,$14,$14,$03,$1C,$15,$03,$1D,$03,$03,$14,$03,$1C ; B2B0  blocks $2C-$2F
        .byte   $04,$05,$0A,$0B,$15,$03,$0A,$0B,$23,$24,$03,$24,$23,$31,$23,$2B ; B2C0  blocks $30-$33
        .byte   $32,$24,$2C,$24,$24,$24,$21,$21,$24,$03,$24,$03,$03,$03,$0A,$0B ; B2D0  blocks $34-$37
        .byte   $03,$12,$0A,$0B,$10,$11,$0A,$0B,$24,$03,$21,$03,$14,$05,$1A,$19 ; B2E0  blocks $38-$3B
        .byte   $24,$2C,$24,$24,$0A,$0B,$0C,$0D,$03,$32,$2C,$03,$30,$03,$21,$03 ; B2F0  blocks $3C-$3F
        .byte   $39,$39,$23,$23,$30,$30,$24,$24,$30,$03,$24,$03,$03,$23,$03,$23 ; B300  blocks $40-$43
        .byte   $03,$39,$03,$23,$03,$23,$03,$03,$24,$24,$03,$03,$23,$37,$03,$3F ; B310  blocks $44-$47
        .byte   $37,$37,$3F,$3F,$2B,$37,$03,$3F,$04,$15,$18,$1B,$23,$24,$20,$21 ; B320  blocks $48-$4B
        .byte   $5E,$5F,$0A,$0B,$02,$6D,$02,$6D,$56,$57,$6B,$6A,$2C,$2C,$21,$21 ; B330  blocks $4C-$4F
        .byte   $2B,$2C,$20,$21,$02,$14,$02,$1A,$02,$2C,$02,$24,$2C,$6D,$24,$6D ; B340  blocks $50-$53
        .byte   $02,$30,$02,$21,$30,$30,$21,$0A,$39,$30,$0A,$0B,$30,$6D,$0A,$0B ; B350  blocks $54-$57
        .byte   $02,$30,$0A,$0B,$30,$14,$21,$1A,$30,$30,$0A,$0B,$30,$6D,$24,$6D ; B360  blocks $58-$5B
        .byte   $24,$24,$0A,$0B,$24,$6D,$01,$6D,$00,$00,$99,$98,$12,$13,$00,$00 ; B370  blocks $5C-$5F
        .byte   $90,$91,$90,$91,$99,$98,$90,$91,$14,$11,$1C,$38,$94,$00,$9C,$00 ; B380  blocks $60-$63
        .byte   $90,$91,$93,$92,$93,$92,$0A,$0B,$01,$0A,$02,$1C,$02,$14,$02,$1C ; B390  blocks $64-$67
        .byte   $12,$13,$38,$38,$00,$00,$00,$00,$95,$95,$00,$00,$0E,$0E,$40,$41 ; B3A0  blocks $68-$6B
        .byte   $0E,$0E,$41,$41,$0E,$95,$42,$00,$95,$0E,$00,$40,$32,$32,$00,$00 ; B3B0  blocks $6C-$6F
        .byte   $0E,$0E,$41,$42,$18,$19,$00,$00,$18,$14,$00,$1C,$99,$14,$90,$1C ; B3C0  blocks $70-$73
        .byte   $13,$02,$0A,$0B,$95,$95,$90,$91,$95,$14,$90,$1C,$12,$13,$0A,$0B ; B3D0  blocks $74-$77
        .byte   $93,$14,$01,$1C,$15,$00,$1D,$98,$15,$91,$1D,$91,$90,$91,$95,$1E ; B3E0  blocks $78-$7B
        .byte   $0E,$95,$9B,$91,$90,$9A,$90,$91,$1E,$95,$9B,$91,$15,$92,$32,$32 ; B3F0  blocks $7C-$7F
        .byte   $93,$92,$0B,$01,$95,$0E,$90,$9A,$0E,$0E,$9B,$9A,$90,$91,$90,$95 ; B400  blocks $80-$83
        .byte   $90,$91,$0E,$95,$95,$1E,$93,$92,$9B,$91,$93,$92,$95,$1E,$90,$9A ; B410  blocks $84-$87
        .byte   $95,$95,$93,$92,$0E,$0E,$93,$92,$9C,$00,$9C,$00,$90,$91,$60,$61 ; B420  blocks $88-$8B
        .byte   $90,$91,$62,$63,$9C,$00,$62,$63,$00,$00,$62,$63,$68,$69,$00,$00 ; B430  blocks $8C-$8F
        .byte   $6E,$6C,$00,$00,$52,$50,$52,$58,$51,$5A,$59,$5A,$70,$71,$70,$71 ; B440  blocks $90-$93
        .byte   $70,$71,$7C,$7D,$A0,$A1,$A8,$A9,$A2,$A3,$AA,$AB,$A0,$A1,$B0,$B1 ; B450  blocks $94-$97
        .byte   $A2,$A3,$B2,$B3,$A8,$A9,$00,$00,$AA,$AB,$00,$00,$7C,$7D,$48,$49 ; B460  blocks $98-$9B
        .byte   $48,$49,$00,$00,$00,$00,$64,$60,$00,$00,$61,$62,$00,$00,$63,$64 ; B470  blocks $9C-$9F
        .byte   $00,$00,$60,$61,$6E,$68,$00,$00,$69,$6E,$00,$00,$6C,$6E,$00,$00 ; B480  blocks $A0-$A3
        .byte   $A0,$A2,$A8,$AA,$A1,$A2,$A9,$AA,$A1,$A3,$A9,$AB,$17,$7A,$81,$70 ; B490  blocks $A4-$A7
        .byte   $7B,$7A,$71,$70,$7B,$17,$71,$17,$17,$A0,$81,$A8,$A3,$17,$AB,$81 ; B4A0  blocks $A8-$AB
        .byte   $A8,$A9,$17,$00,$80,$52,$81,$52,$50,$51,$58,$59,$5A,$80,$5A,$00 ; B4B0  blocks $AC-$AF
        .byte   $81,$00,$00,$00,$80,$A0,$00,$B0,$A1,$A2,$B1,$B2,$A3,$00,$B3,$00 ; B4C0  blocks $B0-$B3
        .byte   $00,$A8,$00,$0F,$A9,$AA,$0F,$0F,$AB,$00,$0F,$00,$00,$00,$80,$60 ; B4D0  blocks $B4-$B7
        .byte   $00,$0F,$65,$66,$0F,$0F,$84,$85,$0F,$00,$66,$67,$00,$00,$75,$65 ; B4E0  blocks $B8-$BB
        .byte   $81,$68,$00,$00,$6D,$69,$00,$00,$8C,$8D,$00,$00,$69,$6F,$00,$00 ; B4F0  blocks $BC-$BF
        .byte   $69,$6D,$00,$00,$7A,$7B,$70,$71,$17,$70,$81,$7C,$71,$17,$7D,$81 ; B500  blocks $C0-$C3
        .byte   $00,$70,$00,$70,$71,$00,$71,$00,$00,$7C,$00,$48,$7D,$00,$49,$00 ; B510  blocks $C4-$C7
        .byte   $00,$0F,$00,$0F,$0F,$00,$0F,$00,$00,$00,$84,$85,$00,$00,$67,$60 ; B520  blocks $C8-$CB
        .byte   $6F,$68,$00,$00,$7D,$81,$49,$80,$0F,$0F,$0F,$0F,$7A,$7B,$7C,$7D ; B530  blocks $CC-$CF
        .byte   $70,$71,$7E,$7F,$00,$17,$00,$81,$00,$00,$65,$66,$00,$00,$66,$67 ; B540  blocks $D0-$D3
        .byte   $80,$02,$88,$02,$2C,$02,$24,$02,$30,$02,$0A,$0B,$39,$39,$0A,$0B ; B550  blocks $D4-$D7
        .byte   $23,$24,$62,$63,$12,$13,$62,$63,$02,$12,$02,$2C,$10,$11,$2B,$2C ; B560  blocks $D8-$DB
        .byte   $10,$11,$2C,$2C,$0B,$01,$80,$02,$24,$80,$21,$17,$24,$80,$21,$88 ; B570  blocks $DC-$DF
        .byte   $2C,$17,$21,$80,$14,$80,$1C,$80,$24,$17,$24,$17,$04,$1F,$0C,$0D ; B580  blocks $E0-$E3
        .byte   $04,$1F,$0C,$19,$12,$13,$2B,$2C,$1B,$2C,$2B,$24,$30,$88,$21,$80 ; B590  blocks $E4-$E7
        .byte   $34,$34,$06,$06,$23,$80,$20,$80,$26,$27,$2E,$2F,$12,$13,$2C,$07 ; B5A0  blocks $E8-$EB
        .byte   $0B,$34,$1D,$06,$24,$07,$21,$07,$14,$80,$1C,$88,$12,$13,$2C,$2C ; B5B0  blocks $EC-$EF
        .byte   $35,$35,$3D,$3D,$3D,$3D,$3D,$3D,$A4,$A5,$70,$71,$A6,$A7,$70,$71 ; B5C0  blocks $F0-$F3
        .byte   $00,$00,$00,$CA,$D1,$D2,$D9,$DA,$D3,$00,$DB,$00,$00,$E0,$00,$E8 ; B5D0  blocks $F4-$F7
        .byte   $E1,$E2,$E9,$EA,$E3,$E4,$EB,$EC,$00,$F0,$00,$F8,$F1,$F2,$F9,$FA ; B5E0  blocks $F8-$FB
        .byte   $F3,$F4,$FB,$FC,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B5F0  blocks $FC-$FF
; --- $B600: screen layouts: 64 block ids (8x8) each; ptr = $B600 + layout*64 ---
; layout $00
        .byte   $00,$00,$00,$01,$00,$00,$00,$00,$01,$02,$02,$03,$04,$02,$04,$05 ; B600
        .byte   $06,$07,$07,$08,$09,$07,$09,$05,$06,$0A,$0A,$08,$09,$07,$09,$05 ; B610
        .byte   $0B,$0C,$0C,$0D,$0E,$0F,$01,$01,$06,$02,$02,$10,$11,$12,$04,$05 ; B620
        .byte   $01,$01,$01,$01,$01,$01,$13,$05,$14,$14,$14,$14,$14,$14,$15,$16 ; B630
; layout $01
        .byte   $06,$17,$18,$19,$1A,$18,$1B,$16,$06,$1C,$1D,$1E,$1F,$20,$21,$16 ; B640
        .byte   $06,$1C,$1D,$1E,$22,$05,$14,$14,$06,$23,$12,$24,$25,$26,$05,$14 ; B650
        .byte   $06,$23,$12,$24,$11,$27,$05,$14,$06,$28,$29,$08,$09,$2A,$05,$14 ; B660
        .byte   $06,$28,$29,$08,$09,$2A,$05,$14,$16,$23,$12,$24,$11,$27,$16,$16 ; B670
; layout $02
        .byte   $16,$23,$12,$24,$11,$27,$16,$16,$06,$28,$07,$08,$09,$2A,$05,$14 ; B680
        .byte   $06,$28,$29,$08,$09,$2A,$05,$14,$06,$2B,$12,$24,$11,$2C,$2D,$05 ; B690
        .byte   $14,$2E,$07,$08,$09,$29,$2F,$05,$30,$31,$32,$33,$34,$12,$2F,$05 ; B6A0
        .byte   $14,$06,$28,$08,$09,$07,$2F,$05,$16,$16,$1C,$1E,$35,$1D,$2F,$16 ; B6B0
; layout $03
        .byte   $16,$16,$28,$08,$09,$29,$2F,$16,$14,$06,$23,$24,$36,$37,$38,$39 ; B6C0
        .byte   $14,$06,$1C,$1E,$3A,$3B,$00,$00,$14,$06,$23,$24,$3C,$02,$2F,$05 ; B6D0
        .byte   $3D,$3D,$2E,$24,$11,$12,$3E,$01,$14,$14,$2E,$08,$09,$29,$3F,$05 ; B6E0
        .byte   $14,$14,$2E,$24,$11,$12,$36,$05,$14,$14,$2E,$24,$11,$12,$36,$05 ; B6F0
; layout $04
        .byte   $14,$14,$2E,$24,$11,$12,$36,$05,$14,$14,$2E,$40,$41,$0A,$42,$05 ; B700
        .byte   $14,$14,$2E,$40,$41,$0A,$42,$05,$14,$14,$2E,$40,$41,$0A,$42,$05 ; B710
        .byte   $14,$14,$2E,$08,$09,$07,$3F,$05,$14,$14,$2E,$24,$11,$12,$36,$05 ; B720
        .byte   $01,$01,$01,$43,$11,$12,$36,$05,$16,$16,$16,$43,$11,$12,$36,$16 ; B730
; layout $05
        .byte   $16,$16,$16,$43,$11,$12,$36,$16,$14,$14,$06,$43,$11,$12,$36,$05 ; B740
        .byte   $14,$14,$06,$44,$41,$07,$3F,$05,$14,$14,$06,$44,$41,$0A,$42,$3B ; B750
        .byte   $14,$14,$06,$43,$11,$12,$3C,$02,$14,$14,$06,$44,$41,$07,$09,$07 ; B760
        .byte   $14,$14,$06,$45,$46,$47,$48,$48,$14,$14,$06,$03,$04,$49,$48,$48 ; B770
; layout $06
        .byte   $05,$14,$14,$06,$48,$48,$05,$06,$14,$14,$14,$06,$48,$48,$05,$06 ; B780
        .byte   $06,$04,$02,$02,$04,$02,$04,$02,$4A,$41,$07,$29,$09,$29,$01,$01 ; B790
        .byte   $04,$11,$4B,$1D,$01,$01,$05,$14,$09,$09,$01,$01,$05,$06,$05,$14 ; B7A0
        .byte   $48,$48,$05,$06,$48,$48,$05,$14,$48,$48,$05,$06,$48,$48,$05,$14 ; B7B0
; layout $07
        .byte   $01,$01,$16,$4C,$16,$4C,$16,$4D,$16,$16,$16,$4E,$16,$4E,$16,$4D ; B7C0
        .byte   $02,$04,$02,$4C,$16,$4C,$16,$4D,$01,$01,$29,$16,$16,$16,$16,$4D ; B7D0
        .byte   $14,$06,$4B,$4F,$50,$4F,$4F,$4D,$14,$06,$1D,$35,$1D,$35,$35,$4D ; B7E0
        .byte   $14,$06,$48,$48,$48,$48,$48,$48,$14,$06,$48,$48,$48,$48,$48,$48 ; B7F0
; layout $08
        .byte   $06,$51,$00,$00,$00,$00,$00,$00,$06,$52,$02,$04,$03,$04,$02,$53 ; B800
        .byte   $06,$54,$29,$09,$08,$55,$56,$57,$06,$58,$0A,$41,$08,$59,$00,$00 ; B810
        .byte   $14,$06,$20,$11,$24,$3C,$02,$53,$16,$16,$16,$5A,$40,$41,$0A,$5B ; B820
        .byte   $16,$4E,$05,$06,$01,$5C,$20,$5D,$16,$4C,$16,$4E,$16,$4E,$16,$4D ; B830
; layout $09
        .byte   $14,$14,$14,$14,$14,$14,$14,$14,$14,$06,$5E,$5E,$5E,$5E,$5E,$05 ; B840
        .byte   $06,$5F,$60,$60,$60,$60,$60,$05,$06,$61,$60,$60,$60,$60,$60,$62 ; B850
        .byte   $06,$60,$60,$60,$60,$60,$60,$63,$06,$64,$64,$64,$65,$65,$01,$01 ; B860
        .byte   $06,$66,$01,$01,$16,$16,$16,$16,$06,$67,$16,$16,$16,$16,$16,$16 ; B870
; layout $0A
        .byte   $06,$16,$16,$16,$05,$14,$06,$16,$06,$4E,$16,$4E,$05,$14,$06,$4E ; B880
        .byte   $06,$4C,$16,$4C,$05,$14,$06,$4C,$68,$68,$68,$68,$68,$68,$68,$68 ; B890
        .byte   $69,$69,$69,$69,$69,$69,$69,$69,$01,$6A,$6A,$6B,$6C,$6D,$6A,$6E ; B8A0
        .byte   $01,$6F,$6F,$6F,$6F,$6F,$6F,$6F,$16,$69,$69,$69,$69,$69,$69,$69 ; B8B0
; layout $0B
        .byte   $16,$01,$16,$01,$16,$16,$16,$67,$16,$4E,$16,$4E,$05,$14,$06,$67 ; B8C0
        .byte   $16,$4C,$16,$4C,$05,$14,$06,$67,$68,$68,$68,$68,$68,$68,$16,$67 ; B8D0
        .byte   $69,$69,$69,$69,$69,$69,$69,$67,$6C,$70,$6A,$6A,$6B,$6C,$6D,$67 ; B8E0
        .byte   $6F,$6F,$6F,$6F,$01,$01,$01,$01,$69,$69,$69,$69,$16,$16,$16,$16 ; B8F0
; layout $0C
        .byte   $14,$15,$71,$71,$71,$71,$71,$72,$14,$15,$61,$61,$61,$61,$61,$73 ; B900
        .byte   $39,$74,$60,$60,$60,$75,$75,$76,$14,$06,$75,$60,$75,$75,$75,$76 ; B910
        .byte   $14,$06,$60,$75,$75,$75,$75,$76,$77,$77,$65,$65,$65,$65,$65,$78 ; B920
        .byte   $06,$4E,$16,$4E,$05,$14,$06,$67,$16,$4C,$16,$4C,$16,$16,$16,$67 ; B930
; layout $0D
        .byte   $14,$14,$14,$14,$14,$14,$14,$14,$79,$5E,$5E,$5E,$5E,$5E,$5E,$5E ; B940
        .byte   $7A,$60,$60,$75,$60,$60,$60,$60,$7A,$75,$75,$60,$60,$60,$60,$7B ; B950
        .byte   $7A,$60,$60,$60,$7B,$75,$7C,$7D,$7A,$60,$60,$7E,$7D,$60,$60,$60 ; B960
        .byte   $7F,$80,$65,$65,$65,$65,$65,$65,$14,$15,$14,$14,$14,$14,$14,$14 ; B970
; layout $0E
        .byte   $14,$14,$14,$14,$14,$14,$14,$14,$5E,$5E,$5E,$5E,$5E,$5E,$5E,$5E ; B980
        .byte   $60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$81,$82,$82,$82 ; B990
        .byte   $75,$7E,$81,$75,$60,$60,$60,$60,$60,$60,$60,$75,$7E,$60,$83,$84 ; B9A0
        .byte   $65,$65,$64,$64,$64,$85,$64,$86,$14,$06,$69,$69,$69,$69,$69,$69 ; B9B0
; layout $0F
        .byte   $14,$14,$14,$14,$14,$14,$14,$14,$5E,$5E,$5E,$5E,$5E,$5E,$5E,$5E ; B9C0
        .byte   $60,$60,$60,$60,$60,$60,$60,$60,$75,$60,$60,$87,$60,$81,$75,$60 ; B9D0
        .byte   $60,$75,$7E,$60,$60,$60,$60,$60,$87,$75,$60,$60,$60,$60,$75,$82 ; B9E0
        .byte   $64,$64,$88,$89,$89,$89,$88,$64,$69,$69,$69,$69,$69,$69,$69,$69 ; B9F0
; layout $10
        .byte   $14,$06,$4E,$05,$06,$4E,$16,$69,$5E,$16,$4C,$05,$06,$4C,$16,$69 ; BA00
        .byte   $60,$16,$4E,$05,$06,$4E,$16,$69,$60,$16,$4C,$05,$06,$4C,$16,$69 ; BA10
        .byte   $60,$61,$61,$61,$63,$69,$69,$69,$75,$60,$60,$60,$8A,$69,$69,$69 ; BA20
        .byte   $64,$8B,$8C,$8C,$8D,$8E,$8E,$8E,$69,$8F,$90,$90,$90,$90,$90,$90 ; BA30
; layout $11
        .byte   $91,$92,$93,$94,$93,$95,$96,$93,$95,$96,$94,$97,$98,$91,$92,$93 ; BA40
        .byte   $69,$69,$93,$99,$9A,$95,$96,$93,$69,$69,$9B,$69,$69,$69,$69,$94 ; BA50
        .byte   $69,$69,$69,$69,$69,$69,$69,$9C,$69,$69,$69,$69,$69,$69,$69,$69 ; BA60
        .byte   $9D,$9E,$9F,$A0,$8E,$9D,$9E,$9F,$A1,$A2,$A3,$8F,$90,$A1,$A2,$A3 ; BA70
; layout $12
        .byte   $95,$96,$93,$A4,$A5,$A6,$95,$96,$91,$92,$93,$A7,$A8,$A9,$91,$92 ; BA80
        .byte   $97,$98,$93,$AA,$A5,$AB,$97,$98,$AC,$9A,$94,$AD,$AE,$AF,$99,$9A ; BA90
        .byte   $B0,$69,$9C,$B1,$B2,$B3,$69,$69,$69,$69,$69,$B4,$B5,$B6,$69,$69 ; BAA0
        .byte   $B7,$9E,$9F,$B8,$B9,$BA,$A0,$BB,$BC,$A2,$A3,$BD,$BE,$BF,$8F,$C0 ; BAB0
; layout $13
        .byte   $C1,$C1,$93,$93,$93,$95,$AB,$93,$93,$93,$9B,$9B,$93,$A7,$A9,$93 ; BAC0
        .byte   $95,$96,$69,$69,$9B,$C2,$C3,$9B,$91,$92,$69,$69,$69,$C4,$C5,$69 ; BAD0
        .byte   $97,$98,$69,$69,$69,$C6,$C7,$69,$99,$9A,$69,$69,$69,$C8,$C9,$69 ; BAE0
        .byte   $CA,$CA,$CB,$9E,$9F,$B8,$BA,$A0,$BE,$BE,$CC,$A2,$A3,$BD,$BF,$8F ; BAF0
; layout $14
        .byte   $95,$96,$95,$96,$93,$95,$96,$93,$91,$92,$91,$92,$93,$91,$92,$93 ; BB00
        .byte   $95,$96,$95,$96,$93,$95,$96,$93,$69,$C1,$69,$69,$9B,$A7,$A9,$93 ; BB10
        .byte   $69,$9B,$69,$69,$69,$C6,$CD,$9B,$69,$CE,$69,$69,$69,$C8,$CE,$CE ; BB20
        .byte   $BB,$B9,$CB,$9E,$9F,$B8,$B9,$B9,$C0,$BE,$CC,$A2,$A3,$BD,$BE,$BE ; BB30
; layout $15
        .byte   $91,$92,$93,$93,$93,$95,$96,$94,$95,$96,$94,$93,$93,$C1,$C1,$93 ; BB40
        .byte   $CF,$C1,$D0,$95,$96,$94,$95,$96,$93,$9B,$01,$91,$92,$93,$91,$92 ; BB50
        .byte   $9B,$69,$D1,$95,$96,$9B,$95,$96,$CE,$69,$69,$69,$69,$69,$69,$69 ; BB60
        .byte   $B9,$CB,$D2,$D3,$A0,$8E,$9D,$9E,$BE,$CC,$BD,$BF,$8F,$90,$A1,$A2 ; BB70
; layout $16
        .byte   $16,$01,$16,$01,$16,$16,$D4,$16,$02,$02,$02,$04,$03,$04,$D5,$16 ; BB80
        .byte   $07,$29,$07,$09,$08,$09,$D6,$05,$12,$12,$12,$11,$1E,$5C,$16,$05 ; BB90
        .byte   $07,$07,$29,$09,$D7,$16,$05,$14,$12,$12,$12,$5C,$16,$16,$05,$14 ; BBA0
        .byte   $D8,$D8,$D8,$D9,$D9,$D9,$D9,$D9,$90,$90,$90,$90,$90,$90,$90,$90 ; BBB0
; layout $17
        .byte   $06,$DA,$DB,$DC,$DB,$DB,$DC,$16,$06,$54,$29,$09,$29,$07,$09,$16 ; BBC0
        .byte   $01,$01,$12,$11,$4B,$1D,$35,$16,$14,$06,$01,$09,$29,$07,$09,$16 ; BBD0
        .byte   $14,$06,$16,$01,$0A,$07,$09,$16,$14,$14,$14,$06,$01,$12,$11,$16 ; BBE0
        .byte   $16,$4E,$16,$4E,$16,$01,$DD,$16,$16,$4C,$16,$4C,$16,$16,$D4,$16 ; BBF0
; layout $18
        .byte   $14,$06,$DE,$DE,$05,$14,$14,$06,$14,$06,$DE,$DF,$E0,$E0,$E1,$05 ; BC00
        .byte   $14,$06,$E2,$E1,$E3,$E3,$14,$14,$14,$14,$E4,$00,$00,$00,$00,$4A ; BC10
        .byte   $E0,$E5,$E6,$04,$04,$03,$04,$04,$E7,$29,$29,$09,$09,$08,$09,$09 ; BC20
        .byte   $01,$66,$01,$E8,$01,$01,$E8,$01,$06,$67,$16,$01,$16,$16,$01,$16 ; BC30
; layout $19
        .byte   $DE,$E9,$DE,$E9,$DE,$DE,$DE,$48,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$EA ; BC40
        .byte   $00,$00,$00,$00,$00,$00,$00,$48,$04,$02,$02,$04,$02,$04,$03,$05 ; BC50
        .byte   $11,$12,$12,$11,$12,$11,$24,$EB,$09,$01,$01,$EC,$EC,$01,$1E,$ED ; BC60
        .byte   $01,$E1,$16,$EE,$EE,$16,$01,$01,$06,$16,$16,$EE,$EE,$16,$05,$14 ; BC70
; layout $1A
        .byte   $16,$4E,$16,$4E,$16,$4E,$05,$06,$16,$4C,$16,$4C,$16,$4C,$05,$06 ; BC80
        .byte   $16,$4E,$16,$4E,$16,$4E,$05,$06,$06,$4C,$16,$4C,$16,$4C,$05,$06 ; BC90
        .byte   $EF,$E5,$EF,$E5,$EF,$E5,$EF,$EB,$35,$4B,$35,$4B,$35,$4B,$35,$ED ; BCA0
        .byte   $F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F1,$F1,$F1,$F1,$F1,$F1,$F1,$F1 ; BCB0
; layout $1B
        .byte   $69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69 ; BCC0
        .byte   $69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69 ; BCD0
        .byte   $69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69 ; BCE0
        .byte   $F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F1,$F1,$F1,$F1,$F1,$F1,$F1,$F1 ; BCF0
; layout $1C
        .byte   $69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69 ; BD00
        .byte   $69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69 ; BD10
        .byte   $69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69 ; BD20
        .byte   $97,$98,$94,$93,$93,$16,$16,$93,$99,$9A,$F2,$F3,$93,$16,$16,$93 ; BD30
; layout $1D
        .byte   $69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$F4,$69 ; BD40
        .byte   $69,$69,$69,$69,$69,$69,$F5,$F6,$69,$69,$69,$69,$69,$F7,$F8,$F9 ; BD50
        .byte   $69,$69,$69,$69,$69,$FA,$FB,$FC,$69,$69,$69,$69,$69,$FA,$FB,$FC ; BD60
        .byte   $F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F1,$F1,$F1,$F1,$F1,$F1,$F1,$F1 ; BD70
; layout $1E
        .byte   $69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69 ; BD80
        .byte   $69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69 ; BD90
        .byte   $69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69 ; BDA0
        .byte   $69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69 ; BDB0
; layout $1F
        .byte   $69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69 ; BDC0
        .byte   $69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69 ; BDD0
        .byte   $69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69 ; BDE0
        .byte   $69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69 ; BDF0
; layout $20
        .byte   $00,$00,$00,$01,$00,$00,$00,$00,$01,$02,$02,$03,$04,$02,$04,$05 ; BE00
        .byte   $06,$07,$07,$08,$09,$07,$09,$05,$06,$0A,$0A,$08,$09,$07,$09,$05 ; BE10
        .byte   $0B,$0C,$0C,$0D,$0E,$0F,$01,$01,$06,$02,$02,$10,$11,$12,$04,$05 ; BE20
        .byte   $01,$01,$01,$01,$01,$01,$13,$05,$14,$14,$14,$14,$14,$14,$15,$16 ; BE30
; layout $21
        .byte   $69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69 ; BE40
        .byte   $69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69 ; BE50
        .byte   $69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69 ; BE60
        .byte   $69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69 ; BE70
; layout $22
        .byte   $69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69 ; BE80
        .byte   $69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69 ; BE90
        .byte   $69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69 ; BEA0
        .byte   $69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69 ; BEB0
; layout $23
        .byte   $69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69 ; BEC0
        .byte   $69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69 ; BED0
        .byte   $69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69 ; BEE0
        .byte   $69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69 ; BEF0
; layout $24
        .byte   $69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69 ; BF00
        .byte   $69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69 ; BF10
        .byte   $69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69 ; BF20
        .byte   $69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69 ; BF30
; layout $25
        .byte   $69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69 ; BF40
        .byte   $69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69 ; BF50
        .byte   $69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69 ; BF60
        .byte   $69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69 ; BF70
; layout $26
        .byte   $69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69 ; BF80
        .byte   $69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69 ; BF90
        .byte   $69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69 ; BFA0
        .byte   $69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69 ; BFB0
; layout $27
        .byte   $69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69 ; BFC0
        .byte   $69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69 ; BFD0
        .byte   $69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69 ; BFE0
        .byte   $69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69 ; BFF0
