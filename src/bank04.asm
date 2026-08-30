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
        .byte   $03                             ; A811 03                       .
        ora     ($01,x)                         ; A812 01 01                    ..
        ora     ($01,x)                         ; A814 01 01                    ..
        .byte   $02                             ; A816 02                       .
        .byte   $02                             ; A817 02                       .
        .byte   $03                             ; A818 03                       .
        ora     ($01,x)                         ; A819 01 01                    ..
        .byte   $03                             ; A81B 03                       .
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
        ora     ($02,x)                         ; A832 01 02                    ..
        ora     (L0000,x)                       ; A834 01 00                    ..
        ora     (L0000,x)                       ; A836 01 00                    ..
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
        ora     ($01,x)                         ; A84F 01 01                    ..
        brk                                     ; A851 00                       .
        ora     ($01,x)                         ; A852 01 01                    ..
        ora     (L0000,x)                       ; A854 01 00                    ..
        ora     (L0000,x)                       ; A856 01 00                    ..
        brk                                     ; A858 00                       .
        ora     $01                             ; A859 05 01                    ..
        brk                                     ; A85B 00                       .
        ora     ($03,x)                         ; A85C 01 03                    ..
        brk                                     ; A85E 00                       .
        brk                                     ; A85F 00                       .
        ora     (L0000,x)                       ; A860 01 00                    ..
        ora     ($01,x)                         ; A862 01 01                    ..
        ora     ($01,x)                         ; A864 01 01                    ..
        ora     ($01,x)                         ; A866 01 01                    ..
        ora     ($04,x)                         ; A868 01 04                    ..
        brk                                     ; A86A 00                       .
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
        .byte   $02                             ; A891 02                       .
        brk                                     ; A892 00                       .
        ora     (L0000,x)                       ; A893 01 00                    ..
        brk                                     ; A895 00                       .
        ora     (L0000,x)                       ; A896 01 00                    ..
        ora     (L0000,x)                       ; A898 01 00                    ..
        brk                                     ; A89A 00                       .
        brk                                     ; A89B 00                       .
        .byte   $02                             ; A89C 02                       .
        brk                                     ; A89D 00                       .
        brk                                     ; A89E 00                       .
        brk                                     ; A89F 00                       .
        ora     (L0000,x)                       ; A8A0 01 00                    ..
        brk                                     ; A8A2 00                       .
        brk                                     ; A8A3 00                       .
        brk                                     ; A8A4 00                       .
LA8A5:  ora     (L0000,x)                       ; A8A5 01 00                    ..
        brk                                     ; A8A7 00                       .
        brk                                     ; A8A8 00                       .
        brk                                     ; A8A9 00                       .
        ora     (L0000,x)                       ; A8AA 01 00                    ..
        brk                                     ; A8AC 00                       .
        brk                                     ; A8AD 00                       .
LA8AE:  brk                                     ; A8AE 00                       .
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
        asl     $02                             ; A8BD 06 02                    ..
        brk                                     ; A8BF 00                       .
        brk                                     ; A8C0 00                       .
        brk                                     ; A8C1 00                       .
        brk                                     ; A8C2 00                       .
        brk                                     ; A8C3 00                       .
        asl     L0000                           ; A8C4 06 00                    ..
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
LA8E3:  brk                                     ; A8E3 00                       .
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
        .byte   $10                             ; A910 10                       .
LA911:  ora     ($12),y                         ; A911 11 12                    ..
        .byte   $13                             ; A913 13                       .
LA914:  .byte   $14                             ; A914 14                       .
        ora     $16,x                           ; A915 15 16                    ..
        .byte   $17                             ; A917 17                       .
        brk                                     ; A918 00                       .
        brk                                     ; A919 00                       .
        .byte   $80                             ; A91A 80                       .
        .byte   $04                             ; A91B 04                       .
        jsr     L2008                           ; A91C 20 08 20                  . 
        dey                                     ; A91F 88                       .
        brk                                     ; A920 00                       .
        brk                                     ; A921 00                       .
        .byte   $80                             ; A922 80                       .
LA923:  ora     ($02,x)                         ; A923 01 02                    ..
        .byte   $02                             ; A925 02                       .
        asl     a                               ; A926 0A                       .
        brk                                     ; A927 00                       .
        .byte   $82                             ; A928 82                       .
LA929:  .byte   $02                             ; A929 02                       .
        brk                                     ; A92A 00                       .
        .byte   $22                             ; A92B 22                       "
        php                                     ; A92C 08                       .
        brk                                     ; A92D 00                       .
        .byte   $02                             ; A92E 02                       .
        brk                                     ; A92F 00                       .
        .byte   $82                             ; A930 82                       .
        .byte   $04                             ; A931 04                       .
        php                                     ; A932 08                       .
        sta     (L0000,x)                       ; A933 81 00                    ..
        php                                     ; A935 08                       .
        brk                                     ; A936 00                       .
        .byte   $02                             ; A937 02                       .
        brk                                     ; A938 00                       .
        .byte   $74                             ; A939 74                       t
        brk                                     ; A93A 00                       .
        bpl     LA93D                           ; A93B 10 00                    ..
LA93D:  sta     (L0008,x)                       ; A93D 81 08                    ..
        .byte   $12                             ; A93F 12                       .
        brk                                     ; A940 00                       .
        rti                                     ; A941 40                       @

; ----------------------------------------------------------------------------
        jsr     L0000                           ; A942 20 00 00                  ..
        brk                                     ; A945 00                       .
        .byte   $80                             ; A946 80                       .
        .byte   $82                             ; A947 82                       .
        brk                                     ; A948 00                       .
        rti                                     ; A949 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; A94A 00                       .
        php                                     ; A94B 08                       .
        brk                                     ; A94C 00                       .
        brk                                     ; A94D 00                       .
        .byte   $80                             ; A94E 80                       .
        jsr     L6322                           ; A94F 20 22 63                  "c
        rti                                     ; A952 40                       @

; ----------------------------------------------------------------------------
        .byte   $63                             ; A953 63                       c
        .byte   $80                             ; A954 80                       .
        ldy     #$20                            ; A955 A0 20                    . 
        and     ($22,x)                         ; A957 21 22                    !"
        jsr     L2020                           ; A959 20 20 20                    
        brk                                     ; A95C 00                       .
        .byte   $14                             ; A95D 14                       .
        brk                                     ; A95E 00                       .
        sta     L0008,x                         ; A95F 95 08                    ..
        bpl     LA8E3                           ; A961 10 80                    ..
        brk                                     ; A963 00                       .
        brk                                     ; A964 00                       .
        bit     $02                             ; A965 24 02                    $.
        .byte   $04                             ; A967 04                       .
        ora     $1C2D,x                         ; A968 1D 2D 1C                 .-.
        .byte   $1C                             ; A96B 1C                       .
        asl     a                               ; A96C 0A                       .
        and     $1C1F                           ; A96D 2D 1F 1C                 -..
        bit     $1F                             ; A970 24 1F                    $.
        .byte   $80                             ; A972 80                       .
        .byte   $B7                             ; A973 B7                       .
        brk                                     ; A974 00                       .
        bpl     LA977                           ; A975 10 00                    ..
LA977:  .byte   $80                             ; A977 80                       .
        .byte   $82                             ; A978 82                       .
        brk                                     ; A979 00                       .
        php                                     ; A97A 08                       .
        jmp     (L0800)                         ; A97B 6C 00 08                 l..

; ----------------------------------------------------------------------------
        php                                     ; A97E 08                       .
        brk                                     ; A97F 00                       .
        bcc     LA914                           ; A980 90 92                    ..
        php                                     ; A982 08                       .
        php                                     ; A983 08                       .
        brk                                     ; A984 00                       .
        bpl     LA989                           ; A985 10 02                    ..
        php                                     ; A987 08                       .
        .byte   $0F                             ; A988 0F                       .
LA989:  jsr     L1323                           ; A989 20 23 13                  #.
        .byte   $0F                             ; A98C 0F                       .
        bit     $011C                           ; A98D 2C 1C 01                 ,..
        .byte   $0F                             ; A990 0F                       .
        jsr     L1A10                           ; A991 20 10 1A                  ..
        .byte   $0F                             ; A994 0F                       .
        sec                                     ; A995 38                       8
        plp                                     ; A996 28                       (
        ora     L0000,x                         ; A997 15 00                    ..
        brk                                     ; A999 00                       .
        brk                                     ; A99A 00                       .
        brk                                     ; A99B 00                       .
        brk                                     ; A99C 00                       .
        .byte   $D4                             ; A99D D4                       .
        jsr     L0840                           ; A99E 20 40 08                  @.
        brk                                     ; A9A1 00                       .
        jsr     L0000                           ; A9A2 20 00 00                  ..
        .byte   $42                             ; A9A5 42                       B
        brk                                     ; A9A6 00                       .
        bpl     LA929                           ; A9A7 10 80                    ..
        .byte   $04                             ; A9A9 04                       .
        .byte   $80                             ; A9AA 80                       .
        .byte   $80                             ; A9AB 80                       .
        brk                                     ; A9AC 00                       .
        brk                                     ; A9AD 00                       .
        .byte   $02                             ; A9AE 02                       .
        .byte   $04                             ; A9AF 04                       .
        brk                                     ; A9B0 00                       .
        .byte   $04                             ; A9B1 04                       .
        .byte   $80                             ; A9B2 80                       .
        .byte   $22                             ; A9B3 22                       "
        brk                                     ; A9B4 00                       .
        php                                     ; A9B5 08                       .
        brk                                     ; A9B6 00                       .
        brk                                     ; A9B7 00                       .
        php                                     ; A9B8 08                       .
        bcs     LA9DB                           ; A9B9 B0 20                    . 
        rti                                     ; A9BB 40                       @

; ----------------------------------------------------------------------------
        ldy     #$0D                            ; A9BC A0 0D                    ..
        .byte   $02                             ; A9BE 02                       .
        .byte   $12                             ; A9BF 12                       .
        jsr     L0085                           ; A9C0 20 85 00                  ..
        bpl     LA9CD                           ; A9C3 10 08                    ..
        brk                                     ; A9C5 00                       .
        rol     a                               ; A9C6 2A                       *
        .byte   $14                             ; A9C7 14                       .
        jsr     L0040                           ; A9C8 20 40 00                  @.
        brk                                     ; A9CB 00                       .
        .byte   $80                             ; A9CC 80                       .
LA9CD:  brk                                     ; A9CD 00                       .
        brk                                     ; A9CE 00                       .
        brk                                     ; A9CF 00                       .
        .byte   $02                             ; A9D0 02                       .
        .byte   $02                             ; A9D1 02                       .
        .byte   $02                             ; A9D2 02                       .
        .byte   $80                             ; A9D3 80                       .
        .byte   $02                             ; A9D4 02                       .
        brk                                     ; A9D5 00                       .
        .byte   $02                             ; A9D6 02                       .
        bpl     LA9DB                           ; A9D7 10 02                    ..
        brk                                     ; A9D9 00                       .
        dey                                     ; A9DA 88                       .
LA9DB:  brk                                     ; A9DB 00                       .
        brk                                     ; A9DC 00                       .
        jsr     L4400                           ; A9DD 20 00 44                  .D
        .byte   $FF                             ; A9E0 FF                       .
        brk                                     ; A9E1 00                       .
        php                                     ; A9E2 08                       .
        rts                                     ; A9E3 60                       `

; ----------------------------------------------------------------------------
        jsr     L0000                           ; A9E4 20 00 00                  ..
        brk                                     ; A9E7 00                       .
        brk                                     ; A9E8 00                       .
        ora     ($02),y                         ; A9E9 11 02                    ..
        brk                                     ; A9EB 00                       .
        .byte   $80                             ; A9EC 80                       .
        .byte   $80                             ; A9ED 80                       .
        brk                                     ; A9EE 00                       .
        ora     (L0000,x)                       ; A9EF 01 00                    ..
        brk                                     ; A9F1 00                       .
        brk                                     ; A9F2 00                       .
        bvc     LA977                           ; A9F3 50 82                    P.
        rti                                     ; A9F5 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; A9F6 00                       .
        .byte   $04                             ; A9F7 04                       .
        brk                                     ; A9F8 00                       .
        .byte   $04                             ; A9F9 04                       .
        brk                                     ; A9FA 00                       .
        bpl     LAA1D                           ; A9FB 10 20                    . 
        cpy     L0080                           ; A9FD C4 80                    ..
        cmp     ($01),y                         ; A9FF D1 01                    ..
        .byte   $03                             ; AA01 03                       .
        .byte   $03                             ; AA02 03                       .
        .byte   $03                             ; AA03 03                       .
        .byte   $04                             ; AA04 04                       .
        .byte   $04                             ; AA05 04                       .
        .byte   $04                             ; AA06 04                       .
        .byte   $04                             ; AA07 04                       .
        .byte   $04                             ; AA08 04                       .
        ora     $05                             ; AA09 05 05                    ..
        ora     $05                             ; AA0B 05 05                    ..
        asl     $06                             ; AA0D 06 06                    ..
        asl     $07                             ; AA0F 06 07                    ..
        .byte   $07                             ; AA11 07                       .
        ora     #$09                            ; AA12 09 09                    ..
        ora     #$0A                            ; AA14 09 0A                    ..
        asl     a                               ; AA16 0A                       .
        asl     a                               ; AA17 0A                       .
        .byte   $0B                             ; AA18 0B                       .
        .byte   $0B                             ; AA19 0B                       .
        .byte   $0B                             ; AA1A 0B                       .
        .byte   $0B                             ; AA1B 0B                       .
LAA1C:  .byte   $0C                             ; AA1C 0C                       .
LAA1D:  .byte   $0C                             ; AA1D 0C                       .
        .byte   $0C                             ; AA1E 0C                       .
        .byte   $0D                             ; AA1F 0D                       .
LAA20:  ora     $0D0D                           ; AA20 0D 0D 0D                 ...
        asl     $0F0F                           ; AA23 0E 0F 0F                 ...
        .byte   $0F                             ; AA26 0F                       .
        .byte   $0F                             ; AA27 0F                       .
        .byte   $0F                             ; AA28 0F                       .
        bpl     LAA3B                           ; AA29 10 10                    ..
        bpl     LAA3E                           ; AA2B 10 11                    ..
        ora     ($11),y                         ; AA2D 11 11                    ..
        .byte   $12                             ; AA2F 12                       .
        .byte   $12                             ; AA30 12                       .
        .byte   $12                             ; AA31 12                       .
        .byte   $12                             ; AA32 12                       .
        .byte   $12                             ; AA33 12                       .
        .byte   $12                             ; AA34 12                       .
        .byte   $13                             ; AA35 13                       .
        .byte   $13                             ; AA36 13                       .
        .byte   $13                             ; AA37 13                       .
        .byte   $13                             ; AA38 13                       .
        .byte   $13                             ; AA39 13                       .
        .byte   $13                             ; AA3A 13                       .
LAA3B:  .byte   $14                             ; AA3B 14                       .
        asl     $FF,x                           ; AA3C 16 FF                    ..
LAA3E:  brk                                     ; AA3E 00                       .
        sta     ($02,x)                         ; AA3F 81 02                    ..
        bpl     LAA45                           ; AA41 10 02                    ..
        php                                     ; AA43 08                       .
        brk                                     ; AA44 00                       .
LAA45:  .byte   $02                             ; AA45 02                       .
        brk                                     ; AA46 00                       .
LAA47:  brk                                     ; AA47 00                       .
        brk                                     ; AA48 00                       .
        jsr     L0000                           ; AA49 20 00 00                  ..
        jsr     L8000                           ; AA4C 20 00 80                  ..
        brk                                     ; AA4F 00                       .
        brk                                     ; AA50 00                       .
        ora     $1000                           ; AA51 0D 00 10                 ...
LAA54:  brk                                     ; AA54 00                       .
        rts                                     ; AA55 60                       `

; ----------------------------------------------------------------------------
        brk                                     ; AA56 00                       .
        pha                                     ; AA57 48                       H
LAA58:  dey                                     ; AA58 88                       .
        cpy     #$08                            ; AA59 C0 08                    ..
        eor     (L0000),y                       ; AA5B 51 00                    Q.
        .byte   $52                             ; AA5D 52                       R
        .byte   $80                             ; AA5E 80                       .
        ora     L0800,y                         ; AA5F 19 00 08                 ...
        brk                                     ; AA62 00                       .
        brk                                     ; AA63 00                       .
        brk                                     ; AA64 00                       .
        ora     $8002,y                         ; AA65 19 02 80                 ...
        brk                                     ; AA68 00                       .
        brk                                     ; AA69 00                       .
        brk                                     ; AA6A 00                       .
        ora     (L0000,x)                       ; AA6B 01 00                    ..
        .byte   $04                             ; AA6D 04                       .
        brk                                     ; AA6E 00                       .
LAA6F:  brk                                     ; AA6F 00                       .
        brk                                     ; AA70 00                       .
        brk                                     ; AA71 00                       .
        brk                                     ; AA72 00                       .
LAA73:  php                                     ; AA73 08                       .
        brk                                     ; AA74 00                       .
        rti                                     ; AA75 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; AA76 00                       .
        sty     $02                             ; AA77 84 02                    ..
        brk                                     ; AA79 00                       .
        brk                                     ; AA7A 00                       .
        .byte   $12                             ; AA7B 12                       .
        .byte   $02                             ; AA7C 02                       .
        .byte   $44                             ; AA7D 44                       D
        tay                                     ; AA7E A8                       .
        cpy     #$40                            ; AA7F C0 40                    .@
        bvc     LAAD4                           ; AA81 50 51                    PQ
        bne     LAA85                           ; AA83 D0 00                    ..
LAA85:  pha                                     ; AA85 48                       H
        bcc     LAA58                           ; AA86 90 D0                    ..
        beq     LAAAA                           ; AA88 F0 20                    . 
        bvc     LAA1C                           ; AA8A 50 90                    P.
        bne     LAA9E                           ; AA8C D0 10                    ..
        bvc     LAA20                           ; AA8E 50 90                    P.
        sec                                     ; AA90 38                       8
        bvc     LAB03                           ; AA91 50 70                    Pp
LAA93:  ldy     #$F0                            ; AA93 A0 F0                    ..
LAA95:  bvc     LAA47                           ; AA95 50 B0                    P.
        beq     LAAF9                           ; AA97 F0 60                    .`
        .byte   $80                             ; AA99 80                       .
        bcc     LAA54                           ; AA9A 90 B8                    ..
        .byte   $20                             ; AA9C 20                        
        .byte   $30                             ; AA9D 30                       0
LAA9E:  rti                                     ; AA9E 40                       @

; ----------------------------------------------------------------------------
        bvc     LAB11                           ; AA9F 50 70                    Pp
        bcs     LAA93                           ; AAA1 B0 F0                    ..
        bne     LAAED                           ; AAA3 D0 48                    .H
        sei                                     ; AAA5 78                       x
        .byte   $80                             ; AAA6 80                       .
        tya                                     ; AAA7 98                       .
LAAA8:  tay                                     ; AAA8 A8                       .
        .byte   $50                             ; AAA9 50                       P
LAAAA:  .byte   $80                             ; AAAA 80                       .
        cpx     #$00                            ; AAAB E0 00                    ..
        ldy     #$F0                            ; AAAD A0 F0                    ..
        bpl     LAAE1                           ; AAAF 10 30                    .0
        bvs     LAB24                           ; AAB1 70 71                    pq
        cld                                     ; AAB3 D8                       .
        .byte   $F0                             ; AAB4 F0                       .
LAAB5:  .byte   $10,$30                    ; AAB5 10 30   (branch out of range for ca65: target has no local label)
        .byte   $50,$60                    ; AAB7 50 60   (branch out of range for ca65: target has no local label)
        tya                                     ; AAB9 98                       .
        tay                                     ; AABA A8                       .
        bne     LAA95                           ; AABB D0 D8                    ..
        .byte   $FF                             ; AABD FF                       .
        brk                                     ; AABE 00                       .
        .byte   $20                             ; AABF 20                        
LAAC0:  brk                                     ; AAC0 00                       .
        brk                                     ; AAC1 00                       .
        brk                                     ; AAC2 00                       .
        ora     (L0080,x)                       ; AAC3 01 80                    ..
LAAC5:  .byte   $04                             ; AAC5 04                       .
LAAC6:  jsr     L0000                           ; AAC6 20 00 00                  ..
LAAC9:  jsr     L0080                           ; AAC9 20 80 00                  ..
        plp                                     ; AACC 28                       (
        sty     L0000                           ; AACD 84 00                    ..
        bmi     LAA73                           ; AACF 30 A2                    0.
        bvc     LAADB                           ; AAD1 50 08                    P.
        .byte   $02                             ; AAD3 02                       .
LAAD4:  brk                                     ; AAD4 00                       .
        jsr     L0028                           ; AAD5 20 28 00                  (.
        brk                                     ; AAD8 00                       .
        php                                     ; AAD9 08                       .
        plp                                     ; AADA 28                       (
LAADB:  ora     (L0000,x)                       ; AADB 01 00                    ..
        asl     a                               ; AADD 0A                       .
        brk                                     ; AADE 00                       .
        ldx     #$00                            ; AADF A2 00                    ..
LAAE1:  .byte   $14                             ; AAE1 14                       .
        .byte   $02                             ; AAE2 02                       .
        bpl     LAAE5                           ; AAE3 10 00                    ..
LAAE5:  brk                                     ; AAE5 00                       .
        php                                     ; AAE6 08                       .
        .byte   $32                             ; AAE7 32                       2
        brk                                     ; AAE8 00                       .
        nop                                     ; AAE9 EA                       .
        brk                                     ; AAEA 00                       .
        brk                                     ; AAEB 00                       .
        brk                                     ; AAEC 00                       .
LAAED:  bpl     LAA6F                           ; AAED 10 80                    ..
        php                                     ; AAEF 08                       .
        brk                                     ; AAF0 00                       .
        brk                                     ; AAF1 00                       .
        .byte   $80                             ; AAF2 80                       .
        brk                                     ; AAF3 00                       .
        brk                                     ; AAF4 00                       .
        ora     #$82                            ; AAF5 09 82                    ..
        rti                                     ; AAF7 40                       @

; ----------------------------------------------------------------------------
        .byte   $80                             ; AAF8 80                       .
LAAF9:  rti                                     ; AAF9 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; AAFA 00                       .
        bpl     LAAFD                           ; AAFB 10 00                    ..
LAAFD:  .byte   $52                             ; AAFD 52                       R
        plp                                     ; AAFE 28                       (
        plp                                     ; AAFF 28                       (
        brk                                     ; AB00 00                       .
        bvc     LAAC0                           ; AB01 50 BD                    P.
LAB03:  lda     $3000,x                         ; AB03 BD 00 30                 ..0
        bmi     LAAC5                           ; AB06 30 BD                    0.
LAB08:  sta     $7D5D,x                         ; AB08 9D 5D 7D                 .]}
        bmi     LAB3D                           ; AB0B 30 30                    00
        lda     $4040                           ; AB0D AD 40 40                 .@@
        .byte   $70                             ; AB10 70                       p
LAB11:  bne     LAB42                           ; AB11 D0 2F                    ./
        bvs     LAAB5                           ; AB13 70 A0                    p.
        bvc     LAB77                           ; AB15 50 60                    P`
        rts                                     ; AB17 60                       `

; ----------------------------------------------------------------------------
        bcc     LAB7A                           ; AB18 90 60                    .`
        lda     LB06D                           ; AB1A AD 6D B0                 .m.
        tya                                     ; AB1D 98                       .
        .byte   $80                             ; AB1E 80                       .
        adc     $9D5D,x                         ; AB1F 7D 5D 9D                 }].
        .byte   $BD                             ; AB22 BD                       .
        .byte   $AC                             ; AB23 AC                       .
