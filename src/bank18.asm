.setcpu "6502"
.include "include/hardware.inc"
.include "include/zeropage.inc"
.include "include/constants.inc"
.include "include/fixed_bank.inc"

.segment "BANK18"

; =============================================================================
; BANK $18 (mapped at $8000) — SOUND DRIVER
;
; Channel indexing: x = 0-3 = noise/triangle/pulse2/pulse1 (APU regs at
; $4000 + (x^3)*4). Two parallel state blocks share the same field
; offsets: SFX uses x = ch (fields at $0700+ch), music uses x = ch+$28
; (fields at $0728+ch). Fields (stride 4 per channel):
;   +$0700 instrument index        +$0704 flags (b0-2 envelope phase,
;   +$0708 envelope level                 b3 env active, b5 portamento
;   +$070C duty|volume shadow             pending, b6-7 phase carry)
;   +$0710 current volume          +$0714 vibrato/detune depth
;   +$0718 portamento speed        +$071C portamento current note
;   +$0720/$0724 period lo/hi      +$0728/$072C track pointer
;   +$0730 track flags (b0-2 octave, b3 stac, b4 dot latch, b6 tie,
;          b7 rest)                +$0734 channel transpose
;   +$0738 note length counter     +$073C gate fraction
;   +$0740 gate counter            +$0744.. loop counters (4 slots)
;   $077C-$077F last period-hi written per APU channel (reload guard)
;
; Driver zp: $C0 flags (b0 in-play mutex, b1 paused), $C1-$C6 temps
; ($C5/$C6 = instrument ptr), $C7 ticks this frame, $C8-$CA tempo
; accumulator/step, $CB global transpose, $CC/$CD master fade
; speed/level, $CE active SFX priority, $CF channel-claim mask (SFX-
; owned channels mute their music voice; b7 = temp busy flag),
; $D0/$D1 SFX stream ptr, $D2 SFX transpose, $D3/$D5 SFX note/frame
; counters, $D4 SFX volume, $D6/$D7 SFX mode + chain latch, $D8 SFX
; pitch offset (control op $F7).
;
; Sound data: instruments at $8ADB (8 bytes: attack/decay rate idx,
; sustain level, release rate idx, env-speed|b7, vibrato, tremolo,
; duty (noise mode), see L86BA/$875B/$87B3), song/SFX streams from
; $8D13 filling the rest of this bank, then bank $19 ($A000-$BFFF)
; and bank $1A (fetched as virtual $C000-$DFFF — L803A temporarily
; remaps MMC3 R7 to bank $1A and reads at addr-$2000).
; =============================================================================
L0000           := $0000
L0018           := $0018
L0026           := $0026
L00C1           := $00C1
L0287           := $0287
L0DD0           := $0DD0
L1860           := $1860
L203C           := $203C
L3DD2           := $3DD2
L4E4D           := $4E4D
L5A06           := $5A06
L606E           := $606E
L628E           := $628E
L6766           := $6766
L696B           := $696B
L6A6B           := $6A6B
L6C60           := $6C60
L6C6E           := $6C6E
L6C80           := $6C80
L6F64           := $6F64
L716B           := $716B
L716E           := $716E
L7273           := $7273
; ----------------------------------------------------------------------------
; =============================================================================
; SOUND DRIVER — bank $18 at $8000 (data in bank $19 at $A000)
; Called via the fixed bank's sound queue pump with both banks mapped:
;   $8000 -> snd_update  (per-frame driver tick)
;   $8003 -> snd_play    (A = sound id)
; IDs >= $F0 are control operations (snd_control: stop/pause/fade
; family); ids wrap modulo snd_song_count. Song directory at
; snd_song_dir (2 bytes/entry); SFX carry a priority byte compared
; against the active priority ($CE) for channel preemption.
; =============================================================================
L8000:  .byte   $4C                             ; 8000 4C                       L
L8001:  jmp     ($4C80)                         ; 8001 6C 80 4C                 l.L

; ----------------------------------------------------------------------------
        .byte   $FE                             ; 8004 FE                       .
        .byte   $80                             ; 8005 80                       .
; --- L8006: 8x8 multiply: $C1:$C2 = $C1 * $C4 (volume/duration scaling).
L8006:  lda     #$00                            ; 8006 A9 00                    ..
        sta     $C2                             ; 8008 85 C2                    ..
        ldy     #$08                            ; 800A A0 08                    ..
L800C:  .byte   $06                             ; 800C 06                       .
L800D:  .byte   $C2                             ; 800D C2                       .
        rol     L00C1                           ; 800E 26 C1                    &.
        bcc     L801F                           ; 8010 90 0D                    ..
        clc                                     ; 8012 18                       .
        lda     $C2                             ; 8013 A5 C2                    ..
        adc     $C4                             ; 8015 65 C4                    e.
        sta     $C2                             ; 8017 85 C2                    ..
        lda     L00C1                           ; 8019 A5 C1                    ..
        adc     #$00                            ; 801B 69 00                    i.
        sta     L00C1                           ; 801D 85 C1                    ..
L801F:  dey                                     ; 801F 88                       .
        bne     L800C                           ; 8020 D0 EA                    ..
        rts                                     ; 8022 60                       `

; ----------------------------------------------------------------------------
; --- L8023: dispatch A into the address table that follows the caller's
; jsr (pulls the return address, indexes table entry A, jumps).
L8023:  asl     a                               ; 8023 0A                       .
        tay                                     ; 8024 A8                       .
        iny                                     ; 8025 C8                       .
        pla                                     ; 8026 68                       h
        sta     L00C1                           ; 8027 85 C1                    ..
        pla                                     ; 8029 68                       h
        sta     $C2                             ; 802A 85 C2                    ..
        lda     (L00C1),y                       ; 802C B1 C1                    ..
        pha                                     ; 802E 48                       H
        iny                                     ; 802F C8                       .
        lda     (L00C1),y                       ; 8030 B1 C1                    ..
        sta     $C2                             ; 8032 85 C2                    ..
        pla                                     ; 8034 68                       h
        sta     L00C1                           ; 8035 85 C1                    ..
        jmp     (L00C1)                         ; 8037 6C C1 00                 l..

; ----------------------------------------------------------------------------
; --- L803A: far fetch, ptr A(hi)/Y(lo): addresses < $C000 read straight
; from this bank pair; >= $C000 temporarily remap MMC3 R7 from bank $19
; to bank $1A and read at addr-$2000 (sound data overflow bank).
L803A:  sty     L00C1                           ; 803A 84 C1                    ..
        ldy     #$00                            ; 803C A0 00                    ..
        cmp     #$C0                            ; 803E C9 C0                    ..
        bcs     L8047                           ; 8040 B0 05                    ..
        sta     $C2                             ; 8042 85 C2                    ..
        lda     (L00C1),y                       ; 8044 B1 C1                    ..
        rts                                     ; 8046 60                       `

; ----------------------------------------------------------------------------
L8047:  sec                                     ; 8047 38                       8
        sbc     #$20                            ; 8048 E9 20                    . 
        sta     $C2                             ; 804A 85 C2                    ..
        lda     #$07                            ; 804C A9 07                    ..
        sta     L8000                           ; 804E 8D 00 80                 ...
        lda     #$1A                            ; 8051 A9 1A                    ..
        sta     L8001                           ; 8053 8D 01 80                 ...
        lda     (L00C1),y                       ; 8056 B1 C1                    ..
        pha                                     ; 8058 48                       H
        lda     #$07                            ; 8059 A9 07                    ..
        sta     L8000                           ; 805B 8D 00 80                 ...
        lda     #$19                            ; 805E A9 19                    ..
        sta     L8001                           ; 8060 8D 01 80                 ...
        lda     #$20                            ; 8063 A9 20                    . 
        clc                                     ; 8065 18                       .
        adc     $C2                             ; 8066 65 C2                    e.
        sta     $C2                             ; 8068 85 C2                    ..
        pla                                     ; 806A 68                       h
        rts                                     ; 806B 60                       `

; ----------------------------------------------------------------------------
; --- snd_update ($806C): per-frame tick. Starts a pending SFX ($D0/$D1
; via L8252), advances the tempo accumulator ($C8 += $CA -> $C7 = whole
; ticks this frame), then per channel x=3..0: SFX voice (L82DE) and,
; unless SFX-paused ($C0 b1), music voice (L8393); channels claimed in
; $CF get their music voice muted (b7 marks the pass). Finally applies
; the master fade: level $CD ramps by $CC<<4, saturating at $FF.
snd_update:  lda     $C0                             ; 806C A5 C0                    ..
        lsr     a                               ; 806E 4A                       J
        bcs     L80D7                           ; 806F B0 66                    .f
        lda     $D0                             ; 8071 A5 D0                    ..
        ora     $D1                             ; 8073 05 D1                    ..
        beq     L807A                           ; 8075 F0 03                    ..
        jsr     L8252                           ; 8077 20 52 82                  R.
L807A:  clc                                     ; 807A 18                       .
        lda     $CA                             ; 807B A5 CA                    ..
        adc     $C8                             ; 807D 65 C8                    e.
        sta     $C8                             ; 807F 85 C8                    ..
        lda     $C9                             ; 8081 A5 C9                    ..
        adc     #$00                            ; 8083 69 00                    i.
        sta     $C7                             ; 8085 85 C7                    ..
        lda     $CF                             ; 8087 A5 CF                    ..
        pha                                     ; 8089 48                       H
        ldx     #$03                            ; 808A A2 03                    ..
L808C:  lsr     $CF                             ; 808C 46 CF                    F.
        .byte   $90                             ; 808E 90                       .
L808F:  ora     #$A5                            ; 808F 09 A5                    ..
        .byte   $CF                             ; 8091 CF                       .
        ora     #$80                            ; 8092 09 80                    ..
        sta     $CF                             ; 8094 85 CF                    ..
        jsr     L82DE                           ; 8096 20 DE 82                  ..
L8099:  lda     $C0                             ; 8099 A5 C0                    ..
        and     #$02                            ; 809B 29 02                    ).
        bne     L80A6                           ; 809D D0 07                    ..
        txa                                     ; 809F 8A                       .
        pha                                     ; 80A0 48                       H
        jsr     L8393                           ; 80A1 20 93 83                  ..
        pla                                     ; 80A4 68                       h
        tax                                     ; 80A5 AA                       .
L80A6:  dex                                     ; 80A6 CA                       .
        bpl     L808C                           ; 80A7 10 E3                    ..
        pla                                     ; 80A9 68                       h
        sta     $CF                             ; 80AA 85 CF                    ..
        lsr     $C0                             ; 80AC 46 C0                    F.
        asl     $C0                             ; 80AE 06 C0                    ..
        lda     $CC                             ; 80B0 A5 CC                    ..
        and     #$7F                            ; 80B2 29 7F                    ).
        beq     L80D7                           ; 80B4 F0 21                    .!
        ldy     #$00                            ; 80B6 A0 00                    ..
        sty     L00C1                           ; 80B8 84 C1                    ..
        ldy     #$04                            ; 80BA A0 04                    ..
L80BC:  asl     a                               ; 80BC 0A                       .
        rol     L00C1                           ; 80BD 26 C1                    &.
        dey                                     ; 80BF 88                       .
        bne     L80BC                           ; 80C0 D0 FA                    ..
        clc                                     ; 80C2 18                       .
        adc     $C0                             ; 80C3 65 C0                    e.
        sta     $C0                             ; 80C5 85 C0                    ..
        lda     L00C1                           ; 80C7 A5 C1                    ..
        adc     $CD                             ; 80C9 65 CD                    e.
        bcc     L80D5                           ; 80CB 90 08                    ..
        lda     $CC                             ; 80CD A5 CC                    ..
        and     #$80                            ; 80CF 29 80                    ).
        sta     $CC                             ; 80D1 85 CC                    ..
        lda     #$FF                            ; 80D3 A9 FF                    ..
L80D5:  sta     $CD                             ; 80D5 85 CD                    ..
L80D7:  rts                                     ; 80D7 60                       `

