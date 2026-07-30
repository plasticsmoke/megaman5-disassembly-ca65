.setcpu "6502"
.include "include/hardware.inc"
.include "include/zeropage.inc"
.include "include/constants.inc"
.include "include/fixed_bank.inc"

.segment "BANK1B"

; =============================================================================
; BANK $1B (mapped at $8000) — player engine: the state machine ($8000,
; 36 states via the $8045/$8069 tables), weapon fire dispatch ($9571),
; spawn engine ($988A) and per-stage enemy spawn tables.
;
; Player states (one header block per handler below):
;   $00 ground        $01 air           $02 slide          $03 ladder
;   $04 jetski ride   $05 nop           $06 hurt           $07 dead
;   $08 teleport-in   $09 carried off   $0A re-enter top   $0B carried path
;   $0C nop           $0D jetski mount  $0E jetski dock    $0F victory orbs
;   $10 teleport-out  $11 walk-to-mark  $12 cutscene pose  $13 drop-in+restore
;   $14 castle clear  $15 warp depart   $16 warp arrive    $17 rematch won
;   $18 boss defeated $19 stand frozen  $1A/$1B nop        $1C-$23 ending
;
; Weapon fire handlers ($9571/$9581, id in $32):
;   $0 P.Buster    $1 Water Wave  $2 Gyro Attack  $3 Crystal Eye
;   $4 Napalm Bomb $5 Super Arrow $6 Power Stone  $7 Gravity Hold
;   $8 Charge Kick $9 Star Crash  $A Rush Coil    $B Rush Jet   $C Beat
; =============================================================================
L0000           := $0000
L0010           := $0010
L0111           := $0111
L0221           := $0221
L04B4           := $04B4
L066F           := $066F
L09B4           := $09B4
L0AB4           := $0AB4
L0BB4           := $0BB4
L0CB4           := $0CB4
L0DB4           := $0DB4
L0EB4           := $0EB4
L0FB4           := $0FB4
L1626           := $1626
L1727           := $1727
L2074           := $2074
L211C           := $211C
L2321           := $2321
L4F4C           := $4F4C
L6503           := $6503
L714F           := $714F
LD460           := $D460
LD7DB           := $D7DB
LD8A2           := $D8A2
LD8C7           := $D8C7
LE747           := $E747
LE8DE           := $E8DE
LE904           := $E904
LEA03           := $EA03
LEA34           := $EA34
; ----------------------------------------------------------------------------
        lda     $30                             ; 8000 A5 30                    .0
        cmp     #$06                            ; 8002 C9 06                    ..
        bcc     L800C                           ; 8004 90 06                    ..
        lda     #$00                            ; 8006 A9 00                    ..
        sta     $33                             ; 8008 85 33                    .3
        sta     $34                             ; 800A 85 34                    .4