LAB24:  bmi     LAB66                           ; AB24 30 40                    0@
        clv                                     ; AB26 B8                       .
        bvs     LAAC9                           ; AB27 70 A0                    p.
        bvc     LAADB                           ; AB29 50 B0                    P.
        .byte   $80                             ; AB2B 80                       .
        brk                                     ; AB2C 00                       .
        cpx     #$38                            ; AB2D E0 38                    .8
        plp                                     ; AB2F 28                       (
        cpx     #$58                            ; AB30 E0 58                    .X
        pha                                     ; AB32 48                       H
        plp                                     ; AB33 28                       (
        clc                                     ; AB34 18                       .
        cpx     #$E0                            ; AB35 E0 E0                    ..
        pha                                     ; AB37 48                       H
        cli                                     ; AB38 58                       X
        cpx     #$E0                            ; AB39 E0 E0                    ..
        .byte   $AC                             ; AB3B AC                       .
        brk                                     ; AB3C 00                       .
LAB3D:  .byte   $FF                             ; AB3D FF                       .
        rol     a                               ; AB3E 2A                       *
        lsr     L0000                           ; AB3F 46 00                    F.
        brk                                     ; AB41 00                       .
LAB42:  brk                                     ; AB42 00                       .
        brk                                     ; AB43 00                       .
        jsr     L0A40                           ; AB44 20 40 0A                  @.
        brk                                     ; AB47 00                       .
        jsr     L0080                           ; AB48 20 80 00                  ..
        bpl     LAB4D                           ; AB4B 10 00                    ..
LAB4D:  bpl     LAB4F                           ; AB4D 10 00                    ..
LAB4F:  brk                                     ; AB4F 00                       .
        asl     a                               ; AB50 0A                       .
        .byte   $80                             ; AB51 80                       .
        brk                                     ; AB52 00                       .
        jsr     L0008                           ; AB53 20 08 00                  ..
        .byte   $80                             ; AB56 80                       .
        ora     L0080,y                         ; AB57 19 80 00                 ...
        brk                                     ; AB5A 00                       .
        ora     (L0000,x)                       ; AB5B 01 00                    ..
        lda     ($02,x)                         ; AB5D A1 02                    ..
        ora     (L0000,x)                       ; AB5F 01 00                    ..
        asl     L0000                           ; AB61 06 00                    ..
        brk                                     ; AB63 00                       .
        php                                     ; AB64 08                       .
        php                                     ; AB65 08                       .
LAB66:  brk                                     ; AB66 00                       .
        .byte   $04                             ; AB67 04                       .
        brk                                     ; AB68 00                       .
        brk                                     ; AB69 00                       .
        brk                                     ; AB6A 00                       .
        ora     (L0000,x)                       ; AB6B 01 00                    ..
        plp                                     ; AB6D 28                       (
        brk                                     ; AB6E 00                       .
        brk                                     ; AB6F 00                       .
        .byte   $80                             ; AB70 80                       .
        brk                                     ; AB71 00                       .
        brk                                     ; AB72 00                       .
        ora     ($22,x)                         ; AB73 01 22                    ."
        inx                                     ; AB75 E8                       .
        .byte   $A0                             ; AB76 A0                       .
LAB77:  php                                     ; AB77 08                       .
        brk                                     ; AB78 00                       .
        dey                                     ; AB79 88                       .
LAB7A:  brk                                     ; AB7A 00                       .
        .byte   $80                             ; AB7B 80                       .
        brk                                     ; AB7C 00                       .
        brk                                     ; AB7D 00                       .
        .byte   $02                             ; AB7E 02                       .
        .byte   $02                             ; AB7F 02                       .
        ora     ($2B),y                         ; AB80 11 2B                    .+
        .byte   $3B                             ; AB82 3B                       ;
        .byte   $3B                             ; AB83 3B                       ;
        .byte   $D4                             ; AB84 D4                       .
        .byte   $2B                             ; AB85 2B                       +
        .byte   $2B                             ; AB86 2B                       +
        .byte   $3B                             ; AB87 3B                       ;
        .byte   $3B                             ; AB88 3B                       ;
        .byte   $3B                             ; AB89 3B                       ;
        .byte   $3B                             ; AB8A 3B                       ;
        .byte   $2B                             ; AB8B 2B                       +
        .byte   $2B                             ; AB8C 2B                       +
        .byte   $3B                             ; AB8D 3B                       ;
        .byte   $2B                             ; AB8E 2B                       +
        .byte   $2B                             ; AB8F 2B                       +
        .byte   $33                             ; AB90 33                       3
        .byte   $33                             ; AB91 33                       3
        sty     $0333                           ; AB92 8C 33 03                 .3.
        .byte   $03                             ; AB95 03                       .
        .byte   $03                             ; AB96 03                       .
        .byte   $03                             ; AB97 03                       .
        .byte   $03                             ; AB98 03                       .
        .byte   $03                             ; AB99 03                       .
        .byte   $3B                             ; AB9A 3B                       ;
        .byte   $3B                             ; AB9B 3B                       ;
        .byte   $37                             ; AB9C 37                       7
        .byte   $37                             ; AB9D 37                       7
        .byte   $37                             ; AB9E 37                       7
        .byte   $3B                             ; AB9F 3B                       ;
        .byte   $3B                             ; ABA0 3B                       ;
        .byte   $3B                             ; ABA1 3B                       ;
        .byte   $3B                             ; ABA2 3B                       ;
        asl     $0303,x                         ; ABA3 1E 03 03                 ...
        sty     $03                             ; ABA6 84 03                    ..
        .byte   $03                             ; ABA8 03                       .
        .byte   $03                             ; ABA9 03                       .
        .byte   $03                             ; ABAA 03                       .
        .byte   $03                             ; ABAB 03                       .
        .byte   $47                             ; ABAC 47                       G
        .byte   $10                             ; ABAD 10                       .
LABAE:  .byte   $52                             ; ABAE 52                       R
        bit     $5210                           ; ABAF 2C 10 52                 ,.R
        bit     $2C53                           ; ABB2 2C 53 2C                 ,S,
        bpl     LABC7                           ; ABB5 10 10                    ..
        bit     $1054                           ; ABB7 2C 54 10                 ,T.
        bpl     LABDA                           ; ABBA 10 1E                    ..
        adc     #$FF                            ; ABBC 69 FF                    i.
        asl     a                               ; ABBE 0A                       .
        cpy     #$00                            ; ABBF C0 00                    ..
        .byte   $02                             ; ABC1 02                       .
        jsr     L0800                           ; ABC2 20 00 08                  ..
        eor     (L0000,x)                       ; ABC5 41 00                    A.
LABC7:  brk                                     ; ABC7 00                       .
        brk                                     ; ABC8 00                       .
        .byte   $04                             ; ABC9 04                       .
        brk                                     ; ABCA 00                       .
        php                                     ; ABCB 08                       .
        php                                     ; ABCC 08                       .
        bpl     LABEF                           ; ABCD 10 20                    . 
        .byte   $80                             ; ABCF 80                       .
        plp                                     ; ABD0 28                       (
        brk                                     ; ABD1 00                       .
        brk                                     ; ABD2 00                       .
        .byte   $02                             ; ABD3 02                       .
        brk                                     ; ABD4 00                       .
        .byte   $22                             ; ABD5 22                       "
        brk                                     ; ABD6 00                       .
        bpl     LABDB                           ; ABD7 10 02                    ..
        brk                                     ; ABD9 00                       .
LABDA:  brk                                     ; ABDA 00                       .
LABDB:  brk                                     ; ABDB 00                       .
        brk                                     ; ABDC 00                       .
        rts                                     ; ABDD 60                       `

; ----------------------------------------------------------------------------
        brk                                     ; ABDE 00                       .
        ora     (L0000),y                       ; ABDF 11 00                    ..
        brk                                     ; ABE1 00                       .
        jsr     L0000                           ; ABE2 20 00 00                  ..
        php                                     ; ABE5 08                       .
        plp                                     ; ABE6 28                       (
        .byte   $04                             ; ABE7 04                       .
        ldy     #$40                            ; ABE8 A0 40                    .@
        brk                                     ; ABEA 00                       .
        ora     L0008                           ; ABEB 05 08                    ..
        .byte   $04                             ; ABED 04                       .
        brk                                     ; ABEE 00                       .
LABEF:  .byte   $02                             ; ABEF 02                       .
        .byte   $02                             ; ABF0 02                       .
        brk                                     ; ABF1 00                       .
        jsr     L2004                           ; ABF2 20 04 20                  . 
        brk                                     ; ABF5 00                       .
        php                                     ; ABF6 08                       .
        php                                     ; ABF7 08                       .
        php                                     ; ABF8 08                       .
LABF9:  jsr     L4202                           ; ABF9 20 02 42                  .B
        brk                                     ; ABFC 00                       .
        rti                                     ; ABFD 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; ABFE 00                       .
        ora     (L0000),y                       ; ABFF 11 00                    ..
LAC01:  brk                                     ; AC01 00                       .
        ora     ($01,x)                         ; AC02 01 01                    ..
        .byte   $04                             ; AC04 04                       .
        ora     #$0D                            ; AC05 09 0D                    ..
        bpl     LAC1B                           ; AC07 10 12                    ..
        .byte   $12                             ; AC09 12                       .
        ora     $18,x                           ; AC0A 15 18                    ..
        .byte   $1C                             ; AC0C 1C                       .
        .byte   $1F                             ; AC0D 1F                       .
        .byte   $23                             ; AC0E 23                       #
        bit     $29                             ; AC0F 24 29                    $)
        bit     $352F                           ; AC11 2C 2F 35                 ,/5
        .byte   $3B                             ; AC14 3B                       ;
        .byte   $3C                             ; AC15 3C                       <
        .byte   $3C                             ; AC16 3C                       <
        brk                                     ; AC17 00                       .
        brk                                     ; AC18 00                       .
        brk                                     ; AC19 00                       .
        brk                                     ; AC1A 00                       .
LAC1B:  brk                                     ; AC1B 00                       .
        brk                                     ; AC1C 00                       .
        brk                                     ; AC1D 00                       .
        brk                                     ; AC1E 00                       .
        brk                                     ; AC1F 00                       .
        brk                                     ; AC20 00                       .
        brk                                     ; AC21 00                       .
        brk                                     ; AC22 00                       .
        brk                                     ; AC23 00                       .
        brk                                     ; AC24 00                       .
        ora     (L0000,x)                       ; AC25 01 00                    ..
        brk                                     ; AC27 00                       .
        brk                                     ; AC28 00                       .
        brk                                     ; AC29 00                       .
        brk                                     ; AC2A 00                       .
        brk                                     ; AC2B 00                       .
        brk                                     ; AC2C 00                       .
        brk                                     ; AC2D 00                       .
        brk                                     ; AC2E 00                       .
        brk                                     ; AC2F 00                       .
        jsr     L0000                           ; AC30 20 00 00                  ..
        brk                                     ; AC33 00                       .
        brk                                     ; AC34 00                       .
        brk                                     ; AC35 00                       .
        brk                                     ; AC36 00                       .
        brk                                     ; AC37 00                       .
        brk                                     ; AC38 00                       .
        .byte   $04                             ; AC39 04                       .
        .byte   $80                             ; AC3A 80                       .
        brk                                     ; AC3B 00                       .
        brk                                     ; AC3C 00                       .
        brk                                     ; AC3D 00                       .
        brk                                     ; AC3E 00                       .
        brk                                     ; AC3F 00                       .
        brk                                     ; AC40 00                       .
        brk                                     ; AC41 00                       .
        brk                                     ; AC42 00                       .
        brk                                     ; AC43 00                       .
        .byte   $02                             ; AC44 02                       .
        brk                                     ; AC45 00                       .
        brk                                     ; AC46 00                       .
        brk                                     ; AC47 00                       .
        brk                                     ; AC48 00                       .
        ora     (L0000,x)                       ; AC49 01 00                    ..
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
        .byte   $04                             ; AC5A 04                       .
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
        .byte   $02                             ; AC6A 02                       .
        brk                                     ; AC6B 00                       .
        ora     (L0000,x)                       ; AC6C 01 00                    ..
        brk                                     ; AC6E 00                       .
        brk                                     ; AC6F 00                       .
        brk                                     ; AC70 00                       .
        brk                                     ; AC71 00                       .
        brk                                     ; AC72 00                       .
        brk                                     ; AC73 00                       .
        brk                                     ; AC74 00                       .
        brk                                     ; AC75 00                       .
        .byte   $02                             ; AC76 02                       .
        brk                                     ; AC77 00                       .
        brk                                     ; AC78 00                       .
        rti                                     ; AC79 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; AC7A 00                       .
        brk                                     ; AC7B 00                       .
        brk                                     ; AC7C 00                       .
        brk                                     ; AC7D 00                       .
        brk                                     ; AC7E 00                       .
        .byte   $04                             ; AC7F 04                       .
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
        .byte   $80                             ; AC8C 80                       .
        brk                                     ; AC8D 00                       .
        brk                                     ; AC8E 00                       .
        brk                                     ; AC8F 00                       .
        brk                                     ; AC90 00                       .
        brk                                     ; AC91 00                       .
        brk                                     ; AC92 00                       .
        brk                                     ; AC93 00                       .
        brk                                     ; AC94 00                       .
        brk                                     ; AC95 00                       .
        .byte   $04                             ; AC96 04                       .
        brk                                     ; AC97 00                       .
        brk                                     ; AC98 00                       .
        brk                                     ; AC99 00                       .
        brk                                     ; AC9A 00                       .
        brk                                     ; AC9B 00                       .
        jsr     L0000                           ; AC9C 20 00 00                  ..
        brk                                     ; AC9F 00                       .
        brk                                     ; ACA0 00                       .
        brk                                     ; ACA1 00                       .
        rti                                     ; ACA2 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; ACA3 00                       .
        brk                                     ; ACA4 00                       .
        brk                                     ; ACA5 00                       .
        brk                                     ; ACA6 00                       .
LACA7:  brk                                     ; ACA7 00                       .
        brk                                     ; ACA8 00                       .
        brk                                     ; ACA9 00                       .
        brk                                     ; ACAA 00                       .
        brk                                     ; ACAB 00                       .
        brk                                     ; ACAC 00                       .
        brk                                     ; ACAD 00                       .
        brk                                     ; ACAE 00                       .
        brk                                     ; ACAF 00                       .
        .byte   $80                             ; ACB0 80                       .
        brk                                     ; ACB1 00                       .
        brk                                     ; ACB2 00                       .
        brk                                     ; ACB3 00                       .
        brk                                     ; ACB4 00                       .
        brk                                     ; ACB5 00                       .
        bpl     LACB8                           ; ACB6 10 00                    ..
LACB8:  php                                     ; ACB8 08                       .
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
        ora     L0000                           ; ACD0 05 00                    ..
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
        bpl     LACDE                           ; ACDC 10 00                    ..
LACDE:  php                                     ; ACDE 08                       .
        brk                                     ; ACDF 00                       .
        brk                                     ; ACE0 00                       .
        rti                                     ; ACE1 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; ACE2 00                       .
        brk                                     ; ACE3 00                       .
        brk                                     ; ACE4 00                       .
        brk                                     ; ACE5 00                       .
        ora     (L0000,x)                       ; ACE6 01 00                    ..
        .byte   $80                             ; ACE8 80                       .
        brk                                     ; ACE9 00                       .
        brk                                     ; ACEA 00                       .
        brk                                     ; ACEB 00                       .
        brk                                     ; ACEC 00                       .
        bpl     LACEF                           ; ACED 10 00                    ..
LACEF:  brk                                     ; ACEF 00                       .
        brk                                     ; ACF0 00                       .
        brk                                     ; ACF1 00                       .
        .byte   $02                             ; ACF2 02                       .
        brk                                     ; ACF3 00                       .
        brk                                     ; ACF4 00                       .
        brk                                     ; ACF5 00                       .
        php                                     ; ACF6 08                       .
        brk                                     ; ACF7 00                       .
        .byte   $02                             ; ACF8 02                       .
        rti                                     ; ACF9 40                       @

; ----------------------------------------------------------------------------
        .byte   $02                             ; ACFA 02                       .
        brk                                     ; ACFB 00                       .
        brk                                     ; ACFC 00                       .
        brk                                     ; ACFD 00                       .
        brk                                     ; ACFE 00                       .
        rti                                     ; ACFF 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; AD00 00                       .
        ora     ($11,x)                         ; AD01 01 11                    ..
        bpl     LAD0B                           ; AD03 10 06                    ..
        .byte   $02                             ; AD05 02                       .
        .byte   $04                             ; AD06 04                       .
        .byte   $04                             ; AD07 04                       .
        .byte   $0C                             ; AD08 0C                       .
        .byte   $0E                             ; AD09 0E                       .
        .byte   $8F                             ; AD0A 8F                       .
LAD0B:  brk                                     ; AD0B 00                       .
        rol     L0000                           ; AD0C 26 00                    &.
        sta     $26                             ; AD0E 85 26                    .&
        bit     a:$2E                           ; AD10 2C 2E 00                 ,..
        ora     #$00                            ; AD13 09 00                    ..
        .byte   $92                             ; AD15 92                       .
        rti                                     ; AD16 40                       @

; ----------------------------------------------------------------------------
        .byte   $42                             ; AD17 42                       B
        .byte   $D2                             ; AD18 D2                       .
        inx                                     ; AD19 E8                       .
        clc                                     ; AD1A 18                       .
        ora     #$00                            ; AD1B 09 00                    ..
        brk                                     ; AD1D 00                       .
        rts                                     ; AD1E 60                       `

; ----------------------------------------------------------------------------
        .byte   $62                             ; AD1F 62                       b
        brk                                     ; AD20 00                       .
        .byte   $82                             ; AD21 82                       .
        sty     L0000                           ; AD22 84 00                    ..
        cpx     a:$EE                           ; AD24 EC EE 00                 ...
        dey                                     ; AD27 88                       .
        ldy     #$8A                            ; AD28 A0 8A                    ..
        ora     ($A6),y                         ; AD2A 11 A6                    ..
        brk                                     ; AD2C 00                       .
        brk                                     ; AD2D 00                       .
        cpy     $C0CE                           ; AD2E CC CE C0                 ...
        tax                                     ; AD31 AA                       .
        ora     ($C6),y                         ; AD32 11 C6                    ..
        iny                                     ; AD34 C8                       .
        brk                                     ; AD35 00                       .
        ldx     a:$11                           ; AD36 AE 11 00                 ...
        .byte   $E2                             ; AD39 E2                       .
        cpx     $E6                             ; AD3A E4 E6                    ..
        ldy     LA1EA                           ; AD3C AC EA A1                 ...
        .byte   $A3                             ; AD3F A3                       .
        eor     $5D5D                           ; AD40 4D 5D 5D                 M]]
        .byte   $27                             ; AD43 27                       '
        eor     $1130,x                         ; AD44 5D 30 11                 ]0.
        ora     ($88),y                         ; AD47 11 88                    ..
        brk                                     ; AD49 00                       .
        txa                                     ; AD4A 8A                       .
        brk                                     ; AD4B 00                       .
        ldy     $8300                           ; AD4C AC 00 83                 ...
        brk                                     ; AD4F 00                       .
        tay                                     ; AD50 A8                       .
        tya                                     ; AD51 98                       .
        brk                                     ; AD52 00                       .
        .byte   $9B                             ; AD53 9B                       .
LAD54:  brk                                     ; AD54 00                       .
        sty     L0000                           ; AD55 84 00                    ..
        brk                                     ; AD57 00                       .
        sta     $B8                             ; AD58 85 B8                    ..
        eor     a:L0000                         ; AD5A 4D 00 00                 M..
        brk                                     ; AD5D 00                       .
        inx                                     ; AD5E E8                       .
        sta     LAE8C                           ; AD5F 8D 8C AE                 ...
        brk                                     ; AD62 00                       .
        brk                                     ; AD63 00                       .
        brk                                     ; AD64 00                       .
        brk                                     ; AD65 00                       .
        inx                                     ; AD66 E8                       .
        .byte   $AF                             ; AD67 AF                       .
        brk                                     ; AD68 00                       .
        brk                                     ; AD69 00                       .
        brk                                     ; AD6A 00                       .
        brk                                     ; AD6B 00                       .
        brk                                     ; AD6C 00                       .
        brk                                     ; AD6D 00                       .
        brk                                     ; AD6E 00                       .
        brk                                     ; AD6F 00                       .
        brk                                     ; AD70 00                       .
        brk                                     ; AD71 00                       .
        brk                                     ; AD72 00                       .
        brk                                     ; AD73 00                       .
        brk                                     ; AD74 00                       .
        brk                                     ; AD75 00                       .
        brk                                     ; AD76 00                       .
        brk                                     ; AD77 00                       .
        brk                                     ; AD78 00                       .
        brk                                     ; AD79 00                       .
        brk                                     ; AD7A 00                       .
        brk                                     ; AD7B 00                       .
        brk                                     ; AD7C 00                       .
        brk                                     ; AD7D 00                       .
        brk                                     ; AD7E 00                       .
        brk                                     ; AD7F 00                       .
        cpy     #$C2                            ; AD80 C0 C2                    ..
        cpy     $C6                             ; AD82 C4 C6                    ..
        .byte   $44                             ; AD84 44                       D
        eor     $45                             ; AD85 45 45                    EE
        brk                                     ; AD87 00                       .
        cpx     #$01                            ; AD88 E0 01                    ..
        ora     ($E6,x)                         ; AD8A 01 E6                    ..
        .byte   $64                             ; AD8C 64                       d
        adc     $65                             ; AD8D 65 65                    ee
        brk                                     ; AD8F 00                       .
        ldy     #$A2                            ; AD90 A0 A2                    ..
        ldy     $A6                             ; AD92 A4 A6                    ..
        jsr     L3022                           ; AD94 20 22 30                  "0
        .byte   $32                             ; AD97 32                       2
        plp                                     ; AD98 28                       (
        rol     a                               ; AD99 2A                       *
        ldx     #$C9                            ; AD9A A2 C9                    ..
        bmi     LADD0                           ; AD9C 30 32                    02
        bit     $34                             ; AD9E 24 34                    $4
        bcs     LAD54                           ; ADA0 B0 B2                    ..
        ldy     $B6,x                           ; ADA2 B4 B6                    ..
        bmi     LADB7                           ; ADA4 30 11                    0.
        brk                                     ; ADA6 00                       .
        ora     ($48),y                         ; ADA7 11 48                    .H
        sbc     #$4B                            ; ADA9 E9 4B                    .K
        .byte   $49                             ; ADAB 49                       I
LADAC:  pha                                     ; ADAC 48                       H
        eor     #$4B                            ; ADAD 49 4B                    IK
LADAF:  .byte   $4B                             ; ADAF 4B                       K
        lsr     $847D                           ; ADB0 4E 7D 84                 N}.
        stx     $84                             ; ADB3 86 84                    ..
        stx     $6A                             ; ADB5 86 6A                    .j
LADB7:  brk                                     ; ADB7 00                       .
        .byte   $5E                             ; ADB8 5E                       ^
LADB9:  adc     $9596,x                         ; ADB9 7D 96 95                 }..
        adc     $7A00,x                         ; ADBC 7D 00 7A                 }.z
        brk                                     ; ADBF 00                       .
        .byte   $1A                             ; ADC0 1A                       .
        brk                                     ; ADC1 00                       .
        .byte   $1A                             ; ADC2 1A                       .
        .byte   $1A                             ; ADC3 1A                       .
        brk                                     ; ADC4 00                       .
        brk                                     ; ADC5 00                       .
        brk                                     ; ADC6 00                       .
        brk                                     ; ADC7 00                       .
        .byte   $1A                             ; ADC8 1A                       .
        brk                                     ; ADC9 00                       .
        brk                                     ; ADCA 00                       .
        brk                                     ; ADCB 00                       .
        cpy     $28CE                           ; ADCC CC CE 28                 ..(
        rol     a                               ; ADCF 2A                       *
LADD0:  sbc     #$EE                            ; ADD0 E9 EE                    ..
        .byte   $EF                             ; ADD2 EF                       .
        brk                                     ; ADD3 00                       .
        plp                                     ; ADD4 28                       (
        dec     $2A1A                           ; ADD5 CE 1A 2A                 ..*
        sbc     #$EB                            ; ADD8 E9 EB                    ..
        .byte   $CB                             ; ADDA CB                       .
        ora     ($A8),y                         ; ADDB 11 A8                    ..
        lda     #$AA                            ; ADDD A9 AA                    ..
        lda     #$40                            ; ADDF A9 40                    .@
        .byte   $42                             ; ADE1 42                       B
        brk                                     ; ADE2 00                       .
        dey                                     ; ADE3 88                       .
        txa                                     ; ADE4 8A                       .
        .byte   $89                             ; ADE5 89                       .
        brk                                     ; ADE6 00                       .
        lda     #$60                            ; ADE7 A9 60                    .`
        .byte   $62                             ; ADE9 62                       b
        eor     #$80                            ; ADEA 49 80                    I.
        sta     (L0000,x)                       ; ADEC 81 00                    ..
        sta     ($AB,x)                         ; ADEE 81 AB                    ..
        pla                                     ; ADF0 68                       h
        adc     #$78                            ; ADF1 69 78                    ix
        ora     ($11),y                         ; ADF3 11 11                    ..
        .byte   $27                             ; ADF5 27                       '
        bmi     LADF8                           ; ADF6 30 00                    0.
LADF8:  sei                                     ; ADF8 78                       x
        ora     ($69),y                         ; ADF9 11 69                    .i
        ora     ($11),y                         ; ADFB 11 11                    ..
        bmi     LAE2F                           ; ADFD 30 30                    00
        brk                                     ; ADFF 00                       .
        brk                                     ; AE00 00                       .
        ora     ($11,x)                         ; AE01 01 11                    ..
        bpl     LAE0C                           ; AE03 10 07                    ..
        .byte   $03                             ; AE05 03                       .
        ora     $05                             ; AE06 05 05                    ..
        ora     $9F0F                           ; AE08 0D 0F 9F                 ...
        brk                                     ; AE0B 00                       .
LAE0C:  .byte   $27                             ; AE0C 27                       '
        brk                                     ; AE0D 00                       .
        stx     $27                             ; AE0E 86 27                    .'
        and     $092F                           ; AE10 2D 2F 09                 -/.
        php                                     ; AE13 08                       .
        brk                                     ; AE14 00                       .
        .byte   $93                             ; AE15 93                       .
        eor     ($43,x)                         ; AE16 41 43                    AC
        .byte   $D3                             ; AE18 D3                       .
        sbc     #$00                            ; AE19 E9 00                    ..
        brk                                     ; AE1B 00                       .
        brk                                     ; AE1C 00                       .
        ora     $6361,y                         ; AE1D 19 61 63                 .ac
        sta     ($83,x)                         ; AE20 81 83                    ..
        brk                                     ; AE22 00                       .
        brk                                     ; AE23 00                       .
        sbc     $87EF                           ; AE24 ED EF 87                 ...
        .byte   $89                             ; AE27 89                       .
        ora     ($11),y                         ; AE28 11 11                    ..
        .byte   $8E,$A7,$A5                     ; AE2A 8E A7 A5
        brk                                     ; AE2D 00                       .
        .byte   $CD                             ; AE2E CD                       .
LAE2F:  .byte   $CF                             ; AE2F CF                       .
        cmp     ($AB,x)                         ; AE30 C1 AB                    ..
        cmp     $C7                             ; AE32 C5 C7                    ..
        cmp     #$00                            ; AE34 C9 00                    ..
        .byte   $AF                             ; AE36 AF                       .
        ora     ($E1),y                         ; AE37 11 E1                    ..
        ora     ($E5),y                         ; AE39 11 E5                    ..
        .byte   $E7                             ; AE3B E7                       .
        lda     LA200                           ; AE3C AD 00 A2                 ...
        ldy     $5D                             ; AE3F A4 5D                    .]
        eor     $5D26,x                         ; AE41 5D 26 5D                 ]&]
        .byte   $33                             ; AE44 33                       3
        ora     ($11),y                         ; AE45 11 11                    ..
        .byte   $33                             ; AE47 33                       3
        .byte   $89                             ; AE48 89                       .
        brk                                     ; AE49 00                       .
        .byte   $8B                             ; AE4A 8B                       .
        brk                                     ; AE4B 00                       .
        lda     a:$84                           ; AE4C AD 84 00                 ...
        txs                                     ; AE4F 9A                       .
        lda     #$99                            ; AE50 A9 99                    ..
        txs                                     ; AE52 9A                       .
        .byte   $8B                             ; AE53 8B                       .
        brk                                     ; AE54 00                       .
        .byte   $83                             ; AE55 83                       .
        brk                                     ; AE56 00                       .
        brk                                     ; AE57 00                       .
        stx     $B9                             ; AE58 86 B9                    ..
        eor     a:$9A,x                         ; AE5A 5D 9A 00                 ]..
        brk                                     ; AE5D 00                       .
        sty     $8DE8                           ; AE5E 8C E8 8D                 ...
        .byte   $AF                             ; AE61 AF                       .
        brk                                     ; AE62 00                       .
        brk                                     ; AE63 00                       .
        brk                                     ; AE64 00                       .
        brk                                     ; AE65 00                       .
        ldx     a:$E8                           ; AE66 AE E8 00                 ...
        brk                                     ; AE69 00                       .
        brk                                     ; AE6A 00                       .
        brk                                     ; AE6B 00                       .
        brk                                     ; AE6C 00                       .
        brk                                     ; AE6D 00                       .
        brk                                     ; AE6E 00                       .
        brk                                     ; AE6F 00                       .
        brk                                     ; AE70 00                       .
        brk                                     ; AE71 00                       .
        brk                                     ; AE72 00                       .
        brk                                     ; AE73 00                       .
        brk                                     ; AE74 00                       .
        brk                                     ; AE75 00                       .
        brk                                     ; AE76 00                       .
        brk                                     ; AE77 00                       .
        brk                                     ; AE78 00                       .
        brk                                     ; AE79 00                       .
        brk                                     ; AE7A 00                       .
        brk                                     ; AE7B 00                       .
        brk                                     ; AE7C 00                       .
        brk                                     ; AE7D 00                       .
        brk                                     ; AE7E 00                       .
        brk                                     ; AE7F 00                       .
        cmp     ($C3,x)                         ; AE80 C1 C3                    ..
        cmp     $C7                             ; AE82 C5 C7                    ..
        eor     $45                             ; AE84 45 45                    EE
        .byte   $47                             ; AE86 47                       G
        brk                                     ; AE87 00                       .
        sbc     ($E3,x)                         ; AE88 E1 E3                    ..
        sbc     $E7                             ; AE8A E5 E7                    ..
LAE8C:  adc     $65                             ; AE8C 65 65                    ee
        .byte   $67                             ; AE8E 67                       g
        brk                                     ; AE8F 00                       .
        lda     ($A3,x)                         ; AE90 A1 A3                    ..
        lda     $A7                             ; AE92 A5 A7                    ..
        and     ($23,x)                         ; AE94 21 23                    !#
        and     ($33),y                         ; AE96 31 33                    13
        and     #$2B                            ; AE98 29 2B                    )+
        iny                                     ; AE9A C8                       .
        lda     $31                             ; AE9B A5 31                    .1
        .byte   $33                             ; AE9D 33                       3
        and     $35                             ; AE9E 25 35                    %5
        lda     ($B3),y                         ; AEA0 B1 B3                    ..
        lda     $B7,x                           ; AEA2 B5 B7                    ..
        ora     ($11),y                         ; AEA4 11 11                    ..
        brk                                     ; AEA6 00                       .
        .byte   $33                             ; AEA7 33                       3
        .byte   $4B                             ; AEA8 4B                       K
        brk                                     ; AEA9 00                       .
        jmp     L494C                           ; AEAA 4C 4C 49                 LLI

; ----------------------------------------------------------------------------
LAEAD:  eor     #$4A                            ; AEAD 49 4A                    IJ
        .byte   $4B                             ; AEAF 4B                       K
        .byte   $4F                             ; AEB0 4F                       O
        jmp     (L8785)                         ; AEB1 6C 85 87                 l..

; ----------------------------------------------------------------------------
        sta     $87                             ; AEB4 85 87                    ..
        .byte   $33                             ; AEB6 33                       3
        brk                                     ; AEB7 00                       .
        .byte   $6F                             ; AEB8 6F                       o
        .byte   $7C                             ; AEB9 7C                       |
        .byte   $97                             ; AEBA 97                       .
        sty     $7C,x                           ; AEBB 94 7C                    .|
        brk                                     ; AEBD 00                       .
        .byte   $33                             ; AEBE 33                       3
        brk                                     ; AEBF 00                       .
        .byte   $1A                             ; AEC0 1A                       .
        brk                                     ; AEC1 00                       .
        .byte   $1A                             ; AEC2 1A                       .
        brk                                     ; AEC3 00                       .
LAEC4:  .byte   $1A                             ; AEC4 1A                       .
        brk                                     ; AEC5 00                       .
        brk                                     ; AEC6 00                       .
        .byte   $1A                             ; AEC7 1A                       .
        brk                                     ; AEC8 00                       .
        brk                                     ; AEC9 00                       .
        brk                                     ; AECA 00                       .
        brk                                     ; AECB 00                       .
        cmp     $29CF                           ; AECC CD CF 29                 ..)
        .byte   $2B                             ; AECF 2B                       +
        sbc     $ECEE                           ; AED0 ED EE EC                 ...
        .byte   $1A                             ; AED3 1A                       .
        cmp     $1ACF                           ; AED4 CD CF 1A                 ...
        cmp     $EBEA                           ; AED7 CD EA EB                 ...
        cpx     LA911                           ; AEDA EC 11 A9                 ...
        lda     #$AB                            ; AEDD A9 AB                    ..
        ldy     $4341                           ; AEDF AC 41 43                 .AC
        brk                                     ; AEE2 00                       .
        .byte   $89                             ; AEE3 89                       .
        txa                                     ; AEE4 8A                       .
        .byte   $8B                             ; AEE5 8B                       .
        brk                                     ; AEE6 00                       .
        tax                                     ; AEE7 AA                       .
        adc     ($63,x)                         ; AEE8 61 63                    ac
        brk                                     ; AEEA 00                       .
        sta     ($81,x)                         ; AEEB 81 81                    ..
        brk                                     ; AEED 00                       .
        .byte   $82                             ; AEEE 82                       .
        lda     #$69                            ; AEEF A9 69                    .i
        ror     a                               ; AEF1 6A                       j
        ora     ($7A),y                         ; AEF2 11 7A                    .z
        rol     $11                             ; AEF4 26 11                    &.
        brk                                     ; AEF6 00                       .
        .byte   $33                             ; AEF7 33                       3
        ora     ($7A),y                         ; AEF8 11 7A                    .z
        adc     #$11                            ; AEFA 69 11                    i.
        .byte   $33                             ; AEFC 33                       3
        ora     (L0000),y                       ; AEFD 11 00                    ..
        .byte   $33                             ; AEFF 33                       3
        brk                                     ; AF00 00                       .
        ora     ($11,x)                         ; AF01 01 11                    ..
        bpl     LAF1B                           ; AF03 10 16                    ..
        .byte   $12                             ; AF05 12                       .
        .byte   $14                             ; AF06 14                       .
        .byte   $14                             ; AF07 14                       .
        .byte   $1C                             ; AF08 1C                       .
        asl     $0A8F,x                         ; AF09 1E 8F 0A                 ...
        rol     $0B,x                           ; AF0C 36 0B                    6.
        lda     $36,x                           ; AF0E B5 36                    .6
        .byte   $3C                             ; AF10 3C                       <
        rol     a:L0008,x                       ; AF11 3E 08 00                 >..
        brk                                     ; AF14 00                       .
        .byte   $C2                             ; AF15 C2                       .
        bvc     LAF6A                           ; AF16 50 52                    PR
        .byte   $E3                             ; AF18 E3                       .
        sed                                     ; AF19 F8                       .
        brk                                     ; AF1A 00                       .