; ----------------------------------------------------------------------------
; --- L80D8: silence channel x: $30 to its APU vol reg ($00 for the
; triangle's linear counter).
L80D8:  txa                                     ; 80D8 8A                       .
        and     #$03                            ; 80D9 29 03                    ).
        eor     #$03                            ; 80DB 49 03                    I.
        asl     a                               ; 80DD 0A                       .
        asl     a                               ; 80DE 0A                       .
        tay                                     ; 80DF A8                       .
        lda     #$30                            ; 80E0 A9 30                    .0
        cpy     #$08                            ; 80E2 C0 08                    ..
        bne     L80E8                           ; 80E4 D0 02                    ..
        lda     #$00                            ; 80E6 A9 00                    ..
L80E8:  sta     $4000,y                         ; 80E8 99 00 40                 ..@
        rts                                     ; 80EB 60                       `

; ----------------------------------------------------------------------------
; --- L80EC: write A to APU register Y of channel x ($4000+(x^3)*4+Y).
L80EC:  pha                                     ; 80EC 48                       H
        txa                                     ; 80ED 8A                       .
        and     #$03                            ; 80EE 29 03                    ).
        eor     #$03                            ; 80F0 49 03                    I.
        asl     a                               ; 80F2 0A                       .
        asl     a                               ; 80F3 0A                       .
        sty     $C4                             ; 80F4 84 C4                    ..
        ora     $C4                             ; 80F6 05 C4                    ..
        tay                                     ; 80F8 A8                       .
        pla                                     ; 80F9 68                       h
        sta     $4000,y                         ; 80FA 99 00 40                 ..@
        rts                                     ; 80FD 60                       `

; ----------------------------------------------------------------------------
; --- snd_play ($8003 vector): queue-driven entry, A = sound id (the $C0
; b0 mutex keeps the NMI-side pump from re-entering the update).
snd_play:  inc     $C0                             ; 80FE E6 C0                    ..
        jsr     L8106                           ; 8100 20 06 81                  ..
        dec     $C0                             ; 8103 C6 C0                    ..
        rts                                     ; 8105 60                       `

; ----------------------------------------------------------------------------
; --- L8106: ids >= $F0 are control ops (snd_control); others wrap mod
; snd_song_count and look up snd_song_dir (2 bytes/entry, hi/lo). The
; entry's first data byte is its priority: $00 = music track (starts
; now, L816F), else SFX — started only if >= the active priority $CE
; (b7 of the id byte = uninterruptible, b6 = chained/looping via $D7);
; accepted SFX latch their stream ptr into $D0/$D1 for next update.
L8106:  cmp     #$F0                            ; 8106 C9 F0                    ..
        bcc     L810D                           ; 8108 90 03                    ..
        jmp     snd_control                           ; 810A 4C AE 81                 L..

; ----------------------------------------------------------------------------
L810D:  cmp     snd_song_count                           ; 810D CD 40 8A                 .@.
        bcc     L8118                           ; 8110 90 06                    ..
        sec                                     ; 8112 38                       8
        sbc     snd_song_count                           ; 8113 ED 40 8A                 .@.
        bcs     L810D                           ; 8116 B0 F5                    ..
L8118:  asl     a                               ; 8118 0A                       .
        tax                                     ; 8119 AA                       .
        ldy     snd_song_dir1,x                         ; 811A BC 44 8A                 .D.
        tya                                     ; 811D 98                       .
        ora     snd_song_dir,x                         ; 811E 1D 43 8A                 .C.
        beq     L816E                           ; 8121 F0 4B                    .K
        lda     snd_song_dir,x                         ; 8123 BD 43 8A                 .C.
        jsr     L803A                           ; 8126 20 3A 80                  :.
        tay                                     ; 8129 A8                       .
        beq     L816F                           ; 812A F0 43                    .C
        ldy     #$00                            ; 812C A0 00                    ..
        inx                                     ; 812E E8                       .
        sta     $C4                             ; 812F 85 C4                    ..
        and     #$7F                            ; 8131 29 7F                    ).
        cmp     $CE                             ; 8133 C5 CE                    ..
        bcc     L816E                           ; 8135 90 37                    .7
        sta     $CE                             ; 8137 85 CE                    ..
        bne     L8145                           ; 8139 D0 0A                    ..
        lda     $D6                             ; 813B A5 D6                    ..
        bpl     L8145                           ; 813D 10 06                    ..
        lda     $C4                             ; 813F A5 C4                    ..
        bmi     L8145                           ; 8141 30 02                    0.
        sty     $D7                             ; 8143 84 D7                    ..
L8145:  sty     $D6                             ; 8145 84 D6                    ..
        asl     $C4                             ; 8147 06 C4                    ..
        ror     $D6                             ; 8149 66 D6                    f.
        bpl     L814F                           ; 814B 10 02                    ..
        stx     $D7                             ; 814D 86 D7                    ..
L814F:  inc     L00C1                           ; 814F E6 C1                    ..
        lda     L00C1                           ; 8151 A5 C1                    ..
        sta     $D0                             ; 8153 85 D0                    ..
        bne     L8159                           ; 8155 D0 02                    ..
        inc     $C2                             ; 8157 E6 C2                    ..
L8159:  lda     $C2                             ; 8159 A5 C2                    ..
        sta     $D1                             ; 815B 85 D1                    ..
        tya                                     ; 815D 98                       .
        sta     $D2                             ; 815E 85 D2                    ..
        sta     $D3                             ; 8160 85 D3                    ..
        sta     $D4                             ; 8162 85 D4                    ..
        sta     $D5                             ; 8164 85 D5                    ..
        ldy     #$27                            ; 8166 A0 27                    .'
L8168:  sta     $0700,y                         ; 8168 99 00 07                 ...
        dey                                     ; 816B 88                       .
        bpl     L8168                           ; 816C 10 FA                    ..
L816E:  rts                                     ; 816E 60                       `

; ----------------------------------------------------------------------------
; --- L816F: start music: default tempo $0199, clear fade and both
; music state blocks, read the 4 channel track pointers (hi, lo per
; channel) from the song header into $0754/$0750 (= $072C/$0728 for
; x=ch+$28).
L816F:  ldx     #$01                            ; 816F A2 01                    ..
        stx     $C9                             ; 8171 86 C9                    ..
        ldx     #$99                            ; 8173 A2 99                    ..
        stx     $CA                             ; 8175 86 CA                    ..
        sta     $C8                             ; 8177 85 C8                    ..
        sta     $CB                             ; 8179 85 CB                    ..
        sta     $CC                             ; 817B 85 CC                    ..
        sta     $CD                             ; 817D 85 CD                    ..
        ldx     #$53                            ; 817F A2 53                    .S
L8181:  .byte   $9D                             ; 8181 9D                       .
L8182:  plp                                     ; 8182 28                       (
        .byte   $07                             ; 8183 07                       .
        dex                                     ; 8184 CA                       .
        bpl     L8181                           ; 8185 10 FA                    ..
        ldx     #$03                            ; 8187 A2 03                    ..
L8189:  inc     L00C1                           ; 8189 E6 C1                    ..
        bne     L818F                           ; 818B D0 02                    ..
        inc     $C2                             ; 818D E6 C2                    ..
L818F:  ldy     L00C1                           ; 818F A4 C1                    ..
        lda     $C2                             ; 8191 A5 C2                    ..
        jsr     L803A                           ; 8193 20 3A 80                  :.
        sta     $0754,x                         ; 8196 9D 54 07                 .T.
        inc     L00C1                           ; 8199 E6 C1                    ..
        bne     L819F                           ; 819B D0 02                    ..
        inc     $C2                             ; 819D E6 C2                    ..
L819F:  ldy     L00C1                           ; 819F A4 C1                    ..
        lda     $C2                             ; 81A1 A5 C2                    ..
        jsr     L803A                           ; 81A3 20 3A 80                  :.
        sta     $0750,x                         ; 81A6 9D 50 07                 .P.
        dex                                     ; 81A9 CA                       .
        bpl     L8189                           ; 81AA 10 DD                    ..
        bmi     L81F1                           ; 81AC 30 43                    0C
; --- snd_control: ops $F0-$F7, Y = param (from queue_sound_param):
;   $F0 stop everything      $F1 stop SFX (release claimed channels)
;   $F2 stop music           $F3 pause music  $F4 resume music
;   $F5 set master fade speed ($CC/$CD)  $F6 fade variant
;   $F7 SFX pitch offset $D8 = -Y (engine-pitch effects)
snd_control:  sty     $C3                             ; 81AE 84 C3                    ..
        and     #$07                            ; 81B0 29 07                    ).
        jsr     L8023                           ; 81B2 20 23 80                  #.
        cmp     $81                             ; 81B5 C5 81                    ..
        iny                                     ; 81B7 C8                       .
        sta     ($E4,x)                         ; 81B8 81 E4                    ..
        sta     ($1E,x)                         ; 81BA 81 1E                    ..
        .byte   $82                             ; 81BC 82                       .
        rol     $82                             ; 81BD 26 82                    &.
        and     $3482                           ; 81BF 2D 82 34                 -.4
        .byte   $82                             ; 81C2 82                       .
        lsr     a                               ; 81C3 4A                       J
        .byte   $82                             ; 81C4 82                       .
        jsr     L81E4                           ; 81C5 20 E4 81                  ..
L81C8:  lda     #$00                            ; 81C8 A9 00                    ..
        sta     $CE                             ; 81CA 85 CE                    ..
        sta     $D0                             ; 81CC 85 D0                    ..
        sta     $D1                             ; 81CE 85 D1                    ..
        sta     $D7                             ; 81D0 85 D7                    ..
        sta     $D8                             ; 81D2 85 D8                    ..
L81D4:  lda     $CF                             ; 81D4 A5 CF                    ..
        beq     L81E3                           ; 81D6 F0 0B                    ..
        eor     #$0F                            ; 81D8 49 0F                    I.
        sta     $CF                             ; 81DA 85 CF                    ..
        jsr     L81F1                           ; 81DC 20 F1 81                  ..
        lda     #$00                            ; 81DF A9 00                    ..
        sta     $CF                             ; 81E1 85 CF                    ..
L81E3:  rts                                     ; 81E3 60                       `

; ----------------------------------------------------------------------------
L81E4:  lda     #$00                            ; 81E4 A9 00                    ..
        ldx     #$03                            ; 81E6 A2 03                    ..
L81E8:  sta     $0754,x                         ; 81E8 9D 54 07                 .T.
        sta     $0750,x                         ; 81EB 9D 50 07                 .P.
        dex                                     ; 81EE CA                       .
        bpl     L81E8                           ; 81EF 10 F7                    ..
; --- L81F1: release SFX-claimed channels: silence them, flag a period
; reload ($077C = $FF) for channels whose music track lives on, restore
; sweep-off/$4015 defaults.
L81F1:  lda     $CF                             ; 81F1 A5 CF                    ..
        pha                                     ; 81F3 48                       H
        ldx     #$03                            ; 81F4 A2 03                    ..
L81F6:  lsr     $CF                             ; 81F6 46 CF                    F.
        bcs     L820A                           ; 81F8 B0 10                    ..
        jsr     L80D8                           ; 81FA 20 D8 80                  ..
        lda     $0754,x                         ; 81FD BD 54 07                 .T.
        ora     $0750,x                         ; 8200 1D 50 07                 .P.
        beq     L820A                           ; 8203 F0 05                    ..
        lda     #$FF                            ; 8205 A9 FF                    ..
        sta     $077C,x                         ; 8207 9D 7C 07                 .|.
L820A:  dex                                     ; 820A CA                       .
        bpl     L81F6                           ; 820B 10 E9                    ..
        pla                                     ; 820D 68                       h
        sta     $CF                             ; 820E 85 CF                    ..
        lda     #$08                            ; 8210 A9 08                    ..
        sta     $4001                           ; 8212 8D 01 40                 ..@
        sta     $4005                           ; 8215 8D 05 40                 ..@
        lda     #$0F                            ; 8218 A9 0F                    ..
        sta     $4015                           ; 821A 8D 15 40                 ..@
        rts                                     ; 821D 60                       `

; ----------------------------------------------------------------------------
; --- $821E: op $F3: pause music ($C0 b1) + silence; $8226: op $F4
; resume.
        lda     $C0                             ; 821E A5 C0                    ..
        ora     #$02                            ; 8220 09 02                    ..
        sta     $C0                             ; 8222 85 C0                    ..
        bne     L81F1                           ; 8224 D0 CB                    ..
        lda     $C0                             ; 8226 A5 C0                    ..
        and     #$FD                            ; 8228 29 FD                    ).
        sta     $C0                             ; 822A 85 C0                    ..
        rts                                     ; 822C 60                       `

; ----------------------------------------------------------------------------
; --- $822D: op $F5: master fade speed $CC (b7 = direction), reset
; level $CD; $8234: op $F6 variant also clears mode bits of $C0.
        asl     $C3                             ; 822D 06 C3                    ..
        beq     L8234                           ; 822F F0 03                    ..
        sec                                     ; 8231 38                       8
        ror     $C3                             ; 8232 66 C3                    f.
L8234:  lda     $C0                             ; 8234 A5 C0                    ..
        and     #$0F                            ; 8236 29 0F                    ).
        sta     $C0                             ; 8238 85 C0                    ..
        ldy     $C3                             ; 823A A4 C3                    ..
        sty     $CC                             ; 823C 84 CC                    ..
        beq     L8247                           ; 823E F0 07                    ..
        ldy     #$FF                            ; 8240 A0 FF                    ..
        cpy     $CD                             ; 8242 C4 CD                    ..
        bne     L8249                           ; 8244 D0 03                    ..
        iny                                     ; 8246 C8                       .
L8247:  sty     $CD                             ; 8247 84 CD                    ..
L8249:  rts                                     ; 8249 60                       `

; ----------------------------------------------------------------------------
; --- $824A: op $F7: SFX pitch offset $D8 = -param.
        lda     #$00                            ; 824A A9 00                    ..
        sec                                     ; 824C 38                       8
        sbc     $C3                             ; 824D E5 C3                    ..
        sta     $D8                             ; 824F 85 D8                    ..
        rts                                     ; 8251 60                       `

; ----------------------------------------------------------------------------
; --- L8252: pending-SFX starter. After the start delay $D3, parse the
; SFX header via L8386: flags byte — b7 end/chain (restart via $D7 or
; stop), b6 alternate-part pointer follows, b5 volume byte $D4 follows,
; b4 transpose byte $D2 follows — then note length $D3 (frames via the
; tempo multiply -> $D5), and the channel-claim mask into $CF (newly
; claimed channels are silenced through L81D4).
L8252:  lda     $D3                             ; 8252 A5 D3                    ..
        beq     L825B                           ; 8254 F0 05                    ..
        dec     $D3                             ; 8256 C6 D3                    ..
        dec     $D5                             ; 8258 C6 D5                    ..
        rts                                     ; 825A 60                       `

; ----------------------------------------------------------------------------
L825B:  jsr     L8386                           ; 825B 20 86 83                  ..
        sta     $C4                             ; 825E 85 C4                    ..
        asl     a                               ; 8260 0A                       .
        bcc     L8273                           ; 8261 90 10                    ..
        sty     $CE                             ; 8263 84 CE                    ..
        lda     $D7                             ; 8265 A5 D7                    ..
        lsr     a                               ; 8267 4A                       J
        bcc     L8270                           ; 8268 90 06                    ..
        jsr     L8118                           ; 826A 20 18 81                  ..
        jmp     L825B                           ; 826D 4C 5B 82                 L[.

; ----------------------------------------------------------------------------
L8270:  jmp     L81C8                           ; 8270 4C C8 81                 L..

; ----------------------------------------------------------------------------
L8273:  lsr     $C4                             ; 8273 46 C4                    F.
        bcc     L82A6                           ; 8275 90 2F                    ./
        jsr     L8386                           ; 8277 20 86 83                  ..
        asl     a                               ; 827A 0A                       .
        beq     L8289                           ; 827B F0 0C                    ..
        asl     $D6                             ; 827D 06 D6                    ..
        php                                     ; 827F 08                       .
        cmp     $D6                             ; 8280 C5 D6                    ..
        beq     L8296                           ; 8282 F0 12                    ..
        plp                                     ; 8284 28                       (
        ror     $D6                             ; 8285 66 D6                    f.
        inc     $D6                             ; 8287 E6 D6                    ..
L8289:  jsr     L8386                           ; 8289 20 86 83                  ..
        tax                                     ; 828C AA                       .
        jsr     L8386                           ; 828D 20 86 83                  ..
        sta     $D0                             ; 8290 85 D0                    ..
        stx     $D1                             ; 8292 86 D1                    ..
        bne     L825B                           ; 8294 D0 C5                    ..
L8296:  tya                                     ; 8296 98                       .
        plp                                     ; 8297 28                       (
        ror     a                               ; 8298 6A                       j
        sta     $D6                             ; 8299 85 D6                    ..
        clc                                     ; 829B 18                       .
        lda     #$02                            ; 829C A9 02                    ..
        adc     $D0                             ; 829E 65 D0                    e.
        sta     $D0                             ; 82A0 85 D0                    ..
        bcc     L82A6                           ; 82A2 90 02                    ..
        inc     $D1                             ; 82A4 E6 D1                    ..
L82A6:  lsr     $C4                             ; 82A6 46 C4                    F.
        bcc     L82AF                           ; 82A8 90 05                    ..
        jsr     L8386                           ; 82AA 20 86 83                  ..
        sta     $D4                             ; 82AD 85 D4                    ..
L82AF:  lsr     $C4                             ; 82AF 46 C4                    F.
        bcc     L82B8                           ; 82B1 90 05                    ..
        jsr     L8386                           ; 82B3 20 86 83                  ..
        sta     $D2                             ; 82B6 85 D2                    ..
L82B8:  jsr     L8386                           ; 82B8 20 86 83                  ..
        sta     $D3                             ; 82BB 85 D3                    ..
        sta     L00C1                           ; 82BD 85 C1                    ..
        lda     $D4                             ; 82BF A5 D4                    ..
        sta     $C4                             ; 82C1 85 C4                    ..
        jsr     L8006                           ; 82C3 20 06 80                  ..
        ldy     L00C1                           ; 82C6 A4 C1                    ..
        iny                                     ; 82C8 C8                       .
        sty     $D5                             ; 82C9 84 D5                    ..
        inc     $C0                             ; 82CB E6 C0                    ..
        jsr     L8386                           ; 82CD 20 86 83                  ..
        pha                                     ; 82D0 48                       H
        eor     $CF                             ; 82D1 45 CF                    E.
        beq     L82DA                           ; 82D3 F0 05                    ..
        sta     $CF                             ; 82D5 85 CF                    ..
        jsr     L81D4                           ; 82D7 20 D4 81                  ..
L82DA:  pla                                     ; 82DA 68                       h
        sta     $CF                             ; 82DB 85 CF                    ..
        rts                                     ; 82DD 60                       `

; ----------------------------------------------------------------------------
; --- L82DE: SFX voice tick (x = 0-3, fields at $0700+): run envelope
; (L8684/L86BA); during snd_play ($C0 b0) instead parse the SFX stream:
; L830A reads a bit-flagged parameter header (each set bit pulls a
; param byte through the L8326 op table: instrument, volume, duty,
; vibrato, portamento), then the note byte at L8333 ($00 = channel
; done -> silence; b7 set = no retrigger/tie; else key-on L85AE and
; pitch from note + SFX transpose $D2). Noise notes load the noise
; mode directly; expired notes key off into release (L85A3).
L82DE:  ldy     $0700,x                         ; 82DE BC 00 07                 ...
        beq     L82E6                           ; 82E1 F0 03                    ..
        jsr     L8684                           ; 82E3 20 84 86                  ..
L82E6:  lda     $C0                             ; 82E6 A5 C0                    ..
        lsr     a                               ; 82E8 4A                       J
        bcs     L830A                           ; 82E9 B0 1F                    ..
        jsr     L86BA                           ; 82EB 20 BA 86                  ..
        lda     $D3                             ; 82EE A5 D3                    ..
        beq     L82FA                           ; 82F0 F0 08                    ..
        cpx     #$01                            ; 82F2 E0 01                    ..
        beq     L82FB                           ; 82F4 F0 05                    ..
        lda     $D5                             ; 82F6 A5 D5                    ..
        beq     L8300                           ; 82F8 F0 06                    ..
L82FA:  rts                                     ; 82FA 60                       `

; ----------------------------------------------------------------------------
L82FB:  dec     $0710,x                         ; 82FB DE 10 07                 ...
        bne     L82FA                           ; 82FE D0 FA                    ..
L8300:  lda     $0704,x                         ; 8300 BD 04 07                 ...
        and     #$04                            ; 8303 29 04                    ).
        bne     L82FA                           ; 8305 D0 F3                    ..
        jmp     L85A3                           ; 8307 4C A3 85                 L..

; ----------------------------------------------------------------------------
L830A:  lda     #$00                            ; 830A A9 00                    ..
        sta     $C4                             ; 830C 85 C4                    ..
        jsr     L8386                           ; 830E 20 86 83                  ..
L8311:  lsr     a                               ; 8311 4A                       J
        bcc     L8320                           ; 8312 90 0C                    ..
        pha                                     ; 8314 48                       H
        jsr     L8386                           ; 8315 20 86 83                  ..
        sta     $C3                             ; 8318 85 C3                    ..
        lda     $C4                             ; 831A A5 C4                    ..
        jsr     L8326                           ; 831C 20 26 83                  &.
        pla                                     ; 831F 68                       h
L8320:  beq     L8333                           ; 8320 F0 11                    ..
        inc     $C4                             ; 8322 E6 C4                    ..
        bne     L8311                           ; 8324 D0 EB                    ..
L8326:  jsr     L8023                           ; 8326 20 23 80                  #.
        .byte   $6F                             ; 8329 6F                       o
        stx     $AD                             ; 832A 86 AD                    ..
        stx     $5A                             ; 832C 86 5A                    .Z
        stx     $A7                             ; 832E 86 A7                    ..
        stx     $A1                             ; 8330 86 A1                    ..
        .byte   $86                             ; 8332 86                       .
L8333:  jsr     L8386                           ; 8333 20 86 83                  ..
        tay                                     ; 8336 A8                       .
        bne     L8349                           ; 8337 D0 10                    ..
        sta     $0710,x                         ; 8339 9D 10 07                 ...
        lda     $0704,x                         ; 833C BD 04 07                 ...
        and     #$F8                            ; 833F 29 F8                    ).
        ora     #$04                            ; 8341 09 04                    ..
        sta     $0704,x                         ; 8343 9D 04 07                 ...
        jmp     L80D8                           ; 8346 4C D8 80                 L..

; ----------------------------------------------------------------------------
L8349:  lda     $0704,x                         ; 8349 BD 04 07                 ...
        ora     #$20                            ; 834C 09 20                    . 
        sta     $0704,x                         ; 834E 9D 04 07                 ...
        lda     $0718,x                         ; 8351 BD 18 07                 ...
        asl     a                               ; 8354 0A                       .
        lda     #$54                            ; 8355 A9 54                    .T
        bcs     L835B                           ; 8357 B0 02                    ..
        lda     #$0A                            ; 8359 A9 0A                    ..
L835B:  sta     $071C,x                         ; 835B 9D 1C 07                 ...
        tya                                     ; 835E 98                       .
        bpl     L836B                           ; 835F 10 0A                    ..
        cpx     #$01                            ; 8361 E0 01                    ..
        bne     L8368                           ; 8363 D0 03                    ..
        jsr     L85AE                           ; 8365 20 AE 85                  ..
L8368:  jmp     L8644                           ; 8368 4C 44 86                 LD.

; ----------------------------------------------------------------------------
L836B:  jsr     L85AE                           ; 836B 20 AE 85                  ..
        lda     #$FF                            ; 836E A9 FF                    ..
        sta     $077C,x                         ; 8370 9D 7C 07                 .|.
        dey                                     ; 8373 88                       .
        txa                                     ; 8374 8A                       .
        bne     L837F                           ; 8375 D0 08                    ..
        sta     $C3                             ; 8377 85 C3                    ..
        tya                                     ; 8379 98                       .
        eor     #$0F                            ; 837A 49 0F                    I.
        jmp     L8636                           ; 837C 4C 36 86                 L6.

; ----------------------------------------------------------------------------
L837F:  tya                                     ; 837F 98                       .
        clc                                     ; 8380 18                       .
        adc     $D2                             ; 8381 65 D2                    e.
        jmp     L85DE                           ; 8383 4C DE 85                 L..

; ----------------------------------------------------------------------------
; --- L8386: fetch next SFX stream byte ($D0/$D1 ptr, far fetch).
L8386:  ldy     $D0                             ; 8386 A4 D0                    ..
        lda     $D1                             ; 8388 A5 D1                    ..
        inc     $D0                             ; 838A E6 D0                    ..
        bne     L8390                           ; 838C D0 02                    ..
        inc     $D1                             ; 838E E6 D1                    ..
L8390:  jmp     L803A                           ; 8390 4C 3A 80                 L:.

; ----------------------------------------------------------------------------
; --- L8393: music voice tick (x |= $28 -> fields at $0728+ch): idle if
; no track ptr; count down the note length $0738 by $C7 ticks (key-off
; via L85A3 when the gate counter $0740 expires first), then at note
; end read track bytes: < $20 = opcode (L8497), else b5-7 = length
; index (L8915 straight / L891C dotted, b4 of $0730 latches the dot),
; b0-4 = note (0 = rest): pitch = note + octave offset (L8923) +
; global $CB + channel transpose $0734 -> L85DE; gate counter = length
; * gate fraction $073C; key-on unless resting/tied.
L8393:  txa                                     ; 8393 8A                       .
        ora     #$28                            ; 8394 09 28                    .(
        tax                                     ; 8396 AA                       .
        lda     $0728,x                         ; 8397 BD 28 07                 .(.
        ora     $072C,x                         ; 839A 1D 2C 07                 .,.
        beq     L83CC                           ; 839D F0 2D                    .-
        lda     $0738,x                         ; 839F BD 38 07                 .8.
        beq     L83CD                           ; 83A2 F0 29                    .)
        ldy     $0700,x                         ; 83A4 BC 00 07                 ...
        beq     L83AF                           ; 83A7 F0 06                    ..
        jsr     L8684                           ; 83A9 20 84 86                  ..
        jsr     L86BA                           ; 83AC 20 BA 86                  ..
L83AF:  lda     $0740,x                         ; 83AF BD 40 07                 .@.
        sec                                     ; 83B2 38                       8
        sbc     $C7                             ; 83B3 E5 C7                    ..
        sta     $0740,x                         ; 83B5 9D 40 07                 .@.
        beq     L83BC                           ; 83B8 F0 02                    ..
        bcs     L83BF                           ; 83BA B0 03                    ..
L83BC:  jsr     L85A3                           ; 83BC 20 A3 85                  ..
L83BF:  lda     $0738,x                         ; 83BF BD 38 07                 .8.
        sec                                     ; 83C2 38                       8
        sbc     $C7                             ; 83C3 E5 C7                    ..
        sta     $0738,x                         ; 83C5 9D 38 07                 .8.
        beq     L83CD                           ; 83C8 F0 03                    ..
        bcc     L83CD                           ; 83CA 90 01                    ..
L83CC:  rts                                     ; 83CC 60                       `

; ----------------------------------------------------------------------------
L83CD:  jsr     L8592                           ; 83CD 20 92 85                  ..
        cmp     #$20                            ; 83D0 C9 20                    . 
        bcs     L83DA                           ; 83D2 B0 06                    ..
        jsr     L8497                           ; 83D4 20 97 84                  ..
        jmp     L83CD                           ; 83D7 4C CD 83                 L..

; ----------------------------------------------------------------------------
L83DA:  pha                                     ; 83DA 48                       H
        rol     a                               ; 83DB 2A                       *
        rol     a                               ; 83DC 2A                       *
        rol     a                               ; 83DD 2A                       *
        rol     a                               ; 83DE 2A                       *
        and     #$07                            ; 83DF 29 07                    ).
        tay                                     ; 83E1 A8                       .
        dey                                     ; 83E2 88                       .
        lda     $0730,x                         ; 83E3 BD 30 07                 .0.
        asl     a                               ; 83E6 0A                       .
        asl     a                               ; 83E7 0A                       .
        bpl     L83EF                           ; 83E8 10 05                    ..
        lda     L8915,y                         ; 83EA B9 15 89                 ...
        bne     L8406                           ; 83ED D0 17                    ..
L83EF:  asl     a                               ; 83EF 0A                       .
        asl     a                               ; 83F0 0A                       .
        lda     L891C,y                         ; 83F1 B9 1C 89                 ...
        bcc     L8406                           ; 83F4 90 10                    ..
        sta     $C3                             ; 83F6 85 C3                    ..
        lda     $0730,x                         ; 83F8 BD 30 07                 .0.
        and     #$EF                            ; 83FB 29 EF                    ).
        sta     $0730,x                         ; 83FD 9D 30 07                 .0.
        lda     $C3                             ; 8400 A5 C3                    ..
        lsr     a                               ; 8402 4A                       J
        clc                                     ; 8403 18                       .
        adc     $C3                             ; 8404 65 C3                    e.
L8406:  clc                                     ; 8406 18                       .
        adc     $0738,x                         ; 8407 7D 38 07                 }8.
        sta     $0738,x                         ; 840A 9D 38 07                 .8.
        tay                                     ; 840D A8                       .
        pla                                     ; 840E 68                       h
        and     #$1F                            ; 840F 29 1F                    ).
        bne     L8419                           ; 8411 D0 06                    ..
        jsr     L85A3                           ; 8413 20 A3 85                  ..
        jmp     L8491                           ; 8416 4C 91 84                 L..

; ----------------------------------------------------------------------------
L8419:  pha                                     ; 8419 48                       H
        sty     $C4                             ; 841A 84 C4                    ..
        lda     $073C,x                         ; 841C BD 3C 07                 .<.
        sta     L00C1                           ; 841F 85 C1                    ..
        jsr     L8006                           ; 8421 20 06 80                  ..
        lda     L00C1                           ; 8424 A5 C1                    ..
        bne     L842A                           ; 8426 D0 02                    ..
        lda     #$01                            ; 8428 A9 01                    ..
L842A:  sta     $0740,x                         ; 842A 9D 40 07                 .@.
        pla                                     ; 842D 68                       h
        tay                                     ; 842E A8                       .
        dey                                     ; 842F 88                       .
        lda     $0730,x                         ; 8430 BD 30 07                 .0.
        bpl     L8440                           ; 8433 10 0B                    ..
        lda     $0718,x                         ; 8435 BD 18 07                 ...
        bne     L8454                           ; 8438 D0 1A                    ..
        jsr     L8644                           ; 843A 20 44 86                  D.
        jmp     L847E                           ; 843D 4C 7E 84                 L~.

; ----------------------------------------------------------------------------
L8440:  jsr     L85AE                           ; 8440 20 AE 85                  ..
        lda     $CF                             ; 8443 A5 CF                    ..
        bmi     L8454                           ; 8445 30 0D                    0.
        sty     $C3                             ; 8447 84 C3                    ..
        txa                                     ; 8449 8A                       .
        and     #$03                            ; 844A 29 03                    ).
        tay                                     ; 844C A8                       .
        lda     #$FF                            ; 844D A9 FF                    ..
        sta     $077C,y                         ; 844F 99 7C 07                 .|.
        ldy     $C3                             ; 8452 A4 C3                    ..
L8454:  txa                                     ; 8454 8A                       .
        and     #$03                            ; 8455 29 03                    ).
        bne     L8466                           ; 8457 D0 0D                    ..
        sta     $C3                             ; 8459 85 C3                    ..
        tya                                     ; 845B 98                       .
        and     #$0F                            ; 845C 29 0F                    ).
        eor     #$0F                            ; 845E 49 0F                    I.
        jsr     L8636                           ; 8460 20 36 86                  6.
        jmp     L847E                           ; 8463 4C 7E 84                 L~.

; ----------------------------------------------------------------------------
L8466:  sty     $C3                             ; 8466 84 C3                    ..
        lda     $0730,x                         ; 8468 BD 30 07                 .0.
        and     #$0F                            ; 846B 29 0F                    ).
        tay                                     ; 846D A8                       .
        lda     L8923,y                         ; 846E B9 23 89                 .#.
        clc                                     ; 8471 18                       .
        adc     $C3                             ; 8472 65 C3                    e.
        clc                                     ; 8474 18                       .
        adc     $CB                             ; 8475 65 CB                    e.
        clc                                     ; 8477 18                       .
        adc     $0734,x                         ; 8478 7D 34 07                 }4.
        jsr     L85DE                           ; 847B 20 DE 85                  ..
L847E:  lda     $0730,x                         ; 847E BD 30 07                 .0.
        tay                                     ; 8481 A8                       .
        and     #$40                            ; 8482 29 40                    )@
        asl     a                               ; 8484 0A                       .
        sta     $C4                             ; 8485 85 C4                    ..
        tya                                     ; 8487 98                       .
        and     #$7F                            ; 8488 29 7F                    ).
        ora     $C4                             ; 848A 05 C4                    ..
        sta     $0730,x                         ; 848C 9D 30 07                 .0.
        bpl     L8496                           ; 848F 10 05                    ..
L8491:  lda     #$FF                            ; 8491 A9 FF                    ..
        sta     $0740,x                         ; 8493 9D 40 07                 .@.
L8496:  rts                                     ; 8496 60                       `

; ----------------------------------------------------------------------------
; --- L8497: music opcode dispatch (ops >= $04 pull a parameter byte
; into $C3 first). Table follows the jsr: $00/$01/$02 toggle track
; flags $40 tie / $10 dot / $08 staccato, $03 set octave, then: tempo
; ($84F1, 2 params), gate fraction ($84FF), octave set ($8505), global
; transpose ($8510), channel transpose ($8515), loop ops ($851B/1F/23/
; 27 select one of 4 loop-counter slots: count N, jump target follows;
; variant >= $12 = loop-with-alternate-ending via $8547), end-of-track
; ($8580: kill channel), instrument ($866F), vibrato ($86A1),
; portamento speed ($86A7), duty/volume ($86AD, noise variant $865A).
L8497:  cmp     #$04                            ; 8497 C9 04                    ..
        bcc     L84A4                           ; 8499 90 09                    ..
        sta     $C4                             ; 849B 85 C4                    ..
        jsr     L8592                           ; 849D 20 92 85                  ..
        sta     $C3                             ; 84A0 85 C3                    ..
        lda     $C4                             ; 84A2 A5 C4                    ..
L84A4:  jsr     L8023                           ; 84A4 20 23 80                  #.
        cmp     $DD84,y                         ; 84A7 D9 84 DD                 ...
        sty     $E1                             ; 84AA 84 E1                    ..
        sty     $E8                             ; 84AC 84 E8                    ..
        sty     $75                             ; 84AE 84 75                    .u
        sta     $F1                             ; 84B0 85 F1                    ..
        sty     $FF                             ; 84B2 84 FF                    ..
        sty     $5A                             ; 84B4 84 5A                    .Z
        stx     $6F                             ; 84B6 86 6F                    .o
        stx     $05                             ; 84B8 86 05                    ..
        sta     $10                             ; 84BA 85 10                    ..
        sta     $15                             ; 84BC 85 15                    ..
        sta     $A1                             ; 84BE 85 A1                    ..
        stx     $A7                             ; 84C0 86 A7                    ..
        stx     $1B                             ; 84C2 86 1B                    ..
        sta     $1F                             ; 84C4 85 1F                    ..
        sta     $23                             ; 84C6 85 23                    .#
        sta     $27                             ; 84C8 85 27                    .'
        sta     $1B                             ; 84CA 85 1B                    ..
        sta     $1F                             ; 84CC 85 1F                    ..
        sta     $23                             ; 84CE 85 23                    .#
        sta     $27                             ; 84D0 85 27                    .'
        sta     $5A                             ; 84D2 85 5A                    .Z
        sta     $80                             ; 84D4 85 80                    ..
        sta     $AD                             ; 84D6 85 AD                    ..
        stx     $A9                             ; 84D8 86 A9                    ..
        jsr     L0DD0                           ; 84DA 20 D0 0D                  ..
        lda     #$40                            ; 84DD A9 40                    .@
        bne     L84EA                           ; 84DF D0 09                    ..
        lda     #$10                            ; 84E1 A9 10                    ..
        ora     $0730,x                         ; 84E3 1D 30 07                 .0.
        bne     L84ED                           ; 84E6 D0 05                    ..
        lda     #$08                            ; 84E8 A9 08                    ..
L84EA:  eor     $0730,x                         ; 84EA 5D 30 07                 ]0.
L84ED:  sta     $0730,x                         ; 84ED 9D 30 07                 .0.
        rts                                     ; 84F0 60                       `

; ----------------------------------------------------------------------------
; --- $84F1: op: set tempo ($C9/$CA from 2 params).
        lda     #$00                            ; 84F1 A9 00                    ..
        sta     $C8                             ; 84F3 85 C8                    ..
        jsr     L8592                           ; 84F5 20 92 85                  ..
        ldy     $C3                             ; 84F8 A4 C3                    ..
        sta     $CA                             ; 84FA 85 CA                    ..
        sty     $C9                             ; 84FC 84 C9                    ..
        rts                                     ; 84FE 60                       `

; ----------------------------------------------------------------------------
; --- $84FF: op: set gate fraction $073C.
        lda     $C3                             ; 84FF A5 C3                    ..
        sta     $073C,x                         ; 8501 9D 3C 07                 .<.
        rts                                     ; 8504 60                       `

; ----------------------------------------------------------------------------
; --- $8505: op: set octave (track flags b0-2).
        lda     $0730,x                         ; 8505 BD 30 07                 .0.
        and     #$F8                            ; 8508 29 F8                    ).
        ora     $C3                             ; 850A 05 C3                    ..
        sta     $0730,x                         ; 850C 9D 30 07                 .0.
        rts                                     ; 850F 60                       `

; ----------------------------------------------------------------------------
; --- $8510: op: set global transpose $CB.
        lda     $C3                             ; 8510 A5 C3                    ..
        sta     $CB                             ; 8512 85 CB                    ..
        rts                                     ; 8514 60                       `

; ----------------------------------------------------------------------------
; --- $8515: op: set channel transpose $0734.
        lda     $C3                             ; 8515 A5 C3                    ..
        sta     $0734,x                         ; 8517 9D 34 07                 .4.
        rts                                     ; 851A 60                       `

; ----------------------------------------------------------------------------
; --- $851B/1F/23/27: loop ops, one per counter slot; see L8497.
        lda     #$00                            ; 851B A9 00                    ..
        beq     L8529                           ; 851D F0 0A                    ..
        lda     #$04                            ; 851F A9 04                    ..
        bne     L8529                           ; 8521 D0 06                    ..
        lda     #$08                            ; 8523 A9 08                    ..
        bne     L8529                           ; 8525 D0 02                    ..
        lda     #$0C                            ; 8527 A9 0C                    ..
L8529:  sta     $C2                             ; 8529 85 C2                    ..
        txa                                     ; 852B 8A                       .
        clc                                     ; 852C 18                       .
        adc     $C2                             ; 852D 65 C2                    e.
        tay                                     ; 852F A8                       .
        lda     $C4                             ; 8530 A5 C4                    ..
        cmp     #$12                            ; 8532 C9 12                    ..
        bcs     L8547                           ; 8534 B0 11                    ..
        lda     $0744,y                         ; 8536 B9 44 07                 .D.
        sec                                     ; 8539 38                       8
        sbc     #$01                            ; 853A E9 01                    ..
        bcs     L8540                           ; 853C B0 02                    ..
        lda     $C3                             ; 853E A5 C3                    ..
L8540:  sta     $0744,y                         ; 8540 99 44 07                 .D.
        beq     L8566                           ; 8543 F0 21                    .!
        bne     L8555                           ; 8545 D0 0E                    ..
L8547:  lda     $0744,y                         ; 8547 B9 44 07                 .D.
        sec                                     ; 854A 38                       8
        sbc     #$01                            ; 854B E9 01                    ..
        bne     L8566                           ; 854D D0 17                    ..
        sta     $0744,y                         ; 854F 99 44 07                 .D.
        jsr     L8575                           ; 8552 20 75 85                  u.
L8555:  jsr     L8592                           ; 8555 20 92 85                  ..
        sta     $C3                             ; 8558 85 C3                    ..
        jsr     L8592                           ; 855A 20 92 85                  ..
        sta     $0728,x                         ; 855D 9D 28 07                 .(.
        lda     $C3                             ; 8560 A5 C3                    ..
        sta     $072C,x                         ; 8562 9D 2C 07                 .,.
        rts                                     ; 8565 60                       `

; ----------------------------------------------------------------------------
; --- L8566: loop not taken: skip the 2-byte jump target.
L8566:  lda     #$02                            ; 8566 A9 02                    ..
        clc                                     ; 8568 18                       .
        adc     $0728,x                         ; 8569 7D 28 07                 }(.
        .byte   $9D                             ; 856C 9D                       .
        plp                                     ; 856D 28                       (
L856E:  .byte   $07                             ; 856E 07                       .
        bcc     L8574                           ; 856F 90 03                    ..
        inc     $072C,x                         ; 8571 FE 2C 07                 .,.
L8574:  rts                                     ; 8574 60                       `

; ----------------------------------------------------------------------------
L8575:  lda     $0730,x                         ; 8575 BD 30 07                 .0.
        and     #$97                            ; 8578 29 97                    ).
        ora     $C3                             ; 857A 05 C3                    ..
        sta     $0730,x                         ; 857C 9D 30 07                 .0.
        rts                                     ; 857F 60                       `

; ----------------------------------------------------------------------------
; --- $8580: op: end of track — abandon the opcode loop, clear the
; track pointer, silence the channel unless SFX holds it.
        pla                                     ; 8580 68                       h
        pla                                     ; 8581 68                       h
        lda     #$00                            ; 8582 A9 00                    ..
        sta     $0728,x                         ; 8584 9D 28 07                 .(.
        sta     $072C,x                         ; 8587 9D 2C 07                 .,.
        lda     $CF                             ; 858A A5 CF                    ..
        bmi     L8591                           ; 858C 30 03                    0.
        jmp     L80D8                           ; 858E 4C D8 80                 L..

; ----------------------------------------------------------------------------
L8591:  rts                                     ; 8591 60                       `

; ----------------------------------------------------------------------------
; --- L8592: fetch next music track byte (ptr $0728/$072C, far fetch).
L8592:  ldy     $0728,x                         ; 8592 BC 28 07                 .(.
        lda     $072C,x                         ; 8595 BD 2C 07                 .,.
        inc     $0728,x                         ; 8598 FE 28 07                 .(.
        bne     L85A0                           ; 859B D0 03                    ..
        inc     $072C,x                         ; 859D FE 2C 07                 .,.
L85A0:  jmp     L803A                           ; 85A0 4C 3A 80                 L:.

; ----------------------------------------------------------------------------
; --- L85A3: key off: envelope phase = 3 (release).
L85A3:  lda     $0704,x                         ; 85A3 BD 04 07                 ...
        and     #$F8                            ; 85A6 29 F8                    ).
        ora     #$03                            ; 85A8 09 03                    ..
        sta     $0704,x                         ; 85AA 9D 04 07                 ...
        rts                                     ; 85AD 60                       `

; ----------------------------------------------------------------------------
; --- L85AE: key on: envelope phase = 0 (or 2 = sustain for the
; triangle, whose gate scales the linear counter via the multiply).
L85AE:  tya                                     ; 85AE 98                       .
        pha                                     ; 85AF 48                       H
        ldy     #$00                            ; 85B0 A0 00                    ..
        lda     $0704,x                         ; 85B2 BD 04 07                 ...
        and     #$F8                            ; 85B5 29 F8                    ).
        sta     $0704,x                         ; 85B7 9D 04 07                 ...
        cpx     #$29                            ; 85BA E0 29                    .)
        beq     L85D0                           ; 85BC F0 12                    ..
        cpx     #$01                            ; 85BE E0 01                    ..
        bne     L85D7                           ; 85C0 D0 15                    ..
        lda     $D3                             ; 85C2 A5 D3                    ..
        sta     L00C1                           ; 85C4 85 C1                    ..
        lda     $070C,x                         ; 85C6 BD 0C 07                 ...
        sta     $C4                             ; 85C9 85 C4                    ..
        jsr     L8006                           ; 85CB 20 06 80                  ..
        ldy     L00C1                           ; 85CE A4 C1                    ..
L85D0:  iny                                     ; 85D0 C8                       .
        inc     $0704,x                         ; 85D1 FE 04 07                 ...
        inc     $0704,x                         ; 85D4 FE 04 07                 ...
L85D7:  tya                                     ; 85D7 98                       .
        sta     $0710,x                         ; 85D8 9D 10 07                 ...
        pla                                     ; 85DB 68                       h
        tay                                     ; 85DC A8                       .
        rts                                     ; 85DD 60                       `

; ----------------------------------------------------------------------------
; --- L85DE: set pitch from note A (clamped to $5F): music channels run
; portamento bookkeeping ($0718 speed toward target $071C, flag b5),
; then period from the L8959/L895A table into $0720/$0724; instrument
; b7 of byte 4 also restarts the envelope on retrigger.
L85DE:  cmp     #$60                            ; 85DE C9 60                    .`
        bcc     L85E4                           ; 85E0 90 02                    ..
        lda     #$5F                            ; 85E2 A9 5F                    ._
L85E4:  sta     $C3                             ; 85E4 85 C3                    ..
        inc     $C3                             ; 85E6 E6 C3                    ..
        cpx     #$28                            ; 85E8 E0 28                    .(
        bcc     L862A                           ; 85EA 90 3E                    .>
        lda     $071C,x                         ; 85EC BD 1C 07                 ...
        beq     L861D                           ; 85EF F0 2C                    .,
        cmp     $C3                             ; 85F1 C5 C3                    ..
        bne     L85FC                           ; 85F3 D0 07                    ..
        lda     $0730,x                         ; 85F5 BD 30 07                 .0.
        bpl     L861D                           ; 85F8 10 23                    .#
        bmi     L8644                           ; 85FA 30 48                    0H
L85FC:  lda     $0718,x                         ; 85FC BD 18 07                 ...
        beq     L861D                           ; 85FF F0 1C                    ..
        bcs     L8607                           ; 8601 B0 04                    ..
        ora     #$80                            ; 8603 09 80                    ..
        bne     L8609                           ; 8605 D0 02                    ..
L8607:  and     #$7F                            ; 8607 29 7F                    ).
L8609:  sta     $0718,x                         ; 8609 9D 18 07                 ...
        lda     $0704,x                         ; 860C BD 04 07                 ...
        ora     #$20                            ; 860F 09 20                    . 
        sta     $0704,x                         ; 8611 9D 04 07                 ...
        lda     $C3                             ; 8614 A5 C3                    ..
        ldy     $071C,x                         ; 8616 BC 1C 07                 ...
        sty     $C3                             ; 8619 84 C3                    ..
        bne     L8627                           ; 861B D0 0A                    ..
L861D:  lda     $0704,x                         ; 861D BD 04 07                 ...
        and     #$DF                            ; 8620 29 DF                    ).
        sta     $0704,x                         ; 8622 9D 04 07                 ...
        lda     $C3                             ; 8625 A5 C3                    ..
L8627:  sta     $071C,x                         ; 8627 9D 1C 07                 ...
L862A:  asl     $C3                             ; 862A 06 C3                    ..
        ldy     $C3                             ; 862C A4 C3                    ..
        lda     L8959,y                         ; 862E B9 59 89                 .Y.
        sta     $C3                             ; 8631 85 C3                    ..
        lda     L895A,y                         ; 8633 B9 5A 89                 .Z.
L8636:  sta     $0724,x                         ; 8636 9D 24 07                 .$.
        lda     $C3                             ; 8639 A5 C3                    ..
        sta     $0720,x                         ; 863B 9D 20 07                 . .
        ldy     #$04                            ; 863E A0 04                    ..
        lda     ($C5),y                         ; 8640 B1 C5                    ..
        bmi     L864C                           ; 8642 30 08                    0.
L8644:  lda     $0704,x                         ; 8644 BD 04 07                 ...
        and     #$08                            ; 8647 29 08                    ).
        bne     L864C                           ; 8649 D0 01                    ..
        rts                                     ; 864B 60                       `

; ----------------------------------------------------------------------------
L864C:  lda     #$00                            ; 864C A9 00                    ..
        sta     $0708,x                         ; 864E 9D 08 07                 ...
        lda     $0704,x                         ; 8651 BD 04 07                 ...
        and     #$37                            ; 8654 29 37                    )7
        sta     $0704,x                         ; 8656 9D 04 07                 ...
        rts                                     ; 8659 60                       `

; ----------------------------------------------------------------------------
; --- $865A: op: set volume (noise/triangle variants keep b6-7).
        cpx     #$01                            ; 865A E0 01                    ..
        bne     L8662                           ; 865C D0 04                    ..
        lda     $C3                             ; 865E A5 C3                    ..
        bne     L866B                           ; 8660 D0 09                    ..
L8662:  lda     $070C,x                         ; 8662 BD 0C 07                 ...
        and     #$C0                            ; 8665 29 C0                    ).
        ora     $C3                             ; 8667 05 C3                    ..
        ora     #$30                            ; 8669 09 30                    .0
L866B:  sta     $070C,x                         ; 866B 9D 0C 07                 ...
        rts                                     ; 866E 60                       `

; ----------------------------------------------------------------------------
; --- $866F: op: set instrument: $C5/$C6 = instr table + (n-1)*8
; (L8684 = recompute entry, shared with the envelope tick).
        inc     $C3                             ; 866F E6 C3                    ..
        lda     $C3                             ; 8671 A5 C3                    ..
        cmp     $0700,x                         ; 8673 DD 00 07                 ...
        beq     L86A0                           ; 8676 F0 28                    .(
        sta     $0700,x                         ; 8678 9D 00 07                 ...
        tay                                     ; 867B A8                       .
        lda     $0704,x                         ; 867C BD 04 07                 ...
        ora     #$08                            ; 867F 09 08                    ..
        sta     $0704,x                         ; 8681 9D 04 07                 ...
L8684:  dey                                     ; 8684 88                       .
        lda     #$00                            ; 8685 A9 00                    ..
        sta     $C3                             ; 8687 85 C3                    ..
        tya                                     ; 8689 98                       .
        asl     a                               ; 868A 0A                       .
        rol     $C3                             ; 868B 26 C3                    &.
        asl     a                               ; 868D 0A                       .
        rol     $C3                             ; 868E 26 C3                    &.
        asl     a                               ; 8690 0A                       .
        rol     $C3                             ; 8691 26 C3                    &.
        clc                                     ; 8693 18                       .
        adc     L8A42                           ; 8694 6D 42 8A                 mB.
        sta     $C5                             ; 8697 85 C5                    ..
        lda     $C3                             ; 8699 A5 C3                    ..
        adc     L8A41                           ; 869B 6D 41 8A                 mA.
        sta     $C6                             ; 869E 85 C6                    ..
L86A0:  rts                                     ; 86A0 60                       `

; ----------------------------------------------------------------------------
; --- $86A1: op: set vibrato/detune depth $0714.
        lda     $C3                             ; 86A1 A5 C3                    ..
        sta     $0714,x                         ; 86A3 9D 14 07                 ...
        rts                                     ; 86A6 60                       `

; ----------------------------------------------------------------------------
; --- $86A7: op: set portamento speed $0718.
        lda     $C3                             ; 86A7 A5 C3                    ..
        sta     $0718,x                         ; 86A9 9D 18 07                 ...
        rts                                     ; 86AC 60                       `

; ----------------------------------------------------------------------------
; --- $86AD: op: set duty (volume shadow high nibble).
        lda     $070C,x                         ; 86AD BD 0C 07                 ...
        and     #$0F                            ; 86B0 29 0F                    ).
        ora     $C3                             ; 86B2 05 C3                    ..
        ora     #$30                            ; 86B4 09 30                    .0
        sta     $070C,x                         ; 86B6 9D 0C 07                 ...
        rts                                     ; 86B9 60                       `

; ----------------------------------------------------------------------------
; --- L86BA: envelope tick: phase 0-3 handlers via L8023 (attack to $F0
; cap, decay to sustain level, sustain, release to 0) using instrument
; rate indexes into the L8933 step table; updates volume $0710 and
; phase in $0704.
L86BA:  lda     $0710,x                         ; 86BA BD 10 07                 ...
        sta     $C4                             ; 86BD 85 C4                    ..
        lda     $0704,x                         ; 86BF BD 04 07                 ...
        and     #$07                            ; 86C2 29 07                    ).
        jsr     L8023                           ; 86C4 20 23 80                  #.
        cmp     ($86),y                         ; 86C7 D1 86                    ..
        inc     $86                             ; 86C9 E6 86                    ..
        jsr     L0287                           ; 86CB 20 87 02                  ..
        .byte   $87                             ; 86CE 87                       .
        .byte   $14                             ; 86CF 14                       .
        .byte   $89                             ; 86D0 89                       .
        ldy     #$00                            ; 86D1 A0 00                    ..
        lda     ($C5),y                         ; 86D3 B1 C5                    ..
        tay                                     ; 86D5 A8                       .
        lda     $C4                             ; 86D6 A5 C4                    ..
        clc                                     ; 86D8 18                       .
        adc     L8933,y                         ; 86D9 79 33 89                 y3.
        bcs     L86E2                           ; 86DC B0 04                    ..
        cmp     #$F0                            ; 86DE C9 F0                    ..
        bcc     L871D                           ; 86E0 90 3B                    .;
L86E2:  lda     #$F0                            ; 86E2 A9 F0                    ..
        bne     L871A                           ; 86E4 D0 34                    .4
        ldy     #$01                            ; 86E6 A0 01                    ..
        lda     ($C5),y                         ; 86E8 B1 C5                    ..
        beq     L86FB                           ; 86EA F0 0F                    ..
        tay                                     ; 86EC A8                       .
        lda     $C4                             ; 86ED A5 C4                    ..
        sec                                     ; 86EF 38                       8
        sbc     L8933,y                         ; 86F0 F9 33 89                 .3.
        bcc     L86FB                           ; 86F3 90 06                    ..
        ldy     #$02                            ; 86F5 A0 02                    ..
        cmp     ($C5),y                         ; 86F7 D1 C5                    ..
        bcs     L871D                           ; 86F9 B0 22                    ."
L86FB:  ldy     #$02                            ; 86FB A0 02                    ..
        lda     ($C5),y                         ; 86FD B1 C5                    ..
        jmp     L871A                           ; 86FF 4C 1A 87                 L..

; ----------------------------------------------------------------------------
        txa                                     ; 8702 8A                       .
        and     #$03                            ; 8703 29 03                    ).
        cmp     #$01                            ; 8705 C9 01                    ..
        beq     L8718                           ; 8707 F0 0F                    ..
        ldy     #$03                            ; 8709 A0 03                    ..
        lda     ($C5),y                         ; 870B B1 C5                    ..
        beq     L8720                           ; 870D F0 11                    ..
        tay                                     ; 870F A8                       .
        lda     $C4                             ; 8710 A5 C4                    ..
        sec                                     ; 8712 38                       8
        sbc     L8933,y                         ; 8713 F9 33 89                 .3.
        bcs     L871D                           ; 8716 B0 05                    ..
L8718:  lda     #$00                            ; 8718 A9 00                    ..
L871A:  inc     $0704,x                         ; 871A FE 04 07                 ...
L871D:  sta     $0710,x                         ; 871D 9D 10 07                 ...
L8720:  cpx     #$28                            ; 8720 E0 28                    .(
        bcc     L8737                           ; 8722 90 13                    ..
        lda     $CF                             ; 8724 A5 CF                    ..
        bpl     L872B                           ; 8726 10 03                    ..
        jmp     L88A0                           ; 8728 4C A0 88                 L..

; ----------------------------------------------------------------------------
L872B:  lda     $CD                             ; 872B A5 CD                    ..
        ldy     $CC                             ; 872D A4 CC                    ..
        bmi     L8733                           ; 872F 30 02                    0.
        eor     #$FF                            ; 8731 49 FF                    I.
L8733:  cmp     #$FF                            ; 8733 C9 FF                    ..
        bne     L8740                           ; 8735 D0 09                    ..
L8737:  txa                                     ; 8737 8A                       .
        and     #$03                            ; 8738 29 03                    ).
        cmp     #$01                            ; 873A C9 01                    ..
        bne     L8760                           ; 873C D0 22                    ."
        beq     L8752                           ; 873E F0 12                    ..
L8740:  cpx     #$29                            ; 8740 E0 29                    .)
        bne     L875B                           ; 8742 D0 17                    ..
        sta     $C4                             ; 8744 85 C4                    ..
        lda     $0740,x                         ; 8746 BD 40 07                 .@.
        sta     L00C1                           ; 8749 85 C1                    ..
        jsr     L8006                           ; 874B 20 06 80                  ..
        lda     L00C1                           ; 874E A5 C1                    ..
        beq     L87AA                           ; 8750 F0 58                    .X
L8752:  lda     $0710,x                         ; 8752 BD 10 07                 ...
        beq     L87AA                           ; 8755 F0 53                    .S
        lda     #$FF                            ; 8757 A9 FF                    ..
        bne     L87AA                           ; 8759 D0 4F                    .O
; --- $875B: write volume: 4-bit level from envelope (SFX capped by
; $D4, music scaled by master fade $CD), tremolo from instrument byte
; 6 (>= 5: depth * envelope via the multiply), then vol|duty to the
; APU; $87B3: vibrato from instrument byte 5 scales into a period
; offset; noise ($8835) packs period-4-bit | instrument noise mode;
; pitched channels normalize through the octave thresholds L8953,
; add the track vibrato/detune $0714, write period lo, and rewrite
; period hi (+ length reload) only when it changed ($077C guard);
; $8814 adds the $D8 control-op pitch offset to SFX periods.
L875B:  cmp     $0710,x                         ; 875B DD 10 07                 ...
        bcc     L8763                           ; 875E 90 03                    ..
L8760:  lda     $0710,x                         ; 8760 BD 10 07                 ...
L8763:  lsr     a                               ; 8763 4A                       J
        lsr     a                               ; 8764 4A                       J
        lsr     a                               ; 8765 4A                       J
        lsr     a                               ; 8766 4A                       J
        eor     #$0F                            ; 8767 49 0F                    I.
        sta     $C3                             ; 8769 85 C3                    ..
        ldy     #$06                            ; 876B A0 06                    ..
        lda     ($C5),y                         ; 876D B1 C5                    ..
        cmp     #$05                            ; 876F C9 05                    ..
        bcc     L8797                           ; 8771 90 24                    .$
        sta     $C4                             ; 8773 85 C4                    ..
        ldy     $0708,x                         ; 8775 BC 08 07                 ...
        lda     $0704,x                         ; 8778 BD 04 07                 ...
        asl     a                               ; 877B 0A                       .
        asl     a                               ; 877C 0A                       .
        tya                                     ; 877D 98                       .
        bcc     L8782                           ; 877E 90 02                    ..
        eor     #$FF                            ; 8780 49 FF                    I.
L8782:  beq     L8797                           ; 8782 F0 13                    ..
        sta     L00C1                           ; 8784 85 C1                    ..
        jsr     L8006                           ; 8786 20 06 80                  ..
L8789:  lda     L00C1                           ; 8789 A5 C1                    ..
        lsr     a                               ; 878B 4A                       J
        lsr     a                               ; 878C 4A                       J
        cmp     #$10                            ; 878D C9 10                    ..
        bcs     L87A5                           ; 878F B0 14                    ..
        cmp     $C3                             ; 8791 C5 C3                    ..
        bcc     L8797                           ; 8793 90 02                    ..
        sta     $C3                             ; 8795 85 C3                    ..
L8797:  lda     #$10                            ; 8797 A9 10                    ..
        sta     $C4                             ; 8799 85 C4                    ..
        lda     $070C,x                         ; 879B BD 0C 07                 ...
        sec                                     ; 879E 38                       8
        sbc     $C3                             ; 879F E5 C3                    ..
        bit     $C4                             ; 87A1 24 C4                    $.
        bne     L87AA                           ; 87A3 D0 05                    ..
L87A5:  lda     $070C,x                         ; 87A5 BD 0C 07                 ...
        and     #$F0                            ; 87A8 29 F0                    ).
L87AA:  ldy     #$00                            ; 87AA A0 00                    ..
        jsr     L80EC                           ; 87AC 20 EC 80                  ..
        txa                                     ; 87AF 8A                       .
        and     #$03                            ; 87B0 29 03                    ).
        tay                                     ; 87B2 A8                       .
        lda     $077C,y                         ; 87B3 B9 7C 07                 .|.
        bmi     L880C                           ; 87B6 30 54                    0T
        ldy     #$05                            ; 87B8 A0 05                    ..
        lda     ($C5),y                         ; 87BA B1 C5                    ..
        beq     L880C                           ; 87BC F0 4E                    .N
        sta     $C4                             ; 87BE 85 C4                    ..
        ldy     $0708,x                         ; 87C0 BC 08 07                 ...
        lda     $0704,x                         ; 87C3 BD 04 07                 ...
        asl     a                               ; 87C6 0A                       .
        asl     a                               ; 87C7 0A                       .
        tya                                     ; 87C8 98                       .
        bcc     L87CD                           ; 87C9 90 02                    ..
        eor     #$FF                            ; 87CB 49 FF                    I.
L87CD:  beq     L880C                           ; 87CD F0 3D                    .=
        sta     L00C1                           ; 87CF 85 C1                    ..
        jsr     L8006                           ; 87D1 20 06 80                  ..
        lda     L00C1                           ; 87D4 A5 C1                    ..
        lsr     a                               ; 87D6 4A                       J
        ror     $C2                             ; 87D7 66 C2                    f.
        lsr     a                               ; 87D9 4A                       J
        ror     $C2                             ; 87DA 66 C2                    f.
        lsr     a                               ; 87DC 4A                       J
        ror     $C2                             ; 87DD 66 C2                    f.
        lsr     a                               ; 87DF 4A                       J
        ror     $C2                             ; 87E0 66 C2                    f.
        tay                                     ; 87E2 A8                       .
        ora     $C2                             ; 87E3 05 C2                    ..
        beq     L880C                           ; 87E5 F0 25                    .%
        lda     $0704,x                         ; 87E7 BD 04 07                 ...
        bmi     L87FA                           ; 87EA 30 0E                    0.
        clc                                     ; 87EC 18                       .
        lda     $C2                             ; 87ED A5 C2                    ..
        adc     $0720,x                         ; 87EF 7D 20 07                 } .
        sta     $C2                             ; 87F2 85 C2                    ..
        tya                                     ; 87F4 98                       .
        adc     $0724,x                         ; 87F5 7D 24 07                 }$.
        bne     L8809                           ; 87F8 D0 0F                    ..
L87FA:  sec                                     ; 87FA 38                       8
        lda     $0720,x                         ; 87FB BD 20 07                 . .
        sbc     $C2                             ; 87FE E5 C2                    ..
        sta     $C2                             ; 8800 85 C2                    ..
        .byte   $BD                             ; 8802 BD                       .
L8803:  bit     $07                             ; 8803 24 07                    $.
        sty     L00C1                           ; 8805 84 C1                    ..
        sbc     L00C1                           ; 8807 E5 C1                    ..
L8809:  tay                                     ; 8809 A8                       .
        bne     L8814                           ; 880A D0 08                    ..
L880C:  lda     $0720,x                         ; 880C BD 20 07                 . .
        sta     $C2                             ; 880F 85 C2                    ..
        ldy     $0724,x                         ; 8811 BC 24 07                 .$.
L8814:  cpx     #$28                            ; 8814 E0 28                    .(
        bcs     L8835                           ; 8816 B0 1D                    ..
        lda     $D6                             ; 8818 A5 D6                    ..
        bpl     L8835                           ; 881A 10 19                    ..
        lda     $D8                             ; 881C A5 D8                    ..
        beq     L8835                           ; 881E F0 15                    ..
        sta     $C4                             ; 8820 85 C4                    ..
        sty     L00C1                           ; 8822 84 C1                    ..
        lda     $C2                             ; 8824 A5 C2                    ..
        pha                                     ; 8826 48                       H
        jsr     L8006                           ; 8827 20 06 80                  ..
        pla                                     ; 882A 68                       h
        clc                                     ; 882B 18                       .
        adc     $C2                             ; 882C 65 C2                    e.
        sta     $C2                             ; 882E 85 C2                    ..
        lda     #$00                            ; 8830 A9 00                    ..
        adc     L00C1                           ; 8832 65 C1                    e.
        tay                                     ; 8834 A8                       .
L8835:  txa                                     ; 8835 8A                       .
        and     #$03                            ; 8836 29 03                    ).
        bne     L8849                           ; 8838 D0 0F                    ..
        tya                                     ; 883A 98                       .
        and     #$0F                            ; 883B 29 0F                    ).
        ldy     #$07                            ; 883D A0 07                    ..
        ora     ($C5),y                         ; 883F 11 C5                    ..
        sta     $C2                             ; 8841 85 C2                    ..
        lda     #$00                            ; 8843 A9 00                    ..
        sta     L00C1                           ; 8845 85 C1                    ..
        beq     L8884                           ; 8847 F0 3B                    .;
L8849:  tya                                     ; 8849 98                       .
        ldy     #$08                            ; 884A A0 08                    ..
L884C:  dey                                     ; 884C 88                       .
        cmp     L8953,y                         ; 884D D9 53 89                 .S.
        bcc     L884C                           ; 8850 90 FA                    ..
        sta     L00C1                           ; 8852 85 C1                    ..
        tya                                     ; 8854 98                       .
        clc                                     ; 8855 18                       .
        adc     L00C1                           ; 8856 65 C1                    e.
        tay                                     ; 8858 A8                       .
        and     #$07                            ; 8859 29 07                    ).
        clc                                     ; 885B 18                       .
        adc     #$07                            ; 885C 69 07                    i.
        sta     L00C1                           ; 885E 85 C1                    ..
        tya                                     ; 8860 98                       .
        and     #$38                            ; 8861 29 38                    )8
        eor     #$38                            ; 8863 49 38                    I8
L8865:  beq     L8870                           ; 8865 F0 09                    ..
L8867:  lsr     L00C1                           ; 8867 46 C1                    F.
        ror     $C2                             ; 8869 66 C2                    f.
        sec                                     ; 886B 38                       8
        sbc     #$08                            ; 886C E9 08                    ..
        bne     L8867                           ; 886E D0 F7                    ..
L8870:  ldy     #$00                            ; 8870 A0 00                    ..
        lda     $0714,x                         ; 8872 BD 14 07                 ...
        beq     L8884                           ; 8875 F0 0D                    ..
        bpl     L887A                           ; 8877 10 01                    ..
        dey                                     ; 8879 88                       .
L887A:  clc                                     ; 887A 18                       .
        adc     $C2                             ; 887B 65 C2                    e.
        sta     $C2                             ; 887D 85 C2                    ..
        tya                                     ; 887F 98                       .
        adc     L00C1                           ; 8880 65 C1                    e.
        sta     L00C1                           ; 8882 85 C1                    ..
L8884:  .byte   $A0                             ; 8884 A0                       .
L8885:  .byte   $02                             ; 8885 02                       .
        lda     $C2                             ; 8886 A5 C2                    ..
        jsr     L80EC                           ; 8888 20 EC 80                  ..
        txa                                     ; 888B 8A                       .
        and     #$03                            ; 888C 29 03                    ).
        tay                                     ; 888E A8                       .
        lda     L00C1                           ; 888F A5 C1                    ..
        cmp     $077C,y                         ; 8891 D9 7C 07                 .|.
        beq     L88A0                           ; 8894 F0 0A                    ..
        sta     $077C,y                         ; 8896 99 7C 07                 .|.
        ora     #$08                            ; 8899 09 08                    ..
        ldy     #$03                            ; 889B A0 03                    ..
        jsr     L80EC                           ; 889D 20 EC 80                  ..
; --- L88A0: portamento glide: step period by $0718 toward the target
; note's period each frame, snapping (and clearing b5) on arrival;
; then $88FA advances the envelope level by instrument env speed.
L88A0:  lda     $0704,x                         ; 88A0 BD 04 07                 ...
        and     #$20                            ; 88A3 29 20                    ) 
        beq     L88FA                           ; 88A5 F0 53                    .S
        lda     $0718,x                         ; 88A7 BD 18 07                 ...
        beq     L88F2                           ; 88AA F0 46                    .F
        ldy     #$00                            ; 88AC A0 00                    ..
        asl     a                               ; 88AE 0A                       .
        php                                     ; 88AF 08                       .
        bcc     L88B8                           ; 88B0 90 06                    ..
        eor     #$FF                            ; 88B2 49 FF                    I.
        clc                                     ; 88B4 18                       .
        adc     #$01                            ; 88B5 69 01                    i.
        dey                                     ; 88B7 88                       .
L88B8:  clc                                     ; 88B8 18                       .
        adc     $0720,x                         ; 88B9 7D 20 07                 } .
        sta     $0720,x                         ; 88BC 9D 20 07                 . .
        tya                                     ; 88BF 98                       .
        adc     $0724,x                         ; 88C0 7D 24 07                 }$.
        sta     $0724,x                         ; 88C3 9D 24 07                 .$.
        lda     $071C,x                         ; 88C6 BD 1C 07                 ...
        asl     a                               ; 88C9 0A                       .
        tay                                     ; 88CA A8                       .
        sec                                     ; 88CB 38                       8
        lda     $0720,x                         ; 88CC BD 20 07                 . .
        sbc     L8959,y                         ; 88CF F9 59 89                 .Y.
        lda     $0724,x                         ; 88D2 BD 24 07                 .$.
        and     #$3F                            ; 88D5 29 3F                    )?
        sbc     L895A,y                         ; 88D7 F9 5A 89                 .Z.
        lda     #$FF                            ; 88DA A9 FF                    ..
        adc     #$00                            ; 88DC 69 00                    i.
        plp                                     ; 88DE 28                       (
        adc     #$00                            ; 88DF 69 00                    i.
        bne     L88FA                           ; 88E1 D0 17                    ..
        txa                                     ; 88E3 8A                       .
        beq     L88FA                           ; 88E4 F0 14                    ..
        lda     L8959,y                         ; 88E6 B9 59 89                 .Y.
        sta     $0720,x                         ; 88E9 9D 20 07                 . .
        lda     L895A,y                         ; 88EC B9 5A 89                 .Z.
        sta     $0724,x                         ; 88EF 9D 24 07                 .$.
L88F2:  lda     $0704,x                         ; 88F2 BD 04 07                 ...
        and     #$DF                            ; 88F5 29 DF                    ).
        sta     $0704,x                         ; 88F7 9D 04 07                 ...
L88FA:  ldy     #$04                            ; 88FA A0 04                    ..
        lda     ($C5),y                         ; 88FC B1 C5                    ..
        and     #$7F                            ; 88FE 29 7F                    ).
        beq     L8914                           ; 8900 F0 12                    ..
        clc                                     ; 8902 18                       .
L8903:  adc     $0708,x                         ; 8903 7D 08 07                 }..
        sta     $0708,x                         ; 8906 9D 08 07                 ...
        bcc     L8914                           ; 8909 90 09                    ..
        lda     $0704,x                         ; 890B BD 04 07                 ...
        clc                                     ; 890E 18                       .
        adc     #$40                            ; 890F 69 40                    i@
        .byte   $9D                             ; 8911 9D                       .
L8912:  .byte   $04                             ; 8912 04                       .
        .byte   $07                             ; 8913 07                       .
L8914:  rts                                     ; 8914 60                       `

; ----------------------------------------------------------------------------
; --- L8915/L891C: note length tables (straight / dotted+latch),
; indexed by note b5-7. L8923: octave base offsets. L8933: envelope
; rate steps. L8953: octave thresholds for period normalization.
; L8959: period table, 2 bytes/note.
L8915:  .byte   $02,$04,$08,$10,$20,$40,$80     ; 8915
L891C:  .byte   $03,$06,$0C,$18,$30,$60,$C0     ; 891C
L8923:  .byte   $00,$0C,$18,$24,$30,$3C,$48,$54,$18,$24,$30,$3C,$48,$54,$60,$6C ; 8923
L8933:  .byte   $00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0A,$0B,$0C,$0E,$0F,$10 ; 8933
        .byte   $12,$13,$14,$16,$18,$1B,$1E,$23,$28,$30,$3C,$50,$7E,$7F,$FE,$FF ; 8943
L8953:  .byte   $00,$07,$0E,$15,$1C,$23         ; 8953
L8959:  .byte   $2A                             ; 8959
L895A:  .byte   $31,$5C,$37,$9C,$36,$E7,$35,$3C,$35,$9B,$34,$02,$34,$72,$33,$EA ; 895A
        .byte   $32,$6A,$32,$F1,$31,$80,$31,$14,$31,$5C,$30,$9C,$2F,$E7,$2E,$3C ; 896A
        .byte   $2E,$9B,$2D,$02,$2D,$72,$2C,$EA,$2B,$6A,$2B,$F1,$2A,$80,$2A,$14 ; 897A
        .byte   $2A,$5C,$29,$9C,$28,$E7,$27,$3C,$27,$9B,$26,$02,$26,$72,$25,$EA ; 898A
        .byte   $24,$6A,$24,$F1,$23,$80,$23,$14,$23,$5C,$22,$9C,$21,$E7,$20,$3C ; 899A
        .byte   $20,$9B,$1F,$02,$1F,$72,$1E,$EA,$1D,$6A,$1D,$F1,$1C,$80,$1C,$14 ; 89AA
        .byte   $1C,$5C,$1B,$9C,$1A,$E7,$19,$3C,$19,$9B,$18,$02,$18,$72,$17,$EA ; 89BA
        .byte   $16,$6A,$16,$F1,$15,$80,$15,$14,$15,$5C,$14,$9C,$13,$E7,$12,$3C ; 89CA
        .byte   $12,$9B,$11,$02,$11,$72,$10,$EA,$0F,$6A,$0F,$F1,$0E,$80,$0E,$14 ; 89DA
        .byte   $0E,$5C,$0D,$9C,$0C,$E7,$0B,$3C,$0B,$9B,$0A,$02,$0A,$72,$09,$EA ; 89EA
        .byte   $08,$6A,$08,$F1,$07,$80,$07,$14,$07,$5C,$06,$9C,$05,$E7,$04,$3C ; 89FA
        .byte   $04,$9B,$03,$02,$03,$72,$02,$EA,$01,$6A,$01,$F1,$00,$80,$00,$14 ; 8A0A
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8A1A
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8A2A
        .byte   $00,$00,$00,$00,$00,$00         ; 8A3A
; --- $8A40: song count / instrument-table ptr (hi L8A41, lo L8A42) ---
snd_song_count: .byte   $4C                     ; 8A40
L8A41:  .byte   $8A                             ; 8A41
L8A42:  .byte   $DB                             ; 8A42
; --- $8A43: song/SFX directory: 2 bytes per id (hi,lo), $4C entries ---
snd_song_dir1   := $8A44
snd_song_dir: .byte   $8D,$13,$93,$02,$97,$7E,$9B,$B2,$9F,$10,$A2,$A7,$A6,$EA,$AA,$B5 ; 8A43  ids $00-$07
        .byte   $AE,$7D,$B2,$64,$B7,$48,$BA,$DC,$BD,$C8,$C3,$90,$C4,$D5,$C5,$DD ; 8A53  ids $08-$0F
        .byte   $C6,$F3,$C7,$C0,$C8,$34,$C8,$D0,$C9,$E0,$CA,$72,$CB,$B0,$CF,$93 ; 8A63  ids $10-$17
        .byte   $CF,$CF,$CF,$E2,$CF,$FB,$D0,$07,$D0,$22,$D0,$40,$D0,$84,$D0,$94 ; 8A73  ids $18-$1F
        .byte   $D0,$A7,$D0,$C4,$D0,$EB,$D1,$2F,$D1,$49,$D1,$AF,$D1,$D6,$D1,$EC ; 8A83  ids $20-$27
        .byte   $D1,$FE,$D2,$20,$D2,$3D,$D2,$4D,$D2,$66,$D2,$84,$D2,$9B,$D2,$AB ; 8A93  ids $28-$2F
        .byte   $D2,$E0,$D3,$0F,$D3,$33,$D3,$86,$D3,$AB,$D3,$D0,$D4,$29,$D4,$56 ; 8AA3  ids $30-$37
        .byte   $D4,$84,$D4,$A1,$D4,$B7,$D4,$C9,$D4,$D5,$D4,$E1,$D4,$EF,$D5,$03 ; 8AB3  ids $38-$3F
        .byte   $D5,$0F,$D5,$21,$D5,$41,$D5,$63,$D5,$91,$D5,$B4,$D5,$D0,$D6,$15 ; 8AC3  ids $40-$47
        .byte   $D6,$57,$D6,$67,$D8,$58,$D8,$B8 ; 8AD3  ids $48-$4B
; --- $8ADB: instruments, 8 bytes each (see bank header) ---
        .byte   $1F,$01,$F0,$10,$80,$00,$00,$00 ; 8ADB  instrument $00
        .byte   $1F,$1D,$E0,$0F,$D9,$01,$00,$00 ; 8AE3  instrument $01
        .byte   $1F,$1D,$E0,$11,$80,$00,$00,$80 ; 8AEB  instrument $02
        .byte   $1D,$1B,$A0,$02,$80,$00,$00,$00 ; 8AF3  instrument $03
        .byte   $1F,$01,$D0,$0F,$82,$00,$39,$00 ; 8AFB  instrument $04
        .byte   $1F,$01,$E0,$0A,$00,$00,$00,$00 ; 8B03  instrument $05
        .byte   $1F,$1D,$E0,$0F,$80,$00,$00,$80 ; 8B0B  instrument $06
        .byte   $1F,$1D,$E0,$0D,$80,$00,$00,$80 ; 8B13  instrument $07
        .byte   $1E,$15,$E0,$0A,$E0,$01,$00,$00 ; 8B1B  instrument $08
        .byte   $1F,$1B,$A0,$05,$CB,$02,$3C,$00 ; 8B23  instrument $09
        .byte   $1E,$14,$A0,$10,$C9,$00,$42,$00 ; 8B2B  instrument $0A
        .byte   $1F,$1D,$D0,$0F,$E3,$03,$00,$00 ; 8B33  instrument $0B
        .byte   $1E,$0D,$80,$07,$E5,$04,$17,$00 ; 8B3B  instrument $0C
        .byte   $1D,$09,$90,$03,$CB,$01,$37,$00 ; 8B43  instrument $0D
        .byte   $1E,$0D,$E0,$12,$F0,$01,$1F,$00 ; 8B4B  instrument $0E
        .byte   $1F,$1B,$F0,$10,$E6,$01,$01,$00 ; 8B53  instrument $0F
        .byte   $1F,$1D,$D0,$0F,$F0,$05,$0F,$00 ; 8B5B  instrument $10
        .byte   $1F,$1D,$E0,$08,$B7,$01,$40,$00 ; 8B63  instrument $11
        .byte   $1F,$1C,$D0,$08,$9A,$01,$22,$00 ; 8B6B  instrument $12
        .byte   $1F,$13,$E0,$0D,$58,$00,$15,$00 ; 8B73  instrument $13
        .byte   $1F,$19,$50,$10,$9E,$20,$26,$00 ; 8B7B  instrument $14
        .byte   $1F,$1F,$E0,$1B,$9E,$58,$7C,$00 ; 8B83  instrument $15
        .byte   $18,$00,$D0,$13,$80,$00,$00,$00 ; 8B8B  instrument $16
        .byte   $1E,$14,$E0,$0F,$0F,$00,$16,$00 ; 8B93  instrument $17
        .byte   $07,$1F,$F0,$06,$80,$00,$00,$00 ; 8B9B  instrument $18
        .byte   $1F,$01,$D0,$1E,$72,$23,$11,$80 ; 8BA3  instrument $19
        .byte   $1F,$1B,$C0,$05,$D2,$03,$48,$00 ; 8BAB  instrument $1A
        .byte   $1E,$0D,$F0,$14,$F8,$01,$2E,$00 ; 8BB3  instrument $1B
        .byte   $1E,$13,$E0,$02,$DA,$00,$01,$00 ; 8BBB  instrument $1C
        .byte   $1F,$1D,$D0,$06,$E3,$03,$00,$00 ; 8BC3  instrument $1D
        .byte   $1F,$1A,$A0,$05,$FF,$01,$33,$00 ; 8BCB  instrument $1E
        .byte   $1E,$1A,$A0,$05,$E4,$04,$00,$00 ; 8BD3  instrument $1F
        .byte   $1F,$19,$A0,$02,$00,$00,$00,$00 ; 8BDB  instrument $20
        .byte   $1F,$04,$80,$02,$80,$00,$00,$00 ; 8BE3  instrument $21
        .byte   $1F,$1E,$D0,$01,$C6,$00,$32,$00 ; 8BEB  instrument $22
        .byte   $1F,$1C,$F0,$1F,$EF,$4B,$06,$00 ; 8BF3  instrument $23
        .byte   $19,$1F,$F0,$1F,$95,$02,$1D,$00 ; 8BFB  instrument $24
        .byte   $1F,$1E,$F0,$02,$EF,$00,$46,$00 ; 8C03  instrument $25
        .byte   $17,$02,$E0,$0F,$00,$00,$00,$00 ; 8C0B  instrument $26
        .byte   $1F,$1F,$F0,$1F,$FF,$09,$18,$80 ; 8C13  instrument $27
        .byte   $1F,$1F,$F0,$1F,$00,$00,$00,$00 ; 8C1B  instrument $28
        .byte   $1F,$1F,$F0,$1F,$FF,$02,$00,$00 ; 8C23  instrument $29
        .byte   $1F,$1F,$F0,$1F,$92,$7F,$00,$00 ; 8C2B  instrument $2A
        .byte   $1F,$01,$00,$0F,$E3,$7F,$00,$00 ; 8C33  instrument $2B
        .byte   $1F,$1F,$F0,$1F,$FF,$4C,$00,$00 ; 8C3B  instrument $2C
        .byte   $1F,$1F,$F0,$1F,$99,$7F,$00,$00 ; 8C43  instrument $2D
        .byte   $1D,$1F,$F0,$1F,$80,$00,$00,$00 ; 8C4B  instrument $2E
        .byte   $1F,$1F,$F0,$1F,$B7,$27,$00,$00 ; 8C53  instrument $2F
        .byte   $1F,$1A,$A0,$07,$CF,$36,$00,$80 ; 8C5B  instrument $30
        .byte   $1F,$1F,$F0,$1F,$A6,$7F,$00,$80 ; 8C63  instrument $31
        .byte   $1C,$13,$10,$1F,$FF,$7F,$00,$00 ; 8C6B  instrument $32
        .byte   $1F,$1E,$F0,$1F,$EB,$7C,$47,$80 ; 8C73  instrument $33
        .byte   $1F,$1B,$D0,$0F,$E1,$67,$18,$00 ; 8C7B  instrument $34
        .byte   $1F,$1F,$F0,$1F,$80,$00,$00,$80 ; 8C83  instrument $35
        .byte   $1F,$1F,$F0,$1F,$D4,$03,$41,$00 ; 8C8B  instrument $36
        .byte   $1F,$1F,$F0,$0F,$D7,$56,$7F,$00 ; 8C93  instrument $37
        .byte   $1F,$16,$E0,$19,$E4,$64,$1E,$00 ; 8C9B  instrument $38
        .byte   $1F,$1F,$F0,$10,$BC,$02,$00,$00 ; 8CA3  instrument $39
        .byte   $1F,$1F,$F0,$1F,$A5,$7F,$00,$00 ; 8CAB  instrument $3A
        .byte   $1F,$1F,$F0,$1F,$D3,$16,$00,$00 ; 8CB3  instrument $3B
        .byte   $1F,$1F,$F0,$04,$80,$00,$00,$00 ; 8CBB  instrument $3C
        .byte   $1A,$1F,$E0,$1C,$00,$00,$00,$00 ; 8CC3  instrument $3D
        .byte   $1F,$1E,$C0,$07,$00,$00,$00,$80 ; 8CCB  instrument $3E
        .byte   $1F,$01,$F0,$05,$E1,$0D,$00,$00 ; 8CD3  instrument $3F
        .byte   $1F,$1F,$F0,$1F,$FF,$7F,$00,$00 ; 8CDB  instrument $40
        .byte   $1C,$1F,$F0,$07,$FF,$7F,$36,$00 ; 8CE3  instrument $41
        .byte   $19,$0B,$F0,$12,$FF,$7F,$36,$00 ; 8CEB  instrument $42
        .byte   $1F,$12,$40,$1E,$FF,$7F,$51,$00 ; 8CF3  instrument $43
        .byte   $1F,$1F,$F0,$1F,$FF,$19,$00,$00 ; 8CFB  instrument $44
        .byte   $1F,$1F,$F0,$0F,$D7,$09,$7F,$00 ; 8D03  instrument $45
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 8D0B  instrument $46
; =============================================================================
; SONG/SFX STREAM DATA — $8D13-$9FFF (continues in bank $19, then bank $1A
; through the virtual $C000-$DFFF far-fetch window). Track byte format in
; the bank header and DATA_REFERENCE.md section 15.
; =============================================================================
        .byte   $00,$8D,$1C,$8E,$E8,$90,$F1,$92,$23,$05,$01,$D8,$04,$00,$A0,$18 ; 8D13
        .byte   $40,$07,$0B,$09,$02,$08,$17,$06,$E6,$02,$9F,$08,$04,$06,$0A,$02 ; 8D23
        .byte   $01,$DD,$01,$7D,$18,$C0,$08,$0E,$07,$08,$7D,$7F,$03,$6C,$73,$72 ; 8D33
        .byte   $6B,$6A,$62,$61,$68,$67,$03,$78,$12,$00,$8D,$7D,$73,$02,$80,$18 ; 8D43
        .byte   $40,$08,$17,$06,$E6,$07,$0B,$02,$03,$8C,$08,$04,$06,$0A,$02,$01 ; 8D53
        .byte   $CB,$01,$6B,$18,$C0,$08,$0E,$07,$08,$6C,$6B,$71,$65,$67,$6B,$71 ; 8D63
        .byte   $65,$67,$03,$71,$72,$73,$0E,$01,$8D,$1F,$80,$18,$40,$08,$02,$06 ; 8D73
        .byte   $E6,$07,$09,$7C,$7A,$7C,$7E,$60,$02,$01,$03,$8C,$08,$10,$02,$01 ; 8D83
        .byte   $AC,$04,$00,$04,$00,$08,$02,$06,$F0,$93,$71,$60,$73,$60,$76,$60 ; 8D93
        .byte   $9A,$60,$7A,$80,$02,$9A,$60,$78,$02,$80,$B1,$06,$64,$93,$96,$9A ; 8DA3
        .byte   $06,$F0,$02,$9D,$02,$9C,$98,$02,$9C,$02,$9D,$9F,$01,$B8,$08,$0B ; 8DB3
        .byte   $02,$01,$D8,$80,$08,$02,$91,$73,$60,$9A,$80,$02,$9A,$60,$BA,$BB ; 8DC3
        .byte   $BA,$BB,$9A,$02,$B9,$D5,$77,$79,$01,$BA,$08,$0B,$02,$01,$DA,$0E ; 8DD3
        .byte   $01,$8D,$96,$04,$48,$08,$02,$06,$FF,$07,$05,$89,$08,$18,$07,$07 ; 8DE3
        .byte   $69,$07,$09,$69,$07,$0A,$89,$07,$0B,$02,$A9,$01,$69,$60,$08,$02 ; 8DF3
        .byte   $07,$08,$67,$02,$01,$89,$07,$09,$69,$07,$0A,$C9,$01,$89,$60,$07 ; 8E03
        .byte   $08,$67,$01,$69,$01,$A9,$87,$89,$80,$89,$80,$A9,$8E,$90,$01,$C9 ; 8E13
        .byte   $01,$89,$80,$03,$93,$98,$BF,$BD,$98,$9A,$9B,$80,$02,$BD,$BF,$02 ; 8E23
        .byte   $03,$C9,$A7,$12,$08,$8E,$44,$A4,$A6,$A7,$02,$89,$60,$0E,$01,$8D ; 8E33
        .byte   $E6,$A4,$A9,$AB,$02,$8D,$6E,$60,$06,$E6,$03,$6C,$80,$6C,$60,$18 ; 8E43
        .byte   $00,$03,$6E,$6C,$69,$87,$88,$89,$03,$78,$9F,$7D,$03,$88,$87,$03 ; 8E53
        .byte   $98,$9A,$7D,$02,$98,$18,$40,$6C,$60,$6C,$80,$6C,$60,$18,$00,$78 ; 8E63
        .byte   $7A,$7D,$9F,$01,$9D,$00,$01,$5D,$03,$8A,$88,$06,$64,$89,$84,$83 ; 8E73
        .byte   $82,$8F,$88,$87,$8D,$86,$06,$E6,$02,$00,$85,$18,$C0,$07,$0B,$03 ; 8E83
        .byte   $6C,$60,$6C,$80,$6C,$18,$00,$06,$64,$7F,$03,$73,$73,$60,$72,$66 ; 8E93
        .byte   $66,$60,$65,$70,$63,$00,$82,$8E,$82,$81,$03,$98,$03,$8B,$03,$96 ; 8EA3
        .byte   $03,$89,$03,$94,$00,$03,$68,$63,$62,$03,$73,$80,$06,$E6,$75,$7A ; 8EB3
        .byte   $72,$75,$7A,$7E,$03,$69,$66,$62,$03,$78,$7A,$7E,$03,$69,$6C,$66 ; 8EC3
        .byte   $67,$69,$6E,$6F,$6E,$66,$01,$B1,$08,$0B,$B1,$01,$71,$18,$40,$07 ; 8ED3
        .byte   $09,$16,$8D,$94,$17,$04,$00,$A0,$07,$0A,$09,$02,$0C,$FF,$18,$40 ; 8EE3
        .byte   $08,$17,$06,$E6,$02,$9A,$08,$04,$06,$0A,$02,$01,$D8,$01,$78,$60 ; 8EF3
        .byte   $18,$C0,$07,$04,$09,$03,$7D,$7F,$03,$6C,$73,$72,$6B,$6A,$62,$61 ; 8F03
        .byte   $68,$67,$12,$08,$8F,$49,$03,$78,$73,$80,$18,$40,$07,$09,$08,$17 ; 8F13
        .byte   $06,$E6,$51,$01,$93,$01,$53,$08,$04,$06,$0A,$02,$01,$D1,$01,$71 ; 8F23
        .byte   $60,$18,$C0,$07,$04,$03,$6C,$6B,$71,$65,$67,$6B,$71,$65,$67,$03 ; 8F33
        .byte   $71,$72,$0E,$01,$8E,$E8,$80,$09,$02,$07,$09,$06,$E6,$03,$78,$77 ; 8F43
        .byte   $78,$7A,$60,$02,$01,$9D,$08,$10,$02,$01,$BD,$04,$00,$04,$00,$04 ; 8F53
        .byte   $00,$09,$02,$08,$11,$07,$08,$06,$3C,$18,$80,$7F,$7F,$73,$60,$73 ; 8F63
        .byte   $60,$7F,$7F,$60,$73,$7F,$02,$80,$73,$7F,$12,$00,$8F,$B0,$03,$69 ; 8F73
        .byte   $69,$03,$75,$60,$75,$60,$03,$69,$69,$60,$03,$75,$7A,$03,$69,$80 ; 8F83
        .byte   $03,$75,$03,$69,$6A,$6A,$03,$76,$60,$76,$60,$03,$6A,$6A,$60,$03 ; 8F93
        .byte   $76,$03,$6A,$02,$80,$03,$76,$03,$6A,$0E,$01,$8F,$62,$7B,$7B,$6F ; 8FA3
        .byte   $60,$80,$06,$FF,$08,$02,$8F,$B3,$B6,$02,$B8,$02,$B6,$B4,$02,$B3 ; 8FB3
        .byte   $B0,$AE,$8D,$13,$00,$8F,$DE,$6E,$60,$18,$00,$92,$98,$3C,$01,$9D ; 8FC3
        .byte   $02,$7D,$01,$3D,$9B,$9A,$98,$0F,$01,$8F,$60,$AE,$80,$B2,$93,$95 ; 8FD3
        .byte   $9A,$04,$00,$04,$00,$80,$08,$12,$07,$09,$06,$96,$69,$6A,$6F,$6A ; 8FE3
        .byte   $6F,$6E,$6F,$73,$75,$76,$6F,$75,$76,$7B,$12,$00,$90,$14,$80,$67 ; 8FF3
        .byte   $69,$6A,$67,$6A,$70,$6A,$70,$73,$75,$70,$73,$75,$7C,$0E,$02,$8F ; 9003
        .byte   $E6,$80,$67,$68,$6A,$68,$6A,$6F,$6A,$6F,$73,$74,$6F,$74,$76,$7B ; 9013
        .byte   $80,$64,$67,$69,$67,$69,$70,$69,$70,$73,$75,$70,$73,$75,$7C,$13 ; 9023
        .byte   $00,$90,$49,$80,$62,$66,$69,$66,$69,$6E,$69,$6E,$70,$72,$6E,$72 ; 9033
        .byte   $75,$7A,$0F,$01,$8F,$E4,$80,$64,$69,$6D,$69,$6D,$70,$69,$6D,$70 ; 9043
        .byte   $75,$70,$73,$75,$18,$C0,$06,$E6,$08,$02,$67,$60,$67,$80,$67,$02 ; 9053
        .byte   $60,$09,$03,$07,$04,$03,$6E,$6C,$69,$87,$88,$89,$03,$78,$9F,$7D ; 9063
        .byte   $03,$88,$87,$03,$98,$9A,$7D,$98,$40,$09,$02,$07,$09,$67,$60,$67 ; 9073
        .byte   $80,$67,$02,$60,$09,$03,$07,$04,$78,$7A,$7D,$9F,$01,$9D,$00,$01 ; 9083
        .byte   $5D,$03,$8A,$88,$06,$64,$89,$84,$83,$82,$8F,$88,$87,$8D,$86,$06 ; 9093
        .byte   $E6,$00,$85,$40,$18,$C0,$07,$09,$09,$02,$03,$67,$60,$67,$80,$67 ; 90A3
        .byte   $40,$09,$03,$07,$03,$18,$00,$7F,$03,$73,$73,$60,$72,$66,$66,$60 ; 90B3
        .byte   $65,$70,$63,$00,$82,$8E,$82,$81,$03,$98,$03,$8B,$03,$96,$03,$89 ; 90C3
        .byte   $03,$94,$00,$03,$68,$63,$62,$03,$53,$18,$C0,$07,$08,$09,$02,$E2 ; 90D3
        .byte   $AE,$95,$60,$01,$B8,$08,$10,$B8,$01,$78,$16,$8F,$5E,$17,$04,$00 ; 90E3
        .byte   $06,$E6,$08,$00,$09,$03,$67,$67,$67,$02,$80,$A0,$67,$6C,$6E,$6C ; 90F3
        .byte   $6E,$71,$67,$60,$67,$60,$02,$A0,$65,$01,$4D,$0D,$7F,$02,$01,$6E ; 9103
        .byte   $0D,$00,$6D,$6A,$65,$12,$00,$91,$38,$67,$67,$67,$02,$80,$A0,$67 ; 9113
        .byte   $6C,$6E,$6C,$6E,$71,$67,$60,$67,$60,$02,$A0,$65,$67,$6C,$6E,$71 ; 9123
        .byte   $76,$0E,$01,$90,$F1,$8C,$A0,$02,$01,$AE,$01,$6E,$08,$15,$79,$74 ; 9133
        .byte   $70,$04,$00,$04,$00,$04,$00,$08,$00,$06,$6E,$87,$85,$06,$FA,$87 ; 9143
        .byte   $60,$87,$69,$02,$6A,$40,$06,$6E,$8E,$87,$0E,$01,$91,$48,$04,$00 ; 9153
        .byte   $8C,$8A,$06,$FA,$8C,$60,$8C,$70,$02,$71,$40,$06,$6E,$93,$8C,$0E ; 9163
        .byte   $01,$91,$61,$83,$82,$06,$FA,$83,$60,$83,$65,$02,$67,$40,$06,$6E ; 9173
        .byte   $8A,$8F,$88,$87,$06,$FA,$88,$60,$88,$67,$02,$68,$40,$06,$6E,$88 ; 9183
        .byte   $8D,$89,$87,$06,$FA,$89,$60,$89,$67,$02,$69,$40,$06,$78,$81,$8D ; 9193
        .byte   $06,$E6,$A2,$02,$84,$86,$69,$8E,$62,$60,$6E,$60,$0F,$01,$91,$46 ; 91A3
        .byte   $04,$00,$06,$F5,$04,$00,$A3,$80,$C3,$60,$6F,$12,$00,$91,$D0,$A4 ; 91B3
        .byte   $80,$84,$60,$6E,$90,$64,$60,$70,$60,$0E,$02,$91,$B7,$A8,$80,$C8 ; 91C3
        .byte   $60,$6F,$A9,$80,$C9,$60,$6E,$13,$00,$91,$EC,$A2,$80,$82,$60,$6C ; 91D3
        .byte   $8E,$62,$60,$6E,$60,$0F,$01,$91,$B3,$A9,$80,$89,$60,$73,$95,$69 ; 91E3
        .byte   $60,$75,$62,$04,$00,$60,$09,$02,$6E,$60,$7A,$6E,$80,$78,$60,$7A ; 91F3
        .byte   $6E,$60,$73,$75,$78,$6E,$60,$6E,$60,$6E,$78,$7A,$6C,$6E,$60,$7A ; 9203
        .byte   $6E,$60,$73,$75,$78,$6E,$0E,$03,$91,$F6,$09,$03,$16,$91,$44,$17 ; 9213
        .byte   $04,$00,$08,$14,$09,$00,$06,$D2,$07,$0A,$63,$63,$02,$83,$07,$08 ; 9223
        .byte   $6F,$6F,$6F,$6F,$6F,$02,$8F,$6F,$07,$0A,$63,$63,$63,$07,$08,$6F ; 9233
        .byte   $63,$8F,$6F,$6F,$6F,$6F,$6F,$AF,$68,$68,$0E,$01,$92,$23,$68,$04 ; 9243
        .byte   $00,$07,$08,$6F,$8F,$07,$0A,$85,$07,$08,$6F,$8F,$6F,$8F,$07,$0A ; 9253
        .byte   $85,$6F,$6F,$12,$00,$92,$6F,$60,$0E,$01,$92,$52,$02,$83,$68,$88 ; 9263
        .byte   $A8,$63,$6F,$6F,$68,$6F,$6F,$04,$00,$04,$00,$63,$07,$08,$6F,$6F ; 9273
        .byte   $6F,$07,$0B,$87,$07,$09,$63,$83,$63,$07,$08,$6F,$6F,$07,$0B,$67 ; 9283
        .byte   $07,$08,$6F,$6F,$6F,$07,$09,$0E,$0F,$92,$7C,$04,$00,$63,$07,$08 ; 9293
        .byte   $6F,$6F,$6F,$07,$0B,$68,$6F,$07,$09,$83,$6F,$6F,$6F,$6F,$68,$6F ; 92A3
        .byte   $6F,$6F,$0E,$0F,$92,$9E,$04,$00,$07,$08,$6F,$07,$0B,$68,$6F,$63 ; 92B3
        .byte   $68,$6F,$6F,$07,$09,$63,$6F,$63,$6F,$6F,$07,$0B,$68,$07,$08,$6F ; 92C3
        .byte   $6F,$6F,$07,$09,$63,$07,$08,$8F,$6F,$07,$0B,$68,$6F,$6F,$07,$09 ; 92D3
        .byte   $63,$6F,$63,$12,$00,$92,$F6,$6F,$63,$07,$0B,$68,$6F,$6F,$68,$0E ; 92E3
        .byte   $03,$92,$B9,$68,$07,$0C,$68,$68,$68,$68,$68,$16,$92,$7A,$17,$00 ; 92F3
        .byte   $93,$0B,$94,$54,$95,$8F,$96,$9D,$05,$01,$B6,$06,$D2,$07,$08,$08 ; 9303
        .byte   $00,$09,$02,$5C,$40,$9C,$7C,$18,$80,$06,$3C,$08,$0A,$7C,$03,$70 ; 9313
        .byte   $69,$64,$61,$03,$75,$7C,$03,$69,$6D,$6C,$6B,$69,$18,$00,$08,$00 ; 9323
        .byte   $06,$D2,$41,$40,$81,$61,$18,$80,$08,$0A,$61,$6D,$6A,$66,$03,$76 ; 9333
        .byte   $72,$76,$7E,$03,$6A,$69,$68,$66,$18,$00,$06,$C8,$08,$00,$42,$40 ; 9343
        .byte   $82,$82,$82,$62,$62,$A0,$84,$64,$04,$00,$04,$00,$80,$18,$40,$08 ; 9353
        .byte   $01,$09,$01,$9C,$7A,$5C,$40,$60,$06,$96,$9F,$60,$06,$C8,$03,$89 ; 9363
        .byte   $67,$66,$62,$67,$80,$06,$F0,$02,$86,$02,$82,$06,$DC,$01,$A6,$01 ; 9373
        .byte   $66,$67,$69,$67,$12,$08,$93,$A4,$60,$66,$01,$A4,$08,$0B,$C4,$01 ; 9383
        .byte   $84,$02,$A0,$08,$01,$81,$64,$60,$61,$60,$63,$02,$86,$0E,$01,$93 ; 9393
        .byte   $5D,$02,$AB,$01,$2D,$0D,$7F,$02,$6E,$01,$2E,$0D,$00,$8D,$8B,$89 ; 93A3
        .byte   $01,$8B,$AB,$08,$0B,$02,$01,$CB,$04,$00,$08,$01,$06,$B8,$7F,$7F ; 93B3
        .byte   $7E,$7F,$60,$06,$DC,$02,$9E,$9F,$80,$7F,$7E,$7F,$03,$69,$12,$08 ; 93C3
        .byte   $94,$04,$8B,$80,$08,$16,$06,$FF,$07,$09,$A8,$A4,$03,$B7,$08,$01 ; 93D3
        .byte   $06,$A0,$07,$08,$7C,$7C,$06,$DC,$7A,$7C,$60,$02,$9A,$9C,$80,$75 ; 93E3
        .byte   $78,$7D,$7F,$03,$A9,$65,$67,$69,$02,$A7,$69,$60,$6B,$0E,$01,$93 ; 93F3
        .byte   $BB,$02,$AB,$06,$FF,$87,$A2,$03,$B7,$06,$D2,$75,$78,$60,$7D,$60 ; 9403
        .byte   $02,$9F,$03,$A9,$65,$67,$69,$01,$67,$02,$C7,$01,$67,$06,$FF,$69 ; 9413
        .byte   $6B,$67,$06,$B4,$6E,$6E,$67,$06,$64,$8E,$87,$8E,$8E,$72,$01,$F0 ; 9423
        .byte   $01,$B0,$06,$D2,$70,$70,$69,$06,$64,$90,$89,$90,$90,$06,$DC,$73 ; 9433
        .byte   $B2,$80,$AC,$06,$64,$8B,$89,$87,$06,$F0,$66,$02,$8F,$16,$93,$5B ; 9443
        .byte   $17,$06,$D2,$07,$08,$08,$00,$09,$02,$59,$40,$99,$79,$02,$C0,$56 ; 9453
        .byte   $40,$96,$76,$02,$C0,$06,$C8,$57,$40,$97,$97,$97,$77,$77,$A0,$99 ; 9463
        .byte   $79,$04,$08,$04,$08,$08,$0C,$06,$C8,$07,$06,$09,$02,$6B,$6B,$6B ; 9473
        .byte   $6B,$12,$08,$94,$98,$60,$6B,$77,$6B,$6B,$75,$77,$6B,$6B,$70,$6B ; 9483
        .byte   $75,$0E,$03,$94,$76,$80,$18,$40,$08,$01,$06,$DC,$03,$89,$6D,$60 ; 9493
        .byte   $69,$60,$6B,$02,$8F,$04,$08,$18,$00,$08,$0C,$06,$C8,$6B,$6B,$6B ; 94A3
        .byte   $6B,$60,$6B,$77,$6B,$6B,$75,$77,$6B,$6B,$70,$6B,$75,$0E,$01,$94 ; 94B3
        .byte   $A8,$18,$C0,$08,$06,$06,$E1,$07,$05,$01,$62,$07,$06,$62,$07,$07 ; 94C3
        .byte   $02,$01,$A2,$07,$05,$01,$64,$07,$06,$64,$07,$07,$02,$01,$A4,$07 ; 94D3
        .byte   $05,$01,$69,$07,$06,$69,$07,$07,$01,$89,$AD,$B0,$AF,$04,$00,$08 ; 94E3
        .byte   $02,$06,$B8,$09,$01,$7C,$7C,$7A,$7C,$60,$06,$DC,$02,$9A,$9C,$80 ; 94F3
        .byte   $A0,$12,$00,$95,$34,$03,$88,$80,$08,$16,$06,$FF,$07,$09,$A4,$03 ; 9503
        .byte   $B7,$B4,$08,$01,$07,$07,$06,$A0,$73,$73,$06,$DC,$72,$73,$60,$02 ; 9513
        .byte   $92,$93,$02,$A0,$B8,$75,$77,$78,$02,$B7,$78,$60,$7A,$0E,$01,$94 ; 9523
        .byte   $F0,$02,$BF,$9A,$B7,$B3,$D1,$CC,$06,$D2,$6B,$6E,$60,$73,$60,$02 ; 9533
        .byte   $95,$01,$B7,$01,$77,$06,$FF,$78,$7A,$77,$06,$B4,$03,$6B,$6B,$64 ; 9543
        .byte   $06,$64,$8B,$84,$8B,$8B,$06,$F5,$6E,$AD,$AC,$AB,$02,$89,$02,$8B ; 9553
        .byte   $8C,$06,$D2,$6D,$6D,$64,$06,$64,$8D,$84,$8D,$8D,$06,$F0,$70,$AF ; 9563
        .byte   $80,$01,$28,$0D,$7F,$89,$02,$69,$01,$29,$0D,$00,$06,$64,$87,$86 ; 9573
        .byte   $84,$06,$F0,$63,$02,$8C,$18,$00,$16,$94,$74,$17,$06,$D2,$08,$0D ; 9583
        .byte   $09,$02,$6B,$8B,$6B,$02,$C0,$68,$88,$68,$02,$C0,$69,$89,$89,$89 ; 9593
        .byte   $69,$89,$73,$75,$60,$8B,$6B,$04,$00,$04,$00,$09,$02,$02,$90,$70 ; 95A3
        .byte   $60,$70,$7C,$6E,$90,$6E,$73,$60,$70,$6B,$70,$02,$8E,$6E,$60,$73 ; 95B3
        .byte   $75,$6C,$8E,$6C,$72,$60,$8C,$6E,$12,$00,$95,$EE,$02,$8C,$6C,$60 ; 95C3
        .byte   $73,$78,$6C,$02,$8C,$6C,$60,$8D,$6D,$02,$8B,$6B,$60,$75,$77,$69 ; 95D3
        .byte   $02,$8B,$70,$60,$6D,$69,$6B,$0E,$01,$95,$AC,$09,$01,$02,$93,$73 ; 95E3
        .byte   $60,$9D,$7F,$02,$95,$75,$60,$9C,$03,$69,$02,$03,$97,$77,$60,$9E ; 95F3
        .byte   $03,$6B,$03,$97,$75,$9C,$7A,$75,$77,$04,$00,$02,$98,$78,$60,$98 ; 9603
        .byte   $78,$78,$02,$80,$7A,$7C,$7F,$03,$69,$12,$08,$96,$49,$02,$84,$64 ; 9613
        .byte   $60,$84,$64,$64,$02,$80,$03,$70,$6E,$70,$77,$02,$98,$78,$60,$98 ; 9623
        .byte   $78,$78,$02,$80,$A0,$02,$9D,$7D,$60,$9D,$7D,$02,$9F,$7F,$60,$73 ; 9633
        .byte   $7A,$7F,$0E,$01,$96,$0C,$02,$87,$67,$60,$87,$67,$67,$02,$80,$67 ; 9643
        .byte   $03,$6E,$71,$73,$71,$71,$78,$71,$60,$91,$78,$02,$91,$71,$60,$9D ; 9653
        .byte   $7D,$73,$73,$7A,$73,$60,$93,$7A,$B3,$73,$7F,$60,$7F,$95,$75,$75 ; 9663
        .byte   $60,$9C,$75,$60,$95,$7C,$95,$70,$75,$92,$72,$72,$60,$99,$7E,$60 ; 9673
        .byte   $02,$9E,$9E,$79,$7E,$97,$77,$77,$60,$9E,$77,$60,$97,$7E,$97,$72 ; 9683
        .byte   $72,$77,$02,$C0,$02,$80,$16,$95,$AA,$17,$08,$14,$09,$00,$04,$00 ; 9693
        .byte   $06,$BE,$07,$0B,$64,$07,$08,$8F,$8F,$6F,$6F,$6F,$6F,$6F,$6F,$6F ; 96A3
        .byte   $64,$07,$0C,$06,$C8,$02,$88,$0E,$01,$96,$A1,$06,$BE,$07,$09,$64 ; 96B3
        .byte   $07,$0B,$88,$88,$88,$68,$68,$60,$6F,$6F,$64,$88,$60,$04,$00,$04 ; 96C3
        .byte   $00,$07,$0A,$64,$07,$08,$6F,$6F,$6F,$07,$0B,$88,$6F,$84,$07,$08 ; 96D3
        .byte   $6F,$6F,$64,$07,$0B,$88,$07,$08,$6F,$6F,$0E,$07,$96,$D2,$04,$00 ; 96E3
        .byte   $07,$0A,$64,$07,$08,$6F,$6F,$07,$0B,$88,$07,$0A,$64,$6F,$64,$64 ; 96F3
        .byte   $07,$08,$6F,$6F,$6F,$07,$0D,$A8,$04,$00,$07,$0A,$64,$07,$08,$6F ; 9703
        .byte   $6F,$07,$0A,$64,$60,$64,$6F,$64,$64,$07,$08,$6F,$6F,$6F,$07,$0B ; 9713
        .byte   $88,$12,$00,$97,$2E,$6F,$6F,$0E,$01,$97,$0B,$80,$04,$00,$64,$07 ; 9723
        .byte   $08,$6F,$6F,$6F,$07,$0B,$02,$88,$6F,$0E,$01,$97,$2F,$0F,$01,$96 ; 9733
        .byte   $F1,$04,$00,$07,$0A,$64,$60,$64,$68,$6F,$64,$60,$88,$64,$6F,$6F ; 9743
        .byte   $68,$6F,$6F,$6F,$04,$00,$64,$07,$08,$6F,$6F,$64,$07,$0B,$88,$6F ; 9753
        .byte   $6F,$13,$00,$97,$70,$0E,$01,$97,$57,$0F,$01,$97,$44,$64,$60,$68 ; 9763
        .byte   $64,$68,$07,$0B,$68,$68,$68,$16,$96,$D0,$17,$00,$97,$87,$98,$8C ; 9773
        .byte   $99,$F7,$9B,$16,$05,$01,$C7,$04,$08,$06,$F0,$07,$09,$08,$05,$09 ; 9783
        .byte   $00,$02,$92,$B1,$60,$02,$91,$AF,$60,$02,$91,$AF,$60,$06,$F5,$02 ; 9793
        .byte   $8F,$02,$91,$92,$06,$C8,$02,$8F,$02,$01,$CD,$6D,$01,$CD,$18,$C0 ; 97A3
        .byte   $08,$02,$02,$92,$72,$60,$06,$FF,$02,$93,$18,$00,$0E,$01,$97,$8A ; 97B3
        .byte   $04,$08,$06,$F0,$07,$09,$09,$01,$18,$80,$04,$08,$88,$6B,$6F,$60 ; 97C3
        .byte   $68,$8B,$91,$60,$01,$B2,$72,$02,$01,$D2,$B4,$91,$72,$91,$02,$8F ; 97D3
        .byte   $8D,$12,$08,$97,$F2,$6F,$01,$AD,$6D,$01,$ED,$0E,$01,$97,$CD,$80 ; 97E3
        .byte   $96,$01,$94,$01,$F4,$08,$05,$04,$08,$02,$92,$B1,$60,$04,$08,$30 ; 97F3
        .byte   $01,$91,$02,$01,$51,$AF,$60,$0E,$01,$98,$00,$02,$8F,$02,$91,$92 ; 9803
        .byte   $13,$08,$98,$23,$02,$8F,$01,$6D,$02,$CD,$01,$ED,$0F,$01,$97,$FA ; 9813
        .byte   $EF,$80,$74,$80,$74,$80,$74,$02,$80,$A0,$04,$08,$F3,$02,$93,$02 ; 9823
        .byte   $91,$93,$02,$94,$02,$96,$98,$31,$01,$93,$02,$01,$53,$01,$71,$12 ; 9833
        .byte   $48,$98,$4E,$02,$D1,$01,$F1,$0E,$01,$98,$2D,$01,$D1,$09,$02,$8E ; 9843
        .byte   $6C,$EA,$60,$02,$A8,$A8,$87,$88,$8A,$02,$87,$02,$83,$65,$01,$C3 ; 9853
        .byte   $01,$63,$02,$A6,$A6,$85,$86,$88,$65,$60,$65,$80,$65,$80,$65,$02 ; 9863
        .byte   $80,$02,$01,$6A,$01,$2A,$0D,$7F,$07,$06,$28,$27,$25,$23,$21,$03 ; 9873
        .byte   $38,$36,$40,$0D,$00,$16,$97,$C3,$17,$04,$08,$06,$F0,$07,$08,$08 ; 9883
        .byte   $05,$09,$00,$02,$8F,$AD,$60,$02,$8D,$AB,$60,$02,$8D,$AB,$60,$06 ; 9893
        .byte   $F5,$02,$8B,$02,$8D,$8F,$06,$C8,$02,$8B,$88,$18,$40,$68,$8A,$02 ; 98A3
        .byte   $88,$02,$85,$86,$02,$88,$02,$81,$81,$08,$02,$09,$00,$18,$C0,$8D ; 98B3
        .byte   $6A,$6D,$60,$06,$FF,$02,$8E,$18,$00,$0E,$01,$98,$8C,$04,$00,$04 ; 98C3
        .byte   $00,$08,$02,$06,$BE,$07,$08,$09,$01,$18,$C0,$97,$74,$74,$60,$02 ; 98D3
        .byte   $97,$99,$74,$02,$9B,$94,$08,$12,$03,$68,$63,$66,$6B,$63,$66,$6D ; 98E3
        .byte   $63,$66,$6B,$63,$66,$6F,$63,$68,$63,$08,$02,$12,$08,$99,$2A,$03 ; 98F3
        .byte   $96,$72,$72,$60,$02,$94,$96,$6D,$01,$AD,$01,$6D,$08,$12,$7E,$79 ; 9903
        .byte   $7E,$03,$68,$61,$66,$6A,$61,$08,$02,$09,$01,$18,$00,$86,$61,$66 ; 9913
        .byte   $60,$02,$87,$0E,$01,$98,$D2,$81,$03,$74,$74,$60,$02,$9B,$99,$74 ; 9923
        .byte   $01,$B4,$01,$74,$99,$03,$68,$6D,$60,$6D,$80,$6D,$80,$06,$FA,$85 ; 9933
        .byte   $64,$83,$04,$08,$06,$F0,$08,$05,$02,$8F,$AD,$60,$2C,$01,$8D,$02 ; 9943
        .byte   $01,$4D,$AB,$60,$2C,$01,$8D,$02,$01,$4D,$02,$8B,$06,$FF,$03,$96 ; 9953
        .byte   $B7,$BE,$12,$00,$99,$78,$03,$AA,$03,$B6,$B9,$BD,$03,$A8,$AA,$AB ; 9963
        .byte   $AA,$0E,$01,$99,$45,$03,$AD,$A3,$A7,$AA,$68,$60,$6F,$80,$6F,$80 ; 9973
        .byte   $02,$01,$6F,$01,$2F,$0D,$7F,$07,$06,$2D,$2B,$2A,$28,$26,$25,$23 ; 9983
        .byte   $A0,$40,$0D,$00,$08,$12,$07,$09,$04,$08,$04,$08,$8C,$65,$88,$65 ; 9993
        .byte   $8F,$8C,$85,$88,$8F,$0E,$01,$99,$9D,$04,$08,$8E,$65,$88,$65,$8F ; 99A3
        .byte   $8E,$85,$8A,$85,$0E,$01,$99,$AC,$0F,$01,$99,$9B,$08,$05,$18,$40 ; 99B3
        .byte   $06,$D2,$68,$03,$94,$96,$02,$99,$02,$9D,$02,$03,$88,$8D,$6C,$03 ; 99C3
        .byte   $98,$9B,$02,$9D,$02,$9F,$02,$03,$8A,$8C,$6B,$03,$97,$9B,$02,$9E ; 99D3
        .byte   $02,$03,$88,$02,$8A,$8B,$6A,$60,$6A,$80,$6A,$80,$6A,$02,$80,$A7 ; 99E3
        .byte   $16,$98,$D0,$17,$04,$00,$06,$F0,$08,$00,$09,$03,$04,$00,$02,$88 ; 99F3
        .byte   $6F,$60,$6F,$83,$0E,$03,$99,$FF,$04,$00,$02,$86,$6D,$60,$6D,$81 ; 9A03
        .byte   $0E,$02,$9A,$0B,$02,$86,$66,$60,$67,$93,$0F,$01,$99,$F7,$04,$00 ; 9A13
        .byte   $04,$00,$04,$00,$02,$88,$6F,$60,$6F,$83,$0E,$03,$9A,$25,$13,$00 ; 9A23
        .byte   $9A,$4B,$04,$00,$02,$86,$6D,$60,$6D,$81,$0E,$02,$9A,$35,$02,$86 ; 9A33
        .byte   $66,$60,$67,$93,$0F,$01,$9A,$23,$02,$8D,$74,$60,$74,$88,$02,$8D ; 9A43
        .byte   $74,$60,$74,$88,$8D,$6D,$6D,$60,$6D,$80,$6D,$80,$8D,$6C,$8B,$04 ; 9A53
        .byte   $00,$04,$00,$02,$8B,$72,$60,$72,$86,$0E,$03,$9A,$64,$13,$00,$9A ; 9A63
        .byte   $8A,$04,$00,$02,$8A,$71,$60,$71,$85,$0E,$02,$9A,$74,$02,$8A,$6A ; 9A73
        .byte   $60,$6A,$96,$0F,$01,$9A,$62,$09,$02,$02,$8F,$76,$60,$76,$8A,$02 ; 9A83
        .byte   $8F,$76,$60,$76,$8A,$09,$03,$88,$60,$68,$60,$68,$80,$68,$02,$80 ; 9A93
        .byte   $09,$02,$06,$FF,$01,$48,$0D,$7F,$01,$4A,$4B,$4C,$4D,$4E,$4F,$50 ; 9AA3
        .byte   $0D,$00,$04,$00,$04,$00,$06,$E6,$02,$91,$02,$71,$02,$60,$98,$0E ; 9AB3
        .byte   $03,$9A,$B7,$04,$00,$02,$96,$02,$76,$02,$60,$9D,$0E,$02,$9A,$C6 ; 9AC3
        .byte   $02,$96,$02,$95,$94,$0F,$01,$9A,$B5,$02,$8F,$02,$6F,$02,$60,$96 ; 9AD3
        .byte   $02,$8F,$02,$6F,$02,$60,$96,$02,$94,$02,$74,$02,$60,$9B,$02,$94 ; 9AE3
        .byte   $02,$74,$02,$60,$9B,$02,$8D,$02,$6D,$02,$60,$94,$02,$8D,$02,$6D ; 9AF3
        .byte   $02,$60,$94,$76,$60,$76,$80,$76,$80,$76,$02,$80,$AF,$09,$03,$16 ; 9B03
        .byte   $9A,$21,$17,$08,$14,$09,$01,$0B,$FF,$04,$00,$04,$00,$06,$C8,$07 ; 9B13
        .byte   $09,$64,$07,$08,$6E,$6E,$07,$09,$64,$06,$2E,$69,$06,$C8,$07,$08 ; 9B23
        .byte   $6E,$6E,$6D,$0E,$06,$9B,$1E,$64,$6F,$6F,$06,$2E,$69,$6E,$69,$06 ; 9B33
        .byte   $C8,$6F,$6F,$0F,$03,$9B,$1C,$04,$00,$04,$00,$07,$09,$64,$6F,$6F ; 9B43
        .byte   $64,$06,$2E,$69,$06,$C8,$6F,$6F,$6F,$0E,$0D,$9B,$4C,$64,$6F,$06 ; 9B53
        .byte   $2E,$69,$6F,$64,$69,$6F,$6F,$69,$06,$C8,$6F,$6F,$06,$2E,$69,$64 ; 9B63
        .byte   $69,$69,$69,$04,$00,$06,$C8,$64,$6F,$6F,$63,$06,$2E,$69,$06,$C8 ; 9B73
        .byte   $6F,$6F,$6F,$0E,$17,$9B,$76,$04,$00,$04,$00,$64,$6F,$6F,$64,$06 ; 9B83
        .byte   $2E,$69,$06,$C8,$6F,$6F,$6F,$0E,$06,$9B,$8C,$64,$6F,$6F,$06,$2E ; 9B93
        .byte   $69,$6E,$69,$06,$C8,$6F,$6F,$0F,$01,$9B,$8A,$16,$9B,$4A,$17,$00 ; 9BA3
        .byte   $9B,$BB,$9C,$C5,$9E,$05,$9E,$8C,$05,$02,$00,$0A,$07,$04,$08,$06 ; 9BB3
        .byte   $E6,$07,$09,$09,$01,$18,$C0,$04,$08,$08,$07,$02,$CC,$08,$04,$8C ; 9BC3
        .byte   $80,$08,$07,$02,$CD,$08,$04,$8D,$80,$0E,$01,$9B,$CA,$18,$00,$08 ; 9BD3
        .byte   $01,$02,$AC,$D3,$8C,$0D,$7F,$02,$CD,$AF,$0D,$00,$02,$CC,$0D,$7F ; 9BE3
        .byte   $8D,$88,$0D,$00,$E7,$02,$AC,$D3,$8C,$0D,$7F,$02,$CD,$AF,$06,$F8 ; 9BF3
        .byte   $EC,$0D,$00,$F1,$08,$07,$18,$C0,$01,$AF,$08,$01,$CF,$08,$07,$01 ; 9C03
        .byte   $8F,$8A,$A7,$A8,$AC,$AF,$01,$AD,$08,$01,$CD,$08,$07,$02,$01,$8D ; 9C13
        .byte   $63,$A3,$A5,$A6,$AA,$09,$02,$00,$81,$80,$03,$98,$80,$97,$98,$9B ; 9C23
        .byte   $80,$9A,$80,$99,$9A,$9D,$80,$9C,$80,$9B,$9C,$9F,$80,$9E,$80,$9D ; 9C33
        .byte   $9E,$06,$FF,$03,$8A,$8C,$8A,$8C,$07,$05,$8A,$8C,$8A,$8C,$07,$04 ; 9C43
        .byte   $8A,$8C,$8A,$8C,$00,$01,$AA,$07,$03,$CA,$07,$02,$01,$AA,$04,$00 ; 9C53
        .byte   $07,$09,$06,$FF,$18,$40,$D9,$97,$8D,$93,$8D,$D9,$97,$8D,$93,$8D ; 9C63
        .byte   $06,$F5,$02,$9C,$02,$9A,$99,$12,$00,$9C,$94,$02,$97,$02,$9A,$99 ; 9C73
        .byte   $02,$97,$02,$95,$97,$01,$B5,$08,$01,$01,$B5,$08,$07,$0E,$01,$9C ; 9C83
        .byte   $61,$02,$B7,$79,$7A,$02,$9C,$02,$9A,$99,$02,$97,$02,$99,$9A,$01 ; 9C93
        .byte   $BB,$08,$0B,$02,$01,$DB,$08,$06,$00,$03,$8F,$08,$0A,$18,$00,$06 ; 9CA3
        .byte   $50,$07,$0B,$8E,$8D,$8C,$8B,$8A,$89,$88,$87,$86,$85,$84,$16,$9B ; 9CB3
        .byte   $C0,$17,$04,$00,$06,$46,$07,$0A,$08,$11,$09,$02,$18,$80,$0C,$FF ; 9CC3
        .byte   $04,$00,$04,$00,$80,$78,$02,$9D,$98,$9F,$98,$7D,$80,$78,$80,$79 ; 9CD3
        .byte   $02,$9F,$99,$03,$89,$81,$67,$80,$61,$13,$08,$9D,$0E,$0E,$02,$9C ; 9CE3
        .byte   $D5,$80,$03,$78,$02,$9D,$98,$9F,$98,$7D,$80,$79,$80,$79,$02,$9F ; 9CF3
        .byte   $99,$03,$89,$81,$67,$80,$61,$0F,$01,$9C,$D3,$80,$03,$78,$02,$9D ; 9D03
        .byte   $98,$9F,$98,$7D,$80,$78,$80,$7A,$02,$9D,$9A,$9F,$9A,$7D,$80,$7A ; 9D13
        .byte   $08,$07,$06,$F8,$07,$08,$09,$00,$18,$40,$02,$92,$02,$96,$9B,$9E ; 9D23
        .byte   $7B,$03,$8A,$60,$8D,$02,$03,$91,$02,$94,$78,$02,$9B,$78,$9F,$60 ; 9D33
        .byte   $03,$8A,$02,$03,$8F,$02,$92,$99,$9B,$76,$9B,$80,$7E,$BE,$03,$A8 ; 9D43
        .byte   $AA,$AD,$08,$07,$09,$01,$00,$89,$80,$88,$80,$87,$88,$8B,$80,$8A ; 9D53
        .byte   $80,$89,$8A,$8D,$80,$8C,$80,$8B,$8C,$8F,$80,$8E,$80,$8D,$8E,$06 ; 9D63
        .byte   $FF,$92,$94,$92,$94,$07,$05,$92,$94,$92,$94,$07,$04,$92,$94,$92 ; 9D73
        .byte   $94,$00,$01,$B2,$07,$03,$D2,$07,$02,$01,$B2,$04,$00,$04,$00,$80 ; 9D83
        .byte   $08,$07,$06,$FF,$07,$08,$09,$02,$6D,$02,$93,$8D,$80,$18,$80,$08 ; 9D93
        .byte   $0E,$06,$5A,$07,$07,$7C,$03,$69,$6B,$64,$69,$70,$18,$40,$0E,$01 ; 9DA3
        .byte   $9D,$90,$08,$07,$06,$F5,$07,$07,$02,$81,$02,$03,$97,$95,$13,$00 ; 9DB3
        .byte   $9D,$D8,$02,$93,$02,$97,$95,$02,$93,$02,$90,$93,$02,$92,$02,$90 ; 9DC3
        .byte   $8E,$0F,$01,$9D,$8E,$02,$B3,$75,$77,$02,$99,$02,$97,$96,$02,$94 ; 9DD3
        .byte   $02,$96,$97,$96,$80,$AF,$B6,$B9,$00,$9B,$80,$08,$0A,$18,$00,$06 ; 9DE3
        .byte   $50,$07,$0B,$03,$8F,$8E,$8D,$8C,$8B,$8A,$89,$88,$87,$86,$16,$9C ; 9DF3
        .byte   $C5,$17,$04,$00,$08,$0E,$09,$02,$04,$00,$06,$DC,$02,$88,$6F,$A0 ; 9E03
        .byte   $06,$82,$B4,$A8,$06,$DC,$12,$00,$9E,$29,$02,$89,$70,$A0,$06,$82 ; 9E13
        .byte   $B5,$A9,$0E,$05,$9E,$0B,$02,$87,$6E,$A0,$06,$82,$B3,$A7,$06,$DC ; 9E23
        .byte   $02,$86,$6D,$A0,$06,$82,$B2,$A6,$06,$DC,$02,$85,$6C,$A0,$06,$82 ; 9E33
        .byte   $B1,$A5,$04,$00,$06,$DC,$02,$83,$6A,$A0,$06,$82,$AF,$A3,$0E,$01 ; 9E43
        .byte   $9E,$45,$06,$DC,$C8,$C8,$C8,$C8,$01,$E8,$02,$C8,$02,$01,$88,$60 ; 9E53
        .byte   $04,$00,$02,$89,$75,$A0,$06,$82,$AE,$B3,$06,$DC,$0E,$06,$9E,$63 ; 9E63
        .byte   $02,$8A,$76,$A0,$06,$82,$B1,$B6,$06,$DC,$02,$83,$6F,$A0,$06,$82 ; 9E73
        .byte   $AA,$AF,$06,$F0,$E3,$16,$9E,$05,$17,$04,$00,$04,$00,$04,$00,$06 ; 9E83
        .byte   $3C,$08,$19,$09,$00,$07,$09,$68,$60,$68,$6B,$60,$68,$6C,$60,$6C ; 9E93
        .byte   $60,$68,$02,$80,$12,$00,$9E,$B1,$68,$60,$0E,$01,$9E,$90,$6B,$6B ; 9EA3
        .byte   $0F,$05,$9E,$8E,$04,$00,$69,$60,$69,$69,$80,$69,$69,$69,$60,$69 ; 9EB3
        .byte   $02,$80,$6B,$6B,$0E,$03,$9E,$B7,$08,$14,$06,$C8,$07,$0B,$CC,$CC ; 9EC3
        .byte   $CB,$CB,$EA,$07,$08,$AF,$AD,$08,$19,$06,$3C,$07,$08,$68,$69,$6A ; 9ED3
        .byte   $6B,$6C,$6B,$6A,$69,$08,$14,$06,$C8,$04,$00,$02,$85,$06,$01,$02 ; 9EE3
        .byte   $8A,$06,$C8,$6E,$6E,$85,$6E,$6E,$06,$01,$8A,$06,$C8,$6E,$6E,$0E ; 9EF3
        .byte   $08,$9E,$EC,$07,$0B,$AA,$AA,$AA,$AA,$16,$9E,$8C,$17,$00,$9F,$19 ; 9F03
        .byte   $A0,$36,$A1,$33,$A2,$3A,$05,$01,$A7,$0A,$02,$04,$00,$04,$00,$06 ; 9F13
        .byte   $5A,$07,$09,$09,$02,$08,$13,$18,$80,$90,$60,$02,$01,$DA,$01,$9A ; 9F23
        .byte   $60,$08,$04,$79,$79,$A0,$06,$6E,$08,$03,$03,$6D,$80,$07,$0C,$18 ; 9F33
        .byte   $C0,$6D,$A0,$0E,$01,$9F,$20,$06,$5A,$08,$13,$07,$09,$18,$80,$03 ; 9F43
        .byte   $96,$60,$02,$01,$DD,$01,$9D,$60,$08,$04,$7C,$7C,$A0,$06,$46,$08 ; 9F53
        .byte   $1A,$07,$0B,$18,$C0,$03,$6C,$60,$18,$80,$64,$07,$0A,$18,$C0,$6C ; 9F63
        .byte   $60,$07,$08,$18,$80,$64,$18,$C0,$6C,$60,$06,$F0,$08,$01,$18,$80 ; 9F73
        .byte   $61,$63,$65,$02,$C8,$60,$C7,$C5,$04,$00,$07,$00,$A0,$07,$09,$08 ; 9F83
        .byte   $05,$18,$80,$02,$01,$96,$07,$04,$0D,$08,$5B,$5C,$07,$09,$01,$DD ; 9F93
        .byte   $0D,$00,$80,$7B,$80,$03,$68,$80,$02,$03,$94,$01,$55,$07,$08,$0D ; 9FA3
        .byte   $1E,$56,$01,$96,$07,$09,$0D,$00,$8F,$01,$B1,$08,$01,$F1,$01,$B1 ; 9FB3
        .byte   $60,$08,$05,$9D,$54,$02,$60,$01,$9D,$07,$05,$0D,$64,$01,$71,$0D ; 9FC3
        .byte   $00,$07,$09,$0E,$01,$9F,$8B,$02,$9D,$9B,$60,$99,$02,$9B,$94,$60 ; 9FD3
        .byte   $03,$88,$02,$86,$85,$60,$83,$60,$41,$02,$60,$AA,$60,$02,$88,$86 ; 9FE3
        .byte   $60,$84,$A3,$03,$B2,$F4,$02,$9F,$9D,$60,$9B,$02,$9D ; 9FF3