L800C:  lda     $54                             ; 800C A5 54                    .T
        bne     L8038                           ; 800E D0 28                    .(
        lda     $33                             ; 8010 A5 33                    .3
        beq     L8025                           ; 8012 F0 11                    ..
        dec     $33                             ; 8014 C6 33                    .3
        bne     L8025                           ; 8016 D0 0D                    ..
        lda     $0558                           ; 8018 AD 58 05                 .X.
        sec                                     ; 801B 38                       8
        sbc     $34                             ; 801C E5 34                    .4
        sta     $0558                           ; 801E 8D 58 05                 .X.
        lda     #$00                            ; 8021 A9 00                    ..
        sta     $34                             ; 8023 85 34                    .4
L8025:  ldx     #$00                            ; 8025 A2 00                    ..
        stx     $37                             ; 8027 86 37                    .7
        ldy     $30                             ; 8029 A4 30                    .0
        lda     player_state_lo,y                         ; 802B B9 45 80                 .E.
        sta     L0000                           ; 802E 85 00                    ..
        lda     player_state_hi,y                         ; 8030 B9 69 80                 .i.
        sta     $01                             ; 8033 85 01                    ..
        jmp     (L0000)                         ; 8035 6C 00 00                 l..

; ----------------------------------------------------------------------------
L8038:  lda     #$00                            ; 8038 A9 00                    ..
        sta     $0570                           ; 803A 8D 70 05                 .p.
        dec     $54                             ; 803D C6 54                    .T
        bne     L8044                           ; 803F D0 03                    ..
        jsr     player_palette_load                           ; 8041 20 BF F3                  ..
L8044:  rts                                     ; 8044 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; PLAYER STATE MACHINE — $1B:8000 (called once per gameplay frame)
; $30 = state (36 handlers, dispatched via the tables below). $54 =
; damage/weapon-get freeze (counts down, restores palette). $33/$34 =
; i-frame flash timer + sub_type offset restored on expiry.
; State $00 = idle/ground (below): runs the jump/fall handler ($8215)
; for shared physics, then handles jump input via a gravity-flip-aware
; direction mask ($9067,y with y = gravity_flip).
; =============================================================================
player_state_lo:
        .byte   $8D,$15,$99,$40,$DF,$5E,$5F,$09,$39,$D4,$06,$2E,$95,$96,$E3,$59,$07,$64,$98,$CA,$8B,$F3,$39,$5E,$E4,$4A,$63,$63,$64,$03,$59,$04,$7B,$EE,$96,$D0   ; 8045
player_state_hi:
        .byte   $80,$82,$82,$83,$83,$84,$84,$85,$85,$85,$86,$86,$86,$86,$86,$87,$88,$88,$88,$88,$89,$89,$8A,$8A,$8A,$8B,$8B,$8B,$8B,$8C,$8C,$8D,$8D,$8D,$8E,$8E   ; 8069
; --- state $00: idle / ground ------------------------------------------------
player_st_ground:
        jsr     player_st_air                   ; 808D 20 15 82  shared air physics
        bcc     L8044                           ; 8090 90 B2                    ..
        lda     $14                             ; 8092 A5 14                    ..
        and     #$80                            ; 8094 29 80                    ).
        bne     L809B                           ; 8096 D0 03                    ..
        jmp     L814A                           ; 8098 4C 4A 81                 LJ.

; ----------------------------------------------------------------------------
L809B:  lda     $16                             ; 809B A5 16                    ..
        ldy     $AF                             ; 809D A4 AF                    ..
        and     slide_input_mask,y                         ; 809F 39 67 90                 9g.
        bne     L80C2                           ; 80A2 D0 1E                    ..
L80A4:  lda     $AF                             ; 80A4 A5 AF                    ..
        bne     L80B5                           ; 80A6 D0 0D                    ..
        lda     #$00                            ; 80A8 A9 00                    ..
        sta     $03D8                           ; 80AA 8D D8 03                 ...
        lda     #$05                            ; 80AD A9 05                    ..
        sta     $03F0                           ; 80AF 8D F0 03                 ...
        jmp     player_st_air                           ; 80B2 4C 15 82                 L..

; ----------------------------------------------------------------------------
L80B5:  lda     #$00                            ; 80B5 A9 00                    ..
        sta     $03D8                           ; 80B7 8D D8 03                 ...
        lda     #$FB                            ; 80BA A9 FB                    ..
        sta     $03F0                           ; 80BC 8D F0 03                 ...
        jmp     player_st_air                           ; 80BF 4C 15 82                 L..

; ----------------------------------------------------------------------------
L80C2:  lda     #$02                            ; 80C2 A9 02                    ..
        sta     $08                             ; 80C4 85 08                    ..
        lda     $0528                           ; 80C6 AD 28 05                 .(.
        and     #$20                            ; 80C9 29 20                    ) 
        beq     L80D1                           ; 80CB F0 04                    ..
        lda     #$01                            ; 80CD A9 01                    ..
        sta     $08                             ; 80CF 85 08                    ..
L80D1:  lda     $16                             ; 80D1 A5 16                    ..
        and     #$03                            ; 80D3 29 03                    ).
        beq     L80D9                           ; 80D5 F0 02                    ..
        sta     $08                             ; 80D7 85 08                    ..
L80D9:  lda     $08                             ; 80D9 A5 08                    ..
        lsr     a                               ; 80DB 4A                       J
        clc                                     ; 80DC 18                       .
        adc     #$08                            ; 80DD 69 08                    i.
        tay                                     ; 80DF A8                       .
        jsr     probe_vert                           ; 80E0 20 4F 98                  O.
        lda     L0010                           ; 80E3 A5 10                    ..
        and     #$10                            ; 80E5 29 10                    ).
        bne     L814A                           ; 80E7 D0 61                    .a
        lda     $08                             ; 80E9 A5 08                    ..
        sta     $31                             ; 80EB 85 31                    .1
        sta     $0420                           ; 80ED 8D 20 04                 . .
        lda     #$1A                            ; 80F0 A9 1A                    ..
        sta     $35                             ; 80F2 85 35                    .5
        lda     #$02                            ; 80F4 A9 02                    ..
        sta     $30                             ; 80F6 85 30                    .0
        lda     #$80                            ; 80F8 A9 80                    ..
        sta     $03A8                           ; 80FA 8D A8 03                 ...
        lda     #$02                            ; 80FD A9 02                    ..
        sta     $03C0                           ; 80FF 8D C0 03                 ...
        lda     #$10                            ; 8102 A9 10                    ..
        ldy     $32                             ; 8104 A4 32                    .2
        cpy     #$08                            ; 8106 C0 08                    ..
        bne     L811C                           ; 8108 D0 12                    ..
        ldy     $B8                             ; 810A A4 B8                    ..
        cpy     #$80                            ; 810C C0 80                    ..
        beq     L811C                           ; 810E F0 0C                    ..
        lda     #$01                            ; 8110 A9 01                    ..
        jsr     weapon_deduct                           ; 8112 20 3D 95                  =.
        lda     #$23                            ; 8115 A9 23                    .#
        jsr     queue_sound                           ; 8117 20 5D EC                  ].
        lda     #$B0                            ; 811A A9 B0                    ..
L811C:  jsr     entity_set_subtype                           ; 811C 20 98 EA                  ..
        ldy     $AF                             ; 811F A4 AF                    ..
        lda     $0378                           ; 8121 AD 78 03                 .x.
        clc                                     ; 8124 18                       .
        adc     ynudge_tbl,y                         ; 8125 79 F1 8E                 y..
        sta     $0378                           ; 8128 8D 78 03                 .x.
        lda     #$00                            ; 812B A9 00                    ..
        sta     $34                             ; 812D 85 34                    .4
        sta     $33                             ; 812F 85 33                    .3
        lda     $0305                           ; 8131 AD 05 03                 ...
        bne     L8147                           ; 8134 D0 11                    ..
        lda     #$17                            ; 8136 A9 17                    ..
        ldy     #$05                            ; 8138 A0 05                    ..
        jsr     entity_init_pos                           ; 813A 20 A4 EA                  ..
        lda     #$01                            ; 813D A9 01                    ..
        sta     $0305                           ; 813F 8D 05 03                 ...
        lda     #$00                            ; 8142 A9 00                    ..
        sta     $040D                           ; 8144 8D 0D 04                 ...
L8147:  jmp     L82C8                           ; 8147 4C C8 82                 L..

; ----------------------------------------------------------------------------
L814A:  ldy     $AF                             ; 814A A4 AF                    ..
        lda     $16                             ; 814C A5 16                    ..
        and     climb_down_mask,y                         ; 814E 39 F7 8E                 9..
        beq     L8186                           ; 8151 F0 33                    .3
        lda     $49                             ; 8153 A5 49                    .I
        cmp     #$40                            ; 8155 C9 40                    .@
        bne     L8186                           ; 8157 D0 2D                    .-
        lda     $11                             ; 8159 A5 11                    ..
        and     #$F0                            ; 815B 29 F0                    ).
        ora     ladder_grab_yofs,y                         ; 815D 19 F9 8E                 ...
        sta     $0378                           ; 8160 8D 78 03                 .x.
        lda     $0330                           ; 8163 AD 30 03                 .0.
        and     #$F0                            ; 8166 29 F0                    ).
        ora     #$08                            ; 8168 09 08                    ..
        sta     $0330                           ; 816A 8D 30 03                 .0.
        lda     #$4C                            ; 816D A9 4C                    .L
        sta     $03D8                           ; 816F 8D D8 03                 ...
        lda     #$01                            ; 8172 A9 01                    ..
        sta     $03F0                           ; 8174 8D F0 03                 ...
        lda     #$03                            ; 8177 A9 03                    ..
        sta     $30                             ; 8179 85 30                    .0
        lda     #$14                            ; 817B A9 14                    ..
        clc                                     ; 817D 18                       .
        adc     $34                             ; 817E 65 34                    e4
        jsr     entity_set_subtype                           ; 8180 20 98 EA                  ..
        jmp     L820E                           ; 8183 4C 0E 82                 L..

; ----------------------------------------------------------------------------
L8186:  lda     $0558                           ; 8186 AD 58 05                 .X.
        cmp     #$04                            ; 8189 C9 04                    ..
        beq     L81B5                           ; 818B F0 28                    .(
        cmp     #$05                            ; 818D C9 05                    ..
        beq     L81B5                           ; 818F F0 24                    .$
        cmp     #$0D                            ; 8191 C9 0D                    ..
        beq     L819D                           ; 8193 F0 08                    ..
        cmp     #$0E                            ; 8195 C9 0E                    ..
        beq     L819D                           ; 8197 F0 04                    ..
        cmp     #$0F                            ; 8199 C9 0F                    ..
        bne     L81BF                           ; 819B D0 22                    ."
L819D:  lda     $0540                           ; 819D AD 40 05                 .@.
        beq     L820E                           ; 81A0 F0 6C                    .l
        lda     $16                             ; 81A2 A5 16                    ..
        and     #$03                            ; 81A4 29 03                    ).
        beq     L81E8                           ; 81A6 F0 40                    .@
        sta     $31                             ; 81A8 85 31                    .1
        lda     #$04                            ; 81AA A9 04                    ..
        clc                                     ; 81AC 18                       .
        adc     $34                             ; 81AD 65 34                    e4
        jsr     entity_set_subtype                           ; 81AF 20 98 EA                  ..
        jmp     L81CF                           ; 81B2 4C CF 81                 L..

; ----------------------------------------------------------------------------
L81B5:  lda     $16                             ; 81B5 A5 16                    ..
        and     #$03                            ; 81B7 29 03                    ).
        beq     L81E1                           ; 81B9 F0 26                    .&
        and     $31                             ; 81BB 25 31                    %1
        bne     L81CF                           ; 81BD D0 10                    ..
L81BF:  lda     $16                             ; 81BF A5 16                    ..
        and     #$03                            ; 81C1 29 03                    ).
        beq     L81E8                           ; 81C3 F0 23                    .#
        sta     $31                             ; 81C5 85 31                    .1
        lda     #$0D                            ; 81C7 A9 0D                    ..
        clc                                     ; 81C9 18                       .
        adc     $34                             ; 81CA 65 34                    e4
        jsr     entity_set_subtype                           ; 81CC 20 98 EA                  ..
L81CF:  lda     $04C8                           ; 81CF AD C8 04                 ...
        bne     L8201                           ; 81D2 D0 2D                    .-
        lda     $31                             ; 81D4 A5 31                    .1
        sta     $0420                           ; 81D6 8D 20 04                 . .
        ldy     #$00                            ; 81D9 A0 00                    ..
        jsr     entity_horiz_dispatch                           ; 81DB 20 3F EA                  ?.
        jmp     L820E                           ; 81DE 4C 0E 82                 L..

; ----------------------------------------------------------------------------
L81E1:  lda     #$0D                            ; 81E1 A9 0D                    ..
        clc                                     ; 81E3 18                       .
        adc     $34                             ; 81E4 65 34                    e4
        bne     L820B                           ; 81E6 D0 23                    .#
L81E8:  ldy     $73                             ; 81E8 A4 73                    .s
        beq     L8201                           ; 81EA F0 15                    ..
        lda     $34                             ; 81EC A5 34                    .4
        bne     L8201                           ; 81EE D0 11                    ..
        lda     $0558,y                         ; 81F0 B9 58 05                 .X.
        cmp     #$52                            ; 81F3 C9 52                    .R
        bne     L8201                           ; 81F5 D0 0A                    ..
        lda     #$1B                            ; 81F7 A9 1B                    ..
        cmp     $0558                           ; 81F9 CD 58 05                 .X.
        beq     L8214                           ; 81FC F0 16                    ..
        jmp     entity_set_subtype                           ; 81FE 4C 98 EA                 L..

; ----------------------------------------------------------------------------
L8201:  lda     #$01                            ; 8201 A9 01                    ..
        clc                                     ; 8203 18                       .
        adc     $34                             ; 8204 65 34                    e4
        cmp     $0558                           ; 8206 CD 58 05                 .X.
        beq     L820E                           ; 8209 F0 03                    ..
L820B:  jsr     entity_set_subtype                           ; 820B 20 98 EA                  ..
L820E:  jsr     player_weapon_fire                           ; 820E 20 6B 90                  k.
        jsr     ladder_grab_up                           ; 8211 20 F8 95                  ..
L8214:  rts                                     ; 8214 60                       `

; ----------------------------------------------------------------------------
player_st_air:  ldy     #$00                            ; 8215 A0 00                    ..
        jsr     entity_gravity_collide                           ; 8217 20 B7 E7                  ..
        jsr     landing_surface_fx                           ; 821A 20 DF 97                  ..
        jsr     player_env_effects                           ; 821D 20 4C 96                  L.
        php                                     ; 8220 08                       .
        bcc     L823A                           ; 8221 90 17                    ..
        lda     $26                             ; 8223 A5 26                    .&
        cmp     #$0E                            ; 8225 C9 0E                    ..
        bne     L823A                           ; 8227 D0 11                    ..
        lda     $0348                           ; 8229 AD 48 03                 .H.
        cmp     #$04                            ; 822C C9 04                    ..
        bne     L823A                           ; 822E D0 0A                    ..
        lda     #$80                            ; 8230 A9 80                    ..
        sta     $03D8                           ; 8232 8D D8 03                 ...
        lda     #$FD                            ; 8235 A9 FD                    ..
        sta     $03F0                           ; 8237 8D F0 03                 ...
L823A:  plp                                     ; 823A 28                       (
        bcs     L826E                           ; 823B B0 31                    .1
        lda     #$07                            ; 823D A9 07                    ..
        cmp     $0558                           ; 823F CD 58 05                 .X.
        beq     L824E                           ; 8242 F0 0A                    ..
        clc                                     ; 8244 18                       .
        adc     $34                             ; 8245 65 34                    e4
        jsr     entity_set_subtype                           ; 8247 20 98 EA                  ..
        lda     #$01                            ; 824A A9 01                    ..
        sta     $30                             ; 824C 85 30                    .0
L824E:  lda     $AF                             ; 824E A5 AF                    ..
        beq     L8259                           ; 8250 F0 07                    ..
        lda     $03F0                           ; 8252 AD F0 03                 ...
        bpl     L8283                           ; 8255 10 2C                    .,
        bmi     L825E                           ; 8257 30 05                    0.
L8259:  lda     $03F0                           ; 8259 AD F0 03                 ...
        bmi     L8283                           ; 825C 30 25                    0%
L825E:  lda     $16                             ; 825E A5 16                    ..
        and     #$80                            ; 8260 29 80                    ).
        bne     L8283                           ; 8262 D0 1F                    ..
        lda     #$00                            ; 8264 A9 00                    ..
        sta     $03D8                           ; 8266 8D D8 03                 ...
        sta     $03F0                           ; 8269 8D F0 03                 ...
        beq     L8283                           ; 826C F0 15                    ..
L826E:  lda     $30                             ; 826E A5 30                    .0
        beq     L8298                           ; 8270 F0 26                    .&
        lda     #$00                            ; 8272 A9 00                    ..
        sta     $30                             ; 8274 85 30                    .0
        lda     #$04                            ; 8276 A9 04                    ..
        clc                                     ; 8278 18                       .
        adc     $34                             ; 8279 65 34                    e4
        jsr     entity_set_subtype                           ; 827B 20 98 EA                  ..
        lda     #$1B                            ; 827E A9 1B                    ..
        jsr     queue_sound                           ; 8280 20 5D EC                  ].
L8283:  lda     $16                             ; 8283 A5 16                    ..
        and     #$03                            ; 8285 29 03                    ).
        sta     $0420                           ; 8287 8D 20 04                 . .
        sta     $31                             ; 828A 85 31                    .1
        ldy     #$00                            ; 828C A0 00                    ..
        jsr     entity_horiz_dispatch                           ; 828E 20 3F EA                  ?.
        jsr     player_weapon_fire                           ; 8291 20 6B 90                  k.
        jsr     ladder_grab_up                           ; 8294 20 F8 95                  ..
        clc                                     ; 8297 18                       .
L8298:  rts                                     ; 8298 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; state $02 — SLIDE ($8299; entered from ground with A+Down, timer $35=$1A)
; A press (Down released) probes headroom (probe_horiz) and pops into a jump.
; Head blocked (probe bit $10) extends the slide past the timer; L/R can
; reverse direction. Expiry restores stand/walk with a slide_yvel y-kick.
; =============================================================================
player_st_slide:
        ldy     #$04                            ; 8299 A0 04                    ..
        jsr     entity_gravity_collide                           ; 829B 20 B7 E7                  ..
        jsr     player_env_effects                           ; 829E 20 4C 96                  L.
        bcc     L830C                           ; 82A1 90 69                    .i
        lda     $14                             ; 82A3 A5 14                    ..
        and     #$80                            ; 82A5 29 80                    ).
        beq     L82C8                           ; 82A7 F0 1F                    ..
        lda     $16                             ; 82A9 A5 16                    ..
        and     #$04                            ; 82AB 29 04                    ).
        bne     L82C8                           ; 82AD D0 19                    ..
        lda     #$02                            ; 82AF A9 02                    ..
        ora     $AF                             ; 82B1 05 AF                    ..
        tay                                     ; 82B3 A8                       .
        jsr     probe_horiz                           ; 82B4 20 45 98                  E.
        lda     L0010                           ; 82B7 A5 10                    ..
        bne     L82C8                           ; 82B9 D0 0D                    ..
        lda     #$4C                            ; 82BB A9 4C                    .L
        sta     $03A8                           ; 82BD 8D A8 03                 ...
        lda     #$01                            ; 82C0 A9 01                    ..
        sta     $03C0                           ; 82C2 8D C0 03                 ...
        jmp     L80A4                           ; 82C5 4C A4 80                 L..

; ----------------------------------------------------------------------------
L82C8:  lda     $16                             ; 82C8 A5 16                    ..
        and     #$03                            ; 82CA 29 03                    ).
        beq     L82DF                           ; 82CC F0 11                    ..
        sta     L0000                           ; 82CE 85 00                    ..
        and     $31                             ; 82D0 25 31                    %1
        bne     L82DF                           ; 82D2 D0 0B                    ..
        lda     L0000                           ; 82D4 A5 00                    ..
        sta     $31                             ; 82D6 85 31                    .1
        sta     $0420                           ; 82D8 8D 20 04                 . .
        lda     #$00                            ; 82DB A9 00                    ..
        sta     $35                             ; 82DD 85 35                    .5
L82DF:  lda     $AF                             ; 82DF A5 AF                    ..
        asl     a                               ; 82E1 0A                       .
        adc     #$04                            ; 82E2 69 04                    i.
        tay                                     ; 82E4 A8                       .
        jsr     entity_horiz_dispatch                           ; 82E5 20 3F EA                  ?.
        bcs     L82F2                           ; 82E8 B0 08                    ..
        lda     $35                             ; 82EA A5 35                    .5
        beq     L82F2                           ; 82EC F0 04                    ..
        dec     $35                             ; 82EE C6 35                    .5
        bne     L832D                           ; 82F0 D0 3B                    .;
L82F2:  lda     #$02                            ; 82F2 A9 02                    ..
        ora     $AF                             ; 82F4 05 AF                    ..
        tay                                     ; 82F6 A8                       .
        jsr     tile_collide_horiz                           ; 82F7 20 A1 C4                  ..
        lda     L0010                           ; 82FA A5 10                    ..
        and     #$10                            ; 82FC 29 10                    ).
        bne     L832D                           ; 82FE D0 2D                    .-
        ldy     $AF                             ; 8300 A4 AF                    ..
        lda     $0378                           ; 8302 AD 78 03                 .x.
        sec                                     ; 8305 38                       8
        sbc     ynudge_tbl,y                         ; 8306 F9 F1 8E                 ...
        sta     $0378                           ; 8309 8D 78 03                 .x.
L830C:  lda     #$00                            ; 830C A9 00                    ..
        sta     $30                             ; 830E 85 30                    .0
        lda     #$4C                            ; 8310 A9 4C                    .L
        sta     $03A8                           ; 8312 8D A8 03                 ...
        lda     #$01                            ; 8315 A9 01                    ..
        sta     $03C0                           ; 8317 8D C0 03                 ...
        lda     #$04                            ; 831A A9 04                    ..
        jsr     entity_set_subtype                           ; 831C 20 98 EA                  ..
        ldy     $AF                             ; 831F A4 AF                    ..
        lda     slide_yvel_sub,y                         ; 8321 B9 F3 8E                 ...
        sta     $03D8                           ; 8324 8D D8 03                 ...
        lda     slide_yvel_px,y                         ; 8327 B9 F5 8E                 ...
        sta     $03F0                           ; 832A 8D F0 03                 ...
L832D:  lda     $9D                             ; 832D A5 9D                    ..
        and     #$07                            ; 832F 29 07                    ).
        sta     L0000                           ; 8331 85 00                    ..
        lda     $38                             ; 8333 A5 38                    .8
        beq     L833F                           ; 8335 F0 08                    ..
        and     #$F8                            ; 8337 29 F8                    ).
        clc                                     ; 8339 18                       .
        adc     L0000                           ; 833A 65 00                    e.
        jsr     charge_flash_update                           ; 833C 20 4C 91                  L.
L833F:  rts                                     ; 833F 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; state $03 — LADDER CLIMB ($8340; from ground via Up/Down over a ladder)
; Up/Down moves (entity_vert_dispatch); fires first via player_weapon_fire with the
; climb-shoot pose. Reaching the ladder end aligns x to the rung center
; (poses $0A climb / $14 top-exit); A with no vertical input lets go.
; =============================================================================
player_st_ladder:
        jsr     player_weapon_fire                           ; 8340 20 6B 90                  k.
        lda     $34                             ; 8343 A5 34                    .4
        bne     L833F                           ; 8345 D0 F8                    ..
        lda     $16                             ; 8347 A5 16                    ..
        and     #$0C                            ; 8349 29 0C                    ).
        bne     L8354                           ; 834B D0 07                    ..
        lda     #$00                            ; 834D A9 00                    ..
        sta     $0570                           ; 834F 8D 70 05                 .p.
        beq     L836C                           ; 8352 F0 18                    ..
L8354:  sta     $0420                           ; 8354 8D 20 04                 . .
        sta     $31                             ; 8357 85 31                    .1
        ldy     #$00                            ; 8359 A0 00                    ..
        jsr     entity_vert_dispatch                           ; 835B 20 52 EA                  R.
        bcc     L836C                           ; 835E 90 0C                    ..
        ldy     $AF                             ; 8360 A4 AF                    ..
        lda     $0420                           ; 8362 AD 20 04                 . .
        and     climb_down_mask,y                         ; 8365 39 F7 8E                 9..
        bne     L83C8                           ; 8368 D0 5E                    .^
        beq     L83B7                           ; 836A F0 4B                    .K
L836C:  lda     #$02                            ; 836C A9 02                    ..
        ora     $AF                             ; 836E 05 AF                    ..
        tay                                     ; 8370 A8                       .
        jsr     probe_vert                           ; 8371 20 4F 98                  O.
        ldy     #$02                            ; 8374 A0 02                    ..
L8376:  lda     $48,y                           ; 8376 B9 48 00                 .H.
        cmp     #$20                            ; 8379 C9 20                    . 
        beq     L8386                           ; 837B F0 09                    ..
        cmp     #$40                            ; 837D C9 40                    .@
        beq     L8386                           ; 837F F0 05                    ..
        dey                                     ; 8381 88                       .
        bpl     L8376                           ; 8382 10 F2                    ..
        bmi     L83C8                           ; 8384 30 42                    0B
L8386:  lda     $0330                           ; 8386 AD 30 03                 .0.
        and     #$F0                            ; 8389 29 F0                    ).
        ora     #$08                            ; 838B 09 08                    ..
        sta     $0330                           ; 838D 8D 30 03                 .0.
        lda     $0528                           ; 8390 AD 28 05                 .(.
        and     #$EF                            ; 8393 29 EF                    ).
        sta     $0528                           ; 8395 8D 28 05                 .(.
        ldx     #$0A                            ; 8398 A2 0A                    ..
        lda     $49                             ; 839A A5 49                    .I
        bne     L83A9                           ; 839C D0 0B                    ..
        lda     $AF                             ; 839E A5 AF                    ..
        asl     a                               ; 83A0 0A                       .
        tay                                     ; 83A1 A8                       .
        lda     $48,y                           ; 83A2 B9 48 00                 .H.
        bne     L83A9                           ; 83A5 D0 02                    ..
        ldx     #$14                            ; 83A7 A2 14                    ..
L83A9:  txa                                     ; 83A9 8A                       .
        ldx     #$00                            ; 83AA A2 00                    ..
        clc                                     ; 83AC 18                       .
        adc     $34                             ; 83AD 65 34                    e4
        cmp     $0558                           ; 83AF CD 58 05                 .X.
        beq     L83BC                           ; 83B2 F0 08                    ..
        jmp     entity_set_subtype                           ; 83B4 4C 98 EA                 L..

; ----------------------------------------------------------------------------
L83B7:  lda     #$00                            ; 83B7 A9 00                    ..
        sta     $0570                           ; 83B9 8D 70 05                 .p.
L83BC:  lda     $16                             ; 83BC A5 16                    ..
        and     #$0C                            ; 83BE 29 0C                    ).
        bne     L83DE                           ; 83C0 D0 1C                    ..
        lda     $14                             ; 83C2 A5 14                    ..
        and     #$80                            ; 83C4 29 80                    ).
        beq     L83DE                           ; 83C6 F0 16                    ..
L83C8:  lda     #$00                            ; 83C8 A9 00                    ..
        sta     $30                             ; 83CA 85 30                    .0
        jsr     entity_stop_y                           ; 83CC 20 1E EA                  ..
        lda     #$02                            ; 83CF A9 02                    ..
        sta     $31                             ; 83D1 85 31                    .1
        lda     $0528                           ; 83D3 AD 28 05                 .(.
        and     #$20                            ; 83D6 29 20                    ) 
        beq     L83DE                           ; 83D8 F0 04                    ..
        lda     #$01                            ; 83DA A9 01                    ..
        sta     $31                             ; 83DC 85 31                    .1
L83DE:  rts                                     ; 83DE 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; state $04 — JET-SKI RIDE (Wave Man stage; from state $0D at ride screen
; $0E) — ride poses $1D (surface)/$1E (air): A hops (+5 yvel, cut on
; release), Right/Left picks jetski_thrust ($01.4C fwd / $01.00 back).
; At x_screen $40 hands off to state $0E for the dock approach.
; =============================================================================
player_st_jetski:
        ldy     #$00                            ; 83DF A0 00                    ..
        jsr     entity_gravity_collide                           ; 83E1 20 B7 E7                  ..
        php                                     ; 83E4 08                       .
        lda     #$1E                            ; 83E5 A9 1E                    ..
        sta     L0010                           ; 83E7 85 10                    ..
        bcc     L83FF                           ; 83E9 90 14                    ..
        dec     L0010                           ; 83EB C6 10                    ..
        lda     $14                             ; 83ED A5 14                    ..
        and     #$80                            ; 83EF 29 80                    ).
        beq     L83FF                           ; 83F1 F0 0C                    ..
        lda     #$00                            ; 83F3 A9 00                    ..
        sta     $03D8                           ; 83F5 8D D8 03                 ...
        lda     #$05                            ; 83F8 A9 05                    ..
        sta     $03F0                           ; 83FA 8D F0 03                 ...
        inc     L0010                           ; 83FD E6 10                    ..
L83FF:  lda     L0010                           ; 83FF A5 10                    ..
        cmp     $0558                           ; 8401 CD 58 05                 .X.
        beq     L8409                           ; 8404 F0 03                    ..
        jsr     entity_set_subtype                           ; 8406 20 98 EA                  ..
L8409:  lda     $03F0                           ; 8409 AD F0 03                 ...
        bmi     L841C                           ; 840C 30 0E                    0.
        lda     $16                             ; 840E A5 16                    ..
        and     #$80                            ; 8410 29 80                    ).
        bne     L841C                           ; 8412 D0 08                    ..
        lda     #$00                            ; 8414 A9 00                    ..
        sta     $03D8                           ; 8416 8D D8 03                 ...
        sta     $03F0                           ; 8419 8D F0 03                 ...
L841C:  lda     $16                             ; 841C A5 16                    ..
        and     #$03                            ; 841E 29 03                    ).
        beq     L8442                           ; 8420 F0 20                    . 
        sta     $0420                           ; 8422 8D 20 04                 . .
        and     #$02                            ; 8425 29 02                    ).
        tay                                     ; 8427 A8                       .
        lda     jetski_thrust_sub,y                         ; 8428 B9 43 8F                 .C.
        sta     $03A8                           ; 842B 8D A8 03                 ...
        lda     jetski_thrust_px,y                         ; 842E B9 44 8F                 .D.
        sta     $03C0                           ; 8431 8D C0 03                 ...
        jsr     entity_facing_dispatch                           ; 8434 20 65 EA                  e.
        lda     $0528                           ; 8437 AD 28 05                 .(.
        ora     #$20                            ; 843A 09 20                    . 
        sta     $0528                           ; 843C 8D 28 05                 .(.
        jsr     clamp_x_to_screen                           ; 843F 20 59 98                  Y.
L8442:  jsr     fire_buster                           ; 8442 20 E3 90                  ..
        plp                                     ; 8445 28                       (
        bcc     L845D                           ; 8446 90 15                    ..
        lda     $0348                           ; 8448 AD 48 03                 .H.
        cmp     #$40                            ; 844B C9 40                    .@
        bne     L845D                           ; 844D D0 0E                    ..
        lda     #$0E                            ; 844F A9 0E                    ..
        sta     $30                             ; 8451 85 30                    .0
        lda     #$00                            ; 8453 A9 00                    ..
        sta     $03A8                           ; 8455 8D A8 03                 ...
        lda     #$01                            ; 8458 A9 01                    ..
        sta     $03C0                           ; 845A 8D C0 03                 ...
L845D:  rts                                     ; 845D 60                       `

; ----------------------------------------------------------------------------
; --- state $05 — no-op ---
        rts                                     ; 845E 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; state $06 — HURT / KNOCKBACK ($845F; the damage engine $1C:82F4 sets it
; with the knockback dir in ent_angle, prior state saved in ent_var6)
; Drifts back at $00.80/frame ($00.40 steering into it); a slot-5 grab
; actor (sub_type $12) tracks the player x. At anim phase 9: $3C hit-stun
; i-frames, then restores the ent_var6 state (2 = slide resume, pose $10;
; ride = pose $1D).
; =============================================================================
player_st_hurt:
        ldy     $04B0                           ; 845F AC B0 04                 ...
        jsr     entity_gravity_collide                           ; 8462 20 B7 E7                  ..
        lda     #$80                            ; 8465 A9 80                    ..
        sta     $03A8                           ; 8467 8D A8 03                 ...
        lda     #$00                            ; 846A A9 00                    ..
        sta     $03C0                           ; 846C 8D C0 03                 ...
        lda     $16                             ; 846F A5 16                    ..
        and     #$03                            ; 8471 29 03                    ).
        beq     L848D                           ; 8473 F0 18                    ..
        eor     #$03                            ; 8475 49 03                    I.
        asl     a                               ; 8477 0A                       .
        asl     a                               ; 8478 0A                       .
        asl     a                               ; 8479 0A                       .
        asl     a                               ; 847A 0A                       .
        and     #$20                            ; 847B 29 20                    ) 
        sta     L0000                           ; 847D 85 00                    ..
        lda     $0528                           ; 847F AD 28 05                 .(.
        and     #$20                            ; 8482 29 20                    ) 
        cmp     L0000                           ; 8484 C5 00                    ..
        bne     L848D                           ; 8486 D0 05                    ..
        lda     #$40                            ; 8488 A9 40                    .@
        sta     $03A8                           ; 848A 8D A8 03                 ...
L848D:  ldy     $04B0                           ; 848D AC B0 04                 ...
        lda     $0528                           ; 8490 AD 28 05                 .(.
        pha                                     ; 8493 48                       H
        and     #$20                            ; 8494 29 20                    ) 
        bne     L849E                           ; 8496 D0 06                    ..
        jsr     entity_move_right                           ; 8498 20 C7 E6                  ..
        jmp     L84A2                           ; 849B 4C A2 84                 L..

; ----------------------------------------------------------------------------
L849E:  iny                                     ; 849E C8                       .
        jsr     entity_move_left                           ; 849F 20 08 E7                  ..
L84A2:  lda     $0498                           ; 84A2 AD 98 04                 ...
        cmp     #$04                            ; 84A5 C9 04                    ..
        bne     L84AC                           ; 84A7 D0 03                    ..
        jsr     clamp_x_to_screen                           ; 84A9 20 59 98                  Y.
L84AC:  lda     $055D                           ; 84AC AD 5D 05                 .].
        cmp     #$12                            ; 84AF C9 12                    ..
        bne     L84BF                           ; 84B1 D0 0C                    ..
        lda     $0330                           ; 84B3 AD 30 03                 .0.
        sta     $0335                           ; 84B6 8D 35 03                 .5.
        lda     $0348                           ; 84B9 AD 48 03                 .H.
        sta     $034D                           ; 84BC 8D 4D 03                 .M.
L84BF:  pla                                     ; 84BF 68                       h
        sta     $0528                           ; 84C0 8D 28 05                 .(.
        lda     $0540                           ; 84C3 AD 40 05                 .@.
        cmp     #$09                            ; 84C6 C9 09                    ..
        bne     L8508                           ; 84C8 D0 3E                    .>
        lda     #$3C                            ; 84CA A9 3C                    .<
        sta     $05B8                           ; 84CC 8D B8 05                 ...
        lda     #$4C                            ; 84CF A9 4C                    .L
        sta     $03A8                           ; 84D1 8D A8 03                 ...
        lda     #$01                            ; 84D4 A9 01                    ..
        sta     $03C0                           ; 84D6 8D C0 03                 ...
        lda     $0498                           ; 84D9 AD 98 04                 ...
        sta     $30                             ; 84DC 85 30                    .0
        beq     L8508                           ; 84DE F0 28                    .(
        cmp     #$02                            ; 84E0 C9 02                    ..
        beq     L84E9                           ; 84E2 F0 05                    ..
        lda     #$1D                            ; 84E4 A9 1D                    ..
        jmp     entity_set_subtype                           ; 84E6 4C 98 EA                 L..

; ----------------------------------------------------------------------------
L84E9:  ldy     $AF                             ; 84E9 A4 AF                    ..
        lda     $0378                           ; 84EB AD 78 03                 .x.
        clc                                     ; 84EE 18                       .
        adc     ynudge_tbl,y                         ; 84EF 79 F1 8E                 y..
        sta     $0378                           ; 84F2 8D 78 03                 .x.
        lda     #$80                            ; 84F5 A9 80                    ..
        sta     $03A8                           ; 84F7 8D A8 03                 ...
        lda     #$02                            ; 84FA A9 02                    ..
        sta     $03C0                           ; 84FC 8D C0 03                 ...
        lda     #$10                            ; 84FF A9 10                    ..
        jsr     entity_set_subtype                           ; 8501 20 98 EA                  ..
        lda     #$00                            ; 8504 A9 00                    ..
        sta     $35                             ; 8506 85 35                    .5
L8508:  rts                                     ; 8508 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; state $07 — DEAD ($8509; set with a $012C-frame timer in ent_param/
; ent_var5 by the damage engine $1C:8351 and the fall-death check $E025)
; On expiry spawns the game-over/flow task ($DDE8) and kills the gameplay
; tasks. player_exit_to_flow is shared by states $14/$23.
; =============================================================================
player_st_dead:  lda     $0468                           ; 8509 AD 68 04                 .h.
        sec                                     ; 850C 38                       8
        sbc     #$01                            ; 850D E9 01                    ..
        sta     $0468                           ; 850F 8D 68 04                 .h.
        lda     $0480                           ; 8512 AD 80 04                 ...
        sbc     #$00                            ; 8515 E9 00                    ..
        sta     $0480                           ; 8517 8D 80 04                 ...
        bcs     L8538                           ; 851A B0 1C                    ..
player_exit_to_flow:  lda     #$DD                            ; 851C A9 DD                    ..
        sta     $94                             ; 851E 85 94                    ..
        lda     #$E8                            ; 8520 A9 E8                    ..
        sta     $93                             ; 8522 85 93                    ..
        lda     #$02                            ; 8524 A9 02                    ..
        jsr     task_create                           ; 8526 20 F3 FE                  ..
        lda     #$03                            ; 8529 A9 03                    ..
        jsr     task_kill                           ; 852B 20 03 FF                  ..
        lda     #$01                            ; 852E A9 01                    ..
        jsr     task_kill                           ; 8530 20 03 FF                  ..
        lda     #$00                            ; 8533 A9 00                    ..
        jmp     task_exit                           ; 8535 4C 0B FF                 L..

; ----------------------------------------------------------------------------
L8538:  rts                                     ; 8538 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; state $08 — TELEPORT-IN ($8539; set by the stage-start task at $DE5C)
; Beam (sub_type $13) descends 8 px/f after the flash anim; below y=$70
; probes ground; landing plays the materialize anim then state $00.
; Boss-rush stage (bank $0E) screen 3 lands at the hub slot x=$50.
; =============================================================================
player_st_teleport_in:
        lda     #$00                            ; 8539 A9 00                    ..
        sta     $52                             ; 853B 85 52                    .R
        sta     $55                             ; 853D 85 55                    .U
        sta     $05B8                           ; 853F 8D B8 05                 ...
        lda     #$13                            ; 8542 A9 13                    ..
        cmp     $0558                           ; 8544 CD 58 05                 .X.
        beq     L857C                           ; 8547 F0 33                    .3
        ldy     $0540                           ; 8549 AC 40 05                 .@.
        cpy     #$0F                            ; 854C C0 0F                    ..
        bne     L85CE                           ; 854E D0 7E                    .~
        jsr     entity_set_subtype                           ; 8550 20 98 EA                  ..
        lda     #$00                            ; 8553 A9 00                    ..
        sta     $03D8                           ; 8555 8D D8 03                 ...
        lda     #$08                            ; 8558 A9 08                    ..
        sta     $03F0                           ; 855A 8D F0 03                 ...
        lda     $0528                           ; 855D AD 28 05                 .(.
        ora     #$20                            ; 8560 09 20                    . 
        sta     $0528                           ; 8562 8D 28 05                 .(.
        lda     #$00                            ; 8565 A9 00                    ..
        sta     $0378                           ; 8567 8D 78 03                 .x.
        lda     $26                             ; 856A A5 26                    .&
        cmp     #$0E                            ; 856C C9 0E                    ..
        bne     L857C                           ; 856E D0 0C                    ..
        lda     $0348                           ; 8570 AD 48 03                 .H.
        cmp     #$03                            ; 8573 C9 03                    ..
        bne     L857C                           ; 8575 D0 05                    ..
        lda     #$50                            ; 8577 A9 50                    .P
        sta     $0330                           ; 8579 8D 30 03                 .0.
L857C:  lda     $0378                           ; 857C AD 78 03                 .x.
        cmp     #$70                            ; 857F C9 70                    .p
        bcc     L8592                           ; 8581 90 0F                    ..
        ldy     #$02                            ; 8583 A0 02                    ..
        jsr     probe_vert                           ; 8585 20 4F 98                  O.
        lda     $49                             ; 8588 A5 49                    .I
        sta     $53                             ; 858A 85 53                    .S
        lda     L0010                           ; 858C A5 10                    ..
        and     #$10                            ; 858E 29 10                    ).
        beq     L859B                           ; 8590 F0 09                    ..
L8592:  jsr     LEA03                           ; 8592 20 03 EA                  ..
        jsr     entity_move_down_collide                           ; 8595 20 2A E9                  *.
        jmp     L85C9                           ; 8598 4C C9 85                 L..

; ----------------------------------------------------------------------------
L859B:  jsr     LEA03                           ; 859B 20 03 EA                  ..
        ldy     #$00                            ; 859E A0 00                    ..
        jsr     LE747                           ; 85A0 20 47 E7                  G.
        bcc     L85C9                           ; 85A3 90 24                    .$
        lda     $0540                           ; 85A5 AD 40 05                 .@.
        bne     L85B6                           ; 85A8 D0 0C                    ..
        lda     $0570                           ; 85AA AD 70 05                 .p.
        cmp     #$01                            ; 85AD C9 01                    ..
        bne     L85B6                           ; 85AF D0 05                    ..
        lda     #$2D                            ; 85B1 A9 2D                    .-
        jsr     queue_sound                           ; 85B3 20 5D EC                  ].
L85B6:  lda     $0540                           ; 85B6 AD 40 05                 .@.
        cmp     #$04                            ; 85B9 C9 04                    ..
        bne     L85CE                           ; 85BB D0 11                    ..
        lda     #$01                            ; 85BD A9 01                    ..
        jsr     entity_set_subtype                           ; 85BF 20 98 EA                  ..
        lda     #$00                            ; 85C2 A9 00                    ..
        sta     $30                             ; 85C4 85 30                    .0
        jsr     entity_stop_y                           ; 85C6 20 1E EA                  ..
L85C9:  lda     #$00                            ; 85C9 A9 00                    ..
        sta     $0570                           ; 85CB 8D 70 05                 .p.
L85CE:  lda     $0378                           ; 85CE AD 78 03                 .x.
        sta     $3E                             ; 85D1 85 3E                    .>
        rts                                     ; 85D3 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; state $09 — CARRIED OFF-SCREEN ($85D4; set by final-stage code $0A:A683
; when a press actor pins the player, position slaved to it) — hurt pose,
; y motion only; past y=$E0 fades out and advances to state $0A to
; re-enter from the top of the screen.
; =============================================================================
player_st_carried_off:
        lda     #$07                            ; 85D4 A9 07                    ..
        cmp     $0558                           ; 85D6 CD 58 05                 .X.
        beq     L85E4                           ; 85D9 F0 09                    ..
        jsr     entity_set_subtype                           ; 85DB 20 98 EA                  ..
        lda     #$00                            ; 85DE A9 00                    ..
        sta     $34                             ; 85E0 85 34                    .4
        sta     $33                             ; 85E2 85 33                    .3
L85E4:  jsr     entity_process_y_vel                           ; 85E4 20 68 E9                  h.
        lda     #$E0                            ; 85E7 A9 E0                    ..
        cmp     $0378                           ; 85E9 CD 78 03                 .x.
        bcs     L8605                           ; 85EC B0 17                    ..
        lda     #$24                            ; 85EE A9 24                    .$
        sta     $0528                           ; 85F0 8D 28 05                 .(.
        inc     $30                             ; 85F3 E6 30                    .0
        lda     #$E8                            ; 85F5 A9 E8                    ..
        sta     $0378                           ; 85F7 8D 78 03                 .x.
        lda     #$00                            ; 85FA A9 00                    ..
        sta     $95                             ; 85FC 85 95                    ..
        jsr     palette_fade_out                           ; 85FE 20 F1 C3                  ..
        lda     #$00                            ; 8601 A9 00                    ..
        inc     $95                             ; 8603 E6 95                    ..
L8605:  rts                                     ; 8605 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; state $0A — RE-ENTER FROM TOP ($8606) — reloads the player sprite
; palette (reenter_palette), CHR $F0, fades in at x=$30/y=$00, state $00.
; =============================================================================
player_st_reenter_top:
        ldy     #$0F                            ; 8606 A0 0F                    ..
L8608:  lda     reenter_palette,y                         ; 8608 B9 FB 8E                 ...
        sta     $0620,y                         ; 860B 99 20 06                 . .
        dey                                     ; 860E 88                       .
        bpl     L8608                           ; 860F 10 F7                    ..
        lda     #$F0                            ; 8611 A9 F0                    ..
        sta     $EB                             ; 8613 85 EB                    ..
        lda     #$00                            ; 8615 A9 00                    ..
        sta     $95                             ; 8617 85 95                    ..
        sta     $30                             ; 8619 85 30                    .0
        sta     $0378                           ; 861B 8D 78 03                 .x.
        jsr     palette_fade_in                           ; 861E 20 EB C3                  ..
        inc     $95                             ; 8621 E6 95                    ..
        lda     #$20                            ; 8623 A9 20                    . 
        sta     $0528                           ; 8625 8D 28 05                 .(.
        lda     #$30                            ; 8628 A9 30                    .0
        sta     $0330                           ; 862A 8D 30 03                 .0.
        rts                                     ; 862D 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; state $0B — SCRIPTED CARRY ($862E; set by $0A:A6A9) — hurt pose, towed
; along the carry_path waypoint script (screen/x/y/dir records, sound $1F
; per turn); the $FF terminator releases the player with a leap, state $00.
; =============================================================================
player_st_carried_path:
        lda     #$07                            ; 862E A9 07                    ..
        cmp     $0558                           ; 8630 CD 58 05                 .X.
        beq     L863E                           ; 8633 F0 09                    ..
        jsr     entity_set_subtype                           ; 8635 20 98 EA                  ..
        lda     #$00                            ; 8638 A9 00                    ..
        sta     $34                             ; 863A 85 34                    .4
        sta     $33                             ; 863C 85 33                    .3
L863E:  jsr     entity_facing_dispatch                           ; 863E 20 65 EA                  e.
        jsr     entity_vert_dispatch_raw                           ; 8641 20 86 EA                  ..
        ldy     $0468                           ; 8644 AC 68 04                 .h.
        lda     carry_path_scr,y                         ; 8647 B9 0B 8F                 ...
        cmp     $0348                           ; 864A CD 48 03                 .H.
        bne     L8694                           ; 864D D0 45                    .E
        lda     carry_path_x,y                         ; 864F B9 0C 8F                 ...
        cmp     $0330                           ; 8652 CD 30 03                 .0.
        bne     L8694                           ; 8655 D0 3D                    .=
        lda     carry_path_y,y                         ; 8657 B9 0D 8F                 ...
        cmp     $0378                           ; 865A CD 78 03                 .x.
        bne     L8694                           ; 865D D0 35                    .5
        lda     carry_path_dir,y                         ; 865F B9 0E 8F                 ...
        bmi     L8674                           ; 8662 30 10                    0.
        sta     $0420                           ; 8664 8D 20 04                 . .
        iny                                     ; 8667 C8                       .
        iny                                     ; 8668 C8                       .
        iny                                     ; 8669 C8                       .
        iny                                     ; 866A C8                       .
        sty     $0468                           ; 866B 8C 68 04                 .h.
        lda     #$1F                            ; 866E A9 1F                    ..
        jsr     queue_sound                           ; 8670 20 5D EC                  ].
        rts                                     ; 8673 60                       `

; ----------------------------------------------------------------------------
L8674:  lda     $0528                           ; 8674 AD 28 05                 .(.
        and     #$EF                            ; 8677 29 EF                    ).
        sta     $0528                           ; 8679 8D 28 05                 .(.
        lda     #$00                            ; 867C A9 00                    ..
        sta     $30                             ; 867E 85 30                    .0
        lda     #$4C                            ; 8680 A9 4C                    .L
        sta     $03A8                           ; 8682 8D A8 03                 ...
        lda     #$01                            ; 8685 A9 01                    ..
        sta     $03C0                           ; 8687 8D C0 03                 ...
        lda     #$00                            ; 868A A9 00                    ..
        sta     $03D8                           ; 868C 8D D8 03                 ...
        lda     #$FC                            ; 868F A9 FC                    ..
        sta     $03F0                           ; 8691 8D F0 03                 ...
L8694:  rts                                     ; 8694 60                       `

; ----------------------------------------------------------------------------
; --- state $0C — no-op ---
        rts                                     ; 8695 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; state $0D — JET-SKI MOUNT (set by Wave Man stage code $05:A4B7)
; Walks in (pose 4/7), hops at x>=$A0 onto the bike; once riding (pose
; $1D) waits for x_screen $0E then switches to ride state $04.
; =============================================================================
player_st_jetski_mount:
        lda     $0558                           ; 8696 AD 58 05                 .X.
        cmp     #$1D                            ; 8699 C9 1D                    ..
        beq     L86CF                           ; 869B F0 32                    .2
        ldy     #$00                            ; 869D A0 00                    ..
        jsr     entity_gravity_collide                           ; 869F 20 B7 E7                  ..
        lda     #$04                            ; 86A2 A9 04                    ..
        bcs     L86A8                           ; 86A4 B0 02                    ..
        lda     #$07                            ; 86A6 A9 07                    ..
L86A8:  php                                     ; 86A8 08                       .
        cmp     $0558                           ; 86A9 CD 58 05                 .X.
        beq     L86B7                           ; 86AC F0 09                    ..
        jsr     entity_set_subtype                           ; 86AE 20 98 EA                  ..
        lda     #$00                            ; 86B1 A9 00                    ..
        sta     $34                             ; 86B3 85 34                    .4
        sta     $33                             ; 86B5 85 33                    .3
L86B7:  jsr     LE8DE                           ; 86B7 20 DE E8                  ..
        plp                                     ; 86BA 28                       (
        bcc     L86CE                           ; 86BB 90 11                    ..
        lda     $0330                           ; 86BD AD 30 03                 .0.
        cmp     #$A0                            ; 86C0 C9 A0                    ..
        bcc     L86CE                           ; 86C2 90 0A                    ..
        lda     #$00                            ; 86C4 A9 00                    ..
        sta     $03D8                           ; 86C6 8D D8 03                 ...
        lda     #$05                            ; 86C9 A9 05                    ..
        sta     $03F0                           ; 86CB 8D F0 03                 ...
L86CE:  rts                                     ; 86CE 60                       `

; ----------------------------------------------------------------------------
L86CF:  lda     #$00                            ; 86CF A9 00                    ..
        sta     $0570                           ; 86D1 8D 70 05                 .p.
        jsr     LE8DE                           ; 86D4 20 DE E8                  ..
        lda     $0348                           ; 86D7 AD 48 03                 .H.
        cmp     #$0E                            ; 86DA C9 0E                    ..
        bne     L86E2                           ; 86DC D0 04                    ..
        lda     #$04                            ; 86DE A9 04                    ..
        sta     $30                             ; 86E0 85 30                    .0
L86E2:  rts                                     ; 86E2 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; state $0E — JET-SKI DOCK ($86E3; from ride state $04 at x_screen $40)
; Ride physics continue (gravity table $17 while mounted); at x>=$4C on
; the dock screen clamps x and spawns the dock actor (type $1E, falling);
; screen $41 dismounts to state $00 with a $01.4C walk-off.
; =============================================================================
player_st_jetski_dismount:
        ldy     #$00                            ; 86E3 A0 00                    ..
        lda     $0558                           ; 86E5 AD 58 05                 .X.
        cmp     #$1D                            ; 86E8 C9 1D                    ..
        bne     L86EE                           ; 86EA D0 02                    ..
        ldy     #$17                            ; 86EC A0 17                    ..
L86EE:  jsr     entity_gravity_collide                           ; 86EE 20 B7 E7                  ..
        ror     L0000                           ; 86F1 66 00                    f.
        lda     $0558                           ; 86F3 AD 58 05                 .X.
        cmp     #$1D                            ; 86F6 C9 1D                    ..
        beq     L870A                           ; 86F8 F0 10                    ..
        lda     #$04                            ; 86FA A9 04                    ..
        rol     L0000                           ; 86FC 26 00                    &.
        bcs     L8702                           ; 86FE B0 02                    ..
        lda     #$07                            ; 8700 A9 07                    ..
L8702:  cmp     $0558                           ; 8702 CD 58 05                 .X.
        beq     L870A                           ; 8705 F0 03                    ..
        jsr     entity_set_subtype                           ; 8707 20 98 EA                  ..
L870A:  jsr     LE8DE                           ; 870A 20 DE E8                  ..
        lda     $0558                           ; 870D AD 58 05                 .X.
        cmp     #$1D                            ; 8710 C9 1D                    ..
        bne     L8743                           ; 8712 D0 2F                    ./
        lda     $0348                           ; 8714 AD 48 03                 .H.
        cmp     #$40                            ; 8717 C9 40                    .@
        bne     L8743                           ; 8719 D0 28                    .(
        lda     #$4C                            ; 871B A9 4C                    .L
        cmp     $0330                           ; 871D CD 30 03                 .0.
        bcs     L8743                           ; 8720 B0 21                    .!
        sta     $0330                           ; 8722 8D 30 03                 .0.
        jsr     find_free_slot_y                           ; 8725 20 6F F1                  o.
        bcs     L8758                           ; 8728 B0 2E                    ..
        lda     #$10                            ; 872A A9 10                    ..
        jsr     entity_init_pos                           ; 872C 20 A4 EA                  ..
        lda     #$1E                            ; 872F A9 1E                    ..
        sta     $0300,y                         ; 8731 99 00 03                 ...
        lda     #$07                            ; 8734 A9 07                    ..
        jsr     entity_set_subtype                           ; 8736 20 98 EA                  ..
        lda     #$00                            ; 8739 A9 00                    ..
        sta     $03D8                           ; 873B 8D D8 03                 ...
        lda     #$05                            ; 873E A9 05                    ..
        sta     $03F0                           ; 8740 8D F0 03                 ...
L8743:  lda     $0348                           ; 8743 AD 48 03                 .H.
        cmp     #$41                            ; 8746 C9 41                    .A
        bne     L8758                           ; 8748 D0 0E                    ..
        lda     #$00                            ; 874A A9 00                    ..
        sta     $30                             ; 874C 85 30                    .0
        lda     #$4C                            ; 874E A9 4C                    .L
        sta     $03A8                           ; 8750 8D A8 03                 ...
        lda     #$01                            ; 8753 A9 01                    ..
        sta     $03C0                           ; 8755 8D C0 03                 ...
L8758:  rts                                     ; 8758 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; state $0F — VICTORY: WEAPON ORBS ($8759; from state $18 on robot-master
; stages) — walks to x=$80, leaps; at y=$78 spawns the converging orb ring
; (type $4D, orb_spawn records, groups of 4, jingle $4B); when ent_var5
; wraps to $80, state $10 teleport-out.
; =============================================================================
player_st_victory_orbs:
        ldy     #$00                            ; 8759 A0 00                    ..
        jsr     entity_gravity_collide                           ; 875B 20 B7 E7                  ..
        bcc     L8794                           ; 875E 90 34                    .4
        ldy     #$00                            ; 8760 A0 00                    ..
        jsr     entity_horiz_dispatch                           ; 8762 20 3F EA                  ?.
        ldy     #$80                            ; 8765 A0 80                    ..
        cpy     $0330                           ; 8767 CC 30 03                 .0.
        beq     L8779                           ; 876A F0 0D                    ..
        lda     $0420                           ; 876C AD 20 04                 . .
        and     #$01                            ; 876F 29 01                    ).
        bne     L8777                           ; 8771 D0 04                    ..
        bcs     L8779                           ; 8773 B0 04                    ..
        bcc     L8793                           ; 8775 90 1C                    ..
L8777:  bcs     L8793                           ; 8777 B0 1A                    ..
L8779:  sty     $0330                           ; 8779 8C 30 03                 .0.
        lda     #$00                            ; 877C A9 00                    ..
        sta     $03D8                           ; 877E 8D D8 03                 ...
        lda     #$08                            ; 8781 A9 08                    ..
        sta     $03F0                           ; 8783 8D F0 03                 ...
        lda     #$07                            ; 8786 A9 07                    ..
        jsr     entity_set_subtype                           ; 8788 20 98 EA                  ..
        lda     #$00                            ; 878B A9 00                    ..
        sta     $0468                           ; 878D 8D 68 04                 .h.
        sta     $0480                           ; 8790 8D 80 04                 ...
L8793:  rts                                     ; 8793 60                       `

; ----------------------------------------------------------------------------
L8794:  lda     $03F0                           ; 8794 AD F0 03                 ...
        bpl     L8793                           ; 8797 10 FA                    ..
        lda     #$78                            ; 8799 A9 78                    .x
        cmp     $0378                           ; 879B CD 78 03                 .x.
        bcs     L8793                           ; 879E B0 F3                    ..
        sta     $0378                           ; 87A0 8D 78 03                 .x.
        lda     $0468                           ; 87A3 AD 68 04                 .h.
        bne     L8801                           ; 87A6 D0 59                    .Y
        lda     $0480                           ; 87A8 AD 80 04                 ...
        cmp     #$80                            ; 87AB C9 80                    ..
        bne     L87B6                           ; 87AD D0 07                    ..
        lda     #$10                            ; 87AF A9 10                    ..
        sta     $30                             ; 87B1 85 30                    .0
        jmp     entity_stop_y                           ; 87B3 4C 1E EA                 L..

; ----------------------------------------------------------------------------
L87B6:  jsr     find_free_slot_y                           ; 87B6 20 6F F1                  o.
        bcs     L87E4                           ; 87B9 B0 29                    .)
        lda     #$19                            ; 87BB A9 19                    ..
        ldx     #$00                            ; 87BD A2 00                    ..
        jsr     entity_init_pos                           ; 87BF 20 A4 EA                  ..
        lda     #$4D                            ; 87C2 A9 4D                    .M
        sta     $0300,y                         ; 87C4 99 00 03                 ...
        lda     $0480                           ; 87C7 AD 80 04                 ...
        and     #$1F                            ; 87CA 29 1F                    ).
        tax                                     ; 87CC AA                       .
        lda     orb_spawn_x,x                         ; 87CD BD 5F 8F                 ._.
        sta     $0330,y                         ; 87D0 99 30 03                 .0.
        lda     orb_spawn_y,x                         ; 87D3 BD 60 8F                 .`.
        sta     $0378,y                         ; 87D6 99 78 03                 .x.
        lda     orb_spawn_phase,x                         ; 87D9 BD 61 8F                 .a.
        sta     $0480,y                         ; 87DC 99 80 04                 ...
        lda     #$08                            ; 87DF A9 08                    ..
        sta     $0498,y                         ; 87E1 99 98 04                 ...
L87E4:  inc     $0480                           ; 87E4 EE 80 04                 ...
        inc     $0480                           ; 87E7 EE 80 04                 ...
        inc     $0480                           ; 87EA EE 80 04                 ...
        inc     $0480                           ; 87ED EE 80 04                 ...
        lda     $0480                           ; 87F0 AD 80 04                 ...
        and     #$0F                            ; 87F3 29 0F                    ).
        bne     L87B6                           ; 87F5 D0 BF                    ..
        lda     #$18                            ; 87F7 A9 18                    ..
        sta     $0468                           ; 87F9 8D 68 04                 .h.
        lda     #$4B                            ; 87FC A9 4B                    .K
        jsr     queue_sound                           ; 87FE 20 5D EC                  ].
L8801:  dec     $0468                           ; 8801 CE 68 04                 .h.
        ldx     #$00                            ; 8804 A2 00                    ..
        rts                                     ; 8806 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; state $10 — TELEPORT OUT ($8807) — grounded: beam-up pose (sub_type $13),
; sound $35, clears gravity flip; when the flash anim ends rises; once
; y_screen goes nonzero runs the dead-state exit path (timer + flow task).
; =============================================================================
player_st_teleport_out:
        lda     $0390                           ; 8807 AD 90 03                 ...
        beq     L880F                           ; 880A F0 03                    ..
        jmp     player_st_dead                           ; 880C 4C 09 85                 L..

; ----------------------------------------------------------------------------
L880F:  lda     $0558                           ; 880F AD 58 05                 .X.
        cmp     #$13                            ; 8812 C9 13                    ..
        beq     L8846                           ; 8814 F0 30                    .0
        ldy     #$00                            ; 8816 A0 00                    ..
        jsr     entity_gravity_collide                           ; 8818 20 B7 E7                  ..
        bcc     L8863                           ; 881B 90 46                    .F
        lda     #$00                            ; 881D A9 00                    ..
        sta     $03D8                           ; 881F 8D D8 03                 ...
        lda     #$08                            ; 8822 A9 08                    ..
        sta     $03F0                           ; 8824 8D F0 03                 ...
        lda     #$13                            ; 8827 A9 13                    ..
        jsr     entity_set_subtype                           ; 8829 20 98 EA                  ..
        lda     #$04                            ; 882C A9 04                    ..
        sta     $0540                           ; 882E 8D 40 05                 .@.
        lda     #$35                            ; 8831 A9 35                    .5
        jsr     queue_sound                           ; 8833 20 5D EC                  ].
        lda     $AF                             ; 8836 A5 AF                    ..
        beq     L8846                           ; 8838 F0 0C                    ..
        lda     #$00                            ; 883A A9 00                    ..
        sta     $AF                             ; 883C 85 AF                    ..
        lda     $0528                           ; 883E AD 28 05                 .(.
        and     #$BF                            ; 8841 29 BF                    ).
        sta     $0528                           ; 8843 8D 28 05                 .(.
L8846:  lda     $0540                           ; 8846 AD 40 05                 .@.
        bne     L8863                           ; 8849 D0 18                    ..
        sta     $0570                           ; 884B 8D 70 05                 .p.
        jsr     LEA03                           ; 884E 20 03 EA                  ..
        jsr     entity_move_up_nofacing                           ; 8851 20 4A E9                  J.
        lda     $0390                           ; 8854 AD 90 03                 ...
        beq     L8863                           ; 8857 F0 0A                    ..
        lda     #$3C                            ; 8859 A9 3C                    .<
        sta     $0468                           ; 885B 8D 68 04                 .h.
        lda     #$00                            ; 885E A9 00                    ..
        sta     $0480                           ; 8860 8D 80 04                 ...
L8863:  rts                                     ; 8863 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; state $11 — WALK TO MARK ($8864; boss-rush arrival, $03:A047 saves the
; health target in ent_param for state $13) — after the ent_var5 delay
; walks to x=$84, stands, then state $12.
; =============================================================================
player_st_walk_to_mark:
        lda     $0480                           ; 8864 AD 80 04                 ...
        beq     L886E                           ; 8867 F0 05                    ..
        dec     $0480                           ; 8869 CE 80 04                 ...
        bne     L8897                           ; 886C D0 29                    .)
L886E:  ldy     #$00                            ; 886E A0 00                    ..
        jsr     entity_gravity_collide                           ; 8870 20 B7 E7                  ..
        lda     #$04                            ; 8873 A9 04                    ..
        bcs     L8879                           ; 8875 B0 02                    ..
        lda     #$07                            ; 8877 A9 07                    ..
L8879:  cmp     $0558                           ; 8879 CD 58 05                 .X.
        beq     L8881                           ; 887C F0 03                    ..
        jsr     entity_set_subtype                           ; 887E 20 98 EA                  ..
L8881:  jsr     LE8DE                           ; 8881 20 DE E8                  ..
        lda     #$84                            ; 8884 A9 84                    ..
        cmp     $0330                           ; 8886 CD 30 03                 .0.
        bcs     L8897                           ; 8889 B0 0C                    ..
        sta     $0330                           ; 888B 8D 30 03                 .0.
        lda     #$01                            ; 888E A9 01                    ..
        jsr     entity_set_subtype                           ; 8890 20 98 EA                  ..
        lda     #$12                            ; 8893 A9 12                    ..
        sta     $30                             ; 8895 85 30                    .0
L8897:  rts                                     ; 8897 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; state $12 — CUTSCENE POSE ($8898) — sub_type $0D: walk left to x=$5C
; (flags |= $20) then stand; sub_type $11: stand once anim phase 9 hits.
; =============================================================================
player_st_cutscene_pose:
        lda     $0558                           ; 8898 AD 58 05                 .X.
        cmp     #$11                            ; 889B C9 11                    ..
        beq     L88C2                           ; 889D F0 23                    .#
        cmp     #$0D                            ; 889F C9 0D                    ..
        bne     L8897                           ; 88A1 D0 F4                    ..
        lda     $0540                           ; 88A3 AD 40 05                 .@.
        bne     L8897                           ; 88A6 D0 EF                    ..
        jsr     LE904                           ; 88A8 20 04 E9                  ..
        lda     $0528                           ; 88AB AD 28 05                 .(.
        ora     #$20                            ; 88AE 09 20                    . 
        sta     $0528                           ; 88B0 8D 28 05                 .(.
        lda     #$5C                            ; 88B3 A9 5C                    .\
        cmp     $0330                           ; 88B5 CD 30 03                 .0.
        bcc     L8897                           ; 88B8 90 DD                    ..
        sta     $0330                           ; 88BA 8D 30 03                 .0.
L88BD:  lda     #$01                            ; 88BD A9 01                    ..
        jmp     entity_set_subtype                           ; 88BF 4C 98 EA                 L..

; ----------------------------------------------------------------------------
L88C2:  lda     $0540                           ; 88C2 AD 40 05                 .@.
        cmp     #$09                            ; 88C5 C9 09                    ..
        beq     L88BD                           ; 88C7 F0 F4                    ..
L88C9:  rts                                     ; 88C9 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; state $13 — DROP-IN + RESTORE ($88CA; set by boss-rush code $03:A418
; with a down-left drift) — lands at x=$40, wipes actors; refills health
; to the target saved in ent_param (tick $26); then plays the hatch_rec
; list (tile rewrite + hatch actor + chime $2B, one per 4th frame) and
; returns to state $00.
; =============================================================================
player_st_dropin_restore:
        ldy     #$00                            ; 88CA A0 00                    ..
        jsr     entity_gravity_collide                           ; 88CC 20 B7 E7                  ..
        bcs     L88E2                           ; 88CF B0 11                    ..
        ldy     #$01                            ; 88D1 A0 01                    ..
        jmp     entity_move_left                           ; 88D3 4C 08 E7                 L..

; ----------------------------------------------------------------------------
        lda     #$40                            ; 88D6 A9 40                    .@
        cmp     $0330                           ; 88D8 CD 30 03                 .0.
        bcs     L88C9                           ; 88DB B0 EC                    ..
        sta     $0330                           ; 88DD 8D 30 03                 .0.
        bcc     L88C9                           ; 88E0 90 E7                    ..
L88E2:  lda     #$40                            ; 88E2 A9 40                    .@
        sta     $0330                           ; 88E4 8D 30 03                 .0.
        lda     $0528                           ; 88E7 AD 28 05                 .(.
        ora     #$20                            ; 88EA 09 20                    . 
        sta     $0528                           ; 88EC 8D 28 05                 .(.
        lda     #$01                            ; 88EF A9 01                    ..
        cmp     $0558                           ; 88F1 CD 58 05                 .X.
        beq     L88FF                           ; 88F4 F0 09                    ..
        jsr     entity_set_subtype                           ; 88F6 20 98 EA                  ..
        ldy     $0480                           ; 88F9 AC 80 04                 ...
        jmp     entity_wipe_y                           ; 88FC 4C FE F2                 L..

; ----------------------------------------------------------------------------
L88FF:  lda     $9D                             ; 88FF A5 9D                    ..
        and     #$03                            ; 8901 29 03                    ).
        bne     L88C9                           ; 8903 D0 C4                    ..
        lda     $0468                           ; 8905 AD 68 04                 .h.
        cmp     $B0                             ; 8908 C5 B0                    ..
        beq     L8919                           ; 890A F0 0D                    ..
        lda     #$26                            ; 890C A9 26                    .&
        jsr     queue_sound                           ; 890E 20 5D EC                  ].
        inc     $B0                             ; 8911 E6 B0                    ..
        lda     #$09                            ; 8913 A9 09                    ..
        sta     $0480                           ; 8915 8D 80 04                 ...
        rts                                     ; 8918 60                       `

; ----------------------------------------------------------------------------
L8919:  lda     $0480                           ; 8919 AD 80 04                 ...
        asl     a                               ; 891C 0A                       .
        sta     L0000                           ; 891D 85 00                    ..
        asl     a                               ; 891F 0A                       .
        adc     L0000                           ; 8920 65 00                    e.
        tay                                     ; 8922 A8                       .
        ldx     $43                             ; 8923 A6 43                    .C
        lda     hatch_rec_nt0,y                         ; 8925 B9 7F 8F                 ...
        sta     $06C0,x                         ; 8928 9D C0 06                 ...
        lda     hatch_rec_nt1,y                         ; 892B B9 80 8F                 ...
        sta     $06C1,x                         ; 892E 9D C1 06                 ...
        sta     $22                             ; 8931 85 22                    ."
        lda     hatch_rec_nt2,y                         ; 8933 B9 81 8F                 ...
        sta     $06C2,x                         ; 8936 9D C2 06                 ...
        sta     L0010                           ; 8939 85 10                    ..
        lda     hatch_rec_nt3,y                         ; 893B B9 82 8F                 ...
        sta     $06C3,x                         ; 893E 9D C3 06                 ...
        sta     $11                             ; 8941 85 11                    ..
        lda     hatch_rec_y,y                         ; 8943 B9 83 8F                 ...
        sta     $02                             ; 8946 85 02                    ..
        lda     hatch_rec_x,y                         ; 8948 B9 84 8F                 ...
        sta     $03                             ; 894B 85 03                    ..
        inx                                     ; 894D E8                       .
        inx                                     ; 894E E8                       .
        inx                                     ; 894F E8                       .
        inx                                     ; 8950 E8                       .
        stx     $43                             ; 8951 86 43                    .C
        ldx     #$00                            ; 8953 A2 00                    ..
        jsr     find_free_slot_y                           ; 8955 20 6F F1                  o.
        bcs     L898A                           ; 8958 B0 30                    .0
        lda     #$2B                            ; 895A A9 2B                    .+
        jsr     queue_sound                           ; 895C 20 5D EC                  ].
        lda     #$42                            ; 895F A9 42                    .B
        jsr     entity_init_pos                           ; 8961 20 A4 EA                  ..
        lda     #$01                            ; 8964 A9 01                    ..
        sta     $0300,y                         ; 8966 99 00 03                 ...
        lda     $02                             ; 8969 A5 02                    ..
        sta     $0378,y                         ; 896B 99 78 03                 .x.
        lda     $03                             ; 896E A5 03                    ..
        sta     $0330,y                         ; 8970 99 30 03                 .0.
        lda     #$00                            ; 8973 A9 00                    ..
        sta     $0408,y                         ; 8975 99 08 04                 ...
        tya                                     ; 8978 98                       .
        tax                                     ; 8979 AA                       .
        ldy     $11                             ; 897A A4 11                    ..
        jsr     LD7DB                           ; 897C 20 DB D7                  ..
        ldx     #$00                            ; 897F A2 00                    ..
        dec     $0480                           ; 8981 CE 80 04                 ...
        bpl     L898A                           ; 8984 10 04                    ..
        lda     #$00                            ; 8986 A9 00                    ..
        sta     $30                             ; 8988 85 30                    .0
L898A:  rts                                     ; 898A 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; state $14 — CASTLE CLEAR ($898B; from state $18 on stage bank $0B) —
; converges on x=$38, stands, then state $10 + the $DDE8 flow task
; (stage exit without the orb ceremony).
; =============================================================================
player_st_castle_clear:
        ldy     #$00                            ; 898B A0 00                    ..
        jsr     entity_gravity_collide                           ; 898D 20 B7 E7                  ..
        lda     #$07                            ; 8990 A9 07                    ..
        bcc     L89C4                           ; 8992 90 30                    .0
        lda     $0330                           ; 8994 AD 30 03                 .0.
        cmp     #$38                            ; 8997 C9 38                    .8
        bcc     L89A7                           ; 8999 90 0C                    ..
        jsr     LE904                           ; 899B 20 04 E9                  ..
        lda     #$38                            ; 899E A9 38                    .8
        cmp     $0330                           ; 89A0 CD 30 03                 .0.
        bcc     L89B1                           ; 89A3 90 0C                    ..
        bcs     L89B5                           ; 89A5 B0 0E                    ..
L89A7:  jsr     LE8DE                           ; 89A7 20 DE E8                  ..
        lda     #$38                            ; 89AA A9 38                    .8
        cmp     $0330                           ; 89AC CD 30 03                 .0.
        bcc     L89B5                           ; 89AF 90 04                    ..
L89B1:  lda     #$04                            ; 89B1 A9 04                    ..
        bne     L89C4                           ; 89B3 D0 0F                    ..
L89B5:  sta     $0330                           ; 89B5 8D 30 03                 .0.
        lda     #$20                            ; 89B8 A9 20                    . 
        sta     $0528                           ; 89BA 8D 28 05                 .(.
        lda     #$01                            ; 89BD A9 01                    ..
        cmp     $0558                           ; 89BF CD 58 05                 .X.
        beq     L89D3                           ; 89C2 F0 0F                    ..
L89C4:  cmp     $0558                           ; 89C4 CD 58 05                 .X.
        beq     L89D2                           ; 89C7 F0 09                    ..
        jsr     entity_set_subtype                           ; 89C9 20 98 EA                  ..
        lda     #$00                            ; 89CC A9 00                    ..
        sta     $33                             ; 89CE 85 33                    .3
        sta     $34                             ; 89D0 85 34                    .4
L89D2:  rts                                     ; 89D2 60                       `

; ----------------------------------------------------------------------------
L89D3:  lda     #$10                            ; 89D3 A9 10                    ..
        sta     $30                             ; 89D5 85 30                    .0
        lda     #$DD                            ; 89D7 A9 DD                    ..
        sta     $94                             ; 89D9 85 94                    ..
        lda     #$E8                            ; 89DB A9 E8                    ..
        sta     $93                             ; 89DD 85 93                    ..
        lda     #$02                            ; 89DF A9 02                    ..
        jsr     task_create                           ; 89E1 20 F3 FE                  ..
        lda     #$03                            ; 89E4 A9 03                    ..
        jsr     task_kill                           ; 89E6 20 03 FF                  ..
        lda     #$01                            ; 89E9 A9 01                    ..
        jsr     task_kill                           ; 89EB 20 03 FF                  ..
        lda     #$00                            ; 89EE A9 00                    ..
        jmp     task_exit                           ; 89F0 4C 0B FF                 L..

; ----------------------------------------------------------------------------
; =============================================================================
; state $15 — WARP DEPART ($89F3; set by $03:A44E when the player steps on
; a boss-rush teleporter; $6A = pad index *4) — beams up (pose $13), then
; loads warp_dest (scroll screen/section/x/landing y), rebuilds the room
; (LD460), state $16.
; =============================================================================
player_st_warp_depart:
        lda     $0540                           ; 89F3 AD 40 05                 .@.
        bne     L8A38                           ; 89F6 D0 40                    .@
        lda     #$13                            ; 89F8 A9 13                    ..
        jsr     entity_set_subtype                           ; 89FA 20 98 EA                  ..
        lda     #$00                            ; 89FD A9 00                    ..
        sta     $03D8                           ; 89FF 8D D8 03                 ...
        lda     #$08                            ; 8A02 A9 08                    ..
        sta     $03F0                           ; 8A04 8D F0 03                 ...
        lda     #$16                            ; 8A07 A9 16                    ..
        sta     $30                             ; 8A09 85 30                    .0
        lda     $0528                           ; 8A0B AD 28 05                 .(.
        and     #$EF                            ; 8A0E 29 EF                    ).
        sta     $0528                           ; 8A10 8D 28 05                 .(.
        ldy     $6A                             ; 8A13 A4 6A                    .j
        lda     warp_dest_scr,y                         ; 8A15 B9 BB 8F                 ...
        sta     $F9                             ; 8A18 85 F9                    ..
        lda     warp_dest_sect,y                         ; 8A1A B9 BC 8F                 ...
        sta     $29                             ; 8A1D 85 29                    .)
        lda     warp_dest_x,y                         ; 8A1F B9 BD 8F                 ...
        sta     $0330                           ; 8A22 8D 30 03                 .0.
        lda     warp_dest_y,y                         ; 8A25 B9 BE 8F                 ...
        sta     $0468                           ; 8A28 8D 68 04                 .h.
        lda     #$00                            ; 8A2B A9 00                    ..
        sta     $0378                           ; 8A2D 8D 78 03                 .x.
        jsr     LD460                           ; 8A30 20 60 D4                  `.
L8A33:  ldx     #$00                            ; 8A33 A2 00                    ..
        stx     $0570                           ; 8A35 8E 70 05                 .p.
L8A38:  rts                                     ; 8A38 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; state $16 — WARP ARRIVE ($8A39) — beam descends to the warp_dest landing
; y held in ent_param; materialize anim then sub_type 1, state $00.
; =============================================================================
player_st_warp_arrive:
        jsr     LEA03                           ; 8A39 20 03 EA                  ..
        jsr     entity_move_down_collide                           ; 8A3C 20 2A E9                  *.
        lda     $0468                           ; 8A3F AD 68 04                 .h.
        cmp     $0378                           ; 8A42 CD 78 03                 .x.
        bcs     L8A33                           ; 8A45 B0 EC                    ..
        sta     $0378                           ; 8A47 8D 78 03                 .x.
        lda     $0540                           ; 8A4A AD 40 05                 .@.
        cmp     #$04                            ; 8A4D C9 04                    ..
        bne     L8A38                           ; 8A4F D0 E7                    ..
        lda     #$01                            ; 8A51 A9 01                    ..
        jsr     entity_set_subtype                           ; 8A53 20 98 EA                  ..
        lda     #$00                            ; 8A56 A9 00                    ..
        sta     $30                             ; 8A58 85 30                    .0
        jsr     entity_stop_y                           ; 8A5A 20 1E EA                  ..
L8A5D:  rts                                     ; 8A5D 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; state $17 — REMATCH WON ($8A5E; set by $03:A4C9 after a rematch boss
; falls) — refills health to full ($9C, tick $26), beams up (sound $35);
; at the screen top warps back to the hub pad (warp_return by pad index),
; rebuilds the room (LD460), descends and materializes to state $00.
; =============================================================================
player_st_rematch_won:
        lda     $0558                           ; 8A5E AD 58 05                 .X.
        cmp     #$13                            ; 8A61 C9 13                    ..
        beq     L8A9A                           ; 8A63 F0 35                    .5
        lda     $B0                             ; 8A65 A5 B0                    ..
        cmp     #$9C                            ; 8A67 C9 9C                    ..
        beq     L8A7D                           ; 8A69 F0 12                    ..
        lda     $9D                             ; 8A6B A5 9D                    ..
        and     #$03                            ; 8A6D 29 03                    ).
        bne     L8A33                           ; 8A6F D0 C2                    ..
        lda     #$26                            ; 8A71 A9 26                    .&
        jsr     queue_sound                           ; 8A73 20 5D EC                  ].
        inc     $B0                             ; 8A76 E6 B0                    ..
        dec     $0468                           ; 8A78 CE 68 04                 .h.
        bne     L8A33                           ; 8A7B D0 B6                    ..
L8A7D:  lda     #$13                            ; 8A7D A9 13                    ..
        jsr     entity_set_subtype                           ; 8A7F 20 98 EA                  ..
        lda     #$04                            ; 8A82 A9 04                    ..
        sta     $0540                           ; 8A84 8D 40 05                 .@.
        lda     #$08                            ; 8A87 A9 08                    ..
        sta     $03F0                           ; 8A89 8D F0 03                 ...
        lda     #$00                            ; 8A8C A9 00                    ..
        sta     $03D8                           ; 8A8E 8D D8 03                 ...
        sta     $33                             ; 8A91 85 33                    .3
        sta     $34                             ; 8A93 85 34                    .4
        lda     #$35                            ; 8A95 A9 35                    .5
        jsr     queue_sound                           ; 8A97 20 5D EC                  ].
L8A9A:  lda     $F9                             ; 8A9A A5 F9                    ..
        cmp     #$03                            ; 8A9C C9 03                    ..
        beq     L8AD8                           ; 8A9E F0 38                    .8
        lda     $0540                           ; 8AA0 AD 40 05                 .@.
        bne     L8A5D                           ; 8AA3 D0 B8                    ..
        jsr     LEA03                           ; 8AA5 20 03 EA                  ..
        jsr     entity_move_up_nofacing                           ; 8AA8 20 4A E9                  J.
        lda     $0390                           ; 8AAB AD 90 03                 ...
        beq     L8A33                           ; 8AAE F0 83                    ..
        jsr     entity_stop_y                           ; 8AB0 20 1E EA                  ..
        lda     $F9                             ; 8AB3 A5 F9                    ..
        and     #$07                            ; 8AB5 29 07                    ).
        asl     a                               ; 8AB7 0A                       .
        tay                                     ; 8AB8 A8                       .
        lda     warp_return_x,y                         ; 8AB9 B9 E3 8F                 ...
        sta     $0330                           ; 8ABC 8D 30 03                 .0.
        lda     warp_return_y,y                         ; 8ABF B9 E4 8F                 ...
        sta     $0378                           ; 8AC2 8D 78 03                 .x.
        lda     #$00                            ; 8AC5 A9 00                    ..
        sta     $0390                           ; 8AC7 8D 90 03                 ...
        lda     #$03                            ; 8ACA A9 03                    ..
        sta     $F9                             ; 8ACC 85 F9                    ..
        lda     #$01                            ; 8ACE A9 01                    ..
        sta     $29                             ; 8AD0 85 29                    .)
        jsr     LD460                           ; 8AD2 20 60 D4                  `.
        ldx     #$00                            ; 8AD5 A2 00                    ..
        rts                                     ; 8AD7 60                       `

; ----------------------------------------------------------------------------
L8AD8:  lda     $0540                           ; 8AD8 AD 40 05                 .@.
        cmp     #$04                            ; 8ADB C9 04                    ..
        bne     L8AE3                           ; 8ADD D0 04                    ..
        lda     #$00                            ; 8ADF A9 00                    ..
        sta     $30                             ; 8AE1 85 30                    .0
L8AE3:  rts                                     ; 8AE3 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; state $18 — BOSS DEFEATED ($8AE4; set by stage boss-death code, e.g.
; $0A:A0EE) — wipes slots 1-4, plays the victory jingle ($11), sets the
; boss-beaten bit ($6E bitmap via $F2B2); robot-master stages -> state $0F
; (orbs), stage bank $0B -> state $14, other castle stages -> state $10.
; =============================================================================
player_st_boss_defeated:
        ldy     #$04                            ; 8AE4 A0 04                    ..
L8AE6:  jsr     entity_wipe_y                           ; 8AE6 20 FE F2                  ..
        dey                                     ; 8AE9 88                       .
        bne     L8AE6                           ; 8AEA D0 FA                    ..
        ldy     #$00                            ; 8AEC A0 00                    ..
        jsr     entity_gravity_collide                           ; 8AEE 20 B7 E7                  ..
        lda     #$07                            ; 8AF1 A9 07                    ..
        bcc     L8AF7                           ; 8AF3 90 02                    ..
        lda     #$01                            ; 8AF5 A9 01                    ..
L8AF7:  cmp     $0558                           ; 8AF7 CD 58 05                 .X.
        beq     L8AFF                           ; 8AFA F0 03                    ..
        jsr     entity_set_subtype                           ; 8AFC 20 98 EA                  ..
L8AFF:  lda     $0558                           ; 8AFF AD 58 05                 .X.
        cmp     #$01                            ; 8B02 C9 01                    ..
        bne     L8AE3                           ; 8B04 D0 DD                    ..
        lda     #$11                            ; 8B06 A9 11                    ..
        cmp     $D9                             ; 8B08 C5 D9                    ..
        beq     L8B0F                           ; 8B0A F0 03                    ..
        jsr     queue_sound_param                           ; 8B0C 20 5B EC                  [.
L8B0F:  dec     $0468                           ; 8B0F CE 68 04                 .h.
        bne     L8AE3                           ; 8B12 D0 CF                    ..
        lda     $26                             ; 8B14 A5 26                    .&
        and     #$07                            ; 8B16 29 07                    ).
        tay                                     ; 8B18 A8                       .
        lda     $F2B2,y                         ; 8B19 B9 B2 F2                 ...
        sta     L0000                           ; 8B1C 85 00                    ..
        lda     $26                             ; 8B1E A5 26                    .&
        lsr     a                               ; 8B20 4A                       J
        lsr     a                               ; 8B21 4A                       J
        lsr     a                               ; 8B22 4A                       J
        tay                                     ; 8B23 A8                       .
        lda     $6E,y                           ; 8B24 B9 6E 00                 .n.
        ora     L0000                           ; 8B27 05 00                    ..
        sta     $6E,y                           ; 8B29 99 6E 00                 .n.
        lda     $26                             ; 8B2C A5 26                    .&
        cmp     #$0B                            ; 8B2E C9 0B                    ..
        beq     L8B45                           ; 8B30 F0 13                    ..
        cmp     #$08                            ; 8B32 C9 08                    ..
        bcs     L8B40                           ; 8B34 B0 0A                    ..
        lda     #$04                            ; 8B36 A9 04                    ..
        jsr     entity_set_subtype                           ; 8B38 20 98 EA                  ..
        lda     #$0F                            ; 8B3B A9 0F                    ..
        sta     $30                             ; 8B3D 85 30                    .0
        rts                                     ; 8B3F 60                       `

; ----------------------------------------------------------------------------
L8B40:  lda     #$10                            ; 8B40 A9 10                    ..
        sta     $30                             ; 8B42 85 30                    .0
        rts                                     ; 8B44 60                       `

; ----------------------------------------------------------------------------
L8B45:  lda     #$14                            ; 8B45 A9 14                    ..
        sta     $30                             ; 8B47 85 30                    .0
        rts                                     ; 8B49 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; state $19 — STAND FROZEN ($8B4A) — parks the player (sub_type 1, flags
; $20) while scripted refills/cutscenes run ($1C:84AD, $0A:A2F3).
; =============================================================================
player_st_frozen:
        lda     #$01                            ; 8B4A A9 01                    ..
        cmp     $0558                           ; 8B4C CD 58 05                 .X.
        beq     L8B5A                           ; 8B4F F0 09                    ..
        jsr     entity_set_subtype                           ; 8B51 20 98 EA                  ..
        lda     #$00                            ; 8B54 A9 00                    ..
        sta     $34                             ; 8B56 85 34                    .4
        sta     $33                             ; 8B58 85 33                    .3
L8B5A:  lda     $0528                           ; 8B5A AD 28 05                 .(.
        ora     #$20                            ; 8B5D 09 20                    . 
        sta     $0528                           ; 8B5F 8D 28 05                 .(.
        rts                                     ; 8B62 60                       `

; ----------------------------------------------------------------------------
; --- states $1A/$1B — no-op ---
        rts                                     ; 8B63 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; state $1C — ENDING: ARRIVAL ($8B64; set by final-stage code $0A:A26E) —
; walks to x=$2C; when ent_param expires jumps to section $26, loads the
; ending palette, cues song $4A and enters state $1D.
; =============================================================================
player_st_end_arrive:
        ldy     #$00                            ; 8B64 A0 00                    ..
        jsr     entity_gravity_collide                           ; 8B66 20 B7 E7                  ..
        lda     #$07                            ; 8B69 A9 07                    ..
        bcc     L8B6F                           ; 8B6B 90 02                    ..
        lda     #$04                            ; 8B6D A9 04                    ..
L8B6F:  cmp     $0558                           ; 8B6F CD 58 05                 .X.
        beq     L8B7D                           ; 8B72 F0 09                    ..
        jsr     entity_set_subtype                           ; 8B74 20 98 EA                  ..
        lda     #$00                            ; 8B77 A9 00                    ..
        sta     $33                             ; 8B79 85 33                    .3
        sta     $34                             ; 8B7B 85 34                    .4
L8B7D:  lda     $0558                           ; 8B7D AD 58 05                 .X.
        cmp     #$04                            ; 8B80 C9 04                    ..
        bne     L8C02                           ; 8B82 D0 7E                    .~
        lda     $0330                           ; 8B84 AD 30 03                 .0.
        cmp     #$2C                            ; 8B87 C9 2C                    .,
        bcs     L8B97                           ; 8B89 B0 0C                    ..
        jsr     LE8DE                           ; 8B8B 20 DE E8                  ..
        lda     $0330                           ; 8B8E AD 30 03                 .0.
        cmp     #$2C                            ; 8B91 C9 2C                    .,
        bcc     L8C02                           ; 8B93 90 6D                    .m
        bcs     L8BA3                           ; 8B95 B0 0C                    ..
L8B97:  jsr     LE904                           ; 8B97 20 04 E9                  ..
        lda     $0330                           ; 8B9A AD 30 03                 .0.
        cmp     #$2C                            ; 8B9D C9 2C                    .,
        beq     L8BA3                           ; 8B9F F0 02                    ..
        bcs     L8C02                           ; 8BA1 B0 5F                    ._
L8BA3:  lda     #$2C                            ; 8BA3 A9 2C                    .,
        sta     $0330                           ; 8BA5 8D 30 03                 .0.
        lda     $0528                           ; 8BA8 AD 28 05                 .(.
        ora     #$20                            ; 8BAB 09 20                    . 
        sta     $0528                           ; 8BAD 8D 28 05                 .(.
        lda     #$01                            ; 8BB0 A9 01                    ..
        cmp     $0558                           ; 8BB2 CD 58 05                 .X.
        beq     L8BBA                           ; 8BB5 F0 03                    ..
        jsr     entity_set_subtype                           ; 8BB7 20 98 EA                  ..
L8BBA:  lda     $99                             ; 8BBA A5 99                    ..
        bne     L8C02                           ; 8BBC D0 44                    .D
        dec     $0468                           ; 8BBE CE 68 04                 .h.
        bne     L8C02                           ; 8BC1 D0 3F                    .?
        lda     #$26                            ; 8BC3 A9 26                    .&
        sta     $29                             ; 8BC5 85 29                    .)
        lda     #$03                            ; 8BC7 A9 03                    ..
        sta     $2A                             ; 8BC9 85 2A                    .*
        lda     #$00                            ; 8BCB A9 00                    ..
        sta     $2B                             ; 8BCD 85 2B                    .+
        sta     $55                             ; 8BCF 85 55                    .U
        sta     $2D                             ; 8BD1 85 2D                    .-
        sta     $2E                             ; 8BD3 85 2E                    ..
        sta     $2F                             ; 8BD5 85 2F                    ./
        ldy     #$0F                            ; 8BD7 A0 0F                    ..
L8BD9:  lda     ending_palette,y                         ; 8BD9 B9 F3 8F                 ...
        sta     $0600,y                         ; 8BDC 99 00 06                 ...
        sta     $0620,y                         ; 8BDF 99 20 06                 . .
        dey                                     ; 8BE2 88                       .
        bpl     L8BD9                           ; 8BE3 10 F4                    ..
        sty     $18                             ; 8BE5 84 18                    ..
        lda     #$9A                            ; 8BE7 A9 9A                    ..
        sta     $05F3                           ; 8BE9 8D F3 05                 ...
        lda     #$00                            ; 8BEC A9 00                    ..
        sta     $05FB                           ; 8BEE 8D FB 05                 ...
        sta     $05F7                           ; 8BF1 8D F7 05                 ...
        lda     #$1D                            ; 8BF4 A9 1D                    ..
        sta     $30                             ; 8BF6 85 30                    .0
        lda     #$04                            ; 8BF8 A9 04                    ..
        jsr     entity_set_subtype                           ; 8BFA 20 98 EA                  ..
        lda     #$4A                            ; 8BFD A9 4A                    .J
        jsr     queue_sound_param                           ; 8BFF 20 5B EC                  [.
L8C02:  rts                                     ; 8C02 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; state $1D — ENDING: TO THE CLIFF ($8C03) — walks right; at screen $0A
; x=$80 stands (song $15); after the beat leaps off the edge (xvel $02.6A,
; yvel $06.A4) into state $1E.
; =============================================================================
player_st_end_cliff:
        lda     $0558                           ; 8C03 AD 58 05                 .X.
        cmp     #$01                            ; 8C06 C9 01                    ..
        beq     L8C2D                           ; 8C08 F0 23                    .#
        jsr     LE8DE                           ; 8C0A 20 DE E8                  ..
        lda     $0348                           ; 8C0D AD 48 03                 .H.
        cmp     #$0A                            ; 8C10 C9 0A                    ..
        bne     L8C02                           ; 8C12 D0 EE                    ..
        lda     #$80                            ; 8C14 A9 80                    ..
        cmp     $0330                           ; 8C16 CD 30 03                 .0.
        bcs     L8C02                           ; 8C19 B0 E7                    ..
        sta     $0330                           ; 8C1B 8D 30 03                 .0.
        lda     #$01                            ; 8C1E A9 01                    ..
        jsr     entity_set_subtype                           ; 8C20 20 98 EA                  ..
        lda     #$15                            ; 8C23 A9 15                    ..
        jsr     queue_sound_param                           ; 8C25 20 5B EC                  [.
        lda     #$00                            ; 8C28 A9 00                    ..
        sta     $0468                           ; 8C2A 8D 68 04                 .h.
L8C2D:  dec     $0468                           ; 8C2D CE 68 04                 .h.
        bne     L8C02                           ; 8C30 D0 D0                    ..
        lda     #$01                            ; 8C32 A9 01                    ..
        sta     $0420                           ; 8C34 8D 20 04                 . .
        lda     #$A4                            ; 8C37 A9 A4                    ..
        sta     $03D8                           ; 8C39 8D D8 03                 ...
        lda     #$06                            ; 8C3C A9 06                    ..
        sta     $03F0                           ; 8C3E 8D F0 03                 ...
        lda     #$6A                            ; 8C41 A9 6A                    .j
        sta     $03A8                           ; 8C43 8D A8 03                 ...
        lda     #$02                            ; 8C46 A9 02                    ..
        sta     $03C0                           ; 8C48 8D C0 03                 ...
        lda     #$1E                            ; 8C4B A9 1E                    ..
        sta     $30                             ; 8C4D 85 30                    .0
        lda     #$07                            ; 8C4F A9 07                    ..
        jsr     entity_set_subtype                           ; 8C51 20 98 EA                  ..
        lda     #$00                            ; 8C54 A9 00                    ..
        sta     $05F3                           ; 8C56 8D F3 05                 ...
; =============================================================================
; state $1E — ENDING: LEAP WITH ESCORT ($8C59; fall-through from the state
; $1D setup) — mid-air arc, turning to face left past the apex; the
; spawn-linked escort actor tracks y/x-$14 alongside; BG palettes step
; darker every 8 frames. Landing: stand, song $4A, $78-frame pause, $1F.
; =============================================================================
player_st_end_leap:
        ldy     #$00                            ; 8C59 A0 00                    ..
        jsr     entity_gravity_collide                           ; 8C5B 20 B7 E7                  ..
        bcs     L8C7B                           ; 8C5E B0 1B                    ..
        jsr     entity_facing_dispatch                           ; 8C60 20 65 EA                  e.
        lda     $0330                           ; 8C63 AD 30 03                 .0.
        sta     $3C                             ; 8C66 85 3C                    .<
        lda     $03F0                           ; 8C68 AD F0 03                 ...
        bpl     L8CAE                           ; 8C6B 10 41                    .A
        lda     $0420                           ; 8C6D AD 20 04                 . .
        and     #$01                            ; 8C70 29 01                    ).
        beq     L8CAE                           ; 8C72 F0 3A                    .:
        lda     #$02                            ; 8C74 A9 02                    ..
        sta     $0420                           ; 8C76 8D 20 04                 . .
        bne     L8CAE                           ; 8C79 D0 33                    .3
L8C7B:  lda     #$01                            ; 8C7B A9 01                    ..
        cmp     $0558                           ; 8C7D CD 58 05                 .X.
        beq     L8CAD                           ; 8C80 F0 2B                    .+
        jsr     entity_set_subtype                           ; 8C82 20 98 EA                  ..
        lda     $0528                           ; 8C85 AD 28 05                 .(.
        ora     #$20                            ; 8C88 09 20                    . 
        sta     $0528                           ; 8C8A 8D 28 05                 .(.
        ldy     $0510                           ; 8C8D AC 10 05                 ...
        lda     $0528,y                         ; 8C90 B9 28 05                 .(.
        ora     #$20                            ; 8C93 09 20                    . 
        sta     $0528,y                         ; 8C95 99 28 05                 .(.
        lda     #$4A                            ; 8C98 A9 4A                    .J
        jsr     queue_sound_param                           ; 8C9A 20 5B EC                  [.
        lda     #$78                            ; 8C9D A9 78                    .x
        sta     $0468                           ; 8C9F 8D 68 04                 .h.
        lda     #$00                            ; 8CA2 A9 00                    ..
        sta     $0480                           ; 8CA4 8D 80 04                 ...
        lda     #$1F                            ; 8CA7 A9 1F                    ..
        sta     $30                             ; 8CA9 85 30                    .0
        bne     L8CAE                           ; 8CAB D0 01                    ..
L8CAD:  rts                                     ; 8CAD 60                       `

; ----------------------------------------------------------------------------
L8CAE:  lda     $0420                           ; 8CAE AD 20 04                 . .
        and     #$01                            ; 8CB1 29 01                    ).
        bne     L8CC7                           ; 8CB3 D0 12                    ..
        ldy     $0510                           ; 8CB5 AC 10 05                 ...
        lda     $0378                           ; 8CB8 AD 78 03                 .x.
        sta     $0378,y                         ; 8CBB 99 78 03                 .x.
        lda     $0330                           ; 8CBE AD 30 03                 .0.
        sec                                     ; 8CC1 38                       8
        sbc     #$14                            ; 8CC2 E9 14                    ..
        sta     $0330,y                         ; 8CC4 99 30 03                 .0.
L8CC7:  inc     $0468                           ; 8CC7 EE 68 04                 .h.
        lda     $0468                           ; 8CCA AD 68 04                 .h.
        and     #$07                            ; 8CCD 29 07                    ).
        bne     L8D03                           ; 8CCF D0 32                    .2
        ldy     #$03                            ; 8CD1 A0 03                    ..
L8CD3:  lda     $0624,y                         ; 8CD3 B9 24 06                 .$.
        sec                                     ; 8CD6 38                       8
        sbc     #$10                            ; 8CD7 E9 10                    ..
        bcs     L8CDD                           ; 8CD9 B0 02                    ..
        lda     #$0F                            ; 8CDB A9 0F                    ..
L8CDD:  sta     $0604,y                         ; 8CDD 99 04 06                 ...
        sta     $0624,y                         ; 8CE0 99 24 06                 .$.
        lda     $062C,y                         ; 8CE3 B9 2C 06                 .,.
        sec                                     ; 8CE6 38                       8
        sbc     #$10                            ; 8CE7 E9 10                    ..
        bcs     L8CED                           ; 8CE9 B0 02                    ..
        lda     #$0F                            ; 8CEB A9 0F                    ..
L8CED:  sta     $060C,y                         ; 8CED 99 0C 06                 ...
        sta     $062C,y                         ; 8CF0 99 2C 06                 .,.
        dey                                     ; 8CF3 88                       .
        bpl     L8CD3                           ; 8CF4 10 DD                    ..
        sty     $18                             ; 8CF6 84 18                    ..
        ldy     $0510                           ; 8CF8 AC 10 05                 ...
        lda     $0528,y                         ; 8CFB B9 28 05                 .(.
        and     #$EF                            ; 8CFE 29 EF                    ).
        sta     $0528,y                         ; 8D00 99 28 05                 .(.
L8D03:  rts                                     ; 8D03 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; state $1F — ENDING: VISTA ($8D04) — gazes out (pose $1F); every 16
; frames lights a star (actor $2F at vista_star positions, 12 total),
; then programs the credits IRQ split (latch $BF, mode 5) and state $20.
; =============================================================================
player_st_end_vista:
        lda     #$1F                            ; 8D04 A9 1F                    ..
        cmp     $0558                           ; 8D06 CD 58 05                 .X.
        beq     L8D1B                           ; 8D09 F0 10                    ..
        dec     $0468                           ; 8D0B CE 68 04                 .h.
        bne     L8D03                           ; 8D0E D0 F3                    ..
        jsr     entity_set_subtype                           ; 8D10 20 98 EA                  ..
        lda     #$0B                            ; 8D13 A9 0B                    ..
        sta     $23                             ; 8D15 85 23                    .#
        lda     #$80                            ; 8D17 A9 80                    ..
        sta     $1E                             ; 8D19 85 1E                    ..
L8D1B:  lda     $0468                           ; 8D1B AD 68 04                 .h.
        inc     $0468                           ; 8D1E EE 68 04                 .h.
        and     #$0F                            ; 8D21 29 0F                    ).
        bne     L8D03                           ; 8D23 D0 DE                    ..
        jsr     find_free_slot_y                           ; 8D25 20 6F F1                  o.
        bcs     L8D03                           ; 8D28 B0 D9                    ..
        lda     #$42                            ; 8D2A A9 42                    .B
        jsr     entity_init_pos                           ; 8D2C 20 A4 EA                  ..
        lda     #$2F                            ; 8D2F A9 2F                    ./
        sta     $0300,y                         ; 8D31 99 00 03                 ...
        lda     #$00                            ; 8D34 A9 00                    ..
        sta     $0408,y                         ; 8D36 99 08 04                 ...
        ldx     $0480                           ; 8D39 AE 80 04                 ...
        lda     vista_star_y,x                         ; 8D3C BD 07 90                 ...
        sta     $0378,y                         ; 8D3F 99 78 03                 .x.
        lda     vista_star_x,x                         ; 8D42 BD 08 90                 ...
        sta     $0330,y                         ; 8D45 99 30 03                 .0.
        inc     $0480                           ; 8D48 EE 80 04                 ...
        inc     $0480                           ; 8D4B EE 80 04                 ...
        lda     $0480                           ; 8D4E AD 80 04                 ...
        cmp     #$18                            ; 8D51 C9 18                    ..
        bne     L8D78                           ; 8D53 D0 23                    .#
        lda     #$00                            ; 8D55 A9 00                    ..
        sta     $0468                           ; 8D57 8D 68 04                 .h.
        sta     $0480                           ; 8D5A 8D 80 04                 ...
        sta     $0498                           ; 8D5D 8D 98 04                 ...
        sta     $78                             ; 8D60 85 78                    .x
        sta     $79                             ; 8D62 85 79                    .y
        lda     #$23                            ; 8D64 A9 23                    .#
        sta     $7A                             ; 8D66 85 7A                    .z
        lda     #$00                            ; 8D68 A9 00                    ..
        sta     $7B                             ; 8D6A 85 7B                    .{
        lda     #$BF                            ; 8D6C A9 BF                    ..
        sta     $9B                             ; 8D6E 85 9B                    ..
        lda     #$05                            ; 8D70 A9 05                    ..
        sta     $99                             ; 8D72 85 99                    ..
        lda     #$20                            ; 8D74 A9 20                    . 
        sta     $30                             ; 8D76 85 30                    .0
L8D78:  ldx     #$00                            ; 8D78 A2 00                    ..
        rts                                     ; 8D7A 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; state $20 — ENDING: SKY PAN ($8D7B) — accelerating upward camera scroll
; (16-bit adder into scroll_y, nametable flip on borrow); pose $C4. When
; the escort actor despawns: state $21, song $4A.
; =============================================================================
player_st_end_ascent:
        lda     $0468                           ; 8D7B AD 68 04                 .h.
        clc                                     ; 8D7E 18                       .
        adc     #$40                            ; 8D7F 69 40                    i@
        sta     $0468                           ; 8D81 8D 68 04                 .h.
        lda     $0480                           ; 8D84 AD 80 04                 ...
        adc     #$00                            ; 8D87 69 00                    i.
        sta     $0480                           ; 8D89 8D 80 04                 ...
L8D8C:  cmp     #$08                            ; 8D8C C9 08                    ..
        bcc     L8D9A                           ; 8D8E 90 0A                    ..
        lda     #$08                            ; 8D90 A9 08                    ..
        sta     $0480                           ; 8D92 8D 80 04                 ...
        lda     #$00                            ; 8D95 A9 00                    ..
        sta     $0468                           ; 8D97 8D 68 04                 .h.
L8D9A:  lda     $0498                           ; 8D9A AD 98 04                 ...
        sec                                     ; 8D9D 38                       8
        sbc     $0468                           ; 8D9E ED 68 04                 .h.
        sta     $0498                           ; 8DA1 8D 98 04                 ...
        lda     $FA                             ; 8DA4 A5 FA                    ..
        sbc     $0480                           ; 8DA6 ED 80 04                 ...
        sta     $FA                             ; 8DA9 85 FA                    ..
        bcs     L8DB5                           ; 8DAB B0 08                    ..
        sbc     #$0F                            ; 8DAD E9 0F                    ..
        sta     $FA                             ; 8DAF 85 FA                    ..
        lda     #$02                            ; 8DB1 A9 02                    ..
        sta     $FD                             ; 8DB3 85 FD                    ..
L8DB5:  lda     $FD                             ; 8DB5 A5 FD                    ..
        beq     L8DED                           ; 8DB7 F0 34                    .4
        lda     #$66                            ; 8DB9 A9 66                    .f
        cmp     $FA                             ; 8DBB C5 FA                    ..
        bcc     L8DED                           ; 8DBD 90 2E                    ..
        sta     $FA                             ; 8DBF 85 FA                    ..
        lda     $9D                             ; 8DC1 A5 9D                    ..
        and     #$02                            ; 8DC3 29 02                    ).
        sta     $78                             ; 8DC5 85 78                    .x
        lda     #$C4                            ; 8DC7 A9 C4                    ..
        cmp     $0558                           ; 8DC9 CD 58 05                 .X.
        beq     L8DD1                           ; 8DCC F0 03                    ..
        jsr     entity_set_subtype                           ; 8DCE 20 98 EA                  ..
L8DD1:  ldy     $04F8                           ; 8DD1 AC F8 04                 ...
        lda     $0300,y                         ; 8DD4 B9 00 03                 ...
        bne     L8DED                           ; 8DD7 D0 14                    ..
        sta     $0480                           ; 8DD9 8D 80 04                 ...
        sta     $0498                           ; 8DDC 8D 98 04                 ...
        lda     #$01                            ; 8DDF A9 01                    ..
        sta     $0468                           ; 8DE1 8D 68 04                 .h.
        lda     #$21                            ; 8DE4 A9 21                    .!
        sta     $30                             ; 8DE6 85 30                    .0
        lda     #$4A                            ; 8DE8 A9 4A                    .J
        jsr     queue_sound_param                           ; 8DEA 20 5B EC                  [.
L8DED:  rts                                     ; 8DED 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; state $21 — ENDING: CAST REVEAL ($8DEE) — camera eases back down; every
; 8 frames plays a cast_rec (tile rewrite + cast actor type $C1 + chime
; $2B), 12 records; then pose 4, walk-off $01.4C, state $22.
; =============================================================================
player_st_end_reveal:
        lda     $0498                           ; 8DEE AD 98 04                 ...
        clc                                     ; 8DF1 18                       .
        adc     #$40                            ; 8DF2 69 40                    i@
        sta     $0498                           ; 8DF4 8D 98 04                 ...
        lda     $FA                             ; 8DF7 A5 FA                    ..
        adc     #$00                            ; 8DF9 69 00                    i.
        sta     $FA                             ; 8DFB 85 FA                    ..
        lda     #$6E                            ; 8DFD A9 6E                    .n
        cmp     $FA                             ; 8DFF C5 FA                    ..
        bcs     L8E05                           ; 8E01 B0 02                    ..
        sta     $FA                             ; 8E03 85 FA                    ..
L8E05:  dec     $0468                           ; 8E05 CE 68 04                 .h.
        bne     L8DED                           ; 8E08 D0 E3                    ..
        lda     #$08                            ; 8E0A A9 08                    ..
        sta     $0468                           ; 8E0C 8D 68 04                 .h.
        ldy     $0480                           ; 8E0F AC 80 04                 ...
        ldx     $43                             ; 8E12 A6 43                    .C
        lda     cast_rec_nt0,y                         ; 8E14 B9 1F 90                 ...
        sta     $06C0,x                         ; 8E17 9D C0 06                 ...
        lda     cast_rec_nt1,y                         ; 8E1A B9 20 90                 . .
        sta     $06C1,x                         ; 8E1D 9D C1 06                 ...
        sta     $22                             ; 8E20 85 22                    ."
        lda     cast_rec_nt2,y                         ; 8E22 B9 21 90                 .!.
        sta     $06C2,x                         ; 8E25 9D C2 06                 ...
        sta     L0010                           ; 8E28 85 10                    ..
        lda     cast_rec_nt3,y                         ; 8E2A B9 22 90                 .".
        sta     $06C3,x                         ; 8E2D 9D C3 06                 ...
        sta     $11                             ; 8E30 85 11                    ..
        lda     cast_rec_y,y                         ; 8E32 B9 23 90                 .#.
        sta     $02                             ; 8E35 85 02                    ..
        lda     cast_rec_x,y                         ; 8E37 B9 24 90                 .$.
        sta     $03                             ; 8E3A 85 03                    ..
        inx                                     ; 8E3C E8                       .
        inx                                     ; 8E3D E8                       .
        inx                                     ; 8E3E E8                       .
        inx                                     ; 8E3F E8                       .
        stx     $43                             ; 8E40 86 43                    .C
        ldx     #$00                            ; 8E42 A2 00                    ..
        jsr     find_free_slot_y                           ; 8E44 20 6F F1                  o.
        bcs     L8E95                           ; 8E47 B0 4C                    .L
        lda     #$2B                            ; 8E49 A9 2B                    .+
        jsr     queue_sound                           ; 8E4B 20 5D EC                  ].
        lda     #$00                            ; 8E4E A9 00                    ..
        jsr     entity_init_pos                           ; 8E50 20 A4 EA                  ..
        lda     #$C1                            ; 8E53 A9 C1                    ..
        sta     $0300,y                         ; 8E55 99 00 03                 ...
        lda     $02                             ; 8E58 A5 02                    ..
        sta     $0378,y                         ; 8E5A 99 78 03                 .x.
        lda     $03                             ; 8E5D A5 03                    ..
        sta     $0330,y                         ; 8E5F 99 30 03                 .0.
        lda     #$00                            ; 8E62 A9 00                    ..
        sta     $0408,y                         ; 8E64 99 08 04                 ...
        tya                                     ; 8E67 98                       .
        tax                                     ; 8E68 AA                       .
        ldy     $11                             ; 8E69 A4 11                    ..
        jsr     LD7DB                           ; 8E6B 20 DB D7                  ..
        ldx     #$00                            ; 8E6E A2 00                    ..
        lda     $0480                           ; 8E70 AD 80 04                 ...
        clc                                     ; 8E73 18                       .
        adc     #$06                            ; 8E74 69 06                    i.
        sta     $0480                           ; 8E76 8D 80 04                 ...
        cmp     #$48                            ; 8E79 C9 48                    .H
        bne     L8E95                           ; 8E7B D0 18                    ..
        lda     #$04                            ; 8E7D A9 04                    ..
        jsr     entity_set_subtype                           ; 8E7F 20 98 EA                  ..
        lda     #$22                            ; 8E82 A9 22                    ."
        sta     $30                             ; 8E84 85 30                    .0
        lda     #$00                            ; 8E86 A9 00                    ..
        sta     $0468                           ; 8E88 8D 68 04                 .h.
        lda     #$4C                            ; 8E8B A9 4C                    .L
L8E8D:  sta     $03A8                           ; 8E8D 8D A8 03                 ...
        lda     #$01                            ; 8E90 A9 01                    ..
        sta     $03C0                           ; 8E92 8D C0 03                 ...
L8E95:  rts                                     ; 8E95 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; state $22 — ENDING: WALK OFF ($8E96) — walks right (wide-range flag)
; until x_screen $0B; when the escort actor despawns, state $23 with a
; $3C-frame pause.
; =============================================================================
player_st_end_walk:
        ldy     #$00                            ; 8E96 A0 00                    ..
        jsr     entity_gravity_collide                           ; 8E98 20 B7 E7                  ..
        lda     #$04                            ; 8E9B A9 04                    ..
        bcs     L8EA1                           ; 8E9D B0 02                    ..
        lda     #$07                            ; 8E9F A9 07                    ..
L8EA1:  cmp     $0558                           ; 8EA1 CD 58 05                 .X.
        beq     L8EA9                           ; 8EA4 F0 03                    ..
        jsr     entity_set_subtype                           ; 8EA6 20 98 EA                  ..
L8EA9:  lda     $0528                           ; 8EA9 AD 28 05                 .(.
        ora     #$08                            ; 8EAC 09 08                    ..
        sta     $0528                           ; 8EAE 8D 28 05                 .(.
        lda     $0348                           ; 8EB1 AD 48 03                 .H.
        cmp     #$0B                            ; 8EB4 C9 0B                    ..
        beq     L8EBB                           ; 8EB6 F0 03                    ..
        jsr     LE8DE                           ; 8EB8 20 DE E8                  ..
L8EBB:  ldy     $0510                           ; 8EBB AC 10 05                 ...
        lda     $0300,y                         ; 8EBE B9 00 03                 ...
        bne     L8ECF                           ; 8EC1 D0 0C                    ..
        lda     #$23                            ; 8EC3 A9 23                    .#
        sta     $30                             ; 8EC5 85 30                    .0
        lda     #$3C                            ; 8EC7 A9 3C                    .<
        sta     $0468                           ; 8EC9 8D 68 04                 .h.
        sta     $0480                           ; 8ECC 8D 80 04                 ...
L8ECF:  rts                                     ; 8ECF 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; state $23 — ENDING: FADE OUT ($8ED0) — after the pause pans the camera up
; to $50, then hands off to the flow task (credits / THE END).
; =============================================================================
player_st_end_fade:
        lda     $0468                           ; 8ED0 AD 68 04
        beq     L8EDA                           ; 8ED3 F0 05
        dec     $0468                           ; 8ED5 CE 68 04
        bne     L8ECF                           ; 8ED8 D0 F5
L8EDA:  lda     $FA                             ; 8EDA A5 FA
        sec                                     ; 8EDC 38
        sbc     #$08                            ; 8EDD E9 08
        sta     $FA                             ; 8EDF 85 FA
        lda     #$50                            ; 8EE1 A9 50
        cmp     $FA                             ; 8EE3 C5 FA
        bcc     L8ECF                           ; 8EE5 90 E8
        sta     $FA                             ; 8EE7 85 FA
        dec     $0480                           ; 8EE9 CE 80 04
        bne     L8ECF                           ; 8EEC D0 E1
        jmp     player_exit_to_flow             ; 8EEE 4C 1C 85

; =============================================================================
; Player state machine data
; =============================================================================
; ground-contact y nudge per gravity flip (+2 / -2)
ynudge_tbl:
        .byte   $02,$FE                         ; 8EF1
; slide-end y kick per gravity flip: $FF.C0 / $00.40
slide_yvel_sub:
        .byte   $C0,$40                         ; 8EF3
slide_yvel_px:
        .byte   $FF,$00                         ; 8EF5
; climb-toward-feet input mask per gravity flip (Down / Up)
climb_down_mask:
        .byte   $04,$08                         ; 8EF7
; ladder-grab y alignment offset per gravity flip
ladder_grab_yofs:
        .byte   $00,$0F                         ; 8EF9
; sprite palette loaded on re-entry from the top (state $0A)
reenter_palette:
        .byte   $0F,$20,$11,$01,$0F,$20,$10,$00 ; 8EFB
        .byte   $0F,$21,$19,$09,$0F,$20,$27,$17 ; 8F03
; carry_path: 4-byte waypoints (screen, x, y, dir; dir=$FF releases the
; player). Two scripts: $8F0B and $8F2B (start index comes in ent_param).
carry_path_scr: .byte   $03                     ; 8F0B
carry_path_x:   .byte   $B0                     ; 8F0C
carry_path_y:   .byte   $90                     ; 8F0D
carry_path_dir: .byte   $04                     ; 8F0E
        .byte   $04,$B0,$30,$02                 ; 8F0F
        .byte   $04,$30,$30,$04                 ; 8F13
        .byte   $04,$30,$50,$01                 ; 8F17
        .byte   $04,$50,$50,$04                 ; 8F1B
        .byte   $04,$50,$70,$01                 ; 8F1F
        .byte   $04,$70,$70,$04                 ; 8F23
        .byte   $04,$70,$A8,$FF                 ; 8F27
        .byte   $03,$D0,$70,$04                 ; 8F2B
        .byte   $04,$D0,$70,$02                 ; 8F2F
        .byte   $04,$B0,$70,$04                 ; 8F33
        .byte   $04,$B0,$B0,$01                 ; 8F37
        .byte   $04,$D0,$B0,$04                 ; 8F3B
        .byte   $05,$D0,$38,$FF                 ; 8F3F
; jet-ski thrust (xvel sub/px): +0 = forward $01.4C, +2 = back $01.00
jetski_thrust_sub: .byte $4C                    ; 8F43
jetski_thrust_px:  .byte $01                    ; 8F44
        .byte   $00,$01                         ; 8F45
; buster charge-flash palette: sprite pal colors 1-3 per flash phase
; (written to $0611-$0613 by the routine at $914C)
charge_flash_col1:
        .byte   $0F,$0F,$05,$15,$25,$0F,$2C,$11 ; 8F47
charge_flash_col2:
        .byte   $2C,$2C,$2C,$2C,$2C,$2C,$11,$0F ; 8F4F
charge_flash_col3:
        .byte   $11,$11,$11,$11,$11,$11,$0F,$2C ; 8F57
; victory orb ring: 4-byte records (x, y, orbit phase, unused) — the 8
; start points of the converging weapon-energy orbs (state $0F)
orb_spawn_x:    .byte   $80                     ; 8F5F
orb_spawn_y:    .byte   $08                     ; 8F60
orb_spawn_phase: .byte  $0C                     ; 8F61
        .byte   $00                             ; 8F62
        .byte   $10,$78,$08,$00                 ; 8F63
        .byte   $80,$E8,$04,$00                 ; 8F67
        .byte   $F0,$78,$00,$00                 ; 8F6B
        .byte   $38,$28,$0A,$00                 ; 8F6F
        .byte   $38,$C8,$06,$00                 ; 8F73
        .byte   $C8,$C8,$02,$00                 ; 8F77
        .byte   $C8,$28,$FE,$00                 ; 8F7B
; hatch reveal: 6-byte records (4-byte tile-rewrite record -> $06C0 buffer,
; spawn y, spawn x); 10 records played by state $13 in the teleporter hub
hatch_rec_nt0:  .byte   $03                     ; 8F7F
hatch_rec_nt1:  .byte   $2A                     ; 8F80
hatch_rec_nt2:  .byte   $02                     ; 8F81
hatch_rec_nt3:  .byte   $65                     ; 8F82
hatch_rec_y:    .byte   $B8                     ; 8F83
hatch_rec_x:    .byte   $48                     ; 8F84
        .byte   $03,$29,$03,$65,$B8,$38         ; 8F85
        .byte   $03,$29,$02,$65,$B8,$28         ; 8F8B
        .byte   $03,$28,$03,$65,$B8,$18         ; 8F91
        .byte   $03,$2A,$00,$82,$A8,$48         ; 8F97
        .byte   $03,$29,$01,$82,$A8,$38         ; 8F9D
        .byte   $03,$29,$00,$82,$A8,$28         ; 8FA3
        .byte   $03,$28,$01,$82,$A8,$18         ; 8FA9
        .byte   $03,$21,$02,$65,$98,$28         ; 8FAF
        .byte   $03,$20,$03,$65,$98,$18         ; 8FB5
; warp destinations, indexed by pad index *4 ($6A): scroll screen, section,
; x, landing y. Entry 0 = hub center; 1-8 = rematch rooms; 9 = exit shaft.
warp_dest_scr:  .byte   $03                     ; 8FBB
warp_dest_sect: .byte   $01                     ; 8FBC
warp_dest_x:    .byte   $80                     ; 8FBD
warp_dest_y:    .byte   $34                     ; 8FBE
        .byte   $08,$04,$20,$B4                 ; 8FBF
        .byte   $09,$04,$20,$B4                 ; 8FC3
        .byte   $0A,$04,$20,$B4                 ; 8FC7
        .byte   $0B,$04,$20,$B4                 ; 8FCB
        .byte   $0C,$04,$20,$B4                 ; 8FCF
        .byte   $0D,$04,$20,$B4                 ; 8FD3
        .byte   $0E,$04,$20,$B4                 ; 8FD7
        .byte   $0F,$04,$20,$B4                 ; 8FDB
        .byte   $04,$02,$20,$B4                 ; 8FDF
; hub pad positions (x, y) the player re-appears on after a rematch win
warp_return_x:  .byte   $20                     ; 8FE3
warp_return_y:  .byte   $34                     ; 8FE4
        .byte   $20,$74                         ; 8FE5
        .byte   $20,$B4                         ; 8FE7
        .byte   $80,$74                         ; 8FE9
        .byte   $80,$B4                         ; 8FEB
        .byte   $E0,$34                         ; 8FED
        .byte   $E0,$74                         ; 8FEF
        .byte   $E0,$B4                         ; 8FF1
; ending palette (loaded to BG $0600 and sprite $0620, state $1C)
ending_palette:
        .byte   $0F,$30,$10,$08,$0F,$2B,$1B,$0B ; 8FF3
        .byte   $0F,$30,$2C,$00,$0F,$27,$26,$06 ; 8FFB
        .byte   $00,$00,$00,$9A                 ; 9003  (unreferenced)
; vista stars (y, x), 12 lit one by one in state $1F
vista_star_y:   .byte   $30                     ; 9007
vista_star_x:   .byte   $38                     ; 9008
        .byte   $60,$98                         ; 9009
        .byte   $90,$68                         ; 900B
        .byte   $30,$C8                         ; 900D
        .byte   $60,$38                         ; 900F
        .byte   $90,$C8                         ; 9011
        .byte   $30,$68                         ; 9013
        .byte   $60,$C8                         ; 9015
        .byte   $90,$38                         ; 9017
        .byte   $30,$98                         ; 9019
        .byte   $60,$68                         ; 901B
        .byte   $90,$98                         ; 901D
; cast reveal: 6-byte records like hatch_rec (tile rewrite + cast actor
; type $C1, byte 3 doubles as the actor variant), 12 played by state $21
cast_rec_nt0:   .byte   $0A                     ; 901F
cast_rec_nt1:   .byte   $0D                     ; 9020
cast_rec_nt2:   .byte   $00                     ; 9021
cast_rec_nt3:   .byte   $00                     ; 9022
cast_rec_y:     .byte   $28                     ; 9023
cast_rec_x:     .byte   $A8                     ; 9024
        .byte   $0A,$05,$02,$80,$18,$A8         ; 9025
        .byte   $0A,$0D,$01,$00,$28,$B8         ; 902B
        .byte   $0A,$05,$03,$81,$18,$B8         ; 9031
        .byte   $0A,$0E,$00,$00,$28,$C8         ; 9037
        .byte   $0A,$06,$02,$82,$18,$C8         ; 903D
        .byte   $0A,$0E,$01,$00,$28,$D8         ; 9043
        .byte   $0A,$06,$03,$83,$18,$D8         ; 9049
        .byte   $0A,$0F,$00,$00,$28,$E8         ; 904F
        .byte   $0A,$07,$02,$84,$18,$E8         ; 9055
        .byte   $0A,$0F,$01,$00,$28,$F8         ; 905B
        .byte   $0A,$07,$03,$80,$18,$F8         ; 9061
; A+dir masks by gravity flip: +0/+1 slide combo (Down/Up); +2/+3 ladder
; grab up (Up/Down) — see ladder_grab_up.
slide_input_mask:  .byte   $04                             ; 9067 04                       .
        php                                     ; 9068 08                       .
ladder_up_mask:  php                                     ; 9069 08                       .
        .byte   $04                             ; 906A 04                       .
player_weapon_fire:  lda     $0390                           ; 906B AD 90 03                 ...
        bne     L90E2                           ; 906E D0 72                    .r
; -----------------------------------------------------------------------------
; PLAYER WEAPON FIRE — $1B:906B (called by states that allow shooting)
; Skipped while the player is off-screen ($0390). Y = weapon id ($32):
; meter at $B0,y ($B0 = player HP for the buster; $9C full, $80 empty)
; is checked against weapon_empty_tbl, then control dispatches through
; weapon_fire_lo/hi — see the weapon id map in the bank header. Weapon
; shots live in slots 1-3; Rush parks in slot 4.
; -----------------------------------------------------------------------------
; -----------------------------------------------------------------------------
        ldy     $32                             ; 9070 A4 32                    .2
        lda     $B0,y                           ; 9072 B9 B0 00                 ...
L9075:  cmp     weapon_empty_tbl,y                         ; 9075 D9 C5 95                 ...
        beq     L90E2                           ; 9078 F0 68                    .h
        lda     weapon_fire_lo,y                         ; 907A B9 71 95                 .q.
L907D:  sta     L0000                           ; 907D 85 00                    ..
        lda     weapon_fire_hi,y                         ; 907F B9 81 95                 ...
        sta     $01                             ; 9082 85 01                    ..
        jmp     (L0000)                         ; 9084 6C 00 00                 l..

; ----------------------------------------------------------------------------
; -----------------------------------------------------------------------------
; fire_rush — weapons $0A/$0B (Rush Coil / Rush Jet). B press: if Rush is
; already out (slot 4 busy) falls through to fire_buster (you keep shooting
; while he's deployed); meter $80 = empty. Summons rush_type_tbl type
; ($02 coil / $45 jet) into slot 4, teleporting down from the sky
; (preset $4E, yvel 8, Rush CHR bank $46 -> R2).
; -----------------------------------------------------------------------------
fire_rush:
        lda     $14                             ; 9087 A5 14                    ..
        and     #$40                            ; 9089 29 40                    )@
        beq     L90E2                           ; 908B F0 55                    .U
        lda     $0304                           ; 908D AD 04 03                 ...
        bne     fire_buster                           ; 9090 D0 51                    .Q
        ldy     $32                             ; 9092 A4 32                    .2
        lda     $B0,y                           ; 9094 B9 B0 00                 ...
        cmp     #$80                            ; 9097 C9 80                    ..
        beq     fire_buster                           ; 9099 F0 48                    .H
        ldy     #$04                            ; 909B A0 04                    ..
        jsr     shot_set_facing                           ; 909D 20 54 95                  T.
        lda     #$36                            ; 90A0 A9 36                    .6
        sta     L0010                           ; 90A2 85 10                    ..
        lda     $0528                           ; 90A4 AD 28 05                 .(.
        and     #$20                            ; 90A7 29 20                    ) 
        beq     L90B2                           ; 90A9 F0 07                    ..
        inc     L0010                           ; 90AB E6 10                    ..
        lda     #$01                            ; 90AD A9 01                    ..
        sta     $0424                           ; 90AF 8D 24 04                 .$.
L90B2:  ldy     #$04                            ; 90B2 A0 04                    ..
        lda     #$4E                            ; 90B4 A9 4E                    .N
        jsr     entity_speed_preset                           ; 90B6 20 F5 EA                  ..
        lda     #$46                            ; 90B9 A9 46                    .F
        sta     $ED                             ; 90BB 85 ED                    ..
        lda     $0528,y                         ; 90BD B9 28 05                 .(.
        and     #$BF                            ; 90C0 29 BF                    ).
        sta     $0528,y                         ; 90C2 99 28 05                 .(.
        lda     #$00                            ; 90C5 A9 00                    ..
        sta     $03D8,y                         ; 90C7 99 D8 03                 ...
        lda     #$08                            ; 90CA A9 08                    ..
        sta     $03F0,y                         ; 90CC 99 F0 03                 ...
        lda     #$00                            ; 90CF A9 00                    ..
        sta     $037C                           ; 90D1 8D 7C 03                 .|.
        ldy     $32                             ; 90D4 A4 32                    .2
        lda     rush_type_tbl,y                         ; 90D6 B9 9C 95                 ...
        sta     $0304                           ; 90D9 8D 04 03                 ...
        lda     rush_shape_tbl,y                         ; 90DC B9 9E 95                 ...
        sta     $040C                           ; 90DF 8D 0C 04                 ...
L90E2:  rts                                     ; 90E2 60                       `

; ----------------------------------------------------------------------------
; -----------------------------------------------------------------------------
; fire_buster — weapon $00 (and unused ids $D-$F; deployed items fall
; through here). B press: blocked while type $45 (Rush Jet) sits in slot 1
; (vestigial? the MM5 summon parks Rush in slot 4) or while a charged shot
; (sub_type $A8/$A9) is in flight; else fires from a free slot 1-3.
; B held/released: buster_charge_ctl.
; -----------------------------------------------------------------------------
fire_buster:  lda     $14                             ; 90E3 A5 14                    ..
        and     #$40                            ; 90E5 29 40                    )@
        beq     buster_charge_ctl                           ; 90E7 F0 27                    .'
        lda     $0301                           ; 90E9 AD 01 03                 ...
        cmp     #$45                            ; 90EC C9 45                    .E
        beq     L910F                           ; 90EE F0 1F                    ..
L90F0:  ldy     #$03                            ; 90F0 A0 03                    ..
L90F2:  lda     $0300,y                         ; 90F2 B9 00 03                 ...
        beq     L9102                           ; 90F5 F0 0B                    ..
        lda     $0558,y                         ; 90F7 B9 58 05                 .X.
        cmp     #$A8                            ; 90FA C9 A8                    ..
        beq     L910F                           ; 90FC F0 11                    ..
        cmp     #$A9                            ; 90FE C9 A9                    ..
        beq     L910F                           ; 9100 F0 0D                    ..
L9102:  dey                                     ; 9102 88                       .
        bne     L90F2                           ; 9103 D0 ED                    ..
        ldy     #$03                            ; 9105 A0 03                    ..
L9107:  lda     $0300,y                         ; 9107 B9 00 03                 ...
        beq     buster_shoot                           ; 910A F0 7F                    ..
        dey                                     ; 910C 88                       .
        bne     L9107                           ; 910D D0 F8                    ..
L910F:  rts                                     ; 910F 60                       `

; ----------------------------------------------------------------------------
; --- buster_charge_ctl — B not newly pressed (buster only, not on the
; jet-ski): B held ticks the charge; on release, $38 >= $10 fires
; buster_shoot with the tier picked from buster_tier_threshold. ---
buster_charge_ctl:  lda     $32                             ; 9110 A5 32                    .2
        bne     L910F                           ; 9112 D0 FB                    ..
        lda     $30                             ; 9114 A5 30                    .0
        cmp     #$04                            ; 9116 C9 04                    ..
        beq     L910F                           ; 9118 F0 F5                    ..
        lda     $16                             ; 911A A5 16                    ..
        and     #$40                            ; 911C 29 40                    )@
        bne     buster_charge_tick                           ; 911E D0 1D                    ..
        lda     $38                             ; 9120 A5 38                    .8
        cmp     #$10                            ; 9122 C9 10                    ..
        bcc     L910F                           ; 9124 90 E9                    ..
        cmp     #$50                            ; 9126 C9 50                    .P
        bcc     L90F0                           ; 9128 90 C6                    ..
        lda     $0301                           ; 912A AD 01 03                 ...
        ora     $0302                           ; 912D 0D 02 03                 ...
        ora     $0303                           ; 9130 0D 03 03                 ...
        bne     L9139                           ; 9133 D0 04                    ..
        ldy     #$01                            ; 9135 A0 01                    ..
        bne     buster_shoot                           ; 9137 D0 52                    .R
L9139:  lda     #$00                            ; 9139 A9 00                    ..
        sta     $38                             ; 913B 85 38                    .8
; --- buster_charge_tick — $38 charge counter: hum ($22) at $20, wraps
; $56 -> $50, then charge_flash_update cycles the suit palette. ---
buster_charge_tick:  lda     $38                             ; 913D A5 38                    .8
        cmp     #$20                            ; 913F C9 20                    . 
        bne     L9148                           ; 9141 D0 05                    ..
        lda     #$22                            ; 9143 A9 22                    ."
        jsr     queue_sound                           ; 9145 20 5D EC                  ].
L9148:  inc     $38                             ; 9148 E6 38                    .8
        lda     $38                             ; 914A A5 38                    .8
charge_flash_update:  cmp     #$56                            ; 914C C9 56                    .V
        bne     L9154                           ; 914E D0 04                    ..
        lda     #$50                            ; 9150 A9 50                    .P
        sta     $38                             ; 9152 85 38                    .8
L9154:  cmp     #$50                            ; 9154 C9 50                    .P
        bcc     L9160                           ; 9156 90 08                    ..
        and     #$0F                            ; 9158 29 0F                    ).
        lsr     a                               ; 915A 4A                       J
        clc                                     ; 915B 18                       .
        adc     #$05                            ; 915C 69 05                    i.
        bne     L916A                           ; 915E D0 0A                    ..
L9160:  lsr     a                               ; 9160 4A                       J
        lsr     a                               ; 9161 4A                       J
        ldy     #$00                            ; 9162 A0 00                    ..
        bcc     charge_flash_apply                           ; 9164 90 05                    ..
        lsr     a                               ; 9166 4A                       J
        lsr     a                               ; 9167 4A                       J
        and     #$07                            ; 9168 29 07                    ).
L916A:  tay                                     ; 916A A8                       .
charge_flash_apply:  lda     charge_flash_col1,y                         ; 916B B9 47 8F                 .G.
        sta     $0611                           ; 916E 8D 11 06                 ...
        sta     $0631                           ; 9171 8D 31 06                 .1.
        lda     charge_flash_col2,y                         ; 9174 B9 4F 8F                 .O.
        sta     $0612                           ; 9177 8D 12 06                 ...
        sta     $0632                           ; 917A 8D 32 06                 .2.
        lda     charge_flash_col3,y                         ; 917D B9 57 8F                 .W.
        sta     $0613                           ; 9180 8D 13 06                 ...
        sta     $0633                           ; 9183 8D 33 06                 .3.
        lda     #$FF                            ; 9186 A9 FF                    ..
        sta     $18                             ; 9188 85 18                    ..
        rts                                     ; 918A 60                       `

; ----------------------------------------------------------------------------
; --- buster_shoot — X = charge tier (0/1/2 via buster_tier_threshold).
; On a ladder, L/R input re-faces first; sets the shoot pose (+1 sub_type,
; $33=$10 timer); spawns the type $70 shot with tier preset/velocity/sound;
; $5B = tier for the damage engine. Jet-ski state: fixed $07.33 xvel and
; +6 y muzzle offset. ---
buster_shoot:  lda     $30                             ; 918B A5 30                    .0
        cmp     #$03                            ; 918D C9 03                    ..
        bne     L919F                           ; 918F D0 0E                    ..
        lda     $16                             ; 9191 A5 16                    ..
        and     #$03                            ; 9193 29 03                    ).
        beq     L919F                           ; 9195 F0 08                    ..
        sta     $0420                           ; 9197 8D 20 04                 . .
        sta     $31                             ; 919A 85 31                    .1
        jsr     entity_facing_to_flags                           ; 919C 20 30 EC                  0.
L919F:  lda     $30                             ; 919F A5 30                    .0
        cmp     #$04                            ; 91A1 C9 04                    ..
        beq     L91B4                           ; 91A3 F0 0F                    ..
        lda     #$10                            ; 91A5 A9 10                    ..
        sta     $33                             ; 91A7 85 33                    .3
        lda     $34                             ; 91A9 A5 34                    .4
        bne     L91B4                           ; 91AB D0 07                    ..
        lda     #$01                            ; 91AD A9 01                    ..
        sta     $34                             ; 91AF 85 34                    .4
        inc     $0558                           ; 91B1 EE 58 05                 .X.
L91B4:  lda     #$02                            ; 91B4 A9 02                    ..
        sta     $0420,y                         ; 91B6 99 20 04                 . .
        lda     $0528                           ; 91B9 AD 28 05                 .(.
        and     #$20                            ; 91BC 29 20                    ) 
        beq     L91C5                           ; 91BE F0 05                    ..
        lda     #$01                            ; 91C0 A9 01                    ..
        sta     $0420,y                         ; 91C2 99 20 04                 . .
L91C5:  lda     $38                             ; 91C5 A5 38                    .8
        cmp     buster_tier_threshold,x                         ; 91C7 DD 91 95                 ...
        bcc     L91D1                           ; 91CA 90 05                    ..
        inx                                     ; 91CC E8                       .
        cpx     #$02                            ; 91CD E0 02                    ..
        bne     L91C5                           ; 91CF D0 F4                    ..
L91D1:  lda     $0420,y                         ; 91D1 B9 20 04                 . .
        and     #$01                            ; 91D4 29 01                    ).
        ora     buster_tier_pose,x                         ; 91D6 1D 97 95                 ...
        sta     L0010                           ; 91D9 85 10                    ..
        lda     buster_tier_xvel_sub,x                         ; 91DB BD 9A 95                 ...
        sta     $03A8,y                         ; 91DE 99 A8 03                 ...
        lda     buster_tier_xvel_px,x                         ; 91E1 BD 9D 95                 ...
        sta     $03C0,y                         ; 91E4 99 C0 03                 ...
        lda     $32                             ; 91E7 A5 32                    .2
        cmp     #$01                            ; 91E9 C9 01                    ..
        beq     L91F2                           ; 91EB F0 05                    ..
        lda     buster_tier_charge,x                         ; 91ED BD A0 95                 ...
        sta     $5B                             ; 91F0 85 5B                    .[
L91F2:  lda     buster_tier_sound,x                         ; 91F2 BD A3 95                 ...
        jsr     queue_sound                           ; 91F5 20 5D EC                  ].
        lda     #$00                            ; 91F8 A9 00                    ..
        sta     $0408,y                         ; 91FA 99 08 04                 ...
        lda     buster_tier_preset,x                         ; 91FD BD 94 95                 ...
        ldx     #$00                            ; 9200 A2 00                    ..
        jsr     entity_speed_preset                           ; 9202 20 F5 EA                  ..
        lda     #$00                            ; 9205 A9 00                    ..
        sta     $0408,y                         ; 9207 99 08 04                 ...
        lda     #$70                            ; 920A A9 70                    .p
        sta     $0300,y                         ; 920C 99 00 03                 ...
        lda     $38                             ; 920F A5 38                    .8
        sta     $0468,y                         ; 9211 99 68 04                 .h.
        lda     $30                             ; 9214 A5 30                    .0
        cmp     #$04                            ; 9216 C9 04                    ..
        bne     L922D                           ; 9218 D0 13                    ..
        lda     #$33                            ; 921A A9 33                    .3
        sta     $03A8,y                         ; 921C 99 A8 03                 ...
        lda     #$07                            ; 921F A9 07                    ..
        sta     $03C0,y                         ; 9221 99 C0 03                 ...
        lda     $0378,y                         ; 9224 B9 78 03                 .x.
        clc                                     ; 9227 18                       .
        adc     #$06                            ; 9228 69 06                    i.
        sta     $0378,y                         ; 922A 99 78 03                 .x.
L922D:  lda     $38                             ; 922D A5 38                    .8
        beq     L9236                           ; 922F F0 05                    ..
        ldy     #$00                            ; 9231 A0 00                    ..
        jsr     charge_flash_apply                           ; 9233 20 6B 91                  k.
L9236:  lda     #$00                            ; 9236 A9 00                    ..
        sta     $38                             ; 9238 85 38                    .8
        rts                                     ; 923A 60                       `

; ----------------------------------------------------------------------------
; -----------------------------------------------------------------------------
; fire_gyro_crystal — weapons $02 (Gyro Attack) / $03 (Crystal Eye).
; B press; slots 1-3 all empty (one shot out at a time). Spawns wpn23_type
; ($74 gyro / $73 crystal) in slot 1 with the wpn23 preset/xvel/sound;
; Crystal Eye is wall-snapped. Cost 1; shoot pose + $33 flash timer.
; -----------------------------------------------------------------------------
fire_gyro_crystal:
        lda     $14                             ; 923B A5 14                    ..
        and     #$40                            ; 923D 29 40                    )@
        beq     L92AE                           ; 923F F0 6D                    .m
        lda     $0301                           ; 9241 AD 01 03                 ...
        ora     $0302                           ; 9244 0D 02 03                 ...
        ora     $0303                           ; 9247 0D 03 03                 ...
        bne     L92AE                           ; 924A D0 62                    .b
        ldy     #$01                            ; 924C A0 01                    ..
        jsr     shot_set_facing                           ; 924E 20 54 95                  T.
        lda     #$36                            ; 9251 A9 36                    .6
        sta     L0010                           ; 9253 85 10                    ..
        lda     $0528                           ; 9255 AD 28 05                 .(.
        and     #$20                            ; 9258 29 20                    ) 
        beq     L9263                           ; 925A F0 07                    ..
        inc     L0010                           ; 925C E6 10                    ..
        lda     #$01                            ; 925E A9 01                    ..
        sta     $0421                           ; 9260 8D 21 04                 .!.
L9263:  ldy     $32                             ; 9263 A4 32                    .2
        lda     wpn23_type_tbl,y                         ; 9265 B9 A8 95                 ...
        sta     $0301                           ; 9268 8D 01 03                 ...
        lda     #$00                            ; 926B A9 00                    ..
        sta     $03A9                           ; 926D 8D A9 03                 ...
        sta     $03D9                           ; 9270 8D D9 03                 ...
        sta     $0409                           ; 9273 8D 09 04                 ...
        lda     wpn23_xvel_tbl,y                         ; 9276 B9 AE 95                 ...
        sta     $03C1                           ; 9279 8D C1 03                 ...
        sta     $03F1                           ; 927C 8D F1 03                 ...
        lda     wpn23_sound_tbl,y                         ; 927F B9 B1 95                 ...
        jsr     queue_sound                           ; 9282 20 5D EC                  ].
        lda     wpn23_preset_tbl,y                         ; 9285 B9 AB 95                 ...
        ldy     #$01                            ; 9288 A0 01                    ..
        jsr     entity_speed_preset                           ; 928A 20 F5 EA                  ..
        lda     #$01                            ; 928D A9 01                    ..
        jsr     weapon_deduct                           ; 928F 20 3D 95                  =.
        lda     $32                             ; 9292 A5 32                    .2
        sta     $5B                             ; 9294 85 5B                    .[
        cmp     #$03                            ; 9296 C9 03                    ..
        bne     L929F                           ; 9298 D0 05                    ..
        ldy     #$01                            ; 929A A0 01                    ..
        jsr     shot_snap_to_wall                           ; 929C 20 1C 95                  ..
L929F:  lda     #$10                            ; 929F A9 10                    ..
        sta     $33                             ; 92A1 85 33                    .3
        lda     $34                             ; 92A3 A5 34                    .4
        bne     L92AE                           ; 92A5 D0 07                    ..
        lda     #$01                            ; 92A7 A9 01                    ..
        sta     $34                             ; 92A9 85 34                    .4
        inc     $0558                           ; 92AB EE 58 05                 .X.
L92AE:  rts                                     ; 92AE 60                       `

; ----------------------------------------------------------------------------
; -----------------------------------------------------------------------------
; fire_water_wave — weapon $01. B press; slots 1-3 must be free. Fires only
; grounded (probe below) or riding a water line (water_line_tbl[stage] in
; vscroll rooms); blocked with a wall in the muzzle. Spawns 3 wave segments
; (type $75, preset $B2, phases 0/3/6) that crawl the ground; cost 2,
; sound $40.
; -----------------------------------------------------------------------------
fire_water_wave:
        lda     $14                             ; 92AF A5 14                    ..
        and     #$40                            ; 92B1 29 40                    )@
        beq     L92AE                           ; 92B3 F0 F9                    ..
        lda     $0301                           ; 92B5 AD 01 03                 ...
        ora     $0302                           ; 92B8 0D 02 03                 ...
        ora     $0303                           ; 92BB 0D 03 03                 ...
        bne     L92AE                           ; 92BE D0 EE                    ..
        ldy     #$01                            ; 92C0 A0 01                    ..
        jsr     shot_set_facing                           ; 92C2 20 54 95                  T.
        lda     $0421                           ; 92C5 AD 21 04                 .!.
        lsr     a                               ; 92C8 4A                       J
        ora     #$20                            ; 92C9 09 20                    . 
        tay                                     ; 92CB A8                       .
        jsr     probe_vert                           ; 92CC 20 4F 98                  O.
        lda     $48                             ; 92CF A5 48                    .H
        and     #$10                            ; 92D1 29 10                    ).
        bne     L92AE                           ; 92D3 D0 D9                    ..
        lda     $49                             ; 92D5 A5 49                    .I
        and     #$10                            ; 92D7 29 10                    ).
        bne     L92E9                           ; 92D9 D0 0E                    ..
        lda     $46                             ; 92DB A5 46                    .F
        beq     L92AE                           ; 92DD F0 CF                    ..
        ldy     $26                             ; 92DF A4 26                    .&
        lda     water_line_tbl,y                         ; 92E1 B9 E8 95                 ...
        cmp     $0378                           ; 92E4 CD 78 03                 .x.
        bne     L92AE                           ; 92E7 D0 C5                    ..
L92E9:  ldy     #$03                            ; 92E9 A0 03                    ..
L92EB:  lda     $0421                           ; 92EB AD 21 04                 .!.
        and     #$01                            ; 92EE 29 01                    ).
        ora     #$3E                            ; 92F0 09 3E                    .>
        sta     L0010                           ; 92F2 85 10                    ..
        lda     #$B2                            ; 92F4 A9 B2                    ..
        jsr     entity_speed_preset                           ; 92F6 20 F5 EA                  ..
        lda     #$75                            ; 92F9 A9 75                    .u
        sta     $0300,y                         ; 92FB 99 00 03                 ...
        lda     #$00                            ; 92FE A9 00                    ..
        sta     $0408,y                         ; 9300 99 08 04                 ...
        sta     $03A8,y                         ; 9303 99 A8 03                 ...
        lda     #$03                            ; 9306 A9 03                    ..
        sta     $03C0,y                         ; 9308 99 C0 03                 ...
        lda     #$13                            ; 930B A9 13                    ..
        sta     $0468,y                         ; 930D 99 68 04                 .h.
        lda     wave_phase_tbl,y                         ; 9310 B9 E1 95                 ...
        sta     $0498,y                         ; 9313 99 98 04                 ...
        lda     wave_flag_tbl,y                         ; 9316 B9 E4 95                 ...
        ora     $0528,y                         ; 9319 19 28 05                 .(.
        and     #$DF                            ; 931C 29 DF                    ).
        sta     $0528,y                         ; 931E 99 28 05                 .(.
        lda     $0421                           ; 9321 AD 21 04                 .!.
        sta     $0420,y                         ; 9324 99 20 04                 . .
        jsr     LEA34                           ; 9327 20 34 EA                  4.
        dey                                     ; 932A 88                       .
        bne     L92EB                           ; 932B D0 BE                    ..
        lda     $32                             ; 932D A5 32                    .2
        sta     $5B                             ; 932F 85 5B                    .[
        lda     #$02                            ; 9331 A9 02                    ..
        jsr     weapon_deduct                           ; 9333 20 3D 95                  =.
        lda     #$40                            ; 9336 A9 40                    .@
        jsr     queue_sound                           ; 9338 20 5D EC                  ].
        jmp     L929F                           ; 933B 4C 9F 92                 L..

; ----------------------------------------------------------------------------
L933E:  rts                                     ; 933E 60                       `

; ----------------------------------------------------------------------------
; -----------------------------------------------------------------------------
; fire_super_arrow — weapon $05. B press; any free slot 1-3. Spawns the
; arrow (type $76, sub_type $36|facing, shape $1A — rideable) at rest; its
; behavior accelerates it to 4 px/f and sticks it to walls. Wall-snapped
; at birth; cost 2, sound $1A.
; -----------------------------------------------------------------------------
fire_super_arrow:
        lda     $14                             ; 933F A5 14                    ..
        and     #$40                            ; 9341 29 40                    )@
        beq     L933E                           ; 9343 F0 F9                    ..
        ldy     #$03                            ; 9345 A0 03                    ..
L9347:  lda     $0300,y                         ; 9347 B9 00 03                 ...
        beq     L9350                           ; 934A F0 04                    ..
        dey                                     ; 934C 88                       .
        bne     L9347                           ; 934D D0 F8                    ..
        rts                                     ; 934F 60                       `

; ----------------------------------------------------------------------------
L9350:  jsr     shot_set_facing                           ; 9350 20 54 95                  T.
        lda     $0420,y                         ; 9353 B9 20 04                 . .
        and     #$01                            ; 9356 29 01                    ).
        ora     #$36                            ; 9358 09 36                    .6
        sta     L0010                           ; 935A 85 10                    ..
        lda     #$20                            ; 935C A9 20                    . 
        jsr     entity_speed_preset                           ; 935E 20 F5 EA                  ..
        lda     $0528,y                         ; 9361 B9 28 05                 .(.
        ora     #$01                            ; 9364 09 01                    ..
        sta     $0528,y                         ; 9366 99 28 05                 .(.
        lda     #$76                            ; 9369 A9 76                    .v
        sta     $0300,y                         ; 936B 99 00 03                 ...
        lda     #$00                            ; 936E A9 00                    ..
        sta     $03A8,y                         ; 9370 99 A8 03                 ...
        sta     $03C0,y                         ; 9373 99 C0 03                 ...
        lda     #$1A                            ; 9376 A9 1A                    ..
        sta     $0408,y                         ; 9378 99 08 04                 ...
        lda     $32                             ; 937B A5 32                    .2
        sta     $5B                             ; 937D 85 5B                    .[
        lda     #$1E                            ; 937F A9 1E                    ..
        sta     $0468,y                         ; 9381 99 68 04                 .h.
        jsr     shot_snap_to_wall                           ; 9384 20 1C 95                  ..
        lda     #$02                            ; 9387 A9 02                    ..
        jsr     weapon_deduct                           ; 9389 20 3D 95                  =.
        lda     #$1A                            ; 938C A9 1A                    ..
        jsr     queue_sound                           ; 938E 20 5D EC                  ].
        jmp     L929F                           ; 9391 4C 9F 92                 L..

; ----------------------------------------------------------------------------
; -----------------------------------------------------------------------------
; fire_napalm — weapon $04 (Napalm Bomb). B press; any free slot 1-3.
; Spawns the bomb (type $72, preset $B1, 1 px/f) with a $78-frame fuse;
; its behavior bounces it along the ground until it detonates (type $C2).
; Wall-snapped at birth; cost 1, sound $1A.
; -----------------------------------------------------------------------------
fire_napalm:
        lda     $14                             ; 9394 A5 14                    ..
        and     #$40                            ; 9396 29 40                    )@
        beq     L93E6                           ; 9398 F0 4C                    .L
        ldy     #$03                            ; 939A A0 03                    ..
L939C:  lda     $0300,y                         ; 939C B9 00 03                 ...
        beq     L93A5                           ; 939F F0 04                    ..
        dey                                     ; 93A1 88                       .
        bne     L939C                           ; 93A2 D0 F8                    ..
        rts                                     ; 93A4 60                       `

; ----------------------------------------------------------------------------
L93A5:  jsr     shot_set_facing                           ; 93A5 20 54 95                  T.
        lda     $0420,y                         ; 93A8 B9 20 04                 . .
        and     #$01                            ; 93AB 29 01                    ).
        ora     #$36                            ; 93AD 09 36                    .6
        sta     L0010                           ; 93AF 85 10                    ..
        lda     #$B1                            ; 93B1 A9 B1                    ..
        jsr     entity_speed_preset                           ; 93B3 20 F5 EA                  ..
        lda     #$00                            ; 93B6 A9 00                    ..
        sta     $0408,y                         ; 93B8 99 08 04                 ...
        lda     #$72                            ; 93BB A9 72                    .r
        sta     $0300,y                         ; 93BD 99 00 03                 ...
        jsr     LEA34                           ; 93C0 20 34 EA                  4.
        lda     $32                             ; 93C3 A5 32                    .2
        sta     $5B                             ; 93C5 85 5B                    .[
        lda     #$78                            ; 93C7 A9 78                    .x
        sta     $0468,y                         ; 93C9 99 68 04                 .h.
        lda     #$00                            ; 93CC A9 00                    ..
        sta     $03A8,y                         ; 93CE 99 A8 03                 ...
        lda     #$01                            ; 93D1 A9 01                    ..
        sta     $03C0,y                         ; 93D3 99 C0 03                 ...
        jsr     shot_snap_to_wall                           ; 93D6 20 1C 95                  ..
        lda     #$01                            ; 93D9 A9 01                    ..
        jsr     weapon_deduct                           ; 93DB 20 3D 95                  =.
        lda     #$1A                            ; 93DE A9 1A                    ..
        jsr     queue_sound                           ; 93E0 20 5D EC                  ].
        jmp     L929F                           ; 93E3 4C 9F 92                 L..

; ----------------------------------------------------------------------------
L93E6:  rts                                     ; 93E6 60                       `

; ----------------------------------------------------------------------------
; -----------------------------------------------------------------------------
; fire_star_crash — weapon $09. B press; slot 1 must be free. Forms the
; star shield (type $77, sub_type $B3) centred on the player; orbit,
; launch and metering live in its behavior ($1D:B60E).
; -----------------------------------------------------------------------------
fire_star_crash:
        lda     $14                             ; 93E7 A5 14                    ..
        and     #$40                            ; 93E9 29 40                    )@
        beq     L93E6                           ; 93EB F0 F9                    ..
        lda     $0301                           ; 93ED AD 01 03                 ...
        bne     L93E6                           ; 93F0 D0 F4                    ..
        ldy     #$01                            ; 93F2 A0 01                    ..
        lda     #$B3                            ; 93F4 A9 B3                    ..
        jsr     entity_init_pos                           ; 93F6 20 A4 EA                  ..
        lda     $0529                           ; 93F9 AD 29 05                 .).
        and     #$DF                            ; 93FC 29 DF                    ).
        sta     $0529                           ; 93FE 8D 29 05                 .).
        lda     #$77                            ; 9401 A9 77                    .w
        sta     $0301                           ; 9403 8D 01 03                 ...
        lda     #$00                            ; 9406 A9 00                    ..
        sta     $0409                           ; 9408 8D 09 04                 ...
        sta     $03A9                           ; 940B 8D A9 03                 ...
        sta     $03C1                           ; 940E 8D C1 03                 ...
        lda     $32                             ; 9411 A5 32                    .2
        sta     $5B                             ; 9413 85 5B                    .[
L9415:  rts                                     ; 9415 60                       `

; ----------------------------------------------------------------------------
; -----------------------------------------------------------------------------
; fire_power_stone — weapon $06. B press; slots 1-3 all free. Spawns 3
; stones (type $78) at stone_*_tbl offsets around the player (right/left/
; above) with spiral phases 2/6/$0C; cost 1, sound $43.
; -----------------------------------------------------------------------------
fire_power_stone:
        lda     $14                             ; 9416 A5 14                    ..
        and     #$40                            ; 9418 29 40                    )@
        beq     L9415                           ; 941A F0 F9                    ..
        lda     $0301                           ; 941C AD 01 03                 ...
        ora     $0302                           ; 941F 0D 02 03                 ...
        ora     $0303                           ; 9422 0D 03 03                 ...
        bne     L9415                           ; 9425 D0 EE                    ..
        lda     #$43                            ; 9427 A9 43                    .C
        jsr     queue_sound                           ; 9429 20 5D EC                  ].
        ldy     #$03                            ; 942C A0 03                    ..
L942E:  lda     #$AF                            ; 942E A9 AF                    ..
        jsr     entity_init_pos                           ; 9430 20 A4 EA                  ..
        lda     #$00                            ; 9433 A9 00                    ..
        sta     $0408,y                         ; 9435 99 08 04                 ...
        lda     $0330,y                         ; 9438 B9 30 03                 .0.
        clc                                     ; 943B 18                       .
        adc     stone_xofs_tbl,y                         ; 943C 79 B5 95                 y..
        sta     $0330,y                         ; 943F 99 30 03                 .0.
        lda     $0348,y                         ; 9442 B9 48 03                 .H.
        adc     stone_xscr_tbl,y                         ; 9445 79 B8 95                 y..
        sta     $0348,y                         ; 9448 99 48 03                 .H.
        lda     $0378,y                         ; 944B B9 78 03                 .x.
        clc                                     ; 944E 18                       .
        adc     stone_yofs_tbl,y                         ; 944F 79 BB 95                 y..
        sta     $0378,y                         ; 9452 99 78 03                 .x.
        lda     $0390,y                         ; 9455 B9 90 03                 ...
        adc     stone_yscr_tbl,y                         ; 9458 79 BE 95                 y..
        sta     $0390,y                         ; 945B 99 90 03                 ...
        lda     stone_phase_tbl,y                         ; 945E B9 C1 95                 ...
        sta     $0468,y                         ; 9461 99 68 04                 .h.
        lda     #$01                            ; 9464 A9 01                    ..
        sta     $0498,y                         ; 9466 99 98 04                 ...
        lda     #$78                            ; 9469 A9 78                    .x
        sta     $0300,y                         ; 946B 99 00 03                 ...
        lda     $32                             ; 946E A5 32                    .2
        sta     $5B                             ; 9470 85 5B                    .[
        dey                                     ; 9472 88                       .
        bne     L942E                           ; 9473 D0 B9                    ..
        lda     #$01                            ; 9475 A9 01                    ..
        jsr     weapon_deduct                           ; 9477 20 3D 95                  =.
        rts                                     ; 947A 60                       `

; ----------------------------------------------------------------------------
; -----------------------------------------------------------------------------
; fire_gravity_hold — weapon $07. B press; slot 1 free. Spawns the screen
; effect (type $C5, sub_type $62, vflip) at the top-centre of the camera
; view and flashes sprite palette 0 white ($0610=$20); cost 4, sound $44.
; -----------------------------------------------------------------------------
fire_gravity_hold:
        lda     $14                             ; 947B A5 14                    ..
        and     #$40                            ; 947D 29 40                    )@
        beq     L94CF                           ; 947F F0 4E                    .N
        lda     $0301                           ; 9481 AD 01 03                 ...
        bne     L94CF                           ; 9484 D0 49                    .I
        lda     #$44                            ; 9486 A9 44                    .D
        jsr     queue_sound                           ; 9488 20 5D EC                  ].
        ldy     #$01                            ; 948B A0 01                    ..
        lda     #$62                            ; 948D A9 62                    .b
        jsr     entity_init_pos                           ; 948F 20 A4 EA                  ..
        lda     $0529                           ; 9492 AD 29 05                 .).
        ora     #$80                            ; 9495 09 80                    ..
        sta     $0529                           ; 9497 8D 29 05                 .).
        lda     #$C5                            ; 949A A9 C5                    ..
        sta     $0301                           ; 949C 8D 01 03                 ...
        lda     #$06                            ; 949F A9 06                    ..
        sta     $0469                           ; 94A1 8D 69 04                 .i.
        lda     #$00                            ; 94A4 A9 00                    ..
        sta     $0391                           ; 94A6 8D 91 03                 ...
        lda     #$80                            ; 94A9 A9 80                    ..
        sta     $0379                           ; 94AB 8D 79 03                 .y.
        lda     $FC                             ; 94AE A5 FC                    ..
        clc                                     ; 94B0 18                       .
        adc     #$80                            ; 94B1 69 80                    i.
        sta     $0331                           ; 94B3 8D 31 03                 .1.
        lda     $F9                             ; 94B6 A5 F9                    ..
        adc     #$00                            ; 94B8 69 00                    i.
        sta     $0349                           ; 94BA 8D 49 03                 .I.
        lda     #$20                            ; 94BD A9 20                    . 
        sta     $0610                           ; 94BF 8D 10 06                 ...
        lda     #$FF                            ; 94C2 A9 FF                    ..
        sta     $18                             ; 94C4 85 18                    ..
        lda     $32                             ; 94C6 A5 32                    .2
        sta     $5B                             ; 94C8 85 5B                    .[
        lda     #$04                            ; 94CA A9 04                    ..
        jsr     weapon_deduct                           ; 94CC 20 3D 95                  =.
L94CF:  rts                                     ; 94CF 60                       `

; ----------------------------------------------------------------------------
; -----------------------------------------------------------------------------
; fire_beat — weapon $0C. B press; with the meter empty ($BC=$80) or Beat
; already out (slot 1), falls through to fire_buster. Spawns Beat (type $79,
; sub_type $9B) diving from the screen top (yvel $02.80, dir down, angle 8);
; no meter cost at launch; sound $3E.
; -----------------------------------------------------------------------------
fire_beat:
        lda     $14                             ; 94D0 A5 14                    ..
        and     #$40                            ; 94D2 29 40                    )@
        beq     fire_none                           ; 94D4 F0 7D                    .}
        lda     $BC                             ; 94D6 A5 BC                    ..
        cmp     #$80                            ; 94D8 C9 80                    ..
        beq     L94E1                           ; 94DA F0 05                    ..
        lda     $0301                           ; 94DC AD 01 03                 ...
        beq     L94E4                           ; 94DF F0 03                    ..
L94E1:  jmp     fire_buster                           ; 94E1 4C E3 90                 L..

; ----------------------------------------------------------------------------
L94E4:  lda     #$3E                            ; 94E4 A9 3E                    .>
        jsr     queue_sound                           ; 94E6 20 5D EC                  ].
        ldy     #$01                            ; 94E9 A0 01                    ..
        lda     #$9B                            ; 94EB A9 9B                    ..
        jsr     entity_init_pos                           ; 94ED 20 A4 EA                  ..
        lda     #$79                            ; 94F0 A9 79                    .y
        sta     $0300,y                         ; 94F2 99 00 03                 ...
        lda     $32                             ; 94F5 A5 32                    .2
        sta     $5B                             ; 94F7 85 5B                    .[
        lda     #$00                            ; 94F9 A9 00                    ..
        sta     $0408,y                         ; 94FB 99 08 04                 ...
        sta     $0378,y                         ; 94FE 99 78 03                 .x.
        sta     $03A8,y                         ; 9501 99 A8 03                 ...
        sta     $03C0,y                         ; 9504 99 C0 03                 ...
        lda     #$80                            ; 9507 A9 80                    ..
        sta     $03D8,y                         ; 9509 99 D8 03                 ...
        lda     #$02                            ; 950C A9 02                    ..
        sta     $03F0,y                         ; 950E 99 F0 03                 ...
        lda     #$08                            ; 9511 A9 08
        sta     $04B0,y                         ; 9513 99 B0 04
        lda     #$04                            ; 9516 A9 04
        sta     $0420,y                         ; 9518 99 20 04
        rts                                     ; 951B 60

; ----------------------------------------------------------------------------
; shot_snap_to_wall — probe ahead of the player; if the muzzle is inside a
; wall, move the new shot (slot Y) onto the player's x so it isn't born
; embedded in the tile. Used by Crystal Eye / Napalm Bomb / Super Arrow.
; ----------------------------------------------------------------------------
shot_snap_to_wall:
        sty     $0F                             ; 951C 84 0F
        lda     $0420,y                         ; 951E B9 20 04
        lsr     a                               ; 9521 4A
        ora     #$22                            ; 9522 09 22
        tay                                     ; 9524 A8
        jsr     probe_vert                           ; 9525 20 4F 98
        ldy     $0F                             ; 9528 A4 0F
        lda     L0010                           ; 952A A5 10
        and     #$10                            ; 952C 29 10
        beq     fire_none                       ; 952E F0 23
        lda     $0330                           ; 9530 AD 30 03
        sta     $0330,y                         ; 9533 99 30 03
        lda     $0348                           ; 9536 AD 48 03
        sta     $0348,y                         ; 9539 99 48 03
        rts                                     ; 953C 60

; ----------------------------------------------------------------------------
; --- weapon_deduct — A = cost: subtract from the current weapon's meter
; ($B0+id), clamping at $80 = empty. ---
weapon_deduct:  sta     L0000                           ; 953D 85 00                    ..
        ldy     $32                             ; 953F A4 32                    .2
        lda     $B0,y                           ; 9541 B9 B0 00                 ...
        and     #$7F                            ; 9544 29 7F                    ).
        sec                                     ; 9546 38                       8
        sbc     L0000                           ; 9547 E5 00                    ..
        bcs     L954D                           ; 9549 B0 02                    ..
        lda     #$00                            ; 954B A9 00                    ..
L954D:  ora     #$80                            ; 954D 09 80                    ..
        sta     $B0,y                           ; 954F 99 B0 00                 ...
        rts                                     ; 9552 60                       `

; ----------------------------------------------------------------------------
; --- fire_none — weapon $08 (Charge Kick): no projectile; the charge slide
; is triggered by the ground state ($8102: cost 1, sound $23, pose $B0). ---
fire_none:  rts                                     ; 9553 60                       `

; ----------------------------------------------------------------------------
; --- shot_set_facing — face the new shot (slot Y) and the player from held
; L/R input, else from the player's facing flag (gravity-flip aware). ---
shot_set_facing:  lda     $16                             ; 9554 A5 16                    ..
        and     #$03                            ; 9556 29 03                    ).
        bne     L9568                           ; 9558 D0 0E                    ..
        lda     #$02                            ; 955A A9 02                    ..
        sta     $0420,y                         ; 955C 99 20 04                 . .
        lda     $0528                           ; 955F AD 28 05                 .(.
L9562:  and     #$20                            ; 9562 29 20                    ) 
        beq     L956E                           ; 9564 F0 08                    ..
        lda     #$01                            ; 9566 A9 01                    ..
L9568:  sta     $0420,y                         ; 9568 99 20 04                 . .
        sta     $0420                           ; 956B 8D 20 04                 . .
L956E:  jmp     entity_facing_to_flags                           ; 956E 4C 30 EC                 L0.

; ----------------------------------------------------------------------------
; -----------------------------------------------------------------------------
; Weapon fire handler table + per-weapon data (see id map in the bank header)
; -----------------------------------------------------------------------------
weapon_fire_lo: .byte   $E3,$AF,$3B,$3B,$94,$3F,$16,$7B,$53,$E7,$87,$87,$D0,$E3,$E3,$E3 ; 9571
weapon_fire_hi: .byte   $90,$92,$92,$92,$93,$93,$94,$94,$95,$93,$90,$90,$94,$90,$90,$90 ; 9581
buster_tier_threshold:.byte   $28,$50,$FF       ; 9591  charge thresholds ($38 < t -> tier X)
buster_tier_preset:.byte   $18,$A8,$A9          ; 9594  shot presets: $18 norm / $A8 mid / $A9 full
buster_tier_pose:.byte   $00,$36,$36            ; 9597  pose aux ORed with facing -> $10
buster_tier_xvel_sub:.byte   $33,$00            ; 959A  xvel sub $33/$00 (tier 2 = $959C)
rush_type_tbl:  .byte   $00                     ; 959C  tier-2 xvel sub; rush reads +$0A/+$0B
buster_tier_xvel_px:.byte   $04                 ; 959D  xvel px $04 (tiers 1/2 = $959E/F)
rush_shape_tbl: .byte   $05,$05                 ; 959E  tier-1/2 xvel px; rush shape at +$0A/+$0B
buster_tier_charge:.byte   $00,$0D,$0E          ; 95A0  $5B damage tier left by the fired shot
buster_tier_sound:.byte   $1A,$20,$21           ; 95A3  fire sounds $1A/$20/$21
        .byte   $02,$45                         ; 95A6  rush_type_tbl+$0A/$0B: $02 Rush Coil / $45 Rush Jet
wpn23_type_tbl: .byte   $05,$1A                 ; 95A8  rush_shape_tbl+$0A/$0B: $05 / $1A
        .byte   $74                             ; 95AA  wpn23_type+2: $74 Gyro Attack shot
wpn23_preset_tbl:.byte   $73                    ; 95AB  wpn23_type+3: $73 Crystal Eye shot
        .byte   $72                             ; 95AC
        .byte   $AA                             ; 95AD  wpn23_preset+2 (Gyro)
wpn23_xvel_tbl: .byte   $AC                     ; 95AE  wpn23_preset+3 (Crystal)
        .byte   $B1                             ; 95AF
        .byte   $03                             ; 95B0  wpn23_xvel+2: 3 px/f (Gyro)
wpn23_sound_tbl:.byte   $04                     ; 95B1  wpn23_xvel+3: 4 px/f (Crystal)
        .byte   $01                             ; 95B2
        .byte   $41                             ; 95B3  wpn23_sound+2: $41 (Gyro)
        .byte   $1A                             ; 95B4  wpn23_sound+3: $1A (Crystal)
stone_xofs_tbl: .byte   $1A,$14,$EC             ; 95B5  x offs +1..3: +$14 / -$14 / 0
stone_xscr_tbl: .byte   $00,$00,$FF             ; 95B8  x screen adj +1..3: 0 / -1 / 0
stone_yofs_tbl: .byte   $00,$10,$10             ; 95BB  y offs +1..3: +$10 / +$10 / -$18
stone_yscr_tbl: .byte   $E8,$00,$00             ; 95BE  y screen adj +1..3: 0 / 0 / -1
stone_phase_tbl:.byte   $FF,$02,$06,$0C         ; 95C1  spiral phase +1..3: 2 / 6 / $0C
weapon_empty_tbl:.byte   $00,$80,$80,$80,$80,$80,$80,$80,$00,$80,$00,$00,$00,$00,$00,$00 ; 95C5  per-id empty value ($80 = metered)
        .byte   $BC,$00,$00,$00,$00,$00,$00,$00,$BC,$CC,$00,$BC ; 95D5  (unreferenced)
wave_phase_tbl: .byte   $00,$00,$03             ; 95E1  segment phase +1..3: 0 / 3 / 6
wave_flag_tbl:  .byte   $06,$00,$04,$04         ; 95E4  segment ent_flags OR +1..3
water_line_tbl: .byte   $00,$00,$00,$B4,$00,$00,$00,$00,$00,$00,$00,$B4,$C4,$00,$00,$00 ; 95E8  water-surface y per stage bank (vscroll)
; -----------------------------------------------------------------------------
; ladder_grab_up — Up held (ladder_up_mask by gravity flip): probe above/
; below; a ladder tile ($20) at head, body or feet grabs on: state $03,
; x snapped to the rung centre, climb impulse $01.4C, climb pose $0A.
; -----------------------------------------------------------------------------
ladder_grab_up:  lda     $16                             ; 95F8 A5 16                    ..
        ldy     $AF                             ; 95FA A4 AF                    ..
        and     ladder_up_mask,y                         ; 95FC 39 69 90                 9i.
        beq     L964B                           ; 95FF F0 4A                    .J
        lda     $0528                           ; 9601 AD 28 05                 .(.
        bpl     L964B                           ; 9604 10 45                    .E
        lda     #$02                            ; 9606 A9 02                    ..
        ora     $AF                             ; 9608 05 AF                    ..
        tay                                     ; 960A A8                       .
        jsr     probe_vert                           ; 960B 20 4F 98                  O.
        lda     $0390                           ; 960E AD 90 03                 ...
        bne     L964B                           ; 9611 D0 38                    .8
        lda     $AF                             ; 9613 A5 AF                    ..
        beq     L961F                           ; 9615 F0 08                    ..
        lda     $4A                             ; 9617 A5 4A                    .J
        cmp     #$20                            ; 9619 C9 20                    . 
        beq     L962B                           ; 961B F0 0E                    ..
        bne     L9625                           ; 961D D0 06                    ..
L961F:  lda     $48                             ; 961F A5 48                    .H
        cmp     #$20                            ; 9621 C9 20                    . 
        beq     L962B                           ; 9623 F0 06                    ..
L9625:  lda     $49                             ; 9625 A5 49                    .I
        cmp     #$20                            ; 9627 C9 20                    . 
        bne     L964B                           ; 9629 D0 20                    . 
L962B:  lda     #$03                            ; 962B A9 03                    ..
        sta     $30                             ; 962D 85 30                    .0
        lda     $0330                           ; 962F AD 30 03                 .0.
        and     #$F0                            ; 9632 29 F0                    ).
        ora     #$08                            ; 9634 09 08                    ..
        sta     $0330                           ; 9636 8D 30 03                 .0.
        lda     #$4C                            ; 9639 A9 4C                    .L
        sta     $03D8                           ; 963B 8D D8 03                 ...
        lda     #$01                            ; 963E A9 01                    ..
        sta     $03F0                           ; 9640 8D F0 03                 ...
        lda     #$0A                            ; 9643 A9 0A                    ..
        clc                                     ; 9645 18                       .
        adc     $34                             ; 9646 65 34                    e4
        jsr     entity_set_subtype                           ; 9648 20 98 EA                  ..
L964B:  rts                                     ; 964B 60                       `

; ----------------------------------------------------------------------------
; -----------------------------------------------------------------------------
; player_env_effects — per-frame surface/room effects (C = grounded from
; entity_gravity_collide; probe results preserved):
;  - conveyor belts: floor tile $50/$70 sets belt dir $39 and drags the
;    player $00.80/frame (velocity+facing swapped in, then restored)
;  - stage banks 3/$0B/$0C vscroll rooms: side-wall contact latches $36=$F0
;  - water (stage-alt bank 4 = always submerged; stage bank $0D pools):
;    crossing the surface spawns a splash (sub_type $8B, sound $3A);
;    $52 = splash cooldown, $53 = last water state
;  - stage bank 5, scroll screens 5-$12 (jet-ski run): alternating wake
;    sounds $33/$34 and a 1px scroll-y bob (jetski_wake_time/jetski_wake_sound/jetski_bob_y)
;  - every 2nd frame: behind-background priority (ent_flags bit 4) while
;    the head/feet probes sit in tile $60
; -----------------------------------------------------------------------------
player_env_effects:  php                                     ; 964C 08                       .
        lda     $49                             ; 964D A5 49                    .I
        pha                                     ; 964F 48                       H
        lda     $11                             ; 9650 A5 11                    ..
        pha                                     ; 9652 48                       H
        lda     $39                             ; 9653 A5 39                    .9
        bne     L9684                           ; 9655 D0 2D                    .-
        bcs     L965C                           ; 9657 B0 03                    ..
        jmp     L96E5                           ; 9659 4C E5 96                 L..

; ----------------------------------------------------------------------------
L965C:  lda     #$01                            ; 965C A9 01                    ..
        sta     $39                             ; 965E 85 39                    .9
        lda     $49                             ; 9660 A5 49                    .I
        cmp     #$50                            ; 9662 C9 50                    .P
        beq     L967C                           ; 9664 F0 16                    ..
        cmp     #$70                            ; 9666 C9 70                    .p
        beq     L967A                           ; 9668 F0 10                    ..
        lda     $48                             ; 966A A5 48                    .H
        cmp     $49                             ; 966C C5 49                    .I
        bne     L9672                           ; 966E D0 02                    ..
        lda     $4A                             ; 9670 A5 4A                    .J
L9672:  cmp     #$50                            ; 9672 C9 50                    .P
        beq     L967C                           ; 9674 F0 06                    ..
        cmp     #$70                            ; 9676 C9 70                    .p
        bne     L96C0                           ; 9678 D0 46                    .F
L967A:  inc     $39                             ; 967A E6 39                    .9
L967C:  lda     #$80                            ; 967C A9 80                    ..
        sta     $3A                             ; 967E 85 3A                    .:
        lda     #$00                            ; 9680 A9 00                    ..
        sta     $3B                             ; 9682 85 3B                    .;
L9684:  lda     $0528                           ; 9684 AD 28 05                 .(.
        pha                                     ; 9687 48                       H
        lda     $03A8                           ; 9688 AD A8 03                 ...
        pha                                     ; 968B 48                       H
        lda     $03C0                           ; 968C AD C0 03                 ...
        pha                                     ; 968F 48                       H
        lda     $0420                           ; 9690 AD 20 04                 . .
        pha                                     ; 9693 48                       H
        lda     $3A                             ; 9694 A5 3A                    .:
        sta     $03A8                           ; 9696 8D A8 03                 ...
        lda     $3B                             ; 9699 A5 3B                    .;
        sta     $03C0                           ; 969B 8D C0 03                 ...
        lda     $39                             ; 969E A5 39                    .9
        sta     $0420                           ; 96A0 8D 20 04                 . .
        ldy     #$00                            ; 96A3 A0 00                    ..
        lda     $30                             ; 96A5 A5 30                    .0
        cmp     #$02                            ; 96A7 C9 02                    ..
        bne     L96AD                           ; 96A9 D0 02                    ..
        ldy     #$04                            ; 96AB A0 04                    ..
L96AD:  jsr     entity_horiz_dispatch                           ; 96AD 20 3F EA                  ?.
        pla                                     ; 96B0 68                       h
        sta     $0420                           ; 96B1 8D 20 04                 . .
        pla                                     ; 96B4 68                       h
        sta     $03C0                           ; 96B5 8D C0 03                 ...
        pla                                     ; 96B8 68                       h
        sta     $03A8                           ; 96B9 8D A8 03                 ...
        pla                                     ; 96BC 68                       h
        sta     $0528                           ; 96BD 8D 28 05                 .(.
L96C0:  lda     #$00                            ; 96C0 A9 00                    ..
        sta     $39                             ; 96C2 85 39                    .9
        lda     $46                             ; 96C4 A5 46                    .F
        beq     L96E5                           ; 96C6 F0 1D                    ..
        ldy     $26                             ; 96C8 A4 26                    .&
        lda     wall_latch_stage_tbl,y                         ; 96CA B9 CF 97                 ...
        beq     L96E5                           ; 96CD F0 16                    ..
        ldy     #$25                            ; 96CF A0 25                    .%
        lda     $30                             ; 96D1 A5 30                    .0
        cmp     #$02                            ; 96D3 C9 02                    ..
        bne     L96D8                           ; 96D5 D0 01                    ..
        iny                                     ; 96D7 C8                       .
L96D8:  jsr     tile_collide_horiz                           ; 96D8 20 A1 C4                  ..
        lda     L0010                           ; 96DB A5 10                    ..
        and     #$10                            ; 96DD 29 10                    ).
        beq     L96E5                           ; 96DF F0 04                    ..
        lda     #$F0                            ; 96E1 A9 F0                    ..
        sta     $36                             ; 96E3 85 36                    .6
L96E5:  lda     $27                             ; 96E5 A5 27                    .'
        cmp     #$04                            ; 96E7 C9 04                    ..
        bne     L96F3                           ; 96E9 D0 08                    ..
        lda     #$80                            ; 96EB A9 80                    ..
        sta     L0010                           ; 96ED 85 10                    ..
        sta     $53                             ; 96EF 85 53                    .S
        bne     L9728                           ; 96F1 D0 35                    .5
L96F3:  lda     $26                             ; 96F3 A5 26                    .&
        cmp     #$0D                            ; 96F5 C9 0D                    ..
        beq     L96FF                           ; 96F7 F0 06                    ..
        lda     #$00                            ; 96F9 A9 00                    ..
        sta     $52                             ; 96FB 85 52                    .R
        beq     L9766                           ; 96FD F0 67                    .g
L96FF:  lda     $0378                           ; 96FF AD 78 03                 .x.
        cmp     #$E0                            ; 9702 C9 E0                    ..
        bcs     L9724                           ; 9704 B0 1E                    ..
        lda     $0390                           ; 9706 AD 90 03                 ...
        bne     L9724                           ; 9709 D0 19                    ..
        ldy     #$06                            ; 970B A0 06                    ..
        jsr     probe_horiz                           ; 970D 20 45 98                  E.
        lda     L0010                           ; 9710 A5 10                    ..
        cmp     #$80                            ; 9712 C9 80                    ..
        beq     L9728                           ; 9714 F0 12                    ..
        cmp     #$20                            ; 9716 C9 20                    . 
        beq     L9724                           ; 9718 F0 0A                    ..
        cmp     #$40                            ; 971A C9 40                    .@
        beq     L9724                           ; 971C F0 06                    ..
        lda     #$00                            ; 971E A9 00                    ..
        sta     L0010                           ; 9720 85 10                    ..
        beq     L9728                           ; 9722 F0 04                    ..
L9724:  lda     $53                             ; 9724 A5 53                    .S
        sta     L0010                           ; 9726 85 10                    ..
L9728:  lda     $52                             ; 9728 A5 52                    .R
        bne     L9734                           ; 972A D0 08                    ..
        lda     L0010                           ; 972C A5 10                    ..
        beq     L9736                           ; 972E F0 06                    ..
        lda     #$03                            ; 9730 A9 03                    ..
        sta     $52                             ; 9732 85 52                    .R
L9734:  dec     $52                             ; 9734 C6 52                    .R
L9736:  lda     L0010                           ; 9736 A5 10                    ..
        cmp     $53                             ; 9738 C5 53                    .S
        beq     L9766                           ; 973A F0 2A                    .*
        sta     $53                             ; 973C 85 53                    .S
        lda     L0010                           ; 973E A5 10                    ..
        bne     L9749                           ; 9740 D0 07                    ..
        lda     $11                             ; 9742 A5 11                    ..
        clc                                     ; 9744 18                       .
        adc     #$10                            ; 9745 69 10                    i.
        sta     $11                             ; 9747 85 11                    ..
L9749:  lda     $0305                           ; 9749 AD 05 03                 ...
        bne     L9766                           ; 974C D0 18                    ..
        ldy     #$05                            ; 974E A0 05                    ..
        lda     #$8B                            ; 9750 A9 8B                    ..
        jsr     entity_init_pos                           ; 9752 20 A4 EA                  ..
        lda     #$01                            ; 9755 A9 01                    ..
        sta     $0300,y                         ; 9757 99 00 03                 ...
        lda     $11                             ; 975A A5 11                    ..
        and     #$F0                            ; 975C 29 F0                    ).
        sta     $0378,y                         ; 975E 99 78 03                 .x.
        lda     #$3A                            ; 9761 A9 3A                    .:
        jsr     queue_sound                           ; 9763 20 5D EC                  ].
L9766:  lda     $26                             ; 9766 A5 26                    .&
        cmp     #$05                            ; 9768 C9 05                    ..
        bne     L9795                           ; 976A D0 29                    .)
        lda     $F9                             ; 976C A5 F9                    ..
        cmp     #$13                            ; 976E C9 13                    ..
        beq     L9795                           ; 9770 F0 23                    .#
        cmp     #$05                            ; 9772 C9 05                    ..
        bcc     L9795                           ; 9774 90 1F                    ..
        dec     $57                             ; 9776 C6 57                    .W
        bne     L9795                           ; 9778 D0 1B                    ..
        lda     $58                             ; 977A A5 58                    .X
        inc     $58                             ; 977C E6 58                    .X
        and     #$01                            ; 977E 29 01                    ).
        tay                                     ; 9780 A8                       .
        lda     jetski_wake_time,y                         ; 9781 B9 C9 97                 ...
        sta     $57                             ; 9784 85 57                    .W
        lda     jetski_wake_sound,y                         ; 9786 B9 CB 97                 ...
        jsr     queue_sound                           ; 9789 20 5D EC                  ].
        lda     $99                             ; 978C A5 99                    ..
        bne     L9795                           ; 978E D0 05                    ..
        lda     jetski_bob_y,y                         ; 9790 B9 CD 97                 ...
        sta     $FA                             ; 9793 85 FA                    ..
L9795:  lda     $9D                             ; 9795 A5 9D                    ..
        lsr     a                               ; 9797 4A                       J
        lsr     a                               ; 9798 4A                       J
        bcs     L97C1                           ; 9799 B0 26                    .&
        lda     $0528                           ; 979B AD 28 05                 .(.
        and     #$EF                            ; 979E 29 EF                    ).
        sta     $0528                           ; 97A0 8D 28 05                 .(.
        ldy     #$18                            ; 97A3 A0 18                    ..
        jsr     probe_vert                           ; 97A5 20 4F 98                  O.
        lda     $42                             ; 97A8 A5 42                    .B
        cmp     #$60                            ; 97AA C9 60                    .`
        beq     L97B9                           ; 97AC F0 0B                    ..
        ldy     #$19                            ; 97AE A0 19                    ..
        jsr     probe_vert                           ; 97B0 20 4F 98                  O.
        lda     $42                             ; 97B3 A5 42                    .B
        cmp     #$60                            ; 97B5 C9 60                    .`
        bne     L97C1                           ; 97B7 D0 08                    ..
L97B9:  lda     $0528                           ; 97B9 AD 28 05                 .(.
        ora     #$10                            ; 97BC 09 10                    ..
        sta     $0528                           ; 97BE 8D 28 05                 .(.
L97C1:  pla                                     ; 97C1 68                       h
        sta     $11                             ; 97C2 85 11                    ..
        pla                                     ; 97C4 68                       h
        sta     $49                             ; 97C5 85 49                    .I
        plp                                     ; 97C7 28                       (
        rts                                     ; 97C8 60                       `

; ----------------------------------------------------------------------------
jetski_wake_time:  .byte $14,$50               ; 97C9  frames between wakes
jetski_wake_sound: .byte $33,$34               ; 97CB  alternating wake sfx
jetski_bob_y:   .byte   $01,$00                ; 97CD  scroll-y bob
; nonzero = vscroll side-wall latch stage banks (3/$0B/$0C)
wall_latch_stage_tbl:
        .byte   $00,$00,$00,$FF,$00,$00,$00,$00 ; 97CF
        .byte   $00,$00,$00,$FF,$FF,$00,$00,$00 ; 97D7
; -----------------------------------------------------------------------------
; landing_surface_fx — while grounded (C set) in stage-alt-bank 3 rooms:
; a foot probe on tile $30 spawns a surface-contact effect actor (type
; $0C, preset $62) at the fixed line y=$C8, claiming its sprite bank via
; LD8A2/LD8C7; ent_var6 = $1E/$1F for the matching side.
; -----------------------------------------------------------------------------
landing_surface_fx:  bcc     L9844                           ; 97DF 90 63                    .c
        php                                     ; 97E1 08                       .
        lda     $27                             ; 97E2 A5 27                    .'
        cmp     #$03                            ; 97E4 C9 03                    ..
        bne     L9843                           ; 97E6 D0 5B                    .[
        lda     #$1E                            ; 97E8 A9 1E                    ..
        sta     L0010                           ; 97EA 85 10                    ..
        lda     $48                             ; 97EC A5 48                    .H
        cmp     #$30                            ; 97EE C9 30                    .0
        beq     L97FA                           ; 97F0 F0 08                    ..
        lda     $4A                             ; 97F2 A5 4A                    .J
        cmp     #$30                            ; 97F4 C9 30                    .0
        bne     L9843                           ; 97F6 D0 4B                    .K
        inc     L0010                           ; 97F8 E6 10                    ..
L97FA:  jsr     find_free_slot_y                           ; 97FA 20 6F F1                  o.
        bcs     L9843                           ; 97FD B0 44                    .D
        lda     #$62                            ; 97FF A9 62                    .b
        jsr     entity_speed_preset                           ; 9801 20 F5 EA                  ..
        lda     #$00                            ; 9804 A9 00                    ..
        sta     $0408,y                         ; 9806 99 08 04                 ...
        lda     $0528,y                         ; 9809 B9 28 05                 .(.
        and     #$DF                            ; 980C 29 DF                    ).
        ora     #$0A                            ; 980E 09 0A                    ..
        sta     $0528,y                         ; 9810 99 28 05                 .(.
        lda     $0330,y                         ; 9813 B9 30 03                 .0.
        and     #$F0                            ; 9816 29 F0                    ).
        ora     #$08                            ; 9818 09 08                    ..
        sta     $0330,y                         ; 981A 99 30 03                 .0.
        lda     #$C8                            ; 981D A9 C8                    ..
        sta     $0378,y                         ; 981F 99 78 03                 .x.
        lda     #$0C                            ; 9822 A9 0C                    ..
        sta     $0300,y                         ; 9824 99 00 03                 ...
        lda     #$2A                            ; 9827 A9 2A                    .*
        sta     $0468,y                         ; 9829 99 68 04                 .h.
        jsr     LEA34                           ; 982C 20 34 EA                  4.
        tya                                     ; 982F 98                       .
        tax                                     ; 9830 AA                       .
        jsr     LD8A2                           ; 9831 20 A2 D8                  ..
        jsr     LD8C7                           ; 9834 20 C7 D8                  ..
        lda     $22                             ; 9837 A5 22                    ."
        sta     $0480,x                         ; 9839 9D 80 04                 ...
        lda     L0010                           ; 983C A5 10                    ..
        sta     $0498,x                         ; 983E 9D 98 04                 ...
        ldx     #$00                            ; 9841 A2 00                    ..
L9843:  plp                                     ; 9843 28                       (
L9844:  rts                                     ; 9844 60                       `

; ----------------------------------------------------------------------------
; --- probe_horiz — tile_collide_horiz with the spike latch ($36) preserved. ---
probe_horiz:  lda     $36                             ; 9845 A5 36                    .6
        pha                                     ; 9847 48                       H
        jsr     tile_collide_horiz                           ; 9848 20 A1 C4                  ..
        pla                                     ; 984B 68                       h
        sta     $36                             ; 984C 85 36                    .6
        rts                                     ; 984E 60                       `

; ----------------------------------------------------------------------------
; --- probe_vert — tile_collide_vert with the spike latch ($36) preserved
; (steering probes must not overwrite contact damage state). ---
probe_vert:  lda     $36                             ; 984F A5 36                    .6
        pha                                     ; 9851 48                       H
        jsr     tile_collide_vert                           ; 9852 20 AA C5                  ..
        pla                                     ; 9855 68                       h
        sta     $36                             ; 9856 85 36                    .6
        rts                                     ; 9858 60                       `

; ----------------------------------------------------------------------------
; --- clamp_x_to_screen — keep the player inside the visible strip
; [camera+$10 .. camera+$F2] (jet-ski and other forced-scroll rides). ---
clamp_x_to_screen:  lda     #$FF                            ; 9859 A9 FF                    ..
        sta     $03                             ; 985B 85 03                    ..
        lda     $0330                           ; 985D AD 30 03                 .0.
        sec                                     ; 9860 38                       8
        sbc     $FC                             ; 9861 E5 FC                    ..
        sta     L0000                           ; 9863 85 00                    ..
        sec                                     ; 9865 38                       8
        sbc     #$10                            ; 9866 E9 10                    ..
        sta     $02                             ; 9868 85 02                    ..
        bcc     L9878                           ; 986A 90 0C                    ..
        inc     $03                             ; 986C E6 03                    ..
        lda     L0000                           ; 986E A5 00                    ..
        sbc     #$F2                            ; 9870 E9 F2                    ..
        sta     $02                             ; 9872 85 02                    ..
        bcc     L9889                           ; 9874 90 13                    ..
        beq     L9889                           ; 9876 F0 11                    ..
L9878:  lda     $0330                           ; 9878 AD 30 03                 .0.
        sec                                     ; 987B 38                       8
        sbc     $02                             ; 987C E5 02                    ..
        sta     $0330                           ; 987E 8D 30 03                 .0.
        lda     $0348                           ; 9881 AD 48 03                 .H.
        sbc     $03                             ; 9884 E5 03                    ..
        sta     $0348                           ; 9886 8D 48 03                 .H.
L9889:  rts                                     ; 9889 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; SPAWN ENGINE — $1B:988A (runs each frame with the stage bank at $A000)
; Walks the stage's position-sorted spawn list as the camera moves:
; $AD = ahead cursor, $AE = behind cursor (leftward re-entry), camera
; edges from scroll_x/scroll_x_hi. Stage-bank tables: $AA00[i] screen,
; $AA80[i] X px, $AB80[i] code. Codes >= $C0 are palette / CHR-anim
; commands (palette-cycle program slots $05F0+, static palette rows
; into PAL_BUF + backup, background CHR-anim program $05D0); < $C0
; spawn an enemy (entry at $9995).
; =============================================================================
spawn_engine:
        clc                                     ; 988A 18                       .
        lda     $FC                             ; 988B A5 FC                    ..
        sta     $02                             ; 988D 85 02                    ..
        adc     #$FF                            ; 988F 69 FF                    i.
        sta     $04                             ; 9891 85 04                    ..
        lda     $F9                             ; 9893 A5 F9                    ..
        sta     $03                             ; 9895 85 03                    ..
        adc     #$00                            ; 9897 69 00                    i.
        sta     $05                             ; 9899 85 05                    ..
        lda     $AC                             ; 989B A5 AC                    ..
        and     #$01                            ; 989D 29 01                    ).
        bne     L98D9                           ; 989F D0 38                    .8
L98A1:  ldy     $AE                             ; 98A1 A4 AE                    ..
        beq     L98BD                           ; 98A3 F0 18                    ..
        lda     $A9FF,y                         ; 98A5 B9 FF A9                 ...
        cmp     $03                             ; 98A8 C5 03                    ..
        bcc     L98BD                           ; 98AA 90 11                    ..
        bne     L98B5                           ; 98AC D0 07                    ..
        lda     $AA7F,y                         ; 98AE B9 7F AA                 ...
        cmp     $02                             ; 98B1 C5 02                    ..
        bcc     L98BD                           ; 98B3 90 08                    ..
L98B5:  dey                                     ; 98B5 88                       .
        jsr     spawn_entry                           ; 98B6 20 0A 99                  ..
        dec     $AE                             ; 98B9 C6 AE                    ..
        bne     L98A1                           ; 98BB D0 E4                    ..
L98BD:  ldy     $AD                             ; 98BD A4 AD                    ..
        beq     L98D4                           ; 98BF F0 13                    ..
L98C1:  lda     $A9FF,y                         ; 98C1 B9 FF A9                 ...
        cmp     $05                             ; 98C4 C5 05                    ..
        bcc     L98D4                           ; 98C6 90 0C                    ..
        bne     L98D1                           ; 98C8 D0 07                    ..
        lda     $AA7F,y                         ; 98CA B9 7F AA                 ...
        cmp     $04                             ; 98CD C5 04                    ..
        bcc     L98D4                           ; 98CF 90 03                    ..
L98D1:  dey                                     ; 98D1 88                       .
        bne     L98C1                           ; 98D2 D0 ED                    ..
L98D4:  sty     $AD                             ; 98D4 84 AD                    ..
        jmp     L9909                           ; 98D6 4C 09 99                 L..

; ----------------------------------------------------------------------------
L98D9:  ldy     $AD                             ; 98D9 A4 AD                    ..
        lda     $05                             ; 98DB A5 05                    ..
        cmp     $AA00,y                         ; 98DD D9 00 AA                 ...
        bcc     L98F2                           ; 98E0 90 10                    ..
        bne     L98EB                           ; 98E2 D0 07                    ..
        lda     $04                             ; 98E4 A5 04                    ..
        cmp     $AA80,y                         ; 98E6 D9 80 AA                 ...
        bcc     L98F2                           ; 98E9 90 07                    ..
L98EB:  jsr     spawn_entry                           ; 98EB 20 0A 99                  ..
        inc     $AD                             ; 98EE E6 AD                    ..
        bne     L98D9                           ; 98F0 D0 E7                    ..
L98F2:  ldy     $AE                             ; 98F2 A4 AE                    ..
L98F4:  lda     $03                             ; 98F4 A5 03                    ..
        cmp     $AA00,y                         ; 98F6 D9 00 AA                 ...
        bcc     L9907                           ; 98F9 90 0C                    ..
        bne     L9904                           ; 98FB D0 07                    ..
        lda     $02                             ; 98FD A5 02                    ..
        cmp     $AA80,y                         ; 98FF D9 80 AA                 ...
        bcc     L9907                           ; 9902 90 03                    ..
L9904:  iny                                     ; 9904 C8                       .
        bne     L98F4                           ; 9905 D0 ED                    ..
L9907:  sty     $AE                             ; 9907 84 AE                    ..
L9909:  rts                                     ; 9909 60                       `

; ----------------------------------------------------------------------------
; -----------------------------------------------------------------------------
; spawn_entry — process spawn-list entry Y. Code ($AB80) < $C0: enemy spawn.
; Code >= $C0 (& $3F -> command index into spawn_cmd_slot/prog):
;   slot < 0   -> start the background CHR-anim program ($05D0)
;   slot < $10 -> palette: prog < 0 starts a palette-cycle program in
;                 $05F0+slot; else static record spawn_pal_rec[prog] into
;                 PAL_BUF row (BG+sprite), ctl byte adds backdrop/CHR pair
;   slot >= $10 -> BG CHR bank pair spawn_chr_pairs[slot] -> R0/R1
; -----------------------------------------------------------------------------
spawn_entry:  sty     $06                             ; 990A 84 06                    ..
        lda     $AB80,y                         ; 990C B9 80 AB                 ...
        cmp     #$C0                            ; 990F C9 C0                    ..
        bcs     L9916                           ; 9911 B0 03                    ..
        jmp     spawn_enemy                     ; 9913 4C 95 99
L9916:  and     #$3F                            ; 9916 29 3F                    )?
        tay                                     ; 9918 A8                       .
        ldx     spawn_cmd_slot,y                         ; 9919 BE B2 9D                 ...
        bmi     L9933                           ; 991C 30 15                    0.
        cpx     #$10                            ; 991E E0 10                    ..
        bcs     L9985                           ; 9920 B0 63                    .c
        lda     spawn_cmd_prog,y                         ; 9922 B9 E2 9D                 ...
        bpl     L993F                           ; 9925 10 18                    ..
        sta     $05F0,x                         ; 9927 9D F0 05                 ...
        lda     #$00                            ; 992A A9 00                    ..
        sta     $05F4,x                         ; 992C 9D F4 05                 ...
        sta     $05F8,x                         ; 992F 9D F8 05                 ...
        rts                                     ; 9932 60                       `

; ----------------------------------------------------------------------------
L9933:  stx     $05D0                           ; 9933 8E D0 05                 ...
        lda     #$00                            ; 9936 A9 00                    ..
        sta     $05D2                           ; 9938 8D D2 05                 ...
        sta     $05D1                           ; 993B 8D D1 05                 ...
        rts                                     ; 993E 60                       `

; ----------------------------------------------------------------------------
L993F:  asl     a                               ; 993F 0A                       .
        asl     a                               ; 9940 0A                       .
        tay                                     ; 9941 A8                       .
        lda     spawn_pal_c1,y                         ; 9942 B9 13 9E                 ...
        sta     $0601,x                         ; 9945 9D 01 06                 ...
        sta     $0621,x                         ; 9948 9D 21 06                 .!.
        lda     spawn_pal_c2,y                         ; 994B B9 14 9E                 ...
        sta     $0602,x                         ; 994E 9D 02 06                 ...
        sta     $0622,x                         ; 9951 9D 22 06                 .".
        lda     spawn_pal_c3,y                         ; 9954 B9 15 9E                 ...
        sta     $0603,x                         ; 9957 9D 03 06                 ...
        sta     $0623,x                         ; 995A 9D 23 06                 .#.
        txa                                     ; 995D 8A                       .
        lsr     a                               ; 995E 4A                       J
        lsr     a                               ; 995F 4A                       J
        tax                                     ; 9960 AA                       .
        lda     #$00                            ; 9961 A9 00                    ..
        sta     $05F0,x                         ; 9963 9D F0 05                 ...
        lda     #$FF                            ; 9966 A9 FF                    ..
        sta     $18                             ; 9968 85 18                    ..
        ldx     spawn_pal_ctl,y                         ; 996A BE 12 9E                 ...
        beq     L9909                           ; 996D F0 9A                    ..
        bpl     L9985                           ; 996F 10 14                    ..
        txa                                     ; 9971 8A                       .
        and     #$3F                            ; 9972 29 3F                    )?
        sta     $0600                           ; 9974 8D 00 06                 ...
        sta     $0620                           ; 9977 8D 20 06                 . .
        sta     $0610                           ; 997A 8D 10 06                 ...
        sta     $0630                           ; 997D 8D 30 06                 .0.
        lda     #$FF                            ; 9980 A9 FF                    ..
        sta     $18                             ; 9982 85 18                    ..
        rts                                     ; 9984 60                       `

; ----------------------------------------------------------------------------
L9985:  lda     spawn_chr_pairs,x                         ; 9985 BD 56 9E                 .V.
        sta     $EA                             ; 9988 85 EA                    ..
        lda     spawn_chr_pairs+1,x                         ; 998A BD 57 9E                 .W.
        sta     $EB                             ; 998D 85 EB                    ..
        lda     #$00                            ; 998F A9 00                    ..
        sta     $05D0                           ; 9991 8D D0 05                 ...
L9994:  rts                                     ; 9994 60                       `

; ----------------------------------------------------------------------------
; -----------------------------------------------------------------------------
; SPAWN ENEMY — $1B:9995 (spawn code < $C0 in $06)
; Skips if this spawn index is already active or its bit is set in the
; $0100 no-respawn bitmap. Fills the new slot from the stage tables
; ($AA00/$AA80/$AB00 screen/X/Y) and this bank's parallel parameter
; tables indexed by code: flags, type, shape, sub-type, HP, and a
; speed row into the xvel tables. Spawn code is kept in $0510.
; -----------------------------------------------------------------------------
spawn_enemy:
        ldx     #$17                            ; 9995 A2 17                    ..
        lda     $06                             ; 9997 A5 06                    ..
L9999:  cmp     $0438,x                         ; 9999 DD 38 04                 .8.
        beq     L9994                           ; 999C F0 F6                    ..
        dex                                     ; 999E CA                       .
        cpx     #$07                            ; 999F E0 07                    ..
        bne     L9999                           ; 99A1 D0 F6                    ..
        jsr     find_free_slot_x                           ; 99A3 20 5F F1                  _.
        bcs     L9994                           ; 99A6 B0 EC                    ..
        lda     $06                             ; 99A8 A5 06                    ..
        and     #$07                            ; 99AA 29 07                    ).
        tay                                     ; 99AC A8                       .
        lda     $F2B2,y                         ; 99AD B9 B2 F2                 ...
        sta     $07                             ; 99B0 85 07                    ..
        lda     $06                             ; 99B2 A5 06                    ..
        lsr     a                               ; 99B4 4A                       J
        lsr     a                               ; 99B5 4A                       J
        lsr     a                               ; 99B6 4A                       J
        tay                                     ; 99B7 A8                       .
        lda     $0100,y                         ; 99B8 B9 00 01                 ...
        and     $07                             ; 99BB 25 07                    %.
        bne     L9994                           ; 99BD D0 D5                    ..
        lda     $06                             ; 99BF A5 06                    ..
        sta     $0438,x                         ; 99C1 9D 38 04                 .8.
        tay                                     ; 99C4 A8                       .
        lda     $AA00,y                         ; 99C5 B9 00 AA                 ...
        sta     $0348,x                         ; 99C8 9D 48 03                 .H.
        lda     $AA80,y                         ; 99CB B9 80 AA                 ...
        sta     $0330,x                         ; 99CE 9D 30 03                 .0.
        lda     $AB00,y                         ; 99D1 B9 00 AB                 ...
        sta     $0378,x                         ; 99D4 9D 78 03                 .x.
        lda     $AB80,y                         ; 99D7 B9 80 AB                 ...
        sta     $0510,x                         ; 99DA 9D 10 05                 ...
        tay                                     ; 99DD A8                       .
        lda     spawn_flags_tbl,y                         ; 99DE B9 42 9A                 .B.
        pha                                     ; 99E1 48                       H
        and     #$7F                            ; 99E2 29 7F                    ).
        sta     $0528,x                         ; 99E4 9D 28 05                 .(.
        lda     spawn_type_tbl,y                         ; 99E7 B9 D2 9A                 ...
        sta     $0300,x                         ; 99EA 9D 00 03                 ...
        lda     spawn_shape_tbl,y                         ; 99ED B9 62 9B                 .b.
        sta     $0408,x                         ; 99F0 9D 08 04                 ...
        lda     spawn_subtype_tbl,y                         ; 99F3 B9 F2 9B                 ...
        jsr     entity_set_subtype                           ; 99F6 20 98 EA                  ..
        jsr     entity_set_facing                           ; 99F9 20 16 EC                  ..
        lda     spawn_hp_tbl,y                         ; 99FC B9 82 9C                 ...
        sta     $0450,x                         ; 99FF 9D 50 04                 .P.
        lda     spawn_speed_tbl,y                         ; 9A02 B9 12 9D                 ...
        tay                                     ; 9A05 A8                       .
        lda     spawn_xvel_sub_tbl,y                         ; 9A06 B9 A2 9D                 ...
        sta     $03A8,x                         ; 9A09 9D A8 03                 ...
        lda     spawn_xvel_px_tbl,y                         ; 9A0C B9 AA 9D                 ...
        sta     $03C0,x                         ; 9A0F 9D C0 03                 ...
        jsr     entity_stop_y                           ; 9A12 20 1E EA                  ..
        lda     #$00                            ; 9A15 A9 00                    ..
        sta     $0390,x                         ; 9A17 9D 90 03                 ...
        sta     $0318,x                         ; 9A1A 9D 18 03                 ...
        sta     $0360,x                         ; 9A1D 9D 60 03                 .`.
        sta     $0588,x                         ; 9A20 9D 88 05                 ...
        sta     $05A0,x                         ; 9A23 9D A0 05                 ...
        sta     $0468,x                         ; 9A26 9D 68 04                 .h.
        sta     $0480,x                         ; 9A29 9D 80 04                 ...
        sta     $0498,x                         ; 9A2C 9D 98 04                 ...
        sta     $04B0,x                         ; 9A2F 9D B0 04                 ...
        sta     $04C8,x                         ; 9A32 9D C8 04                 ...
        sta     $04E0,x                         ; 9A35 9D E0 04                 ...
        sta     $04F8,x                         ; 9A38 9D F8 04                 ...
        pla                                     ; 9A3B 68                       h
        bmi     L9A41                           ; 9A3C 30 03                    0.
        jsr     entity_facing_to_flags                           ; 9A3E 20 30 EC                  0.
L9A41:  rts                                     ; 9A41 60                       `

; ----------------------------------------------------------------------------
; -----------------------------------------------------------------------------
; Per-code enemy parameter tables (indexed by spawn code $00-$8F). Flags
; bit 7 clear = face the player at spawn (entity_facing_to_flags).
; -----------------------------------------------------------------------------
spawn_flags_tbl: .byte   $08,$00,$00,$00,$00,$00,$00,$00,$00,$00,$84,$00,$08,$00,$88,$C8 ; 9A42  codes $00-$0F
        .byte   $84,$04,$80,$80,$00,$00,$00,$00,$00,$00,$40,$00,$40,$00,$08,$08 ; 9A52  codes $10-$1F
        .byte   $89,$89,$89,$89,$89,$89,$89,$89,$A4,$00,$00,$00,$04,$A8,$88,$A8 ; 9A62  codes $20-$2F
        .byte   $88,$00,$80,$80,$80,$00,$00,$00,$00,$00,$00,$00,$88,$A8,$88,$00 ; 9A72  codes $30-$3F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$88,$00,$A0,$08 ; 9A82  codes $40-$4F
        .byte   $00,$00,$02,$02,$02,$02,$00,$00,$00,$04,$04,$06,$04,$04,$04,$04 ; 9A92  codes $50-$5F
        .byte   $00,$00,$04,$04,$14,$04,$04,$04,$04,$04,$04,$04,$04,$00,$00,$00 ; 9AA2  codes $60-$6F
        .byte   $00,$00,$10,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$A8 ; 9AB2  codes $70-$7F
        .byte   $84,$80,$84,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80 ; 9AC2  codes $80-$8F
spawn_type_tbl: .byte   $10,$12,$13,$15,$16,$17,$18,$19,$1B,$1D,$26,$1F,$20,$21,$23,$23 ; 9AD2  codes $00-$0F
        .byte   $24,$38,$28,$27,$2B,$31,$33,$35,$2A,$36,$36,$59,$63,$64,$9C,$9C ; 9AE2  codes $10-$1F
        .byte   $2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$35,$9E,$3A,$3B,$3E,$3D,$3D,$3D ; 9AF2  codes $20-$2F
        .byte   $3D,$50,$53,$54,$56,$BD,$66,$5A,$5C,$5D,$5F,$60,$3D,$3D,$3D,$66 ; 9B02  codes $30-$3F
        .byte   $04,$05,$06,$07,$06,$07,$08,$09,$0A,$0B,$0E,$0F,$40,$41,$42,$43 ; 9B12  codes $40-$4F
        .byte   $44,$47,$48,$48,$48,$49,$4A,$4B,$4C,$4F,$71,$7A,$7C,$A0,$A2,$A5 ; 9B22  codes $50-$5F
        .byte   $67,$68,$B3,$B3,$B3,$B3,$B3,$B3,$B3,$B3,$B3,$B3,$B3,$00,$00,$00 ; 9B32  codes $60-$6F
        .byte   $AF,$B0,$B9,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$3D ; 9B42  codes $70-$7F
        .byte   $22,$B6,$B6,$B6,$B6,$B6,$B6,$B6,$B6,$B6,$B6,$B6,$B6,$B6,$B6,$B6 ; 9B52  codes $80-$8F
spawn_shape_tbl: .byte   $80,$C0,$C0,$C0,$CB,$D1,$92,$D2,$93,$89,$96,$C0,$EE,$D7,$01,$01 ; 9B62  codes $00-$0F
        .byte   $00,$00,$D0,$00,$CC,$C8,$CC,$CD,$88,$F0,$F0,$A4,$C1,$C8,$AF,$AF ; 9B72  codes $10-$1F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$CD,$91,$C0,$C8,$CD,$C1,$C1,$C1 ; 9B82  codes $20-$2F
        .byte   $C1,$81,$C0,$CC,$90,$CC,$D1,$A2,$C1,$D7,$CE,$CA,$C1,$C1,$C1,$D1 ; 9B92  codes $30-$3F
        .byte   $00,$00,$04,$04,$02,$02,$03,$00,$02,$02,$00,$03,$A8,$00,$00,$D9 ; 9BA2  codes $40-$4F
        .byte   $A7,$00,$1D,$1E,$1F,$03,$00,$00,$00,$89,$E1,$A1,$A9,$89,$00,$AB ; 9BB2  codes $50-$5F
        .byte   $C0,$C1,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$C0,$00,$00 ; 9BC2  codes $60-$6F
        .byte   $06,$06,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$C1 ; 9BD2  codes $70-$7F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9BE2  codes $80-$8F
spawn_subtype_tbl: .byte   $48,$2F,$27,$90,$49,$2E,$23,$31,$43,$26,$22,$35,$39,$3C,$4C,$4C ; 9BF2  codes $00-$0F
        .byte   $4F,$4B,$53,$59,$56,$01,$60,$50,$4D,$0A,$0A,$61,$1D,$96,$89,$89 ; 9C02  codes $10-$1F
        .byte   $52,$52,$52,$52,$52,$52,$52,$52,$50,$99,$67,$6C,$6F,$06,$06,$06 ; 9C12  codes $20-$2F
        .byte   $06,$72,$74,$77,$79,$90,$1C,$7E,$6B,$AE,$93,$89,$05,$05,$05,$86 ; 9C22  codes $30-$3F
        .byte   $00,$00,$00,$00,$62,$00,$00,$00,$00,$62,$00,$00,$83,$00,$10,$62 ; 9C32  codes $40-$4F
        .byte   $62,$00,$62,$62,$62,$62,$B6,$00,$00,$C3,$BF,$62,$BA,$55,$9E,$85 ; 9C42  codes $50-$5F
        .byte   $8F,$92,$10,$20,$0D,$03,$1F,$30,$3A,$3E,$41,$4B,$52,$00,$00,$00 ; 9C52  codes $60-$6F
        .byte   $6A,$74,$65,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$05 ; 9C62  codes $70-$7F
        .byte   $07,$72,$73,$78,$74,$75,$76,$77,$79,$7A,$7B,$7C,$7D,$7E,$7F,$80 ; 9C72  codes $80-$8F
spawn_hp_tbl:   .byte   $02,$01,$01,$01,$03,$02,$06,$01,$04,$01,$00,$03,$0D,$04,$00,$00 ; 9C82  codes $00-$0F
        .byte   $00,$00,$03,$00,$02,$03,$03,$02,$03,$03,$03,$05,$01,$02,$05,$05 ; 9C92  codes $10-$1F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$02,$01,$04,$03,$03,$01,$01,$01 ; 9CA2  codes $20-$2F
        .byte   $01,$01,$01,$01,$01,$03,$02,$01,$05,$06,$01,$02,$01,$01,$01,$02 ; 9CB2  codes $30-$3F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$00,$00,$00 ; 9CC2  codes $40-$4F
        .byte   $14,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9CD2  codes $50-$5F
        .byte   $01,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9CE2  codes $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01 ; 9CF2  codes $70-$7F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9D02  codes $80-$8F
; speed row index into the xvel tables below
spawn_speed_tbl: .byte   $01,$02,$04,$00,$03,$03,$03,$02,$00,$05,$04,$00,$00,$00,$00,$00 ; 9D12  codes $00-$0F
        .byte   $00,$05,$00,$00,$00,$05,$00,$00,$00,$00,$00,$00,$03,$00,$05,$05 ; 9D22  codes $10-$1F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$06,$00,$05,$00,$00,$05,$00,$00 ; 9D32  codes $20-$2F
        .byte   $05,$05,$03,$05,$00,$00,$00,$03,$00,$00,$00,$00,$00,$05,$00,$00 ; 9D42  codes $30-$3F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9D52  codes $40-$4F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07,$00,$00 ; 9D62  codes $50-$5F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$05,$00,$00,$00 ; 9D72  codes $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$05 ; 9D82  codes $70-$7F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9D92  codes $80-$8F
spawn_xvel_sub_tbl: .byte   $00,$CC,$33,$00,$80,$80,$00,$00             ; 9DA2
spawn_xvel_px_tbl: .byte   $01,$00,$01,$02,$01,$00,$04,$03              ; 9DAA
; -----------------------------------------------------------------------------
; Spawn commands (codes >= $C0, & $3F). Slot < 0: start the background
; CHR-anim program (prog -> $05D0). Slot < $10: palette command in PAL_BUF
; row/cycle slot. Slot >= $10: BG CHR bank pair index (spawn_chr_pairs).
; -----------------------------------------------------------------------------
spawn_cmd_slot: .byte   $82,$83,$12,$14,$0C,$08,$04,$04,$02,$02,$0C,$03,$84,$16,$04,$04 ; 9DB2
        .byte   $80,$81,$08,$85,$18,$0C,$08,$00,$00,$00,$00,$00,$0C,$00,$00,$0C ; 9DC2
        .byte   $08,$0C,$01,$00,$00,$00,$00,$00,$00,$08,$0C,$03,$00,$04,$00,$10 ; 9DD2
; neg = palette-cycle program ($05F0+slot); pos = spawn_pal_rec index
spawn_cmd_prog: .byte   $00,$00,$00,$00,$00,$01,$02,$03,$89,$90,$04,$83,$00,$00,$06,$07 ; 9DE2
        .byte   $00,$00,$05,$00,$00,$08,$10,$00,$00,$00,$00,$00,$0E,$00,$00,$08 ; 9DF2
        .byte   $09,$0C,$9D,$0F,$00,$00,$00,$00,$00,$0A,$0B,$91,$00,$00,$00,$00 ; 9E02
; static palette records: ctl byte (0 = colors only, >0 = also load
; spawn_chr_pairs[ctl], <0 = also set backdrop to ctl & $3F) + 3 colors
spawn_pal_ctl:  .byte   $00                     ; 9E12
spawn_pal_c1:   .byte   $30                     ; 9E13
spawn_pal_c2:   .byte   $23                     ; 9E14
spawn_pal_c3:   .byte   $03                     ; 9E15
        .byte   $00,$30,$2A,$0A                                         ; 9E16
        .byte   $00,$19,$09,$06                                         ; 9E1A
        .byte   $00,$1C,$0C,$05                                         ; 9E1E
        .byte   $00,$30,$23,$03                                         ; 9E22
        .byte   $00,$39,$27,$18                                         ; 9E26
        .byte   $06,$20,$27,$18                                         ; 9E2A
        .byte   $08,$20,$1C,$21                                         ; 9E2E
        .byte   $00,$24,$14,$03                                         ; 9E32
        .byte   $00,$08,$08,$09                                         ; 9E36
        .byte   $00,$10,$1C,$0C                                         ; 9E3A
        .byte   $00,$10,$00,$08                                         ; 9E3E
        .byte   $00,$3C,$2C,$1C                                         ; 9E42
        .byte   $00,$24,$14,$03                                         ; 9E46
        .byte   $00,$31,$21,$11                                         ; 9E4A
        .byte   $00,$30,$27,$17                                         ; 9E4E
        .byte   $00,$20,$26,$16                                         ; 9E52
; background CHR bank pairs -> MMC3 R0/R1 ($EA/$EB), indexed by command
; slot ($10+); remainder of the bank is padding
spawn_chr_pairs: .byte  $00                     ; 9E56
        .byte   $00                             ; 9E57
        .byte   $90,$92,$90,$F0,$84,$86,$84,$7A,$00,$00,$00,$00,$00,$00,$88,$8A ; 9E58
        .byte   $A4,$A6,$B0,$B2,$B4,$B6,$90,$F8,$00,$00,$00,$00,$00,$00,$00,$00 ; 9E68
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9E78
        .byte   $00,$40,$80,$00,$00,$00,$00,$10,$00,$00,$00,$00,$00,$00,$00,$00 ; 9E88
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9E98
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9EA8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9EB8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9EC8
        .byte   $00,$00,$00,$00,$08,$00,$00,$00,$00,$00,$00,$00,$08,$00,$00,$00 ; 9ED8
        .byte   $00,$00,$00,$00,$01,$00,$00,$00,$20,$00,$00,$00,$00,$00,$00,$00 ; 9EE8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9EF8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9F08
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$10,$00,$00 ; 9F18
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9F28
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9F38
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9F48
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9F58
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9F68
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9F78
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9F88
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9F98
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9FA8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$00 ; 9FB8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9FC8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$00 ; 9FD8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9FE8
        .byte   $00,$00,$00,$00,$00,$00,$05,$FF                         ; 9FF8