LAF1B:  brk                                     ; AF1B 00                       .
        brk                                     ; AF1C 00                       .
        brk                                     ; AF1D 00                       .
        bvs     LAF92                           ; AF1E 70 72                    pr
        bcc     LAF33                           ; AF20 90 11                    ..
        sty     $96,x                           ; AF22 94 96                    ..
        .byte   $FC                             ; AF24 FC                       .
        inc     $9887,x                         ; AF25 FE 87 98                 ...
        bcs     LAEC4                           ; AF28 B0 9A                    ..
        ora     ($11),y                         ; AF2A 11 11                    ..
        cpy     L0000                           ; AF2C C4 00                    ..
        .byte   $DC                             ; AF2E DC                       .
        dec     a:L0000,x                       ; AF2F DE 00 00                 ...
        .byte   $D4                             ; AF32 D4                       .
LAF33:  dec     $11,x                           ; AF33 D6 11                    ..
        .byte   $DA                             ; AF35 DA                       .
        .byte   $BF                             ; AF36 BF                       .
        lda     $F200,x                         ; AF37 BD 00 F2                 ...
        .byte   $F4                             ; AF3A F4                       .
        inc     L0000,x                         ; AF3B F6 00                    ..
        .byte   $FA                             ; AF3D FA                       .
        lda     ($B3),y                         ; AF3E B1 B3                    ..
        bmi     LAF53                           ; AF40 30 11                    0.
        ora     ($30),y                         ; AF42 11 30                    .0
LAF44:  ora     ($1B),y                         ; AF44 11 1B                    ..
        and     $9839,y                         ; AF46 39 39 98                 99.
        dey                                     ; AF49 88                       .
        txs                                     ; AF4A 9A                       .
        .byte   $8B                             ; AF4B 8B                       .
        ldy     a:$93,x                         ; AF4C BC 93 00                 ...
        brk                                     ; AF4F 00                       .
        brk                                     ; AF50 00                       .
        tay                                     ; AF51 A8                       .
        brk                                     ; AF52 00                       .
LAF53:  txs                                     ; AF53 9A                       .
LAF54:  .byte   $8B                             ; AF54 8B                       .
        sty     L0000,x                         ; AF55 94 00                    ..
        brk                                     ; AF57 00                       .
        sta     $94,x                           ; AF58 95 94                    ..
        .byte   $37                             ; AF5A 37                       7
        brk                                     ; AF5B 00                       .
        brk                                     ; AF5C 00                       .
        brk                                     ; AF5D 00                       .
        sed                                     ; AF5E F8                       .
        .byte   $9E                             ; AF5F 9E                       .
        .byte   $9C                             ; AF60 9C                       .
        ldx     $9CBE,y                         ; AF61 BE BE 9C                 ...
        brk                                     ; AF64 00                       .
        brk                                     ; AF65 00                       .
        sed                                     ; AF66 F8                       .
        .byte   $BF                             ; AF67 BF                       .
        brk                                     ; AF68 00                       .
        brk                                     ; AF69 00                       .
LAF6A:  brk                                     ; AF6A 00                       .
        brk                                     ; AF6B 00                       .
        brk                                     ; AF6C 00                       .
        brk                                     ; AF6D 00                       .
        brk                                     ; AF6E 00                       .
        brk                                     ; AF6F 00                       .
        brk                                     ; AF70 00                       .
        brk                                     ; AF71 00                       .
        brk                                     ; AF72 00                       .
        brk                                     ; AF73 00                       .
        brk                                     ; AF74 00                       .
        brk                                     ; AF75 00                       .
        brk                                     ; AF76 00                       .
        brk                                     ; AF77 00                       .
        brk                                     ; AF78 00                       .
        brk                                     ; AF79 00                       .
        brk                                     ; AF7A 00                       .
        brk                                     ; AF7B 00                       .
LAF7C:  brk                                     ; AF7C 00                       .
        brk                                     ; AF7D 00                       .
        brk                                     ; AF7E 00                       .
        brk                                     ; AF7F 00                       .
        bne     LAF54                           ; AF80 D0 D2                    ..
        .byte   $D4                             ; AF82 D4                       .
        dec     $54,x                           ; AF83 D6 54                    .T
        eor     $55,x                           ; AF85 55 55                    UU
        brk                                     ; AF87 00                       .
        beq     LAF7C                           ; AF88 F0 F2                    ..
        .byte   $F4                             ; AF8A F4                       .
        inc     $74,x                           ; AF8B F6 74                    .t
        adc     $75,x                           ; AF8D 75 75                    uu
        brk                                     ; AF8F 00                       .
        bcs     LAF44                           ; AF90 B0 B2                    ..
LAF92:  ldy     $B6,x                           ; AF92 B4 B6                    ..
        bmi     LAFC8                           ; AF94 30 32                    02
        bit     $34                             ; AF96 24 34                    $4
        sec                                     ; AF98 38                       8
        .byte   $3A                             ; AF99 3A                       :
        .byte   $B2                             ; AF9A B2                       .
        ldy     $30,x                           ; AF9B B4 30                    .0
        .byte   $32                             ; AF9D 32                       2
        bmi     LAFD2                           ; AF9E 30 32                    02
        bcs     LAF54                           ; AFA0 B0 B2                    ..
        ldy     $B6,x                           ; AFA2 B4 B6                    ..
        bmi     LAFB7                           ; AFA4 30 11                    0.
        brk                                     ; AFA6 00                       .
        ora     ($58),y                         ; AFA7 11 58                    .X
        sbc     #$5B                            ; AFA9 E9 5B                    .[
        eor     $5958,y                         ; AFAB 59 58 59                 YXY
LAFAE:  .byte   $5B                             ; AFAE 5B                       [
        .byte   $5B                             ; AFAF 5B                       [
        lsr     $947D,x                         ; AFB0 5E 7D 94                 ^}.
        stx     $98,y                           ; AFB3 96 98                    ..
        txs                                     ; AFB5 9A                       .
        .byte   $7A                             ; AFB6 7A                       z
LAFB7:  brk                                     ; AFB7 00                       .
        ror     $987D,x                         ; AFB8 7E 7D 98                 ~}.
        txs                                     ; AFBB 9A                       .
        adc     $7900,x                         ; AFBC 7D 00 79                 }.y
        brk                                     ; AFBF 00                       .
        .byte   $1A                             ; AFC0 1A                       .
        .byte   $1A                             ; AFC1 1A                       .
        brk                                     ; AFC2 00                       .
        .byte   $1A                             ; AFC3 1A                       .
        brk                                     ; AFC4 00                       .
        brk                                     ; AFC5 00                       .
        .byte   $1A                             ; AFC6 1A                       .
        .byte   $1A                             ; AFC7 1A                       .
LAFC8:  .byte   $1A                             ; AFC8 1A                       .
        cmp     $D8D8,y                         ; AFC9 D9 D8 D8                 ...
        .byte   $DC                             ; AFCC DC                       .
        dec     $DEDC,x                         ; AFCD DE DC DE                 ...
        sbc     #$FE                            ; AFD0 E9 FE                    ..
