.setcpu "6502"
.include "include/hardware.inc"
.include "include/zeropage.inc"
.include "include/constants.inc"
.include "include/fixed_bank.inc"

.segment "BANK04"

; =============================================================================
; BANK $04 (mapped at $A000) — raw da65 disassembly, annotation in progress
; SKELETON — raw ROM bytes, not yet classified as code or data.
; Data half (file +$0900 on): stage $04 (Star Man) stage data —
; screen table at $A900 with this bank at $A000; format in
; DATA_REFERENCE.md section 11.
; =============================================================================
L0000           := $0000
L0008           := $0008
L0028           := $0028
L0040           := $0040
L0080           := $0080
L0085           := $0085
L0503           := $0503
L0800           := $0800
L0840           := $0840
L0A40           := $0A40
L0F11           := $0F11
L1323           := $1323
L1424           := $1424
L1525           := $1525
L1A10           := $1A10
L1B4B           := $1B4B
L2004           := $2004
L2008           := $2008
L2020           := $2020
L2221           := $2221
L3022           := $3022
L3224           := $3224
L4202           := $4202
L4400           := $4400
L494C           := $494C
L4E4D           := $4E4D
L6322           := $6322
L8000           := $8000
L809D           := $809D
L8420           := $8420
L84A6           := $84A6
L84BF           := $84BF
L84D5           := $84D5
L8785           := $8785
L9B99           := $9B99
LEA34           := $EA34
LED5B           := $ED5B
; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $A5 — WILY MACHINE, phase 1 (Wily 4 = stage $0F, spawn
; code $5F at scr $07; stage data in bank $0F). IRQ-split background
; boss (mode $0C): $84A6 freeze + $1E handshake, $84D5 screen reset,
; CHR R0/R1 := $EC/$EE, BG CHR-anim program $86, spawns the BG-locked
; body overlay (type $B2 at X=$C0), palette $A58E fade + HP fill
; ($1C:8420). Fight ($A076): a weapon hit (shape-0 probe) knocks it
; back then forward ($4E frames each way, xvel/dir from LA5A2/LA5A4);
; on a timer it launches one of four attacks from the random tables
; LA5AA-LA5CE — child types $A6 (suction field), $A7 (arcing bomb) or
; $A8 (hopping skull). Camera: $78 := $98 - X; hits feed the damage
; engine with flag $40 ($A158). Death transform -> type $A9.
; =============================================================================
        jsr     L84A6                           ; A000 20 A6 84                  ..
        bcs     LA019                           ; A003 B0 14                    ..
        lda     #$80                            ; A005 A9 80                    ..
        sta     $1E                             ; A007 85 1E                    ..
        sta     $55                             ; A009 85 55                    .U
        lda     #$0C                            ; A00B A9 0C                    ..
        sta     $23                             ; A00D 85 23                    .#
        lda     #$1A                            ; A00F A9 1A                    ..
        sta     $0588,x                         ; A011 9D 88 05                 ...
        lda     #$A0                            ; A014 A9 A0                    ..
        sta     $05A0,x                         ; A016 9D A0 05                 ...
LA019:  rts                                     ; A019 60                       `

; ----------------------------------------------------------------------------
        lda     $1E                             ; A01A A5 1E                    ..
        bne     LA075                           ; A01C D0 57                    .W
        jsr     L84D5                           ; A01E 20 D5 84                  ..
        lda     #$EC                            ; A021 A9 EC                    ..
        sta     $EA                             ; A023 85 EA                    ..
        lda     #$EE                            ; A025 A9 EE                    ..
        sta     $EB                             ; A027 85 EB                    ..
        lda     #$86                            ; A029 A9 86                    ..
        sta     $05D0                           ; A02B 8D D0 05                 ...
        lda     #$59                            ; A02E A9 59                    .Y
        sta     $0588,x                         ; A030 9D 88 05                 ...
        lda     #$A0                            ; A033 A9 A0                    ..
        sta     $05A0,x                         ; A035 9D A0 05                 ...
        lda     #$30                            ; A038 A9 30                    .0
        sta     $0468,x                         ; A03A 9D 68 04                 .h.
        jsr     find_free_slot_y                           ; A03D 20 6F F1                  o.
        bcs     LA059                           ; A040 B0 17                    ..
        lda     #$62                            ; A042 A9 62                    .b
        jsr     entity_init_pos                           ; A044 20 A4 EA                  ..
        lda     #$B2                            ; A047 A9 B2                    ..
        sta     $0300,y                         ; A049 99 00 03                 ...
        lda     #$EC                            ; A04C A9 EC                    ..
        sta     $0408,y                         ; A04E 99 08 04                 ...
        lda     #$C0                            ; A051 A9 C0                    ..
        sta     $0330,y                         ; A053 99 30 03                 .0.
        sta     $0468,y                         ; A056 99 68 04                 .h.
LA059:  lda     #$8E                            ; A059 A9 8E                    ..
        sta     L0000                           ; A05B 85 00                    ..
        lda     #$A5                            ; A05D A9 A5                    ..
        sta     $01                             ; A05F 85 01                    ..
        jsr     L8420                           ; A061 20 20 84                   .
        bcs     LA075                           ; A064 B0 0F                    ..
        lda     #$00                            ; A066 A9 00                    ..
        sta     $0468,x                         ; A068 9D 68 04                 .h.
        lda     #$76                            ; A06B A9 76                    .v
        sta     $0588,x                         ; A06D 9D 88 05                 ...
        lda     #$A0                            ; A070 A9 A0                    ..
        sta     $05A0,x                         ; A072 9D A0 05                 ...
LA075:  rts                                     ; A075 60                       `

; ----------------------------------------------------------------------------
        lda     #$00                            ; A076 A9 00                    ..
        sta     $0408,x                         ; A078 9D 08 04                 ...
        jsr     entity_hitbox_check                           ; A07B 20 F8 EF                  ..
        bcs     LA08F                           ; A07E B0 0F                    ..
        lda     #$8F                            ; A080 A9 8F                    ..
        sta     $0588,x                         ; A082 9D 88 05                 ...
        lda     #$A0                            ; A085 A9 A0                    ..
        sta     $05A0,x                         ; A087 9D A0 05                 ...
        lda     #$4E                            ; A08A A9 4E                    .N
LA08C:  sta     $0468,x                         ; A08C 9D 68 04                 .h.
LA08F:  lda     $0468,x                         ; A08F BD 68 04                 .h.
        beq     LA0D1                           ; A092 F0 3D                    .=
        lda     $0468,x                         ; A094 BD 68 04                 .h.
        and     #$01                            ; A097 29 01                    ).
        ora     $0480,x                         ; A099 1D 80 04                 ...
        tay                                     ; A09C A8                       .
        lda     LA5A2,y                         ; A09D B9 A2 A5                 ...
        sta     $03C0,x                         ; A0A0 9D C0 03                 ...
        lda     LA5A4,y                         ; A0A3 B9 A4 A5                 ...
        sta     $0420,x                         ; A0A6 9D 20 04                 . .
        jsr     entity_facing_dispatch                           ; A0A9 20 65 EA                  e.
        lda     #$80                            ; A0AC A9 80                    ..
        sta     $0528,x                         ; A0AE 9D 28 05                 .(.
        dec     $0468,x                         ; A0B1 DE 68 04                 .h.
        bne     LA0D1                           ; A0B4 D0 1B                    ..
        lda     $0480,x                         ; A0B6 BD 80 04                 ...
        eor     #$04                            ; A0B9 49 04                    I.
        sta     $0480,x                         ; A0BB 9D 80 04                 ...
        beq     LA0C7                           ; A0BE F0 07                    ..
        lda     #$4E                            ; A0C0 A9 4E                    .N
        sta     $0468,x                         ; A0C2 9D 68 04                 .h.
        bne     LA0D1                           ; A0C5 D0 0A                    ..
LA0C7:  lda     #$76                            ; A0C7 A9 76                    .v
        sta     $0588,x                         ; A0C9 9D 88 05                 ...
        lda     #$A0                            ; A0CC A9 A0                    ..
        sta     $05A0,x                         ; A0CE 9D A0 05                 ...
LA0D1:  lda     $0498,x                         ; A0D1 BD 98 04                 ...
        bne     LA148                           ; A0D4 D0 72                    .r
        jsr     find_free_slot_y                           ; A0D6 20 6F F1                  o.
        bcs     LA14B                           ; A0D9 B0 70                    .p
        lda     #$00                            ; A0DB A9 00                    ..
        jsr     entity_init_pos                           ; A0DD 20 A4 EA                  ..
        lda     $0528,y                         ; A0E0 B9 28 05                 .(.
        ora     #$08                            ; A0E3 09 08                    ..
        sta     $0528,y                         ; A0E5 99 28 05                 .(.
        lda     $E4                             ; A0E8 A5 E4                    ..
        clc                                     ; A0EA 18                       .
        adc     $E5                             ; A0EB 65 E5                    e.
        sta     $E5                             ; A0ED 85 E5                    ..
        and     #$03                            ; A0EF 29 03                    ).
        tax                                     ; A0F1 AA                       .
        lda     LA5AE,x                         ; A0F2 BD AE A5                 ...
        jsr     entity_init_subtype_y                           ; A0F5 20 E9 EA                  ..
        lda     LA5B2,x                         ; A0F8 BD B2 A5                 ...
        sta     $0300,y                         ; A0FB 99 00 03                 ...
        lda     LA5B6,x                         ; A0FE BD B6 A5                 ...
        sta     $0408,y                         ; A101 99 08 04                 ...
        lda     LA5BA,x                         ; A104 BD BA A5                 ...
        sta     $03A8,y                         ; A107 99 A8 03                 ...
        lda     LA5BE,x                         ; A10A BD BE A5                 ...
        sta     $03C0,y                         ; A10D 99 C0 03                 ...
        lda     LA5C2,x                         ; A110 BD C2 A5                 ...
        sta     $0468,y                         ; A113 99 68 04                 .h.
        lda     LA5C6,x                         ; A116 BD C6 A5                 ...
        sta     $0480,y                         ; A119 99 80 04                 ...
        jsr     LEA34                           ; A11C 20 34 EA                  4.
        lda     LA5CA,x                         ; A11F BD CA A5                 ...
        sta     $0378,y                         ; A122 99 78 03                 .x.
        lda     $0330,y                         ; A125 B9 30 03                 .0.
        clc                                     ; A128 18                       .
        adc     LA5CE,x                         ; A129 7D CE A5                 }..
        sta     $0330,y                         ; A12C 99 30 03                 .0.
        lda     $A6                             ; A12F A5 A6                    ..
        sta     $0498,y                         ; A131 99 98 04                 ...
        lda     #$0C                            ; A134 A9 0C                    ..
        sta     $04B0,y                         ; A136 99 B0 04                 ...
        lda     #$03                            ; A139 A9 03                    ..
        sta     $04C8,y                         ; A13B 99 C8 04                 ...
        lda     LA5AA,x                         ; A13E BD AA A5                 ...
        pha                                     ; A141 48                       H
        ldx     $A6                             ; A142 A6 A6                    ..
        pla                                     ; A144 68                       h
        sta     $0498,x                         ; A145 9D 98 04                 ...
LA148:  dec     $0498,x                         ; A148 DE 98 04                 ...
LA14B:  lda     #$98                            ; A14B A9 98                    ..
        sec                                     ; A14D 38                       8
        sbc     $0330,x                         ; A14E FD 30 03                 .0.
        sta     $78                             ; A151 85 78                    .x
        lda     #$00                            ; A153 A9 00                    ..
        sta     $0408,x                         ; A155 9D 08 04                 ...
        jsr     entity_hitbox_check                           ; A158 20 F8 EF                  ..
        lda     #$AB                            ; A15B A9 AB                    ..
        sta     $0408,x                         ; A15D 9D 08 04                 ...
        bcs     LA169                           ; A160 B0 07                    ..
        lda     #$40                            ; A162 A9 40                    .@
        sta     L0000                           ; A164 85 00                    ..
        jmp     L809D                           ; A166 4C 9D 80                 L..

; ----------------------------------------------------------------------------
LA169:  rts                                     ; A169 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $A6 — Wily Machine suction field: while the player is
; left of it, drags him toward the machine via push vars $39-$3B
; (strong pull $02.4C while walking, else $00.CC); tracks the machine
; ($0498 link) at X-$0C and expires after $B4 frames.
; =============================================================================
        lda     $0330                           ; A16A AD 30 03                 .0.
        cmp     $0330,x                         ; A16D DD 30 03                 .0.
        bcs     LA190                           ; A170 B0 1E                    ..
        lda     #$CC                            ; A172 A9 CC                    ..
        sta     $3A                             ; A174 85 3A                    .:
        lda     #$00                            ; A176 A9 00                    ..
        sta     $3B                             ; A178 85 3B                    .;
        lda     $30                             ; A17A A5 30                    .0
        cmp     #$06                            ; A17C C9 06                    ..
        bcs     LA190                           ; A17E B0 10                    ..
        cmp     #$01                            ; A180 C9 01                    ..
        bne     LA18C                           ; A182 D0 08                    ..
        lda     #$4C                            ; A184 A9 4C                    .L
        sta     $3A                             ; A186 85 3A                    .:
        lda     #$02                            ; A188 A9 02                    ..
        sta     $3B                             ; A18A 85 3B                    .;
LA18C:  lda     #$01                            ; A18C A9 01                    ..
        sta     $39                             ; A18E 85 39                    .9
LA190:  ldy     $0498,x                         ; A190 BC 98 04                 ...
        lda     $0330,y                         ; A193 B9 30 03                 .0.
        sec                                     ; A196 38                       8
        sbc     #$0C                            ; A197 E9 0C                    ..
        sta     $0330,x                         ; A199 9D 30 03                 .0.
        inc     $0468,x                         ; A19C FE 68 04                 .h.
        lda     $0468,x                         ; A19F BD 68 04                 .h.
        cmp     #$B4                            ; A1A2 C9 B4                    ..
        bne     LA1A9                           ; A1A4 D0 03                    ..
        jsr     entity_wipe_x                           ; A1A6 20 C4 F2                  ..
LA1A9:  rts                                     ; A1A9 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $A7 — Wily Machine arcing bomb: falls to Y=$B8, then
; re-launches with its stored velocity ($0468/$0480) and rolls left;
; wipes when it leaves the screen, re-arming the machine's attack
; timer ($A1CD).
; =============================================================================
        jsr     entity_process_y_vel                           ; A1AA 20 68 E9                  h.
        lda     #$B8                            ; A1AD A9 B8                    ..
        cmp     $0378,x                         ; A1AF DD 78 03                 .x.
        bcs     LA1C3                           ; A1B2 B0 0F                    ..
        sta     $0378,x                         ; A1B4 9D 78 03                 .x.
        lda     $0468,x                         ; A1B7 BD 68 04                 .h.
        sta     $03D8,x                         ; A1BA 9D D8 03                 ...
        lda     $0480,x                         ; A1BD BD 80 04                 ...
        sta     $03F0,x                         ; A1C0 9D F0 03                 ...
LA1C3:  jsr     entity_move_left_collide                           ; A1C3 20 0C E9                  ..
        lda     $0348,x                         ; A1C6 BD 48 03                 .H.
        cmp     $F9                             ; A1C9 C5 F9                    ..
        beq     LA1D8                           ; A1CB F0 0B                    ..
LA1CD:  ldy     $0498,x                         ; A1CD BC 98 04                 ...
        lda     #$28                            ; A1D0 A9 28                    .(
        sta     $0498,y                         ; A1D2 99 98 04                 ...
        jsr     entity_wipe_x                           ; A1D5 20 C4 F2                  ..
LA1D8:  rts                                     ; A1D8 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $A8 — Wily Machine hopping skull: stays on the boss's
; screen (a limited number of screen-crossings, $04C8, then wipes back
; to the machine's mouth at X+8/Y=$A8); every $14 frames re-rolls its
; hop (LED5B rng -> kind LA5D2, sub_type LA5D8, flags LA5DD, 16-dir
; velocity) and suppresses the machine's other attacks while alive
; ($0498,parent := $FF).
; =============================================================================
        lda     $F9                             ; A1D9 A5 F9                    ..
        cmp     $0348,x                         ; A1DB DD 48 03                 .H.
        beq     LA203                           ; A1DE F0 23                    .#
        dec     $04C8,x                         ; A1E0 DE C8 04                 ...
        beq     LA1CD                           ; A1E3 F0 E8                    ..
        sta     $0348,x                         ; A1E5 9D 48 03                 .H.
        lda     #$A8                            ; A1E8 A9 A8                    ..
LA1EA:  sta     $0378,x                         ; A1EA 9D 78 03                 .x.
        ldy     $0498,x                         ; A1ED BC 98 04                 ...
        lda     $0330,y                         ; A1F0 B9 30 03                 .0.
        clc                                     ; A1F3 18                       .
        adc     #$08                            ; A1F4 69 08                    i.
        sta     $0330,x                         ; A1F6 9D 30 03                 .0.
        lda     #$00                            ; A1F9 A9 00                    ..
        sta     $0468,x                         ; A1FB 9D 68 04                 .h.
        lda     #$0C                            ; A1FE A9 0C                    ..
LA200:  sta     $04B0,x                         ; A200 9D B0 04                 ...
LA203:  lda     $0468,x                         ; A203 BD 68 04                 .h.
        bne     LA228                           ; A206 D0 20                    . 
        lda     #$14                            ; A208 A9 14                    ..
        sta     $0468,x                         ; A20A 9D 68 04                 .h.
        jsr     LED5B                           ; A20D 20 5B ED                  [.
        lda     LA5D2,y                         ; A210 B9 D2 A5                 ...
        sta     $04B0,x                         ; A213 9D B0 04                 ...
        tay                                     ; A216 A8                       .
        lda     LA5D8,y                         ; A217 B9 D8 A5                 ...
        jsr     entity_set_subtype                           ; A21A 20 98 EA                  ..
        lda     LA5DD,y                         ; A21D B9 DD A5                 ...
        sta     $0528,x                         ; A220 9D 28 05                 .(.
        lda     #$10                            ; A223 A9 10                    ..
        jsr     entity_set_dir_velocity                           ; A225 20 70 F4                  p.
LA228:  jsr     entity_facing_dispatch                           ; A228 20 65 EA                  e.
        jsr     entity_vert_dispatch_raw                           ; A22B 20 86 EA                  ..
        dec     $0468,x                         ; A22E DE 68 04                 .h.
        ldy     $0498,x                         ; A231 BC 98 04                 ...
        lda     #$FF                            ; A234 A9 FF                    ..
        sta     $0498,y                         ; A236 99 98 04                 ...
LA239:  rts                                     ; A239 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $A9 — Wily Machine destruction (death transform of
; $A5): $1C:84BF wipes the arena with the death sound, then explosion
; bursts (type $2F sub $42) walk across the hull at the LA5EC offset
; pairs every 8 frames while the machine sinks and the palette steps
; to black ($A2DD); after 9 bursts, a pause, then it wipes and becomes
; type $AA — phase 2 — with the split screen and boss meter reset.
; =============================================================================
        jsr     L84BF                           ; A23A 20 BF 84                  ..
        lda     $0330,x                         ; A23D BD 30 03                 .0.
        sta     $0468,x                         ; A240 9D 68 04                 .h.
        lda     $0378,x                         ; A243 BD 78 03                 .x.
        sta     $0480,x                         ; A246 9D 80 04                 ...
        lda     #$6B                            ; A249 A9 6B                    .k
        sta     $0588,x                         ; A24B 9D 88 05                 ...
        lda     #$A2                            ; A24E A9 A2                    ..
        sta     $05A0,x                         ; A250 9D A0 05                 ...
        lda     #$00                            ; A253 A9 00                    ..
        sta     $0420,x                         ; A255 9D 20 04                 . .
        sta     $03D8,x                         ; A258 9D D8 03                 ...
        sta     $0498,x                         ; A25B 9D 98 04                 ...
        sta     $05D0                           ; A25E 8D D0 05                 ...
        lda     #$04                            ; A261 A9 04                    ..
        sta     $03F0,x                         ; A263 9D F0 03                 ...
        lda     #$04                            ; A266 A9 04                    ..
        sta     $04C8,x                         ; A268 9D C8 04                 ...
        lda     $0498,x                         ; A26B BD 98 04                 ...
        bne     LA2C0                           ; A26E D0 50                    .P
        jsr     find_free_slot_y                           ; A270 20 6F F1                  o.
        bcs     LA239                           ; A273 B0 C4                    ..
        lda     #$42                            ; A275 A9 42                    .B
        jsr     entity_init_pos                           ; A277 20 A4 EA                  ..
        lda     $0468,x                         ; A27A BD 68 04                 .h.
        sta     $0330,y                         ; A27D 99 30 03                 .0.
        lda     $0480,x                         ; A280 BD 80 04                 ...
        sta     $0378,y                         ; A283 99 78 03                 .x.
        lda     #$2F                            ; A286 A9 2F                    ./
        sta     $0300,y                         ; A288 99 00 03                 ...
        lda     $04B0,x                         ; A28B BD B0 04                 ...
        tax                                     ; A28E AA                       .
        lda     $0330,y                         ; A28F B9 30 03                 .0.
        clc                                     ; A292 18                       .
        adc     LA5EC,x                         ; A293 7D EC A5                 }..
        sta     $0330,y                         ; A296 99 30 03                 .0.
        lda     $0378,y                         ; A299 B9 78 03                 .x.
        clc                                     ; A29C 18                       .
        adc     LA5ED,x                         ; A29D 7D ED A5                 }..
        sta     $0378,y                         ; A2A0 99 78 03                 .x.
        ldx     $A6                             ; A2A3 A6 A6                    ..
        lda     #$08                            ; A2A5 A9 08                    ..
        sta     $0498,x                         ; A2A7 9D 98 04                 ...
        inc     $04B0,x                         ; A2AA FE B0 04                 ...
        inc     $04B0,x                         ; A2AD FE B0 04                 ...
        lda     $04B0,x                         ; A2B0 BD B0 04                 ...
        cmp     #$12                            ; A2B3 C9 12                    ..
        beq     LA2F6                           ; A2B5 F0 3F                    .?
        cmp     #$02                            ; A2B7 C9 02                    ..
        bne     LA2C0                           ; A2B9 D0 05                    ..
        lda     #$08                            ; A2BB A9 08                    ..
        sta     $0420,x                         ; A2BD 9D 20 04                 . .
LA2C0:  dec     $0498,x                         ; A2C0 DE 98 04                 ...
        jsr     entity_vert_dispatch_raw                           ; A2C3 20 86 EA                  ..
        lda     #$10                            ; A2C6 A9 10                    ..
        cmp     $0378,x                         ; A2C8 DD 78 03                 .x.
        bcc     LA2F5                           ; A2CB 90 28                    .(
        sta     $0378,x                         ; A2CD 9D 78 03                 .x.
        lda     $9D                             ; A2D0 A5 9D                    ..
        and     #$07                            ; A2D2 29 07                    ).
        bne     LA2F5                           ; A2D4 D0 1F                    ..
        lda     $04C8,x                         ; A2D6 BD C8 04                 ...
        beq     LA2F5                           ; A2D9 F0 1A                    ..
        ldy     #$0B                            ; A2DB A0 0B                    ..
LA2DD:  lda     $0624,y                         ; A2DD B9 24 06                 .$.
        sec                                     ; A2E0 38                       8
        sbc     #$10                            ; A2E1 E9 10                    ..
        bcs     LA2E7                           ; A2E3 B0 02                    ..
        lda     #$0F                            ; A2E5 A9 0F                    ..
LA2E7:  sta     $0604,y                         ; A2E7 99 04 06                 ...
        sta     $0624,y                         ; A2EA 99 24 06                 .$.
        dey                                     ; A2ED 88                       .
        bpl     LA2DD                           ; A2EE 10 ED                    ..
        sty     $18                             ; A2F0 84 18                    ..
        dec     $04C8,x                         ; A2F2 DE C8 04                 ...
LA2F5:  rts                                     ; A2F5 60                       `

; ----------------------------------------------------------------------------
LA2F6:  lda     #$78                            ; A2F6 A9 78                    .x
        sta     $0468,x                         ; A2F8 9D 68 04                 .h.
        lda     #$05                            ; A2FB A9 05                    ..
        sta     $0588,x                         ; A2FD 9D 88 05                 ...
        lda     #$A3                            ; A300 A9 A3                    ..
        sta     $05A0,x                         ; A302 9D A0 05                 ...
        dec     $0468,x                         ; A305 DE 68 04                 .h.
        bne     LA324                           ; A308 D0 1A                    ..
        jsr     entity_wipe_x                           ; A30A 20 C4 F2                  ..
        lda     #$62                            ; A30D A9 62                    .b
        jsr     entity_set_subtype                           ; A30F 20 98 EA                  ..
        lda     #$AA                            ; A312 A9 AA                    ..
        sta     $0300,x                         ; A314 9D 00 03                 ...
        lda     #$00                            ; A317 A9 00                    ..
        sta     $0408,x                         ; A319 9D 08 04                 ...
        sta     $FD                             ; A31C 85 FD                    ..
        sta     $FA                             ; A31E 85 FA                    ..
        sta     $78                             ; A320 85 78                    .x
        sta     $2F                             ; A322 85 2F                    ./
LA324:  rts                                     ; A324 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $AA — WILY CAPSULE (the true final boss, emerging
; from the wrecked machine). Fortress intro ($84A6, special sound
; $16), CHR R0/R1 := $BC/$BE, IRQ
; mode $0D, centers at ($80,$68), palette $A5FE fade + HP fill. Cycle:
; fire a 4-way spread of curving orbs (type $AB at LA629/LA62D offsets,
; start angles LA631) and two type $47 floor bombs ($A4B6), then fade
; out (LA55C step +$10 -> hidden), wait for its orbs to despawn, and
; fade back in at a random position (Y from LA612, X from LA61A masked
; per row by LA61F). Camera tracks it ($A4E9). Death transform ->
; type $C0 ($0A:A1F8) — Wily's escape.
; =============================================================================
        jsr     L84A6                           ; A325 20 A6 84                  ..
        bcs     LA324                           ; A328 B0 FA                    ..
        lda     #$BC                            ; A32A A9 BC                    ..
        sta     $EA                             ; A32C 85 EA                    ..
        lda     #$BE                            ; A32E A9 BE                    ..
        sta     $EB                             ; A330 85 EB                    ..
        lda     #$80                            ; A332 A9 80                    ..
        sta     $1E                             ; A334 85 1E                    ..
        lda     #$0D                            ; A336 A9 0D                    ..
        sta     $23                             ; A338 85 23                    .#
        lda     #$44                            ; A33A A9 44                    .D
        sta     $0588,x                         ; A33C 9D 88 05                 ...
        lda     #$A3                            ; A33F A9 A3                    ..
        sta     $05A0,x                         ; A341 9D A0 05                 ...
        lda     $1E                             ; A344 A5 1E                    ..
        bne     LA324                           ; A346 D0 DC                    ..
        lda     #$69                            ; A348 A9 69                    .i
        sta     $0588,x                         ; A34A 9D 88 05                 ...
        lda     #$A3                            ; A34D A9 A3                    ..
        sta     $05A0,x                         ; A34F 9D A0 05                 ...
        lda     #$30                            ; A352 A9 30                    .0
        sta     $0468,x                         ; A354 9D 68 04                 .h.
        lda     #$40                            ; A357 A9 40                    .@
        sta     $FA                             ; A359 85 FA                    ..
        lda     #$68                            ; A35B A9 68                    .h
        sta     $0378,x                         ; A35D 9D 78 03                 .x.
        lda     #$80                            ; A360 A9 80                    ..
        sta     $0330,x                         ; A362 9D 30 03                 .0.
        lda     #$02                            ; A365 A9 02                    ..
        sta     $FD                             ; A367 85 FD                    ..
        lda     #$FE                            ; A369 A9 FE                    ..
        sta     L0000                           ; A36B 85 00                    ..
        lda     #$A5                            ; A36D A9 A5                    ..
        sta     $01                             ; A36F 85 01                    ..
        jsr     L8420                           ; A371 20 20 84                   .
        bcs     LA3A4                           ; A374 B0 2E                    ..
        ldy     #$07                            ; A376 A0 07                    ..
LA378:  lda     LA60A,y                         ; A378 B9 0A A6                 ...
        sta     $0618,y                         ; A37B 99 18 06                 ...
        sta     $0638,y                         ; A37E 99 38 06                 .8.
        dey                                     ; A381 88                       .
        bpl     LA378                           ; A382 10 F4                    ..
        sty     $18                             ; A384 84 18                    ..
        lda     #$00                            ; A386 A9 00                    ..
        sta     $0468,x                         ; A388 9D 68 04                 .h.
        lda     #$13                            ; A38B A9 13                    ..
        sta     $0588,x                         ; A38D 9D 88 05                 ...
        lda     #$A4                            ; A390 A9 A4                    ..
        sta     $05A0,x                         ; A392 9D A0 05                 ...
        lda     #$1E                            ; A395 A9 1E                    ..
        sta     $0468,x                         ; A397 9D 68 04                 .h.
        lda     #$00                            ; A39A A9 00                    ..
        sta     $0480,x                         ; A39C 9D 80 04                 ...
        lda     #$ED                            ; A39F A9 ED                    ..
        sta     $0408,x                         ; A3A1 9D 08 04                 ...
LA3A4:  rts                                     ; A3A4 60                       `

; ----------------------------------------------------------------------------
        jsr     LA553                           ; A3A5 20 53 A5                  S.
        bne     LA418                           ; A3A8 D0 6E                    .n
        lda     #$03                            ; A3AA A9 03                    ..
        sta     $12                             ; A3AC 85 12                    ..
        jsr     entity_set_facing                           ; A3AE 20 16 EC                  ..
        lda     $0420,x                         ; A3B1 BD 20 04                 . .
        and     #$01                            ; A3B4 29 01                    ).
        beq     LA3BA                           ; A3B6 F0 02                    ..
        lda     #$04                            ; A3B8 A9 04                    ..
LA3BA:  sta     $13                             ; A3BA 85 13                    ..
LA3BC:  jsr     find_free_slot_y                           ; A3BC 20 6F F1                  o.
        bcs     LA3F9                           ; A3BF B0 38                    .8
        lda     #$9D                            ; A3C1 A9 9D                    ..
        jsr     entity_init_pos                           ; A3C3 20 A4 EA                  ..
        lda     #$AB                            ; A3C6 A9 AB                    ..
        sta     $0300,y                         ; A3C8 99 00 03                 ...
        lda     #$80                            ; A3CB A9 80                    ..
        sta     $0408,y                         ; A3CD 99 08 04                 ...
        ldx     $12                             ; A3D0 A6 12                    ..
        lda     $0330,y                         ; A3D2 B9 30 03                 .0.
        clc                                     ; A3D5 18                       .
        adc     LA629,x                         ; A3D6 7D 29 A6                 }).
        sta     $0330,y                         ; A3D9 99 30 03                 .0.
        lda     $0378,y                         ; A3DC B9 78 03                 .x.
        clc                                     ; A3DF 18                       .
        adc     LA62D,x                         ; A3E0 7D 2D A6                 }-.
        sta     $0378,y                         ; A3E3 99 78 03                 .x.
        lda     $13                             ; A3E6 A5 13                    ..
        sta     $0498,y                         ; A3E8 99 98 04                 ...
        ora     $12                             ; A3EB 05 12                    ..
        tax                                     ; A3ED AA                       .
        lda     LA631,x                         ; A3EE BD 31 A6                 .1.
        sta     $0480,y                         ; A3F1 99 80 04                 ...
        lda     #$2B                            ; A3F4 A9 2B                    .+
        sta     $04B0,y                         ; A3F6 99 B0 04                 ...
LA3F9:  ldx     $A6                             ; A3F9 A6 A6                    ..
        dec     $12                             ; A3FB C6 12                    ..
        bpl     LA3BC                           ; A3FD 10 BD                    ..
        lda     #$13                            ; A3FF A9 13
        sta     $0588,x                         ; A401 9D 88 05                 ...
        lda     #$A4                            ; A404 A9 A4                    ..
        sta     $05A0,x                         ; A406 9D A0 05                 ...
        lda     #$1E                            ; A409 A9 1E                    ..
        sta     $0468,x                         ; A40B 9D 68 04                 .h.
        lda     #$00                            ; A40E A9 00                    ..
        sta     $0480,x                         ; A410 9D 80 04                 ...
        jsr     LA553                           ; A413 20 53 A5                  S.
        beq     LA41B                           ; A416 F0 03                    ..
LA418:  jmp     LA4E9                           ; A418 4C E9 A4                 L..

; ----------------------------------------------------------------------------
LA41B:  lda     $0528,x                         ; A41B BD 28 05                 .(.
        ora     #$04                            ; A41E 09 04                    ..
        sta     $0528,x                         ; A420 9D 28 05                 .(.
        lda     #$10                            ; A423 A9 10                    ..
        sta     $10                             ; A425 85 10                    ..
        jsr     LA55C                           ; A427 20 5C A5                  \.
        lda     $0480,x                         ; A42A BD 80 04                 ...
        cmp     #$50                            ; A42D C9 50                    .P
        bne     LA418                           ; A42F D0 E7                    ..
        lda     #$3B                            ; A431 A9 3B                    .;
        sta     $0588,x                         ; A433 9D 88 05                 ...
        lda     #$A4                            ; A436 A9 A4                    ..
        sta     $05A0,x                         ; A438 9D A0 05                 ...
        ldy     #$17                            ; A43B A0 17                    ..
LA43D:  lda     $0300,y                         ; A43D B9 00 03                 ...
        cmp     #$AB                            ; A440 C9 AB                    ..
        beq     LA418                           ; A442 F0 D4                    ..
        dey                                     ; A444 88                       .
        cpy     #$08                            ; A445 C0 08                    ..
        bne     LA43D                           ; A447 D0 F4                    ..
        lda     #$85                            ; A449 A9 85                    ..
        sta     $0588,x                         ; A44B 9D 88 05                 ...
        lda     #$A4                            ; A44E A9 A4                    ..
        sta     $05A0,x                         ; A450 9D A0 05                 ...
        lda     #$78                            ; A453 A9 78                    .x
        sta     $0468,x                         ; A455 9D 68 04                 .h.
        lda     #$30                            ; A458 A9 30                    .0
        sta     $0480,x                         ; A45A 9D 80 04                 ...
        lda     $E4                             ; A45D A5 E4                    ..
        adc     $E5                             ; A45F 65 E5                    e.
        sta     $E6                             ; A461 85 E6                    ..
        and     #$07                            ; A463 29 07                    ).
        tay                                     ; A465 A8                       .
        lda     LA612,y                         ; A466 B9 12 A6                 ...
        sta     $0378,x                         ; A469 9D 78 03                 .x.
        lsr     a                               ; A46C 4A                       J
        lsr     a                               ; A46D 4A                       J
        lsr     a                               ; A46E 4A                       J
        lsr     a                               ; A46F 4A                       J
        tay                                     ; A470 A8                       .
        lda     LA61F,y                         ; A471 B9 1F A6                 ...
        sta     L0000                           ; A474 85 00                    ..
        lda     $E4                             ; A476 A5 E4                    ..
        adc     $E6                             ; A478 65 E6                    e.
        sta     $E5                             ; A47A 85 E5                    ..
        and     L0000                           ; A47C 25 00                    %.
        tay                                     ; A47E A8                       .
        lda     LA61A,y                         ; A47F B9 1A A6                 ...
        sta     $0330,x                         ; A482 9D 30 03                 .0.
        jsr     LA553                           ; A485 20 53 A5                  S.
        bne     LA4E9                           ; A488 D0 5F                    ._
        lda     #$00                            ; A48A A9 00
        sta     $05B8,x                         ; A48C 9D B8 05
        lda     #$F0                            ; A48F A9 F0
        sta     $10                             ; A491 85 10    fade step -$10
        jsr     LA55C                           ; A493 20 5C A5
        lda     $0480,x                         ; A496 BD 80 04
        bpl     LA4E9                           ; A499 10 4E    fade-out done at < 0
        lda     #$3C                            ; A49B A9 3C                    .<
        sta     $0468,x                         ; A49D 9D 68 04                 .h.
        lda     #$A5                            ; A4A0 A9 A5                    ..
        sta     $0588,x                         ; A4A2 9D 88 05                 ...
        lda     #$A3                            ; A4A5 A9 A3                    ..
        sta     $05A0,x                         ; A4A7 9D A0 05                 ...
        lda     $0528,x                         ; A4AA BD 28 05                 .(.
        and     #$FB                            ; A4AD 29 FB                    ).
        sta     $0528,x                         ; A4AF 9D 28 05                 .(.
        lda     #$02                            ; A4B2 A9 02                    ..
        sta     $12                             ; A4B4 85 12                    ..
LA4B6:  jsr     find_free_slot_y                           ; A4B6 20 6F F1                  o.
        bcs     LA4E9                           ; A4B9 B0 2E                    ..
        lda     #$9D                            ; A4BB A9 9D
        jsr     entity_init_pos                 ; A4BD 20 A4 EA
        lda     $0378,y                         ; A4C0 B9 78 03                 .x.
        clc                                     ; A4C3 18                       .
        adc     #$18                            ; A4C4 69 18                    i.
        sta     $0378,y                         ; A4C6 99 78 03                 .x.
        lda     #$47                            ; A4C9 A9 47                    .G
        sta     $0300,y                         ; A4CB 99 00 03                 ...
        lda     #$80                            ; A4CE A9 80                    ..
        sta     $0408,y                         ; A4D0 99 08 04                 ...
        lda     #$00                            ; A4D3 A9 00                    ..
        sta     $03A8,y                         ; A4D5 99 A8 03                 ...
        lda     #$03                            ; A4D8 A9 03                    ..
LA4DA:  sta     $03C0,y                         ; A4DA 99 C0 03                 ...
        lda     $12                             ; A4DD A5 12                    ..
        sta     $0420,y                         ; A4DF 99 20 04                 . .
        jsr     LEA34                           ; A4E2 20 34 EA                  4.
        dec     $12                             ; A4E5 C6 12                    ..
        bne     LA4B6                           ; A4E7 D0 CD                    ..
LA4E9:  lda     #$A8                            ; A4E9 A9 A8                    ..
        sec                                     ; A4EB 38                       8
        sbc     $0378,x                         ; A4EC FD 78 03                 .x.
        sta     $FA                             ; A4EF 85 FA                    ..
        lda     #$80                            ; A4F1 A9 80                    ..
        sec                                     ; A4F3 38                       8
        sbc     $0330,x                         ; A4F4 FD 30 03                 .0.
        sta     $78                             ; A4F7 85 78                    .x
        rts                                     ; A4F9 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $AB — phase-2 curving orb: flies 16-dir at speed $10,
; rotating its heading one step per LA639 delay (direction fixed by
; $0498), spiraling outward until the step list runs dry, then wipes.
; =============================================================================
        lda     $0468,x                         ; A4FA BD 68 04                 .h.
        bne     LA52B                           ; A4FD D0 2C                    .,
        ldy     $0480,x                         ; A4FF BC 80 04                 ...
        lda     #$10                            ; A502 A9 10                    ..
        jsr     entity_set_dir_velocity                           ; A504 20 70 F4                  p.
        ldy     $04B0,x                         ; A507 BC B0 04                 ...
        dec     $04B0,x                         ; A50A DE B0 04                 ...
        bmi     LA535                           ; A50D 30 26                    0&
        lda     LA639,y                         ; A50F B9 39 A6                 .9.
        sta     $0468,x                         ; A512 9D 68 04                 .h.
        lda     $0498,x                         ; A515 BD 98 04                 ...
        beq     LA520                           ; A518 F0 06                    ..
        inc     $0480,x                         ; A51A FE 80 04                 ...
        jmp     LA523                           ; A51D 4C 23 A5                 L#.

; ----------------------------------------------------------------------------
LA520:  dec     $0480,x                         ; A520 DE 80 04                 ...
LA523:  lda     $0480,x                         ; A523 BD 80 04                 ...
        and     #$0F                            ; A526 29 0F                    ).
        sta     $0480,x                         ; A528 9D 80 04                 ...
LA52B:  jsr     entity_facing_dispatch                           ; A52B 20 65 EA                  e.
        jsr     entity_vert_dispatch_raw                           ; A52E 20 86 EA                  ..
        dec     $0468,x                         ; A531 DE 68 04                 .h.
        rts                                     ; A534 60                       `

; ----------------------------------------------------------------------------
LA535:  jmp     entity_wipe_x                           ; A535 4C C4 F2                 L..

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $47 — phase-2 floor bomb: falls to Y=$B8, then slides
; along the floor toward the player.
; =============================================================================
        jsr     entity_process_y_vel                           ; A538 20 68 E9                  h.
        lda     #$B8                            ; A53B A9 B8                    ..
        cmp     $0378,x                         ; A53D DD 78 03                 .x.
        bcs     LA552                           ; A540 B0 10                    ..
        sta     $0378,x                         ; A542 9D 78 03                 .x.
        lda     #$4F                            ; A545 A9 4F                    .O
        sta     $0588,x                         ; A547 9D 88 05                 ...
        lda     #$A5                            ; A54A A9 A5                    ..
        sta     $05A0,x                         ; A54C 9D A0 05                 ...
        jsr     entity_facing_dispatch                           ; A54F 20 65 EA                  e.
LA552:  rts                                     ; A552 60                       `

; ----------------------------------------------------------------------------
LA553:  lda     $0468,x                         ; A553 BD 68 04                 .h.
        beq     LA55B                           ; A556 F0 03                    ..
        dec     $0468,x                         ; A558 DE 68 04                 .h.
LA55B:  rts                                     ; A55B 60                       `

; --- LA55C: phase-2 palette fade — every 4 frames add step $10 to $0480 and
; rewrite rows $0604/$0624 from LA5FE - $0480 (positive step = fade out,
; $F0 = fade back in)
LA55C:  lda     $9D                             ; A55C A5 9D                    ..
        and     #$03                            ; A55E 29 03                    ).
        bne     LA583                           ; A560 D0 21                    .!
        ldy     #$0B                            ; A562 A0 0B                    ..
LA564:  lda     LA5FE,y                         ; A564 B9 FE A5                 ...
        sec                                     ; A567 38                       8
        sbc     $0480,x                         ; A568 FD 80 04                 ...
        bcs     LA56F                           ; A56B B0 02                    ..
        lda     #$0F                            ; A56D A9 0F                    ..
LA56F:  sta     $0604,y                         ; A56F 99 04 06                 ...
        sta     $0624,y                         ; A572 99 24 06                 .$.
        dey                                     ; A575 88                       .
        bpl     LA564                           ; A576 10 EC                    ..
        sty     $18                             ; A578 84 18                    ..
        lda     $0480,x                         ; A57A BD 80 04                 ...
        clc                                     ; A57D 18                       .
        adc     $10                             ; A57E 65 10                    e.
        sta     $0480,x                         ; A580 9D 80 04                 ...
LA583:  rts                                     ; A583 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $B2 — BG-locked overlay: X := $0468 - scroll offset
; $78, pinning the sprite to the split-screen background (Wily Machine
; body ornament).
; =============================================================================
        lda     $0468,x                         ; A584 BD 68 04                 .h.
        sec                                     ; A587 38                       8
        sbc     $78                             ; A588 E5 78                    .x
        sta     $0330,x                         ; A58A 9D 30 03                 .0.
        rts                                     ; A58D 60                       `

; ----------------------------------------------------------------------------
; Wily Machine data. $A66B-$A7FF unreferenced.
        .byte   $0F,$30,$1C,$0B,$0F,$30,$36,$1C ; A58E  phase-1 palette (5 rows, $1C:8420)
        .byte   $0F,$30,$27,$17,$0F,$0F,$20,$11 ; A596
        .byte   $0F,$20,$25,$15 ; A59E
LA5A2:  .byte   $03,$01 ; A5A2  recoil xvel px / dir (idx 0,1,4,5)
LA5A4:  .byte   $02,$01,$03,$01,$01,$02 ; A5A4
LA5AA:  .byte   $DC,$FF,$FF,$FF ; A5AA  child spawn delay
LA5AE:  .byte   $86,$81,$81,$82 ; A5AE  child sub_type
LA5B2:  .byte   $A6,$A7,$A7,$A8 ; A5B2  child type
LA5B6:  .byte   $00,$80,$80,$87 ; A5B6  child shape
LA5BA:  .byte   $00,$E3,$22,$00 ; A5BA  child xvel sub
LA5BE:  .byte   $00,$02,$01,$00 ; A5BE  child xvel px
LA5C2:  .byte   $00,$4B,$4B,$00 ; A5C2  child param
LA5C6:  .byte   $00,$05,$05,$00 ; A5C6  child param2
LA5CA:  .byte   $86,$88,$88,$A8 ; A5CA  child Y
LA5CE:  .byte   $F4,$00,$00,$08 ; A5CE  child X offset
LA5D2:  .byte   $0C,$0C,$0C,$0C,$0C,$0C ; A5D2  skull hop kind (rnd)
LA5D8:  .byte   $0C,$0C,$0A,$0A,$0A ; A5D8  skull hop sub_type
LA5DD:  .byte   $0B,$0C,$0D,$0E,$0E,$82,$82,$82 ; A5DD  skull hop flags
        .byte   $82,$82,$08,$08,$08,$08,$08 ; A5E5
LA5EC:  .byte   $30 ; A5EC  explosion X/Y offset pairs
LA5ED:  .byte   $D4,$00,$0C,$50,$14,$F8,$DC,$00 ; A5ED
        .byte   $2C,$48,$EC,$30,$14,$28,$EC,$40 ; A5F5
        .byte   $2C ; A5FD
LA5FE:  .byte   $0F,$30,$2C,$13,$0F,$30,$36,$13 ; A5FE  phase-2 palette (3 rows)
        .byte   $0F,$30,$27,$17 ; A606
LA60A:  .byte   $0F,$0F,$20,$11,$0F,$20,$24,$14 ; A60A  phase-2 palette row 4 (2x)
LA612:  .byte   $38,$48,$58,$68,$78,$88,$98,$38 ; A612  teleport Y (rnd&7)
LA61A:  .byte   $30,$D0,$50,$B0,$70 ; A61A  teleport X
LA61F:  .byte   $90,$50,$B0,$07,$07,$07,$07,$03 ; A61F  teleport X mask by Y row
        .byte   $03,$01 ; A627
LA629:  .byte   $00,$E0,$00,$20 ; A629  spread shot X offs
LA62D:  .byte   $E0,$00,$20,$00 ; A62D  spread shot Y offs
LA631:  .byte   $0C,$08,$04,$00,$04,$00,$0C,$08 ; A631  spread shot start angle
LA639:  .byte   $01,$01,$01,$01,$01,$01,$01,$01 ; A639  spiral step delays
        .byte   $02,$02,$02,$04,$04,$04,$04,$02 ; A641
        .byte   $06,$06,$06,$08,$08,$06,$08,$0E ; A649
        .byte   $06,$06,$0A,$0A,$08,$08,$08,$08 ; A651
        .byte   $06,$06,$06,$06,$04,$04,$04,$04 ; A659
        .byte   $03,$03,$03,$03,$51,$6D,$79,$FF ; A661
        .byte   $74,$FD ; A669
        .byte   $45,$77,$35,$F6,$85,$FD,$75,$BF ; A66B
        .byte   $94,$FF,$1D,$9F,$D7,$DE,$F5,$DA ; A673
        .byte   $3F,$BF,$14,$FF,$5C,$EF,$5F,$67 ; A67B
        .byte   $5D,$B7,$D5,$EF,$17,$1C,$5D,$BB ; A683
        .byte   $55,$EF,$35,$E7,$79,$DB,$31,$FE ; A68B
        .byte   $17,$FB,$5C,$BE,$4D,$9F,$45,$F7 ; A693
        .byte   $55,$FD,$5F,$5E,$57,$7D,$7D,$7E ; A69B
        .byte   $57,$77,$D5,$EF,$16,$F7,$F7,$F3 ; A6A3
        .byte   $57,$DC,$54,$FF,$65,$EF,$55,$BD ; A6AB
        .byte   $DD,$FB,$65,$FD,$C1,$E8,$ED,$F3 ; A6B3
        .byte   $5C,$B6,$F5,$F7,$77,$AB,$45,$FF ; A6BB
        .byte   $F1,$3F,$C7,$BF,$55,$BF,$C5,$9A ; A6C3
        .byte   $55,$FB,$57,$9D,$57,$E5,$7D,$AF ; A6CB
        .byte   $55,$A7,$75,$9F,$B5,$77,$15,$86 ; A6D3
        .byte   $85,$AA,$7F,$F7,$55,$DF,$14,$FB ; A6DB
        .byte   $35,$FF,$36,$FE,$FD,$FF,$5B,$DF ; A6E3
        .byte   $75,$DF,$75,$B7,$7F,$DF,$7F,$FB ; A6EB
        .byte   $79,$B3,$FD,$7F,$FD,$C7,$E5,$FB ; A6F3
        .byte   $FD,$FD,$9D,$7E,$5D,$FA,$57,$67 ; A6FB
        .byte   $71,$BE,$55,$57,$45,$C1,$D1,$DE ; A703
        .byte   $D5,$EE,$5E,$F8,$45,$2F,$16,$F7 ; A70B
        .byte   $C7,$FB,$4D,$FB,$37,$BF,$F7,$FE ; A713
        .byte   $7F,$F5,$77,$FD,$43,$7F,$55,$3F ; A71B
        .byte   $3C,$FF,$9D,$FF,$53,$FF,$77,$1F ; A723
        .byte   $51,$4A,$75,$FF,$D4,$FF,$57,$FE ; A72B
        .byte   $CF,$FF,$D4,$6E,$D7,$FB,$C4,$FF ; A733
        .byte   $5D,$F9,$DA,$FC,$35,$FD,$D1,$BB ; A73B
        .byte   $75,$76,$DD,$F3,$55,$FE,$DE,$FA ; A743
        .byte   $B5,$F5,$56,$E5,$55,$D9,$77,$FD ; A74B
        .byte   $6C,$DF,$DE,$7F,$F4,$AF,$3A,$ED ; A753
        .byte   $47,$6F,$55,$DF,$77,$FF,$FD,$DF ; A75B
        .byte   $51,$BB,$51,$FF,$55,$FB,$51,$F6 ; A763
        .byte   $7F,$7D,$55,$77,$76,$F7,$55,$FF ; A76B
        .byte   $57,$EE,$C5,$FF,$85,$F7,$5D,$BF ; A773
        .byte   $47,$EF,$F4,$F9,$39,$DE,$66,$7D ; A77B
        .byte   $F5,$F3,$11,$FF,$45,$3B,$5D,$9C ; A783
        .byte   $77,$F6,$47,$BF,$53,$FF,$C7,$FF ; A78B
        .byte   $92,$FB,$1F,$BB,$3D,$DF,$59,$F7 ; A793
        .byte   $47,$B7,$F1,$9E,$B7,$FF,$5D,$D6 ; A79B
        .byte   $D7,$7F,$D5,$FD,$F5,$F7,$55,$BB ; A7A3
        .byte   $5F,$EF,$3E,$FF,$74,$BF,$17,$D7 ; A7AB
        .byte   $63,$FB,$74,$3F,$F0,$E7,$53,$DF ; A7B3
        .byte   $74,$ED,$7D,$FF,$77,$BD,$51,$BD ; A7BB
        .byte   $57,$BF,$31,$FF,$D5,$3D,$3D,$E6 ; A7C3
        .byte   $EC,$9F,$51,$7E,$11,$6E,$1D,$BF ; A7CB
        .byte   $D4,$AF,$51,$FF,$DD,$4B,$BD,$BF ; A7D3
        .byte   $2C,$BC,$55,$DF,$7C,$FD,$55,$DF ; A7DB
        .byte   $DF,$EF,$54,$DF,$54,$EF,$DB,$EF ; A7E3
        .byte   $35,$FF,$2B,$FB,$F5,$FF,$51,$A7 ; A7EB
        .byte   $75,$FF,$5B,$DF,$17,$FF,$57,$FE ; A7F3
        .byte   $55,$FE,$75,$FF,$D5 ; A7FB
; --- $A800: DAMAGE TABLE, weapon $4 (Napalm Bomb) ---
; $A800[ent_type] via damage_engine $1C:809D; low 7 bits = damage,
; bit 7 = special handling; $00 = ricochet. Types $00-$CF.
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A800  types $00-$0F
        .byte   $02,$03,$01,$01,$01,$01,$02,$02,$03,$01,$01,$03,$01,$01,$00,$00 ; A810  types $10-$1F
        .byte   $04,$03,$00,$00,$00,$01,$00,$00,$03,$01,$03,$01,$00,$00,$00,$00 ; A820  types $20-$2F
        .byte   $00,$02,$01,$02,$01,$00,$01,$00,$00,$01,$02,$01,$00,$00,$02,$00 ; A830  types $30-$3F
        .byte   $03,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01 ; A840  types $40-$4F
        .byte   $01,$00,$01,$01,$01,$00,$01,$00,$00,$05,$01,$00,$01,$03,$00,$00 ; A850  types $50-$5F
        .byte   $01,$00,$01,$01,$01,$01,$01,$01,$01,$04,$00,$01,$00,$00,$01,$00 ; A860  types $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01,$00,$00,$00 ; A870  types $70-$7F
        .byte   $00,$01,$00,$01,$00,$00,$01,$00,$00,$01,$00,$00,$00,$01,$00,$00 ; A880  types $80-$8F
        .byte   $00,$02,$00,$01,$00,$00,$01,$00,$01,$00,$00,$00,$02,$00,$00,$00 ; A890  types $90-$9F
        .byte   $01,$00,$00,$00,$00,$01,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00 ; A8A0  types $A0-$AF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$06,$02,$00 ; A8B0  types $B0-$BF
        .byte   $00,$00,$00,$00,$06,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A8C0  types $C0-$CF
; --- $A8D0: remainder (beyond type $CF) ---
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A8D0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A8E0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A8F0

; =============================================================================
; STAR MAN STAGE DATA — format: DATA_REFERENCE.md section 11
; =============================================================================
; --- $A900: screen -> layout index ---
        .byte   $00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0A,$0B,$0C,$0D,$0E,$0F ; A900  screens $00-$0F
        .byte   $10,$11,$12,$13,$14,$15,$16,$17,$00,$00,$80,$04,$20,$08,$20,$88 ; A910  screens $10-$1F
        .byte   $00,$00,$80,$01,$02,$02,$0A,$00,$82,$02,$00,$22,$08,$00,$02,$00 ; A920  screens $20-$2F
        .byte   $82,$04,$08,$81,$00,$08,$00,$02,$00,$74,$00,$10,$00,$81,$08,$12 ; A930  screens $30-$3F
        .byte   $00,$40,$20,$00,$00,$00,$80,$82,$00,$40,$00,$08,$00,$00,$80,$20 ; A940  screens $40-$4F
; --- $A950: section list: start screen (bits 0-4) | flags (bits 5-7) ---
        .byte   $22,$63,$40,$63,$80,$A0,$20,$21,$22,$20,$20,$20,$00,$14,$00,$95 ; A950
        .byte   $08,$10,$80,$00,$00,$24,$02,$04 ; A960
; --- $A968: per-section attributes (bit 7 = vertical-scroll room) ---
        .byte   $1D,$2D,$1C,$1C,$0A,$2D,$1F,$1C,$24,$1F,$80,$B7,$00,$10,$00,$80 ; A968
        .byte   $82,$00,$08,$6C,$00,$08,$08,$00 ; A978
; --- $A980: BG CHR banks (MMC3 R0/R1 <- $A980/$A981; rest unreferenced) ---
        .byte   $90,$92,$08,$08,$00,$10,$02,$08 ; A980
; --- $A988: BG palette (16 bytes) ---
        .byte   $0F,$20,$23,$13,$0F,$2C,$1C,$01,$0F,$20,$10,$1A,$0F,$38,$28,$15 ; A988
; --- $A998: sprite palette-cycle seeds -> $05F0 slots ($A998-$A99B read) ---
        .byte   $00,$00,$00,$00,$00,$D4,$20,$40 ; A998
; --- $A9A0: unreferenced ---
        .byte   $08,$00,$20,$00,$00,$42,$00,$10,$80,$04,$80,$80,$00,$00,$02,$04 ; A9A0
        .byte   $00,$04,$80,$22,$00,$08,$00,$00,$08,$B0,$20,$40,$A0,$0D,$02,$12 ; A9B0
        .byte   $20,$85,$00,$10,$08,$00,$2A,$14,$20,$40,$00,$00,$80,$00,$00,$00 ; A9C0
        .byte   $02,$02,$02,$80,$02,$00,$02,$10,$02,$00,$88,$00,$00,$20,$00,$44 ; A9D0
; --- $A9E0: screen links [screen, Y band, dest screen, dest section], bit 7 ends ---
        .byte   $FF,$00,$08,$60,$20,$00,$00,$00,$00,$11,$02,$00,$80,$80,$00,$01 ; A9E0  terminator / filler
        .byte   $00,$00,$00,$50,$82,$40,$00,$04,$00,$04,$00,$10,$20,$C4,$80 ; A9F0  
        .byte   $D1                             ; A9FF  -1 base for the spawn arrays
; --- $AA00: spawn screens (ascending) ---
        .byte   $01,$03,$03,$03,$04,$04,$04,$04,$04,$05,$05,$05,$05,$06,$06,$06 ; AA00  entries $00-$0F
        .byte   $07,$07,$09,$09,$09,$0A,$0A,$0A,$0B,$0B,$0B,$0B,$0C,$0C,$0C,$0D ; AA10  entries $10-$1F
        .byte   $0D,$0D,$0D,$0E,$0F,$0F,$0F,$0F,$0F,$10,$10,$10,$11,$11,$11,$12 ; AA20  entries $20-$2F
        .byte   $12,$12,$12,$12,$12,$13,$13,$13,$13,$13,$13,$14,$16,$FF,$00,$81 ; AA30  entries $30-$3F
        .byte   $02,$10,$02,$08,$00,$02,$00,$00,$00,$20,$00,$00,$20,$00,$80,$00 ; AA40  entries $40-$4F
        .byte   $00,$0D,$00,$10,$00,$60,$00,$48,$88,$C0,$08,$51,$00,$52,$80,$19 ; AA50  entries $50-$5F
        .byte   $00,$08,$00,$00,$00,$19,$02,$80,$00,$00,$00,$01,$00,$04,$00,$00 ; AA60  entries $60-$6F
        .byte   $00,$00,$00,$08,$00,$40,$00,$84,$02,$00,$00,$12,$02,$44,$A8,$C0 ; AA70  entries $70-$7F
; --- $AA80: spawn X px ---
        .byte   $40,$50,$51,$D0,$00,$48,$90,$D0,$F0,$20,$50,$90,$D0,$10,$50,$90 ; AA80  entries $00-$0F
        .byte   $38,$50,$70,$A0,$F0,$50,$B0,$F0,$60,$80,$90,$B8,$20,$30,$40,$50 ; AA90  entries $10-$1F
        .byte   $70,$B0,$F0,$D0,$48,$78,$80,$98,$A8,$50,$80,$E0,$00,$A0,$F0,$10 ; AAA0  entries $20-$2F
        .byte   $30,$70,$71,$D8,$F0,$10,$30,$50,$60,$98,$A8,$D0,$D8,$FF,$00,$20 ; AAB0  entries $30-$3F
        .byte   $00,$00,$00,$01,$80,$04,$20,$00,$00,$20,$80,$00,$28,$84,$00,$30 ; AAC0  entries $40-$4F
        .byte   $A2,$50,$08,$02,$00,$20,$28,$00,$00,$08,$28,$01,$00,$0A,$00,$A2 ; AAD0  entries $50-$5F
        .byte   $00,$14,$02,$10,$00,$00,$08,$32,$00,$EA,$00,$00,$00,$10,$80,$08 ; AAE0  entries $60-$6F
        .byte   $00,$00,$80,$00,$00,$09,$82,$40,$80,$40,$00,$10,$00,$52,$28,$28 ; AAF0  entries $70-$7F
; --- $AB00: spawn Y px ---
        .byte   $00,$50,$BD,$BD,$00,$30,$30,$BD,$9D,$5D,$7D,$30,$30,$AD,$40,$40 ; AB00  entries $00-$0F
        .byte   $70,$D0,$2F,$70,$A0,$50,$60,$60,$90,$60,$AD,$6D,$B0,$98,$80,$7D ; AB10  entries $10-$1F
        .byte   $5D,$9D,$BD,$AC,$30,$40,$B8,$70,$A0,$50,$B0,$80,$00,$E0,$38,$28 ; AB20  entries $20-$2F
        .byte   $E0,$58,$48,$28,$18,$E0,$E0,$48,$58,$E0,$E0,$AC,$00,$FF,$2A,$46 ; AB30  entries $30-$3F
        .byte   $00,$00,$00,$00,$20,$40,$0A,$00,$20,$80,$00,$10,$00,$10,$00,$00 ; AB40  entries $40-$4F
        .byte   $0A,$80,$00,$20,$08,$00,$80,$19,$80,$00,$00,$01,$00,$A1,$02,$01 ; AB50  entries $50-$5F
        .byte   $00,$06,$00,$00,$08,$08,$00,$04,$00,$00,$00,$01,$00,$28,$00,$00 ; AB60  entries $60-$6F
        .byte   $80,$00,$00,$01,$22,$E8,$A0,$08,$00,$88,$00,$80,$00,$00,$02,$02 ; AB70  entries $70-$7F
; --- $AB80: spawn codes (< $C0 enemy id, >= $C0 palette/CHR command) ---
        .byte   $11,$2B,$3B,$3B,$D4,$2B,$2B,$3B,$3B,$3B,$3B,$2B,$2B,$3B,$2B,$2B ; AB80  entries $00-$0F
        .byte   $33,$33,$8C,$33,$03,$03,$03,$03,$03,$03,$3B,$3B,$37,$37,$37,$3B ; AB90  entries $10-$1F
        .byte   $3B,$3B,$3B,$1E,$03,$03,$84,$03,$03,$03,$03,$03,$47,$10,$52,$2C ; ABA0  entries $20-$2F
        .byte   $10,$52,$2C,$53,$2C,$10,$10,$2C,$54,$10,$10,$1E,$69,$FF,$0A,$C0 ; ABB0  entries $30-$3F
        .byte   $00,$02,$20,$00,$08,$41,$00,$00,$00,$04,$00,$08,$08,$10,$20,$80 ; ABC0  entries $40-$4F
        .byte   $28,$00,$00,$02,$00,$22,$00,$10,$02,$00,$00,$00,$00,$60,$00,$11 ; ABD0  entries $50-$5F
        .byte   $00,$00,$20,$00,$00,$08,$28,$04,$A0,$40,$00,$05,$08,$04,$00,$02 ; ABE0  entries $60-$6F
        .byte   $02,$00,$20,$04,$20,$00,$08,$08,$08,$20,$02,$42,$00,$40,$00,$11 ; ABF0  entries $70-$7F
; --- $AC00: per-screen spawn-list start index ---
        .byte   $00,$00,$01,$01,$04,$09,$0D,$10,$12,$12,$15,$18,$1C,$1F,$23,$24 ; AC00  screens $00-$0F
        .byte   $29,$2C,$2F,$35,$3B,$3C,$3C,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC10  screens $10-$1F
        .byte   $00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC20  screens $20-$2F
        .byte   $20,$00,$00,$00,$00,$00,$00,$00,$00,$04,$80,$00,$00,$00,$00,$00 ; AC30  screens $30-$3F
        .byte   $00,$00,$00,$00,$02,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00 ; AC40  screens $40-$4F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$04,$00,$00,$00,$00,$00 ; AC50  screens $50-$5F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$00,$01,$00,$00,$00 ; AC60  screens $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$02,$00,$00,$40,$00,$00,$00,$00,$00,$04 ; AC70  screens $70-$7F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$00,$00,$00 ; AC80  screens $80-$8F
        .byte   $00,$00,$00,$00,$00,$00,$04,$00,$00,$00,$00,$00,$20,$00,$00,$00 ; AC90  screens $90-$9F
        .byte   $00,$00,$40,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACA0  screens $A0-$AF
        .byte   $80,$00,$00,$00,$00,$00,$10,$00,$08,$00,$00,$00,$00,$00,$00,$00 ; ACB0  screens $B0-$BF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACC0  screens $C0-$CF
        .byte   $05,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$10,$00,$08,$00 ; ACD0  screens $D0-$DF
        .byte   $00,$40,$00,$00,$00,$00,$01,$00,$80,$00,$00,$00,$00,$10,$00,$00 ; ACE0  screens $E0-$EF
        .byte   $00,$00,$02,$00,$00,$00,$08,$00,$02,$40,$02,$00,$00,$00,$00,$40 ; ACF0  screens $F0-$FF
; --- $AD00: metatile top-left tile ids ---
        .byte   $00,$01,$11,$10,$06,$02,$04,$04,$0C,$0E,$8F,$00,$26,$00,$85,$26 ; AD00  metatiles $00-$0F
        .byte   $2C,$2E,$00,$09,$00,$92,$40,$42,$D2,$E8,$18,$09,$00,$00,$60,$62 ; AD10  metatiles $10-$1F
        .byte   $00,$82,$84,$00,$EC,$EE,$00,$88,$A0,$8A,$11,$A6,$00,$00,$CC,$CE ; AD20  metatiles $20-$2F
        .byte   $C0,$AA,$11,$C6,$C8,$00,$AE,$11,$00,$E2,$E4,$E6,$AC,$EA,$A1,$A3 ; AD30  metatiles $30-$3F
        .byte   $4D,$5D,$5D,$27,$5D,$30,$11,$11,$88,$00,$8A,$00,$AC,$00,$83,$00 ; AD40  metatiles $40-$4F
        .byte   $A8,$98,$00,$9B,$00,$84,$00,$00,$85,$B8,$4D,$00,$00,$00,$E8,$8D ; AD50  metatiles $50-$5F
        .byte   $8C,$AE,$00,$00,$00,$00,$E8,$AF,$00,$00,$00,$00,$00,$00,$00,$00 ; AD60  metatiles $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AD70  metatiles $70-$7F
        .byte   $C0,$C2,$C4,$C6,$44,$45,$45,$00,$E0,$01,$01,$E6,$64,$65,$65,$00 ; AD80  metatiles $80-$8F
        .byte   $A0,$A2,$A4,$A6,$20,$22,$30,$32,$28,$2A,$A2,$C9,$30,$32,$24,$34 ; AD90  metatiles $90-$9F
        .byte   $B0,$B2,$B4,$B6,$30,$11,$00,$11,$48,$E9,$4B,$49,$48,$49,$4B,$4B ; ADA0  metatiles $A0-$AF
        .byte   $4E,$7D,$84,$86,$84,$86,$6A,$00,$5E,$7D,$96,$95,$7D,$00,$7A,$00 ; ADB0  metatiles $B0-$BF
        .byte   $1A,$00,$1A,$1A,$00,$00,$00,$00,$1A,$00,$00,$00,$CC,$CE,$28,$2A ; ADC0  metatiles $C0-$CF
        .byte   $E9,$EE,$EF,$00,$28,$CE,$1A,$2A,$E9,$EB,$CB,$11,$A8,$A9,$AA,$A9 ; ADD0  metatiles $D0-$DF
        .byte   $40,$42,$00,$88,$8A,$89,$00,$A9,$60,$62,$49,$80,$81,$00,$81,$AB ; ADE0  metatiles $E0-$EF
        .byte   $68,$69,$78,$11,$11,$27,$30,$00,$78,$11,$69,$11,$11,$30,$30,$00 ; ADF0  metatiles $F0-$FF
; --- $AE00: metatile bottom-left tile ids ---
        .byte   $00,$01,$11,$10,$07,$03,$05,$05,$0D,$0F,$9F,$00,$27,$00,$86,$27 ; AE00  metatiles $00-$0F
        .byte   $2D,$2F,$09,$08,$00,$93,$41,$43,$D3,$E9,$00,$00,$00,$19,$61,$63 ; AE10  metatiles $10-$1F
        .byte   $81,$83,$00,$00,$ED,$EF,$87,$89,$11,$11,$8E,$A7,$A5,$00,$CD,$CF ; AE20  metatiles $20-$2F
        .byte   $C1,$AB,$C5,$C7,$C9,$00,$AF,$11,$E1,$11,$E5,$E7,$AD,$00,$A2,$A4 ; AE30  metatiles $30-$3F
        .byte   $5D,$5D,$26,$5D,$33,$11,$11,$33,$89,$00,$8B,$00,$AD,$84,$00,$9A ; AE40  metatiles $40-$4F
        .byte   $A9,$99,$9A,$8B,$00,$83,$00,$00,$86,$B9,$5D,$9A,$00,$00,$8C,$E8 ; AE50  metatiles $50-$5F
        .byte   $8D,$AF,$00,$00,$00,$00,$AE,$E8,$00,$00,$00,$00,$00,$00,$00,$00 ; AE60  metatiles $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AE70  metatiles $70-$7F
        .byte   $C1,$C3,$C5,$C7,$45,$45,$47,$00,$E1,$E3,$E5,$E7,$65,$65,$67,$00 ; AE80  metatiles $80-$8F
        .byte   $A1,$A3,$A5,$A7,$21,$23,$31,$33,$29,$2B,$C8,$A5,$31,$33,$25,$35 ; AE90  metatiles $90-$9F
        .byte   $B1,$B3,$B5,$B7,$11,$11,$00,$33,$4B,$00,$4C,$4C,$49,$49,$4A,$4B ; AEA0  metatiles $A0-$AF
        .byte   $4F,$6C,$85,$87,$85,$87,$33,$00,$6F,$7C,$97,$94,$7C,$00,$33,$00 ; AEB0  metatiles $B0-$BF
        .byte   $1A,$00,$1A,$00,$1A,$00,$00,$1A,$00,$00,$00,$00,$CD,$CF,$29,$2B ; AEC0  metatiles $C0-$CF
        .byte   $ED,$EE,$EC,$1A,$CD,$CF,$1A,$CD,$EA,$EB,$EC,$11,$A9,$A9,$AB,$AC ; AED0  metatiles $D0-$DF
        .byte   $41,$43,$00,$89,$8A,$8B,$00,$AA,$61,$63,$00,$81,$81,$00,$82,$A9 ; AEE0  metatiles $E0-$EF
        .byte   $69,$6A,$11,$7A,$26,$11,$00,$33,$11,$7A,$69,$11,$33,$11,$00,$33 ; AEF0  metatiles $F0-$FF
; --- $AF00: metatile top-right tile ids ---
        .byte   $00,$01,$11,$10,$16,$12,$14,$14,$1C,$1E,$8F,$0A,$36,$0B,$B5,$36 ; AF00  metatiles $00-$0F
        .byte   $3C,$3E,$08,$00,$00,$C2,$50,$52,$E3,$F8,$00,$00,$00,$00,$70,$72 ; AF10  metatiles $10-$1F
        .byte   $90,$11,$94,$96,$FC,$FE,$87,$98,$B0,$9A,$11,$11,$C4,$00,$DC,$DE ; AF20  metatiles $20-$2F
        .byte   $00,$00,$D4,$D6,$11,$DA,$BF,$BD,$00,$F2,$F4,$F6,$00,$FA,$B1,$B3 ; AF30  metatiles $30-$3F
        .byte   $30,$11,$11,$30,$11,$1B,$39,$39,$98,$88,$9A,$8B,$BC,$93,$00,$00 ; AF40  metatiles $40-$4F
        .byte   $00,$A8,$00,$9A,$8B,$94,$00,$00,$95,$94,$37,$00,$00,$00,$F8,$9E ; AF50  metatiles $50-$5F
        .byte   $9C,$BE,$BE,$9C,$00,$00,$F8,$BF,$00,$00,$00,$00,$00,$00,$00,$00 ; AF60  metatiles $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AF70  metatiles $70-$7F
        .byte   $D0,$D2,$D4,$D6,$54,$55,$55,$00,$F0,$F2,$F4,$F6,$74,$75,$75,$00 ; AF80  metatiles $80-$8F
        .byte   $B0,$B2,$B4,$B6,$30,$32,$24,$34,$38,$3A,$B2,$B4,$30,$32,$30,$32 ; AF90  metatiles $90-$9F
        .byte   $B0,$B2,$B4,$B6,$30,$11,$00,$11,$58,$E9,$5B,$59,$58,$59,$5B,$5B ; AFA0  metatiles $A0-$AF
        .byte   $5E,$7D,$94,$96,$98,$9A,$7A,$00,$7E,$7D,$98,$9A,$7D,$00,$79,$00 ; AFB0  metatiles $B0-$BF
        .byte   $1A,$1A,$00,$1A,$00,$00,$1A,$1A,$1A,$D9,$D8,$D8,$DC,$DE,$DC,$DE ; AFC0  metatiles $C0-$CF
        .byte   $E9,$FE,$FF,$00,$38,$DE,$CA,$DC,$F9,$DB,$FB,$11,$B8,$B9,$BA,$B9 ; AFD0  metatiles $D0-$DF
        .byte   $50,$52,$00,$00,$00,$00,$00,$B9,$70,$72,$59,$90,$91,$00,$91,$BB ; AFE0  metatiles $E0-$EF
        .byte   $78,$11,$78,$11,$11,$30,$30,$00,$6B,$7B,$11,$7B,$11,$37,$30,$00 ; AFF0  metatiles $F0-$FF
; --- $B000: metatile bottom-right tile ids ---
        .byte   $00,$01,$11,$10,$17,$13,$15,$15,$1D,$1F,$9F,$0A,$37,$0A,$B6,$37 ; B000  metatiles $00-$0F
        .byte   $3D,$3F,$00,$00,$09,$C3,$51,$53,$F7,$F9,$00,$00,$00,$00,$71,$73 ; B010  metatiles $10-$1F
        .byte   $91,$11,$95,$00,$FD,$FF,$97,$99,$11,$9B,$9E,$B7,$00,$00,$DD,$DF ; B020  metatiles $20-$2F
        .byte   $D1,$00,$D5,$D7,$D9,$00,$00,$BE,$F1,$F3,$F5,$11,$BC,$FB,$B2,$B4 ; B030  metatiles $30-$3F
        .byte   $11,$11,$33,$11,$33,$39,$39,$6E,$99,$89,$9B,$00,$BD,$94,$00,$BB ; B040  metatiles $40-$4F
        .byte   $00,$A9,$00,$9B,$9D,$00,$93,$00,$96,$00,$11,$00,$00,$00,$9C,$F8 ; B050  metatiles $50-$5F
        .byte   $9E,$BF,$BF,$9E,$00,$00,$BE,$F8,$00,$00,$00,$00,$00,$00,$00,$00 ; B060  metatiles $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B070  metatiles $70-$7F
        .byte   $D1,$D3,$D5,$D7,$55,$55,$57,$00,$F1,$F3,$F5,$F7,$75,$75,$77,$00 ; B080  metatiles $80-$8F
        .byte   $B1,$B3,$B5,$B7,$31,$33,$25,$35,$00,$3B,$B3,$B5,$31,$33,$31,$33 ; B090  metatiles $90-$9F
        .byte   $B1,$B3,$B5,$B7,$11,$11,$00,$33,$5B,$00,$5C,$5C,$59,$59,$5A,$5B ; B0A0  metatiles $A0-$AF
        .byte   $5F,$7C,$95,$97,$99,$9B,$33,$00,$7F,$6C,$99,$9B,$7C,$00,$33,$00 ; B0B0  metatiles $B0-$BF
        .byte   $1A,$1A,$00,$00,$1A,$1A,$00,$1A,$1A,$D8,$DA,$D8,$DD,$DF,$DD,$DF ; B0C0  metatiles $C0-$CF
        .byte   $FD,$FE,$EC,$CA,$DD,$DF,$CA,$DD,$FA,$DB,$FC,$11,$B9,$B9,$BB,$BC ; B0D0  metatiles $D0-$DF
        .byte   $51,$53,$00,$00,$00,$00,$00,$BA,$71,$73,$00,$91,$91,$00,$92,$B9 ; B0E0  metatiles $E0-$EF
        .byte   $11,$7A,$11,$7A,$33,$11,$00,$33,$7B,$79,$11,$7B,$36,$11,$00,$33 ; B0F0  metatiles $F0-$FF
; --- $B100: metatile attributes: palette (bits 0-1) | collision (high nibble: ---
; $20 solid, $40 ladder, >= $D0 spikes; see DATA_REFERENCE section 11)
        .byte   $00,$00,$01,$01,$00,$F3,$42,$22,$10,$10,$00,$01,$00,$01,$03,$21 ; B100  metatiles $00-$0F
        .byte   $10,$10,$03,$01,$03,$03,$10,$10,$03,$03,$02,$01,$00,$01,$10,$10 ; B110  metatiles $10-$1F
        .byte   $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01 ; B120  metatiles $20-$2F
        .byte   $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01 ; B130  metatiles $30-$3F
        .byte   $10,$10,$10,$10,$10,$10,$10,$10,$01,$01,$01,$01,$01,$01,$01,$01 ; B140  metatiles $40-$4F
        .byte   $01,$01,$01,$01,$01,$01,$01,$00,$01,$01,$10,$00,$00,$00,$01,$01 ; B150  metatiles $50-$5F
        .byte   $01,$01,$01,$01,$00,$00,$01,$01,$00,$00,$00,$00,$00,$00,$00,$00 ; B160  metatiles $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B170  metatiles $70-$7F
        .byte   $12,$12,$12,$12,$10,$10,$10,$00,$12,$12,$12,$12,$10,$10,$10,$00 ; B180  metatiles $80-$8F
        .byte   $10,$10,$10,$10,$10,$10,$10,$10,$01,$01,$10,$10,$10,$10,$10,$10 ; B190  metatiles $90-$9F
        .byte   $10,$10,$10,$10,$10,$10,$00,$10,$10,$00,$10,$10,$10,$10,$10,$10 ; B1A0  metatiles $A0-$AF
        .byte   $10,$10,$10,$10,$10,$10,$10,$00,$10,$10,$10,$10,$10,$00,$10,$00 ; B1B0  metatiles $B0-$BF
        .byte   $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01 ; B1C0  metatiles $C0-$CF
        .byte   $12,$12,$12,$01,$01,$01,$01,$01,$12,$12,$12,$02,$10,$10,$10,$10 ; B1D0  metatiles $D0-$DF
        .byte   $12,$12,$10,$10,$10,$10,$10,$10,$12,$12,$10,$00,$00,$00,$00,$10 ; B1E0  metatiles $E0-$EF
        .byte   $10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10 ; B1F0  metatiles $F0-$FF
; --- $B200: 32px block defs: 4 metatile ids [TL,BL,TR,BR] per block ---
        .byte   $20,$21,$28,$02,$22,$23,$02,$2B,$00,$00,$2C,$00,$00,$00,$00,$00 ; B200  blocks $00-$03
        .byte   $12,$13,$1A,$1B,$14,$00,$00,$1D,$30,$02,$38,$39,$32,$33,$3A,$3B ; B210  blocks $04-$07
        .byte   $34,$35,$02,$3D,$0E,$15,$18,$19,$26,$27,$2E,$2F,$29,$02,$31,$3C ; B220  blocks $08-$0B
        .byte   $02,$2A,$37,$36,$24,$25,$3E,$3F,$00,$00,$98,$99,$98,$99,$A8,$AE ; B230  blocks $0C-$0F
        .byte   $E0,$E1,$E8,$E9,$43,$F0,$FD,$F8,$F1,$B1,$F9,$BC,$A4,$A5,$A4,$A5 ; B240  blocks $10-$13
        .byte   $A5,$B1,$A5,$BC,$1B,$00,$00,$00,$98,$99,$AC,$AD,$98,$99,$AD,$AE ; B250  blocks $14-$17
        .byte   $44,$B0,$A7,$B8,$40,$42,$A4,$FC,$43,$41,$FD,$A5,$A7,$B1,$A7,$BC ; B260  blocks $18-$1B
        .byte   $A4,$A7,$A4,$A7,$13,$00,$1B,$00,$00,$12,$00,$1A,$AC,$AD,$40,$F0 ; B270  blocks $1C-$1F
        .byte   $AC,$AD,$F0,$F1,$AE,$AB,$F1,$B0,$A8,$AD,$40,$44,$A8,$AA,$40,$44 ; B280  blocks $20-$23
        .byte   $A4,$F2,$A4,$F2,$F2,$F3,$F2,$F3,$F3,$B8,$F3,$B1,$F3,$B1,$F3,$BC ; B290  blocks $24-$27
        .byte   $F3,$BC,$F3,$B1,$45,$F8,$AD,$AE,$F8,$F9,$AF,$AD,$F9,$B9,$AD,$AE ; B2A0  blocks $28-$2B
        .byte   $45,$47,$AF,$AD,$45,$47,$AC,$AA,$98,$99,$AE,$AF,$A4,$F4,$A4,$FC ; B2B0  blocks $2C-$2F
        .byte   $16,$17,$1E,$1F,$08,$09,$10,$11,$14,$00,$1B,$00,$05,$05,$00,$00 ; B2C0  blocks $30-$33
        .byte   $E1,$E0,$E9,$E8,$A8,$AA,$40,$B0,$F5,$B8,$FD,$B1,$00,$13,$00,$1B ; B2D0  blocks $34-$37
        .byte   $A4,$B1,$A4,$BC,$05,$00,$00,$00,$00,$00,$00,$13,$00,$00,$13,$00 ; B2E0  blocks $38-$3B
        .byte   $A4,$F8,$A4,$F0,$F9,$B8,$F1,$B1,$F9,$B1,$F1,$BC,$43,$F0,$FD,$F2 ; B2F0  blocks $3C-$3F
        .byte   $F0,$F1,$F2,$F3,$A4,$F2,$A4,$F8,$F2,$F3,$F8,$F9,$D0,$D1,$D0,$D1 ; B300  blocks $40-$43
        .byte   $D2,$D0,$D2,$D0,$D1,$D1,$D1,$D1,$D1,$D2,$D1,$D2,$D8,$D9,$00,$00 ; B310  blocks $44-$47
        .byte   $DA,$D8,$50,$51,$D9,$D9,$48,$49,$DA,$D8,$00,$00,$D9,$DA,$00,$00 ; B320  blocks $48-$4B
        .byte   $50,$51,$1B,$00,$48,$49,$50,$51,$00,$13,$48,$49,$1B,$00,$13,$00 ; B330  blocks $4C-$4F
        .byte   $00,$56,$00,$4D,$59,$00,$4E,$00,$98,$99,$AE,$AB,$56,$55,$58,$99 ; B340  blocks $50-$53
        .byte   $F1,$B0,$F3,$B8,$40,$41,$A4,$A5,$40,$F0,$A4,$F8,$F1,$B0,$F9,$B8 ; B350  blocks $54-$57
        .byte   $F3,$B1,$F9,$BC,$A4,$F0,$A4,$F2,$F1,$B1,$F3,$BC,$A4,$A7,$F0,$B6 ; B360  blocks $58-$5B
        .byte   $F3,$B0,$F3,$B8,$45,$46,$AD,$AE,$45,$F8,$AF,$AD,$F9,$BC,$AD,$AE ; B370  blocks $5C-$5F
        .byte   $F8,$BE,$AF,$AD,$00,$00,$00,$56,$4D,$4E,$55,$00,$00,$4D,$56,$55 ; B380  blocks $60-$63
        .byte   $4E,$00,$00,$00,$F5,$F2,$FD,$F2,$00,$00,$05,$05,$53,$4B,$52,$53 ; B390  blocks $64-$67
        .byte   $52,$53,$00,$52,$4B,$00,$53,$54,$50,$51,$1A,$1B,$4F,$4C,$4B,$1B ; B3A0  blocks $68-$6B
        .byte   $00,$00,$1B,$00,$C9,$CA,$C4,$C0,$A4,$B8,$A4,$B1,$C4,$C0,$C4,$C0 ; B3B0  blocks $6C-$6F
        .byte   $C1,$C1,$C0,$C0,$62,$63,$60,$61,$45,$47,$8C,$8E,$A4,$A7,$45,$47 ; B3C0  blocks $70-$73
        .byte   $A4,$F2,$45,$F8,$C4,$C0,$D4,$CD,$C0,$C0,$CC,$CD,$61,$60,$60,$61 ; B3D0  blocks $74-$77
        .byte   $C1,$C1,$CC,$CD,$8C,$8E,$CE,$CF,$8C,$8D,$CE,$CF,$A4,$BC,$A4,$BC ; B3E0  blocks $78-$7B
        .byte   $90,$91,$80,$81,$92,$93,$82,$83,$88,$89,$90,$91,$8A,$8B,$92,$93 ; B3F0  blocks $7C-$7F
        .byte   $F3,$A7,$F3,$A7,$D0,$D2,$D0,$D2,$D8,$DA,$05,$05,$D0,$D2,$D8,$DA ; B400  blocks $80-$83
        .byte   $C5,$C1,$C4,$C0,$F3,$A7,$F9,$47,$05,$05,$C5,$C1,$C4,$C0,$C7,$C0 ; B410  blocks $84-$87
        .byte   $8C,$8D,$05,$05,$8D,$8E,$05,$05,$45,$F8,$8C,$8D,$F9,$47,$8D,$8E ; B420  blocks $88-$8B
        .byte   $C0,$C0,$C0,$C0,$05,$05,$C1,$C1,$C0,$C0,$94,$95,$C0,$C0,$C4,$C0 ; B430  blocks $8C-$8F
        .byte   $8D,$8D,$CE,$CF,$8D,$8E,$CE,$CF,$C4,$C0,$D7,$D5,$9C,$9D,$9E,$9F ; B440  blocks $90-$93
        .byte   $CC,$CD,$90,$91,$CC,$CD,$92,$93,$D3,$D6,$05,$05,$A0,$A1,$80,$81 ; B450  blocks $94-$97
        .byte   $A2,$A3,$82,$83,$94,$95,$9E,$9F,$D0,$D1,$D8,$D9,$D1,$D2,$D9,$DA ; B460  blocks $98-$9B
        .byte   $A4,$F0,$45,$F8,$FA,$FA,$FB,$FB,$A4,$A5,$45,$46,$CC,$CD,$84,$85 ; B470  blocks $9C-$9F
        .byte   $C0,$C0,$90,$9A,$C0,$C0,$D3,$D6,$C0,$C0,$D6,$D6,$C0,$C0,$9B,$93 ; B480  blocks $A0-$A3
        .byte   $40,$F0,$A4,$F2,$A0,$A1,$A0,$A1,$05,$05,$9B,$93,$05,$05,$90,$9A ; B490  blocks $A4-$A7
        .byte   $A2,$A3,$A2,$A3,$05,$05,$94,$95,$A7,$A4,$47,$45,$A5,$A5,$46,$46 ; B4A0  blocks $A8-$AB
        .byte   $A5,$A7,$46,$47,$A4,$A5,$A4,$F0,$A5,$A7,$F1,$A7,$B1,$07,$BC,$07 ; B4B0  blocks $AC-$AF
        .byte   $8E,$8C,$05,$05,$8D,$8D,$05,$05,$A4,$F8,$8C,$8D,$F9,$A7,$8D,$8E ; B4C0  blocks $B0-$B3
        .byte   $BC,$07,$B9,$07,$C1,$07,$C0,$07,$CC,$CD,$85,$85,$CC,$CD,$85,$86 ; B4D0  blocks $B4-$B7
        .byte   $61,$60,$90,$91,$CC,$CF,$92,$93,$F1,$44,$F3,$A7,$F3,$A7,$F9,$A7 ; B4E0  blocks $B8-$BB
        .byte   $C4,$C0,$D3,$D6,$F1,$A7,$F3,$A7,$A7,$07,$A7,$07,$A4,$A7,$8C,$8E ; B4F0  blocks $BC-$BF
        .byte   $A4,$B1,$8C,$B9,$A8,$AA,$5A,$B0,$A7,$07,$A7,$00,$A7,$00,$A7,$00 ; B500  blocks $C0-$C3
        .byte   $A7,$00,$A7,$99,$A7,$AC,$A7,$40,$AF,$AD,$F0,$FA,$AC,$AD,$FA,$FA ; B510  blocks $C4-$C7
        .byte   $AF,$AA,$FA,$B6,$A8,$AD,$40,$F0,$AC,$AD,$FA,$B6,$AA,$06,$B0,$07 ; B520  blocks $C8-$CB
        .byte   $A7,$A4,$A7,$A4,$F8,$FB,$A5,$A5,$FB,$FB,$A5,$A5,$FB,$BE,$A5,$A7 ; B530  blocks $CC-$CF
        .byte   $A4,$F8,$A4,$A5,$B8,$07,$B1,$07,$A7,$B1,$A7,$B9,$A7,$05,$A7,$00 ; B540  blocks $D0-$D3
        .byte   $A8,$AE,$40,$44,$14,$00,$00,$00,$A8,$AB,$40,$B0,$17,$16,$1F,$1E ; B550  blocks $D4-$D7
        .byte   $A7,$06,$A7,$07,$00,$17,$05,$1F,$00,$00,$EB,$EC,$00,$00,$EC,$EC ; B560  blocks $D8-$DB
        .byte   $00,$00,$EC,$EE,$00,$EB,$00,$00,$EC,$EC,$00,$00,$EC,$EE,$00,$00 ; B570  blocks $DC-$DF
        .byte   $A7,$BC,$A7,$B1,$45,$47,$A8,$AA,$45,$46,$AB,$AC,$47,$BC,$A8,$AA ; B580  blocks $E0-$E3
        .byte   $45,$F8,$AB,$AC,$F9,$47,$AD,$AE,$A8,$AA,$12,$0A,$13,$0A,$00,$0A ; B590  blocks $E4-$E7
        .byte   $F2,$F2,$F2,$F2,$F3,$F3,$F3,$F3,$F2,$F2,$F8,$F2,$F3,$F3,$F3,$F9 ; B5A0  blocks $E8-$EB
        .byte   $F0,$F2,$F2,$F2,$F3,$F1,$F3,$F3,$A7,$BC,$47,$B9,$F2,$F2,$F8,$F8 ; B5B0  blocks $EC-$EF
        .byte   $F3,$F3,$F9,$F9,$AB,$AC,$C1,$C1,$AD,$AE,$C1,$C1,$A8,$AA,$C1,$0A ; B5C0  blocks $F0-$F3
        .byte   $C0,$0A,$C0,$0A,$BC,$17,$B1,$1F,$16,$F5,$1E,$FD,$BC,$C5,$B1,$C4 ; B5D0  blocks $F4-$F7
        .byte   $C1,$A4,$C0,$A4,$BC,$C4,$B1,$C4,$C0,$A4,$C0,$A4,$BC,$C4,$B9,$C4 ; B5E0  blocks $F8-$FB
        .byte   $AA,$C4,$C1,$C7,$E0,$F5,$E8,$FD,$00,$A4,$00,$A4,$00,$00,$00,$00 ; B5F0  blocks $FC-$FF
; --- $B600: screen layouts: 64 block ids (8x8) each; ptr = $B600 + layout*64 ---
; layout $00
        .byte   $00,$01,$02,$03,$04,$03,$03,$05,$06,$07,$08,$03,$03,$05,$09,$03 ; B600
        .byte   $0A,$0B,$0C,$04,$03,$03,$04,$05,$0D,$00,$01,$02,$05,$03,$03,$03 ; B610
        .byte   $0D,$06,$07,$08,$04,$05,$03,$03,$0D,$0A,$0B,$0C,$0E,$0E,$0F,$0F ; B620
        .byte   $10,$10,$10,$10,$10,$10,$11,$12,$03,$03,$04,$03,$04,$03,$13,$14 ; B630
; layout $01
        .byte   $05,$03,$05,$03,$04,$03,$03,$05,$03,$04,$03,$03,$03,$05,$03,$03 ; B640
        .byte   $03,$03,$15,$04,$03,$03,$04,$05,$03,$03,$04,$03,$05,$03,$04,$03 ; B650
        .byte   $04,$03,$05,$03,$04,$05,$03,$03,$16,$17,$0E,$0E,$0E,$0E,$0E,$0F ; B660
        .byte   $18,$19,$10,$10,$10,$10,$10,$1A,$1B,$1C,$04,$03,$1D,$03,$04,$13 ; B670
; layout $02
        .byte   $05,$03,$05,$03,$04,$03,$03,$05,$03,$04,$03,$03,$03,$05,$03,$03 ; B680
        .byte   $03,$03,$15,$04,$03,$03,$04,$05,$1D,$03,$04,$03,$05,$03,$03,$03 ; B690
        .byte   $1E,$0E,$0E,$0E,$0E,$05,$03,$1D,$16,$1F,$20,$21,$22,$0E,$03,$23 ; B6A0
        .byte   $18,$24,$25,$26,$1C,$22,$04,$1C,$1B,$24,$25,$27,$1C,$1C,$03,$1C ; B6B0
; layout $03
        .byte   $1B,$24,$25,$28,$1C,$1C,$04,$1C,$1B,$29,$2A,$2B,$2C,$2D,$03,$1C ; B6C0
        .byte   $1B,$03,$04,$03,$03,$03,$04,$1C,$1B,$1D,$05,$03,$04,$1D,$05,$1C ; B6D0
        .byte   $1B,$04,$16,$2E,$2E,$2E,$2E,$2C,$1B,$0E,$0E,$0E,$0E,$0E,$0E,$0E ; B6E0
        .byte   $1B,$10,$10,$10,$10,$10,$10,$10,$1B,$1E,$1D,$03,$04,$03,$03,$03 ; B6F0
; layout $04
        .byte   $2F,$30,$30,$31,$30,$30,$30,$30,$1C,$32,$03,$32,$03,$33,$33,$33 ; B700
        .byte   $1C,$03,$04,$03,$32,$03,$04,$03,$1C,$1D,$05,$03,$03,$1D,$05,$03 ; B710
        .byte   $2D,$04,$32,$03,$10,$05,$03,$0E,$0E,$0E,$0E,$0E,$34,$0E,$0E,$35 ; B720
        .byte   $10,$10,$10,$10,$10,$10,$10,$36,$03,$37,$03,$04,$34,$03,$03,$38 ; B730
; layout $05
        .byte   $30,$30,$30,$31,$30,$30,$31,$30,$33,$39,$03,$03,$04,$3A,$03,$1D ; B740
        .byte   $0E,$0E,$3B,$1D,$05,$03,$04,$03,$1F,$21,$0E,$04,$03,$1D,$05,$33 ; B750
        .byte   $3C,$3D,$23,$03,$03,$04,$32,$03,$24,$27,$1C,$0E,$0E,$0E,$16,$2E ; B760
        .byte   $3C,$3E,$2F,$10,$10,$10,$3F,$40,$24,$27,$1C,$04,$03,$1D,$41,$42 ; B770
; layout $06
        .byte   $30,$30,$43,$44,$45,$44,$46,$24,$05,$03,$47,$48,$49,$4A,$4B,$24 ; B780
        .byte   $32,$03,$1D,$32,$4C,$4D,$4E,$24,$33,$03,$03,$1D,$4F,$1D,$4C,$24 ; B790
        .byte   $32,$05,$03,$04,$50,$51,$03,$24,$52,$16,$16,$52,$53,$03,$04,$24 ; B7A0
        .byte   $54,$55,$56,$57,$23,$05,$32,$24,$58,$13,$59,$5A,$1C,$03,$03,$24 ; B7B0
; layout $07
        .byte   $27,$13,$24,$28,$5B,$04,$32,$24,$5C,$5D,$5E,$5F,$60,$03,$03,$24 ; B7C0
        .byte   $27,$61,$62,$03,$05,$03,$04,$24,$27,$63,$64,$03,$32,$0E,$0E,$24 ; B7D0
        .byte   $27,$62,$03,$03,$03,$10,$10,$65,$27,$4D,$4E,$66,$05,$03,$04,$24 ; B7E0
        .byte   $27,$32,$4C,$4D,$4E,$32,$03,$24,$27,$67,$1D,$03,$4C,$4D,$03,$24 ; B7F0
; layout $08
        .byte   $27,$68,$69,$03,$03,$6A,$4D,$24,$27,$03,$6B,$6C,$03,$05,$03,$24 ; B800
        .byte   $27,$0E,$05,$0E,$0E,$0E,$0E,$24,$27,$35,$6D,$30,$30,$30,$30,$65 ; B810
        .byte   $27,$6E,$6F,$70,$71,$72,$73,$74,$27,$38,$75,$76,$77,$78,$79,$7A ; B820
        .byte   $27,$7B,$7C,$7D,$7C,$7D,$7C,$7D,$27,$38,$7E,$7F,$7E,$7F,$7E,$7F ; B830
; layout $09
        .byte   $25,$80,$81,$82,$24,$80,$24,$80,$25,$80,$83,$84,$74,$85,$24,$80 ; B840
        .byte   $25,$80,$86,$87,$88,$89,$8A,$8B,$25,$80,$6F,$8C,$70,$70,$8D,$8D ; B850
        .byte   $42,$85,$6F,$8C,$8E,$8F,$8C,$8C,$90,$91,$92,$76,$93,$6F,$94,$95 ; B860
        .byte   $7C,$7D,$7C,$7D,$93,$96,$97,$98,$7E,$7F,$7E,$7F,$93,$99,$7E,$7F ; B870
; layout $0A
        .byte   $9A,$9B,$9A,$9B,$9C,$9D,$85,$9E,$86,$8D,$8D,$8D,$8D,$8D,$8D,$88 ; B880
        .byte   $6F,$8C,$8C,$8C,$8C,$8C,$8C,$70,$87,$8C,$8C,$8C,$8C,$8C,$8C,$9F ; B890
        .byte   $8C,$8C,$A0,$A1,$A2,$A3,$A1,$A4,$94,$95,$A5,$A6,$A7,$A8,$A9,$41 ; B8A0
        .byte   $97,$98,$97,$98,$97,$98,$93,$59,$7E,$7F,$7E,$7F,$7E,$7F,$93,$24 ; B8B0
; layout $0B
        .byte   $AA,$AB,$AB,$AC,$AD,$AE,$AF,$38,$B0,$B1,$B1,$89,$B2,$B3,$B4,$38 ; B8C0
        .byte   $70,$70,$70,$71,$70,$71,$B5,$38,$B6,$B7,$8F,$77,$8C,$B8,$B9,$38 ; B8D0
        .byte   $40,$BA,$6F,$77,$8C,$A5,$A8,$38,$25,$BB,$BC,$B8,$95,$A5,$A8,$38 ; B8E0
        .byte   $25,$BD,$A9,$97,$98,$97,$98,$38,$25,$80,$93,$7E,$7F,$7E,$7F,$38 ; B8F0
; layout $0C
        .byte   $BE,$BF,$C0,$2F,$10,$10,$10,$C1,$BE,$04,$05,$1C,$33,$33,$33,$6E ; B900
        .byte   $BE,$05,$03,$72,$05,$03,$05,$38,$C2,$03,$03,$33,$1D,$05,$03,$38 ; B910
        .byte   $C3,$32,$05,$03,$04,$03,$1D,$38,$C4,$0E,$0E,$0E,$0E,$0E,$0E,$38 ; B920
        .byte   $C5,$C6,$C7,$C8,$C9,$CA,$CB,$38,$CC,$CD,$CE,$CF,$D0,$CF,$D1,$38 ; B930
; layout $0D
        .byte   $1B,$1C,$9A,$9B,$9A,$9B,$59,$BD,$D2,$72,$33,$33,$33,$33,$24,$80 ; B940
        .byte   $D3,$33,$04,$03,$03,$04,$8A,$8B,$C3,$1D,$03,$D4,$1D,$32,$03,$03 ; B950
        .byte   $C3,$D5,$D6,$1C,$03,$03,$03,$04,$C4,$0E,$6E,$1C,$66,$D7,$0E,$0E ; B960
        .byte   $D8,$D4,$38,$2F,$30,$30,$30,$30,$BE,$1C,$38,$1C,$03,$1D,$03,$04 ; B970
; layout $0E
        .byte   $05,$03,$05,$03,$04,$03,$03,$05,$03,$04,$03,$03,$03,$05,$03,$03 ; B980
        .byte   $03,$03,$15,$04,$03,$03,$04,$05,$03,$03,$04,$03,$05,$03,$03,$03 ; B990
        .byte   $1E,$1D,$05,$03,$04,$05,$03,$03,$0E,$0E,$0E,$03,$03,$03,$03,$04 ; B9A0
        .byte   $30,$30,$30,$66,$66,$30,$30,$30,$03,$1D,$03,$15,$04,$03,$1D,$03 ; B9B0
; layout $0F
        .byte   $05,$03,$05,$03,$04,$03,$03,$05,$03,$04,$03,$03,$03,$05,$03,$03 ; B9C0
        .byte   $03,$03,$15,$04,$03,$03,$04,$05,$03,$03,$04,$03,$05,$03,$03,$03 ; B9D0
        .byte   $1E,$1D,$05,$03,$04,$05,$03,$03,$03,$1D,$03,$05,$03,$03,$03,$03 ; B9E0
        .byte   $30,$30,$66,$D9,$30,$30,$30,$30,$03,$03,$3B,$03,$05,$03,$03,$03 ; B9F0
; layout $10
        .byte   $05,$03,$05,$03,$04,$03,$03,$D5,$03,$04,$03,$03,$03,$05,$03,$03 ; BA00
        .byte   $03,$03,$15,$04,$03,$03,$04,$03,$03,$03,$04,$03,$05,$03,$03,$03 ; BA10
        .byte   $1E,$1D,$05,$03,$04,$05,$03,$03,$03,$03,$1D,$03,$03,$03,$03,$03 ; BA20
        .byte   $30,$66,$66,$D9,$30,$30,$30,$30,$1D,$03,$04,$03,$04,$03,$03,$03 ; BA30
; layout $11
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$DA,$DB ; BA40
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BA50
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BA60
        .byte   $D7,$D7,$D7,$D7,$66,$66,$66,$66,$03,$03,$03,$03,$03,$03,$03,$03 ; BA70
; layout $12
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$DC,$03,$03,$03,$03,$DD,$DE,$DF ; BA80
        .byte   $03,$03,$DA,$DB,$DC,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BA90
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BAA0
        .byte   $66,$66,$66,$66,$66,$66,$66,$66,$03,$03,$03,$03,$03,$03,$03,$03 ; BAB0
; layout $13
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BAC0
        .byte   $03,$03,$DA,$DC,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BAD0
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$0E,$0E ; BAE0
        .byte   $66,$66,$66,$66,$66,$66,$10,$10,$03,$03,$03,$03,$03,$03,$03,$03 ; BAF0
; layout $14
        .byte   $03,$03,$1C,$13,$E0,$24,$80,$1C,$03,$05,$E1,$E2,$E3,$E4,$E5,$1C ; BB00
        .byte   $05,$03,$33,$33,$33,$33,$33,$1C,$03,$03,$04,$05,$03,$1D,$32,$73 ; BB10
        .byte   $04,$03,$1D,$03,$04,$03,$1D,$E6,$0E,$0E,$03,$0E,$0E,$0E,$0E,$E7 ; BB20
        .byte   $10,$10,$66,$10,$10,$10,$10,$10,$03,$03,$05,$03,$03,$04,$03,$03 ; BB30
; layout $15
        .byte   $1C,$E0,$1C,$E8,$E9,$1C,$E0,$1C,$1C,$E0,$1C,$EA,$EB,$1C,$E0,$1C ; BB40
        .byte   $1C,$E0,$1C,$EC,$ED,$1C,$E0,$1C,$73,$EE,$73,$EF,$F0,$73,$EE,$73 ; BB50
        .byte   $F1,$F2,$F2,$F1,$F2,$F1,$F2,$F3,$8C,$76,$76,$76,$76,$76,$76,$F4 ; BB60
        .byte   $10,$10,$10,$10,$10,$10,$10,$10,$03,$03,$04,$03,$04,$03,$1D,$03 ; BB70
; layout $16
        .byte   $F5,$30,$30,$30,$30,$30,$30,$F6,$F7,$70,$71,$70,$70,$71,$70,$F8 ; BB80
        .byte   $F9,$8C,$77,$8C,$8C,$77,$8C,$FA,$FB,$8C,$77,$8C,$8C,$77,$8C,$FA ; BB90
        .byte   $FC,$8C,$77,$8C,$8C,$77,$8C,$FA,$8C,$76,$77,$76,$76,$77,$76,$FA ; BBA0
        .byte   $10,$10,$10,$10,$10,$10,$10,$FD,$32,$03,$04,$05,$32,$04,$03,$FE ; BBB0
; layout $17
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BBC0
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BBD0
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BBE0
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BBF0
; layout $18
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BC00
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BC10
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BC20
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BC30
; layout $19
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BC40
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BC50
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BC60
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BC70
; layout $1A
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BC80
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BC90
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BCA0
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BCB0
; layout $1B
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BCC0
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BCD0
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BCE0
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BCF0
; layout $1C
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BD00
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BD10
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BD20
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BD30
; layout $1D
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BD40
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BD50
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BD60
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BD70
; layout $1E
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BD80
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BD90
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BDA0
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BDB0
; layout $1F
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BDC0
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BDD0
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BDE0
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BDF0
; layout $20
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BE00
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BE10
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BE20
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BE30
; layout $21
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BE40
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BE50
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BE60
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BE70
; layout $22
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BE80
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BE90
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BEA0
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BEB0
; layout $23
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BEC0
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BED0
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BEE0
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BEF0
; layout $24
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BF00
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BF10
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BF20
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BF30
; layout $25
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BF40
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BF50
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BF60
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BF70
; layout $26
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BF80
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BF90
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BFA0
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BFB0
; layout $27
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BFC0
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BFD0
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BFE0
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; BFF0