LAFD2:  .byte   $FF                             ; AFD2 FF                       .
        brk                                     ; AFD3 00                       .
        sec                                     ; AFD4 38                       8
        dec     $DCCA,x                         ; AFD5 DE CA DC                 ...
        sbc     $FBDB,y                         ; AFD8 F9 DB FB                 ...
        ora     ($B8),y                         ; AFDB 11 B8                    ..
        lda     LB9BA,y                         ; AFDD B9 BA B9                 ...
        bvc     LB034                           ; AFE0 50 52                    PR
        brk                                     ; AFE2 00                       .
        brk                                     ; AFE3 00                       .
        brk                                     ; AFE4 00                       .
        brk                                     ; AFE5 00                       .
        brk                                     ; AFE6 00                       .
        lda     $7270,y                         ; AFE7 B9 70 72                 .pr
        eor     $9190,y                         ; AFEA 59 90 91                 Y..
        brk                                     ; AFED 00                       .
        sta     ($BB),y                         ; AFEE 91 BB                    ..
        sei                                     ; AFF0 78                       x
        ora     ($78),y                         ; AFF1 11 78                    .x
        ora     ($11),y                         ; AFF3 11 11                    ..
        bmi     LB027                           ; AFF5 30 30                    00
        brk                                     ; AFF7 00                       .
        .byte   $6B                             ; AFF8 6B                       k
        .byte   $7B                             ; AFF9 7B                       {
        ora     ($7B),y                         ; AFFA 11 7B                    .{
        ora     ($37),y                         ; AFFC 11 37                    .7
        bmi     LB000                           ; AFFE 30 00                    0.
LB000:  brk                                     ; B000 00                       .
        ora     ($11,x)                         ; B001 01 11                    ..
        bpl     LB01C                           ; B003 10 17                    ..
        .byte   $13                             ; B005 13                       .
        ora     $15,x                           ; B006 15 15                    ..
        ora     $9F1F,x                         ; B008 1D 1F 9F                 ...
        asl     a                               ; B00B 0A                       .
        .byte   $37                             ; B00C 37                       7
        asl     a                               ; B00D 0A                       .
        ldx     $37,y                           ; B00E B6 37                    .7
        and     a:$3F,x                         ; B010 3D 3F 00                 =?.
        brk                                     ; B013 00                       .
        ora     #$C3                            ; B014 09 C3                    ..
        eor     ($53),y                         ; B016 51 53                    QS
        .byte   $F7                             ; B018 F7                       .
        sbc     L0000,y                         ; B019 F9 00 00                 ...
LB01C:  brk                                     ; B01C 00                       .
        brk                                     ; B01D 00                       .
        adc     ($73),y                         ; B01E 71 73                    qs
        sta     ($11),y                         ; B020 91 11                    ..
        sta     L0000,x                         ; B022 95 00                    ..
        sbc     $97FF,x                         ; B024 FD FF 97                 ...
LB027:  sta     $9B11,y                         ; B027 99 11 9B                 ...
        .byte   $9E                             ; B02A 9E                       .
        .byte   $B7                             ; B02B B7                       .
        brk                                     ; B02C 00                       .
        brk                                     ; B02D 00                       .
        cmp     $D1DF,x                         ; B02E DD DF D1                 ...
        brk                                     ; B031 00                       .
        cmp     $D7,x                           ; B032 D5 D7                    ..
LB034:  cmp     L0000,y                         ; B034 D9 00 00                 ...
        ldx     $F3F1,y                         ; B037 BE F1 F3                 ...
        sbc     $11,x                           ; B03A F5 11                    ..
        ldy     LB2FB,x                         ; B03C BC FB B2                 ...
        ldy     $11,x                           ; B03F B4 11                    ..
        ora     ($33),y                         ; B041 11 33                    .3
        ora     ($33),y                         ; B043 11 33                    .3
        and     $6E39,y                         ; B045 39 39 6E                 99n
        sta     $9B89,y                         ; B048 99 89 9B                 ...
        brk                                     ; B04B 00                       .
        lda     a:$94,x                         ; B04C BD 94 00                 ...
        .byte   $BB                             ; B04F BB                       .
        brk                                     ; B050 00                       .
        lda     #$00                            ; B051 A9 00                    ..
        .byte   $9B                             ; B053 9B                       .
        sta     $9300,x                         ; B054 9D 00 93                 ...
        brk                                     ; B057 00                       .
        stx     L0000,y                         ; B058 96 00                    ..
        ora     (L0000),y                       ; B05A 11 00                    ..
        brk                                     ; B05C 00                       .
        brk                                     ; B05D 00                       .
        .byte   $9C                             ; B05E 9C                       .
        sed                                     ; B05F F8                       .
        .byte   $9E                             ; B060 9E                       .
        .byte   $BF                             ; B061 BF                       .
        .byte   $BF                             ; B062 BF                       .
        .byte   $9E                             ; B063 9E                       .
        brk                                     ; B064 00                       .
        brk                                     ; B065 00                       .
        ldx     a:$F8,y                         ; B066 BE F8 00                 ...
        brk                                     ; B069 00                       .
        brk                                     ; B06A 00                       .
        brk                                     ; B06B 00                       .
        brk                                     ; B06C 00                       .
LB06D:  brk                                     ; B06D 00                       .
        brk                                     ; B06E 00                       .
        brk                                     ; B06F 00                       .
        brk                                     ; B070 00                       .
        brk                                     ; B071 00                       .
        brk                                     ; B072 00                       .
        brk                                     ; B073 00                       .
        brk                                     ; B074 00                       .
        brk                                     ; B075 00                       .
        brk                                     ; B076 00                       .
        brk                                     ; B077 00                       .
        brk                                     ; B078 00                       .
        brk                                     ; B079 00                       .
        brk                                     ; B07A 00                       .
        brk                                     ; B07B 00                       .
        brk                                     ; B07C 00                       .
        brk                                     ; B07D 00                       .
        brk                                     ; B07E 00                       .
        brk                                     ; B07F 00                       .
        cmp     ($D3),y                         ; B080 D1 D3                    ..
        cmp     $D7,x                           ; B082 D5 D7                    ..
        eor     $55,x                           ; B084 55 55                    UU
        .byte   $57                             ; B086 57                       W
        brk                                     ; B087 00                       .
        sbc     ($F3),y                         ; B088 F1 F3                    ..
        sbc     $F7,x                           ; B08A F5 F7                    ..
        adc     $75,x                           ; B08C 75 75                    uu
        .byte   $77                             ; B08E 77                       w
        brk                                     ; B08F 00                       .
        lda     ($B3),y                         ; B090 B1 B3                    ..
        lda     $B7,x                           ; B092 B5 B7                    ..
        and     ($33),y                         ; B094 31 33                    13
        and     $35                             ; B096 25 35                    %5
        brk                                     ; B098 00                       .
        .byte   $3B                             ; B099 3B                       ;
        .byte   $B3                             ; B09A B3                       .
        lda     $31,x                           ; B09B B5 31                    .1
        .byte   $33                             ; B09D 33                       3
        and     ($33),y                         ; B09E 31 33                    13
        lda     ($B3),y                         ; B0A0 B1 B3                    ..
        lda     $B7,x                           ; B0A2 B5 B7                    ..
        ora     ($11),y                         ; B0A4 11 11                    ..
        brk                                     ; B0A6 00                       .
        .byte   $33                             ; B0A7 33                       3
        .byte   $5B                             ; B0A8 5B                       [
        brk                                     ; B0A9 00                       .
        .byte   $5C                             ; B0AA 5C                       \
        .byte   $5C                             ; B0AB 5C                       \
        eor     $5A59,y                         ; B0AC 59 59 5A                 YYZ
        .byte   $5B                             ; B0AF 5B                       [
        .byte   $5F                             ; B0B0 5F                       _
        .byte   $7C                             ; B0B1 7C                       |
        sta     $97,x                           ; B0B2 95 97                    ..
        sta     $339B,y                         ; B0B4 99 9B 33                 ..3
        brk                                     ; B0B7 00                       .
        .byte   $7F                             ; B0B8 7F                       .
        jmp     (L9B99)                         ; B0B9 6C 99 9B                 l..

; ----------------------------------------------------------------------------
        .byte   $7C                             ; B0BC 7C                       |
        brk                                     ; B0BD 00                       .
        .byte   $33                             ; B0BE 33                       3
        brk                                     ; B0BF 00                       .
        .byte   $1A                             ; B0C0 1A                       .
        .byte   $1A                             ; B0C1 1A                       .
        brk                                     ; B0C2 00                       .
        brk                                     ; B0C3 00                       .
        .byte   $1A                             ; B0C4 1A                       .
        .byte   $1A                             ; B0C5 1A                       .
        brk                                     ; B0C6 00                       .
        .byte   $1A                             ; B0C7 1A                       .
        .byte   $1A                             ; B0C8 1A                       .
        cld                                     ; B0C9 D8                       .
        .byte   $DA                             ; B0CA DA                       .
        cld                                     ; B0CB D8                       .
        cmp     $DDDF,x                         ; B0CC DD DF DD                 ...
        .byte   $DF                             ; B0CF DF                       .
        sbc     $ECFE,x                         ; B0D0 FD FE EC                 ...
        dex                                     ; B0D3 CA                       .
        cmp     $CADF,x                         ; B0D4 DD DF CA                 ...
        cmp     $DBFA,x                         ; B0D7 DD FA DB                 ...
        .byte   $FC                             ; B0DA FC                       .
        ora     ($B9),y                         ; B0DB 11 B9                    ..
        lda     LBCBB,y                         ; B0DD B9 BB BC                 ...
        eor     ($53),y                         ; B0E0 51 53                    QS
        brk                                     ; B0E2 00                       .
        brk                                     ; B0E3 00                       .
        brk                                     ; B0E4 00                       .
        brk                                     ; B0E5 00                       .
        brk                                     ; B0E6 00                       .
        tsx                                     ; B0E7 BA                       .
        adc     ($73),y                         ; B0E8 71 73                    qs
        brk                                     ; B0EA 00                       .
        sta     ($91),y                         ; B0EB 91 91                    ..
        brk                                     ; B0ED 00                       .
        .byte   $92                             ; B0EE 92                       .
        .byte   $B9                             ; B0EF B9                       .
        .byte   $11                             ; B0F0 11                       .
LB0F1:  .byte   $7A                             ; B0F1 7A                       z
        ora     ($7A),y                         ; B0F2 11 7A                    .z
        .byte   $33                             ; B0F4 33                       3
        ora     (L0000),y                       ; B0F5 11 00                    ..
        .byte   $33                             ; B0F7 33                       3
        .byte   $7B                             ; B0F8 7B                       {
        adc     $7B11,y                         ; B0F9 79 11 7B                 y.{
        rol     $11,x                           ; B0FC 36 11                    6.
        brk                                     ; B0FE 00                       .
        .byte   $33                             ; B0FF 33                       3
        brk                                     ; B100 00                       .
        brk                                     ; B101 00                       .
        ora     ($01,x)                         ; B102 01 01                    ..
        brk                                     ; B104 00                       .
        .byte   $F3                             ; B105 F3                       .
        .byte   $42                             ; B106 42                       B
        .byte   $22                             ; B107 22                       "
        bpl     LB11A                           ; B108 10 10                    ..
        brk                                     ; B10A 00                       .
        ora     (L0000,x)                       ; B10B 01 00                    ..
        ora     ($03,x)                         ; B10D 01 03                    ..
        and     ($10,x)                         ; B10F 21 10                    !.
        bpl     LB116                           ; B111 10 03                    ..
        ora     ($03,x)                         ; B113 01 03                    ..
        .byte   $03                             ; B115 03                       .
LB116:  .byte   $10                             ; B116 10                       .
LB117:  .byte   $10,$03                    ; B117 10 03   (branch out of range for ca65: target has no local label)
        .byte   $03                             ; B119 03                       .
LB11A:  .byte   $02                             ; B11A 02                       .
        ora     (L0000,x)                       ; B11B 01 00                    ..
        ora     ($10,x)                         ; B11D 01 10                    ..
        bpl     LB122                           ; B11F 10 01                    ..
        .byte   $01                             ; B121 01                       .
LB122:  ora     ($01,x)                         ; B122 01 01                    ..
        ora     ($01,x)                         ; B124 01 01                    ..
        ora     ($01,x)                         ; B126 01 01                    ..
LB128:  ora     ($01,x)                         ; B128 01 01                    ..
        ora     ($01,x)                         ; B12A 01 01                    ..
        ora     ($01,x)                         ; B12C 01 01                    ..
        ora     ($01,x)                         ; B12E 01 01                    ..
        ora     ($01,x)                         ; B130 01 01                    ..
        ora     ($01,x)                         ; B132 01 01                    ..
        ora     ($01,x)                         ; B134 01 01                    ..
        ora     ($01,x)                         ; B136 01 01                    ..
        ora     ($01,x)                         ; B138 01 01                    ..
        ora     ($01,x)                         ; B13A 01 01                    ..
        ora     ($01,x)                         ; B13C 01 01                    ..
        ora     ($01,x)                         ; B13E 01 01                    ..
        bpl     LB152                           ; B140 10 10                    ..
        bpl     LB154                           ; B142 10 10                    ..
        bpl     LB156                           ; B144 10 10                    ..
        bpl     LB158                           ; B146 10 10                    ..
        ora     ($01,x)                         ; B148 01 01                    ..
        ora     ($01,x)                         ; B14A 01 01                    ..
        ora     ($01,x)                         ; B14C 01 01                    ..
        ora     ($01,x)                         ; B14E 01 01                    ..
        ora     ($01,x)                         ; B150 01 01                    ..
LB152:  ora     ($01,x)                         ; B152 01 01                    ..
LB154:  ora     ($01,x)                         ; B154 01 01                    ..
LB156:  ora     (L0000,x)                       ; B156 01 00                    ..
LB158:  ora     ($01,x)                         ; B158 01 01                    ..
        bpl     LB15C                           ; B15A 10 00                    ..
LB15C:  brk                                     ; B15C 00                       .
        brk                                     ; B15D 00                       .
        ora     ($01,x)                         ; B15E 01 01                    ..
        ora     ($01,x)                         ; B160 01 01                    ..
        ora     ($01,x)                         ; B162 01 01                    ..
        brk                                     ; B164 00                       .
        brk                                     ; B165 00                       .
        ora     ($01,x)                         ; B166 01 01                    ..
        brk                                     ; B168 00                       .
        brk                                     ; B169 00                       .
        brk                                     ; B16A 00                       .
        brk                                     ; B16B 00                       .
        brk                                     ; B16C 00                       .
        brk                                     ; B16D 00                       .
        brk                                     ; B16E 00                       .
        brk                                     ; B16F 00                       .
        brk                                     ; B170 00                       .
        brk                                     ; B171 00                       .
        brk                                     ; B172 00                       .
        brk                                     ; B173 00                       .
        brk                                     ; B174 00                       .
        brk                                     ; B175 00                       .
        brk                                     ; B176 00                       .
        brk                                     ; B177 00                       .
        brk                                     ; B178 00                       .
        brk                                     ; B179 00                       .
        brk                                     ; B17A 00                       .
        brk                                     ; B17B 00                       .
        brk                                     ; B17C 00                       .
        brk                                     ; B17D 00                       .
        brk                                     ; B17E 00                       .
        brk                                     ; B17F 00                       .
        .byte   $12                             ; B180 12                       .
        .byte   $12                             ; B181 12                       .
        .byte   $12                             ; B182 12                       .
        .byte   $12                             ; B183 12                       .
        bpl     LB196                           ; B184 10 10                    ..
        bpl     LB188                           ; B186 10 00                    ..
LB188:  .byte   $12                             ; B188 12                       .
        .byte   $12                             ; B189 12                       .
        .byte   $12                             ; B18A 12                       .
        .byte   $12                             ; B18B 12                       .
        bpl     LB19E                           ; B18C 10 10                    ..
        bpl     LB190                           ; B18E 10 00                    ..
LB190:  bpl     LB1A2                           ; B190 10 10                    ..
        bpl     LB1A4                           ; B192 10 10                    ..
        bpl     LB1A6                           ; B194 10 10                    ..
LB196:  bpl     LB1A8                           ; B196 10 10                    ..
        ora     ($01,x)                         ; B198 01 01                    ..
        bpl     LB1AC                           ; B19A 10 10                    ..
        bpl     LB1AE                           ; B19C 10 10                    ..
LB19E:  bpl     LB1B0                           ; B19E 10 10                    ..
        bpl     LB1B2                           ; B1A0 10 10                    ..
LB1A2:  bpl     LB1B4                           ; B1A2 10 10                    ..
LB1A4:  bpl     LB1B6                           ; B1A4 10 10                    ..
LB1A6:  brk                                     ; B1A6 00                       .
LB1A7:  .byte   $10                             ; B1A7 10                       .
LB1A8:  bpl     LB1AA                           ; B1A8 10 00                    ..
LB1AA:  bpl     LB1BC                           ; B1AA 10 10                    ..
LB1AC:  bpl     LB1BE                           ; B1AC 10 10                    ..
LB1AE:  bpl     LB1C0                           ; B1AE 10 10                    ..
LB1B0:  bpl     LB1C2                           ; B1B0 10 10                    ..
LB1B2:  bpl     LB1C4                           ; B1B2 10 10                    ..
LB1B4:  bpl     LB1C6                           ; B1B4 10 10                    ..
LB1B6:  bpl     LB1B8                           ; B1B6 10 00                    ..
LB1B8:  bpl     LB1CA                           ; B1B8 10 10                    ..
        bpl     LB1CC                           ; B1BA 10 10                    ..
LB1BC:  bpl     LB1BE                           ; B1BC 10 00                    ..
LB1BE:  bpl     LB1C0                           ; B1BE 10 00                    ..
LB1C0:  ora     ($01,x)                         ; B1C0 01 01                    ..
LB1C2:  ora     ($01,x)                         ; B1C2 01 01                    ..
LB1C4:  ora     ($01,x)                         ; B1C4 01 01                    ..
LB1C6:  ora     ($01,x)                         ; B1C6 01 01                    ..
        ora     ($01,x)                         ; B1C8 01 01                    ..
LB1CA:  ora     ($01,x)                         ; B1CA 01 01                    ..
LB1CC:  ora     ($01,x)                         ; B1CC 01 01                    ..
        ora     ($01,x)                         ; B1CE 01 01                    ..
        .byte   $12                             ; B1D0 12                       .
        .byte   $12                             ; B1D1 12                       .
        .byte   $12                             ; B1D2 12                       .
        ora     ($01,x)                         ; B1D3 01 01                    ..
        ora     ($01,x)                         ; B1D5 01 01                    ..
        ora     ($12,x)                         ; B1D7 01 12                    ..
        .byte   $12                             ; B1D9 12                       .
        .byte   $12                             ; B1DA 12                       .
        .byte   $02                             ; B1DB 02                       .
        bpl     LB1EE                           ; B1DC 10 10                    ..
        bpl     LB1F0                           ; B1DE 10 10                    ..
        .byte   $12                             ; B1E0 12                       .
        .byte   $12                             ; B1E1 12                       .
        bpl     LB1F4                           ; B1E2 10 10                    ..
        bpl     LB1F6                           ; B1E4 10 10                    ..
        bpl     LB1F8                           ; B1E6 10 10                    ..
        .byte   $12                             ; B1E8 12                       .
        .byte   $12                             ; B1E9 12                       .
        bpl     LB1EC                           ; B1EA 10 00                    ..
LB1EC:  brk                                     ; B1EC 00                       .
        brk                                     ; B1ED 00                       .
LB1EE:  brk                                     ; B1EE 00                       .
        .byte   $10                             ; B1EF 10                       .
LB1F0:  bpl     LB202                           ; B1F0 10 10                    ..
        bpl     LB204                           ; B1F2 10 10                    ..
LB1F4:  bpl     LB206                           ; B1F4 10 10                    ..
LB1F6:  bpl     LB208                           ; B1F6 10 10                    ..
LB1F8:  bpl     LB20A                           ; B1F8 10 10                    ..
        bpl     LB20C                           ; B1FA 10 10                    ..
        bpl     LB20E                           ; B1FC 10 10                    ..
        bpl     LB210                           ; B1FE 10 10                    ..
        .byte   $20                             ; B200 20                        
        .byte   $21                             ; B201 21                       !
LB202:  plp                                     ; B202 28                       (
        .byte   $02                             ; B203 02                       .
LB204:  .byte   $22                             ; B204 22                       "
        .byte   $23                             ; B205 23                       #
LB206:  .byte   $02                             ; B206 02                       .
        .byte   $2B                             ; B207 2B                       +
LB208:  brk                                     ; B208 00                       .
        brk                                     ; B209 00                       .
LB20A:  .byte   $2C                             ; B20A 2C                       ,
        brk                                     ; B20B 00                       .
LB20C:  brk                                     ; B20C 00                       .
        brk                                     ; B20D 00                       .
LB20E:  brk                                     ; B20E 00                       .
        brk                                     ; B20F 00                       .
LB210:  .byte   $12                             ; B210 12                       .
        .byte   $13                             ; B211 13                       .
        .byte   $1A                             ; B212 1A                       .
        .byte   $1B                             ; B213 1B                       .
        .byte   $14                             ; B214 14                       .
        brk                                     ; B215 00                       .
        brk                                     ; B216 00                       .
        ora     $0230,x                         ; B217 1D 30 02                 .0.
        sec                                     ; B21A 38                       8
        and     $3332,y                         ; B21B 39 32 33                 923
        .byte   $3A                             ; B21E 3A                       :
        .byte   $3B                             ; B21F 3B                       ;
        .byte   $34                             ; B220 34                       4
        and     $02,x                           ; B221 35 02                    5.
        and     $150E,x                         ; B223 3D 0E 15                 =..
        clc                                     ; B226 18                       .
        ora     $2726,y                         ; B227 19 26 27                 .&'
        rol     $292F                           ; B22A 2E 2F 29                 ./)
LB22D:  .byte   $02                             ; B22D 02                       .
        and     ($3C),y                         ; B22E 31 3C                    1<
        .byte   $02                             ; B230 02                       .
LB231:  rol     a                               ; B231 2A                       *
        .byte   $37                             ; B232 37                       7
        rol     $24,x                           ; B233 36 24                    6$
        and     $3E                             ; B235 25 3E                    %>
        .byte   $3F                             ; B237 3F                       ?
        brk                                     ; B238 00                       .
        brk                                     ; B239 00                       .
        tya                                     ; B23A 98                       .
        sta     $9998,y                         ; B23B 99 98 99                 ...
        tay                                     ; B23E A8                       .
        ldx     $E1E0                           ; B23F AE E0 E1                 ...
        inx                                     ; B242 E8                       .
        .byte   $E9                             ; B243 E9                       .
LB244:  .byte   $43                             ; B244 43                       C
        beq     LB244                           ; B245 F0 FD                    ..
        sed                                     ; B247 F8                       .
        sbc     ($B1),y                         ; B248 F1 B1                    ..
        .byte   $F9,$BC,$A4                     ; B24A F9 BC A4
        lda     $A4                             ; B24D A5 A4                    ..
        lda     $A5                             ; B24F A5 A5                    ..
        lda     ($A5),y                         ; B251 B1 A5                    ..
        ldy     a:$1B,x                         ; B253 BC 1B 00                 ...
        brk                                     ; B256 00                       .
        brk                                     ; B257 00                       .
        tya                                     ; B258 98                       .
        sta     LADAC,y                         ; B259 99 AC AD                 ...
        tya                                     ; B25C 98                       .
        sta     LAEAD,y                         ; B25D 99 AD AE                 ...
        .byte   $44                             ; B260 44                       D
        bcs     LB20A                           ; B261 B0 A7                    ..
        clv                                     ; B263 B8                       .
        rti                                     ; B264 40                       @

; ----------------------------------------------------------------------------
        .byte   $42                             ; B265 42                       B
        ldy     $FC                             ; B266 A4 FC                    ..
        .byte   $43                             ; B268 43                       C
        eor     ($FD,x)                         ; B269 41 FD                    A.
        lda     $A7                             ; B26B A5 A7                    ..
        lda     ($A7),y                         ; B26D B1 A7                    ..
        .byte   $BC,$A4,$A7                     ; B26F BC A4 A7
        ldy     $A7                             ; B272 A4 A7                    ..
        .byte   $13                             ; B274 13                       .
        brk                                     ; B275 00                       .
        .byte   $1B                             ; B276 1B                       .
        brk                                     ; B277 00                       .
        brk                                     ; B278 00                       .
        .byte   $12                             ; B279 12                       .
        brk                                     ; B27A 00                       .
        .byte   $1A                             ; B27B 1A                       .
        ldy     $40AD                           ; B27C AC AD 40                 ..@
        beq     LB22D                           ; B27F F0 AC                    ..
        lda     $F1F0                           ; B281 AD F0 F1                 ...
        ldx     $F1AB                           ; B284 AE AB F1                 ...
        bcs     LB231                           ; B287 B0 A8                    ..
        lda     $4440                           ; B289 AD 40 44                 .@D
        tay                                     ; B28C A8                       .
        tax                                     ; B28D AA                       .
        rti                                     ; B28E 40                       @

; ----------------------------------------------------------------------------
        .byte   $44                             ; B28F 44                       D
        ldy     $F2                             ; B290 A4 F2                    ..
        ldy     $F2                             ; B292 A4 F2                    ..
        .byte   $F2                             ; B294 F2                       .
        .byte   $F3                             ; B295 F3                       .
        .byte   $F2                             ; B296 F2                       .
        .byte   $F3                             ; B297 F3                       .
        .byte   $F3                             ; B298 F3                       .
        clv                                     ; B299 B8                       .
        .byte   $F3                             ; B29A F3                       .
        lda     ($F3),y                         ; B29B B1 F3                    ..
        lda     ($F3),y                         ; B29D B1 F3                    ..
        ldy     LBCF3,x                         ; B29F BC F3 BC                 ...
        .byte   $F3                             ; B2A2 F3                       .
        lda     ($45),y                         ; B2A3 B1 45                    .E
        sed                                     ; B2A5 F8                       .
        lda     $F8AE                           ; B2A6 AD AE F8                 ...
        sbc     LADAF,y                         ; B2A9 F9 AF AD                 ...
        sbc     LADB9,y                         ; B2AC F9 B9 AD                 ...
        ldx     $4745                           ; B2AF AE 45 47                 .EG
        .byte   $AF                             ; B2B2 AF                       .
        lda     $4745                           ; B2B3 AD 45 47                 .EG
        ldy     $98AA                           ; B2B6 AC AA 98                 ...
        sta     LAFAE,y                         ; B2B9 99 AE AF                 ...
        ldy     $F4                             ; B2BC A4 F4                    ..
        ldy     $FC                             ; B2BE A4 FC                    ..
        asl     $17,x                           ; B2C0 16 17                    ..
        asl     $081F,x                         ; B2C2 1E 1F 08                 ...
        ora     #$10                            ; B2C5 09 10                    ..
        ora     ($14),y                         ; B2C7 11 14                    ..
        brk                                     ; B2C9 00                       .
        .byte   $1B                             ; B2CA 1B                       .
        brk                                     ; B2CB 00                       .
        ora     $05                             ; B2CC 05 05                    ..
LB2CE:  brk                                     ; B2CE 00                       .
        brk                                     ; B2CF 00                       .
        sbc     ($E0,x)                         ; B2D0 E1 E0                    ..
        sbc     #$E8                            ; B2D2 E9 E8                    ..
        tay                                     ; B2D4 A8                       .
        tax                                     ; B2D5 AA                       .
        rti                                     ; B2D6 40                       @

; ----------------------------------------------------------------------------
        bcs     LB2CE                           ; B2D7 B0 F5                    ..
        clv                                     ; B2D9 B8                       .
        sbc     a:$B1,x                         ; B2DA FD B1 00                 ...
        .byte   $13                             ; B2DD 13                       .
        brk                                     ; B2DE 00                       .
        .byte   $1B                             ; B2DF 1B                       .
        .byte   $A4                             ; B2E0 A4                       .
LB2E1:  lda     ($A4),y                         ; B2E1 B1 A4                    ..
        .byte   $BC                             ; B2E3 BC                       .
        .byte   $05                             ; B2E4 05                       .
LB2E5:  brk                                     ; B2E5 00                       .
LB2E6:  brk                                     ; B2E6 00                       .
        brk                                     ; B2E7 00                       .
        brk                                     ; B2E8 00                       .
        brk                                     ; B2E9 00                       .
        brk                                     ; B2EA 00                       .
        .byte   $13                             ; B2EB 13                       .
        brk                                     ; B2EC 00                       .
        brk                                     ; B2ED 00                       .
        .byte   $13                             ; B2EE 13                       .
        brk                                     ; B2EF 00                       .
        ldy     $F8                             ; B2F0 A4 F8                    ..
        ldy     $F0                             ; B2F2 A4 F0                    ..
        sbc     $F1B8,y                         ; B2F4 F9 B8 F1                 ...
        lda     ($F9),y                         ; B2F7 B1 F9                    ..
        lda     ($F1),y                         ; B2F9 B1 F1                    ..
LB2FB:  ldy     $F043,x                         ; B2FB BC 43 F0                 .C.
        .byte   $FD                             ; B2FE FD                       .
LB2FF:  .byte   $F2                             ; B2FF F2                       .
        .byte   $F0,$F1                    ; B300 F0 F1   (branch out of range for ca65: target has no local label)
        .byte   $F2                             ; B302 F2                       .
        .byte   $F3                             ; B303 F3                       .
        ldy     $F2                             ; B304 A4 F2                    ..
        ldy     $F8                             ; B306 A4 F8                    ..
        .byte   $F2                             ; B308 F2                       .
        .byte   $F3                             ; B309 F3                       .
        sed                                     ; B30A F8                       .
        sbc     $D1D0,y                         ; B30B F9 D0 D1                 ...
        bne     LB2E1                           ; B30E D0 D1                    ..
        .byte   $D2                             ; B310 D2                       .
        bne     LB2E5                           ; B311 D0 D2                    ..
        bne     LB2E6                           ; B313 D0 D1                    ..
        cmp     ($D1),y                         ; B315 D1 D1                    ..
        cmp     ($D1),y                         ; B317 D1 D1                    ..
        .byte   $D2                             ; B319 D2                       .
        cmp     ($D2),y                         ; B31A D1 D2                    ..
        cld                                     ; B31C D8                       .
        cmp     L0000,y                         ; B31D D9 00 00                 ...
        .byte   $DA                             ; B320 DA                       .
        cld                                     ; B321 D8                       .
        bvc     LB375                           ; B322 50 51                    PQ
        .byte   $D9                             ; B324 D9                       .
        .byte   $D9                             ; B325 D9                       .
LB326:  pha                                     ; B326 48                       H
        eor     #$DA                            ; B327 49 DA                    I.
        cld                                     ; B329 D8                       .
        brk                                     ; B32A 00                       .
        brk                                     ; B32B 00                       .
        cmp     $DA,y                           ; B32C D9 DA 00                 ...
        brk                                     ; B32F 00                       .
        bvc     LB383                           ; B330 50 51                    PQ
        .byte   $1B                             ; B332 1B                       .
        brk                                     ; B333 00                       .
        pha                                     ; B334 48                       H
        eor     #$50                            ; B335 49 50                    IP
        eor     (L0000),y                       ; B337 51 00                    Q.
        .byte   $13                             ; B339 13                       .
        pha                                     ; B33A 48                       H
        eor     #$1B                            ; B33B 49 1B                    I.
        brk                                     ; B33D 00                       .
        .byte   $13                             ; B33E 13                       .
        brk                                     ; B33F 00                       .
        brk                                     ; B340 00                       .
        lsr     L0000,x                         ; B341 56 00                    V.
        eor     a:$59                           ; B343 4D 59 00                 MY.
        lsr     $9800                           ; B346 4E 00 98                 N..
        sta     LABAE,y                         ; B349 99 AE AB                 ...
        lsr     $55,x                           ; B34C 56 55                    VU
        cli                                     ; B34E 58                       X
        sta     LB0F1,y                         ; B34F 99 F1 B0                 ...
        .byte   $F3                             ; B352 F3                       .
        clv                                     ; B353 B8                       .
        rti                                     ; B354 40                       @

; ----------------------------------------------------------------------------
        eor     ($A4,x)                         ; B355 41 A4                    A.
        lda     L0040                           ; B357 A5 40                    .@
        beq     LB2FF                           ; B359 F0 A4                    ..
        sed                                     ; B35B F8                       .
        sbc     ($B0),y                         ; B35C F1 B0                    ..
        sbc     $F3B8,y                         ; B35E F9 B8 F3                 ...
        lda     ($F9),y                         ; B361 B1 F9                    ..
        ldy     $F0A4,x                         ; B363 BC A4 F0                 ...
LB366:  ldy     $F2                             ; B366 A4 F2                    ..
        sbc     ($B1),y                         ; B368 F1 B1                    ..
        .byte   $F3                             ; B36A F3                       .
        .byte   $BC,$A4,$A7                     ; B26F BC A4 A7
        beq     LB326                           ; B36E F0 B6                    ..
        .byte   $F3                             ; B370 F3                       .
        bcs     LB366                           ; B371 B0 F3                    ..
        clv                                     ; B373 B8                       .
        .byte   $45                             ; B374 45                       E
LB375:  lsr     $AD                             ; B375 46 AD                    F.
        ldx     $F845                           ; B377 AE 45 F8                 .E.
        .byte   $AF                             ; B37A AF                       .
        lda     LBCF9                           ; B37B AD F9 BC                 ...
        lda     $F8AE                           ; B37E AD AE F8                 ...
        .byte   $BE                             ; B381 BE                       .
        .byte   $AF                             ; B382 AF                       .
LB383:  lda     a:L0000                         ; B383 AD 00 00                 ...
        brk                                     ; B386 00                       .
        lsr     $4D,x                           ; B387 56 4D                    VM
        lsr     a:$55                           ; B389 4E 55 00                 NU.
        brk                                     ; B38C 00                       .
        eor     $5556                           ; B38D 4D 56 55                 MVU
        lsr     a:L0000                         ; B390 4E 00 00                 N..
        brk                                     ; B393 00                       .
        sbc     $F2,x                           ; B394 F5 F2                    ..
        sbc     a:$F2,x                         ; B396 FD F2 00                 ...
        brk                                     ; B399 00                       .
        ora     $05                             ; B39A 05 05                    ..
        .byte   $53                             ; B39C 53                       S
        .byte   $4B                             ; B39D 4B                       K
        .byte   $52                             ; B39E 52                       R
        .byte   $53                             ; B39F 53                       S
        .byte   $52                             ; B3A0 52                       R
        .byte   $53                             ; B3A1 53                       S
        brk                                     ; B3A2 00                       .
        .byte   $52                             ; B3A3 52                       R
        .byte   $4B                             ; B3A4 4B                       K
        brk                                     ; B3A5 00                       .
        .byte   $53                             ; B3A6 53                       S
        .byte   $54                             ; B3A7 54                       T
        bvc     LB3FB                           ; B3A8 50 51                    PQ
        .byte   $1A                             ; B3AA 1A                       .
        .byte   $1B                             ; B3AB 1B                       .
        .byte   $4F                             ; B3AC 4F                       O
        jmp     L1B4B                           ; B3AD 4C 4B 1B                 LK.

; ----------------------------------------------------------------------------
        brk                                     ; B3B0 00                       .
        brk                                     ; B3B1 00                       .
        .byte   $1B                             ; B3B2 1B                       .
        brk                                     ; B3B3 00                       .
        cmp     #$CA                            ; B3B4 C9 CA                    ..
        cpy     $C0                             ; B3B6 C4 C0                    ..
        ldy     $B8                             ; B3B8 A4 B8                    ..
        ldy     $B1                             ; B3BA A4 B1                    ..
        cpy     $C0                             ; B3BC C4 C0                    ..
        cpy     $C0                             ; B3BE C4 C0                    ..
        cmp     ($C1,x)                         ; B3C0 C1 C1                    ..
        cpy     #$C0                            ; B3C2 C0 C0                    ..
        .byte   $62                             ; B3C4 62                       b
        .byte   $63                             ; B3C5 63                       c
        rts                                     ; B3C6 60                       `

; ----------------------------------------------------------------------------
        adc     ($45,x)                         ; B3C7 61 45                    aE
        .byte   $47                             ; B3C9 47                       G
        .byte   $8C,$8E,$A4                     ; B3CA 8C 8E A4                 ...
        .byte   $A7                             ; B3CD A7                       .
        eor     $47                             ; B3CE 45 47                    EG
        ldy     $F2                             ; B3D0 A4 F2                    ..
        eor     $F8                             ; B3D2 45 F8                    E.
        cpy     $C0                             ; B3D4 C4 C0                    ..
        .byte   $D4                             ; B3D6 D4                       .
        .byte   $CD                             ; B3D7 CD                       .
LB3D8:  cpy     #$C0                            ; B3D8 C0 C0                    ..
LB3DA:  cpy     $61CD                           ; B3DA CC CD 61                 ..a
        rts                                     ; B3DD 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; B3DE 60                       `

; ----------------------------------------------------------------------------
        .byte   $61                             ; B3DF 61                       a
LB3E0:  cmp     ($C1,x)                         ; B3E0 C1 C1                    ..
        cpy     $8CCD                           ; B3E2 CC CD 8C                 ...
        stx     $CFCE                           ; B3E5 8E CE CF                 ...
        sty     $CE8D                           ; B3E8 8C 8D CE                 ...
        .byte   $CF                             ; B3EB CF                       .
        ldy     $BC                             ; B3EC A4 BC                    ..
        ldy     $BC                             ; B3EE A4 BC                    ..
        bcc     LB383                           ; B3F0 90 91                    ..
        .byte   $80                             ; B3F2 80                       .
        sta     ($92,x)                         ; B3F3 81 92                    ..
        .byte   $93                             ; B3F5 93                       .
        .byte   $82                             ; B3F6 82                       .
        .byte   $83                             ; B3F7 83                       .
        dey                                     ; B3F8 88                       .
        .byte   $89                             ; B3F9 89                       .
        .byte   $90                             ; B3FA 90                       .
LB3FB:  sta     ($8A),y                         ; B3FB 91 8A                    ..
        .byte   $8B                             ; B3FD 8B                       .
        .byte   $92                             ; B3FE 92                       .
        .byte   $93                             ; B3FF 93                       .
        .byte   $F3                             ; B400 F3                       .
        .byte   $A7                             ; B401 A7                       .
        .byte   $F3                             ; B402 F3                       .
        .byte   $A7                             ; B403 A7                       .
        bne     LB3D8                           ; B404 D0 D2                    ..
        bne     LB3DA                           ; B406 D0 D2                    ..
        cld                                     ; B408 D8                       .
        .byte   $DA                             ; B409 DA                       .
        ora     $05                             ; B40A 05 05                    ..
        bne     LB3E0                           ; B40C D0 D2                    ..
        cld                                     ; B40E D8                       .
        .byte   $DA                             ; B40F DA                       .
        cmp     $C1                             ; B410 C5 C1                    ..
        cpy     $C0                             ; B412 C4 C0                    ..
        .byte   $F3                             ; B414 F3                       .
        .byte   $A7                             ; B415 A7                       .
        sbc     $0547,y                         ; B416 F9 47 05                 .G.
        ora     $C5                             ; B419 05 C5                    ..
        cmp     ($C4,x)                         ; B41B C1 C4                    ..
        cpy     #$C7                            ; B41D C0 C7                    ..
        cpy     #$8C                            ; B41F C0 8C                    ..
        sta     $0505                           ; B421 8D 05 05                 ...
        sta     $058E                           ; B424 8D 8E 05                 ...
        ora     $45                             ; B427 05 45                    .E
        sed                                     ; B429 F8                       .
        sty     $F98D                           ; B42A 8C 8D F9                 ...
        .byte   $47                             ; B42D 47                       G
        sta     $C08E                           ; B42E 8D 8E C0                 ...
        cpy     #$C0                            ; B431 C0 C0                    ..
        cpy     #$05                            ; B433 C0 05                    ..
        ora     $C1                             ; B435 05 C1                    ..
LB437:  cmp     ($C0,x)                         ; B437 C1 C0                    ..
        .byte   $C0                             ; B439 C0                       .
LB43A:  .byte   $94                             ; B43A 94                       .
LB43B:  sta     $C0,x                           ; B43B 95 C0                    ..
        cpy     #$C4                            ; B43D C0 C4                    ..
        cpy     #$8D                            ; B43F C0 8D                    ..
        sta     $CFCE                           ; B441 8D CE CF                 ...
        sta     $CE8E                           ; B444 8D 8E CE                 ...
        .byte   $CF                             ; B447 CF                       .
        cpy     $C0                             ; B448 C4 C0                    ..
        .byte   $D7                             ; B44A D7                       .
        cmp     $9C,x                           ; B44B D5 9C                    ..
        sta     $9F9E,x                         ; B44D 9D 9E 9F                 ...
        cpy     $90CD                           ; B450 CC CD 90                 ...
        sta     ($CC),y                         ; B453 91 CC                    ..
        cmp     $9392                           ; B455 CD 92 93                 ...
        .byte   $D3                             ; B458 D3                       .
        dec     $05,x                           ; B459 D6 05                    ..
        ora     $A0                             ; B45B 05 A0                    ..
        lda     (L0080,x)                       ; B45D A1 80                    ..
        sta     ($A2,x)                         ; B45F 81 A2                    ..
        .byte   $A3                             ; B461 A3                       .
        .byte   $82                             ; B462 82                       .
        .byte   $83                             ; B463 83                       .
        sty     $95,x                           ; B464 94 95                    ..
        .byte   $9E                             ; B466 9E                       .
        .byte   $9F                             ; B467 9F                       .
        bne     LB43B                           ; B468 D0 D1                    ..
        cld                                     ; B46A D8                       .
        cmp     $D2D1,y                         ; B46B D9 D1 D2                 ...
        .byte   $D9,$DA,$A4                     ; B46E D9 DA A4
        beq     LB4B8                           ; B471 F0 45                    .E
        sed                                     ; B473 F8                       .
        .byte   $FA                             ; B474 FA                       .
LB475:  .byte   $FA                             ; B475 FA                       .
        .byte   $FB                             ; B476 FB                       .
        .byte   $FB                             ; B477 FB                       .
        ldy     $A5                             ; B478 A4 A5                    ..
        eor     $46                             ; B47A 45 46                    EF
        cpy     $84CD                           ; B47C CC CD 84                 ...
        sta     $C0                             ; B47F 85 C0                    ..
        cpy     #$90                            ; B481 C0 90                    ..
        txs                                     ; B483 9A                       .
        cpy     #$C0                            ; B484 C0 C0                    ..
        .byte   $D3                             ; B486 D3                       .
        dec     $C0,x                           ; B487 D6 C0                    ..
        cpy     #$D6                            ; B489 C0 D6                    ..
        dec     $C0,x                           ; B48B D6 C0                    ..
        cpy     #$9B                            ; B48D C0 9B                    ..
        .byte   $93                             ; B48F 93                       .
        rti                                     ; B490 40                       @

; ----------------------------------------------------------------------------
        beq     LB437                           ; B491 F0 A4                    ..
        .byte   $F2                             ; B493 F2                       .
        ldy     #$A1                            ; B494 A0 A1                    ..
        ldy     #$A1                            ; B496 A0 A1                    ..
        ora     $05                             ; B498 05 05                    ..
        .byte   $9B                             ; B49A 9B                       .
        .byte   $93                             ; B49B 93                       .
        ora     $05                             ; B49C 05 05                    ..
        bcc     LB43A                           ; B49E 90 9A                    ..
        ldx     #$A3                            ; B4A0 A2 A3                    ..
        ldx     #$A3                            ; B4A2 A2 A3                    ..
        ora     $05                             ; B4A4 05 05                    ..
        sty     $95,x                           ; B4A6 94 95                    ..
        .byte   $A7                             ; B4A8 A7                       .
        ldy     $47                             ; B4A9 A4 47                    .G
        eor     $A5                             ; B4AB 45 A5                    E.
        lda     $46                             ; B4AD A5 46                    .F
        .byte   $46                             ; B4AF 46                       F
LB4B0:  lda     $A7                             ; B4B0 A5 A7                    ..
        lsr     $47                             ; B4B2 46 47                    FG
        ldy     $A5                             ; B4B4 A4 A5                    ..
        ldy     $F0                             ; B4B6 A4 F0                    ..
LB4B8:  lda     $A7                             ; B4B8 A5 A7                    ..
        sbc     ($A7),y                         ; B4BA F1 A7                    ..
        lda     ($07),y                         ; B4BC B1 07                    ..
        ldy     $8E07,x                         ; B4BE BC 07 8E                 ...
        sty     $0505                           ; B4C1 8C 05 05                 ...
        sta     $058D                           ; B4C4 8D 8D 05                 ...
        ora     $A4                             ; B4C7 05 A4                    ..
        sed                                     ; B4C9 F8                       .
        sty     $F98D                           ; B4CA 8C 8D F9                 ...
        .byte   $A7                             ; B4CD A7                       .
        sta     LBC8E                           ; B4CE 8D 8E BC                 ...
        .byte   $07                             ; B4D1 07                       .
        lda     $C107,y                         ; B4D2 B9 07 C1                 ...
        .byte   $07                             ; B4D5 07                       .
        cpy     #$07                            ; B4D6 C0 07                    ..
        cpy     $85CD                           ; B4D8 CC CD 85                 ...
        sta     $CC                             ; B4DB 85 CC                    ..
        cmp     $8685                           ; B4DD CD 85 86                 ...
        adc     ($60,x)                         ; B4E0 61 60                    a`
        bcc     LB475                           ; B4E2 90 91                    ..
        cpy     $92CF                           ; B4E4 CC CF 92                 ...
        .byte   $93                             ; B4E7 93                       .
        sbc     ($44),y                         ; B4E8 F1 44                    .D
        .byte   $F3                             ; B4EA F3                       .
        .byte   $A7                             ; B4EB A7                       .
        .byte   $F3                             ; B4EC F3                       .
        .byte   $A7                             ; B4ED A7                       .
        sbc     $C4A7,y                         ; B4EE F9 A7 C4                 ...
        cpy     #$D3                            ; B4F1 C0 D3                    ..
        dec     $F1,x                           ; B4F3 D6 F1                    ..
        .byte   $A7                             ; B4F5 A7                       .
        .byte   $F3                             ; B4F6 F3                       .
        .byte   $A7                             ; B4F7 A7                       .
        .byte   $A7                             ; B4F8 A7                       .
        .byte   $07                             ; B4F9 07                       .
        .byte   $A7                             ; B4FA A7                       .
        .byte   $07                             ; B4FB 07                       .
        ldy     $A7                             ; B4FC A4 A7                    ..
        .byte   $8C,$8E,$A4                     ; B4FE 8C 8E A4                 ...
        lda     ($8C),y                         ; B501 B1 8C                    ..
        lda     LAAA8,y                         ; B503 B9 A8 AA                 ...
        .byte   $5A                             ; B506 5A                       Z
        bcs     LB4B0                           ; B507 B0 A7                    ..
        .byte   $07                             ; B509 07                       .
        .byte   $A7                             ; B50A A7                       .
        brk                                     ; B50B 00                       .
        .byte   $A7                             ; B50C A7                       .
        brk                                     ; B50D 00                       .
        .byte   $A7                             ; B50E A7                       .
        brk                                     ; B50F 00                       .
        .byte   $A7                             ; B510 A7                       .
        brk                                     ; B511 00                       .
        .byte   $A7                             ; B512 A7                       .
        sta     LACA7,y                         ; B513 99 A7 AC                 ...
        .byte   $A7                             ; B516 A7                       .
        rti                                     ; B517 40                       @

; ----------------------------------------------------------------------------
        .byte   $AF                             ; B518 AF                       .
        lda     $FAF0                           ; B519 AD F0 FA                 ...
        ldy     $FAAD                           ; B51C AC AD FA                 ...
        .byte   $FA                             ; B51F FA                       .
        .byte   $AF                             ; B520 AF                       .
        tax                                     ; B521 AA                       .
        .byte   $FA                             ; B522 FA                       .
        ldx     $A8,y                           ; B523 B6 A8                    ..
        lda     $F040                           ; B525 AD 40 F0                 .@.
        ldy     $FAAD                           ; B528 AC AD FA                 ...
        ldx     $AA,y                           ; B52B B6 AA                    ..
        asl     $B0                             ; B52D 06 B0                    ..
        .byte   $07                             ; B52F 07                       .
        .byte   $A7                             ; B530 A7                       .
        ldy     $A7                             ; B531 A4 A7                    ..
        ldy     $F8                             ; B533 A4 F8                    ..
        .byte   $FB                             ; B535 FB                       .
        lda     $A5                             ; B536 A5 A5                    ..
        .byte   $FB                             ; B538 FB                       .
        .byte   $FB                             ; B539 FB                       .
        lda     $A5                             ; B53A A5 A5                    ..
        .byte   $FB                             ; B53C FB                       .
        .byte   $BE,$A5,$A7                     ; B53D BE A5 A7
        ldy     $F8                             ; B540 A4 F8                    ..
        ldy     $A5                             ; B542 A4 A5                    ..
        clv                                     ; B544 B8                       .
        .byte   $07                             ; B545 07                       .
        lda     ($07),y                         ; B546 B1 07                    ..
        .byte   $A7                             ; B548 A7                       .
        lda     ($A7),y                         ; B549 B1 A7                    ..
        lda     $05A7,y                         ; B54B B9 A7 05                 ...
        .byte   $A7                             ; B54E A7                       .
        brk                                     ; B54F 00                       .
        tay                                     ; B550 A8                       .
        ldx     $4440                           ; B551 AE 40 44                 .@D
        .byte   $14                             ; B554 14                       .
        brk                                     ; B555 00                       .
        brk                                     ; B556 00                       .
        brk                                     ; B557 00                       .
        tay                                     ; B558 A8                       .
        .byte   $AB                             ; B559 AB                       .
        rti                                     ; B55A 40                       @

; ----------------------------------------------------------------------------
        bcs     LB574                           ; B55B B0 17                    ..
        asl     $1F,x                           ; B55D 16 1F                    ..
        asl     $06A7,x                         ; B55F 1E A7 06                 ...
        .byte   $A7                             ; B562 A7                       .
        .byte   $07                             ; B563 07                       .
        brk                                     ; B564 00                       .
        .byte   $17                             ; B565 17                       .
        ora     $1F                             ; B566 05 1F                    ..
        brk                                     ; B568 00                       .
        brk                                     ; B569 00                       .
        .byte   $EB                             ; B56A EB                       .
        cpx     a:L0000                         ; B56B EC 00 00                 ...
        cpx     a:$EC                           ; B56E EC EC 00                 ...
        brk                                     ; B571 00                       .
        .byte   $EC                             ; B572 EC                       .
        .byte   $EE                             ; B573 EE                       .
LB574:  brk                                     ; B574 00                       .
        .byte   $EB                             ; B575 EB                       .
        brk                                     ; B576 00                       .
        brk                                     ; B577 00                       .
        cpx     a:$EC                           ; B578 EC EC 00                 ...
        brk                                     ; B57B 00                       .
        cpx     a:$EE                           ; B57C EC EE 00                 ...
        brk                                     ; B57F 00                       .
        .byte   $A7                             ; B580 A7                       .
        ldy     LB1A7,x                         ; B581 BC A7 B1                 ...
        eor     $47                             ; B584 45 47                    EG
        tay                                     ; B586 A8                       .
        tax                                     ; B587 AA                       .
        eor     $46                             ; B588 45 46                    EF
        .byte   $AB                             ; B58A AB                       .
        ldy     LBC47                           ; B58B AC 47 BC                 .G.
        tay                                     ; B58E A8                       .
        tax                                     ; B58F AA                       .
        eor     $F8                             ; B590 45 F8                    E.
        .byte   $AB                             ; B592 AB                       .
        ldy     $47F9                           ; B593 AC F9 47                 ..G
        lda     LA8AE                           ; B596 AD AE A8                 ...
        tax                                     ; B599 AA                       .
        .byte   $12                             ; B59A 12                       .
        asl     a                               ; B59B 0A                       .
        .byte   $13                             ; B59C 13                       .
        asl     a                               ; B59D 0A                       .
        brk                                     ; B59E 00                       .
        asl     a                               ; B59F 0A                       .
        .byte   $F2                             ; B5A0 F2                       .
        .byte   $F2                             ; B5A1 F2                       .
        .byte   $F2                             ; B5A2 F2                       .
        .byte   $F2                             ; B5A3 F2                       .
        .byte   $F3                             ; B5A4 F3                       .
        .byte   $F3                             ; B5A5 F3                       .
        .byte   $F3                             ; B5A6 F3                       .
        .byte   $F3                             ; B5A7 F3                       .
        .byte   $F2                             ; B5A8 F2                       .
        .byte   $F2                             ; B5A9 F2                       .
        sed                                     ; B5AA F8                       .
        .byte   $F2                             ; B5AB F2                       .
        .byte   $F3                             ; B5AC F3                       .
        .byte   $F3                             ; B5AD F3                       .
        .byte   $F3                             ; B5AE F3                       .
        sbc     $F2F0,y                         ; B5AF F9 F0 F2                 ...
        .byte   $F2                             ; B5B2 F2                       .
        .byte   $F2                             ; B5B3 F2                       .
        .byte   $F3                             ; B5B4 F3                       .
        sbc     ($F3),y                         ; B5B5 F1 F3                    ..
        .byte   $F3                             ; B5B7 F3                       .
        .byte   $A7                             ; B5B8 A7                       .
        ldy     LB947,x                         ; B5B9 BC 47 B9                 .G.
        .byte   $F2                             ; B5BC F2                       .
        .byte   $F2                             ; B5BD F2                       .
        sed                                     ; B5BE F8                       .
        sed                                     ; B5BF F8                       .
        .byte   $F3                             ; B5C0 F3                       .
        .byte   $F3                             ; B5C1 F3                       .
        sbc     LABF9,y                         ; B5C2 F9 F9 AB                 ...
        ldy     $C1C1                           ; B5C5 AC C1 C1                 ...
        lda     $C1AE                           ; B5C8 AD AE C1                 ...
        cmp     ($A8,x)                         ; B5CB C1 A8                    ..
        tax                                     ; B5CD AA                       .
        cmp     ($0A,x)                         ; B5CE C1 0A                    ..
        cpy     #$0A                            ; B5D0 C0 0A                    ..
        cpy     #$0A                            ; B5D2 C0 0A                    ..
        ldy     LB117,x                         ; B5D4 BC 17 B1                 ...
        .byte   $1F                             ; B5D7 1F                       .
        asl     $F5,x                           ; B5D8 16 F5                    ..
        asl     LBCFD,x                         ; B5DA 1E FD BC                 ...
        cmp     $B1                             ; B5DD C5 B1                    ..
        cpy     $C1                             ; B5DF C4 C1                    ..
        ldy     $C0                             ; B5E1 A4 C0                    ..
        ldy     $BC                             ; B5E3 A4 BC                    ..
        cpy     $B1                             ; B5E5 C4 B1                    ..
        cpy     $C0                             ; B5E7 C4 C0                    ..
        ldy     $C0                             ; B5E9 A4 C0                    ..
        ldy     $BC                             ; B5EB A4 BC                    ..
        cpy     $B9                             ; B5ED C4 B9                    ..
        cpy     $AA                             ; B5EF C4 AA                    ..
        cpy     $C1                             ; B5F1 C4 C1                    ..
        .byte   $C7                             ; B5F3 C7                       .
        cpx     #$F5                            ; B5F4 E0 F5                    ..
        inx                                     ; B5F6 E8                       .
        .byte   $FD,$00,$A4                     ; B5F7 FD 00 A4
        brk                                     ; B5FA 00                       .
        ldy     L0000                           ; B5FB A4 00                    ..
        brk                                     ; B5FD 00                       .
        brk                                     ; B5FE 00                       .
        brk                                     ; B5FF 00                       .
        brk                                     ; B600 00                       .
        ora     ($02,x)                         ; B601 01 02                    ..
        .byte   $03                             ; B603 03                       .
        .byte   $04                             ; B604 04                       .
        .byte   $03                             ; B605 03                       .
        .byte   $03                             ; B606 03                       .
        ora     $06                             ; B607 05 06                    ..
        .byte   $07                             ; B609 07                       .
        php                                     ; B60A 08                       .
        .byte   $03                             ; B60B 03                       .
        .byte   $03                             ; B60C 03                       .
        ora     $09                             ; B60D 05 09                    ..
        .byte   $03                             ; B60F 03                       .
        asl     a                               ; B610 0A                       .
        .byte   $0B                             ; B611 0B                       .
        .byte   $0C                             ; B612 0C                       .
        .byte   $04                             ; B613 04                       .
        .byte   $03                             ; B614 03                       .
        .byte   $03                             ; B615 03                       .
        .byte   $04                             ; B616 04                       .
        ora     $0D                             ; B617 05 0D                    ..
        brk                                     ; B619 00                       .
        ora     ($02,x)                         ; B61A 01 02                    ..
        ora     $03                             ; B61C 05 03                    ..
        .byte   $03                             ; B61E 03                       .
        .byte   $03                             ; B61F 03                       .
        ora     $0706                           ; B620 0D 06 07                 ...
        php                                     ; B623 08                       .
        .byte   $04                             ; B624 04                       .
        ora     $03                             ; B625 05 03                    ..
        .byte   $03                             ; B627 03                       .
        ora     $0B0A                           ; B628 0D 0A 0B                 ...
        .byte   $0C                             ; B62B 0C                       .
        asl     $0F0E                           ; B62C 0E 0E 0F                 ...
        .byte   $0F                             ; B62F 0F                       .
        bpl     LB642                           ; B630 10 10                    ..
        bpl     LB644                           ; B632 10 10                    ..
        bpl     LB646                           ; B634 10 10                    ..
        ora     ($12),y                         ; B636 11 12                    ..
        .byte   $03                             ; B638 03                       .
        .byte   $03                             ; B639 03                       .
        .byte   $04                             ; B63A 04                       .
        .byte   $03                             ; B63B 03                       .
        .byte   $04                             ; B63C 04                       .
        .byte   $03                             ; B63D 03                       .
        .byte   $13                             ; B63E 13                       .
        .byte   $14                             ; B63F 14                       .
        ora     $03                             ; B640 05 03                    ..
LB642:  ora     $03                             ; B642 05 03                    ..
LB644:  .byte   $04                             ; B644 04                       .
        .byte   $03                             ; B645 03                       .
LB646:  .byte   $03                             ; B646 03                       .
        ora     $03                             ; B647 05 03                    ..
        .byte   $04                             ; B649 04                       .
        .byte   $03                             ; B64A 03                       .
        .byte   $03                             ; B64B 03                       .
        .byte   $03                             ; B64C 03                       .
        ora     $03                             ; B64D 05 03                    ..
        .byte   $03                             ; B64F 03                       .
        .byte   $03                             ; B650 03                       .
        .byte   $03                             ; B651 03                       .
        ora     $04,x                           ; B652 15 04                    ..
        .byte   $03                             ; B654 03                       .
        .byte   $03                             ; B655 03                       .
        .byte   $04                             ; B656 04                       .
        ora     $03                             ; B657 05 03                    ..
        .byte   $03                             ; B659 03                       .
        .byte   $04                             ; B65A 04                       .
        .byte   $03                             ; B65B 03                       .
        ora     $03                             ; B65C 05 03                    ..
        .byte   $04                             ; B65E 04                       .
        .byte   $03                             ; B65F 03                       .
        .byte   $04                             ; B660 04                       .
        .byte   $03                             ; B661 03                       .
        ora     $03                             ; B662 05 03                    ..
        .byte   $04                             ; B664 04                       .
        ora     $03                             ; B665 05 03                    ..
        .byte   $03                             ; B667 03                       .
        asl     $17,x                           ; B668 16 17                    ..
        asl     $0E0E                           ; B66A 0E 0E 0E                 ...
        asl     $0F0E                           ; B66D 0E 0E 0F                 ...
        clc                                     ; B670 18                       .
        ora     $1010,y                         ; B671 19 10 10                 ...
        bpl     LB686                           ; B674 10 10                    ..
        bpl     LB692                           ; B676 10 1A                    ..
        .byte   $1B                             ; B678 1B                       .
        .byte   $1C                             ; B679 1C                       .
        .byte   $04                             ; B67A 04                       .
        .byte   $03                             ; B67B 03                       .
        ora     $0403,x                         ; B67C 1D 03 04                 ...
        .byte   $13                             ; B67F 13                       .
        ora     $03                             ; B680 05 03                    ..
        ora     $03                             ; B682 05 03                    ..
        .byte   $04                             ; B684 04                       .
        .byte   $03                             ; B685 03                       .
LB686:  .byte   $03                             ; B686 03                       .
        ora     $03                             ; B687 05 03                    ..
        .byte   $04                             ; B689 04                       .
        .byte   $03                             ; B68A 03                       .
        .byte   $03                             ; B68B 03                       .
        .byte   $03                             ; B68C 03                       .
        ora     $03                             ; B68D 05 03                    ..
        .byte   $03                             ; B68F 03                       .
        .byte   $03                             ; B690 03                       .
        .byte   $03                             ; B691 03                       .
LB692:  ora     $04,x                           ; B692 15 04                    ..
        .byte   $03                             ; B694 03                       .
        .byte   $03                             ; B695 03                       .
        .byte   $04                             ; B696 04                       .
        ora     $1D                             ; B697 05 1D                    ..
        .byte   $03                             ; B699 03                       .
        .byte   $04                             ; B69A 04                       .
        .byte   $03                             ; B69B 03                       .
        ora     $03                             ; B69C 05 03                    ..
        .byte   $03                             ; B69E 03                       .
        .byte   $03                             ; B69F 03                       .
        asl     $0E0E,x                         ; B6A0 1E 0E 0E                 ...
        asl     $050E                           ; B6A3 0E 0E 05                 ...
        .byte   $03                             ; B6A6 03                       .
        ora     $1F16,x                         ; B6A7 1D 16 1F                 ...
        jsr     L2221                           ; B6AA 20 21 22                  !"
        asl     $2303                           ; B6AD 0E 03 23                 ..#
        clc                                     ; B6B0 18                       .
        bit     $25                             ; B6B1 24 25                    $%
        rol     $1C                             ; B6B3 26 1C                    &.
        .byte   $22                             ; B6B5 22                       "
        .byte   $04                             ; B6B6 04                       .
        .byte   $1C                             ; B6B7 1C                       .
        .byte   $1B                             ; B6B8 1B                       .
        bit     $25                             ; B6B9 24 25                    $%
        .byte   $27                             ; B6BB 27                       '
        .byte   $1C                             ; B6BC 1C                       .
        .byte   $1C                             ; B6BD 1C                       .
        .byte   $03                             ; B6BE 03                       .
        .byte   $1C                             ; B6BF 1C                       .
        .byte   $1B                             ; B6C0 1B                       .
        bit     $25                             ; B6C1 24 25                    $%
        plp                                     ; B6C3 28                       (
        .byte   $1C                             ; B6C4 1C                       .
        .byte   $1C                             ; B6C5 1C                       .
        .byte   $04                             ; B6C6 04                       .
        .byte   $1C                             ; B6C7 1C                       .
        .byte   $1B                             ; B6C8 1B                       .
        and     #$2A                            ; B6C9 29 2A                    )*
        .byte   $2B                             ; B6CB 2B                       +
        bit     $032D                           ; B6CC 2C 2D 03                 ,-.
        .byte   $1C                             ; B6CF 1C                       .
        .byte   $1B                             ; B6D0 1B                       .
        .byte   $03                             ; B6D1 03                       .
        .byte   $04                             ; B6D2 04                       .
        .byte   $03                             ; B6D3 03                       .
        .byte   $03                             ; B6D4 03                       .
        .byte   $03                             ; B6D5 03                       .
        .byte   $04                             ; B6D6 04                       .
        .byte   $1C                             ; B6D7 1C                       .
        .byte   $1B                             ; B6D8 1B                       .
        ora     $0305,x                         ; B6D9 1D 05 03                 ...
        .byte   $04                             ; B6DC 04                       .
        ora     $1C05,x                         ; B6DD 1D 05 1C                 ...
        .byte   $1B                             ; B6E0 1B                       .
        .byte   $04                             ; B6E1 04                       .
        asl     $2E,x                           ; B6E2 16 2E                    ..
        rol     $2E2E                           ; B6E4 2E 2E 2E                 ...
        bit     $0E1B                           ; B6E7 2C 1B 0E                 ,..
        asl     $0E0E                           ; B6EA 0E 0E 0E                 ...
        asl     $0E0E                           ; B6ED 0E 0E 0E                 ...
        .byte   $1B                             ; B6F0 1B                       .
        bpl     LB703                           ; B6F1 10 10                    ..
        bpl     LB705                           ; B6F3 10 10                    ..
        bpl     LB707                           ; B6F5 10 10                    ..
        bpl     LB714                           ; B6F7 10 1B                    ..
        asl     $031D,x                         ; B6F9 1E 1D 03                 ...
        .byte   $04                             ; B6FC 04                       .
        .byte   $03                             ; B6FD 03                       .
        .byte   $03                             ; B6FE 03                       .
        .byte   $03                             ; B6FF 03                       .
        .byte   $2F                             ; B700 2F                       /
        bmi     LB733                           ; B701 30 30                    00
LB703:  and     ($30),y                         ; B703 31 30                    10
LB705:  bmi     LB737                           ; B705 30 30                    00
LB707:  bmi     LB725                           ; B707 30 1C                    0.
        .byte   $32                             ; B709 32                       2
        .byte   $03                             ; B70A 03                       .
        .byte   $32                             ; B70B 32                       2
        .byte   $03                             ; B70C 03                       .
        .byte   $33                             ; B70D 33                       3
        .byte   $33                             ; B70E 33                       3
        .byte   $33                             ; B70F 33                       3
        .byte   $1C                             ; B710 1C                       .
        .byte   $03                             ; B711 03                       .
        .byte   $04                             ; B712 04                       .
        .byte   $03                             ; B713 03                       .
LB714:  .byte   $32                             ; B714 32                       2
        .byte   $03                             ; B715 03                       .
        .byte   $04                             ; B716 04                       .
        .byte   $03                             ; B717 03                       .
        .byte   $1C                             ; B718 1C                       .
        ora     $0305,x                         ; B719 1D 05 03                 ...
        .byte   $03                             ; B71C 03                       .
        ora     $0305,x                         ; B71D 1D 05 03                 ...
        and     $3204                           ; B720 2D 04 32                 -.2
        .byte   $03                             ; B723 03                       .
        .byte   $10                             ; B724 10                       .
LB725:  ora     $03                             ; B725 05 03                    ..
        asl     $0E0E                           ; B727 0E 0E 0E                 ...
        asl     $340E                           ; B72A 0E 0E 34                 ..4
        asl     $350E                           ; B72D 0E 0E 35                 ..5
        bpl     LB742                           ; B730 10 10                    ..
        .byte   $10                             ; B732 10                       .
LB733:  bpl     LB745                           ; B733 10 10                    ..
        bpl     LB747                           ; B735 10 10                    ..
LB737:  rol     $03,x                           ; B737 36 03                    6.
        .byte   $37                             ; B739 37                       7
        .byte   $03                             ; B73A 03                       .
        .byte   $04                             ; B73B 04                       .
        .byte   $34                             ; B73C 34                       4
        .byte   $03                             ; B73D 03                       .
        .byte   $03                             ; B73E 03                       .
        sec                                     ; B73F 38                       8
        bmi     LB772                           ; B740 30 30                    00
LB742:  bmi     LB775                           ; B742 30 31                    01
        .byte   $30                             ; B744 30                       0
LB745:  bmi     LB778                           ; B745 30 31                    01
LB747:  bmi     LB77C                           ; B747 30 33                    03
        and     $0303,y                         ; B749 39 03 03                 9..
        .byte   $04                             ; B74C 04                       .
        .byte   $3A                             ; B74D 3A                       :
        .byte   $03                             ; B74E 03                       .
        ora     $0E0E,x                         ; B74F 1D 0E 0E                 ...
        .byte   $3B                             ; B752 3B                       ;
        ora     $0305,x                         ; B753 1D 05 03                 ...
        .byte   $04                             ; B756 04                       .
        .byte   $03                             ; B757 03                       .
        .byte   $1F                             ; B758 1F                       .
        and     ($0E,x)                         ; B759 21 0E                    !.
        .byte   $04                             ; B75B 04                       .
        .byte   $03                             ; B75C 03                       .
        ora     $3305,x                         ; B75D 1D 05 33                 ..3
        .byte   $3C                             ; B760 3C                       <
        and     $0323,x                         ; B761 3D 23 03                 =#.
        .byte   $03                             ; B764 03                       .
        .byte   $04                             ; B765 04                       .
        .byte   $32                             ; B766 32                       2
        .byte   $03                             ; B767 03                       .
        bit     $27                             ; B768 24 27                    $'
        .byte   $1C                             ; B76A 1C                       .
        asl     $0E0E                           ; B76B 0E 0E 0E                 ...
        asl     $2E,x                           ; B76E 16 2E                    ..
        .byte   $3C                             ; B770 3C                       <
        .byte   $3E                             ; B771 3E                       >
LB772:  .byte   $2F                             ; B772 2F                       /
        bpl     LB785                           ; B773 10 10                    ..
LB775:  bpl     LB7B6                           ; B775 10 3F                    .?
        rti                                     ; B777 40                       @

; ----------------------------------------------------------------------------
LB778:  bit     $27                             ; B778 24 27                    $'
        .byte   $1C                             ; B77A 1C                       .
        .byte   $04                             ; B77B 04                       .
LB77C:  .byte   $03                             ; B77C 03                       .
        ora     $4241,x                         ; B77D 1D 41 42                 .AB
        bmi     LB7B2                           ; B780 30 30                    00
        .byte   $43                             ; B782 43                       C
        .byte   $44                             ; B783 44                       D
        .byte   $45                             ; B784 45                       E
LB785:  .byte   $44                             ; B785 44                       D
        lsr     $24                             ; B786 46 24                    F$
        ora     $03                             ; B788 05 03                    ..
        .byte   $47                             ; B78A 47                       G
        pha                                     ; B78B 48                       H
        eor     #$4A                            ; B78C 49 4A                    IJ
        .byte   $4B                             ; B78E 4B                       K
        bit     $32                             ; B78F 24 32                    $2
        .byte   $03                             ; B791 03                       .
        ora     $4C32,x                         ; B792 1D 32 4C                 .2L
        eor     $244E                           ; B795 4D 4E 24                 MN$
        .byte   $33                             ; B798 33                       3
        .byte   $03                             ; B799 03                       .
        .byte   $03                             ; B79A 03                       .
        ora     $1D4F,x                         ; B79B 1D 4F 1D                 .O.
        jmp     L3224                           ; B79E 4C 24 32                 L$2

; ----------------------------------------------------------------------------
        ora     $03                             ; B7A1 05 03                    ..
        .byte   $04                             ; B7A3 04                       .
        bvc     LB7F7                           ; B7A4 50 51                    PQ
        .byte   $03                             ; B7A6 03                       .
        bit     $52                             ; B7A7 24 52                    $R
        asl     $16,x                           ; B7A9 16 16                    ..
        .byte   $52                             ; B7AB 52                       R
        .byte   $53                             ; B7AC 53                       S
        .byte   $03                             ; B7AD 03                       .
        .byte   $04                             ; B7AE 04                       .
        bit     $54                             ; B7AF 24 54                    $T
        .byte   $55                             ; B7B1 55                       U
LB7B2:  lsr     $57,x                           ; B7B2 56 57                    VW
        .byte   $23                             ; B7B4 23                       #
        .byte   $05                             ; B7B5 05                       .
LB7B6:  .byte   $32                             ; B7B6 32                       2
        bit     $58                             ; B7B7 24 58                    $X
        .byte   $13                             ; B7B9 13                       .
        eor     $1C5A,y                         ; B7BA 59 5A 1C                 YZ.
        .byte   $03                             ; B7BD 03                       .
        .byte   $03                             ; B7BE 03                       .
        bit     $27                             ; B7BF 24 27                    $'
        .byte   $13                             ; B7C1 13                       .
        bit     L0028                           ; B7C2 24 28                    $(
        .byte   $5B                             ; B7C4 5B                       [
        .byte   $04                             ; B7C5 04                       .
        .byte   $32                             ; B7C6 32                       2
        bit     $5C                             ; B7C7 24 5C                    $\
        eor     $5F5E,x                         ; B7C9 5D 5E 5F                 ]^_
        rts                                     ; B7CC 60                       `

; ----------------------------------------------------------------------------
        .byte   $03                             ; B7CD 03                       .
        .byte   $03                             ; B7CE 03                       .
        bit     $27                             ; B7CF 24 27                    $'
        adc     ($62,x)                         ; B7D1 61 62                    ab
        .byte   $03                             ; B7D3 03                       .
        ora     $03                             ; B7D4 05 03                    ..
        .byte   $04                             ; B7D6 04                       .
        bit     $27                             ; B7D7 24 27                    $'
        .byte   $63                             ; B7D9 63                       c
        .byte   $64                             ; B7DA 64                       d
        .byte   $03                             ; B7DB 03                       .
        .byte   $32                             ; B7DC 32                       2
        asl     $240E                           ; B7DD 0E 0E 24                 ..$
        .byte   $27                             ; B7E0 27                       '
        .byte   $62                             ; B7E1 62                       b
        .byte   $03                             ; B7E2 03                       .
        .byte   $03                             ; B7E3 03                       .
        .byte   $03                             ; B7E4 03                       .
        bpl     LB7F7                           ; B7E5 10 10                    ..
        adc     $27                             ; B7E7 65 27                    e'
        eor     $664E                           ; B7E9 4D 4E 66                 MNf
        ora     $03                             ; B7EC 05 03                    ..
        .byte   $04                             ; B7EE 04                       .
        bit     $27                             ; B7EF 24 27                    $'
        .byte   $32                             ; B7F1 32                       2
        jmp     L4E4D                           ; B7F2 4C 4D 4E                 LMN

; ----------------------------------------------------------------------------
        .byte   $32                             ; B7F5 32                       2
        .byte   $03                             ; B7F6 03                       .
LB7F7:  bit     $27                             ; B7F7 24 27                    $'
        .byte   $67                             ; B7F9 67                       g
        ora     $4C03,x                         ; B7FA 1D 03 4C                 ..L
        eor     $2403                           ; B7FD 4D 03 24                 M.$
        .byte   $27                             ; B800 27                       '
        pla                                     ; B801 68                       h
        adc     #$03                            ; B802 69 03                    i.
        .byte   $03                             ; B804 03                       .
        ror     a                               ; B805 6A                       j
        eor     $2724                           ; B806 4D 24 27                 M$'
        .byte   $03                             ; B809 03                       .
        .byte   $6B                             ; B80A 6B                       k
        jmp     (L0503)                         ; B80B 6C 03 05                 l..

; ----------------------------------------------------------------------------
        .byte   $03                             ; B80E 03                       .
        bit     $27                             ; B80F 24 27                    $'
        asl     $0E05                           ; B811 0E 05 0E                 ...
        asl     $0E0E                           ; B814 0E 0E 0E                 ...
        bit     $27                             ; B817 24 27                    $'
        and     $6D,x                           ; B819 35 6D                    5m
        bmi     LB84D                           ; B81B 30 30                    00
        bmi     LB84F                           ; B81D 30 30                    00
        .byte   $65                             ; B81F 65                       e
LB820:  .byte   $27                             ; B820 27                       '
        ror     $706F                           ; B821 6E 6F 70                 nop
        adc     ($72),y                         ; B824 71 72                    qr
        .byte   $73                             ; B826 73                       s
        .byte   $74                             ; B827 74                       t
        .byte   $27                             ; B828 27                       '
        sec                                     ; B829 38                       8
        adc     $76,x                           ; B82A 75 76                    uv
        .byte   $77                             ; B82C 77                       w
        sei                                     ; B82D 78                       x
        adc     $277A,y                         ; B82E 79 7A 27                 yz'
        .byte   $7B                             ; B831 7B                       {
        .byte   $7C                             ; B832 7C                       |
        adc     $7D7C,x                         ; B833 7D 7C 7D                 }|}
        .byte   $7C                             ; B836 7C                       |
        adc     $3827,x                         ; B837 7D 27 38                 }'8
        ror     $7E7F,x                         ; B83A 7E 7F 7E                 ~.~
        .byte   $7F                             ; B83D 7F                       .
        ror     $257F,x                         ; B83E 7E 7F 25                 ~.%
        .byte   $80                             ; B841 80                       .
        sta     ($82,x)                         ; B842 81 82                    ..
        bit     L0080                           ; B844 24 80                    $.
        bit     L0080                           ; B846 24 80                    $.
        and     L0080                           ; B848 25 80                    %.
        .byte   $83                             ; B84A 83                       .
        sty     $74                             ; B84B 84 74                    .t
LB84D:  sta     $24                             ; B84D 85 24                    .$
LB84F:  .byte   $80                             ; B84F 80                       .
        and     L0080                           ; B850 25 80                    %.
        stx     $87                             ; B852 86 87                    ..
        dey                                     ; B854 88                       .
        .byte   $89                             ; B855 89                       .
        txa                                     ; B856 8A                       .
        .byte   $8B                             ; B857 8B                       .
        and     L0080                           ; B858 25 80                    %.
        .byte   $6F                             ; B85A 6F                       o
        sty     $7070                           ; B85B 8C 70 70                 .pp
        sta     $428D                           ; B85E 8D 8D 42                 ..B
        sta     $6F                             ; B861 85 6F                    .o
        sty     $8F8E                           ; B863 8C 8E 8F                 ...
        sty     $908C                           ; B866 8C 8C 90                 ...
        sta     ($92),y                         ; B869 91 92                    ..
        ror     $93,x                           ; B86B 76 93                    v.
        .byte   $6F                             ; B86D 6F                       o
        sty     $95,x                           ; B86E 94 95                    ..
        .byte   $7C                             ; B870 7C                       |
        adc     $7D7C,x                         ; B871 7D 7C 7D                 }|}
        .byte   $93                             ; B874 93                       .
        stx     $97,y                           ; B875 96 97                    ..
        tya                                     ; B877 98                       .
        ror     $7E7F,x                         ; B878 7E 7F 7E                 ~.~
LB87B:  .byte   $7F                             ; B87B 7F                       .
        .byte   $93                             ; B87C 93                       .
        sta     $7F7E,y                         ; B87D 99 7E 7F                 .~.
        txs                                     ; B880 9A                       .
        .byte   $9B                             ; B881 9B                       .
        txs                                     ; B882 9A                       .
        .byte   $9B                             ; B883 9B                       .
        .byte   $9C                             ; B884 9C                       .
        sta     $9E85,x                         ; B885 9D 85 9E                 ...
        stx     $8D                             ; B888 86 8D                    ..
        sta     $8D8D                           ; B88A 8D 8D 8D                 ...
        sta     $888D                           ; B88D 8D 8D 88                 ...
        .byte   $6F                             ; B890 6F                       o
        sty     $8C8C                           ; B891 8C 8C 8C                 ...
        sty     $8C8C                           ; B894 8C 8C 8C                 ...
        bvs     LB820                           ; B897 70 87                    p.
        sty     $8C8C                           ; B899 8C 8C 8C                 ...
        sty     $8C8C                           ; B89C 8C 8C 8C                 ...
        .byte   $9F                             ; B89F 9F                       .
        sty     LA08C                           ; B8A0 8C 8C A0                 ...
        lda     ($A2,x)                         ; B8A3 A1 A2                    ..
        .byte   $A3                             ; B8A5 A3                       .
        lda     ($A4,x)                         ; B8A6 A1 A4                    ..
        sty     $95,x                           ; B8A8 94 95                    ..
        lda     $A6                             ; B8AA A5 A6                    ..
        .byte   $A7                             ; B8AC A7                       .
        tay                                     ; B8AD A8                       .
        lda     #$41                            ; B8AE A9 41                    .A
        .byte   $97                             ; B8B0 97                       .
        tya                                     ; B8B1 98                       .
        .byte   $97                             ; B8B2 97                       .
        tya                                     ; B8B3 98                       .
        .byte   $97                             ; B8B4 97                       .
        tya                                     ; B8B5 98                       .
        .byte   $93                             ; B8B6 93                       .
        eor     $7F7E,y                         ; B8B7 59 7E 7F                 Y~.
        ror     $7E7F,x                         ; B8BA 7E 7F 7E                 ~.~
        .byte   $7F                             ; B8BD 7F                       .
        .byte   $93                             ; B8BE 93                       .
        bit     $AA                             ; B8BF 24 AA                    $.
        .byte   $AB                             ; B8C1 AB                       .
        .byte   $AB                             ; B8C2 AB                       .
        ldy     LAEAD                           ; B8C3 AC AD AE                 ...
        .byte   $AF                             ; B8C6 AF                       .
        sec                                     ; B8C7 38                       8
        .byte   $B0                             ; B8C8 B0                       .
LB8C9:  lda     ($B1),y                         ; B8C9 B1 B1                    ..
        .byte   $89                             ; B8CB 89                       .
        .byte   $B2                             ; B8CC B2                       .
        .byte   $B3                             ; B8CD B3                       .
        ldy     $38,x                           ; B8CE B4 38                    .8
        bvs     LB942                           ; B8D0 70 70                    pp
        bvs     LB945                           ; B8D2 70 71                    pq
        bvs     LB947                           ; B8D4 70 71                    pq
        lda     $38,x                           ; B8D6 B5 38                    .8
        ldx     $B7,y                           ; B8D8 B6 B7                    ..
        .byte   $8F                             ; B8DA 8F                       .
        .byte   $77                             ; B8DB 77                       w
        sty     LB9B8                           ; B8DC 8C B8 B9                 ...
        sec                                     ; B8DF 38                       8
        rti                                     ; B8E0 40                       @

; ----------------------------------------------------------------------------
        tsx                                     ; B8E1 BA                       .
        .byte   $6F                             ; B8E2 6F                       o
        .byte   $77                             ; B8E3 77                       w
        sty     LA8A5                           ; B8E4 8C A5 A8                 ...
        sec                                     ; B8E7 38                       8
        and     $BB                             ; B8E8 25 BB                    %.
        ldy     $95B8,x                         ; B8EA BC B8 95                 ...
        lda     $A8                             ; B8ED A5 A8                    ..
        sec                                     ; B8EF 38                       8
        and     $BD                             ; B8F0 25 BD                    %.
        lda     #$97                            ; B8F2 A9 97                    ..
        tya                                     ; B8F4 98                       .
        .byte   $97                             ; B8F5 97                       .
        tya                                     ; B8F6 98                       .
        sec                                     ; B8F7 38                       8
        and     L0080                           ; B8F8 25 80                    %.
        .byte   $93                             ; B8FA 93                       .
        ror     $7E7F,x                         ; B8FB 7E 7F 7E                 ~.~
        .byte   $7F                             ; B8FE 7F                       .
        sec                                     ; B8FF 38                       8
        ldx     $C0BF,y                         ; B900 BE BF C0                 ...
        .byte   $2F                             ; B903 2F                       /
        bpl     LB916                           ; B904 10 10                    ..
        bpl     LB8C9                           ; B906 10 C1                    ..
        ldx     $0504,y                         ; B908 BE 04 05                 ...
        .byte   $1C                             ; B90B 1C                       .
        .byte   $33                             ; B90C 33                       3
LB90D:  .byte   $33                             ; B90D 33                       3
        .byte   $33                             ; B90E 33                       3
        ror     $05BE                           ; B90F 6E BE 05                 n..
        .byte   $03                             ; B912 03                       .
        .byte   $72                             ; B913 72                       r
        ora     $03                             ; B914 05 03                    ..
LB916:  ora     $38                             ; B916 05 38                    .8
        .byte   $C2                             ; B918 C2                       .
        .byte   $03                             ; B919 03                       .
        .byte   $03                             ; B91A 03                       .
        .byte   $33                             ; B91B 33                       3
        ora     $0305,x                         ; B91C 1D 05 03                 ...
        sec                                     ; B91F 38                       8
        .byte   $C3                             ; B920 C3                       .
        .byte   $32                             ; B921 32                       2
        ora     $03                             ; B922 05 03                    ..
        .byte   $04                             ; B924 04                       .
        .byte   $03                             ; B925 03                       .
        ora     $C438,x                         ; B926 1D 38 C4                 .8.
        asl     $0E0E                           ; B929 0E 0E 0E                 ...
        asl     $0E0E                           ; B92C 0E 0E 0E                 ...
        sec                                     ; B92F 38                       8
        cmp     $C6                             ; B930 C5 C6                    ..
        .byte   $C7                             ; B932 C7                       .
        iny                                     ; B933 C8                       .
        cmp     #$CA                            ; B934 C9 CA                    ..
        .byte   $CB                             ; B936 CB                       .
        sec                                     ; B937 38                       8
        cpy     $CECD                           ; B938 CC CD CE                 ...
        .byte   $CF                             ; B93B CF                       .
        bne     LB90D                           ; B93C D0 CF                    ..
        cmp     ($38),y                         ; B93E D1 38                    .8
        .byte   $1B                             ; B940 1B                       .
        .byte   $1C                             ; B941 1C                       .
LB942:  txs                                     ; B942 9A                       .
        .byte   $9B                             ; B943 9B                       .
        txs                                     ; B944 9A                       .
LB945:  .byte   $9B                             ; B945 9B                       .
        .byte   $59                             ; B946 59                       Y
LB947:  lda     $72D2,x                         ; B947 BD D2 72                 ..r
        .byte   $33                             ; B94A 33                       3
        .byte   $33                             ; B94B 33                       3
        .byte   $33                             ; B94C 33                       3
        .byte   $33                             ; B94D 33                       3
        bit     L0080                           ; B94E 24 80                    $.
        .byte   $D3                             ; B950 D3                       .
        .byte   $33                             ; B951 33                       3
        .byte   $04                             ; B952 04                       .
        .byte   $03                             ; B953 03                       .
        .byte   $03                             ; B954 03                       .
        .byte   $04                             ; B955 04                       .
        txa                                     ; B956 8A                       .
        .byte   $8B                             ; B957 8B                       .
        .byte   $C3                             ; B958 C3                       .
        ora     $D403,x                         ; B959 1D 03 D4                 ...
        ora     $0332,x                         ; B95C 1D 32 03                 .2.
        .byte   $03                             ; B95F 03                       .
        .byte   $C3                             ; B960 C3                       .
        cmp     $D6,x                           ; B961 D5 D6                    ..
        .byte   $1C                             ; B963 1C                       .
        .byte   $03                             ; B964 03                       .
        .byte   $03                             ; B965 03                       .
        .byte   $03                             ; B966 03                       .
        .byte   $04                             ; B967 04                       .
        cpy     $0E                             ; B968 C4 0E                    ..
        ror     $661C                           ; B96A 6E 1C 66                 n.f
        .byte   $D7                             ; B96D D7                       .
        asl     $D80E                           ; B96E 0E 0E D8                 ...
        .byte   $D4                             ; B971 D4                       .
        sec                                     ; B972 38                       8
        .byte   $2F                             ; B973 2F                       /
        bmi     LB9A6                           ; B974 30 30                    00
        bmi     LB9A8                           ; B976 30 30                    00
        ldx     $381C,y                         ; B978 BE 1C 38                 ..8
        .byte   $1C                             ; B97B 1C                       .
        .byte   $03                             ; B97C 03                       .
        ora     $0403,x                         ; B97D 1D 03 04                 ...
        ora     $03                             ; B980 05 03                    ..
        ora     $03                             ; B982 05 03                    ..
        .byte   $04                             ; B984 04                       .
        .byte   $03                             ; B985 03                       .
        .byte   $03                             ; B986 03                       .
        ora     $03                             ; B987 05 03                    ..
        .byte   $04                             ; B989 04                       .
        .byte   $03                             ; B98A 03                       .
        .byte   $03                             ; B98B 03                       .
        .byte   $03                             ; B98C 03                       .
        ora     $03                             ; B98D 05 03                    ..
        .byte   $03                             ; B98F 03                       .
        .byte   $03                             ; B990 03                       .
        .byte   $03                             ; B991 03                       .
        ora     $04,x                           ; B992 15 04                    ..
        .byte   $03                             ; B994 03                       .
        .byte   $03                             ; B995 03                       .
        .byte   $04                             ; B996 04                       .
        ora     $03                             ; B997 05 03                    ..
        .byte   $03                             ; B999 03                       .
        .byte   $04                             ; B99A 04                       .
        .byte   $03                             ; B99B 03                       .
        ora     $03                             ; B99C 05 03                    ..
        .byte   $03                             ; B99E 03                       .
        .byte   $03                             ; B99F 03                       .
        asl     $051D,x                         ; B9A0 1E 1D 05                 ...
        .byte   $03                             ; B9A3 03                       .
        .byte   $04                             ; B9A4 04                       .
        .byte   $05                             ; B9A5 05                       .
LB9A6:  .byte   $03                             ; B9A6 03                       .
        .byte   $03                             ; B9A7 03                       .
LB9A8:  asl     $0E0E                           ; B9A8 0E 0E 0E                 ...
        .byte   $03                             ; B9AB 03                       .
        .byte   $03                             ; B9AC 03                       .
        .byte   $03                             ; B9AD 03                       .
        .byte   $03                             ; B9AE 03                       .
        .byte   $04                             ; B9AF 04                       .
        bmi     LB9E2                           ; B9B0 30 30                    00
        bmi     LBA1A                           ; B9B2 30 66                    0f
        ror     $30                             ; B9B4 66 30                    f0
        bmi     LB9E8                           ; B9B6 30 30                    00
LB9B8:  .byte   $03                             ; B9B8 03                       .
        .byte   $1D                             ; B9B9 1D                       .
LB9BA:  .byte   $03                             ; B9BA 03                       .
        ora     $04,x                           ; B9BB 15 04                    ..
        .byte   $03                             ; B9BD 03                       .
        ora     L0503,x                         ; B9BE 1D 03 05                 ...
        .byte   $03                             ; B9C1 03                       .
        ora     $03                             ; B9C2 05 03                    ..
        .byte   $04                             ; B9C4 04                       .
        .byte   $03                             ; B9C5 03                       .
        .byte   $03                             ; B9C6 03                       .
        ora     $03                             ; B9C7 05 03                    ..
        .byte   $04                             ; B9C9 04                       .
        .byte   $03                             ; B9CA 03                       .
        .byte   $03                             ; B9CB 03                       .
        .byte   $03                             ; B9CC 03                       .
        ora     $03                             ; B9CD 05 03                    ..
        .byte   $03                             ; B9CF 03                       .
        .byte   $03                             ; B9D0 03                       .
        .byte   $03                             ; B9D1 03                       .
        ora     $04,x                           ; B9D2 15 04                    ..
        .byte   $03                             ; B9D4 03                       .
        .byte   $03                             ; B9D5 03                       .
        .byte   $04                             ; B9D6 04                       .
        ora     $03                             ; B9D7 05 03                    ..
        .byte   $03                             ; B9D9 03                       .
        .byte   $04                             ; B9DA 04                       .
        .byte   $03                             ; B9DB 03                       .
        ora     $03                             ; B9DC 05 03                    ..
        .byte   $03                             ; B9DE 03                       .
        .byte   $03                             ; B9DF 03                       .
        .byte   $1E                             ; B9E0 1E                       .
        .byte   $1D                             ; B9E1 1D                       .
LB9E2:  ora     $03                             ; B9E2 05 03                    ..
        .byte   $04                             ; B9E4 04                       .
        ora     $03                             ; B9E5 05 03                    ..
        .byte   $03                             ; B9E7 03                       .
LB9E8:  .byte   $03                             ; B9E8 03                       .
        ora     L0503,x                         ; B9E9 1D 03 05                 ...
        .byte   $03                             ; B9EC 03                       .
        .byte   $03                             ; B9ED 03                       .
        .byte   $03                             ; B9EE 03                       .
        .byte   $03                             ; B9EF 03                       .
        bmi     LBA22                           ; B9F0 30 30                    00
        ror     $D9                             ; B9F2 66 D9                    f.
        bmi     LBA26                           ; B9F4 30 30                    00
        bmi     LBA28                           ; B9F6 30 30                    00
        .byte   $03                             ; B9F8 03                       .
        .byte   $03                             ; B9F9 03                       .
        .byte   $3B                             ; B9FA 3B                       ;
        .byte   $03                             ; B9FB 03                       .
        ora     $03                             ; B9FC 05 03                    ..
        .byte   $03                             ; B9FE 03                       .
        .byte   $03                             ; B9FF 03                       .
        ora     $03                             ; BA00 05 03                    ..
        ora     $03                             ; BA02 05 03                    ..
        .byte   $04                             ; BA04 04                       .
        .byte   $03                             ; BA05 03                       .
        .byte   $03                             ; BA06 03                       .
        cmp     $03,x                           ; BA07 D5 03                    ..
        .byte   $04                             ; BA09 04                       .
        .byte   $03                             ; BA0A 03                       .
        .byte   $03                             ; BA0B 03                       .
        .byte   $03                             ; BA0C 03                       .
        ora     $03                             ; BA0D 05 03                    ..
        .byte   $03                             ; BA0F 03                       .
        .byte   $03                             ; BA10 03                       .
        .byte   $03                             ; BA11 03                       .
        ora     $04,x                           ; BA12 15 04                    ..
        .byte   $03                             ; BA14 03                       .
        .byte   $03                             ; BA15 03                       .
        .byte   $04                             ; BA16 04                       .
        .byte   $03                             ; BA17 03                       .
        .byte   $03                             ; BA18 03                       .
        .byte   $03                             ; BA19 03                       .
LBA1A:  .byte   $04                             ; BA1A 04                       .
        .byte   $03                             ; BA1B 03                       .
        ora     $03                             ; BA1C 05 03                    ..
        .byte   $03                             ; BA1E 03                       .
        .byte   $03                             ; BA1F 03                       .
        .byte   $1E                             ; BA20 1E                       .
        .byte   $1D                             ; BA21 1D                       .
LBA22:  ora     $03                             ; BA22 05 03                    ..
        .byte   $04                             ; BA24 04                       .
        .byte   $05                             ; BA25 05                       .
LBA26:  .byte   $03                             ; BA26 03                       .
        .byte   $03                             ; BA27 03                       .
LBA28:  .byte   $03                             ; BA28 03                       .
        .byte   $03                             ; BA29 03                       .
        ora     $0303,x                         ; BA2A 1D 03 03                 ...
        .byte   $03                             ; BA2D 03                       .
        .byte   $03                             ; BA2E 03                       .
        .byte   $03                             ; BA2F 03                       .
        bmi     LBA98                           ; BA30 30 66                    0f
        ror     $D9                             ; BA32 66 D9                    f.
        bmi     LBA66                           ; BA34 30 30                    00
        bmi     LBA68                           ; BA36 30 30                    00
        ora     $0403,x                         ; BA38 1D 03 04                 ...
        .byte   $03                             ; BA3B 03                       .
        .byte   $04                             ; BA3C 04                       .
        .byte   $03                             ; BA3D 03                       .
        .byte   $03                             ; BA3E 03                       .
        .byte   $03                             ; BA3F 03                       .
        .byte   $03                             ; BA40 03                       .
        .byte   $03                             ; BA41 03                       .
        .byte   $03                             ; BA42 03                       .
        .byte   $03                             ; BA43 03                       .
        .byte   $03                             ; BA44 03                       .
        .byte   $03                             ; BA45 03                       .
        .byte   $03                             ; BA46 03                       .
        .byte   $03                             ; BA47 03                       .
        .byte   $03                             ; BA48 03                       .
        .byte   $03                             ; BA49 03                       .
        .byte   $03                             ; BA4A 03                       .
        .byte   $03                             ; BA4B 03                       .
        .byte   $03                             ; BA4C 03                       .
        .byte   $03                             ; BA4D 03                       .
        .byte   $DA                             ; BA4E DA                       .
        .byte   $DB                             ; BA4F DB                       .
        .byte   $03                             ; BA50 03                       .
        .byte   $03                             ; BA51 03                       .
        .byte   $03                             ; BA52 03                       .
        .byte   $03                             ; BA53 03                       .
        .byte   $03                             ; BA54 03                       .
        .byte   $03                             ; BA55 03                       .
        .byte   $03                             ; BA56 03                       .
        .byte   $03                             ; BA57 03                       .
        .byte   $03                             ; BA58 03                       .
        .byte   $03                             ; BA59 03                       .
        .byte   $03                             ; BA5A 03                       .
        .byte   $03                             ; BA5B 03                       .
        .byte   $03                             ; BA5C 03                       .
        .byte   $03                             ; BA5D 03                       .
        .byte   $03                             ; BA5E 03                       .
        .byte   $03                             ; BA5F 03                       .
        .byte   $03                             ; BA60 03                       .
        .byte   $03                             ; BA61 03                       .
        .byte   $03                             ; BA62 03                       .
        .byte   $03                             ; BA63 03                       .
        .byte   $03                             ; BA64 03                       .
        .byte   $03                             ; BA65 03                       .
LBA66:  .byte   $03                             ; BA66 03                       .
        .byte   $03                             ; BA67 03                       .
LBA68:  .byte   $03                             ; BA68 03                       .
        .byte   $03                             ; BA69 03                       .
        .byte   $03                             ; BA6A 03                       .
        .byte   $03                             ; BA6B 03                       .
        .byte   $03                             ; BA6C 03                       .
        .byte   $03                             ; BA6D 03                       .
        .byte   $03                             ; BA6E 03                       .
        .byte   $03                             ; BA6F 03                       .
        .byte   $D7                             ; BA70 D7                       .
        .byte   $D7                             ; BA71 D7                       .
        .byte   $D7                             ; BA72 D7                       .
        .byte   $D7                             ; BA73 D7                       .
        ror     $66                             ; BA74 66 66                    ff
        ror     $66                             ; BA76 66 66                    ff
        .byte   $03                             ; BA78 03                       .
        .byte   $03                             ; BA79 03                       .
        .byte   $03                             ; BA7A 03                       .
        .byte   $03                             ; BA7B 03                       .
        .byte   $03                             ; BA7C 03                       .
        .byte   $03                             ; BA7D 03                       .
        .byte   $03                             ; BA7E 03                       .
        .byte   $03                             ; BA7F 03                       .
        .byte   $03                             ; BA80 03                       .
        .byte   $03                             ; BA81 03                       .
        .byte   $03                             ; BA82 03                       .
        .byte   $03                             ; BA83 03                       .
        .byte   $03                             ; BA84 03                       .
        .byte   $03                             ; BA85 03                       .
        .byte   $03                             ; BA86 03                       .
        .byte   $03                             ; BA87 03                       .
        .byte   $DC                             ; BA88 DC                       .
        .byte   $03                             ; BA89 03                       .
        .byte   $03                             ; BA8A 03                       .
        .byte   $03                             ; BA8B 03                       .
        .byte   $03                             ; BA8C 03                       .
        cmp     $DFDE,x                         ; BA8D DD DE DF                 ...
        .byte   $03                             ; BA90 03                       .
        .byte   $03                             ; BA91 03                       .
        .byte   $DA                             ; BA92 DA                       .
        .byte   $DB                             ; BA93 DB                       .
        .byte   $DC                             ; BA94 DC                       .
        .byte   $03                             ; BA95 03                       .
        .byte   $03                             ; BA96 03                       .
        .byte   $03                             ; BA97 03                       .
LBA98:  .byte   $03                             ; BA98 03                       .
        .byte   $03                             ; BA99 03                       .
        .byte   $03                             ; BA9A 03                       .
        .byte   $03                             ; BA9B 03                       .
        .byte   $03                             ; BA9C 03                       .
        .byte   $03                             ; BA9D 03                       .
        .byte   $03                             ; BA9E 03                       .
        .byte   $03                             ; BA9F 03                       .
        .byte   $03                             ; BAA0 03                       .
        .byte   $03                             ; BAA1 03                       .
        .byte   $03                             ; BAA2 03                       .
        .byte   $03                             ; BAA3 03                       .
        .byte   $03                             ; BAA4 03                       .
        .byte   $03                             ; BAA5 03                       .
        .byte   $03                             ; BAA6 03                       .
        .byte   $03                             ; BAA7 03                       .
        .byte   $03                             ; BAA8 03                       .
        .byte   $03                             ; BAA9 03                       .
        .byte   $03                             ; BAAA 03                       .
        .byte   $03                             ; BAAB 03                       .
        .byte   $03                             ; BAAC 03                       .
        .byte   $03                             ; BAAD 03                       .
        .byte   $03                             ; BAAE 03                       .
        .byte   $03                             ; BAAF 03                       .
        ror     $66                             ; BAB0 66 66                    ff
        ror     $66                             ; BAB2 66 66                    ff
        ror     $66                             ; BAB4 66 66                    ff
        ror     $66                             ; BAB6 66 66                    ff
        .byte   $03                             ; BAB8 03                       .
        .byte   $03                             ; BAB9 03                       .
        .byte   $03                             ; BABA 03                       .
        .byte   $03                             ; BABB 03                       .
        .byte   $03                             ; BABC 03                       .
        .byte   $03                             ; BABD 03                       .
        .byte   $03                             ; BABE 03                       .
        .byte   $03                             ; BABF 03                       .
        .byte   $03                             ; BAC0 03                       .
        .byte   $03                             ; BAC1 03                       .
        .byte   $03                             ; BAC2 03                       .
        .byte   $03                             ; BAC3 03                       .
        .byte   $03                             ; BAC4 03                       .
        .byte   $03                             ; BAC5 03                       .
        .byte   $03                             ; BAC6 03                       .
        .byte   $03                             ; BAC7 03                       .
        .byte   $03                             ; BAC8 03                       .
        .byte   $03                             ; BAC9 03                       .
        .byte   $03                             ; BACA 03                       .
        .byte   $03                             ; BACB 03                       .
        .byte   $03                             ; BACC 03                       .
        .byte   $03                             ; BACD 03                       .
        .byte   $03                             ; BACE 03                       .
        .byte   $03                             ; BACF 03                       .
        .byte   $03                             ; BAD0 03                       .
        .byte   $03                             ; BAD1 03                       .
        .byte   $DA                             ; BAD2 DA                       .
        .byte   $DC                             ; BAD3 DC                       .
        .byte   $03                             ; BAD4 03                       .
        .byte   $03                             ; BAD5 03                       .
        .byte   $03                             ; BAD6 03                       .
        .byte   $03                             ; BAD7 03                       .
        .byte   $03                             ; BAD8 03                       .
        .byte   $03                             ; BAD9 03                       .
        .byte   $03                             ; BADA 03                       .
        .byte   $03                             ; BADB 03                       .
        .byte   $03                             ; BADC 03                       .
        .byte   $03                             ; BADD 03                       .
        .byte   $03                             ; BADE 03                       .
        .byte   $03                             ; BADF 03                       .
        .byte   $03                             ; BAE0 03                       .
        .byte   $03                             ; BAE1 03                       .
        .byte   $03                             ; BAE2 03                       .
        .byte   $03                             ; BAE3 03                       .
        .byte   $03                             ; BAE4 03                       .
        .byte   $03                             ; BAE5 03                       .
        .byte   $03                             ; BAE6 03                       .
        .byte   $03                             ; BAE7 03                       .
        .byte   $03                             ; BAE8 03                       .
        .byte   $03                             ; BAE9 03                       .
        .byte   $03                             ; BAEA 03                       .
        .byte   $03                             ; BAEB 03                       .
        .byte   $03                             ; BAEC 03                       .
        .byte   $03                             ; BAED 03                       .
        asl     $660E                           ; BAEE 0E 0E 66                 ..f
        ror     $66                             ; BAF1 66 66                    ff
        ror     $66                             ; BAF3 66 66                    ff
        ror     $10                             ; BAF5 66 10                    f.
        bpl     LBAFC                           ; BAF7 10 03                    ..
        .byte   $03                             ; BAF9 03                       .
        .byte   $03                             ; BAFA 03                       .
        .byte   $03                             ; BAFB 03                       .
LBAFC:  .byte   $03                             ; BAFC 03                       .
        .byte   $03                             ; BAFD 03                       .
        .byte   $03                             ; BAFE 03                       .
        .byte   $03                             ; BAFF 03                       .
        .byte   $03                             ; BB00 03                       .
        .byte   $03                             ; BB01 03                       .
        .byte   $1C                             ; BB02 1C                       .
        .byte   $13                             ; BB03 13                       .
        cpx     #$24                            ; BB04 E0 24                    .$
        .byte   $80                             ; BB06 80                       .
        .byte   $1C                             ; BB07 1C                       .
        .byte   $03                             ; BB08 03                       .
        ora     $E1                             ; BB09 05 E1                    ..
        .byte   $E2                             ; BB0B E2                       .
        .byte   $E3                             ; BB0C E3                       .
        cpx     $E5                             ; BB0D E4 E5                    ..
        .byte   $1C                             ; BB0F 1C                       .
        ora     $03                             ; BB10 05 03                    ..
        .byte   $33                             ; BB12 33                       3
        .byte   $33                             ; BB13 33                       3
        .byte   $33                             ; BB14 33                       3
        .byte   $33                             ; BB15 33                       3
        .byte   $33                             ; BB16 33                       3
        .byte   $1C                             ; BB17 1C                       .
        .byte   $03                             ; BB18 03                       .
        .byte   $03                             ; BB19 03                       .
        .byte   $04                             ; BB1A 04                       .
        ora     $03                             ; BB1B 05 03                    ..
        ora     $7332,x                         ; BB1D 1D 32 73                 .2s
        .byte   $04                             ; BB20 04                       .
        .byte   $03                             ; BB21 03                       .
        ora     $0403,x                         ; BB22 1D 03 04                 ...
        .byte   $03                             ; BB25 03                       .
        ora     $0EE6,x                         ; BB26 1D E6 0E                 ...
        asl     $0E03                           ; BB29 0E 03 0E                 ...
        asl     $0E0E                           ; BB2C 0E 0E 0E                 ...
        .byte   $E7                             ; BB2F E7                       .
        bpl     LBB42                           ; BB30 10 10                    ..
        ror     $10                             ; BB32 66 10                    f.
        bpl     LBB46                           ; BB34 10 10                    ..
        bpl     LBB48                           ; BB36 10 10                    ..
        .byte   $03                             ; BB38 03                       .
        .byte   $03                             ; BB39 03                       .
        ora     $03                             ; BB3A 05 03                    ..
        .byte   $03                             ; BB3C 03                       .
        .byte   $04                             ; BB3D 04                       .
        .byte   $03                             ; BB3E 03                       .
        .byte   $03                             ; BB3F 03                       .
        .byte   $1C                             ; BB40 1C                       .
        .byte   $E0                             ; BB41 E0                       .
LBB42:  .byte   $1C                             ; BB42 1C                       .
        inx                                     ; BB43 E8                       .
        sbc     #$1C                            ; BB44 E9 1C                    ..
LBB46:  cpx     #$1C                            ; BB46 E0 1C                    ..
LBB48:  .byte   $1C                             ; BB48 1C                       .
        cpx     #$1C                            ; BB49 E0 1C                    ..
        nop                                     ; BB4B EA                       .
        .byte   $EB                             ; BB4C EB                       .
        .byte   $1C                             ; BB4D 1C                       .
        cpx     #$1C                            ; BB4E E0 1C                    ..
        .byte   $1C                             ; BB50 1C                       .
        cpx     #$1C                            ; BB51 E0 1C                    ..
        cpx     $1CED                           ; BB53 EC ED 1C                 ...
        cpx     #$1C                            ; BB56 E0 1C                    ..
        .byte   $73                             ; BB58 73                       s
        inc     $EF73                           ; BB59 EE 73 EF                 .s.
        beq     LBBD1                           ; BB5C F0 73                    .s
        inc     $F173                           ; BB5E EE 73 F1                 .s.
        .byte   $F2                             ; BB61 F2                       .
        .byte   $F2                             ; BB62 F2                       .
        sbc     ($F2),y                         ; BB63 F1 F2                    ..
        sbc     ($F2),y                         ; BB65 F1 F2                    ..
        .byte   $F3                             ; BB67 F3                       .
        sty     $7676                           ; BB68 8C 76 76                 .vv
        ror     $76,x                           ; BB6B 76 76                    vv
        ror     $76,x                           ; BB6D 76 76                    vv
        .byte   $F4                             ; BB6F F4                       .
        bpl     LBB82                           ; BB70 10 10                    ..
        bpl     LBB84                           ; BB72 10 10                    ..
        bpl     LBB86                           ; BB74 10 10                    ..
        bpl     LBB88                           ; BB76 10 10                    ..
        .byte   $03                             ; BB78 03                       .
        .byte   $03                             ; BB79 03                       .
        .byte   $04                             ; BB7A 04                       .
        .byte   $03                             ; BB7B 03                       .
        .byte   $04                             ; BB7C 04                       .
        .byte   $03                             ; BB7D 03                       .
LBB7E:  ora     $F503,x                         ; BB7E 1D 03 F5                 ...
        .byte   $30                             ; BB81 30                       0
LBB82:  bmi     LBBB4                           ; BB82 30 30                    00
LBB84:  bmi     LBBB6                           ; BB84 30 30                    00
LBB86:  bmi     LBB7E                           ; BB86 30 F6                    0.
LBB88:  .byte   $F7                             ; BB88 F7                       .
        bvs     LBBFC                           ; BB89 70 71                    pq
        bvs     LBBFD                           ; BB8B 70 70                    pp
        adc     ($70),y                         ; BB8D 71 70                    qp
        sed                                     ; BB8F F8                       .
        sbc     $778C,y                         ; BB90 F9 8C 77                 ..w
        sty     $778C                           ; BB93 8C 8C 77                 ..w
        sty     $FBFA                           ; BB96 8C FA FB                 ...
        sty     $8C77                           ; BB99 8C 77 8C                 .w.
        sty     $8C77                           ; BB9C 8C 77 8C                 .w.
        .byte   $FA                             ; BB9F FA                       .
        .byte   $FC                             ; BBA0 FC                       .
        sty     $8C77                           ; BBA1 8C 77 8C                 .w.
        sty     $8C77                           ; BBA4 8C 77 8C                 .w.
        .byte   $FA                             ; BBA7 FA                       .
        sty     $7776                           ; BBA8 8C 76 77                 .vw
        ror     $76,x                           ; BBAB 76 76                    vv
        .byte   $77                             ; BBAD 77                       w
        ror     $FA,x                           ; BBAE 76 FA                    v.
        bpl     LBBC2                           ; BBB0 10 10                    ..
        bpl     LBBC4                           ; BBB2 10 10                    ..
LBBB4:  .byte   $10                             ; BBB4 10                       .
LBBB5:  .byte   $10                             ; BBB5 10                       .
LBBB6:  bpl     LBBB5                           ; BBB6 10 FD                    ..
        .byte   $32                             ; BBB8 32                       2
        .byte   $03                             ; BBB9 03                       .
        .byte   $04                             ; BBBA 04                       .
        ora     $32                             ; BBBB 05 32                    .2
        .byte   $04                             ; BBBD 04                       .
        .byte   $03                             ; BBBE 03                       .
        inc     $0303,x                         ; BBBF FE 03 03                 ...
LBBC2:  .byte   $03                             ; BBC2 03                       .
        .byte   $03                             ; BBC3 03                       .
LBBC4:  .byte   $03                             ; BBC4 03                       .
        .byte   $03                             ; BBC5 03                       .
LBBC6:  .byte   $03                             ; BBC6 03                       .
        .byte   $03                             ; BBC7 03                       .
        .byte   $03                             ; BBC8 03                       .
        .byte   $03                             ; BBC9 03                       .
        .byte   $03                             ; BBCA 03                       .
        .byte   $03                             ; BBCB 03                       .
        .byte   $03                             ; BBCC 03                       .
        .byte   $03                             ; BBCD 03                       .
        .byte   $03                             ; BBCE 03                       .
        .byte   $03                             ; BBCF 03                       .
        .byte   $03                             ; BBD0 03                       .
LBBD1:  .byte   $03                             ; BBD1 03                       .
        .byte   $03                             ; BBD2 03                       .
        .byte   $03                             ; BBD3 03                       .
        .byte   $03                             ; BBD4 03                       .
        .byte   $03                             ; BBD5 03                       .
        .byte   $03                             ; BBD6 03                       .
        .byte   $03                             ; BBD7 03                       .
        .byte   $03                             ; BBD8 03                       .
        .byte   $03                             ; BBD9 03                       .
        .byte   $03                             ; BBDA 03                       .
        .byte   $03                             ; BBDB 03                       .
        .byte   $03                             ; BBDC 03                       .
        .byte   $03                             ; BBDD 03                       .
        .byte   $03                             ; BBDE 03                       .
        .byte   $03                             ; BBDF 03                       .
        .byte   $03                             ; BBE0 03                       .
        .byte   $03                             ; BBE1 03                       .
        .byte   $03                             ; BBE2 03                       .
        .byte   $03                             ; BBE3 03                       .
        .byte   $03                             ; BBE4 03                       .
        .byte   $03                             ; BBE5 03                       .
        .byte   $03                             ; BBE6 03                       .
        .byte   $03                             ; BBE7 03                       .
        .byte   $03                             ; BBE8 03                       .
        .byte   $03                             ; BBE9 03                       .
        .byte   $03                             ; BBEA 03                       .
        .byte   $03                             ; BBEB 03                       .
        .byte   $03                             ; BBEC 03                       .
        .byte   $03                             ; BBED 03                       .
        .byte   $03                             ; BBEE 03                       .
        .byte   $03                             ; BBEF 03                       .
        .byte   $03                             ; BBF0 03                       .
        .byte   $03                             ; BBF1 03                       .
        .byte   $03                             ; BBF2 03                       .
        .byte   $03                             ; BBF3 03                       .
        .byte   $03                             ; BBF4 03                       .
        .byte   $03                             ; BBF5 03                       .
        .byte   $03                             ; BBF6 03                       .
        .byte   $03                             ; BBF7 03                       .
        .byte   $03                             ; BBF8 03                       .
        .byte   $03                             ; BBF9 03                       .
        .byte   $03                             ; BBFA 03                       .
        .byte   $03                             ; BBFB 03                       .
LBBFC:  .byte   $03                             ; BBFC 03                       .
LBBFD:  .byte   $03                             ; BBFD 03                       .
        .byte   $03                             ; BBFE 03                       .
        .byte   $03                             ; BBFF 03                       .
        .byte   $03                             ; BC00 03                       .
        .byte   $03                             ; BC01 03                       .
        .byte   $03                             ; BC02 03                       .
        .byte   $03                             ; BC03 03                       .
        .byte   $03                             ; BC04 03                       .
        .byte   $03                             ; BC05 03                       .
        .byte   $03                             ; BC06 03                       .
        .byte   $03                             ; BC07 03                       .
        .byte   $03                             ; BC08 03                       .
        .byte   $03                             ; BC09 03                       .
        .byte   $03                             ; BC0A 03                       .
        .byte   $03                             ; BC0B 03                       .
        .byte   $03                             ; BC0C 03                       .
        .byte   $03                             ; BC0D 03                       .
        .byte   $03                             ; BC0E 03                       .
        .byte   $03                             ; BC0F 03                       .
        .byte   $03                             ; BC10 03                       .
        .byte   $03                             ; BC11 03                       .
        .byte   $03                             ; BC12 03                       .
        .byte   $03                             ; BC13 03                       .
        .byte   $03                             ; BC14 03                       .
        .byte   $03                             ; BC15 03                       .
        .byte   $03                             ; BC16 03                       .
        .byte   $03                             ; BC17 03                       .
        .byte   $03                             ; BC18 03                       .
        .byte   $03                             ; BC19 03                       .
        .byte   $03                             ; BC1A 03                       .
        .byte   $03                             ; BC1B 03                       .
        .byte   $03                             ; BC1C 03                       .
        .byte   $03                             ; BC1D 03                       .
        .byte   $03                             ; BC1E 03                       .
        .byte   $03                             ; BC1F 03                       .
        .byte   $03                             ; BC20 03                       .
        .byte   $03                             ; BC21 03                       .
        .byte   $03                             ; BC22 03                       .
        .byte   $03                             ; BC23 03                       .
        .byte   $03                             ; BC24 03                       .
        .byte   $03                             ; BC25 03                       .
        .byte   $03                             ; BC26 03                       .
        .byte   $03                             ; BC27 03                       .
        .byte   $03                             ; BC28 03                       .
        .byte   $03                             ; BC29 03                       .
        .byte   $03                             ; BC2A 03                       .
        .byte   $03                             ; BC2B 03                       .
        .byte   $03                             ; BC2C 03                       .
        .byte   $03                             ; BC2D 03                       .
        .byte   $03                             ; BC2E 03                       .
        .byte   $03                             ; BC2F 03                       .
        .byte   $03                             ; BC30 03                       .
        .byte   $03                             ; BC31 03                       .
        .byte   $03                             ; BC32 03                       .
        .byte   $03                             ; BC33 03                       .
        .byte   $03                             ; BC34 03                       .
        .byte   $03                             ; BC35 03                       .
        .byte   $03                             ; BC36 03                       .
        .byte   $03                             ; BC37 03                       .
        .byte   $03                             ; BC38 03                       .
        .byte   $03                             ; BC39 03                       .
        .byte   $03                             ; BC3A 03                       .
        .byte   $03                             ; BC3B 03                       .
        .byte   $03                             ; BC3C 03                       .
        .byte   $03                             ; BC3D 03                       .
        .byte   $03                             ; BC3E 03                       .
        .byte   $03                             ; BC3F 03                       .
        .byte   $03                             ; BC40 03                       .
        .byte   $03                             ; BC41 03                       .
        .byte   $03                             ; BC42 03                       .
        .byte   $03                             ; BC43 03                       .
        .byte   $03                             ; BC44 03                       .
        .byte   $03                             ; BC45 03                       .
        .byte   $03                             ; BC46 03                       .
LBC47:  .byte   $03                             ; BC47 03                       .
        .byte   $03                             ; BC48 03                       .
        .byte   $03                             ; BC49 03                       .
        .byte   $03                             ; BC4A 03                       .
        .byte   $03                             ; BC4B 03                       .
        .byte   $03                             ; BC4C 03                       .
        .byte   $03                             ; BC4D 03                       .
        .byte   $03                             ; BC4E 03                       .
        .byte   $03                             ; BC4F 03                       .
        .byte   $03                             ; BC50 03                       .
        .byte   $03                             ; BC51 03                       .
        .byte   $03                             ; BC52 03                       .
        .byte   $03                             ; BC53 03                       .
        .byte   $03                             ; BC54 03                       .
        .byte   $03                             ; BC55 03                       .
        .byte   $03                             ; BC56 03                       .
        .byte   $03                             ; BC57 03                       .
        .byte   $03                             ; BC58 03                       .
        .byte   $03                             ; BC59 03                       .
        .byte   $03                             ; BC5A 03                       .
        .byte   $03                             ; BC5B 03                       .
        .byte   $03                             ; BC5C 03                       .
        .byte   $03                             ; BC5D 03                       .
        .byte   $03                             ; BC5E 03                       .
        .byte   $03                             ; BC5F 03                       .
        .byte   $03                             ; BC60 03                       .
        .byte   $03                             ; BC61 03                       .
        .byte   $03                             ; BC62 03                       .
        .byte   $03                             ; BC63 03                       .
        .byte   $03                             ; BC64 03                       .
        .byte   $03                             ; BC65 03                       .
        .byte   $03                             ; BC66 03                       .
        .byte   $03                             ; BC67 03                       .
        .byte   $03                             ; BC68 03                       .
        .byte   $03                             ; BC69 03                       .
        .byte   $03                             ; BC6A 03                       .
        .byte   $03                             ; BC6B 03                       .
        .byte   $03                             ; BC6C 03                       .
        .byte   $03                             ; BC6D 03                       .
        .byte   $03                             ; BC6E 03                       .
        .byte   $03                             ; BC6F 03                       .
        .byte   $03                             ; BC70 03                       .
        .byte   $03                             ; BC71 03                       .
        .byte   $03                             ; BC72 03                       .
        .byte   $03                             ; BC73 03                       .
        .byte   $03                             ; BC74 03                       .
        .byte   $03                             ; BC75 03                       .
        .byte   $03                             ; BC76 03                       .
        .byte   $03                             ; BC77 03                       .
        .byte   $03                             ; BC78 03                       .
        .byte   $03                             ; BC79 03                       .
        .byte   $03                             ; BC7A 03                       .
        .byte   $03                             ; BC7B 03                       .
        .byte   $03                             ; BC7C 03                       .
        .byte   $03                             ; BC7D 03                       .
        .byte   $03                             ; BC7E 03                       .
        .byte   $03                             ; BC7F 03                       .
        .byte   $03                             ; BC80 03                       .
        .byte   $03                             ; BC81 03                       .
        .byte   $03                             ; BC82 03                       .
        .byte   $03                             ; BC83 03                       .
        .byte   $03                             ; BC84 03                       .
        .byte   $03                             ; BC85 03                       .
        .byte   $03                             ; BC86 03                       .
        .byte   $03                             ; BC87 03                       .
        .byte   $03                             ; BC88 03                       .
        .byte   $03                             ; BC89 03                       .
        .byte   $03                             ; BC8A 03                       .
        .byte   $03                             ; BC8B 03                       .
        .byte   $03                             ; BC8C 03                       .
        .byte   $03                             ; BC8D 03                       .
LBC8E:  .byte   $03                             ; BC8E 03                       .
        .byte   $03                             ; BC8F 03                       .
        .byte   $03                             ; BC90 03                       .
        .byte   $03                             ; BC91 03                       .
        .byte   $03                             ; BC92 03                       .
        .byte   $03                             ; BC93 03                       .
        .byte   $03                             ; BC94 03                       .
        .byte   $03                             ; BC95 03                       .
        .byte   $03                             ; BC96 03                       .
        .byte   $03                             ; BC97 03                       .
        .byte   $03                             ; BC98 03                       .
        .byte   $03                             ; BC99 03                       .
        .byte   $03                             ; BC9A 03                       .
        .byte   $03                             ; BC9B 03                       .
        .byte   $03                             ; BC9C 03                       .
        .byte   $03                             ; BC9D 03                       .
        .byte   $03                             ; BC9E 03                       .
        .byte   $03                             ; BC9F 03                       .
        .byte   $03                             ; BCA0 03                       .
        .byte   $03                             ; BCA1 03                       .
        .byte   $03                             ; BCA2 03                       .
        .byte   $03                             ; BCA3 03                       .
        .byte   $03                             ; BCA4 03                       .
        .byte   $03                             ; BCA5 03                       .
        .byte   $03                             ; BCA6 03                       .
        .byte   $03                             ; BCA7 03                       .
        .byte   $03                             ; BCA8 03                       .
        .byte   $03                             ; BCA9 03                       .
        .byte   $03                             ; BCAA 03                       .
        .byte   $03                             ; BCAB 03                       .
        .byte   $03                             ; BCAC 03                       .
        .byte   $03                             ; BCAD 03                       .
        .byte   $03                             ; BCAE 03                       .
        .byte   $03                             ; BCAF 03                       .
        .byte   $03                             ; BCB0 03                       .
        .byte   $03                             ; BCB1 03                       .
        .byte   $03                             ; BCB2 03                       .
        .byte   $03                             ; BCB3 03                       .
        .byte   $03                             ; BCB4 03                       .
        .byte   $03                             ; BCB5 03                       .
        .byte   $03                             ; BCB6 03                       .
        .byte   $03                             ; BCB7 03                       .
        .byte   $03                             ; BCB8 03                       .
        .byte   $03                             ; BCB9 03                       .
        .byte   $03                             ; BCBA 03                       .
LBCBB:  .byte   $03                             ; BCBB 03                       .
        .byte   $03                             ; BCBC 03                       .
        .byte   $03                             ; BCBD 03                       .
        .byte   $03                             ; BCBE 03                       .
        .byte   $03                             ; BCBF 03                       .
        .byte   $03                             ; BCC0 03                       .
        .byte   $03                             ; BCC1 03                       .
        .byte   $03                             ; BCC2 03                       .
        .byte   $03                             ; BCC3 03                       .
        .byte   $03                             ; BCC4 03                       .
        .byte   $03                             ; BCC5 03                       .
        .byte   $03                             ; BCC6 03                       .
        .byte   $03                             ; BCC7 03                       .
        .byte   $03                             ; BCC8 03                       .
        .byte   $03                             ; BCC9 03                       .
        .byte   $03                             ; BCCA 03                       .
        .byte   $03                             ; BCCB 03                       .
        .byte   $03                             ; BCCC 03                       .
        .byte   $03                             ; BCCD 03                       .
        .byte   $03                             ; BCCE 03                       .
        .byte   $03                             ; BCCF 03                       .
        .byte   $03                             ; BCD0 03                       .
        .byte   $03                             ; BCD1 03                       .
        .byte   $03                             ; BCD2 03                       .
        .byte   $03                             ; BCD3 03                       .
        .byte   $03                             ; BCD4 03                       .
        .byte   $03                             ; BCD5 03                       .
        .byte   $03                             ; BCD6 03                       .
        .byte   $03                             ; BCD7 03                       .
        .byte   $03                             ; BCD8 03                       .
        .byte   $03                             ; BCD9 03                       .
        .byte   $03                             ; BCDA 03                       .
        .byte   $03                             ; BCDB 03                       .
        .byte   $03                             ; BCDC 03                       .
        .byte   $03                             ; BCDD 03                       .
        .byte   $03                             ; BCDE 03                       .
        .byte   $03                             ; BCDF 03                       .
        .byte   $03                             ; BCE0 03                       .
        .byte   $03                             ; BCE1 03                       .
        .byte   $03                             ; BCE2 03                       .
        .byte   $03                             ; BCE3 03                       .
        .byte   $03                             ; BCE4 03                       .
        .byte   $03                             ; BCE5 03                       .
        .byte   $03                             ; BCE6 03                       .
        .byte   $03                             ; BCE7 03                       .
        .byte   $03                             ; BCE8 03                       .
        .byte   $03                             ; BCE9 03                       .
        .byte   $03                             ; BCEA 03                       .
        .byte   $03                             ; BCEB 03                       .
        .byte   $03                             ; BCEC 03                       .
        .byte   $03                             ; BCED 03                       .
        .byte   $03                             ; BCEE 03                       .
        .byte   $03                             ; BCEF 03                       .
        .byte   $03                             ; BCF0 03                       .
        .byte   $03                             ; BCF1 03                       .
        .byte   $03                             ; BCF2 03                       .
LBCF3:  .byte   $03                             ; BCF3 03                       .
        .byte   $03                             ; BCF4 03                       .
        .byte   $03                             ; BCF5 03                       .
        .byte   $03                             ; BCF6 03                       .
        .byte   $03                             ; BCF7 03                       .
        .byte   $03                             ; BCF8 03                       .
LBCF9:  .byte   $03                             ; BCF9 03                       .
        .byte   $03                             ; BCFA 03                       .
        .byte   $03                             ; BCFB 03                       .
        .byte   $03                             ; BCFC 03                       .
LBCFD:  .byte   $03                             ; BCFD 03                       .
        .byte   $03                             ; BCFE 03                       .
        .byte   $03                             ; BCFF 03                       .
        .byte   $03                             ; BD00 03                       .
        .byte   $03                             ; BD01 03                       .
        .byte   $03                             ; BD02 03                       .
        .byte   $03                             ; BD03 03                       .
        .byte   $03                             ; BD04 03                       .
        .byte   $03                             ; BD05 03                       .
        .byte   $03                             ; BD06 03                       .
        .byte   $03                             ; BD07 03                       .
        .byte   $03                             ; BD08 03                       .
        .byte   $03                             ; BD09 03                       .
        .byte   $03                             ; BD0A 03                       .
        .byte   $03                             ; BD0B 03                       .
        .byte   $03                             ; BD0C 03                       .
        .byte   $03                             ; BD0D 03                       .
        .byte   $03                             ; BD0E 03                       .
        .byte   $03                             ; BD0F 03                       .
        .byte   $03                             ; BD10 03                       .
        .byte   $03                             ; BD11 03                       .
        .byte   $03                             ; BD12 03                       .
        .byte   $03                             ; BD13 03                       .
        .byte   $03                             ; BD14 03                       .
        .byte   $03                             ; BD15 03                       .
        .byte   $03                             ; BD16 03                       .
        .byte   $03                             ; BD17 03                       .
        .byte   $03                             ; BD18 03                       .
        .byte   $03                             ; BD19 03                       .
        .byte   $03                             ; BD1A 03                       .
        .byte   $03                             ; BD1B 03                       .
        .byte   $03                             ; BD1C 03                       .
        .byte   $03                             ; BD1D 03                       .
        .byte   $03                             ; BD1E 03                       .
        .byte   $03                             ; BD1F 03                       .
        .byte   $03                             ; BD20 03                       .
        .byte   $03                             ; BD21 03                       .
        .byte   $03                             ; BD22 03                       .
        .byte   $03                             ; BD23 03                       .
        .byte   $03                             ; BD24 03                       .
        .byte   $03                             ; BD25 03                       .
        .byte   $03                             ; BD26 03                       .
        .byte   $03                             ; BD27 03                       .
        .byte   $03                             ; BD28 03                       .
        .byte   $03                             ; BD29 03                       .
        .byte   $03                             ; BD2A 03                       .
        .byte   $03                             ; BD2B 03                       .
        .byte   $03                             ; BD2C 03                       .
        .byte   $03                             ; BD2D 03                       .
        .byte   $03                             ; BD2E 03                       .
        .byte   $03                             ; BD2F 03                       .
        .byte   $03                             ; BD30 03                       .
        .byte   $03                             ; BD31 03                       .
        .byte   $03                             ; BD32 03                       .
        .byte   $03                             ; BD33 03                       .
        .byte   $03                             ; BD34 03                       .
        .byte   $03                             ; BD35 03                       .
        .byte   $03                             ; BD36 03                       .
        .byte   $03                             ; BD37 03                       .
        .byte   $03                             ; BD38 03                       .
        .byte   $03                             ; BD39 03                       .
        .byte   $03                             ; BD3A 03                       .
        .byte   $03                             ; BD3B 03                       .
        .byte   $03                             ; BD3C 03                       .
        .byte   $03                             ; BD3D 03                       .
        .byte   $03                             ; BD3E 03                       .
        .byte   $03                             ; BD3F 03                       .
        .byte   $03                             ; BD40 03                       .
        .byte   $03                             ; BD41 03                       .
        .byte   $03                             ; BD42 03                       .
        .byte   $03                             ; BD43 03                       .
        .byte   $03                             ; BD44 03                       .
        .byte   $03                             ; BD45 03                       .
        .byte   $03                             ; BD46 03                       .
        .byte   $03                             ; BD47 03                       .
        .byte   $03                             ; BD48 03                       .
        .byte   $03                             ; BD49 03                       .
        .byte   $03                             ; BD4A 03                       .
LBD4B:  .byte   $03                             ; BD4B 03                       .
        .byte   $03                             ; BD4C 03                       .
        .byte   $03                             ; BD4D 03                       .
        .byte   $03                             ; BD4E 03                       .
        .byte   $03                             ; BD4F 03                       .
        .byte   $03                             ; BD50 03                       .
LBD51:  .byte   $03                             ; BD51 03                       .
        .byte   $03                             ; BD52 03                       .
        .byte   $03                             ; BD53 03                       .
        .byte   $03                             ; BD54 03                       .
        .byte   $03                             ; BD55 03                       .
        .byte   $03                             ; BD56 03                       .
        .byte   $03                             ; BD57 03                       .
        .byte   $03                             ; BD58 03                       .
        .byte   $03                             ; BD59 03                       .
        .byte   $03                             ; BD5A 03                       .
        .byte   $03                             ; BD5B 03                       .
        .byte   $03                             ; BD5C 03                       .
        .byte   $03                             ; BD5D 03                       .
        .byte   $03                             ; BD5E 03                       .
        .byte   $03                             ; BD5F 03                       .
        .byte   $03                             ; BD60 03                       .
        .byte   $03                             ; BD61 03                       .
        .byte   $03                             ; BD62 03                       .
        .byte   $03                             ; BD63 03                       .
        .byte   $03                             ; BD64 03                       .
        .byte   $03                             ; BD65 03                       .
        .byte   $03                             ; BD66 03                       .
        .byte   $03                             ; BD67 03                       .
        .byte   $03                             ; BD68 03                       .
        .byte   $03                             ; BD69 03                       .
        .byte   $03                             ; BD6A 03                       .
        .byte   $03                             ; BD6B 03                       .
        .byte   $03                             ; BD6C 03                       .
        .byte   $03                             ; BD6D 03                       .
        .byte   $03                             ; BD6E 03                       .
        .byte   $03                             ; BD6F 03                       .
        .byte   $03                             ; BD70 03                       .
        .byte   $03                             ; BD71 03                       .
        .byte   $03                             ; BD72 03                       .
        .byte   $03                             ; BD73 03                       .
        .byte   $03                             ; BD74 03                       .
        .byte   $03                             ; BD75 03                       .
        .byte   $03                             ; BD76 03                       .
        .byte   $03                             ; BD77 03                       .
        .byte   $03                             ; BD78 03                       .
        .byte   $03                             ; BD79 03                       .
        .byte   $03                             ; BD7A 03                       .
        .byte   $03                             ; BD7B 03                       .
        .byte   $03                             ; BD7C 03                       .
        .byte   $03                             ; BD7D 03                       .
        .byte   $03                             ; BD7E 03                       .
        .byte   $03                             ; BD7F 03                       .
        .byte   $03                             ; BD80 03                       .
        .byte   $03                             ; BD81 03                       .
        .byte   $03                             ; BD82 03                       .
        .byte   $03                             ; BD83 03                       .
        .byte   $03                             ; BD84 03                       .
        .byte   $03                             ; BD85 03                       .
        .byte   $03                             ; BD86 03                       .
        .byte   $03                             ; BD87 03                       .
        .byte   $03                             ; BD88 03                       .
        .byte   $03                             ; BD89 03                       .
        .byte   $03                             ; BD8A 03                       .
        .byte   $03                             ; BD8B 03                       .
        .byte   $03                             ; BD8C 03                       .
        .byte   $03                             ; BD8D 03                       .
        .byte   $03                             ; BD8E 03                       .
        .byte   $03                             ; BD8F 03                       .
        .byte   $03                             ; BD90 03                       .
        .byte   $03                             ; BD91 03                       .
        .byte   $03                             ; BD92 03                       .
        .byte   $03                             ; BD93 03                       .
        .byte   $03                             ; BD94 03                       .
        .byte   $03                             ; BD95 03                       .
        .byte   $03                             ; BD96 03                       .
        .byte   $03                             ; BD97 03                       .
        .byte   $03                             ; BD98 03                       .
        .byte   $03                             ; BD99 03                       .
        .byte   $03                             ; BD9A 03                       .
        .byte   $03                             ; BD9B 03                       .
        .byte   $03                             ; BD9C 03                       .
        .byte   $03                             ; BD9D 03                       .
        .byte   $03                             ; BD9E 03                       .
        .byte   $03                             ; BD9F 03                       .
        .byte   $03                             ; BDA0 03                       .
        .byte   $03                             ; BDA1 03                       .
        .byte   $03                             ; BDA2 03                       .
        .byte   $03                             ; BDA3 03                       .
        .byte   $03                             ; BDA4 03                       .
        .byte   $03                             ; BDA5 03                       .
        .byte   $03                             ; BDA6 03                       .
        .byte   $03                             ; BDA7 03                       .
        .byte   $03                             ; BDA8 03                       .
        .byte   $03                             ; BDA9 03                       .
        .byte   $03                             ; BDAA 03                       .
        .byte   $03                             ; BDAB 03                       .
        .byte   $03                             ; BDAC 03                       .
        .byte   $03                             ; BDAD 03                       .
        .byte   $03                             ; BDAE 03                       .
        .byte   $03                             ; BDAF 03                       .
        .byte   $03                             ; BDB0 03                       .
        .byte   $03                             ; BDB1 03                       .
        .byte   $03                             ; BDB2 03                       .
        .byte   $03                             ; BDB3 03                       .
        .byte   $03                             ; BDB4 03                       .
        .byte   $03                             ; BDB5 03                       .
        .byte   $03                             ; BDB6 03                       .
        .byte   $03                             ; BDB7 03                       .
        .byte   $03                             ; BDB8 03                       .
        .byte   $03                             ; BDB9 03                       .
        .byte   $03                             ; BDBA 03                       .
        .byte   $03                             ; BDBB 03                       .
        .byte   $03                             ; BDBC 03                       .
        .byte   $03                             ; BDBD 03                       .
        .byte   $03                             ; BDBE 03                       .
        .byte   $03                             ; BDBF 03                       .
        .byte   $03                             ; BDC0 03                       .
        .byte   $03                             ; BDC1 03                       .
        .byte   $03                             ; BDC2 03                       .
        .byte   $03                             ; BDC3 03                       .
        .byte   $03                             ; BDC4 03                       .
        .byte   $03                             ; BDC5 03                       .
        .byte   $03                             ; BDC6 03                       .
        .byte   $03                             ; BDC7 03                       .
        .byte   $03                             ; BDC8 03                       .
        .byte   $03                             ; BDC9 03                       .
        .byte   $03                             ; BDCA 03                       .
        .byte   $03                             ; BDCB 03                       .
        .byte   $03                             ; BDCC 03                       .
        .byte   $03                             ; BDCD 03                       .
        .byte   $03                             ; BDCE 03                       .
        .byte   $03                             ; BDCF 03                       .
        .byte   $03                             ; BDD0 03                       .
        .byte   $03                             ; BDD1 03                       .
        .byte   $03                             ; BDD2 03                       .
        .byte   $03                             ; BDD3 03                       .
        .byte   $03                             ; BDD4 03                       .
        .byte   $03                             ; BDD5 03                       .
        .byte   $03                             ; BDD6 03                       .
        .byte   $03                             ; BDD7 03                       .
        .byte   $03                             ; BDD8 03                       .
        .byte   $03                             ; BDD9 03                       .
        .byte   $03                             ; BDDA 03                       .
        .byte   $03                             ; BDDB 03                       .
        .byte   $03                             ; BDDC 03                       .
        .byte   $03                             ; BDDD 03                       .
        .byte   $03                             ; BDDE 03                       .
        .byte   $03                             ; BDDF 03                       .
        .byte   $03                             ; BDE0 03                       .
        .byte   $03                             ; BDE1 03                       .
        .byte   $03                             ; BDE2 03                       .
        .byte   $03                             ; BDE3 03                       .
        .byte   $03                             ; BDE4 03                       .
        .byte   $03                             ; BDE5 03                       .
        .byte   $03                             ; BDE6 03                       .
        .byte   $03                             ; BDE7 03                       .
        .byte   $03                             ; BDE8 03                       .
        .byte   $03                             ; BDE9 03                       .
        .byte   $03                             ; BDEA 03                       .
        .byte   $03                             ; BDEB 03                       .
        .byte   $03                             ; BDEC 03                       .
        .byte   $03                             ; BDED 03                       .
        .byte   $03                             ; BDEE 03                       .
        .byte   $03                             ; BDEF 03                       .
        .byte   $03                             ; BDF0 03                       .
        .byte   $03                             ; BDF1 03                       .
        .byte   $03                             ; BDF2 03                       .
        .byte   $03                             ; BDF3 03                       .
        .byte   $03                             ; BDF4 03                       .
        .byte   $03                             ; BDF5 03                       .
        .byte   $03                             ; BDF6 03                       .
        .byte   $03                             ; BDF7 03                       .
        .byte   $03                             ; BDF8 03                       .
        .byte   $03                             ; BDF9 03                       .
        .byte   $03                             ; BDFA 03                       .
        .byte   $03                             ; BDFB 03                       .
        .byte   $03                             ; BDFC 03                       .
        .byte   $03                             ; BDFD 03                       .
        .byte   $03                             ; BDFE 03                       .
        .byte   $03                             ; BDFF 03                       .
        .byte   $03                             ; BE00 03                       .
        .byte   $03                             ; BE01 03                       .
        .byte   $03                             ; BE02 03                       .
        .byte   $03                             ; BE03 03                       .
        .byte   $03                             ; BE04 03                       .
        .byte   $03                             ; BE05 03                       .
        .byte   $03                             ; BE06 03                       .
        .byte   $03                             ; BE07 03                       .
        .byte   $03                             ; BE08 03                       .
        .byte   $03                             ; BE09 03                       .
        .byte   $03                             ; BE0A 03                       .
        .byte   $03                             ; BE0B 03                       .
        .byte   $03                             ; BE0C 03                       .
        .byte   $03                             ; BE0D 03                       .
        .byte   $03                             ; BE0E 03                       .
        .byte   $03                             ; BE0F 03                       .
        .byte   $03                             ; BE10 03                       .
        .byte   $03                             ; BE11 03                       .
        .byte   $03                             ; BE12 03                       .
        .byte   $03                             ; BE13 03                       .
        .byte   $03                             ; BE14 03                       .
        .byte   $03                             ; BE15 03                       .
        .byte   $03                             ; BE16 03                       .
        .byte   $03                             ; BE17 03                       .
        .byte   $03                             ; BE18 03                       .
        .byte   $03                             ; BE19 03                       .
        .byte   $03                             ; BE1A 03                       .
        .byte   $03                             ; BE1B 03                       .
        .byte   $03                             ; BE1C 03                       .
        .byte   $03                             ; BE1D 03                       .
        .byte   $03                             ; BE1E 03                       .
        .byte   $03                             ; BE1F 03                       .
        .byte   $03                             ; BE20 03                       .
        .byte   $03                             ; BE21 03                       .
        .byte   $03                             ; BE22 03                       .
        .byte   $03                             ; BE23 03                       .
        .byte   $03                             ; BE24 03                       .
        .byte   $03                             ; BE25 03                       .
        .byte   $03                             ; BE26 03                       .
        .byte   $03                             ; BE27 03                       .
        .byte   $03                             ; BE28 03                       .
        .byte   $03                             ; BE29 03                       .
        .byte   $03                             ; BE2A 03                       .
        .byte   $03                             ; BE2B 03                       .
        .byte   $03                             ; BE2C 03                       .
        .byte   $03                             ; BE2D 03                       .
        .byte   $03                             ; BE2E 03                       .
        .byte   $03                             ; BE2F 03                       .
        .byte   $03                             ; BE30 03                       .
        .byte   $03                             ; BE31 03                       .
        .byte   $03                             ; BE32 03                       .
        .byte   $03                             ; BE33 03                       .
        .byte   $03                             ; BE34 03                       .
        .byte   $03                             ; BE35 03                       .
        .byte   $03                             ; BE36 03                       .
        .byte   $03                             ; BE37 03                       .
        .byte   $03                             ; BE38 03                       .
        .byte   $03                             ; BE39 03                       .
        .byte   $03                             ; BE3A 03                       .
        .byte   $03                             ; BE3B 03                       .
        .byte   $03                             ; BE3C 03                       .
        .byte   $03                             ; BE3D 03                       .
        .byte   $03                             ; BE3E 03                       .
        .byte   $03                             ; BE3F 03                       .
        .byte   $03                             ; BE40 03                       .
        .byte   $03                             ; BE41 03                       .
        .byte   $03                             ; BE42 03                       .
        .byte   $03                             ; BE43 03                       .
        .byte   $03                             ; BE44 03                       .
        .byte   $03                             ; BE45 03                       .
        .byte   $03                             ; BE46 03                       .
        .byte   $03                             ; BE47 03                       .
        .byte   $03                             ; BE48 03                       .
        .byte   $03                             ; BE49 03                       .
        .byte   $03                             ; BE4A 03                       .
        .byte   $03                             ; BE4B 03                       .
        .byte   $03                             ; BE4C 03                       .
        .byte   $03                             ; BE4D 03                       .
        .byte   $03                             ; BE4E 03                       .
        .byte   $03                             ; BE4F 03                       .
        .byte   $03                             ; BE50 03                       .
        .byte   $03                             ; BE51 03                       .
        .byte   $03                             ; BE52 03                       .
        .byte   $03                             ; BE53 03                       .
        .byte   $03                             ; BE54 03                       .
        .byte   $03                             ; BE55 03                       .
        .byte   $03                             ; BE56 03                       .
        .byte   $03                             ; BE57 03                       .
        .byte   $03                             ; BE58 03                       .
        .byte   $03                             ; BE59 03                       .
        .byte   $03                             ; BE5A 03                       .
        .byte   $03                             ; BE5B 03                       .
        .byte   $03                             ; BE5C 03                       .
        .byte   $03                             ; BE5D 03                       .
        .byte   $03                             ; BE5E 03                       .
        .byte   $03                             ; BE5F 03                       .
        .byte   $03                             ; BE60 03                       .
        .byte   $03                             ; BE61 03                       .
        .byte   $03                             ; BE62 03                       .
        .byte   $03                             ; BE63 03                       .
        .byte   $03                             ; BE64 03                       .
        .byte   $03                             ; BE65 03                       .
        .byte   $03                             ; BE66 03                       .
        .byte   $03                             ; BE67 03                       .
        .byte   $03                             ; BE68 03                       .
        .byte   $03                             ; BE69 03                       .
        .byte   $03                             ; BE6A 03                       .
        .byte   $03                             ; BE6B 03                       .
        .byte   $03                             ; BE6C 03                       .
        .byte   $03                             ; BE6D 03                       .
        .byte   $03                             ; BE6E 03                       .
        .byte   $03                             ; BE6F 03                       .
        .byte   $03                             ; BE70 03                       .
        .byte   $03                             ; BE71 03                       .
        .byte   $03                             ; BE72 03                       .
        .byte   $03                             ; BE73 03                       .
        .byte   $03                             ; BE74 03                       .
        .byte   $03                             ; BE75 03                       .
        .byte   $03                             ; BE76 03                       .
        .byte   $03                             ; BE77 03                       .
        .byte   $03                             ; BE78 03                       .
        .byte   $03                             ; BE79 03                       .
        .byte   $03                             ; BE7A 03                       .
        .byte   $03                             ; BE7B 03                       .
        .byte   $03                             ; BE7C 03                       .
        .byte   $03                             ; BE7D 03                       .
        .byte   $03                             ; BE7E 03                       .
        .byte   $03                             ; BE7F 03                       .
        .byte   $03                             ; BE80 03                       .
        .byte   $03                             ; BE81 03                       .
        .byte   $03                             ; BE82 03                       .
        .byte   $03                             ; BE83 03                       .
        .byte   $03                             ; BE84 03                       .
        .byte   $03                             ; BE85 03                       .
        .byte   $03                             ; BE86 03                       .
        .byte   $03                             ; BE87 03                       .
        .byte   $03                             ; BE88 03                       .
        .byte   $03                             ; BE89 03                       .
        .byte   $03                             ; BE8A 03                       .
        .byte   $03                             ; BE8B 03                       .
        .byte   $03                             ; BE8C 03                       .
        .byte   $03                             ; BE8D 03                       .
        .byte   $03                             ; BE8E 03                       .
        .byte   $03                             ; BE8F 03                       .
        .byte   $03                             ; BE90 03                       .
        .byte   $03                             ; BE91 03                       .
        .byte   $03                             ; BE92 03                       .
        .byte   $03                             ; BE93 03                       .
        .byte   $03                             ; BE94 03                       .
        .byte   $03                             ; BE95 03                       .
        .byte   $03                             ; BE96 03                       .
        .byte   $03                             ; BE97 03                       .
        .byte   $03                             ; BE98 03                       .
        .byte   $03                             ; BE99 03                       .
        .byte   $03                             ; BE9A 03                       .
        .byte   $03                             ; BE9B 03                       .
        .byte   $03                             ; BE9C 03                       .
        .byte   $03                             ; BE9D 03                       .
        .byte   $03                             ; BE9E 03                       .
        .byte   $03                             ; BE9F 03                       .
        .byte   $03                             ; BEA0 03                       .
        .byte   $03                             ; BEA1 03                       .
        .byte   $03                             ; BEA2 03                       .
        .byte   $03                             ; BEA3 03                       .
        .byte   $03                             ; BEA4 03                       .
        .byte   $03                             ; BEA5 03                       .
        .byte   $03                             ; BEA6 03                       .
        .byte   $03                             ; BEA7 03                       .
        .byte   $03                             ; BEA8 03                       .
        .byte   $03                             ; BEA9 03                       .
        .byte   $03                             ; BEAA 03                       .
        .byte   $03                             ; BEAB 03                       .
        .byte   $03                             ; BEAC 03                       .
        .byte   $03                             ; BEAD 03                       .
        .byte   $03                             ; BEAE 03                       .
        .byte   $03                             ; BEAF 03                       .
        .byte   $03                             ; BEB0 03                       .
        .byte   $03                             ; BEB1 03                       .
        .byte   $03                             ; BEB2 03                       .
        .byte   $03                             ; BEB3 03                       .
        .byte   $03                             ; BEB4 03                       .
        .byte   $03                             ; BEB5 03                       .
        .byte   $03                             ; BEB6 03                       .
        .byte   $03                             ; BEB7 03                       .
        .byte   $03                             ; BEB8 03                       .
        .byte   $03                             ; BEB9 03                       .
        .byte   $03                             ; BEBA 03                       .
        .byte   $03                             ; BEBB 03                       .
        .byte   $03                             ; BEBC 03                       .
        .byte   $03                             ; BEBD 03                       .
        .byte   $03                             ; BEBE 03                       .
        .byte   $03                             ; BEBF 03                       .
        .byte   $03                             ; BEC0 03                       .
        .byte   $03                             ; BEC1 03                       .
        .byte   $03                             ; BEC2 03                       .
        .byte   $03                             ; BEC3 03                       .
        .byte   $03                             ; BEC4 03                       .
        .byte   $03                             ; BEC5 03                       .
        .byte   $03                             ; BEC6 03                       .
        .byte   $03                             ; BEC7 03                       .
        .byte   $03                             ; BEC8 03                       .
        .byte   $03                             ; BEC9 03                       .
        .byte   $03                             ; BECA 03                       .
        .byte   $03                             ; BECB 03                       .
        .byte   $03                             ; BECC 03                       .
        .byte   $03                             ; BECD 03                       .
        .byte   $03                             ; BECE 03                       .
        .byte   $03                             ; BECF 03                       .
        .byte   $03                             ; BED0 03                       .
        .byte   $03                             ; BED1 03                       .
        .byte   $03                             ; BED2 03                       .
        .byte   $03                             ; BED3 03                       .
        .byte   $03                             ; BED4 03                       .
        .byte   $03                             ; BED5 03                       .
        .byte   $03                             ; BED6 03                       .
        .byte   $03                             ; BED7 03                       .
        .byte   $03                             ; BED8 03                       .
        .byte   $03                             ; BED9 03                       .
        .byte   $03                             ; BEDA 03                       .
        .byte   $03                             ; BEDB 03                       .
        .byte   $03                             ; BEDC 03                       .
        .byte   $03                             ; BEDD 03                       .
        .byte   $03                             ; BEDE 03                       .
        .byte   $03                             ; BEDF 03                       .
        .byte   $03                             ; BEE0 03                       .
        .byte   $03                             ; BEE1 03                       .
        .byte   $03                             ; BEE2 03                       .
        .byte   $03                             ; BEE3 03                       .
        .byte   $03                             ; BEE4 03                       .
        .byte   $03                             ; BEE5 03                       .
        .byte   $03                             ; BEE6 03                       .
        .byte   $03                             ; BEE7 03                       .
        .byte   $03                             ; BEE8 03                       .
        .byte   $03                             ; BEE9 03                       .
        .byte   $03                             ; BEEA 03                       .
        .byte   $03                             ; BEEB 03                       .
        .byte   $03                             ; BEEC 03                       .
        .byte   $03                             ; BEED 03                       .
        .byte   $03                             ; BEEE 03                       .
        .byte   $03                             ; BEEF 03                       .
        .byte   $03                             ; BEF0 03                       .
        .byte   $03                             ; BEF1 03                       .
        .byte   $03                             ; BEF2 03                       .
        .byte   $03                             ; BEF3 03                       .
        .byte   $03                             ; BEF4 03                       .
        .byte   $03                             ; BEF5 03                       .
        .byte   $03                             ; BEF6 03                       .
        .byte   $03                             ; BEF7 03                       .
        .byte   $03                             ; BEF8 03                       .
        .byte   $03                             ; BEF9 03                       .
        .byte   $03                             ; BEFA 03                       .
        .byte   $03                             ; BEFB 03                       .
        .byte   $03                             ; BEFC 03                       .
        .byte   $03                             ; BEFD 03                       .
        .byte   $03                             ; BEFE 03                       .
        .byte   $03                             ; BEFF 03                       .
        .byte   $03                             ; BF00 03                       .
        .byte   $03                             ; BF01 03                       .
        .byte   $03                             ; BF02 03                       .
        .byte   $03                             ; BF03 03                       .
        .byte   $03                             ; BF04 03                       .
        .byte   $03                             ; BF05 03                       .
        .byte   $03                             ; BF06 03                       .
        .byte   $03                             ; BF07 03                       .
        .byte   $03                             ; BF08 03                       .
        .byte   $03                             ; BF09 03                       .
        .byte   $03                             ; BF0A 03                       .
        .byte   $03                             ; BF0B 03                       .
        .byte   $03                             ; BF0C 03                       .
        .byte   $03                             ; BF0D 03                       .
        .byte   $03                             ; BF0E 03                       .
        .byte   $03                             ; BF0F 03                       .
        .byte   $03                             ; BF10 03                       .
        .byte   $03                             ; BF11 03                       .
        .byte   $03                             ; BF12 03                       .
        .byte   $03                             ; BF13 03                       .
        .byte   $03                             ; BF14 03                       .
        .byte   $03                             ; BF15 03                       .
        .byte   $03                             ; BF16 03                       .
        .byte   $03                             ; BF17 03                       .
        .byte   $03                             ; BF18 03                       .
        .byte   $03                             ; BF19 03                       .
        .byte   $03                             ; BF1A 03                       .
        .byte   $03                             ; BF1B 03                       .
        .byte   $03                             ; BF1C 03                       .
        .byte   $03                             ; BF1D 03                       .
        .byte   $03                             ; BF1E 03                       .
        .byte   $03                             ; BF1F 03                       .
        .byte   $03                             ; BF20 03                       .
        .byte   $03                             ; BF21 03                       .
        .byte   $03                             ; BF22 03                       .
        .byte   $03                             ; BF23 03                       .
        .byte   $03                             ; BF24 03                       .
        .byte   $03                             ; BF25 03                       .
        .byte   $03                             ; BF26 03                       .
        .byte   $03                             ; BF27 03                       .
        .byte   $03                             ; BF28 03                       .
        .byte   $03                             ; BF29 03                       .
        .byte   $03                             ; BF2A 03                       .
        .byte   $03                             ; BF2B 03                       .
        .byte   $03                             ; BF2C 03                       .
        .byte   $03                             ; BF2D 03                       .
        .byte   $03                             ; BF2E 03                       .
        .byte   $03                             ; BF2F 03                       .
        .byte   $03                             ; BF30 03                       .
        .byte   $03                             ; BF31 03                       .
        .byte   $03                             ; BF32 03                       .
        .byte   $03                             ; BF33 03                       .
        .byte   $03                             ; BF34 03                       .
        .byte   $03                             ; BF35 03                       .
        .byte   $03                             ; BF36 03                       .
        .byte   $03                             ; BF37 03                       .
        .byte   $03                             ; BF38 03                       .
        .byte   $03                             ; BF39 03                       .
        .byte   $03                             ; BF3A 03                       .
        .byte   $03                             ; BF3B 03                       .
        .byte   $03                             ; BF3C 03                       .
        .byte   $03                             ; BF3D 03                       .
        .byte   $03                             ; BF3E 03                       .
        .byte   $03                             ; BF3F 03                       .
        .byte   $03                             ; BF40 03                       .
        .byte   $03                             ; BF41 03                       .
        .byte   $03                             ; BF42 03                       .
        .byte   $03                             ; BF43 03                       .
        .byte   $03                             ; BF44 03                       .
        .byte   $03                             ; BF45 03                       .
        .byte   $03                             ; BF46 03                       .
        .byte   $03                             ; BF47 03                       .
        .byte   $03                             ; BF48 03                       .
        .byte   $03                             ; BF49 03                       .
        .byte   $03                             ; BF4A 03                       .
        .byte   $03                             ; BF4B 03                       .
        .byte   $03                             ; BF4C 03                       .
        .byte   $03                             ; BF4D 03                       .
        .byte   $03                             ; BF4E 03                       .
        .byte   $03                             ; BF4F 03                       .
        .byte   $03                             ; BF50 03                       .
        .byte   $03                             ; BF51 03                       .
        .byte   $03                             ; BF52 03                       .
        .byte   $03                             ; BF53 03                       .
        .byte   $03                             ; BF54 03                       .
        .byte   $03                             ; BF55 03                       .
        .byte   $03                             ; BF56 03                       .
        .byte   $03                             ; BF57 03                       .
        .byte   $03                             ; BF58 03                       .
        .byte   $03                             ; BF59 03                       .
        .byte   $03                             ; BF5A 03                       .
        .byte   $03                             ; BF5B 03                       .
        .byte   $03                             ; BF5C 03                       .
        .byte   $03                             ; BF5D 03                       .
        .byte   $03                             ; BF5E 03                       .
        .byte   $03                             ; BF5F 03                       .
        .byte   $03                             ; BF60 03                       .
        .byte   $03                             ; BF61 03                       .
        .byte   $03                             ; BF62 03                       .
        .byte   $03                             ; BF63 03                       .
        .byte   $03                             ; BF64 03                       .
        .byte   $03                             ; BF65 03                       .
        .byte   $03                             ; BF66 03                       .
        .byte   $03                             ; BF67 03                       .
        .byte   $03                             ; BF68 03                       .
        .byte   $03                             ; BF69 03                       .
        .byte   $03                             ; BF6A 03                       .
        .byte   $03                             ; BF6B 03                       .
        .byte   $03                             ; BF6C 03                       .
        .byte   $03                             ; BF6D 03                       .
        .byte   $03                             ; BF6E 03                       .
        .byte   $03                             ; BF6F 03                       .
        .byte   $03                             ; BF70 03                       .
        .byte   $03                             ; BF71 03                       .
        .byte   $03                             ; BF72 03                       .
        .byte   $03                             ; BF73 03                       .
        .byte   $03                             ; BF74 03                       .
        .byte   $03                             ; BF75 03                       .
        .byte   $03                             ; BF76 03                       .
        .byte   $03                             ; BF77 03                       .
        .byte   $03                             ; BF78 03                       .
        .byte   $03                             ; BF79 03                       .
        .byte   $03                             ; BF7A 03                       .
        .byte   $03                             ; BF7B 03                       .
        .byte   $03                             ; BF7C 03                       .
        .byte   $03                             ; BF7D 03                       .
        .byte   $03                             ; BF7E 03                       .
        .byte   $03                             ; BF7F 03                       .
        .byte   $03                             ; BF80 03                       .
        .byte   $03                             ; BF81 03                       .
        .byte   $03                             ; BF82 03                       .
        .byte   $03                             ; BF83 03                       .
        .byte   $03                             ; BF84 03                       .
        .byte   $03                             ; BF85 03                       .
        .byte   $03                             ; BF86 03                       .
        .byte   $03                             ; BF87 03                       .
        .byte   $03                             ; BF88 03                       .
        .byte   $03                             ; BF89 03                       .
        .byte   $03                             ; BF8A 03                       .
        .byte   $03                             ; BF8B 03                       .
        .byte   $03                             ; BF8C 03                       .
        .byte   $03                             ; BF8D 03                       .
        .byte   $03                             ; BF8E 03                       .
        .byte   $03                             ; BF8F 03                       .
        .byte   $03                             ; BF90 03                       .
        .byte   $03                             ; BF91 03                       .
        .byte   $03                             ; BF92 03                       .
        .byte   $03                             ; BF93 03                       .
        .byte   $03                             ; BF94 03                       .
        .byte   $03                             ; BF95 03                       .
        .byte   $03                             ; BF96 03                       .
        .byte   $03                             ; BF97 03                       .
        .byte   $03                             ; BF98 03                       .
        .byte   $03                             ; BF99 03                       .
        .byte   $03                             ; BF9A 03                       .
        .byte   $03                             ; BF9B 03                       .
        .byte   $03                             ; BF9C 03                       .
        .byte   $03                             ; BF9D 03                       .
        .byte   $03                             ; BF9E 03                       .
        .byte   $03                             ; BF9F 03                       .
        .byte   $03                             ; BFA0 03                       .
        .byte   $03                             ; BFA1 03                       .
        .byte   $03                             ; BFA2 03                       .
        .byte   $03                             ; BFA3 03                       .
        .byte   $03                             ; BFA4 03                       .
        .byte   $03                             ; BFA5 03                       .
        .byte   $03                             ; BFA6 03                       .
        .byte   $03                             ; BFA7 03                       .
        .byte   $03                             ; BFA8 03                       .
        .byte   $03                             ; BFA9 03                       .
        .byte   $03                             ; BFAA 03                       .
        .byte   $03                             ; BFAB 03                       .
        .byte   $03                             ; BFAC 03                       .
        .byte   $03                             ; BFAD 03                       .
        .byte   $03                             ; BFAE 03                       .
        .byte   $03                             ; BFAF 03                       .
        .byte   $03                             ; BFB0 03                       .
        .byte   $03                             ; BFB1 03                       .
        .byte   $03                             ; BFB2 03                       .
        .byte   $03                             ; BFB3 03                       .
        .byte   $03                             ; BFB4 03                       .
        .byte   $03                             ; BFB5 03                       .
        .byte   $03                             ; BFB6 03                       .
        .byte   $03                             ; BFB7 03                       .
        .byte   $03                             ; BFB8 03                       .
        .byte   $03                             ; BFB9 03                       .
        .byte   $03                             ; BFBA 03                       .
        .byte   $03                             ; BFBB 03                       .
        .byte   $03                             ; BFBC 03                       .
        .byte   $03                             ; BFBD 03                       .
        .byte   $03                             ; BFBE 03                       .
        .byte   $03                             ; BFBF 03                       .
        .byte   $03                             ; BFC0 03                       .
        .byte   $03                             ; BFC1 03                       .
        .byte   $03                             ; BFC2 03                       .
        .byte   $03                             ; BFC3 03                       .
        .byte   $03                             ; BFC4 03                       .
        .byte   $03                             ; BFC5 03                       .
        .byte   $03                             ; BFC6 03                       .
        .byte   $03                             ; BFC7 03                       .
        .byte   $03                             ; BFC8 03                       .
        .byte   $03                             ; BFC9 03                       .
        .byte   $03                             ; BFCA 03                       .
        .byte   $03                             ; BFCB 03                       .
        .byte   $03                             ; BFCC 03                       .
        .byte   $03                             ; BFCD 03                       .
        .byte   $03                             ; BFCE 03                       .
        .byte   $03                             ; BFCF 03                       .
        .byte   $03                             ; BFD0 03                       .
        .byte   $03                             ; BFD1 03                       .
        .byte   $03                             ; BFD2 03                       .
        .byte   $03                             ; BFD3 03                       .
        .byte   $03                             ; BFD4 03                       .
        .byte   $03                             ; BFD5 03                       .
        .byte   $03                             ; BFD6 03                       .
        .byte   $03                             ; BFD7 03                       .
        .byte   $03                             ; BFD8 03                       .
        .byte   $03                             ; BFD9 03                       .
        .byte   $03                             ; BFDA 03                       .
        .byte   $03                             ; BFDB 03                       .
        .byte   $03                             ; BFDC 03                       .
        .byte   $03                             ; BFDD 03                       .
        .byte   $03                             ; BFDE 03                       .
        .byte   $03                             ; BFDF 03                       .
        .byte   $03                             ; BFE0 03                       .
        .byte   $03                             ; BFE1 03                       .
        .byte   $03                             ; BFE2 03                       .
        .byte   $03                             ; BFE3 03                       .
        .byte   $03                             ; BFE4 03                       .
        .byte   $03                             ; BFE5 03                       .
        .byte   $03                             ; BFE6 03                       .
        .byte   $03                             ; BFE7 03                       .
        .byte   $03                             ; BFE8 03                       .
        .byte   $03                             ; BFE9 03                       .
        .byte   $03                             ; BFEA 03                       .
        .byte   $03                             ; BFEB 03                       .
        .byte   $03                             ; BFEC 03                       .
        .byte   $03                             ; BFED 03                       .
        .byte   $03                             ; BFEE 03                       .
        .byte   $03                             ; BFEF 03                       .
        .byte   $03                             ; BFF0 03                       .
        .byte   $03                             ; BFF1 03                       .
        .byte   $03                             ; BFF2 03                       .
        .byte   $03                             ; BFF3 03                       .
        .byte   $03                             ; BFF4 03                       .
        .byte   $03                             ; BFF5 03                       .
        .byte   $03                             ; BFF6 03                       .
        .byte   $03                             ; BFF7 03                       .
        .byte   $03                             ; BFF8 03                       .
        .byte   $03                             ; BFF9 03                       .
        .byte   $03                             ; BFFA 03                       .
        .byte   $03                             ; BFFB 03                       .
        .byte   $03                             ; BFFC 03                       .
        .byte   $03                             ; BFFD 03                       .
        .byte   $03                             ; BFFE 03                       .
        .byte   $03                             ; BFFF 03                       .
