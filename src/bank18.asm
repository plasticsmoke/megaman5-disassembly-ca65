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
L8915:  .byte   $02                             ; 8915 02                       .
        .byte   $04                             ; 8916 04                       .
        php                                     ; 8917 08                       .
        bpl     L893A                           ; 8918 10 20                    . 
        rti                                     ; 891A 40                       @

; ----------------------------------------------------------------------------
        .byte   $80                             ; 891B 80                       .
L891C:  .byte   $03                             ; 891C 03                       .
        asl     $0C                             ; 891D 06 0C                    ..
        clc                                     ; 891F 18                       .
        bmi     L8982                           ; 8920 30 60                    0`
        .byte   $C0                             ; 8922 C0                       .
L8923:  brk                                     ; 8923 00                       .
        .byte   $0C                             ; 8924 0C                       .
        clc                                     ; 8925 18                       .
        bit     $30                             ; 8926 24 30                    $0
        .byte   $3C                             ; 8928 3C                       <
        pha                                     ; 8929 48                       H
        .byte   $54                             ; 892A 54                       T
        clc                                     ; 892B 18                       .
        bit     $30                             ; 892C 24 30                    $0
        .byte   $3C                             ; 892E 3C                       <
        pha                                     ; 892F 48                       H
        .byte   $54                             ; 8930 54                       T
        rts                                     ; 8931 60                       `

; ----------------------------------------------------------------------------
        .byte   $6C                             ; 8932 6C                       l
L8933:  brk                                     ; 8933 00                       .
        ora     ($02,x)                         ; 8934 01 02                    ..
        .byte   $03                             ; 8936 03                       .
        .byte   $04                             ; 8937 04                       .
        ora     $06                             ; 8938 05 06                    ..
L893A:  .byte   $07                             ; 893A 07                       .
        php                                     ; 893B 08                       .
        ora     #$0A                            ; 893C 09 0A                    ..
        .byte   $0B                             ; 893E 0B                       .
        .byte   $0C                             ; 893F 0C                       .
        asl     $100F                           ; 8940 0E 0F 10                 ...
        .byte   $12                             ; 8943 12                       .
        .byte   $13                             ; 8944 13                       .
        .byte   $14                             ; 8945 14                       .
        asl     L0018,x                         ; 8946 16 18                    ..
        .byte   $1B                             ; 8948 1B                       .
        asl     $2823,x                         ; 8949 1E 23 28                 .#(
        bmi     L898A                           ; 894C 30 3C                    0<
        bvc     L89CE                           ; 894E 50 7E                    P~
        .byte   $7F                             ; 8950 7F                       .
        .byte   $FE                             ; 8951 FE                       .
        .byte   $FF                             ; 8952 FF                       .
L8953:  brk                                     ; 8953 00                       .
        .byte   $07                             ; 8954 07                       .
        asl     $1C15                           ; 8955 0E 15 1C                 ...
        .byte   $23                             ; 8958 23                       #
L8959:  rol     a                               ; 8959 2A                       *
L895A:  and     ($5C),y                         ; 895A 31 5C                    1\
        .byte   $37                             ; 895C 37                       7
        .byte   $9C                             ; 895D 9C                       .
        rol     $E7,x                           ; 895E 36 E7                    6.
        and     $3C,x                           ; 8960 35 3C                    5<
        and     $9B,x                           ; 8962 35 9B                    5.
        .byte   $34                             ; 8964 34                       4
        .byte   $02                             ; 8965 02                       .
        .byte   $34                             ; 8966 34                       4
        .byte   $72                             ; 8967 72                       r
        .byte   $33                             ; 8968 33                       3
        nop                                     ; 8969 EA                       .
        .byte   $32                             ; 896A 32                       2
        ror     a                               ; 896B 6A                       j
        .byte   $32                             ; 896C 32                       2
        sbc     ($31),y                         ; 896D F1 31                    .1
        .byte   $80                             ; 896F 80                       .
        and     ($14),y                         ; 8970 31 14                    1.
        and     ($5C),y                         ; 8972 31 5C                    1\
        bmi     L8912                           ; 8974 30 9C                    0.
        .byte   $2F                             ; 8976 2F                       /
        .byte   $E7                             ; 8977 E7                       .
        rol     $2E3C                           ; 8978 2E 3C 2E                 .<.
        .byte   $9B                             ; 897B 9B                       .
        and     $2D02                           ; 897C 2D 02 2D                 -.-
L897F:  .byte   $72                             ; 897F 72                       r
        .byte   $2C                             ; 8980 2C                       ,
        nop                                     ; 8981 EA                       .
L8982:  .byte   $2B                             ; 8982 2B                       +
        ror     a                               ; 8983 6A                       j
        .byte   $2B                             ; 8984 2B                       +
        sbc     ($2A),y                         ; 8985 F1 2A                    .*
        .byte   $80                             ; 8987 80                       .
        rol     a                               ; 8988 2A                       *
        .byte   $14                             ; 8989 14                       .
L898A:  rol     a                               ; 898A 2A                       *
        .byte   $5C                             ; 898B 5C                       \
        and     #$9C                            ; 898C 29 9C                    ).
        plp                                     ; 898E 28                       (
        .byte   $E7                             ; 898F E7                       .
        .byte   $27                             ; 8990 27                       '
        .byte   $3C                             ; 8991 3C                       <
        .byte   $27                             ; 8992 27                       '
        .byte   $9B                             ; 8993 9B                       .
        rol     $02                             ; 8994 26 02                    &.
        rol     $72                             ; 8996 26 72                    &r
        and     $EA                             ; 8998 25 EA                    %.
        bit     $6A                             ; 899A 24 6A                    $j
        bit     $F1                             ; 899C 24 F1                    $.
        .byte   $23                             ; 899E 23                       #
        .byte   $80                             ; 899F 80                       .
        .byte   $23                             ; 89A0 23                       #
        .byte   $14                             ; 89A1 14                       .
        .byte   $23                             ; 89A2 23                       #
        .byte   $5C                             ; 89A3 5C                       \
        .byte   $22                             ; 89A4 22                       "
        .byte   $9C                             ; 89A5 9C                       .
        and     ($E7,x)                         ; 89A6 21 E7                    !.
        jsr     L203C                           ; 89A8 20 3C 20                  < 
        .byte   $9B                             ; 89AB 9B                       .
        .byte   $1F                             ; 89AC 1F                       .
        .byte   $02                             ; 89AD 02                       .
        .byte   $1F                             ; 89AE 1F                       .
        .byte   $72                             ; 89AF 72                       r
        asl     $1DEA,x                         ; 89B0 1E EA 1D                 ...
        ror     a                               ; 89B3 6A                       j
        ora     $1CF1,x                         ; 89B4 1D F1 1C                 ...
        .byte   $80                             ; 89B7 80                       .
        .byte   $1C                             ; 89B8 1C                       .
        .byte   $14                             ; 89B9 14                       .
        .byte   $1C                             ; 89BA 1C                       .
        .byte   $5C                             ; 89BB 5C                       \
        .byte   $1B                             ; 89BC 1B                       .
        .byte   $9C                             ; 89BD 9C                       .
        .byte   $1A                             ; 89BE 1A                       .
        .byte   $E7                             ; 89BF E7                       .
        ora     $193C,y                         ; 89C0 19 3C 19                 .<.
        .byte   $9B                             ; 89C3 9B                       .
        clc                                     ; 89C4 18                       .
        .byte   $02                             ; 89C5 02                       .
        clc                                     ; 89C6 18                       .
        .byte   $72                             ; 89C7 72                       r
        .byte   $17                             ; 89C8 17                       .
        nop                                     ; 89C9 EA                       .
        asl     $6A,x                           ; 89CA 16 6A                    .j
L89CC:  asl     $F1,x                           ; 89CC 16 F1                    ..
L89CE:  ora     $80,x                           ; 89CE 15 80                    ..
        ora     $14,x                           ; 89D0 15 14                    ..
        ora     $5C,x                           ; 89D2 15 5C                    .\
        .byte   $14                             ; 89D4 14                       .
        .byte   $9C                             ; 89D5 9C                       .
        .byte   $13                             ; 89D6 13                       .
        .byte   $E7                             ; 89D7 E7                       .
        .byte   $12                             ; 89D8 12                       .
        .byte   $3C                             ; 89D9 3C                       <
        .byte   $12                             ; 89DA 12                       .
        .byte   $9B                             ; 89DB 9B                       .
        ora     ($02),y                         ; 89DC 11 02                    ..
        ora     ($72),y                         ; 89DE 11 72                    .r
        bpl     L89CC                           ; 89E0 10 EA                    ..
        .byte   $0F                             ; 89E2 0F                       .
        ror     a                               ; 89E3 6A                       j
        .byte   $0F                             ; 89E4 0F                       .
        sbc     ($0E),y                         ; 89E5 F1 0E                    ..
        .byte   $80                             ; 89E7 80                       .
        asl     $0E14                           ; 89E8 0E 14 0E                 ...
        .byte   $5C                             ; 89EB 5C                       \
        ora     $0C9C                           ; 89EC 0D 9C 0C                 ...
        .byte   $E7                             ; 89EF E7                       .
L89F0:  .byte   $0B                             ; 89F0 0B                       .
        .byte   $3C                             ; 89F1 3C                       <
        .byte   $0B                             ; 89F2 0B                       .
        .byte   $9B                             ; 89F3 9B                       .
        asl     a                               ; 89F4 0A                       .
        .byte   $02                             ; 89F5 02                       .
        asl     a                               ; 89F6 0A                       .
        .byte   $72                             ; 89F7 72                       r
        ora     #$EA                            ; 89F8 09 EA                    ..
        php                                     ; 89FA 08                       .
        ror     a                               ; 89FB 6A                       j
        php                                     ; 89FC 08                       .
        sbc     ($07),y                         ; 89FD F1 07                    ..
        .byte   $80                             ; 89FF 80                       .
        .byte   $07                             ; 8A00 07                       .
        .byte   $14                             ; 8A01 14                       .
        .byte   $07                             ; 8A02 07                       .
L8A03:  .byte   $5C                             ; 8A03 5C                       \
        .byte   $06                             ; 8A04 06                       .
L8A05:  .byte   $9C                             ; 8A05 9C                       .
        ora     $E7                             ; 8A06 05 E7                    ..
        .byte   $04                             ; 8A08 04                       .
        .byte   $3C                             ; 8A09 3C                       <
        .byte   $04                             ; 8A0A 04                       .
        .byte   $9B                             ; 8A0B 9B                       .
        .byte   $03                             ; 8A0C 03                       .
        .byte   $02                             ; 8A0D 02                       .
        .byte   $03                             ; 8A0E 03                       .
        .byte   $72                             ; 8A0F 72                       r
        .byte   $02                             ; 8A10 02                       .
        nop                                     ; 8A11 EA                       .
        ora     ($6A,x)                         ; 8A12 01 6A                    .j
        ora     ($F1,x)                         ; 8A14 01 F1                    ..
        brk                                     ; 8A16 00                       .
        .byte   $80                             ; 8A17 80                       .
        brk                                     ; 8A18 00                       .
        .byte   $14                             ; 8A19 14                       .
        brk                                     ; 8A1A 00                       .
        brk                                     ; 8A1B 00                       .
        brk                                     ; 8A1C 00                       .
        brk                                     ; 8A1D 00                       .
        brk                                     ; 8A1E 00                       .
        brk                                     ; 8A1F 00                       .
        brk                                     ; 8A20 00                       .
        brk                                     ; 8A21 00                       .
        brk                                     ; 8A22 00                       .
        brk                                     ; 8A23 00                       .
L8A24:  brk                                     ; 8A24 00                       .
        brk                                     ; 8A25 00                       .
        brk                                     ; 8A26 00                       .
        brk                                     ; 8A27 00                       .
        brk                                     ; 8A28 00                       .
        brk                                     ; 8A29 00                       .
        brk                                     ; 8A2A 00                       .
        brk                                     ; 8A2B 00                       .
        brk                                     ; 8A2C 00                       .
        brk                                     ; 8A2D 00                       .
        brk                                     ; 8A2E 00                       .
        brk                                     ; 8A2F 00                       .
        brk                                     ; 8A30 00                       .
        brk                                     ; 8A31 00                       .
        brk                                     ; 8A32 00                       .
        brk                                     ; 8A33 00                       .
        brk                                     ; 8A34 00                       .
L8A35:  brk                                     ; 8A35 00                       .
        brk                                     ; 8A36 00                       .
        brk                                     ; 8A37 00                       .
        brk                                     ; 8A38 00                       .
        brk                                     ; 8A39 00                       .
        brk                                     ; 8A3A 00                       .
        brk                                     ; 8A3B 00                       .
        brk                                     ; 8A3C 00                       .
        brk                                     ; 8A3D 00                       .
        brk                                     ; 8A3E 00                       .
        brk                                     ; 8A3F 00                       .
; =============================================================================
; SOUND DATA DIRECTORY
;   $8A40 snd_song_count ($4C ids), $8A41/$8A42 instrument table ptr
;   ($8ADB, hi/lo), $8A43 snd_song_dir: $4C entries x 2 (hi/lo).
;   $8ADB-$8D12 instruments (8 bytes each), $8D13+ song/SFX streams
;   (continue through bank $19 and, as virtual $C000+, bank $1A).
; =============================================================================
snd_song_count:  .byte   $4C                             ; 8A40 4C                       L
L8A41:  txa                                     ; 8A41 8A                       .
L8A42:  .byte   $DB                             ; 8A42 DB                       .
snd_song_dir:  .byte   $8D                             ; 8A43 8D                       .
snd_song_dir1:  .byte   $13                             ; 8A44 13                       .
        .byte   $93                             ; 8A45 93                       .
        .byte   $02                             ; 8A46 02                       .
        .byte   $97                             ; 8A47 97                       .
        ror     $B29B,x                         ; 8A48 7E 9B B2                 ~..
L8A4B:  .byte   $9F                             ; 8A4B 9F                       .
        bpl     L89F0                           ; 8A4C 10 A2                    ..
        .byte   $A7                             ; 8A4E A7                       .
        ldx     $EA                             ; 8A4F A6 EA                    ..
        tax                                     ; 8A51 AA                       .
        lda     $AE,x                           ; 8A52 B5 AE                    ..
        adc     $64B2,x                         ; 8A54 7D B2 64                 }.d
        .byte   $B7                             ; 8A57 B7                       .
        pha                                     ; 8A58 48                       H
        tsx                                     ; 8A59 BA                       .
        .byte   $DC                             ; 8A5A DC                       .
        lda     $C3C8,x                         ; 8A5B BD C8 C3                 ...
        bcc     L8A24                           ; 8A5E 90 C4                    ..
L8A60:  cmp     $C5,x                           ; 8A60 D5 C5                    ..
        cmp     $F3C6,x                         ; 8A62 DD C6 F3                 ...
        .byte   $C7                             ; 8A65 C7                       .
        cpy     #$C8                            ; 8A66 C0 C8                    ..
        .byte   $34                             ; 8A68 34                       4
        iny                                     ; 8A69 C8                       .
        bne     L8A35                           ; 8A6A D0 C9                    ..
        cpx     #$CA                            ; 8A6C E0 CA                    ..
        .byte   $72                             ; 8A6E 72                       r
        .byte   $CB                             ; 8A6F CB                       .
        bcs     L8A41                           ; 8A70 B0 CF                    ..
        .byte   $93                             ; 8A72 93                       .
        .byte   $CF                             ; 8A73 CF                       .
L8A74:  .byte   $CF                             ; 8A74 CF                       .
        .byte   $CF                             ; 8A75 CF                       .
        .byte   $E2                             ; 8A76 E2                       .
        .byte   $CF                             ; 8A77 CF                       .
        .byte   $FB                             ; 8A78 FB                       .
        bne     L8A82                           ; 8A79 D0 07                    ..
        bne     L8A9F                           ; 8A7B D0 22                    ."
        bne     L8ABF                           ; 8A7D D0 40                    .@
        bne     L8A05                           ; 8A7F D0 84                    ..
        .byte   $D0                             ; 8A81 D0                       .
L8A82:  sty     $D0,x                           ; 8A82 94 D0                    ..
L8A84:  .byte   $A7                             ; 8A84 A7                       .
L8A85:  bne     L8A4B                           ; 8A85 D0 C4                    ..
        bne     L8A74                           ; 8A87 D0 EB                    ..
        cmp     ($2F),y                         ; 8A89 D1 2F                    ./
        cmp     ($49),y                         ; 8A8B D1 49                    .I
        cmp     ($AF),y                         ; 8A8D D1 AF                    ..
        cmp     ($D6),y                         ; 8A8F D1 D6                    ..
        cmp     ($EC),y                         ; 8A91 D1 EC                    ..
        cmp     ($FE),y                         ; 8A93 D1 FE                    ..
        .byte   $D2                             ; 8A95 D2                       .
        jsr     L3DD2                           ; 8A96 20 D2 3D                  .=
        .byte   $D2                             ; 8A99 D2                       .
        eor     $66D2                           ; 8A9A 4D D2 66                 M.f
        .byte   $D2                             ; 8A9D D2                       .
        .byte   $84                             ; 8A9E 84                       .
L8A9F:  .byte   $D2                             ; 8A9F D2                       .
        .byte   $9B                             ; 8AA0 9B                       .
        .byte   $D2                             ; 8AA1 D2                       .
        .byte   $AB                             ; 8AA2 AB                       .
        .byte   $D2                             ; 8AA3 D2                       .
        cpx     #$D3                            ; 8AA4 E0 D3                    ..
        .byte   $0F                             ; 8AA6 0F                       .
        .byte   $D3                             ; 8AA7 D3                       .
        .byte   $33                             ; 8AA8 33                       3
        .byte   $D3                             ; 8AA9 D3                       .
        stx     $D3                             ; 8AAA 86 D3                    ..
        .byte   $AB                             ; 8AAC AB                       .
        .byte   $D3                             ; 8AAD D3                       .
        bne     L8A84                           ; 8AAE D0 D4                    ..
        and     #$D4                            ; 8AB0 29 D4                    ).
        lsr     $D4,x                           ; 8AB2 56 D4                    V.
        sty     $D4                             ; 8AB4 84 D4                    ..
        lda     ($D4,x)                         ; 8AB6 A1 D4                    ..
        .byte   $B7                             ; 8AB8 B7                       .
        .byte   $D4                             ; 8AB9 D4                       .
        cmp     #$D4                            ; 8ABA C9 D4                    ..
        cmp     $D4,x                           ; 8ABC D5 D4                    ..
        .byte   $E1                             ; 8ABE E1                       .
L8ABF:  .byte   $D4                             ; 8ABF D4                       .
        .byte   $EF                             ; 8AC0 EF                       .
        cmp     $03,x                           ; 8AC1 D5 03                    ..
        cmp     $0F,x                           ; 8AC3 D5 0F                    ..
        cmp     $21,x                           ; 8AC5 D5 21                    .!
        cmp     $41,x                           ; 8AC7 D5 41                    .A
        cmp     $63,x                           ; 8AC9 D5 63                    .c
        cmp     $91,x                           ; 8ACB D5 91                    ..
        cmp     $B4,x                           ; 8ACD D5 B4                    ..
        cmp     $D0,x                           ; 8ACF D5 D0                    ..
        dec     $15,x                           ; 8AD1 D6 15                    ..
        dec     $57,x                           ; 8AD3 D6 57                    .W
        dec     $67,x                           ; 8AD5 D6 67                    .g
        cld                                     ; 8AD7 D8                       .
        cli                                     ; 8AD8 58                       X
        cld                                     ; 8AD9 D8                       .
        clv                                     ; 8ADA B8                       .
        .byte   $1F                             ; 8ADB 1F                       .
        ora     ($F0,x)                         ; 8ADC 01 F0                    ..
        bpl     L8A60                           ; 8ADE 10 80                    ..
        brk                                     ; 8AE0 00                       .
        brk                                     ; 8AE1 00                       .
        brk                                     ; 8AE2 00                       .
        .byte   $1F                             ; 8AE3 1F                       .
        ora     $0FE0,x                         ; 8AE4 1D E0 0F                 ...
        cmp     $01,y                           ; 8AE7 D9 01 00                 ...
        brk                                     ; 8AEA 00                       .
        .byte   $1F                             ; 8AEB 1F                       .
        ora     $11E0,x                         ; 8AEC 1D E0 11                 ...
        .byte   $80                             ; 8AEF 80                       .
        brk                                     ; 8AF0 00                       .
        brk                                     ; 8AF1 00                       .
        .byte   $80                             ; 8AF2 80                       .
        ora     $A01B,x                         ; 8AF3 1D 1B A0                 ...
        .byte   $02                             ; 8AF6 02                       .
        .byte   $80                             ; 8AF7 80                       .
        brk                                     ; 8AF8 00                       .
L8AF9:  brk                                     ; 8AF9 00                       .
        brk                                     ; 8AFA 00                       .
        .byte   $1F                             ; 8AFB 1F                       .
        ora     ($D0,x)                         ; 8AFC 01 D0                    ..
        .byte   $0F                             ; 8AFE 0F                       .
        .byte   $82                             ; 8AFF 82                       .
        brk                                     ; 8B00 00                       .
        .byte   $39                             ; 8B01 39                       9
L8B02:  brk                                     ; 8B02 00                       .
        .byte   $1F                             ; 8B03 1F                       .
        ora     ($E0,x)                         ; 8B04 01 E0                    ..
        asl     a                               ; 8B06 0A                       .
        brk                                     ; 8B07 00                       .
        brk                                     ; 8B08 00                       .
        brk                                     ; 8B09 00                       .
        brk                                     ; 8B0A 00                       .
        .byte   $1F                             ; 8B0B 1F                       .
        ora     $0FE0,x                         ; 8B0C 1D E0 0F                 ...
        .byte   $80                             ; 8B0F 80                       .
        brk                                     ; 8B10 00                       .
        brk                                     ; 8B11 00                       .
        .byte   $80                             ; 8B12 80                       .
        .byte   $1F                             ; 8B13 1F                       .
        ora     $0DE0,x                         ; 8B14 1D E0 0D                 ...
        .byte   $80                             ; 8B17 80                       .
        brk                                     ; 8B18 00                       .
        brk                                     ; 8B19 00                       .
        .byte   $80                             ; 8B1A 80                       .
        asl     $E015,x                         ; 8B1B 1E 15 E0                 ...
        asl     a                               ; 8B1E 0A                       .
        cpx     #$01                            ; 8B1F E0 01                    ..
        brk                                     ; 8B21 00                       .
        brk                                     ; 8B22 00                       .
        .byte   $1F                             ; 8B23 1F                       .
        .byte   $1B                             ; 8B24 1B                       .
        ldy     #$05                            ; 8B25 A0 05                    ..
        .byte   $CB                             ; 8B27 CB                       .
        .byte   $02                             ; 8B28 02                       .
        .byte   $3C                             ; 8B29 3C                       <
        brk                                     ; 8B2A 00                       .
        asl     $A014,x                         ; 8B2B 1E 14 A0                 ...
        bpl     L8AF9                           ; 8B2E 10 C9                    ..
        brk                                     ; 8B30 00                       .
        .byte   $42                             ; 8B31 42                       B
        brk                                     ; 8B32 00                       .
        .byte   $1F                             ; 8B33 1F                       .
        ora     $0FD0,x                         ; 8B34 1D D0 0F                 ...
        .byte   $E3                             ; 8B37 E3                       .
        .byte   $03                             ; 8B38 03                       .
        brk                                     ; 8B39 00                       .
        brk                                     ; 8B3A 00                       .
        asl     L800D,x                         ; 8B3B 1E 0D 80                 ...
        .byte   $07                             ; 8B3E 07                       .
        sbc     $04                             ; 8B3F E5 04                    ..
        .byte   $17                             ; 8B41 17                       .
        brk                                     ; 8B42 00                       .
        ora     L9009,x                         ; 8B43 1D 09 90                 ...
        .byte   $03                             ; 8B46 03                       .
        .byte   $CB                             ; 8B47 CB                       .
        ora     ($37,x)                         ; 8B48 01 37                    .7
        brk                                     ; 8B4A 00                       .
        asl     $E00D,x                         ; 8B4B 1E 0D E0                 ...
        .byte   $12                             ; 8B4E 12                       .
        beq     L8B52                           ; 8B4F F0 01                    ..
        .byte   $1F                             ; 8B51 1F                       .
L8B52:  brk                                     ; 8B52 00                       .
        .byte   $1F                             ; 8B53 1F                       .
        .byte   $1B                             ; 8B54 1B                       .
        beq     L8B67                           ; 8B55 F0 10                    ..
        inc     $01                             ; 8B57 E6 01                    ..
        ora     (L0000,x)                       ; 8B59 01 00                    ..
        .byte   $1F                             ; 8B5B 1F                       .
        ora     $0FD0,x                         ; 8B5C 1D D0 0F                 ...
        beq     L8B66                           ; 8B5F F0 05                    ..
        .byte   $0F                             ; 8B61 0F                       .
        brk                                     ; 8B62 00                       .
        .byte   $1F                             ; 8B63 1F                       .
        .byte   $1D                             ; 8B64 1D                       .
        .byte   $E0                             ; 8B65 E0                       .
L8B66:  php                                     ; 8B66 08                       .
L8B67:  .byte   $B7                             ; 8B67 B7                       .
        ora     ($40,x)                         ; 8B68 01 40                    .@
        brk                                     ; 8B6A 00                       .
        .byte   $1F                             ; 8B6B 1F                       .
L8B6C:  .byte   $1C                             ; 8B6C 1C                       .
        bne     L8B77                           ; 8B6D D0 08                    ..
        txs                                     ; 8B6F 9A                       .
        ora     ($22,x)                         ; 8B70 01 22                    ."
        brk                                     ; 8B72 00                       .
        .byte   $1F                             ; 8B73 1F                       .
        .byte   $13                             ; 8B74 13                       .
        cpx     #$0D                            ; 8B75 E0 0D                    ..
L8B77:  cli                                     ; 8B77 58                       X
        brk                                     ; 8B78 00                       .
        ora     L0000,x                         ; 8B79 15 00                    ..
        .byte   $1F                             ; 8B7B 1F                       .
        ora     $1050,y                         ; 8B7C 19 50 10                 .P.
        .byte   $9E                             ; 8B7F 9E                       .
        jsr     L0026                           ; 8B80 20 26 00                  &.
        .byte   $1F                             ; 8B83 1F                       .
        .byte   $1F                             ; 8B84 1F                       .
        cpx     #$1B                            ; 8B85 E0 1B                    ..
        .byte   $9E                             ; 8B87 9E                       .
        cli                                     ; 8B88 58                       X
        .byte   $7C                             ; 8B89 7C                       |
        brk                                     ; 8B8A 00                       .
        clc                                     ; 8B8B 18                       .
        brk                                     ; 8B8C 00                       .
        bne     L8BA2                           ; 8B8D D0 13                    ..
        .byte   $80                             ; 8B8F 80                       .
        brk                                     ; 8B90 00                       .
        brk                                     ; 8B91 00                       .
        brk                                     ; 8B92 00                       .
        asl     $E014,x                         ; 8B93 1E 14 E0                 ...
        .byte   $0F                             ; 8B96 0F                       .
        .byte   $0F                             ; 8B97 0F                       .
        brk                                     ; 8B98 00                       .
        asl     L0000,x                         ; 8B99 16 00                    ..
        .byte   $07                             ; 8B9B 07                       .
        .byte   $1F                             ; 8B9C 1F                       .
        beq     L8BA5                           ; 8B9D F0 06                    ..
        .byte   $80                             ; 8B9F 80                       .
        brk                                     ; 8BA0 00                       .
        brk                                     ; 8BA1 00                       .
L8BA2:  brk                                     ; 8BA2 00                       .
        .byte   $1F                             ; 8BA3 1F                       .
        .byte   $01                             ; 8BA4 01                       .
L8BA5:  bne     L8BC5                           ; 8BA5 D0 1E                    ..
        .byte   $72                             ; 8BA7 72                       r
        .byte   $23                             ; 8BA8 23                       #
        ora     ($80),y                         ; 8BA9 11 80                    ..
        .byte   $1F                             ; 8BAB 1F                       .
        .byte   $1B                             ; 8BAC 1B                       .
        cpy     #$05                            ; 8BAD C0 05                    ..
        .byte   $D2                             ; 8BAF D2                       .
        .byte   $03                             ; 8BB0 03                       .
        pha                                     ; 8BB1 48                       H
        brk                                     ; 8BB2 00                       .
        asl     $F00D,x                         ; 8BB3 1E 0D F0                 ...
        .byte   $14                             ; 8BB6 14                       .
        sed                                     ; 8BB7 F8                       .
        ora     ($2E,x)                         ; 8BB8 01 2E                    ..
        brk                                     ; 8BBA 00                       .
        asl     $E013,x                         ; 8BBB 1E 13 E0                 ...
        .byte   $02                             ; 8BBE 02                       .
        .byte   $DA                             ; 8BBF DA                       .
        brk                                     ; 8BC0 00                       .
        ora     (L0000,x)                       ; 8BC1 01 00                    ..
        .byte   $1F                             ; 8BC3 1F                       .
        .byte   $1D                             ; 8BC4 1D                       .
L8BC5:  bne     L8BCD                           ; 8BC5 D0 06                    ..
        .byte   $E3                             ; 8BC7 E3                       .
        .byte   $03                             ; 8BC8 03                       .
        brk                                     ; 8BC9 00                       .
        brk                                     ; 8BCA 00                       .
        .byte   $1F                             ; 8BCB 1F                       .
        .byte   $1A                             ; 8BCC 1A                       .
L8BCD:  ldy     #$05                            ; 8BCD A0 05                    ..
        .byte   $FF                             ; 8BCF FF                       .
        ora     ($33,x)                         ; 8BD0 01 33                    .3
        brk                                     ; 8BD2 00                       .
        asl     $A01A,x                         ; 8BD3 1E 1A A0                 ...
        ora     $E4                             ; 8BD6 05 E4                    ..
        .byte   $04                             ; 8BD8 04                       .
        brk                                     ; 8BD9 00                       .
        brk                                     ; 8BDA 00                       .
        .byte   $1F                             ; 8BDB 1F                       .
        ora     $02A0,y                         ; 8BDC 19 A0 02                 ...
        brk                                     ; 8BDF 00                       .
        brk                                     ; 8BE0 00                       .
        brk                                     ; 8BE1 00                       .
        brk                                     ; 8BE2 00                       .
        .byte   $1F                             ; 8BE3 1F                       .
        .byte   $04                             ; 8BE4 04                       .
        .byte   $80                             ; 8BE5 80                       .
        .byte   $02                             ; 8BE6 02                       .
        .byte   $80                             ; 8BE7 80                       .
        brk                                     ; 8BE8 00                       .
        brk                                     ; 8BE9 00                       .
        brk                                     ; 8BEA 00                       .
        .byte   $1F                             ; 8BEB 1F                       .
        asl     $01D0,x                         ; 8BEC 1E D0 01                 ...
        dec     L0000                           ; 8BEF C6 00                    ..
        .byte   $32                             ; 8BF1 32                       2
        brk                                     ; 8BF2 00                       .
        .byte   $1F                             ; 8BF3 1F                       .
        .byte   $1C                             ; 8BF4 1C                       .
        beq     L8C16                           ; 8BF5 F0 1F                    ..
        .byte   $EF                             ; 8BF7 EF                       .
        .byte   $4B                             ; 8BF8 4B                       K
        asl     L0000                           ; 8BF9 06 00                    ..
        ora     $F01F,y                         ; 8BFB 19 1F F0                 ...
        .byte   $1F                             ; 8BFE 1F                       .
        sta     $02,x                           ; 8BFF 95 02                    ..
        .byte   $1D                             ; 8C01 1D                       .
L8C02:  brk                                     ; 8C02 00                       .
        .byte   $1F                             ; 8C03 1F                       .
        asl     $02F0,x                         ; 8C04 1E F0 02                 ...
        .byte   $EF                             ; 8C07 EF                       .
        brk                                     ; 8C08 00                       .
        lsr     L0000                           ; 8C09 46 00                    F.
        .byte   $17                             ; 8C0B 17                       .
        .byte   $02                             ; 8C0C 02                       .
        cpx     #$0F                            ; 8C0D E0 0F                    ..
        brk                                     ; 8C0F 00                       .
        brk                                     ; 8C10 00                       .
        brk                                     ; 8C11 00                       .
        brk                                     ; 8C12 00                       .
        .byte   $1F                             ; 8C13 1F                       .
        .byte   $1F                             ; 8C14 1F                       .
        .byte   $F0                             ; 8C15 F0                       .
L8C16:  .byte   $1F                             ; 8C16 1F                       .
        .byte   $FF                             ; 8C17 FF                       .
        ora     #$18                            ; 8C18 09 18                    ..
        .byte   $80                             ; 8C1A 80                       .
        .byte   $1F                             ; 8C1B 1F                       .
        .byte   $1F                             ; 8C1C 1F                       .
        beq     L8C3E                           ; 8C1D F0 1F                    ..
        brk                                     ; 8C1F 00                       .
        brk                                     ; 8C20 00                       .
        brk                                     ; 8C21 00                       .
        brk                                     ; 8C22 00                       .
        .byte   $1F                             ; 8C23 1F                       .
        .byte   $1F                             ; 8C24 1F                       .
        beq     L8C46                           ; 8C25 F0 1F                    ..
        .byte   $FF                             ; 8C27 FF                       .
        .byte   $02                             ; 8C28 02                       .
        brk                                     ; 8C29 00                       .
        brk                                     ; 8C2A 00                       .
        .byte   $1F                             ; 8C2B 1F                       .
        .byte   $1F                             ; 8C2C 1F                       .
        beq     L8C4E                           ; 8C2D F0 1F                    ..
        .byte   $92                             ; 8C2F 92                       .
        .byte   $7F                             ; 8C30 7F                       .
        brk                                     ; 8C31 00                       .
        brk                                     ; 8C32 00                       .
        .byte   $1F                             ; 8C33 1F                       .
        ora     (L0000,x)                       ; 8C34 01 00                    ..
        .byte   $0F                             ; 8C36 0F                       .
        .byte   $E3                             ; 8C37 E3                       .
        .byte   $7F                             ; 8C38 7F                       .
        brk                                     ; 8C39 00                       .
        brk                                     ; 8C3A 00                       .
        .byte   $1F                             ; 8C3B 1F                       .
        .byte   $1F                             ; 8C3C 1F                       .
        .byte   $F0                             ; 8C3D F0                       .
L8C3E:  .byte   $1F                             ; 8C3E 1F                       .
        .byte   $FF                             ; 8C3F FF                       .
        jmp     L0000                           ; 8C40 4C 00 00                 L..

; ----------------------------------------------------------------------------
        .byte   $1F                             ; 8C43 1F                       .
        .byte   $1F                             ; 8C44 1F                       .
        .byte   $F0                             ; 8C45 F0                       .
L8C46:  .byte   $1F                             ; 8C46 1F                       .
        sta     $7F,y                           ; 8C47 99 7F 00                 ...
        brk                                     ; 8C4A 00                       .
        ora     $F01F,x                         ; 8C4B 1D 1F F0                 ...
L8C4E:  .byte   $1F                             ; 8C4E 1F                       .
        .byte   $80                             ; 8C4F 80                       .
        brk                                     ; 8C50 00                       .
        brk                                     ; 8C51 00                       .
        brk                                     ; 8C52 00                       .
        .byte   $1F                             ; 8C53 1F                       .
        .byte   $1F                             ; 8C54 1F                       .
        beq     L8C76                           ; 8C55 F0 1F                    ..
        .byte   $B7                             ; 8C57 B7                       .
        .byte   $27                             ; 8C58 27                       '
        brk                                     ; 8C59 00                       .
        brk                                     ; 8C5A 00                       .
        .byte   $1F                             ; 8C5B 1F                       .
        .byte   $1A                             ; 8C5C 1A                       .
        ldy     #$07                            ; 8C5D A0 07                    ..
        .byte   $CF                             ; 8C5F CF                       .
L8C60:  rol     L0000,x                         ; 8C60 36 00                    6.
        .byte   $80                             ; 8C62 80                       .
        .byte   $1F                             ; 8C63 1F                       .
L8C64:  .byte   $1F                             ; 8C64 1F                       .
        beq     L8C86                           ; 8C65 F0 1F                    ..
        ldx     $7F                             ; 8C67 A6 7F                    ..
        brk                                     ; 8C69 00                       .
        .byte   $80                             ; 8C6A 80                       .
        .byte   $1C                             ; 8C6B 1C                       .
        .byte   $13                             ; 8C6C 13                       .
        bpl     L8C8E                           ; 8C6D 10 1F                    ..
        .byte   $FF                             ; 8C6F FF                       .
        .byte   $7F                             ; 8C70 7F                       .
        brk                                     ; 8C71 00                       .
        brk                                     ; 8C72 00                       .
        .byte   $1F                             ; 8C73 1F                       .
        .byte   $1E                             ; 8C74 1E                       .
        .byte   $F0                             ; 8C75 F0                       .
L8C76:  .byte   $1F                             ; 8C76 1F                       .
        .byte   $EB                             ; 8C77 EB                       .
        .byte   $7C                             ; 8C78 7C                       |
        .byte   $47                             ; 8C79 47                       G
        .byte   $80                             ; 8C7A 80                       .
        .byte   $1F                             ; 8C7B 1F                       .
        .byte   $1B                             ; 8C7C 1B                       .
        bne     L8C8E                           ; 8C7D D0 0F                    ..
        .byte   $E1                             ; 8C7F E1                       .
L8C80:  .byte   $67                             ; 8C80 67                       g
        clc                                     ; 8C81 18                       .
        brk                                     ; 8C82 00                       .
        .byte   $1F                             ; 8C83 1F                       .
        .byte   $1F                             ; 8C84 1F                       .
        .byte   $F0                             ; 8C85 F0                       .
L8C86:  .byte   $1F                             ; 8C86 1F                       .
        .byte   $80                             ; 8C87 80                       .
        brk                                     ; 8C88 00                       .
        brk                                     ; 8C89 00                       .
L8C8A:  .byte   $80                             ; 8C8A 80                       .
        .byte   $1F                             ; 8C8B 1F                       .
        .byte   $1F                             ; 8C8C 1F                       .
L8C8D:  .byte   $F0                             ; 8C8D F0                       .
L8C8E:  .byte   $1F                             ; 8C8E 1F                       .
        .byte   $D4                             ; 8C8F D4                       .
        .byte   $03                             ; 8C90 03                       .
        eor     (L0000,x)                       ; 8C91 41 00                    A.
        .byte   $1F                             ; 8C93 1F                       .
        .byte   $1F                             ; 8C94 1F                       .
        beq     L8CA6                           ; 8C95 F0 0F                    ..
        .byte   $D7                             ; 8C97 D7                       .
        lsr     $7F,x                           ; 8C98 56 7F                    V.
        brk                                     ; 8C9A 00                       .
        .byte   $1F                             ; 8C9B 1F                       .
        asl     $E0,x                           ; 8C9C 16 E0                    ..
        ora     $64E4,y                         ; 8C9E 19 E4 64                 ..d
        asl     $1F00,x                         ; 8CA1 1E 00 1F                 ...
        .byte   $1F                             ; 8CA4 1F                       .
        .byte   $F0                             ; 8CA5 F0                       .
L8CA6:  bpl     L8C64                           ; 8CA6 10 BC                    ..
        .byte   $02                             ; 8CA8 02                       .
        brk                                     ; 8CA9 00                       .
        brk                                     ; 8CAA 00                       .
        .byte   $1F                             ; 8CAB 1F                       .
        .byte   $1F                             ; 8CAC 1F                       .
        beq     L8CCE                           ; 8CAD F0 1F                    ..
        lda     $7F                             ; 8CAF A5 7F                    ..
        brk                                     ; 8CB1 00                       .
        brk                                     ; 8CB2 00                       .
        .byte   $1F                             ; 8CB3 1F                       .
        .byte   $1F                             ; 8CB4 1F                       .
        beq     L8CD6                           ; 8CB5 F0 1F                    ..
        .byte   $D3                             ; 8CB7 D3                       .
        asl     L0000,x                         ; 8CB8 16 00                    ..
        brk                                     ; 8CBA 00                       .
        .byte   $1F                             ; 8CBB 1F                       .
        .byte   $1F                             ; 8CBC 1F                       .
        beq     L8CC3                           ; 8CBD F0 04                    ..
        .byte   $80                             ; 8CBF 80                       .
        brk                                     ; 8CC0 00                       .
        brk                                     ; 8CC1 00                       .
        brk                                     ; 8CC2 00                       .
L8CC3:  .byte   $1A                             ; 8CC3 1A                       .
        .byte   $1F                             ; 8CC4 1F                       .
        cpx     #$1C                            ; 8CC5 E0 1C                    ..
        brk                                     ; 8CC7 00                       .
        brk                                     ; 8CC8 00                       .
        brk                                     ; 8CC9 00                       .
        brk                                     ; 8CCA 00                       .
        .byte   $1F                             ; 8CCB 1F                       .
        .byte   $1E                             ; 8CCC 1E                       .
        .byte   $C0                             ; 8CCD C0                       .
L8CCE:  .byte   $07                             ; 8CCE 07                       .
        brk                                     ; 8CCF 00                       .
        brk                                     ; 8CD0 00                       .
        brk                                     ; 8CD1 00                       .
        .byte   $80                             ; 8CD2 80                       .
L8CD3:  .byte   $1F                             ; 8CD3 1F                       .
        ora     ($F0,x)                         ; 8CD4 01 F0                    ..
L8CD6:  ora     $E1                             ; 8CD6 05 E1                    ..
        ora     a:L0000                         ; 8CD8 0D 00 00                 ...
        .byte   $1F                             ; 8CDB 1F                       .
        .byte   $1F                             ; 8CDC 1F                       .
        beq     L8CFE                           ; 8CDD F0 1F                    ..
        .byte   $FF                             ; 8CDF FF                       .
        .byte   $7F                             ; 8CE0 7F                       .
        brk                                     ; 8CE1 00                       .
        brk                                     ; 8CE2 00                       .
        .byte   $1C                             ; 8CE3 1C                       .
        .byte   $1F                             ; 8CE4 1F                       .
        beq     L8CEE                           ; 8CE5 F0 07                    ..
        .byte   $FF                             ; 8CE7 FF                       .
        .byte   $7F                             ; 8CE8 7F                       .
        rol     L0000,x                         ; 8CE9 36 00                    6.
        ora     $F00B,y                         ; 8CEB 19 0B F0                 ...
L8CEE:  .byte   $12                             ; 8CEE 12                       .
        .byte   $FF                             ; 8CEF FF                       .
        .byte   $7F                             ; 8CF0 7F                       .
        rol     L0000,x                         ; 8CF1 36 00                    6.
        .byte   $1F                             ; 8CF3 1F                       .
        .byte   $12                             ; 8CF4 12                       .
        rti                                     ; 8CF5 40                       @

; ----------------------------------------------------------------------------
        asl     $7FFF,x                         ; 8CF6 1E FF 7F                 ...
        eor     (L0000),y                       ; 8CF9 51 00                    Q.
        .byte   $1F                             ; 8CFB 1F                       .
        .byte   $1F                             ; 8CFC 1F                       .
        .byte   $F0                             ; 8CFD F0                       .
L8CFE:  .byte   $1F                             ; 8CFE 1F                       .
        .byte   $FF                             ; 8CFF FF                       .
L8D00:  .byte   $19                             ; 8D00 19                       .
L8D01:  brk                                     ; 8D01 00                       .
        brk                                     ; 8D02 00                       .
        .byte   $1F                             ; 8D03 1F                       .
        .byte   $1F                             ; 8D04 1F                       .
        beq     L8D16                           ; 8D05 F0 0F                    ..
        .byte   $D7                             ; 8D07 D7                       .
        ora     #$7F                            ; 8D08 09 7F                    ..
        brk                                     ; 8D0A 00                       .
        brk                                     ; 8D0B 00                       .
        brk                                     ; 8D0C 00                       .
        brk                                     ; 8D0D 00                       .
        brk                                     ; 8D0E 00                       .
        brk                                     ; 8D0F 00                       .
        brk                                     ; 8D10 00                       .
        brk                                     ; 8D11 00                       .
        brk                                     ; 8D12 00                       .
        brk                                     ; 8D13 00                       .
        .byte   $8D                             ; 8D14 8D                       .
        .byte   $1C                             ; 8D15 1C                       .
L8D16:  stx     L90E8                           ; 8D16 8E E8 90                 ...
        sbc     ($92),y                         ; 8D19 F1 92                    ..
        .byte   $23                             ; 8D1B 23                       #
        ora     $01                             ; 8D1C 05 01                    ..
        cld                                     ; 8D1E D8                       .
        .byte   $04                             ; 8D1F 04                       .
        brk                                     ; 8D20 00                       .
        ldy     #$18                            ; 8D21 A0 18                    ..
        rti                                     ; 8D23 40                       @

; ----------------------------------------------------------------------------
        .byte   $07                             ; 8D24 07                       .
        .byte   $0B                             ; 8D25 0B                       .
        ora     #$02                            ; 8D26 09 02                    ..
        php                                     ; 8D28 08                       .
        .byte   $17                             ; 8D29 17                       .
        asl     $E6                             ; 8D2A 06 E6                    ..
        .byte   $02                             ; 8D2C 02                       .
        .byte   $9F                             ; 8D2D 9F                       .
        php                                     ; 8D2E 08                       .
        .byte   $04                             ; 8D2F 04                       .
        asl     $0A                             ; 8D30 06 0A                    ..
        .byte   $02                             ; 8D32 02                       .
        ora     ($DD,x)                         ; 8D33 01 DD                    ..
        ora     ($7D,x)                         ; 8D35 01 7D                    .}
        clc                                     ; 8D37 18                       .
        cpy     #$08                            ; 8D38 C0 08                    ..
        asl     $0807                           ; 8D3A 0E 07 08                 ...
        adc     $037F,x                         ; 8D3D 7D 7F 03                 }..
        jmp     (L7273)                         ; 8D40 6C 73 72                 lsr

; ----------------------------------------------------------------------------
        .byte   $6B                             ; 8D43 6B                       k
        ror     a                               ; 8D44 6A                       j
        .byte   $62                             ; 8D45 62                       b
        adc     ($68,x)                         ; 8D46 61 68                    ah
        .byte   $67                             ; 8D48 67                       g
        .byte   $03                             ; 8D49 03                       .
        sei                                     ; 8D4A 78                       x
        .byte   $12                             ; 8D4B 12                       .
        brk                                     ; 8D4C 00                       .
        sta     $737D                           ; 8D4D 8D 7D 73                 .}s
        .byte   $02                             ; 8D50 02                       .
        .byte   $80                             ; 8D51 80                       .
        clc                                     ; 8D52 18                       .
        rti                                     ; 8D53 40                       @

; ----------------------------------------------------------------------------
        php                                     ; 8D54 08                       .
        .byte   $17                             ; 8D55 17                       .
        asl     $E6                             ; 8D56 06 E6                    ..
        .byte   $07                             ; 8D58 07                       .
        .byte   $0B                             ; 8D59 0B                       .
        .byte   $02                             ; 8D5A 02                       .
        .byte   $03                             ; 8D5B 03                       .
        sty     $0408                           ; 8D5C 8C 08 04                 ...
        .byte   $06                             ; 8D5F 06                       .
L8D60:  asl     a                               ; 8D60 0A                       .
        .byte   $02                             ; 8D61 02                       .
        ora     ($CB,x)                         ; 8D62 01 CB                    ..
        ora     ($6B,x)                         ; 8D64 01 6B                    .k
        clc                                     ; 8D66 18                       .
        cpy     #$08                            ; 8D67 C0 08                    ..
        asl     $0807                           ; 8D69 0E 07 08                 ...
        jmp     (L716B)                         ; 8D6C 6C 6B 71                 lkq

; ----------------------------------------------------------------------------
        adc     $67                             ; 8D6F 65 67                    eg
        .byte   $6B                             ; 8D71 6B                       k
        adc     ($65),y                         ; 8D72 71 65                    qe
        .byte   $67                             ; 8D74 67                       g
        .byte   $03                             ; 8D75 03                       .
        adc     ($72),y                         ; 8D76 71 72                    qr
        .byte   $73                             ; 8D78 73                       s
        asl     L8D01                           ; 8D79 0E 01 8D                 ...
        .byte   $1F                             ; 8D7C 1F                       .
        .byte   $80                             ; 8D7D 80                       .
        clc                                     ; 8D7E 18                       .
        rti                                     ; 8D7F 40                       @

; ----------------------------------------------------------------------------
L8D80:  php                                     ; 8D80 08                       .
        .byte   $02                             ; 8D81 02                       .
        asl     $E6                             ; 8D82 06 E6                    ..
L8D84:  .byte   $07                             ; 8D84 07                       .
        ora     #$7C                            ; 8D85 09 7C                    .|
        .byte   $7A                             ; 8D87 7A                       z
        .byte   $7C                             ; 8D88 7C                       |
        ror     $0260,x                         ; 8D89 7E 60 02                 ~`.
        ora     ($03,x)                         ; 8D8C 01 03                    ..
        sty     $1008                           ; 8D8E 8C 08 10                 ...
        .byte   $02                             ; 8D91 02                       .
        .byte   $01                             ; 8D92 01                       .
L8D93:  ldy     a:$04                           ; 8D93 AC 04 00                 ...
        .byte   $04                             ; 8D96 04                       .
L8D97:  brk                                     ; 8D97 00                       .
        php                                     ; 8D98 08                       .
        .byte   $02                             ; 8D99 02                       .
        asl     $F0                             ; 8D9A 06 F0                    ..
        .byte   $93                             ; 8D9C 93                       .
        adc     ($60),y                         ; 8D9D 71 60                    q`
        .byte   $73                             ; 8D9F 73                       s
        rts                                     ; 8DA0 60                       `

; ----------------------------------------------------------------------------
        ror     $60,x                           ; 8DA1 76 60                    v`
        txs                                     ; 8DA3 9A                       .
        rts                                     ; 8DA4 60                       `

; ----------------------------------------------------------------------------
        .byte   $7A                             ; 8DA5 7A                       z
        .byte   $80                             ; 8DA6 80                       .
        .byte   $02                             ; 8DA7 02                       .
        txs                                     ; 8DA8 9A                       .
        rts                                     ; 8DA9 60                       `

; ----------------------------------------------------------------------------
        sei                                     ; 8DAA 78                       x
        .byte   $02                             ; 8DAB 02                       .
        .byte   $80                             ; 8DAC 80                       .
        lda     ($06),y                         ; 8DAD B1 06                    ..
        .byte   $64                             ; 8DAF 64                       d
        .byte   $93                             ; 8DB0 93                       .
        stx     $9A,y                           ; 8DB1 96 9A                    ..
        asl     $F0                             ; 8DB3 06 F0                    ..
        .byte   $02                             ; 8DB5 02                       .
        sta     L9C02,x                         ; 8DB6 9D 02 9C                 ...
        tya                                     ; 8DB9 98                       .
        .byte   $02                             ; 8DBA 02                       .
        .byte   $9C                             ; 8DBB 9C                       .
        .byte   $02                             ; 8DBC 02                       .
        sta     $019F,x                         ; 8DBD 9D 9F 01                 ...
        clv                                     ; 8DC0 B8                       .
        php                                     ; 8DC1 08                       .
        .byte   $0B                             ; 8DC2 0B                       .
        .byte   $02                             ; 8DC3 02                       .
        ora     ($D8,x)                         ; 8DC4 01 D8                    ..
        .byte   $80                             ; 8DC6 80                       .
        php                                     ; 8DC7 08                       .
        .byte   $02                             ; 8DC8 02                       .
        sta     ($73),y                         ; 8DC9 91 73                    .s
        rts                                     ; 8DCB 60                       `

; ----------------------------------------------------------------------------
        txs                                     ; 8DCC 9A                       .
        .byte   $80                             ; 8DCD 80                       .
        .byte   $02                             ; 8DCE 02                       .
        txs                                     ; 8DCF 9A                       .
        rts                                     ; 8DD0 60                       `

; ----------------------------------------------------------------------------
        tsx                                     ; 8DD1 BA                       .
        .byte   $BB                             ; 8DD2 BB                       .
        tsx                                     ; 8DD3 BA                       .
        .byte   $BB                             ; 8DD4 BB                       .
        txs                                     ; 8DD5 9A                       .
        .byte   $02                             ; 8DD6 02                       .
        lda     $77D5,y                         ; 8DD7 B9 D5 77                 ..w
        adc     $BA01,y                         ; 8DDA 79 01 BA                 y..
        php                                     ; 8DDD 08                       .
        .byte   $0B                             ; 8DDE 0B                       .
        .byte   $02                             ; 8DDF 02                       .
        ora     ($DA,x)                         ; 8DE0 01 DA                    ..
        asl     L8D01                           ; 8DE2 0E 01 8D                 ...
        stx     $04,y                           ; 8DE5 96 04                    ..
        pha                                     ; 8DE7 48                       H
        php                                     ; 8DE8 08                       .
        .byte   $02                             ; 8DE9 02                       .
        asl     $FF                             ; 8DEA 06 FF                    ..
        .byte   $07                             ; 8DEC 07                       .
        ora     $89                             ; 8DED 05 89                    ..
        php                                     ; 8DEF 08                       .
        clc                                     ; 8DF0 18                       .
        .byte   $07                             ; 8DF1 07                       .
        .byte   $07                             ; 8DF2 07                       .
        adc     #$07                            ; 8DF3 69 07                    i.
        ora     #$69                            ; 8DF5 09 69                    .i
        .byte   $07                             ; 8DF7 07                       .
        asl     a                               ; 8DF8 0A                       .
        .byte   $89                             ; 8DF9 89                       .
        .byte   $07                             ; 8DFA 07                       .
        .byte   $0B                             ; 8DFB 0B                       .
        .byte   $02                             ; 8DFC 02                       .
        lda     #$01                            ; 8DFD A9 01                    ..
        adc     #$60                            ; 8DFF 69 60                    i`
L8E01:  php                                     ; 8E01 08                       .
        .byte   $02                             ; 8E02 02                       .
        .byte   $07                             ; 8E03 07                       .
        php                                     ; 8E04 08                       .
        .byte   $67                             ; 8E05 67                       g
        .byte   $02                             ; 8E06 02                       .
        ora     ($89,x)                         ; 8E07 01 89                    ..
        .byte   $07                             ; 8E09 07                       .
        ora     #$69                            ; 8E0A 09 69                    .i
        .byte   $07                             ; 8E0C 07                       .
        asl     a                               ; 8E0D 0A                       .
        cmp     #$01                            ; 8E0E C9 01                    ..
        .byte   $89                             ; 8E10 89                       .
        rts                                     ; 8E11 60                       `

; ----------------------------------------------------------------------------
        .byte   $07                             ; 8E12 07                       .
        php                                     ; 8E13 08                       .
        .byte   $67                             ; 8E14 67                       g
        ora     ($69,x)                         ; 8E15 01 69                    .i
        ora     ($A9,x)                         ; 8E17 01 A9                    ..
        .byte   $87                             ; 8E19 87                       .
        .byte   $89                             ; 8E1A 89                       .
        .byte   $80                             ; 8E1B 80                       .
        .byte   $89                             ; 8E1C 89                       .
        .byte   $80                             ; 8E1D 80                       .
        lda     #$8E                            ; 8E1E A9 8E                    ..
        bcc     L8E23                           ; 8E20 90 01                    ..
        .byte   $C9                             ; 8E22 C9                       .
L8E23:  ora     ($89,x)                         ; 8E23 01 89                    ..
        .byte   $80                             ; 8E25 80                       .
        .byte   $03                             ; 8E26 03                       .
        .byte   $93                             ; 8E27 93                       .
        tya                                     ; 8E28 98                       .
        .byte   $BF                             ; 8E29 BF                       .
        lda     L9A98,x                         ; 8E2A BD 98 9A                 ...
        .byte   $9B                             ; 8E2D 9B                       .
        .byte   $80                             ; 8E2E 80                       .
        .byte   $02                             ; 8E2F 02                       .
        lda     $02BF,x                         ; 8E30 BD BF 02                 ...
        .byte   $03                             ; 8E33 03                       .
        cmp     #$A7                            ; 8E34 C9 A7                    ..
        .byte   $12                             ; 8E36 12                       .
        php                                     ; 8E37 08                       .
        stx     $A444                           ; 8E38 8E 44 A4                 .D.
        ldx     $A7                             ; 8E3B A6 A7                    ..
        .byte   $02                             ; 8E3D 02                       .
        .byte   $89                             ; 8E3E 89                       .
        rts                                     ; 8E3F 60                       `

; ----------------------------------------------------------------------------
        asl     L8D01                           ; 8E40 0E 01 8D                 ...
        inc     $A4                             ; 8E43 E6 A4                    ..
        lda     #$AB                            ; 8E45 A9 AB                    ..
        .byte   $02                             ; 8E47 02                       .
        sta     L606E                           ; 8E48 8D 6E 60                 .n`
        asl     $E6                             ; 8E4B 06 E6                    ..
        .byte   $03                             ; 8E4D 03                       .
        jmp     (L6C80)                         ; 8E4E 6C 80 6C                 l.l

; ----------------------------------------------------------------------------
        rts                                     ; 8E51 60                       `

; ----------------------------------------------------------------------------
        clc                                     ; 8E52 18                       .
        brk                                     ; 8E53 00                       .
        .byte   $03                             ; 8E54 03                       .
        ror     $696C                           ; 8E55 6E 6C 69                 nli
        .byte   $87                             ; 8E58 87                       .
        dey                                     ; 8E59 88                       .
        .byte   $89                             ; 8E5A 89                       .
        .byte   $03                             ; 8E5B 03                       .
        sei                                     ; 8E5C 78                       x
        .byte   $9F                             ; 8E5D 9F                       .
        adc     L8803,x                         ; 8E5E 7D 03 88                 }..
        .byte   $87                             ; 8E61 87                       .
        .byte   $03                             ; 8E62 03                       .
        tya                                     ; 8E63 98                       .
        txs                                     ; 8E64 9A                       .
        adc     L9802,x                         ; 8E65 7D 02 98                 }..
        clc                                     ; 8E68 18                       .
        rti                                     ; 8E69 40                       @

; ----------------------------------------------------------------------------
        jmp     (L6C60)                         ; 8E6A 6C 60 6C                 l`l

; ----------------------------------------------------------------------------
        .byte   $80                             ; 8E6D 80                       .
        jmp     (L1860)                         ; 8E6E 6C 60 18                 l`.

; ----------------------------------------------------------------------------
        brk                                     ; 8E71 00                       .
        sei                                     ; 8E72 78                       x
        .byte   $7A                             ; 8E73 7A                       z
        adc     $019F,x                         ; 8E74 7D 9F 01                 }..
        sta     $0100,x                         ; 8E77 9D 00 01                 ...
        eor     L8A03,x                         ; 8E7A 5D 03 8A                 ]..
        dey                                     ; 8E7D 88                       .
        asl     $64                             ; 8E7E 06 64                    .d
        .byte   $89                             ; 8E80 89                       .
        sty     $83                             ; 8E81 84 83                    ..
        .byte   $82                             ; 8E83 82                       .
        .byte   $8F                             ; 8E84 8F                       .
        dey                                     ; 8E85 88                       .
        .byte   $87                             ; 8E86 87                       .
L8E87:  sta     $0686                           ; 8E87 8D 86 06                 ...
        inc     $02                             ; 8E8A E6 02                    ..
        brk                                     ; 8E8C 00                       .
        sta     L0018                           ; 8E8D 85 18                    ..
        cpy     #$07                            ; 8E8F C0 07                    ..
        .byte   $0B                             ; 8E91 0B                       .
        .byte   $03                             ; 8E92 03                       .
        jmp     (L6C60)                         ; 8E93 6C 60 6C                 l`l

; ----------------------------------------------------------------------------
        .byte   $80                             ; 8E96 80                       .
        jmp     (L0018)                         ; 8E97 6C 18 00                 l..

; ----------------------------------------------------------------------------
        asl     $64                             ; 8E9A 06 64                    .d
        .byte   $7F                             ; 8E9C 7F                       .
        .byte   $03                             ; 8E9D 03                       .
        .byte   $73                             ; 8E9E 73                       s
        .byte   $73                             ; 8E9F 73                       s
        rts                                     ; 8EA0 60                       `

; ----------------------------------------------------------------------------
        .byte   $72                             ; 8EA1 72                       r
        ror     $66                             ; 8EA2 66 66                    ff
        rts                                     ; 8EA4 60                       `

; ----------------------------------------------------------------------------
        adc     $70                             ; 8EA5 65 70                    ep
        .byte   $63                             ; 8EA7 63                       c
        brk                                     ; 8EA8 00                       .
        .byte   $82                             ; 8EA9 82                       .
        stx     L8182                           ; 8EAA 8E 82 81                 ...
        .byte   $03                             ; 8EAD 03                       .
        tya                                     ; 8EAE 98                       .
        .byte   $03                             ; 8EAF 03                       .
        .byte   $8B                             ; 8EB0 8B                       .
        .byte   $03                             ; 8EB1 03                       .
        stx     $03,y                           ; 8EB2 96 03                    ..
        .byte   $89                             ; 8EB4 89                       .
        .byte   $03                             ; 8EB5 03                       .
        sty     L0000,x                         ; 8EB6 94 00                    ..
        .byte   $03                             ; 8EB8 03                       .
        pla                                     ; 8EB9 68                       h
        .byte   $63                             ; 8EBA 63                       c
        .byte   $62                             ; 8EBB 62                       b
        .byte   $03                             ; 8EBC 03                       .
        .byte   $73                             ; 8EBD 73                       s
        .byte   $80                             ; 8EBE 80                       .
        asl     $E6                             ; 8EBF 06 E6                    ..
        adc     $7A,x                           ; 8EC1 75 7A                    uz
        .byte   $72                             ; 8EC3 72                       r
        adc     $7A,x                           ; 8EC4 75 7A                    uz
        ror     $6903,x                         ; 8EC6 7E 03 69                 ~.i
        ror     $62                             ; 8EC9 66 62                    fb
        .byte   $03                             ; 8ECB 03                       .
        sei                                     ; 8ECC 78                       x
        .byte   $7A                             ; 8ECD 7A                       z
        ror     $6903,x                         ; 8ECE 7E 03 69                 ~.i
        jmp     (L6766)                         ; 8ED1 6C 66 67                 lfg

; ----------------------------------------------------------------------------
        adc     #$6E                            ; 8ED4 69 6E                    in
        .byte   $6F                             ; 8ED6 6F                       o
        ror     $0166                           ; 8ED7 6E 66 01                 nf.
        lda     ($08),y                         ; 8EDA B1 08                    ..
        .byte   $0B                             ; 8EDC 0B                       .
        lda     ($01),y                         ; 8EDD B1 01                    ..
        adc     (L0018),y                       ; 8EDF 71 18                    q.
        rti                                     ; 8EE1 40                       @

; ----------------------------------------------------------------------------
        .byte   $07                             ; 8EE2 07                       .
        ora     #$16                            ; 8EE3 09 16                    ..
        sta     $1794                           ; 8EE5 8D 94 17                 ...
        .byte   $04                             ; 8EE8 04                       .
        brk                                     ; 8EE9 00                       .
        ldy     #$07                            ; 8EEA A0 07                    ..
        asl     a                               ; 8EEC 0A                       .
        ora     #$02                            ; 8EED 09 02                    ..
        .byte   $0C                             ; 8EEF 0C                       .
        .byte   $FF                             ; 8EF0 FF                       .
        clc                                     ; 8EF1 18                       .
        rti                                     ; 8EF2 40                       @

; ----------------------------------------------------------------------------
        php                                     ; 8EF3 08                       .
        .byte   $17                             ; 8EF4 17                       .
        asl     $E6                             ; 8EF5 06 E6                    ..
        .byte   $02                             ; 8EF7 02                       .
        txs                                     ; 8EF8 9A                       .
        php                                     ; 8EF9 08                       .
        .byte   $04                             ; 8EFA 04                       .
        asl     $0A                             ; 8EFB 06 0A                    ..
        .byte   $02                             ; 8EFD 02                       .
        ora     ($D8,x)                         ; 8EFE 01 D8                    ..
        .byte   $01                             ; 8F00 01                       .
L8F01:  sei                                     ; 8F01 78                       x
L8F02:  rts                                     ; 8F02 60                       `

; ----------------------------------------------------------------------------
        clc                                     ; 8F03 18                       .
        cpy     #$07                            ; 8F04 C0 07                    ..
        .byte   $04                             ; 8F06 04                       .
        ora     #$03                            ; 8F07 09 03                    ..
        adc     $037F,x                         ; 8F09 7D 7F 03                 }..
        jmp     (L7273)                         ; 8F0C 6C 73 72                 lsr

; ----------------------------------------------------------------------------
        .byte   $6B                             ; 8F0F 6B                       k
        ror     a                               ; 8F10 6A                       j
        .byte   $62                             ; 8F11 62                       b
        adc     ($68,x)                         ; 8F12 61 68                    ah
        .byte   $67                             ; 8F14 67                       g
        .byte   $12                             ; 8F15 12                       .
        php                                     ; 8F16 08                       .
        .byte   $8F                             ; 8F17 8F                       .
        eor     #$03                            ; 8F18 49 03                    I.
        sei                                     ; 8F1A 78                       x
        .byte   $73                             ; 8F1B 73                       s
        .byte   $80                             ; 8F1C 80                       .
        clc                                     ; 8F1D 18                       .
        rti                                     ; 8F1E 40                       @

; ----------------------------------------------------------------------------
        .byte   $07                             ; 8F1F 07                       .
        ora     #$08                            ; 8F20 09 08                    ..
        .byte   $17                             ; 8F22 17                       .
        asl     $E6                             ; 8F23 06 E6                    ..
        eor     ($01),y                         ; 8F25 51 01                    Q.
        .byte   $93                             ; 8F27 93                       .
        ora     ($53,x)                         ; 8F28 01 53                    .S
        php                                     ; 8F2A 08                       .
        .byte   $04                             ; 8F2B 04                       .
        asl     $0A                             ; 8F2C 06 0A                    ..
        .byte   $02                             ; 8F2E 02                       .
        ora     ($D1,x)                         ; 8F2F 01 D1                    ..
        ora     ($71,x)                         ; 8F31 01 71                    .q
        rts                                     ; 8F33 60                       `

; ----------------------------------------------------------------------------
        clc                                     ; 8F34 18                       .
        cpy     #$07                            ; 8F35 C0 07                    ..
        .byte   $04                             ; 8F37 04                       .
        .byte   $03                             ; 8F38 03                       .
        jmp     (L716B)                         ; 8F39 6C 6B 71                 lkq

; ----------------------------------------------------------------------------
        adc     $67                             ; 8F3C 65 67                    eg
        .byte   $6B                             ; 8F3E 6B                       k
        adc     ($65),y                         ; 8F3F 71 65                    qe
        .byte   $67                             ; 8F41 67                       g
        .byte   $03                             ; 8F42 03                       .
        adc     ($72),y                         ; 8F43 71 72                    qr
        asl     L8E01                           ; 8F45 0E 01 8E                 ...
        inx                                     ; 8F48 E8                       .
        .byte   $80                             ; 8F49 80                       .
        ora     #$02                            ; 8F4A 09 02                    ..
        .byte   $07                             ; 8F4C 07                       .
        ora     #$06                            ; 8F4D 09 06                    ..
        inc     $03                             ; 8F4F E6 03                    ..
        sei                                     ; 8F51 78                       x
        .byte   $77                             ; 8F52 77                       w
        sei                                     ; 8F53 78                       x
        .byte   $7A                             ; 8F54 7A                       z
        rts                                     ; 8F55 60                       `

; ----------------------------------------------------------------------------
        .byte   $02                             ; 8F56 02                       .
        ora     ($9D,x)                         ; 8F57 01 9D                    ..
        php                                     ; 8F59 08                       .
        bpl     L8F5E                           ; 8F5A 10 02                    ..
        ora     ($BD,x)                         ; 8F5C 01 BD                    ..
L8F5E:  .byte   $04                             ; 8F5E 04                       .
        brk                                     ; 8F5F 00                       .
        .byte   $04                             ; 8F60 04                       .
        brk                                     ; 8F61 00                       .
        .byte   $04                             ; 8F62 04                       .
        brk                                     ; 8F63 00                       .
        ora     #$02                            ; 8F64 09 02                    ..
        php                                     ; 8F66 08                       .
        ora     ($07),y                         ; 8F67 11 07                    ..
        php                                     ; 8F69 08                       .
        asl     $3C                             ; 8F6A 06 3C                    .<
        clc                                     ; 8F6C 18                       .
        .byte   $80                             ; 8F6D 80                       .
        .byte   $7F                             ; 8F6E 7F                       .
        .byte   $7F                             ; 8F6F 7F                       .
        .byte   $73                             ; 8F70 73                       s
        rts                                     ; 8F71 60                       `

; ----------------------------------------------------------------------------
        .byte   $73                             ; 8F72 73                       s
L8F73:  rts                                     ; 8F73 60                       `

; ----------------------------------------------------------------------------
        .byte   $7F                             ; 8F74 7F                       .
        .byte   $7F                             ; 8F75 7F                       .
        rts                                     ; 8F76 60                       `

; ----------------------------------------------------------------------------
        .byte   $73                             ; 8F77 73                       s
        .byte   $7F                             ; 8F78 7F                       .
        .byte   $02                             ; 8F79 02                       .
        .byte   $80                             ; 8F7A 80                       .
        .byte   $73                             ; 8F7B 73                       s
        .byte   $7F                             ; 8F7C 7F                       .
        .byte   $12                             ; 8F7D 12                       .
        brk                                     ; 8F7E 00                       .
        .byte   $8F                             ; 8F7F 8F                       .
        bcs     L8F85                           ; 8F80 B0 03                    ..
        adc     #$69                            ; 8F82 69 69                    ii
        .byte   $03                             ; 8F84 03                       .
L8F85:  adc     $60,x                           ; 8F85 75 60                    u`
        adc     $60,x                           ; 8F87 75 60                    u`
        .byte   $03                             ; 8F89 03                       .
        adc     #$69                            ; 8F8A 69 69                    ii
        rts                                     ; 8F8C 60                       `

; ----------------------------------------------------------------------------
        .byte   $03                             ; 8F8D 03                       .
        adc     $7A,x                           ; 8F8E 75 7A                    uz
        .byte   $03                             ; 8F90 03                       .
        adc     #$80                            ; 8F91 69 80                    i.
        .byte   $03                             ; 8F93 03                       .
        adc     $03,x                           ; 8F94 75 03                    u.
        adc     #$6A                            ; 8F96 69 6A                    ij
        ror     a                               ; 8F98 6A                       j
        .byte   $03                             ; 8F99 03                       .
        ror     $60,x                           ; 8F9A 76 60                    v`
        ror     $60,x                           ; 8F9C 76 60                    v`
        .byte   $03                             ; 8F9E 03                       .
        ror     a                               ; 8F9F 6A                       j
        ror     a                               ; 8FA0 6A                       j
        rts                                     ; 8FA1 60                       `

; ----------------------------------------------------------------------------
        .byte   $03                             ; 8FA2 03                       .
        ror     $03,x                           ; 8FA3 76 03                    v.
        ror     a                               ; 8FA5 6A                       j
        .byte   $02                             ; 8FA6 02                       .
        .byte   $80                             ; 8FA7 80                       .
        .byte   $03                             ; 8FA8 03                       .
        ror     $03,x                           ; 8FA9 76 03                    v.
        ror     a                               ; 8FAB 6A                       j
        asl     L8F01                           ; 8FAC 0E 01 8F                 ...
        .byte   $62                             ; 8FAF 62                       b
        .byte   $7B                             ; 8FB0 7B                       {
        .byte   $7B                             ; 8FB1 7B                       {
        .byte   $6F                             ; 8FB2 6F                       o
        rts                                     ; 8FB3 60                       `

; ----------------------------------------------------------------------------
        .byte   $80                             ; 8FB4 80                       .
        asl     $FF                             ; 8FB5 06 FF                    ..
        php                                     ; 8FB7 08                       .
        .byte   $02                             ; 8FB8 02                       .
        .byte   $8F                             ; 8FB9 8F                       .
        .byte   $B3                             ; 8FBA B3                       .
        ldx     $02,y                           ; 8FBB B6 02                    ..
        clv                                     ; 8FBD B8                       .
        .byte   $02                             ; 8FBE 02                       .
        ldx     $B4,y                           ; 8FBF B6 B4                    ..
        .byte   $02                             ; 8FC1 02                       .
        .byte   $B3                             ; 8FC2 B3                       .
        bcs     L8F73                           ; 8FC3 B0 AE                    ..
        sta     a:$13                           ; 8FC5 8D 13 00                 ...
        .byte   $8F                             ; 8FC8 8F                       .
        dec     L606E,x                         ; 8FC9 DE 6E 60                 .n`
        clc                                     ; 8FCC 18                       .
        brk                                     ; 8FCD 00                       .
        .byte   $92                             ; 8FCE 92                       .
        tya                                     ; 8FCF 98                       .
        .byte   $3C                             ; 8FD0 3C                       <
        ora     ($9D,x)                         ; 8FD1 01 9D                    ..
        .byte   $02                             ; 8FD3 02                       .
        adc     $3D01,x                         ; 8FD4 7D 01 3D                 }.=
        .byte   $9B                             ; 8FD7 9B                       .
        txs                                     ; 8FD8 9A                       .
        tya                                     ; 8FD9 98                       .
        .byte   $0F                             ; 8FDA 0F                       .
        ora     ($8F,x)                         ; 8FDB 01 8F                    ..
        rts                                     ; 8FDD 60                       `

; ----------------------------------------------------------------------------
        ldx     $B280                           ; 8FDE AE 80 B2                 ...
        .byte   $93                             ; 8FE1 93                       .
        sta     $9A,x                           ; 8FE2 95 9A                    ..
        .byte   $04                             ; 8FE4 04                       .
        brk                                     ; 8FE5 00                       .
        .byte   $04                             ; 8FE6 04                       .
        brk                                     ; 8FE7 00                       .
        .byte   $80                             ; 8FE8 80                       .
        php                                     ; 8FE9 08                       .
        .byte   $12                             ; 8FEA 12                       .
        .byte   $07                             ; 8FEB 07                       .
        ora     #$06                            ; 8FEC 09 06                    ..
        stx     $69,y                           ; 8FEE 96 69                    .i
        ror     a                               ; 8FF0 6A                       j
        .byte   $6F                             ; 8FF1 6F                       o
        ror     a                               ; 8FF2 6A                       j
        .byte   $6F                             ; 8FF3 6F                       o
        ror     $736F                           ; 8FF4 6E 6F 73                 nos
        adc     $76,x                           ; 8FF7 75 76                    uv
        .byte   $6F                             ; 8FF9 6F                       o
        adc     $76,x                           ; 8FFA 75 76                    uv
        .byte   $7B                             ; 8FFC 7B                       {
        .byte   $12                             ; 8FFD 12                       .
        brk                                     ; 8FFE 00                       .
        bcc     L9015                           ; 8FFF 90 14                    ..
        .byte   $80                             ; 9001 80                       .
        .byte   $67                             ; 9002 67                       g
        adc     #$6A                            ; 9003 69 6A                    ij
        .byte   $67                             ; 9005 67                       g
        ror     a                               ; 9006 6A                       j
        bvs     L9073                           ; 9007 70 6A                    pj
L9009:  bvs     L907E                           ; 9009 70 73                    ps
        adc     $70,x                           ; 900B 75 70                    up
        .byte   $73                             ; 900D 73                       s
        adc     $7C,x                           ; 900E 75 7C                    u|
        asl     L8F02                           ; 9010 0E 02 8F                 ...
        inc     $80                             ; 9013 E6 80                    ..
L9015:  .byte   $67                             ; 9015 67                       g
        pla                                     ; 9016 68                       h
        ror     a                               ; 9017 6A                       j
        pla                                     ; 9018 68                       h
        ror     a                               ; 9019 6A                       j
        .byte   $6F                             ; 901A 6F                       o
        ror     a                               ; 901B 6A                       j
        .byte   $6F                             ; 901C 6F                       o
        .byte   $73                             ; 901D 73                       s
        .byte   $74                             ; 901E 74                       t
        .byte   $6F                             ; 901F 6F                       o
        .byte   $74                             ; 9020 74                       t
        ror     $7B,x                           ; 9021 76 7B                    v{
        .byte   $80                             ; 9023 80                       .
        .byte   $64                             ; 9024 64                       d
        .byte   $67                             ; 9025 67                       g
        adc     #$67                            ; 9026 69 67                    ig
        adc     #$70                            ; 9028 69 70                    ip
        adc     #$70                            ; 902A 69 70                    ip
        .byte   $73                             ; 902C 73                       s
        adc     $70,x                           ; 902D 75 70                    up
        .byte   $73                             ; 902F 73                       s
        adc     $7C,x                           ; 9030 75 7C                    u|
        .byte   $13                             ; 9032 13                       .
        brk                                     ; 9033 00                       .
        bcc     L907F                           ; 9034 90 49                    .I
        .byte   $80                             ; 9036 80                       .
        .byte   $62                             ; 9037 62                       b
        ror     $69                             ; 9038 66 69                    fi
        ror     $69                             ; 903A 66 69                    fi
        ror     $6E69                           ; 903C 6E 69 6E                 nin
        bvs     L90B3                           ; 903F 70 72                    pr
        ror     $7572                           ; 9041 6E 72 75                 nru
        .byte   $7A                             ; 9044 7A                       z
        .byte   $0F                             ; 9045 0F                       .
        ora     ($8F,x)                         ; 9046 01 8F                    ..
        cpx     $80                             ; 9048 E4 80                    ..
        .byte   $64                             ; 904A 64                       d
        adc     #$6D                            ; 904B 69 6D                    im
        adc     #$6D                            ; 904D 69 6D                    im
        bvs     L90BA                           ; 904F 70 69                    pi
        adc     $7570                           ; 9051 6D 70 75                 mpu
        bvs     L90C9                           ; 9054 70 73                    ps
        adc     L0018,x                         ; 9056 75 18                    u.
        cpy     #$06                            ; 9058 C0 06                    ..
        inc     $08                             ; 905A E6 08                    ..
        .byte   $02                             ; 905C 02                       .
        .byte   $67                             ; 905D 67                       g
        rts                                     ; 905E 60                       `

; ----------------------------------------------------------------------------
        .byte   $67                             ; 905F 67                       g
        .byte   $80                             ; 9060 80                       .
        .byte   $67                             ; 9061 67                       g
        .byte   $02                             ; 9062 02                       .
        rts                                     ; 9063 60                       `

; ----------------------------------------------------------------------------
        ora     #$03                            ; 9064 09 03                    ..
        .byte   $07                             ; 9066 07                       .
        .byte   $04                             ; 9067 04                       .
        .byte   $03                             ; 9068 03                       .
        ror     $696C                           ; 9069 6E 6C 69                 nli
        .byte   $87                             ; 906C 87                       .
        dey                                     ; 906D 88                       .
        .byte   $89                             ; 906E 89                       .
        .byte   $03                             ; 906F 03                       .
        sei                                     ; 9070 78                       x
        .byte   $9F                             ; 9071 9F                       .
        .byte   $7D                             ; 9072 7D                       }
L9073:  .byte   $03                             ; 9073 03                       .
        dey                                     ; 9074 88                       .
        .byte   $87                             ; 9075 87                       .
        .byte   $03                             ; 9076 03                       .
        tya                                     ; 9077 98                       .
        txs                                     ; 9078 9A                       .
        adc     $4098,x                         ; 9079 7D 98 40                 }.@
        ora     #$02                            ; 907C 09 02                    ..
L907E:  .byte   $07                             ; 907E 07                       .
L907F:  ora     #$67                            ; 907F 09 67                    .g
        rts                                     ; 9081 60                       `

; ----------------------------------------------------------------------------
        .byte   $67                             ; 9082 67                       g
        .byte   $80                             ; 9083 80                       .
        .byte   $67                             ; 9084 67                       g
        .byte   $02                             ; 9085 02                       .
        rts                                     ; 9086 60                       `

; ----------------------------------------------------------------------------
        ora     #$03                            ; 9087 09 03                    ..
        .byte   $07                             ; 9089 07                       .
        .byte   $04                             ; 908A 04                       .
        sei                                     ; 908B 78                       x
        .byte   $7A                             ; 908C 7A                       z
        adc     $019F,x                         ; 908D 7D 9F 01                 }..
        sta     $0100,x                         ; 9090 9D 00 01                 ...
        eor     L8A03,x                         ; 9093 5D 03 8A                 ]..
        dey                                     ; 9096 88                       .
        asl     $64                             ; 9097 06 64                    .d
        .byte   $89                             ; 9099 89                       .
        sty     $83                             ; 909A 84 83                    ..
        .byte   $82                             ; 909C 82                       .
        .byte   $8F                             ; 909D 8F                       .
        dey                                     ; 909E 88                       .
        .byte   $87                             ; 909F 87                       .
        sta     $0686                           ; 90A0 8D 86 06                 ...
L90A3:  inc     L0000                           ; 90A3 E6 00                    ..
        sta     $40                             ; 90A5 85 40                    .@
        clc                                     ; 90A7 18                       .
        cpy     #$07                            ; 90A8 C0 07                    ..
        ora     #$09                            ; 90AA 09 09                    ..
        .byte   $02                             ; 90AC 02                       .
        .byte   $03                             ; 90AD 03                       .
        .byte   $67                             ; 90AE 67                       g
        rts                                     ; 90AF 60                       `

; ----------------------------------------------------------------------------
        .byte   $67                             ; 90B0 67                       g
        .byte   $80                             ; 90B1 80                       .
        .byte   $67                             ; 90B2 67                       g
L90B3:  rti                                     ; 90B3 40                       @

; ----------------------------------------------------------------------------
        ora     #$03                            ; 90B4 09 03                    ..
        .byte   $07                             ; 90B6 07                       .
        .byte   $03                             ; 90B7 03                       .
        clc                                     ; 90B8 18                       .
        brk                                     ; 90B9 00                       .
L90BA:  .byte   $7F                             ; 90BA 7F                       .
        .byte   $03                             ; 90BB 03                       .
        .byte   $73                             ; 90BC 73                       s
        .byte   $73                             ; 90BD 73                       s
        rts                                     ; 90BE 60                       `

; ----------------------------------------------------------------------------
        .byte   $72                             ; 90BF 72                       r
        ror     $66                             ; 90C0 66 66                    ff
        rts                                     ; 90C2 60                       `

; ----------------------------------------------------------------------------
        adc     $70                             ; 90C3 65 70                    ep
        .byte   $63                             ; 90C5 63                       c
        brk                                     ; 90C6 00                       .
        .byte   $82                             ; 90C7 82                       .
        .byte   $8E                             ; 90C8 8E                       .
L90C9:  .byte   $82                             ; 90C9 82                       .
        sta     ($03,x)                         ; 90CA 81 03                    ..
        tya                                     ; 90CC 98                       .
        .byte   $03                             ; 90CD 03                       .
        .byte   $8B                             ; 90CE 8B                       .
        .byte   $03                             ; 90CF 03                       .
        stx     $03,y                           ; 90D0 96 03                    ..
        .byte   $89                             ; 90D2 89                       .
        .byte   $03                             ; 90D3 03                       .
        sty     L0000,x                         ; 90D4 94 00                    ..
        .byte   $03                             ; 90D6 03                       .
        pla                                     ; 90D7 68                       h
        .byte   $63                             ; 90D8 63                       c
        .byte   $62                             ; 90D9 62                       b
        .byte   $03                             ; 90DA 03                       .
        .byte   $53                             ; 90DB 53                       S
        clc                                     ; 90DC 18                       .
        cpy     #$07                            ; 90DD C0 07                    ..
        php                                     ; 90DF 08                       .
        ora     #$02                            ; 90E0 09 02                    ..
        .byte   $E2                             ; 90E2 E2                       .
        ldx     $6095                           ; 90E3 AE 95 60                 ..`
        ora     ($B8,x)                         ; 90E6 01 B8                    ..
L90E8:  php                                     ; 90E8 08                       .
        bpl     L90A3                           ; 90E9 10 B8                    ..
        ora     ($78,x)                         ; 90EB 01 78                    .x
        asl     $8F,x                           ; 90ED 16 8F                    ..
        lsr     $0417,x                         ; 90EF 5E 17 04                 ^..
        brk                                     ; 90F2 00                       .
        asl     $E6                             ; 90F3 06 E6                    ..
        php                                     ; 90F5 08                       .
        brk                                     ; 90F6 00                       .
        ora     #$03                            ; 90F7 09 03                    ..
        .byte   $67                             ; 90F9 67                       g
        .byte   $67                             ; 90FA 67                       g
        .byte   $67                             ; 90FB 67                       g
        .byte   $02                             ; 90FC 02                       .
        .byte   $80                             ; 90FD 80                       .
        ldy     #$67                            ; 90FE A0 67                    .g
        .byte   $6C                             ; 9100 6C                       l
        .byte   $6E                             ; 9101 6E                       n
L9102:  jmp     (L716E)                         ; 9102 6C 6E 71                 lnq

; ----------------------------------------------------------------------------
        .byte   $67                             ; 9105 67                       g
        rts                                     ; 9106 60                       `

; ----------------------------------------------------------------------------
        .byte   $67                             ; 9107 67                       g
        rts                                     ; 9108 60                       `

; ----------------------------------------------------------------------------
        .byte   $02                             ; 9109 02                       .
        ldy     #$65                            ; 910A A0 65                    .e
        ora     ($4D,x)                         ; 910C 01 4D                    .M
        ora     $027F                           ; 910E 0D 7F 02                 ...
        ora     ($6E,x)                         ; 9111 01 6E                    .n
        ora     $6D00                           ; 9113 0D 00 6D                 ..m
        ror     a                               ; 9116 6A                       j
        adc     $12                             ; 9117 65 12                    e.
        brk                                     ; 9119 00                       .
        sta     ($38),y                         ; 911A 91 38                    .8
        .byte   $67                             ; 911C 67                       g
        .byte   $67                             ; 911D 67                       g
        .byte   $67                             ; 911E 67                       g
        .byte   $02                             ; 911F 02                       .
        .byte   $80                             ; 9120 80                       .
        ldy     #$67                            ; 9121 A0 67                    .g
        jmp     (L6C6E)                         ; 9123 6C 6E 6C                 lnl

; ----------------------------------------------------------------------------
        ror     $6771                           ; 9126 6E 71 67                 nqg
        rts                                     ; 9129 60                       `

; ----------------------------------------------------------------------------
        .byte   $67                             ; 912A 67                       g
        rts                                     ; 912B 60                       `

; ----------------------------------------------------------------------------
        .byte   $02                             ; 912C 02                       .
        ldy     #$65                            ; 912D A0 65                    .e
        .byte   $67                             ; 912F 67                       g
        jmp     (L716E)                         ; 9130 6C 6E 71                 lnq

; ----------------------------------------------------------------------------
        ror     $0E,x                           ; 9133 76 0E                    v.
        ora     ($90,x)                         ; 9135 01 90                    ..
        sbc     ($8C),y                         ; 9137 F1 8C                    ..
        ldy     #$02                            ; 9139 A0 02                    ..
        ora     ($AE,x)                         ; 913B 01 AE                    ..
        ora     ($6E,x)                         ; 913D 01 6E                    .n
        php                                     ; 913F 08                       .
        ora     $79,x                           ; 9140 15 79                    .y
        .byte   $74                             ; 9142 74                       t
        bvs     L9149                           ; 9143 70 04                    p.
        brk                                     ; 9145 00                       .
        .byte   $04                             ; 9146 04                       .
        brk                                     ; 9147 00                       .
        .byte   $04                             ; 9148 04                       .
L9149:  brk                                     ; 9149 00                       .
        php                                     ; 914A 08                       .
        brk                                     ; 914B 00                       .
        asl     $6E                             ; 914C 06 6E                    .n
        .byte   $87                             ; 914E 87                       .
        sta     $06                             ; 914F 85 06                    ..
        .byte   $FA                             ; 9151 FA                       .
        .byte   $87                             ; 9152 87                       .
        rts                                     ; 9153 60                       `

; ----------------------------------------------------------------------------
        .byte   $87                             ; 9154 87                       .
        adc     #$02                            ; 9155 69 02                    i.
        ror     a                               ; 9157 6A                       j
        rti                                     ; 9158 40                       @

; ----------------------------------------------------------------------------
        asl     $6E                             ; 9159 06 6E                    .n
        stx     $0E87                           ; 915B 8E 87 0E                 ...
        ora     ($91,x)                         ; 915E 01 91                    ..
        pha                                     ; 9160 48                       H
        .byte   $04                             ; 9161 04                       .
        brk                                     ; 9162 00                       .
        sty     $068A                           ; 9163 8C 8A 06                 ...
        .byte   $FA                             ; 9166 FA                       .
        sty     L8C60                           ; 9167 8C 60 8C                 .`.
        bvs     L916E                           ; 916A 70 02                    p.
        adc     ($40),y                         ; 916C 71 40                    q@
L916E:  asl     $6E                             ; 916E 06 6E                    .n
        .byte   $93                             ; 9170 93                       .
        sty     $010E                           ; 9171 8C 0E 01                 ...
        sta     ($61),y                         ; 9174 91 61                    .a
        .byte   $83                             ; 9176 83                       .
        .byte   $82                             ; 9177 82                       .
        asl     $FA                             ; 9178 06 FA                    ..
        .byte   $83                             ; 917A 83                       .
        rts                                     ; 917B 60                       `

; ----------------------------------------------------------------------------
        .byte   $83                             ; 917C 83                       .
        adc     $02                             ; 917D 65 02                    e.
        .byte   $67                             ; 917F 67                       g
        rti                                     ; 9180 40                       @

; ----------------------------------------------------------------------------
        asl     $6E                             ; 9181 06 6E                    .n
        txa                                     ; 9183 8A                       .
        .byte   $8F                             ; 9184 8F                       .
        dey                                     ; 9185 88                       .
        .byte   $87                             ; 9186 87                       .
        asl     $FA                             ; 9187 06 FA                    ..
        dey                                     ; 9189 88                       .
        rts                                     ; 918A 60                       `

; ----------------------------------------------------------------------------
        dey                                     ; 918B 88                       .
        .byte   $67                             ; 918C 67                       g
        .byte   $02                             ; 918D 02                       .
        pla                                     ; 918E 68                       h
        rti                                     ; 918F 40                       @

; ----------------------------------------------------------------------------
        asl     $6E                             ; 9190 06 6E                    .n
        dey                                     ; 9192 88                       .
        sta     L8789                           ; 9193 8D 89 87                 ...
        asl     $FA                             ; 9196 06 FA                    ..
        .byte   $89                             ; 9198 89                       .
        rts                                     ; 9199 60                       `

; ----------------------------------------------------------------------------
        .byte   $89                             ; 919A 89                       .
        .byte   $67                             ; 919B 67                       g
        .byte   $02                             ; 919C 02                       .
        adc     #$40                            ; 919D 69 40                    i@
        asl     $78                             ; 919F 06 78                    .x
        sta     ($8D,x)                         ; 91A1 81 8D                    ..
        asl     $E6                             ; 91A3 06 E6                    ..
        ldx     #$02                            ; 91A5 A2 02                    ..
        sty     $86                             ; 91A7 84 86                    ..
        adc     #$8E                            ; 91A9 69 8E                    i.
        .byte   $62                             ; 91AB 62                       b
        rts                                     ; 91AC 60                       `

; ----------------------------------------------------------------------------
        ror     $0F60                           ; 91AD 6E 60 0F                 n`.
        ora     ($91,x)                         ; 91B0 01 91                    ..
        lsr     $04                             ; 91B2 46 04                    F.
        brk                                     ; 91B4 00                       .
        asl     $F5                             ; 91B5 06 F5                    ..
        .byte   $04                             ; 91B7 04                       .
        brk                                     ; 91B8 00                       .
        .byte   $A3                             ; 91B9 A3                       .
        .byte   $80                             ; 91BA 80                       .
        .byte   $C3                             ; 91BB C3                       .
        rts                                     ; 91BC 60                       `

; ----------------------------------------------------------------------------
        .byte   $6F                             ; 91BD 6F                       o
        .byte   $12                             ; 91BE 12                       .
        brk                                     ; 91BF 00                       .
        sta     ($D0),y                         ; 91C0 91 D0                    ..
        ldy     $80                             ; 91C2 A4 80                    ..
        sty     $60                             ; 91C4 84 60                    .`
        ror     $6490                           ; 91C6 6E 90 64                 n.d
        rts                                     ; 91C9 60                       `

; ----------------------------------------------------------------------------
        bvs     L922C                           ; 91CA 70 60                    p`
        asl     L9102                           ; 91CC 0E 02 91                 ...
        .byte   $B7                             ; 91CF B7                       .
        tay                                     ; 91D0 A8                       .
        .byte   $80                             ; 91D1 80                       .
        iny                                     ; 91D2 C8                       .
        rts                                     ; 91D3 60                       `

; ----------------------------------------------------------------------------
        .byte   $6F                             ; 91D4 6F                       o
        lda     #$80                            ; 91D5 A9 80                    ..
        cmp     #$60                            ; 91D7 C9 60                    .`
        ror     a:$13                           ; 91D9 6E 13 00                 n..
        sta     ($EC),y                         ; 91DC 91 EC                    ..
        ldx     #$80                            ; 91DE A2 80                    ..
        .byte   $82                             ; 91E0 82                       .
        rts                                     ; 91E1 60                       `

; ----------------------------------------------------------------------------
        jmp     (L628E)                         ; 91E2 6C 8E 62                 l.b

; ----------------------------------------------------------------------------
        rts                                     ; 91E5 60                       `

; ----------------------------------------------------------------------------
        ror     $0F60                           ; 91E6 6E 60 0F                 n`.
        ora     ($91,x)                         ; 91E9 01 91                    ..
        .byte   $B3                             ; 91EB B3                       .
        lda     #$80                            ; 91EC A9 80                    ..
        .byte   $89                             ; 91EE 89                       .
        rts                                     ; 91EF 60                       `

; ----------------------------------------------------------------------------
        .byte   $73                             ; 91F0 73                       s
        sta     $69,x                           ; 91F1 95 69                    .i
        rts                                     ; 91F3 60                       `

; ----------------------------------------------------------------------------
        adc     $62,x                           ; 91F4 75 62                    ub
        .byte   $04                             ; 91F6 04                       .
        brk                                     ; 91F7 00                       .
        rts                                     ; 91F8 60                       `

; ----------------------------------------------------------------------------
        ora     #$02                            ; 91F9 09 02                    ..
        ror     $7A60                           ; 91FB 6E 60 7A                 n`z
        ror     $7880                           ; 91FE 6E 80 78                 n.x
L9201:  rts                                     ; 9201 60                       `

; ----------------------------------------------------------------------------
        .byte   $7A                             ; 9202 7A                       z
L9203:  ror     $7360                           ; 9203 6E 60 73                 n`s
        adc     $78,x                           ; 9206 75 78                    ux
        ror     $6E60                           ; 9208 6E 60 6E                 n`n
        rts                                     ; 920B 60                       `

; ----------------------------------------------------------------------------
        ror     $7A78                           ; 920C 6E 78 7A                 nxz
L920F:  jmp     (L606E)                         ; 920F 6C 6E 60                 ln`

; ----------------------------------------------------------------------------
        .byte   $7A                             ; 9212 7A                       z
        ror     $7360                           ; 9213 6E 60 73                 n`s
        adc     $78,x                           ; 9216 75 78                    ux
        ror     $030E                           ; 9218 6E 0E 03                 n..
        sta     ($F6),y                         ; 921B 91 F6                    ..
        ora     #$03                            ; 921D 09 03                    ..
        asl     $91,x                           ; 921F 16 91                    ..
        .byte   $44                             ; 9221 44                       D
        .byte   $17                             ; 9222 17                       .
        .byte   $04                             ; 9223 04                       .
        brk                                     ; 9224 00                       .
        php                                     ; 9225 08                       .
        .byte   $14                             ; 9226 14                       .
        ora     #$00                            ; 9227 09 00                    ..
        asl     $D2                             ; 9229 06 D2                    ..
        .byte   $07                             ; 922B 07                       .
L922C:  asl     a                               ; 922C 0A                       .
        .byte   $63                             ; 922D 63                       c
        .byte   $63                             ; 922E 63                       c
        .byte   $02                             ; 922F 02                       .
        .byte   $83                             ; 9230 83                       .
        .byte   $07                             ; 9231 07                       .
        php                                     ; 9232 08                       .
        .byte   $6F                             ; 9233 6F                       o
        .byte   $6F                             ; 9234 6F                       o
        .byte   $6F                             ; 9235 6F                       o
        .byte   $6F                             ; 9236 6F                       o
        .byte   $6F                             ; 9237 6F                       o
        .byte   $02                             ; 9238 02                       .
        .byte   $8F                             ; 9239 8F                       .
        .byte   $6F                             ; 923A 6F                       o
        .byte   $07                             ; 923B 07                       .
        asl     a                               ; 923C 0A                       .
        .byte   $63                             ; 923D 63                       c
        .byte   $63                             ; 923E 63                       c
        .byte   $63                             ; 923F 63                       c
        .byte   $07                             ; 9240 07                       .
        php                                     ; 9241 08                       .
        .byte   $6F                             ; 9242 6F                       o
        .byte   $63                             ; 9243 63                       c
        .byte   $8F                             ; 9244 8F                       .
        .byte   $6F                             ; 9245 6F                       o
        .byte   $6F                             ; 9246 6F                       o
        .byte   $6F                             ; 9247 6F                       o
        .byte   $6F                             ; 9248 6F                       o
        .byte   $6F                             ; 9249 6F                       o
        .byte   $AF                             ; 924A AF                       .
        pla                                     ; 924B 68                       h
        pla                                     ; 924C 68                       h
        asl     L9201                           ; 924D 0E 01 92                 ...
        .byte   $23                             ; 9250 23                       #
        pla                                     ; 9251 68                       h
        .byte   $04                             ; 9252 04                       .
        brk                                     ; 9253 00                       .
        .byte   $07                             ; 9254 07                       .
        php                                     ; 9255 08                       .
        .byte   $6F                             ; 9256 6F                       o
        .byte   $8F                             ; 9257 8F                       .
        .byte   $07                             ; 9258 07                       .
        asl     a                               ; 9259 0A                       .
        sta     $07                             ; 925A 85 07                    ..
        php                                     ; 925C 08                       .
        .byte   $6F                             ; 925D 6F                       o
        .byte   $8F                             ; 925E 8F                       .
        .byte   $6F                             ; 925F 6F                       o
        .byte   $8F                             ; 9260 8F                       .
        .byte   $07                             ; 9261 07                       .
        asl     a                               ; 9262 0A                       .
        sta     $6F                             ; 9263 85 6F                    .o
        .byte   $6F                             ; 9265 6F                       o
        .byte   $12                             ; 9266 12                       .
        brk                                     ; 9267 00                       .
        .byte   $92                             ; 9268 92                       .
        .byte   $6F                             ; 9269 6F                       o
        rts                                     ; 926A 60                       `

; ----------------------------------------------------------------------------
        asl     L9201                           ; 926B 0E 01 92                 ...
        .byte   $52                             ; 926E 52                       R
        .byte   $02                             ; 926F 02                       .
        .byte   $83                             ; 9270 83                       .
        pla                                     ; 9271 68                       h
        dey                                     ; 9272 88                       .
        tay                                     ; 9273 A8                       .
        .byte   $63                             ; 9274 63                       c
        .byte   $6F                             ; 9275 6F                       o
        .byte   $6F                             ; 9276 6F                       o
        pla                                     ; 9277 68                       h
        .byte   $6F                             ; 9278 6F                       o
        .byte   $6F                             ; 9279 6F                       o
        .byte   $04                             ; 927A 04                       .
        brk                                     ; 927B 00                       .
        .byte   $04                             ; 927C 04                       .
        brk                                     ; 927D 00                       .
        .byte   $63                             ; 927E 63                       c
        .byte   $07                             ; 927F 07                       .
        php                                     ; 9280 08                       .
        .byte   $6F                             ; 9281 6F                       o
        .byte   $6F                             ; 9282 6F                       o
        .byte   $6F                             ; 9283 6F                       o
        .byte   $07                             ; 9284 07                       .
        .byte   $0B                             ; 9285 0B                       .
        .byte   $87                             ; 9286 87                       .
        .byte   $07                             ; 9287 07                       .
        ora     #$63                            ; 9288 09 63                    .c
        .byte   $83                             ; 928A 83                       .
        .byte   $63                             ; 928B 63                       c
        .byte   $07                             ; 928C 07                       .
        php                                     ; 928D 08                       .
        .byte   $6F                             ; 928E 6F                       o
        .byte   $6F                             ; 928F 6F                       o
        .byte   $07                             ; 9290 07                       .
        .byte   $0B                             ; 9291 0B                       .
        .byte   $67                             ; 9292 67                       g
        .byte   $07                             ; 9293 07                       .
        php                                     ; 9294 08                       .
        .byte   $6F                             ; 9295 6F                       o
        .byte   $6F                             ; 9296 6F                       o
        .byte   $6F                             ; 9297 6F                       o
        .byte   $07                             ; 9298 07                       .
        ora     #$0E                            ; 9299 09 0E                    ..
        .byte   $0F                             ; 929B 0F                       .
        .byte   $92                             ; 929C 92                       .
        .byte   $7C                             ; 929D 7C                       |
        .byte   $04                             ; 929E 04                       .
        brk                                     ; 929F 00                       .
        .byte   $63                             ; 92A0 63                       c
        .byte   $07                             ; 92A1 07                       .
        php                                     ; 92A2 08                       .
        .byte   $6F                             ; 92A3 6F                       o
        .byte   $6F                             ; 92A4 6F                       o
        .byte   $6F                             ; 92A5 6F                       o
        .byte   $07                             ; 92A6 07                       .
        .byte   $0B                             ; 92A7 0B                       .
        pla                                     ; 92A8 68                       h
        .byte   $6F                             ; 92A9 6F                       o
        .byte   $07                             ; 92AA 07                       .
        ora     #$83                            ; 92AB 09 83                    ..
        .byte   $6F                             ; 92AD 6F                       o
        .byte   $6F                             ; 92AE 6F                       o
        .byte   $6F                             ; 92AF 6F                       o
        .byte   $6F                             ; 92B0 6F                       o
        pla                                     ; 92B1 68                       h
        .byte   $6F                             ; 92B2 6F                       o
        .byte   $6F                             ; 92B3 6F                       o
        .byte   $6F                             ; 92B4 6F                       o
        asl     L920F                           ; 92B5 0E 0F 92                 ...
        .byte   $9E                             ; 92B8 9E                       .
        .byte   $04                             ; 92B9 04                       .
        brk                                     ; 92BA 00                       .
        .byte   $07                             ; 92BB 07                       .
        php                                     ; 92BC 08                       .
        .byte   $6F                             ; 92BD 6F                       o
        .byte   $07                             ; 92BE 07                       .
        .byte   $0B                             ; 92BF 0B                       .
        pla                                     ; 92C0 68                       h
        .byte   $6F                             ; 92C1 6F                       o
        .byte   $63                             ; 92C2 63                       c
        pla                                     ; 92C3 68                       h
        .byte   $6F                             ; 92C4 6F                       o
        .byte   $6F                             ; 92C5 6F                       o
        .byte   $07                             ; 92C6 07                       .
        ora     #$63                            ; 92C7 09 63                    .c
        .byte   $6F                             ; 92C9 6F                       o
        .byte   $63                             ; 92CA 63                       c
        .byte   $6F                             ; 92CB 6F                       o
        .byte   $6F                             ; 92CC 6F                       o
        .byte   $07                             ; 92CD 07                       .
        .byte   $0B                             ; 92CE 0B                       .
        pla                                     ; 92CF 68                       h
        .byte   $07                             ; 92D0 07                       .
        php                                     ; 92D1 08                       .
        .byte   $6F                             ; 92D2 6F                       o
        .byte   $6F                             ; 92D3 6F                       o
        .byte   $6F                             ; 92D4 6F                       o
        .byte   $07                             ; 92D5 07                       .
        ora     #$63                            ; 92D6 09 63                    .c
        .byte   $07                             ; 92D8 07                       .
        php                                     ; 92D9 08                       .
        .byte   $8F                             ; 92DA 8F                       .
        .byte   $6F                             ; 92DB 6F                       o
        .byte   $07                             ; 92DC 07                       .
        .byte   $0B                             ; 92DD 0B                       .
        pla                                     ; 92DE 68                       h
        .byte   $6F                             ; 92DF 6F                       o
        .byte   $6F                             ; 92E0 6F                       o
        .byte   $07                             ; 92E1 07                       .
        ora     #$63                            ; 92E2 09 63                    .c
        .byte   $6F                             ; 92E4 6F                       o
        .byte   $63                             ; 92E5 63                       c
        .byte   $12                             ; 92E6 12                       .
        brk                                     ; 92E7 00                       .
        .byte   $92                             ; 92E8 92                       .
        inc     $6F,x                           ; 92E9 F6 6F                    .o
        .byte   $63                             ; 92EB 63                       c
        .byte   $07                             ; 92EC 07                       .
        .byte   $0B                             ; 92ED 0B                       .
        pla                                     ; 92EE 68                       h
        .byte   $6F                             ; 92EF 6F                       o
        .byte   $6F                             ; 92F0 6F                       o
        pla                                     ; 92F1 68                       h
        asl     L9203                           ; 92F2 0E 03 92                 ...
        lda     $0768,y                         ; 92F5 B9 68 07                 .h.
        .byte   $0C                             ; 92F8 0C                       .
        pla                                     ; 92F9 68                       h
        pla                                     ; 92FA 68                       h
        pla                                     ; 92FB 68                       h
        pla                                     ; 92FC 68                       h
        pla                                     ; 92FD 68                       h
        asl     $92,x                           ; 92FE 16 92                    ..
        .byte   $7A                             ; 9300 7A                       z
L9301:  .byte   $17                             ; 9301 17                       .
L9302:  brk                                     ; 9302 00                       .
        .byte   $93                             ; 9303 93                       .
        .byte   $0B                             ; 9304 0B                       .
        sty     $54,x                           ; 9305 94 54                    .T
        sta     $8F,x                           ; 9307 95 8F                    ..
        stx     $9D,y                           ; 9309 96 9D                    ..
        ora     $01                             ; 930B 05 01                    ..
        ldx     $06,y                           ; 930D B6 06                    ..
        .byte   $D2                             ; 930F D2                       .
        .byte   $07                             ; 9310 07                       .
        php                                     ; 9311 08                       .
        php                                     ; 9312 08                       .
        brk                                     ; 9313 00                       .
        ora     #$02                            ; 9314 09 02                    ..
        .byte   $5C                             ; 9316 5C                       \
        rti                                     ; 9317 40                       @

; ----------------------------------------------------------------------------
        .byte   $9C                             ; 9318 9C                       .
        .byte   $7C                             ; 9319 7C                       |
        clc                                     ; 931A 18                       .
        .byte   $80                             ; 931B 80                       .
        asl     $3C                             ; 931C 06 3C                    .<
        php                                     ; 931E 08                       .
        asl     a                               ; 931F 0A                       .
        .byte   $7C                             ; 9320 7C                       |
        .byte   $03                             ; 9321 03                       .
        bvs     L938D                           ; 9322 70 69                    pi
        .byte   $64                             ; 9324 64                       d
        adc     ($03,x)                         ; 9325 61 03                    a.
        adc     $7C,x                           ; 9327 75 7C                    u|
        .byte   $03                             ; 9329 03                       .
        adc     #$6D                            ; 932A 69 6D                    im
        jmp     (L696B)                         ; 932C 6C 6B 69                 lki

; ----------------------------------------------------------------------------
        clc                                     ; 932F 18                       .
        brk                                     ; 9330 00                       .
        php                                     ; 9331 08                       .
        brk                                     ; 9332 00                       .
        asl     $D2                             ; 9333 06 D2                    ..
        eor     ($40,x)                         ; 9335 41 40                    A@
        sta     ($61,x)                         ; 9337 81 61                    .a
        clc                                     ; 9339 18                       .
        .byte   $80                             ; 933A 80                       .
        php                                     ; 933B 08                       .
        asl     a                               ; 933C 0A                       .
        adc     ($6D,x)                         ; 933D 61 6D                    am
        ror     a                               ; 933F 6A                       j
        ror     $03                             ; 9340 66 03                    f.
        ror     $72,x                           ; 9342 76 72                    vr
        ror     $7E,x                           ; 9344 76 7E                    v~
        .byte   $03                             ; 9346 03                       .
        ror     a                               ; 9347 6A                       j
        adc     #$68                            ; 9348 69 68                    ih
        ror     L0018                           ; 934A 66 18                    f.
        brk                                     ; 934C 00                       .
        asl     $C8                             ; 934D 06 C8                    ..
        php                                     ; 934F 08                       .
        brk                                     ; 9350 00                       .
        .byte   $42                             ; 9351 42                       B
        rti                                     ; 9352 40                       @

; ----------------------------------------------------------------------------
        .byte   $82                             ; 9353 82                       .
        .byte   $82                             ; 9354 82                       .
        .byte   $82                             ; 9355 82                       .
        .byte   $62                             ; 9356 62                       b
        .byte   $62                             ; 9357 62                       b
        ldy     #$84                            ; 9358 A0 84                    ..
        .byte   $64                             ; 935A 64                       d
        .byte   $04                             ; 935B 04                       .
        brk                                     ; 935C 00                       .
        .byte   $04                             ; 935D 04                       .
        brk                                     ; 935E 00                       .
        .byte   $80                             ; 935F 80                       .
        clc                                     ; 9360 18                       .
        rti                                     ; 9361 40                       @

; ----------------------------------------------------------------------------
        php                                     ; 9362 08                       .
        ora     ($09,x)                         ; 9363 01 09                    ..
        ora     ($9C,x)                         ; 9365 01 9C                    ..
        .byte   $7A                             ; 9367 7A                       z
        .byte   $5C                             ; 9368 5C                       \
        rti                                     ; 9369 40                       @

; ----------------------------------------------------------------------------
        rts                                     ; 936A 60                       `

; ----------------------------------------------------------------------------
        asl     $96                             ; 936B 06 96                    ..
        .byte   $9F                             ; 936D 9F                       .
        rts                                     ; 936E 60                       `

; ----------------------------------------------------------------------------
        asl     $C8                             ; 936F 06 C8                    ..
        .byte   $03                             ; 9371 03                       .
        .byte   $89                             ; 9372 89                       .
        .byte   $67                             ; 9373 67                       g
        ror     $62                             ; 9374 66 62                    fb
        .byte   $67                             ; 9376 67                       g
        .byte   $80                             ; 9377 80                       .
        asl     $F0                             ; 9378 06 F0                    ..
        .byte   $02                             ; 937A 02                       .
        stx     $02                             ; 937B 86 02                    ..
        .byte   $82                             ; 937D 82                       .
        asl     $DC                             ; 937E 06 DC                    ..
        ora     ($A6,x)                         ; 9380 01 A6                    ..
        ora     ($66,x)                         ; 9382 01 66                    .f
        .byte   $67                             ; 9384 67                       g
        adc     #$67                            ; 9385 69 67                    ig
        .byte   $12                             ; 9387 12                       .
        php                                     ; 9388 08                       .
        .byte   $93                             ; 9389 93                       .
        ldy     $60                             ; 938A A4 60                    .`
        .byte   $66                             ; 938C 66                       f
L938D:  ora     ($A4,x)                         ; 938D 01 A4                    ..
        php                                     ; 938F 08                       .
        .byte   $0B                             ; 9390 0B                       .
        cpy     $01                             ; 9391 C4 01                    ..
        sty     $02                             ; 9393 84 02                    ..
        ldy     #$08                            ; 9395 A0 08                    ..
        ora     ($81,x)                         ; 9397 01 81                    ..
        .byte   $64                             ; 9399 64                       d
        rts                                     ; 939A 60                       `

; ----------------------------------------------------------------------------
        adc     ($60,x)                         ; 939B 61 60                    a`
        .byte   $63                             ; 939D 63                       c
        .byte   $02                             ; 939E 02                       .
        stx     $0E                             ; 939F 86 0E                    ..
        ora     ($93,x)                         ; 93A1 01 93                    ..
        eor     $AB02,x                         ; 93A3 5D 02 AB                 ]..
        ora     ($2D,x)                         ; 93A6 01 2D                    .-
        ora     $027F                           ; 93A8 0D 7F 02                 ...
        ror     $2E01                           ; 93AB 6E 01 2E                 n..
        ora     L8D00                           ; 93AE 0D 00 8D                 ...
        .byte   $8B                             ; 93B1 8B                       .
        .byte   $89                             ; 93B2 89                       .
        ora     ($8B,x)                         ; 93B3 01 8B                    ..
        .byte   $AB                             ; 93B5 AB                       .
        php                                     ; 93B6 08                       .
        .byte   $0B                             ; 93B7 0B                       .
        .byte   $02                             ; 93B8 02                       .
        ora     ($CB,x)                         ; 93B9 01 CB                    ..
        .byte   $04                             ; 93BB 04                       .
        brk                                     ; 93BC 00                       .
        php                                     ; 93BD 08                       .
        ora     ($06,x)                         ; 93BE 01 06                    ..
        clv                                     ; 93C0 B8                       .
        .byte   $7F                             ; 93C1 7F                       .
        .byte   $7F                             ; 93C2 7F                       .
        ror     $607F,x                         ; 93C3 7E 7F 60                 ~.`
        .byte   $06                             ; 93C6 06                       .
L93C7:  .byte   $DC                             ; 93C7 DC                       .
        .byte   $02                             ; 93C8 02                       .
        .byte   $9E                             ; 93C9 9E                       .
        .byte   $9F                             ; 93CA 9F                       .
        .byte   $80                             ; 93CB 80                       .
        .byte   $7F                             ; 93CC 7F                       .
        ror     $037F,x                         ; 93CD 7E 7F 03                 ~..
L93D0:  adc     #$12                            ; 93D0 69 12                    i.
        php                                     ; 93D2 08                       .
        sty     $04,x                           ; 93D3 94 04                    ..
        .byte   $8B                             ; 93D5 8B                       .
        .byte   $80                             ; 93D6 80                       .
        php                                     ; 93D7 08                       .
        asl     $06,x                           ; 93D8 16 06                    ..
        .byte   $FF                             ; 93DA FF                       .
        .byte   $07                             ; 93DB 07                       .
        ora     #$A8                            ; 93DC 09 A8                    ..
        ldy     $03                             ; 93DE A4 03                    ..
        .byte   $B7                             ; 93E0 B7                       .
        php                                     ; 93E1 08                       .
        ora     ($06,x)                         ; 93E2 01 06                    ..
        ldy     #$07                            ; 93E4 A0 07                    ..
        php                                     ; 93E6 08                       .
        .byte   $7C                             ; 93E7 7C                       |
        .byte   $7C                             ; 93E8 7C                       |
        asl     $DC                             ; 93E9 06 DC                    ..
        .byte   $7A                             ; 93EB 7A                       z
        .byte   $7C                             ; 93EC 7C                       |
        rts                                     ; 93ED 60                       `

; ----------------------------------------------------------------------------
        .byte   $02                             ; 93EE 02                       .
        txs                                     ; 93EF 9A                       .
        .byte   $9C                             ; 93F0 9C                       .
        .byte   $80                             ; 93F1 80                       .
        adc     $78,x                           ; 93F2 75 78                    ux
        adc     $037F,x                         ; 93F4 7D 7F 03                 }..
        lda     #$65                            ; 93F7 A9 65                    .e
        .byte   $67                             ; 93F9 67                       g
        adc     #$02                            ; 93FA 69 02                    i.
        .byte   $A7                             ; 93FC A7                       .
        adc     #$60                            ; 93FD 69 60                    i`
        .byte   $6B                             ; 93FF 6B                       k
        .byte   $0E                             ; 9400 0E                       .
L9401:  ora     ($93,x)                         ; 9401 01 93                    ..
        .byte   $BB                             ; 9403 BB                       .
        .byte   $02                             ; 9404 02                       .
        .byte   $AB                             ; 9405 AB                       .
        asl     $FF                             ; 9406 06 FF                    ..
        .byte   $87                             ; 9408 87                       .
        ldx     #$03                            ; 9409 A2 03                    ..
        .byte   $B7                             ; 940B B7                       .
        asl     $D2                             ; 940C 06 D2                    ..
        adc     $78,x                           ; 940E 75 78                    ux
        rts                                     ; 9410 60                       `

; ----------------------------------------------------------------------------
        adc     $0260,x                         ; 9411 7D 60 02                 }`.
        .byte   $9F                             ; 9414 9F                       .
        .byte   $03                             ; 9415 03                       .
        lda     #$65                            ; 9416 A9 65                    .e
        .byte   $67                             ; 9418 67                       g
        adc     #$01                            ; 9419 69 01                    i.
        .byte   $67                             ; 941B 67                       g
        .byte   $02                             ; 941C 02                       .
        .byte   $C7                             ; 941D C7                       .
        ora     ($67,x)                         ; 941E 01 67                    .g
        asl     $FF                             ; 9420 06 FF                    ..
        adc     #$6B                            ; 9422 69 6B                    ik
        .byte   $67                             ; 9424 67                       g
        asl     $B4                             ; 9425 06 B4                    ..
        ror     $676E                           ; 9427 6E 6E 67                 nng
        asl     $64                             ; 942A 06 64                    .d
        stx     L8E87                           ; 942C 8E 87 8E                 ...
        stx     $0172                           ; 942F 8E 72 01                 .r.
        beq     L9435                           ; 9432 F0 01                    ..
        .byte   $B0                             ; 9434 B0                       .
L9435:  asl     $D2                             ; 9435 06 D2                    ..
        bvs     L94A9                           ; 9437 70 70                    pp
        adc     #$06                            ; 9439 69 06                    i.
        .byte   $64                             ; 943B 64                       d
        bcc     L93C7                           ; 943C 90 89                    ..
        bcc     L93D0                           ; 943E 90 90                    ..
        asl     $DC                             ; 9440 06 DC                    ..
        .byte   $73                             ; 9442 73                       s
        .byte   $B2                             ; 9443 B2                       .
        .byte   $80                             ; 9444 80                       .
        ldy     $6406                           ; 9445 AC 06 64                 ..d
        .byte   $8B                             ; 9448 8B                       .
        .byte   $89                             ; 9449 89                       .
        .byte   $87                             ; 944A 87                       .
        asl     $F0                             ; 944B 06 F0                    ..
        ror     $02                             ; 944D 66 02                    f.
        .byte   $8F                             ; 944F 8F                       .
        asl     $93,x                           ; 9450 16 93                    ..
        .byte   $5B                             ; 9452 5B                       [
        .byte   $17                             ; 9453 17                       .
        asl     $D2                             ; 9454 06 D2                    ..
        .byte   $07                             ; 9456 07                       .
        php                                     ; 9457 08                       .
        php                                     ; 9458 08                       .
        brk                                     ; 9459 00                       .
        ora     #$02                            ; 945A 09 02                    ..
        eor     L9940,y                         ; 945C 59 40 99                 Y@.
        adc     $C002,y                         ; 945F 79 02 C0                 y..
        lsr     $40,x                           ; 9462 56 40                    V@
        stx     $76,y                           ; 9464 96 76                    .v
        .byte   $02                             ; 9466 02                       .
        cpy     #$06                            ; 9467 C0 06                    ..
        iny                                     ; 9469 C8                       .
        .byte   $57                             ; 946A 57                       W
        rti                                     ; 946B 40                       @

; ----------------------------------------------------------------------------
        .byte   $97                             ; 946C 97                       .
        .byte   $97                             ; 946D 97                       .
        .byte   $97                             ; 946E 97                       .
        .byte   $77                             ; 946F 77                       w
        .byte   $77                             ; 9470 77                       w
        ldy     #$99                            ; 9471 A0 99                    ..
        adc     $0804,y                         ; 9473 79 04 08                 y..
        .byte   $04                             ; 9476 04                       .
        php                                     ; 9477 08                       .
        php                                     ; 9478 08                       .
        .byte   $0C                             ; 9479 0C                       .
        asl     $C8                             ; 947A 06 C8                    ..
        .byte   $07                             ; 947C 07                       .
        asl     $09                             ; 947D 06 09                    ..
        .byte   $02                             ; 947F 02                       .
        .byte   $6B                             ; 9480 6B                       k
        .byte   $6B                             ; 9481 6B                       k
        .byte   $6B                             ; 9482 6B                       k
        .byte   $6B                             ; 9483 6B                       k
        .byte   $12                             ; 9484 12                       .
        php                                     ; 9485 08                       .
        sty     $98,x                           ; 9486 94 98                    ..
        rts                                     ; 9488 60                       `

; ----------------------------------------------------------------------------
        .byte   $6B                             ; 9489 6B                       k
        .byte   $77                             ; 948A 77                       w
        .byte   $6B                             ; 948B 6B                       k
        .byte   $6B                             ; 948C 6B                       k
        adc     $77,x                           ; 948D 75 77                    uw
        .byte   $6B                             ; 948F 6B                       k
        .byte   $6B                             ; 9490 6B                       k
        bvs     L94FE                           ; 9491 70 6B                    pk
        adc     $0E,x                           ; 9493 75 0E                    u.
        .byte   $03                             ; 9495 03                       .
        sty     $76,x                           ; 9496 94 76                    .v
        .byte   $80                             ; 9498 80                       .
        clc                                     ; 9499 18                       .
        rti                                     ; 949A 40                       @

; ----------------------------------------------------------------------------
        php                                     ; 949B 08                       .
        ora     ($06,x)                         ; 949C 01 06                    ..
        .byte   $DC                             ; 949E DC                       .
        .byte   $03                             ; 949F 03                       .
        .byte   $89                             ; 94A0 89                       .
        adc     $6960                           ; 94A1 6D 60 69                 m`i
        rts                                     ; 94A4 60                       `

; ----------------------------------------------------------------------------
        .byte   $6B                             ; 94A5 6B                       k
        .byte   $02                             ; 94A6 02                       .
        .byte   $8F                             ; 94A7 8F                       .
        .byte   $04                             ; 94A8 04                       .
L94A9:  php                                     ; 94A9 08                       .
        clc                                     ; 94AA 18                       .
        brk                                     ; 94AB 00                       .
        php                                     ; 94AC 08                       .
        .byte   $0C                             ; 94AD 0C                       .
        asl     $C8                             ; 94AE 06 C8                    ..
        .byte   $6B                             ; 94B0 6B                       k
        .byte   $6B                             ; 94B1 6B                       k
        .byte   $6B                             ; 94B2 6B                       k
        .byte   $6B                             ; 94B3 6B                       k
        rts                                     ; 94B4 60                       `

; ----------------------------------------------------------------------------
        .byte   $6B                             ; 94B5 6B                       k
        .byte   $77                             ; 94B6 77                       w
        .byte   $6B                             ; 94B7 6B                       k
        .byte   $6B                             ; 94B8 6B                       k
        adc     $77,x                           ; 94B9 75 77                    uw
        .byte   $6B                             ; 94BB 6B                       k
        .byte   $6B                             ; 94BC 6B                       k
        bvs     L952A                           ; 94BD 70 6B                    pk
        adc     $0E,x                           ; 94BF 75 0E                    u.
        ora     ($94,x)                         ; 94C1 01 94                    ..
        tay                                     ; 94C3 A8                       .
        clc                                     ; 94C4 18                       .
        cpy     #$08                            ; 94C5 C0 08                    ..
        asl     $06                             ; 94C7 06 06                    ..
        sbc     ($07,x)                         ; 94C9 E1 07                    ..
        ora     $01                             ; 94CB 05 01                    ..
        .byte   $62                             ; 94CD 62                       b
        .byte   $07                             ; 94CE 07                       .
        asl     $62                             ; 94CF 06 62                    .b
        .byte   $07                             ; 94D1 07                       .
        .byte   $07                             ; 94D2 07                       .
        .byte   $02                             ; 94D3 02                       .
        ora     ($A2,x)                         ; 94D4 01 A2                    ..
        .byte   $07                             ; 94D6 07                       .
        ora     $01                             ; 94D7 05 01                    ..
        .byte   $64                             ; 94D9 64                       d
        .byte   $07                             ; 94DA 07                       .
        asl     $64                             ; 94DB 06 64                    .d
        .byte   $07                             ; 94DD 07                       .
        .byte   $07                             ; 94DE 07                       .
        .byte   $02                             ; 94DF 02                       .
        ora     ($A4,x)                         ; 94E0 01 A4                    ..
        .byte   $07                             ; 94E2 07                       .
        ora     $01                             ; 94E3 05 01                    ..
        adc     #$07                            ; 94E5 69 07                    i.
        asl     $69                             ; 94E7 06 69                    .i
        .byte   $07                             ; 94E9 07                       .
        .byte   $07                             ; 94EA 07                       .
        ora     ($89,x)                         ; 94EB 01 89                    ..
        lda     $AFB0                           ; 94ED AD B0 AF                 ...
        .byte   $04                             ; 94F0 04                       .
        brk                                     ; 94F1 00                       .
        php                                     ; 94F2 08                       .
        .byte   $02                             ; 94F3 02                       .
        asl     $B8                             ; 94F4 06 B8                    ..
        ora     #$01                            ; 94F6 09 01                    ..
        .byte   $7C                             ; 94F8 7C                       |
        .byte   $7C                             ; 94F9 7C                       |
        .byte   $7A                             ; 94FA 7A                       z
        .byte   $7C                             ; 94FB 7C                       |
        rts                                     ; 94FC 60                       `

; ----------------------------------------------------------------------------
        .byte   $06                             ; 94FD 06                       .
L94FE:  .byte   $DC                             ; 94FE DC                       .
        .byte   $02                             ; 94FF 02                       .
        txs                                     ; 9500 9A                       .
L9501:  .byte   $9C                             ; 9501 9C                       .
        .byte   $80                             ; 9502 80                       .
        ldy     #$12                            ; 9503 A0 12                    ..
        brk                                     ; 9505 00                       .
        sta     $34,x                           ; 9506 95 34                    .4
        .byte   $03                             ; 9508 03                       .
        dey                                     ; 9509 88                       .
        .byte   $80                             ; 950A 80                       .
        php                                     ; 950B 08                       .
        asl     $06,x                           ; 950C 16 06                    ..
        .byte   $FF                             ; 950E FF                       .
        .byte   $07                             ; 950F 07                       .
        ora     #$A4                            ; 9510 09 A4                    ..
        .byte   $03                             ; 9512 03                       .
        .byte   $B7                             ; 9513 B7                       .
        ldy     $08,x                           ; 9514 B4 08                    ..
        ora     ($07,x)                         ; 9516 01 07                    ..
        .byte   $07                             ; 9518 07                       .
        asl     $A0                             ; 9519 06 A0                    ..
        .byte   $73                             ; 951B 73                       s
        .byte   $73                             ; 951C 73                       s
        asl     $DC                             ; 951D 06 DC                    ..
        .byte   $72                             ; 951F 72                       r
        .byte   $73                             ; 9520 73                       s
        rts                                     ; 9521 60                       `

; ----------------------------------------------------------------------------
L9522:  .byte   $02                             ; 9522 02                       .
        .byte   $92                             ; 9523 92                       .
        .byte   $93                             ; 9524 93                       .
        .byte   $02                             ; 9525 02                       .
        ldy     #$B8                            ; 9526 A0 B8                    ..
        adc     $77,x                           ; 9528 75 77                    uw
L952A:  sei                                     ; 952A 78                       x
        .byte   $02                             ; 952B 02                       .
        .byte   $B7                             ; 952C B7                       .
        sei                                     ; 952D 78                       x
        rts                                     ; 952E 60                       `

; ----------------------------------------------------------------------------
        .byte   $7A                             ; 952F 7A                       z
        asl     L9401                           ; 9530 0E 01 94                 ...
        beq     L9537                           ; 9533 F0 02                    ..
        .byte   $BF                             ; 9535 BF                       .
        txs                                     ; 9536 9A                       .
L9537:  .byte   $B7                             ; 9537 B7                       .
        .byte   $B3                             ; 9538 B3                       .
        cmp     ($CC),y                         ; 9539 D1 CC                    ..
        asl     $D2                             ; 953B 06 D2                    ..
        .byte   $6B                             ; 953D 6B                       k
        ror     $7360                           ; 953E 6E 60 73                 n`s
        rts                                     ; 9541 60                       `

; ----------------------------------------------------------------------------
        .byte   $02                             ; 9542 02                       .
        sta     $01,x                           ; 9543 95 01                    ..
        .byte   $B7                             ; 9545 B7                       .
        ora     ($77,x)                         ; 9546 01 77                    .w
        asl     $FF                             ; 9548 06 FF                    ..
        sei                                     ; 954A 78                       x
        .byte   $7A                             ; 954B 7A                       z
        .byte   $77                             ; 954C 77                       w
        asl     $B4                             ; 954D 06 B4                    ..
        .byte   $03                             ; 954F 03                       .
        .byte   $6B                             ; 9550 6B                       k
        .byte   $6B                             ; 9551 6B                       k
        .byte   $64                             ; 9552 64                       d
        asl     $64                             ; 9553 06 64                    .d
        .byte   $8B                             ; 9555 8B                       .
        sty     $8B                             ; 9556 84 8B                    ..
        .byte   $8B                             ; 9558 8B                       .
        asl     $F5                             ; 9559 06 F5                    ..
        ror     $ACAD                           ; 955B 6E AD AC                 n..
        .byte   $AB                             ; 955E AB                       .
        .byte   $02                             ; 955F 02                       .
        .byte   $89                             ; 9560 89                       .
        .byte   $02                             ; 9561 02                       .
        .byte   $8B                             ; 9562 8B                       .
        sty     $D206                           ; 9563 8C 06 D2                 ...
        adc     $646D                           ; 9566 6D 6D 64                 mmd
        asl     $64                             ; 9569 06 64                    .d
        sta     L8D84                           ; 956B 8D 84 8D                 ...
        sta     $F006                           ; 956E 8D 06 F0                 ...
        bvs     L9522                           ; 9571 70 AF                    p.
        .byte   $80                             ; 9573 80                       .
        ora     ($28,x)                         ; 9574 01 28                    .(
        ora     L897F                           ; 9576 0D 7F 89                 ...
        .byte   $02                             ; 9579 02                       .
        adc     #$01                            ; 957A 69 01                    i.
        and     #$0D                            ; 957C 29 0D                    ).
        brk                                     ; 957E 00                       .
        asl     $64                             ; 957F 06 64                    .d
        .byte   $87                             ; 9581 87                       .
        stx     $84                             ; 9582 86 84                    ..
        asl     $F0                             ; 9584 06 F0                    ..
        .byte   $63                             ; 9586 63                       c
        .byte   $02                             ; 9587 02                       .
        sty     a:L0018                         ; 9588 8C 18 00                 ...
        asl     $94,x                           ; 958B 16 94                    ..
        .byte   $74                             ; 958D 74                       t
        .byte   $17                             ; 958E 17                       .
        asl     $D2                             ; 958F 06 D2                    ..
        php                                     ; 9591 08                       .
        ora     $0209                           ; 9592 0D 09 02                 ...
        .byte   $6B                             ; 9595 6B                       k
        .byte   $8B                             ; 9596 8B                       .
        .byte   $6B                             ; 9597 6B                       k
        .byte   $02                             ; 9598 02                       .
        cpy     #$68                            ; 9599 C0 68                    .h
        dey                                     ; 959B 88                       .
        pla                                     ; 959C 68                       h
        .byte   $02                             ; 959D 02                       .
        cpy     #$69                            ; 959E C0 69                    .i
        .byte   $89                             ; 95A0 89                       .
        .byte   $89                             ; 95A1 89                       .
        .byte   $89                             ; 95A2 89                       .
        adc     #$89                            ; 95A3 69 89                    i.
        .byte   $73                             ; 95A5 73                       s
        adc     $60,x                           ; 95A6 75 60                    u`
        .byte   $8B                             ; 95A8 8B                       .
        .byte   $6B                             ; 95A9 6B                       k
        .byte   $04                             ; 95AA 04                       .
        brk                                     ; 95AB 00                       .
        .byte   $04                             ; 95AC 04                       .
        brk                                     ; 95AD 00                       .
        ora     #$02                            ; 95AE 09 02                    ..
        .byte   $02                             ; 95B0 02                       .
        bcc     L9623                           ; 95B1 90 70                    .p
        rts                                     ; 95B3 60                       `

; ----------------------------------------------------------------------------
        bvs     L9632                           ; 95B4 70 7C                    p|
        ror     $6E90                           ; 95B6 6E 90 6E                 n.n
        .byte   $73                             ; 95B9 73                       s
        rts                                     ; 95BA 60                       `

; ----------------------------------------------------------------------------
        bvs     L9628                           ; 95BB 70 6B                    pk
        bvs     L95C1                           ; 95BD 70 02                    p.
        .byte   $8E                             ; 95BF 8E                       .
        .byte   $6E                             ; 95C0 6E                       n
L95C1:  rts                                     ; 95C1 60                       `

; ----------------------------------------------------------------------------
        .byte   $73                             ; 95C2 73                       s
        adc     $6C,x                           ; 95C3 75 6C                    ul
        stx     $726C                           ; 95C5 8E 6C 72                 .lr
        rts                                     ; 95C8 60                       `

; ----------------------------------------------------------------------------
        sty     $126E                           ; 95C9 8C 6E 12                 .n.
        brk                                     ; 95CC 00                       .
        sta     $EE,x                           ; 95CD 95 EE                    ..
        .byte   $02                             ; 95CF 02                       .
        sty     $606C                           ; 95D0 8C 6C 60                 .l`
        .byte   $73                             ; 95D3 73                       s
        sei                                     ; 95D4 78                       x
        jmp     (L8C02)                         ; 95D5 6C 02 8C                 l..

; ----------------------------------------------------------------------------
        jmp     (L8D60)                         ; 95D8 6C 60 8D                 l`.

; ----------------------------------------------------------------------------
        adc     L8B02                           ; 95DB 6D 02 8B                 m..
        .byte   $6B                             ; 95DE 6B                       k
        rts                                     ; 95DF 60                       `

; ----------------------------------------------------------------------------
        adc     $77,x                           ; 95E0 75 77                    uw
        adc     #$02                            ; 95E2 69 02                    i.
        .byte   $8B                             ; 95E4 8B                       .
        bvs     L9647                           ; 95E5 70 60                    p`
        adc     $6B69                           ; 95E7 6D 69 6B                 mik
        asl     L9501                           ; 95EA 0E 01 95                 ...
        ldy     $0109                           ; 95ED AC 09 01                 ...
        .byte   $02                             ; 95F0 02                       .
        .byte   $93                             ; 95F1 93                       .
        .byte   $73                             ; 95F2 73                       s
        rts                                     ; 95F3 60                       `

; ----------------------------------------------------------------------------
        sta     $027F,x                         ; 95F4 9D 7F 02                 ...
        sta     $75,x                           ; 95F7 95 75                    .u
        rts                                     ; 95F9 60                       `

; ----------------------------------------------------------------------------
        .byte   $9C                             ; 95FA 9C                       .
        .byte   $03                             ; 95FB 03                       .
        adc     #$02                            ; 95FC 69 02                    i.
        .byte   $03                             ; 95FE 03                       .
        .byte   $97                             ; 95FF 97                       .
        .byte   $77                             ; 9600 77                       w
L9601:  rts                                     ; 9601 60                       `

; ----------------------------------------------------------------------------
        .byte   $9E                             ; 9602 9E                       .
        .byte   $03                             ; 9603 03                       .
        .byte   $6B                             ; 9604 6B                       k
        .byte   $03                             ; 9605 03                       .
        .byte   $97                             ; 9606 97                       .
L9607:  adc     $9C,x                           ; 9607 75 9C                    u.
        .byte   $7A                             ; 9609 7A                       z
        adc     $77,x                           ; 960A 75 77                    uw
        .byte   $04                             ; 960C 04                       .
        brk                                     ; 960D 00                       .
        .byte   $02                             ; 960E 02                       .
        tya                                     ; 960F 98                       .
        sei                                     ; 9610 78                       x
        rts                                     ; 9611 60                       `

; ----------------------------------------------------------------------------
        tya                                     ; 9612 98                       .
        sei                                     ; 9613 78                       x
        sei                                     ; 9614 78                       x
        .byte   $02                             ; 9615 02                       .
        .byte   $80                             ; 9616 80                       .
        .byte   $7A                             ; 9617 7A                       z
        .byte   $7C                             ; 9618 7C                       |
        .byte   $7F                             ; 9619 7F                       .
        .byte   $03                             ; 961A 03                       .
        adc     #$12                            ; 961B 69 12                    i.
        php                                     ; 961D 08                       .
        stx     $49,y                           ; 961E 96 49                    .I
        .byte   $02                             ; 9620 02                       .
        sty     $64                             ; 9621 84 64                    .d
L9623:  rts                                     ; 9623 60                       `

; ----------------------------------------------------------------------------
        sty     $64                             ; 9624 84 64                    .d
        .byte   $64                             ; 9626 64                       d
        .byte   $02                             ; 9627 02                       .
L9628:  .byte   $80                             ; 9628 80                       .
        .byte   $03                             ; 9629 03                       .
        bvs     L969A                           ; 962A 70 6E                    pn
        bvs     L96A5                           ; 962C 70 77                    pw
        .byte   $02                             ; 962E 02                       .
        tya                                     ; 962F 98                       .
        sei                                     ; 9630 78                       x
        rts                                     ; 9631 60                       `

; ----------------------------------------------------------------------------
L9632:  tya                                     ; 9632 98                       .
        sei                                     ; 9633 78                       x
        sei                                     ; 9634 78                       x
        .byte   $02                             ; 9635 02                       .
        .byte   $80                             ; 9636 80                       .
        ldy     #$02                            ; 9637 A0 02                    ..
        sta     $607D,x                         ; 9639 9D 7D 60                 .}`
        sta     $027D,x                         ; 963C 9D 7D 02                 .}.
        .byte   $9F                             ; 963F 9F                       .
        .byte   $7F                             ; 9640 7F                       .
        rts                                     ; 9641 60                       `

; ----------------------------------------------------------------------------
        .byte   $73                             ; 9642 73                       s
        .byte   $7A                             ; 9643 7A                       z
        .byte   $7F                             ; 9644 7F                       .
        .byte   $0E                             ; 9645 0E                       .
        .byte   $01                             ; 9646 01                       .
L9647:  stx     $0C,y                           ; 9647 96 0C                    ..
        .byte   $02                             ; 9649 02                       .
        .byte   $87                             ; 964A 87                       .
        .byte   $67                             ; 964B 67                       g
        rts                                     ; 964C 60                       `

; ----------------------------------------------------------------------------
        .byte   $87                             ; 964D 87                       .
        .byte   $67                             ; 964E 67                       g
        .byte   $67                             ; 964F 67                       g
        .byte   $02                             ; 9650 02                       .
        .byte   $80                             ; 9651 80                       .
        .byte   $67                             ; 9652 67                       g
        .byte   $03                             ; 9653 03                       .
        ror     $7371                           ; 9654 6E 71 73                 nqs
        adc     ($71),y                         ; 9657 71 71                    qq
        sei                                     ; 9659 78                       x
        adc     ($60),y                         ; 965A 71 60                    q`
        sta     ($78),y                         ; 965C 91 78                    .x
        .byte   $02                             ; 965E 02                       .
        sta     ($71),y                         ; 965F 91 71                    .q
        rts                                     ; 9661 60                       `

; ----------------------------------------------------------------------------
        sta     $737D,x                         ; 9662 9D 7D 73                 .}s
        .byte   $73                             ; 9665 73                       s
        .byte   $7A                             ; 9666 7A                       z
        .byte   $73                             ; 9667 73                       s
        rts                                     ; 9668 60                       `

; ----------------------------------------------------------------------------
        .byte   $93                             ; 9669 93                       .
        .byte   $7A                             ; 966A 7A                       z
        .byte   $B3                             ; 966B B3                       .
        .byte   $73                             ; 966C 73                       s
        .byte   $7F                             ; 966D 7F                       .
        rts                                     ; 966E 60                       `

; ----------------------------------------------------------------------------
        .byte   $7F                             ; 966F 7F                       .
        sta     $75,x                           ; 9670 95 75                    .u
        adc     $60,x                           ; 9672 75 60                    u`
        .byte   $9C                             ; 9674 9C                       .
        adc     $60,x                           ; 9675 75 60                    u`
        sta     $7C,x                           ; 9677 95 7C                    .|
        sta     $70,x                           ; 9679 95 70                    .p
        adc     $92,x                           ; 967B 75 92                    u.
        .byte   $72                             ; 967D 72                       r
        .byte   $72                             ; 967E 72                       r
        rts                                     ; 967F 60                       `

; ----------------------------------------------------------------------------
L9680:  sta     $607E,y                         ; 9680 99 7E 60                 .~`
        .byte   $02                             ; 9683 02                       .
        .byte   $9E                             ; 9684 9E                       .
        .byte   $9E                             ; 9685 9E                       .
        adc     L977E,y                         ; 9686 79 7E 97                 y~.
        .byte   $77                             ; 9689 77                       w
        .byte   $77                             ; 968A 77                       w
        rts                                     ; 968B 60                       `

; ----------------------------------------------------------------------------
        .byte   $9E                             ; 968C 9E                       .
        .byte   $77                             ; 968D 77                       w
        rts                                     ; 968E 60                       `

; ----------------------------------------------------------------------------
        .byte   $97                             ; 968F 97                       .
        ror     $7297,x                         ; 9690 7E 97 72                 ~.r
        .byte   $72                             ; 9693 72                       r
        .byte   $77                             ; 9694 77                       w
        .byte   $02                             ; 9695 02                       .
        cpy     #$02                            ; 9696 C0 02                    ..
        .byte   $80                             ; 9698 80                       .
        .byte   $16                             ; 9699 16                       .
L969A:  sta     $AA,x                           ; 969A 95 AA                    ..
        .byte   $17                             ; 969C 17                       .
        php                                     ; 969D 08                       .
        .byte   $14                             ; 969E 14                       .
        ora     #$00                            ; 969F 09 00                    ..
        .byte   $04                             ; 96A1 04                       .
        brk                                     ; 96A2 00                       .
        asl     $BE                             ; 96A3 06 BE                    ..
L96A5:  .byte   $07                             ; 96A5 07                       .
        .byte   $0B                             ; 96A6 0B                       .
        .byte   $64                             ; 96A7 64                       d
        .byte   $07                             ; 96A8 07                       .
        php                                     ; 96A9 08                       .
        .byte   $8F                             ; 96AA 8F                       .
        .byte   $8F                             ; 96AB 8F                       .
        .byte   $6F                             ; 96AC 6F                       o
        .byte   $6F                             ; 96AD 6F                       o
        .byte   $6F                             ; 96AE 6F                       o
        .byte   $6F                             ; 96AF 6F                       o
        .byte   $6F                             ; 96B0 6F                       o
        .byte   $6F                             ; 96B1 6F                       o
        .byte   $6F                             ; 96B2 6F                       o
        .byte   $64                             ; 96B3 64                       d
        .byte   $07                             ; 96B4 07                       .
        .byte   $0C                             ; 96B5 0C                       .
        asl     $C8                             ; 96B6 06 C8                    ..
        .byte   $02                             ; 96B8 02                       .
        dey                                     ; 96B9 88                       .
        asl     L9601                           ; 96BA 0E 01 96                 ...
        lda     ($06,x)                         ; 96BD A1 06                    ..
        ldx     $0907,y                         ; 96BF BE 07 09                 ...
        .byte   $64                             ; 96C2 64                       d
        .byte   $07                             ; 96C3 07                       .
        .byte   $0B                             ; 96C4 0B                       .
        dey                                     ; 96C5 88                       .
        dey                                     ; 96C6 88                       .
        dey                                     ; 96C7 88                       .
        pla                                     ; 96C8 68                       h
        pla                                     ; 96C9 68                       h
        rts                                     ; 96CA 60                       `

; ----------------------------------------------------------------------------
        .byte   $6F                             ; 96CB 6F                       o
        .byte   $6F                             ; 96CC 6F                       o
        .byte   $64                             ; 96CD 64                       d
        dey                                     ; 96CE 88                       .
        rts                                     ; 96CF 60                       `

; ----------------------------------------------------------------------------
        .byte   $04                             ; 96D0 04                       .
        brk                                     ; 96D1 00                       .
        .byte   $04                             ; 96D2 04                       .
        brk                                     ; 96D3 00                       .
        .byte   $07                             ; 96D4 07                       .
        asl     a                               ; 96D5 0A                       .
        .byte   $64                             ; 96D6 64                       d
        .byte   $07                             ; 96D7 07                       .
        php                                     ; 96D8 08                       .
        .byte   $6F                             ; 96D9 6F                       o
        .byte   $6F                             ; 96DA 6F                       o
        .byte   $6F                             ; 96DB 6F                       o
        .byte   $07                             ; 96DC 07                       .
        .byte   $0B                             ; 96DD 0B                       .
        dey                                     ; 96DE 88                       .
        .byte   $6F                             ; 96DF 6F                       o
        sty     $07                             ; 96E0 84 07                    ..
        php                                     ; 96E2 08                       .
        .byte   $6F                             ; 96E3 6F                       o
        .byte   $6F                             ; 96E4 6F                       o
        .byte   $64                             ; 96E5 64                       d
        .byte   $07                             ; 96E6 07                       .
        .byte   $0B                             ; 96E7 0B                       .
        dey                                     ; 96E8 88                       .
        .byte   $07                             ; 96E9 07                       .
        php                                     ; 96EA 08                       .
        .byte   $6F                             ; 96EB 6F                       o
        .byte   $6F                             ; 96EC 6F                       o
        asl     L9607                           ; 96ED 0E 07 96                 ...
        .byte   $D2                             ; 96F0 D2                       .
        .byte   $04                             ; 96F1 04                       .
        brk                                     ; 96F2 00                       .
        .byte   $07                             ; 96F3 07                       .
        asl     a                               ; 96F4 0A                       .
        .byte   $64                             ; 96F5 64                       d
        .byte   $07                             ; 96F6 07                       .
        php                                     ; 96F7 08                       .
        .byte   $6F                             ; 96F8 6F                       o
        .byte   $6F                             ; 96F9 6F                       o
        .byte   $07                             ; 96FA 07                       .
        .byte   $0B                             ; 96FB 0B                       .
        dey                                     ; 96FC 88                       .
        .byte   $07                             ; 96FD 07                       .
        asl     a                               ; 96FE 0A                       .
        .byte   $64                             ; 96FF 64                       d
        .byte   $6F                             ; 9700 6F                       o
L9701:  .byte   $64                             ; 9701 64                       d
L9702:  .byte   $64                             ; 9702 64                       d
        .byte   $07                             ; 9703 07                       .
        php                                     ; 9704 08                       .
        .byte   $6F                             ; 9705 6F                       o
        .byte   $6F                             ; 9706 6F                       o
        .byte   $6F                             ; 9707 6F                       o
        .byte   $07                             ; 9708 07                       .
        ora     $04A8                           ; 9709 0D A8 04                 ...
        brk                                     ; 970C 00                       .
        .byte   $07                             ; 970D 07                       .
        asl     a                               ; 970E 0A                       .
        .byte   $64                             ; 970F 64                       d
        .byte   $07                             ; 9710 07                       .
        php                                     ; 9711 08                       .
        .byte   $6F                             ; 9712 6F                       o
        .byte   $6F                             ; 9713 6F                       o
        .byte   $07                             ; 9714 07                       .
        asl     a                               ; 9715 0A                       .
        .byte   $64                             ; 9716 64                       d
        rts                                     ; 9717 60                       `

; ----------------------------------------------------------------------------
        .byte   $64                             ; 9718 64                       d
        .byte   $6F                             ; 9719 6F                       o
        .byte   $64                             ; 971A 64                       d
        .byte   $64                             ; 971B 64                       d
        .byte   $07                             ; 971C 07                       .
        php                                     ; 971D 08                       .
        .byte   $6F                             ; 971E 6F                       o
        .byte   $6F                             ; 971F 6F                       o
        .byte   $6F                             ; 9720 6F                       o
        .byte   $07                             ; 9721 07                       .
        .byte   $0B                             ; 9722 0B                       .
        dey                                     ; 9723 88                       .
        .byte   $12                             ; 9724 12                       .
        brk                                     ; 9725 00                       .
        .byte   $97                             ; 9726 97                       .
        rol     $6F6F                           ; 9727 2E 6F 6F                 .oo
        asl     L9701                           ; 972A 0E 01 97                 ...
        .byte   $0B                             ; 972D 0B                       .
        .byte   $80                             ; 972E 80                       .
        .byte   $04                             ; 972F 04                       .
        brk                                     ; 9730 00                       .
        .byte   $64                             ; 9731 64                       d
        .byte   $07                             ; 9732 07                       .
        php                                     ; 9733 08                       .
        .byte   $6F                             ; 9734 6F                       o
        .byte   $6F                             ; 9735 6F                       o
        .byte   $6F                             ; 9736 6F                       o
        .byte   $07                             ; 9737 07                       .
        .byte   $0B                             ; 9738 0B                       .
        .byte   $02                             ; 9739 02                       .
        dey                                     ; 973A 88                       .
        .byte   $6F                             ; 973B 6F                       o
        asl     L9701                           ; 973C 0E 01 97                 ...
        .byte   $2F                             ; 973F 2F                       /
        .byte   $0F                             ; 9740 0F                       .
        ora     ($96,x)                         ; 9741 01 96                    ..
        sbc     ($04),y                         ; 9743 F1 04                    ..
        brk                                     ; 9745 00                       .
        .byte   $07                             ; 9746 07                       .
        asl     a                               ; 9747 0A                       .
        .byte   $64                             ; 9748 64                       d
        rts                                     ; 9749 60                       `

; ----------------------------------------------------------------------------
        .byte   $64                             ; 974A 64                       d
        pla                                     ; 974B 68                       h
        .byte   $6F                             ; 974C 6F                       o
        .byte   $64                             ; 974D 64                       d
        rts                                     ; 974E 60                       `

; ----------------------------------------------------------------------------
        dey                                     ; 974F 88                       .
        .byte   $64                             ; 9750 64                       d
        .byte   $6F                             ; 9751 6F                       o
        .byte   $6F                             ; 9752 6F                       o
        pla                                     ; 9753 68                       h
        .byte   $6F                             ; 9754 6F                       o
        .byte   $6F                             ; 9755 6F                       o
        .byte   $6F                             ; 9756 6F                       o
        .byte   $04                             ; 9757 04                       .
        brk                                     ; 9758 00                       .
        .byte   $64                             ; 9759 64                       d
        .byte   $07                             ; 975A 07                       .
        php                                     ; 975B 08                       .
        .byte   $6F                             ; 975C 6F                       o
        .byte   $6F                             ; 975D 6F                       o
        .byte   $64                             ; 975E 64                       d
        .byte   $07                             ; 975F 07                       .
        .byte   $0B                             ; 9760 0B                       .
        dey                                     ; 9761 88                       .
        .byte   $6F                             ; 9762 6F                       o
        .byte   $6F                             ; 9763 6F                       o
        .byte   $13                             ; 9764 13                       .
        brk                                     ; 9765 00                       .
        .byte   $97                             ; 9766 97                       .
        bvs     L9777                           ; 9767 70 0E                    p.
        ora     ($97,x)                         ; 9769 01 97                    ..
        .byte   $57                             ; 976B 57                       W
        .byte   $0F                             ; 976C 0F                       .
        ora     ($97,x)                         ; 976D 01 97                    ..
        .byte   $44                             ; 976F 44                       D
        .byte   $64                             ; 9770 64                       d
        rts                                     ; 9771 60                       `

; ----------------------------------------------------------------------------
        pla                                     ; 9772 68                       h
        .byte   $64                             ; 9773 64                       d
        pla                                     ; 9774 68                       h
        .byte   $07                             ; 9775 07                       .
        .byte   $0B                             ; 9776 0B                       .
L9777:  pla                                     ; 9777 68                       h
        pla                                     ; 9778 68                       h
        pla                                     ; 9779 68                       h
        asl     $96,x                           ; 977A 16 96                    ..
        bne     L9795                           ; 977C D0 17                    ..
L977E:  brk                                     ; 977E 00                       .
        .byte   $97                             ; 977F 97                       .
        .byte   $87                             ; 9780 87                       .
        tya                                     ; 9781 98                       .
        sty     $F799                           ; 9782 8C 99 F7                 ...
        .byte   $9B                             ; 9785 9B                       .
        asl     $05,x                           ; 9786 16 05                    ..
        ora     ($C7,x)                         ; 9788 01 C7                    ..
        .byte   $04                             ; 978A 04                       .
        php                                     ; 978B 08                       .
        asl     $F0                             ; 978C 06 F0                    ..
        .byte   $07                             ; 978E 07                       .
        ora     #$08                            ; 978F 09 08                    ..
        ora     $09                             ; 9791 05 09                    ..
        brk                                     ; 9793 00                       .
        .byte   $02                             ; 9794 02                       .
L9795:  .byte   $92                             ; 9795 92                       .
        lda     ($60),y                         ; 9796 B1 60                    .`
        .byte   $02                             ; 9798 02                       .
        sta     ($AF),y                         ; 9799 91 AF                    ..
        rts                                     ; 979B 60                       `

; ----------------------------------------------------------------------------
        .byte   $02                             ; 979C 02                       .
        sta     ($AF),y                         ; 979D 91 AF                    ..
        rts                                     ; 979F 60                       `

; ----------------------------------------------------------------------------
        asl     $F5                             ; 97A0 06 F5                    ..
        .byte   $02                             ; 97A2 02                       .
        .byte   $8F                             ; 97A3 8F                       .
        .byte   $02                             ; 97A4 02                       .
        sta     ($92),y                         ; 97A5 91 92                    ..
        asl     $C8                             ; 97A7 06 C8                    ..
        .byte   $02                             ; 97A9 02                       .
        .byte   $8F                             ; 97AA 8F                       .
        .byte   $02                             ; 97AB 02                       .
        ora     ($CD,x)                         ; 97AC 01 CD                    ..
        adc     $CD01                           ; 97AE 6D 01 CD                 m..
        clc                                     ; 97B1 18                       .
        cpy     #$08                            ; 97B2 C0 08                    ..
        .byte   $02                             ; 97B4 02                       .
        .byte   $02                             ; 97B5 02                       .
        .byte   $92                             ; 97B6 92                       .
        .byte   $72                             ; 97B7 72                       r
        rts                                     ; 97B8 60                       `

; ----------------------------------------------------------------------------
        asl     $FF                             ; 97B9 06 FF                    ..
        .byte   $02                             ; 97BB 02                       .
        .byte   $93                             ; 97BC 93                       .
        clc                                     ; 97BD 18                       .
        brk                                     ; 97BE 00                       .
        asl     L9701                           ; 97BF 0E 01 97                 ...
        txa                                     ; 97C2 8A                       .
        .byte   $04                             ; 97C3 04                       .
        php                                     ; 97C4 08                       .
        asl     $F0                             ; 97C5 06 F0                    ..
        .byte   $07                             ; 97C7 07                       .
        ora     #$09                            ; 97C8 09 09                    ..
        ora     (L0018,x)                       ; 97CA 01 18                    ..
        .byte   $80                             ; 97CC 80                       .
        .byte   $04                             ; 97CD 04                       .
        php                                     ; 97CE 08                       .
        dey                                     ; 97CF 88                       .
        .byte   $6B                             ; 97D0 6B                       k
        .byte   $6F                             ; 97D1 6F                       o
        rts                                     ; 97D2 60                       `

; ----------------------------------------------------------------------------
        pla                                     ; 97D3 68                       h
        .byte   $8B                             ; 97D4 8B                       .
        sta     ($60),y                         ; 97D5 91 60                    .`
        ora     ($B2,x)                         ; 97D7 01 B2                    ..
L97D9:  .byte   $72                             ; 97D9 72                       r
        .byte   $02                             ; 97DA 02                       .
        ora     ($D2,x)                         ; 97DB 01 D2                    ..
        ldy     $91,x                           ; 97DD B4 91                    ..
        .byte   $72                             ; 97DF 72                       r
        sta     ($02),y                         ; 97E0 91 02                    ..
        .byte   $8F                             ; 97E2 8F                       .
        sta     $0812                           ; 97E3 8D 12 08                 ...
        .byte   $97                             ; 97E6 97                       .
        .byte   $F2                             ; 97E7 F2                       .
        .byte   $6F                             ; 97E8 6F                       o
        ora     ($AD,x)                         ; 97E9 01 AD                    ..
        adc     $ED01                           ; 97EB 6D 01 ED                 m..
        asl     L9701                           ; 97EE 0E 01 97                 ...
        cmp     L9680                           ; 97F1 CD 80 96                 ...
        ora     ($94,x)                         ; 97F4 01 94                    ..
        ora     ($F4,x)                         ; 97F6 01 F4                    ..
        php                                     ; 97F8 08                       .
        ora     $04                             ; 97F9 05 04                    ..
        php                                     ; 97FB 08                       .
        .byte   $02                             ; 97FC 02                       .
        .byte   $92                             ; 97FD 92                       .
        lda     ($60),y                         ; 97FE B1 60                    .`
        .byte   $04                             ; 9800 04                       .
L9801:  php                                     ; 9801 08                       .
L9802:  bmi     L9805                           ; 9802 30 01                    0.
        .byte   $91                             ; 9804 91                       .
L9805:  .byte   $02                             ; 9805 02                       .
        ora     ($51,x)                         ; 9806 01 51                    .Q
        .byte   $AF                             ; 9808 AF                       .
        rts                                     ; 9809 60                       `

; ----------------------------------------------------------------------------
        asl     L9801                           ; 980A 0E 01 98                 ...
        brk                                     ; 980D 00                       .
        .byte   $02                             ; 980E 02                       .
        .byte   $8F                             ; 980F 8F                       .
        .byte   $02                             ; 9810 02                       .
        sta     ($92),y                         ; 9811 91 92                    ..
        .byte   $13                             ; 9813 13                       .
        php                                     ; 9814 08                       .
        tya                                     ; 9815 98                       .
        .byte   $23                             ; 9816 23                       #
        .byte   $02                             ; 9817 02                       .
        .byte   $8F                             ; 9818 8F                       .
        ora     ($6D,x)                         ; 9819 01 6D                    .m
        .byte   $02                             ; 981B 02                       .
        cmp     $ED01                           ; 981C CD 01 ED                 ...
        .byte   $0F                             ; 981F 0F                       .
        ora     ($97,x)                         ; 9820 01 97                    ..
        .byte   $FA                             ; 9822 FA                       .
        .byte   $EF                             ; 9823 EF                       .
        .byte   $80                             ; 9824 80                       .
        .byte   $74                             ; 9825 74                       t
        .byte   $80                             ; 9826 80                       .
        .byte   $74                             ; 9827 74                       t
        .byte   $80                             ; 9828 80                       .
        .byte   $74                             ; 9829 74                       t
        .byte   $02                             ; 982A 02                       .
        .byte   $80                             ; 982B 80                       .
        ldy     #$04                            ; 982C A0 04                    ..
        php                                     ; 982E 08                       .
        .byte   $F3                             ; 982F F3                       .
        .byte   $02                             ; 9830 02                       .
        .byte   $93                             ; 9831 93                       .
        .byte   $02                             ; 9832 02                       .
        sta     ($93),y                         ; 9833 91 93                    ..
        .byte   $02                             ; 9835 02                       .
        sty     $02,x                           ; 9836 94 02                    ..
        stx     $98,y                           ; 9838 96 98                    ..
        and     ($01),y                         ; 983A 31 01                    1.
        .byte   $93                             ; 983C 93                       .
        .byte   $02                             ; 983D 02                       .
        ora     ($53,x)                         ; 983E 01 53                    .S
        ora     ($71,x)                         ; 9840 01 71                    .q
        .byte   $12                             ; 9842 12                       .
        pha                                     ; 9843 48                       H
        tya                                     ; 9844 98                       .
        lsr     $D102                           ; 9845 4E 02 D1                 N..
        ora     ($F1,x)                         ; 9848 01 F1                    ..
        asl     L9801                           ; 984A 0E 01 98                 ...
        and     $D101                           ; 984D 2D 01 D1                 -..
        ora     #$02                            ; 9850 09 02                    ..
        stx     $EA6C                           ; 9852 8E 6C EA                 .l.
        rts                                     ; 9855 60                       `

; ----------------------------------------------------------------------------
        .byte   $02                             ; 9856 02                       .
        tay                                     ; 9857 A8                       .
        tay                                     ; 9858 A8                       .
        .byte   $87                             ; 9859 87                       .
        dey                                     ; 985A 88                       .
        txa                                     ; 985B 8A                       .
        .byte   $02                             ; 985C 02                       .
        .byte   $87                             ; 985D 87                       .
        .byte   $02                             ; 985E 02                       .
        .byte   $83                             ; 985F 83                       .
        adc     $01                             ; 9860 65 01                    e.
        .byte   $C3                             ; 9862 C3                       .
        ora     ($63,x)                         ; 9863 01 63                    .c
        .byte   $02                             ; 9865 02                       .
        ldx     $A6                             ; 9866 A6 A6                    ..
        sta     $86                             ; 9868 85 86                    ..
        dey                                     ; 986A 88                       .
        adc     $60                             ; 986B 65 60                    e`
        adc     $80                             ; 986D 65 80                    e.
        adc     $80                             ; 986F 65 80                    e.
        adc     $02                             ; 9871 65 02                    e.
        .byte   $80                             ; 9873 80                       .
        .byte   $02                             ; 9874 02                       .
        ora     ($6A,x)                         ; 9875 01 6A                    .j
        ora     ($2A,x)                         ; 9877 01 2A                    .*
        ora     $077F                           ; 9879 0D 7F 07                 ...
        asl     $28                             ; 987C 06 28                    .(
        .byte   $27                             ; 987E 27                       '
        and     $23                             ; 987F 25 23                    %#
        and     ($03,x)                         ; 9881 21 03                    !.
        sec                                     ; 9883 38                       8
        rol     $40,x                           ; 9884 36 40                    6@
        ora     $1600                           ; 9886 0D 00 16                 ...
        .byte   $97                             ; 9889 97                       .
        .byte   $C3                             ; 988A C3                       .
        .byte   $17                             ; 988B 17                       .
        .byte   $04                             ; 988C 04                       .
        php                                     ; 988D 08                       .
        asl     $F0                             ; 988E 06 F0                    ..
        .byte   $07                             ; 9890 07                       .
        php                                     ; 9891 08                       .
        php                                     ; 9892 08                       .
        ora     $09                             ; 9893 05 09                    ..
        brk                                     ; 9895 00                       .
        .byte   $02                             ; 9896 02                       .
        .byte   $8F                             ; 9897 8F                       .
        lda     $0260                           ; 9898 AD 60 02                 .`.
        sta     $60AB                           ; 989B 8D AB 60                 ..`
        .byte   $02                             ; 989E 02                       .
        sta     $60AB                           ; 989F 8D AB 60                 ..`
        asl     $F5                             ; 98A2 06 F5                    ..
        .byte   $02                             ; 98A4 02                       .
        .byte   $8B                             ; 98A5 8B                       .
        .byte   $02                             ; 98A6 02                       .
        sta     $068F                           ; 98A7 8D 8F 06                 ...
        iny                                     ; 98AA C8                       .
        .byte   $02                             ; 98AB 02                       .
        .byte   $8B                             ; 98AC 8B                       .
        dey                                     ; 98AD 88                       .
        clc                                     ; 98AE 18                       .
        rti                                     ; 98AF 40                       @

; ----------------------------------------------------------------------------
        pla                                     ; 98B0 68                       h
        txa                                     ; 98B1 8A                       .
        .byte   $02                             ; 98B2 02                       .
        dey                                     ; 98B3 88                       .
        .byte   $02                             ; 98B4 02                       .
        sta     $86                             ; 98B5 85 86                    ..
        .byte   $02                             ; 98B7 02                       .
        dey                                     ; 98B8 88                       .
        .byte   $02                             ; 98B9 02                       .
        sta     ($81,x)                         ; 98BA 81 81                    ..
        php                                     ; 98BC 08                       .
        .byte   $02                             ; 98BD 02                       .
        ora     #$00                            ; 98BE 09 00                    ..
        clc                                     ; 98C0 18                       .
        cpy     #$8D                            ; 98C1 C0 8D                    ..
        ror     a                               ; 98C3 6A                       j
        adc     $0660                           ; 98C4 6D 60 06                 m`.
        .byte   $FF                             ; 98C7 FF                       .
        .byte   $02                             ; 98C8 02                       .
        stx     a:L0018                         ; 98C9 8E 18 00                 ...
        asl     L9801                           ; 98CC 0E 01 98                 ...
        sty     a:$04                           ; 98CF 8C 04 00                 ...
        .byte   $04                             ; 98D2 04                       .
        brk                                     ; 98D3 00                       .
        php                                     ; 98D4 08                       .
        .byte   $02                             ; 98D5 02                       .
        asl     $BE                             ; 98D6 06 BE                    ..
        .byte   $07                             ; 98D8 07                       .
        php                                     ; 98D9 08                       .
        ora     #$01                            ; 98DA 09 01                    ..
        clc                                     ; 98DC 18                       .
        cpy     #$97                            ; 98DD C0 97                    ..
        .byte   $74                             ; 98DF 74                       t
        .byte   $74                             ; 98E0 74                       t
        rts                                     ; 98E1 60                       `

; ----------------------------------------------------------------------------
        .byte   $02                             ; 98E2 02                       .
        .byte   $97                             ; 98E3 97                       .
        sta     $0274,y                         ; 98E4 99 74 02                 .t.
        .byte   $9B                             ; 98E7 9B                       .
        sty     $08,x                           ; 98E8 94 08                    ..
        .byte   $12                             ; 98EA 12                       .
        .byte   $03                             ; 98EB 03                       .
        pla                                     ; 98EC 68                       h
        .byte   $63                             ; 98ED 63                       c
        ror     $6B                             ; 98EE 66 6B                    fk
        .byte   $63                             ; 98F0 63                       c
        ror     $6D                             ; 98F1 66 6D                    fm
        .byte   $63                             ; 98F3 63                       c
        ror     $6B                             ; 98F4 66 6B                    fk
        .byte   $63                             ; 98F6 63                       c
        ror     $6F                             ; 98F7 66 6F                    fo
        .byte   $63                             ; 98F9 63                       c
        pla                                     ; 98FA 68                       h
        .byte   $63                             ; 98FB 63                       c
        php                                     ; 98FC 08                       .
        .byte   $02                             ; 98FD 02                       .
        .byte   $12                             ; 98FE 12                       .
        php                                     ; 98FF 08                       .
        .byte   $99                             ; 9900 99                       .
L9901:  rol     a                               ; 9901 2A                       *
        .byte   $03                             ; 9902 03                       .
L9903:  stx     $72,y                           ; 9903 96 72                    .r
        .byte   $72                             ; 9905 72                       r
        rts                                     ; 9906 60                       `

; ----------------------------------------------------------------------------
        .byte   $02                             ; 9907 02                       .
        sty     $96,x                           ; 9908 94 96                    ..
        adc     $AD01                           ; 990A 6D 01 AD                 m..
        ora     ($6D,x)                         ; 990D 01 6D                    .m
        php                                     ; 990F 08                       .
        .byte   $12                             ; 9910 12                       .
        ror     $7E79,x                         ; 9911 7E 79 7E                 ~y~
        .byte   $03                             ; 9914 03                       .
        pla                                     ; 9915 68                       h
        adc     ($66,x)                         ; 9916 61 66                    af
        ror     a                               ; 9918 6A                       j
        adc     ($08,x)                         ; 9919 61 08                    a.
        .byte   $02                             ; 991B 02                       .
        ora     #$01                            ; 991C 09 01                    ..
        clc                                     ; 991E 18                       .
        brk                                     ; 991F 00                       .
        stx     $61                             ; 9920 86 61                    .a
        ror     $60                             ; 9922 66 60                    f`
        .byte   $02                             ; 9924 02                       .
        .byte   $87                             ; 9925 87                       .
        asl     L9801                           ; 9926 0E 01 98                 ...
        .byte   $D2                             ; 9929 D2                       .
        sta     ($03,x)                         ; 992A 81 03                    ..
        .byte   $74                             ; 992C 74                       t
        .byte   $74                             ; 992D 74                       t
        rts                                     ; 992E 60                       `

; ----------------------------------------------------------------------------
        .byte   $02                             ; 992F 02                       .
        .byte   $9B                             ; 9930 9B                       .
        sta     $0174,y                         ; 9931 99 74 01                 .t.
        ldy     $01,x                           ; 9934 B4 01                    ..
        .byte   $74                             ; 9936 74                       t
        sta     $6803,y                         ; 9937 99 03 68                 ..h
        adc     $6D60                           ; 993A 6D 60 6D                 m`m
        .byte   $80                             ; 993D 80                       .
        .byte   $6D                             ; 993E 6D                       m
        .byte   $80                             ; 993F 80                       .
L9940:  asl     $FA                             ; 9940 06 FA                    ..
        sta     $64                             ; 9942 85 64                    .d
        .byte   $83                             ; 9944 83                       .
        .byte   $04                             ; 9945 04                       .
        php                                     ; 9946 08                       .
        asl     $F0                             ; 9947 06 F0                    ..
        php                                     ; 9949 08                       .
        ora     $02                             ; 994A 05 02                    ..
        .byte   $8F                             ; 994C 8F                       .
        lda     $2C60                           ; 994D AD 60 2C                 .`,
        ora     ($8D,x)                         ; 9950 01 8D                    ..
        .byte   $02                             ; 9952 02                       .
        ora     ($4D,x)                         ; 9953 01 4D                    .M
        .byte   $AB                             ; 9955 AB                       .
        rts                                     ; 9956 60                       `

; ----------------------------------------------------------------------------
        bit     L8D01                           ; 9957 2C 01 8D                 ,..
        .byte   $02                             ; 995A 02                       .
        ora     ($4D,x)                         ; 995B 01 4D                    .M
        .byte   $02                             ; 995D 02                       .
        .byte   $8B                             ; 995E 8B                       .
        asl     $FF                             ; 995F 06 FF                    ..
        .byte   $03                             ; 9961 03                       .
        stx     $B7,y                           ; 9962 96 B7                    ..
        ldx     a:$12,y                         ; 9964 BE 12 00                 ...
        sta     $0378,y                         ; 9967 99 78 03                 .x.
        tax                                     ; 996A AA                       .
        .byte   $03                             ; 996B 03                       .
        ldx     $B9,y                           ; 996C B6 B9                    ..
        lda     $A803,x                         ; 996E BD 03 A8                 ...
        tax                                     ; 9971 AA                       .
        .byte   $AB                             ; 9972 AB                       .
        tax                                     ; 9973 AA                       .
        asl     L9901                           ; 9974 0E 01 99                 ...
        eor     $03                             ; 9977 45 03                    E.
        lda     $A7A3                           ; 9979 AD A3 A7                 ...
        tax                                     ; 997C AA                       .
        pla                                     ; 997D 68                       h
        rts                                     ; 997E 60                       `

; ----------------------------------------------------------------------------
        .byte   $6F                             ; 997F 6F                       o
        .byte   $80                             ; 9980 80                       .
        .byte   $6F                             ; 9981 6F                       o
        .byte   $80                             ; 9982 80                       .
        .byte   $02                             ; 9983 02                       .
        ora     ($6F,x)                         ; 9984 01 6F                    .o
        ora     ($2F,x)                         ; 9986 01 2F                    ./
        ora     $077F                           ; 9988 0D 7F 07                 ...
        asl     $2D                             ; 998B 06 2D                    .-
        .byte   $2B                             ; 998D 2B                       +
        rol     a                               ; 998E 2A                       *
        plp                                     ; 998F 28                       (
        rol     $25                             ; 9990 26 25                    &%
        .byte   $23                             ; 9992 23                       #
        ldy     #$40                            ; 9993 A0 40                    .@
        ora     $0800                           ; 9995 0D 00 08                 ...
        .byte   $12                             ; 9998 12                       .
        .byte   $07                             ; 9999 07                       .
        ora     #$04                            ; 999A 09 04                    ..
        php                                     ; 999C 08                       .
        .byte   $04                             ; 999D 04                       .
        php                                     ; 999E 08                       .
        sty     L8865                           ; 999F 8C 65 88                 .e.
        adc     $8F                             ; 99A2 65 8F                    e.
        sty     L8885                           ; 99A4 8C 85 88                 ...
        .byte   $8F                             ; 99A7 8F                       .
        asl     L9901                           ; 99A8 0E 01 99                 ...
        sta     $0804,x                         ; 99AB 9D 04 08                 ...
        stx     L8865                           ; 99AE 8E 65 88                 .e.
        adc     $8F                             ; 99B1 65 8F                    e.
        stx     L8A85                           ; 99B3 8E 85 8A                 ...
        sta     $0E                             ; 99B6 85 0E                    ..
        ora     ($99,x)                         ; 99B8 01 99                    ..
        ldy     $010F                           ; 99BA AC 0F 01                 ...
        sta     $089B,y                         ; 99BD 99 9B 08                 ...
        ora     L0018                           ; 99C0 05 18                    ..
        rti                                     ; 99C2 40                       @

; ----------------------------------------------------------------------------
        asl     $D2                             ; 99C3 06 D2                    ..
        pla                                     ; 99C5 68                       h
        .byte   $03                             ; 99C6 03                       .
        sty     $96,x                           ; 99C7 94 96                    ..
        .byte   $02                             ; 99C9 02                       .
        sta     L9D02,y                         ; 99CA 99 02 9D                 ...
        .byte   $02                             ; 99CD 02                       .
        .byte   $03                             ; 99CE 03                       .
        dey                                     ; 99CF 88                       .
        sta     $036C                           ; 99D0 8D 6C 03                 .l.
        tya                                     ; 99D3 98                       .
        .byte   $9B                             ; 99D4 9B                       .
        .byte   $02                             ; 99D5 02                       .
        sta     L9F02,x                         ; 99D6 9D 02 9F                 ...
        .byte   $02                             ; 99D9 02                       .
        .byte   $03                             ; 99DA 03                       .
        txa                                     ; 99DB 8A                       .
        sty     $036B                           ; 99DC 8C 6B 03                 .k.
        .byte   $97                             ; 99DF 97                       .
        .byte   $9B                             ; 99E0 9B                       .
        .byte   $02                             ; 99E1 02                       .
        .byte   $9E                             ; 99E2 9E                       .
        .byte   $02                             ; 99E3 02                       .
        .byte   $03                             ; 99E4 03                       .
        dey                                     ; 99E5 88                       .
        .byte   $02                             ; 99E6 02                       .
        txa                                     ; 99E7 8A                       .
        .byte   $8B                             ; 99E8 8B                       .
        ror     a                               ; 99E9 6A                       j
        rts                                     ; 99EA 60                       `

; ----------------------------------------------------------------------------
        ror     a                               ; 99EB 6A                       j
        .byte   $80                             ; 99EC 80                       .
        ror     a                               ; 99ED 6A                       j
        .byte   $80                             ; 99EE 80                       .
        ror     a                               ; 99EF 6A                       j
        .byte   $02                             ; 99F0 02                       .
        .byte   $80                             ; 99F1 80                       .
        .byte   $A7                             ; 99F2 A7                       .
        asl     $98,x                           ; 99F3 16 98                    ..
        bne     L9A0E                           ; 99F5 D0 17                    ..
        .byte   $04                             ; 99F7 04                       .
        brk                                     ; 99F8 00                       .
        asl     $F0                             ; 99F9 06 F0                    ..
        php                                     ; 99FB 08                       .
        brk                                     ; 99FC 00                       .
        ora     #$03                            ; 99FD 09 03                    ..
        .byte   $04                             ; 99FF 04                       .
        brk                                     ; 9A00 00                       .
        .byte   $02                             ; 9A01 02                       .
L9A02:  dey                                     ; 9A02 88                       .
L9A03:  .byte   $6F                             ; 9A03 6F                       o
        rts                                     ; 9A04 60                       `

; ----------------------------------------------------------------------------
        .byte   $6F                             ; 9A05 6F                       o
        .byte   $83                             ; 9A06 83                       .
        asl     L9903                           ; 9A07 0E 03 99                 ...
        .byte   $FF                             ; 9A0A FF                       .
        .byte   $04                             ; 9A0B 04                       .
        brk                                     ; 9A0C 00                       .
        .byte   $02                             ; 9A0D 02                       .
L9A0E:  stx     $6D                             ; 9A0E 86 6D                    .m
        rts                                     ; 9A10 60                       `

; ----------------------------------------------------------------------------
        adc     $0E81                           ; 9A11 6D 81 0E                 m..
        .byte   $02                             ; 9A14 02                       .
        txs                                     ; 9A15 9A                       .
        .byte   $0B                             ; 9A16 0B                       .
        .byte   $02                             ; 9A17 02                       .
        stx     $66                             ; 9A18 86 66                    .f
        rts                                     ; 9A1A 60                       `

; ----------------------------------------------------------------------------
        .byte   $67                             ; 9A1B 67                       g
        .byte   $93                             ; 9A1C 93                       .
        .byte   $0F                             ; 9A1D 0F                       .
        ora     ($99,x)                         ; 9A1E 01 99                    ..
        .byte   $F7                             ; 9A20 F7                       .
        .byte   $04                             ; 9A21 04                       .
        brk                                     ; 9A22 00                       .
        .byte   $04                             ; 9A23 04                       .
        brk                                     ; 9A24 00                       .
        .byte   $04                             ; 9A25 04                       .
        brk                                     ; 9A26 00                       .
        .byte   $02                             ; 9A27 02                       .
        dey                                     ; 9A28 88                       .
        .byte   $6F                             ; 9A29 6F                       o
        rts                                     ; 9A2A 60                       `

; ----------------------------------------------------------------------------
        .byte   $6F                             ; 9A2B 6F                       o
        .byte   $83                             ; 9A2C 83                       .
        asl     L9A03                           ; 9A2D 0E 03 9A                 ...
        and     $13                             ; 9A30 25 13                    %.
        brk                                     ; 9A32 00                       .
        txs                                     ; 9A33 9A                       .
        .byte   $4B                             ; 9A34 4B                       K
        .byte   $04                             ; 9A35 04                       .
        brk                                     ; 9A36 00                       .
        .byte   $02                             ; 9A37 02                       .
        stx     $6D                             ; 9A38 86 6D                    .m
        rts                                     ; 9A3A 60                       `

; ----------------------------------------------------------------------------
        adc     $0E81                           ; 9A3B 6D 81 0E                 m..
        .byte   $02                             ; 9A3E 02                       .
        txs                                     ; 9A3F 9A                       .
        and     $02,x                           ; 9A40 35 02                    5.
        stx     $66                             ; 9A42 86 66                    .f
        rts                                     ; 9A44 60                       `

; ----------------------------------------------------------------------------
        .byte   $67                             ; 9A45 67                       g
        .byte   $93                             ; 9A46 93                       .
        .byte   $0F                             ; 9A47 0F                       .
        ora     ($9A,x)                         ; 9A48 01 9A                    ..
        .byte   $23                             ; 9A4A 23                       #
        .byte   $02                             ; 9A4B 02                       .
        sta     $6074                           ; 9A4C 8D 74 60                 .t`
        .byte   $74                             ; 9A4F 74                       t
        dey                                     ; 9A50 88                       .
        .byte   $02                             ; 9A51 02                       .
        sta     $6074                           ; 9A52 8D 74 60                 .t`
        .byte   $74                             ; 9A55 74                       t
        dey                                     ; 9A56 88                       .
        sta     $6D6D                           ; 9A57 8D 6D 6D                 .mm
        rts                                     ; 9A5A 60                       `

; ----------------------------------------------------------------------------
        adc     $6D80                           ; 9A5B 6D 80 6D                 m.m
        .byte   $80                             ; 9A5E 80                       .
        sta     L8B6C                           ; 9A5F 8D 6C 8B                 .l.
        .byte   $04                             ; 9A62 04                       .
        brk                                     ; 9A63 00                       .
        .byte   $04                             ; 9A64 04                       .
        brk                                     ; 9A65 00                       .
        .byte   $02                             ; 9A66 02                       .
        .byte   $8B                             ; 9A67 8B                       .
        .byte   $72                             ; 9A68 72                       r
        rts                                     ; 9A69 60                       `

; ----------------------------------------------------------------------------
        .byte   $72                             ; 9A6A 72                       r
        stx     $0E                             ; 9A6B 86 0E                    ..
        .byte   $03                             ; 9A6D 03                       .
        txs                                     ; 9A6E 9A                       .
        .byte   $64                             ; 9A6F 64                       d
        .byte   $13                             ; 9A70 13                       .
        brk                                     ; 9A71 00                       .
        txs                                     ; 9A72 9A                       .
        txa                                     ; 9A73 8A                       .
        .byte   $04                             ; 9A74 04                       .
        brk                                     ; 9A75 00                       .
        .byte   $02                             ; 9A76 02                       .
        txa                                     ; 9A77 8A                       .
        adc     ($60),y                         ; 9A78 71 60                    q`
        adc     ($85),y                         ; 9A7A 71 85                    q.
        asl     L9A02                           ; 9A7C 0E 02 9A                 ...
        .byte   $74                             ; 9A7F 74                       t
        .byte   $02                             ; 9A80 02                       .
        txa                                     ; 9A81 8A                       .
        ror     a                               ; 9A82 6A                       j
        rts                                     ; 9A83 60                       `

; ----------------------------------------------------------------------------
        ror     a                               ; 9A84 6A                       j
        stx     $0F,y                           ; 9A85 96 0F                    ..
        ora     ($9A,x)                         ; 9A87 01 9A                    ..
        .byte   $62                             ; 9A89 62                       b
        ora     #$02                            ; 9A8A 09 02                    ..
        .byte   $02                             ; 9A8C 02                       .
        .byte   $8F                             ; 9A8D 8F                       .
        ror     $60,x                           ; 9A8E 76 60                    v`
        ror     $8A,x                           ; 9A90 76 8A                    v.
        .byte   $02                             ; 9A92 02                       .
        .byte   $8F                             ; 9A93 8F                       .
        ror     $60,x                           ; 9A94 76 60                    v`
        ror     $8A,x                           ; 9A96 76 8A                    v.
L9A98:  ora     #$03                            ; 9A98 09 03                    ..
        dey                                     ; 9A9A 88                       .
        rts                                     ; 9A9B 60                       `

; ----------------------------------------------------------------------------
        pla                                     ; 9A9C 68                       h
        rts                                     ; 9A9D 60                       `

; ----------------------------------------------------------------------------
        pla                                     ; 9A9E 68                       h
        .byte   $80                             ; 9A9F 80                       .
        pla                                     ; 9AA0 68                       h
        .byte   $02                             ; 9AA1 02                       .
        .byte   $80                             ; 9AA2 80                       .
        ora     #$02                            ; 9AA3 09 02                    ..
        asl     $FF                             ; 9AA5 06 FF                    ..
        ora     ($48,x)                         ; 9AA7 01 48                    .H
        ora     $017F                           ; 9AA9 0D 7F 01                 ...
        lsr     a                               ; 9AAC 4A                       J
        .byte   $4B                             ; 9AAD 4B                       K
        jmp     L4E4D                           ; 9AAE 4C 4D 4E                 LMN

; ----------------------------------------------------------------------------
        .byte   $4F                             ; 9AB1 4F                       O
        bvc     L9AC1                           ; 9AB2 50 0D                    P.
        brk                                     ; 9AB4 00                       .
        .byte   $04                             ; 9AB5 04                       .
        brk                                     ; 9AB6 00                       .
        .byte   $04                             ; 9AB7 04                       .
        brk                                     ; 9AB8 00                       .
        asl     $E6                             ; 9AB9 06 E6                    ..
        .byte   $02                             ; 9ABB 02                       .
        sta     ($02),y                         ; 9ABC 91 02                    ..
        adc     ($02),y                         ; 9ABE 71 02                    q.
        rts                                     ; 9AC0 60                       `

; ----------------------------------------------------------------------------
L9AC1:  tya                                     ; 9AC1 98                       .
        asl     L9A03                           ; 9AC2 0E 03 9A                 ...
        .byte   $B7                             ; 9AC5 B7                       .
        .byte   $04                             ; 9AC6 04                       .
        brk                                     ; 9AC7 00                       .
        .byte   $02                             ; 9AC8 02                       .
        stx     $02,y                           ; 9AC9 96 02                    ..
        ror     $02,x                           ; 9ACB 76 02                    v.
        rts                                     ; 9ACD 60                       `

; ----------------------------------------------------------------------------
        sta     $020E,x                         ; 9ACE 9D 0E 02                 ...
        txs                                     ; 9AD1 9A                       .
        dec     $02                             ; 9AD2 C6 02                    ..
        stx     $02,y                           ; 9AD4 96 02                    ..
        sta     $94,x                           ; 9AD6 95 94                    ..
        .byte   $0F                             ; 9AD8 0F                       .
        ora     ($9A,x)                         ; 9AD9 01 9A                    ..
        lda     $02,x                           ; 9ADB B5 02                    ..
        .byte   $8F                             ; 9ADD 8F                       .
        .byte   $02                             ; 9ADE 02                       .
        .byte   $6F                             ; 9ADF 6F                       o
        .byte   $02                             ; 9AE0 02                       .
        rts                                     ; 9AE1 60                       `

; ----------------------------------------------------------------------------
        stx     $02,y                           ; 9AE2 96 02                    ..
        .byte   $8F                             ; 9AE4 8F                       .
        .byte   $02                             ; 9AE5 02                       .
        .byte   $6F                             ; 9AE6 6F                       o
        .byte   $02                             ; 9AE7 02                       .
        rts                                     ; 9AE8 60                       `

; ----------------------------------------------------------------------------
        stx     $02,y                           ; 9AE9 96 02                    ..
        sty     $02,x                           ; 9AEB 94 02                    ..
        .byte   $74                             ; 9AED 74                       t
        .byte   $02                             ; 9AEE 02                       .
        rts                                     ; 9AEF 60                       `

; ----------------------------------------------------------------------------
        .byte   $9B                             ; 9AF0 9B                       .
        .byte   $02                             ; 9AF1 02                       .
        sty     $02,x                           ; 9AF2 94 02                    ..
        .byte   $74                             ; 9AF4 74                       t
        .byte   $02                             ; 9AF5 02                       .
        rts                                     ; 9AF6 60                       `

; ----------------------------------------------------------------------------
        .byte   $9B                             ; 9AF7 9B                       .
        .byte   $02                             ; 9AF8 02                       .
        sta     $6D02                           ; 9AF9 8D 02 6D                 ..m
        .byte   $02                             ; 9AFC 02                       .
        rts                                     ; 9AFD 60                       `

; ----------------------------------------------------------------------------
        sty     $02,x                           ; 9AFE 94 02                    ..
        .byte   $8D                             ; 9B00 8D                       .
        .byte   $02                             ; 9B01 02                       .
L9B02:  adc     $6002                           ; 9B02 6D 02 60                 m.`
        .byte   $94                             ; 9B05 94                       .
L9B06:  ror     $60,x                           ; 9B06 76 60                    v`
        ror     $80,x                           ; 9B08 76 80                    v.
        ror     $80,x                           ; 9B0A 76 80                    v.
        .byte   $76                             ; 9B0C 76                       v
L9B0D:  .byte   $02                             ; 9B0D 02                       .
        .byte   $80                             ; 9B0E 80                       .
        .byte   $AF                             ; 9B0F AF                       .
        ora     #$03                            ; 9B10 09 03                    ..
        asl     $9A,x                           ; 9B12 16 9A                    ..
        and     ($17,x)                         ; 9B14 21 17                    !.
        php                                     ; 9B16 08                       .
L9B17:  .byte   $14                             ; 9B17 14                       .
        ora     #$01                            ; 9B18 09 01                    ..
        .byte   $0B                             ; 9B1A 0B                       .
        .byte   $FF                             ; 9B1B FF                       .
        .byte   $04                             ; 9B1C 04                       .
        brk                                     ; 9B1D 00                       .
        .byte   $04                             ; 9B1E 04                       .
        brk                                     ; 9B1F 00                       .
        asl     $C8                             ; 9B20 06 C8                    ..
        .byte   $07                             ; 9B22 07                       .
        ora     #$64                            ; 9B23 09 64                    .d
        .byte   $07                             ; 9B25 07                       .
        php                                     ; 9B26 08                       .
        ror     $076E                           ; 9B27 6E 6E 07                 nn.
        ora     #$64                            ; 9B2A 09 64                    .d
        asl     $2E                             ; 9B2C 06 2E                    ..
        adc     #$06                            ; 9B2E 69 06                    i.
        iny                                     ; 9B30 C8                       .
        .byte   $07                             ; 9B31 07                       .
        php                                     ; 9B32 08                       .
        ror     $6D6E                           ; 9B33 6E 6E 6D                 nnm
        asl     L9B06                           ; 9B36 0E 06 9B                 ...
        asl     L6F64,x                         ; 9B39 1E 64 6F                 .do
        .byte   $6F                             ; 9B3C 6F                       o
        asl     $2E                             ; 9B3D 06 2E                    ..
        adc     #$6E                            ; 9B3F 69 6E                    in
        adc     #$06                            ; 9B41 69 06                    i.
        iny                                     ; 9B43 C8                       .
        .byte   $6F                             ; 9B44 6F                       o
        .byte   $6F                             ; 9B45 6F                       o
        .byte   $0F                             ; 9B46 0F                       .
        .byte   $03                             ; 9B47 03                       .
        .byte   $9B                             ; 9B48 9B                       .
        .byte   $1C                             ; 9B49 1C                       .
        .byte   $04                             ; 9B4A 04                       .
        brk                                     ; 9B4B 00                       .
        .byte   $04                             ; 9B4C 04                       .
        brk                                     ; 9B4D 00                       .
        .byte   $07                             ; 9B4E 07                       .
        ora     #$64                            ; 9B4F 09 64                    .d
        .byte   $6F                             ; 9B51 6F                       o
        .byte   $6F                             ; 9B52 6F                       o
        .byte   $64                             ; 9B53 64                       d
        asl     $2E                             ; 9B54 06 2E                    ..
        adc     #$06                            ; 9B56 69 06                    i.
        iny                                     ; 9B58 C8                       .
        .byte   $6F                             ; 9B59 6F                       o
        .byte   $6F                             ; 9B5A 6F                       o
        .byte   $6F                             ; 9B5B 6F                       o
        asl     L9B0D                           ; 9B5C 0E 0D 9B                 ...
        .byte   $4C                             ; 9B5F 4C                       L
L9B60:  .byte   $64                             ; 9B60 64                       d
        .byte   $6F                             ; 9B61 6F                       o
        asl     $2E                             ; 9B62 06 2E                    ..
        adc     #$6F                            ; 9B64 69 6F                    io
        .byte   $64                             ; 9B66 64                       d
        adc     #$6F                            ; 9B67 69 6F                    io
        .byte   $6F                             ; 9B69 6F                       o
        adc     #$06                            ; 9B6A 69 06                    i.
        iny                                     ; 9B6C C8                       .
        .byte   $6F                             ; 9B6D 6F                       o
        .byte   $6F                             ; 9B6E 6F                       o
        asl     $2E                             ; 9B6F 06 2E                    ..
        adc     #$64                            ; 9B71 69 64                    id
        adc     #$69                            ; 9B73 69 69                    ii
        adc     #$04                            ; 9B75 69 04                    i.
        brk                                     ; 9B77 00                       .
        asl     $C8                             ; 9B78 06 C8                    ..
        .byte   $64                             ; 9B7A 64                       d
        .byte   $6F                             ; 9B7B 6F                       o
        .byte   $6F                             ; 9B7C 6F                       o
        .byte   $63                             ; 9B7D 63                       c
        asl     $2E                             ; 9B7E 06 2E                    ..
        adc     #$06                            ; 9B80 69 06                    i.
        iny                                     ; 9B82 C8                       .
        .byte   $6F                             ; 9B83 6F                       o
        .byte   $6F                             ; 9B84 6F                       o
        .byte   $6F                             ; 9B85 6F                       o
        asl     L9B17                           ; 9B86 0E 17 9B                 ...
        ror     $04,x                           ; 9B89 76 04                    v.
        brk                                     ; 9B8B 00                       .
        .byte   $04                             ; 9B8C 04                       .
        brk                                     ; 9B8D 00                       .
        .byte   $64                             ; 9B8E 64                       d
        .byte   $6F                             ; 9B8F 6F                       o
        .byte   $6F                             ; 9B90 6F                       o
        .byte   $64                             ; 9B91 64                       d
        asl     $2E                             ; 9B92 06 2E                    ..
        adc     #$06                            ; 9B94 69 06                    i.
        iny                                     ; 9B96 C8                       .
        .byte   $6F                             ; 9B97 6F                       o
        .byte   $6F                             ; 9B98 6F                       o
        .byte   $6F                             ; 9B99 6F                       o
        asl     L9B06                           ; 9B9A 0E 06 9B                 ...
        sty     L6F64                           ; 9B9D 8C 64 6F                 .do
        .byte   $6F                             ; 9BA0 6F                       o
        asl     $2E                             ; 9BA1 06 2E                    ..
        adc     #$6E                            ; 9BA3 69 6E                    in
        adc     #$06                            ; 9BA5 69 06                    i.
        iny                                     ; 9BA7 C8                       .
        .byte   $6F                             ; 9BA8 6F                       o
        .byte   $6F                             ; 9BA9 6F                       o
        .byte   $0F                             ; 9BAA 0F                       .
        ora     ($9B,x)                         ; 9BAB 01 9B                    ..
        txa                                     ; 9BAD 8A                       .
        asl     $9B,x                           ; 9BAE 16 9B                    ..
        lsr     a                               ; 9BB0 4A                       J
        .byte   $17                             ; 9BB1 17                       .
        brk                                     ; 9BB2 00                       .
        .byte   $9B                             ; 9BB3 9B                       .
        .byte   $BB                             ; 9BB4 BB                       .
        .byte   $9C                             ; 9BB5 9C                       .
        cmp     $9E                             ; 9BB6 C5 9E                    ..
        ora     $9E                             ; 9BB8 05 9E                    ..
        sty     $0205                           ; 9BBA 8C 05 02                 ...
        brk                                     ; 9BBD 00                       .
        asl     a                               ; 9BBE 0A                       .
        .byte   $07                             ; 9BBF 07                       .
        .byte   $04                             ; 9BC0 04                       .
        php                                     ; 9BC1 08                       .
        asl     $E6                             ; 9BC2 06 E6                    ..
        .byte   $07                             ; 9BC4 07                       .
        ora     #$09                            ; 9BC5 09 09                    ..
        ora     (L0018,x)                       ; 9BC7 01 18                    ..
        cpy     #$04                            ; 9BC9 C0 04                    ..
        php                                     ; 9BCB 08                       .
        php                                     ; 9BCC 08                       .
        .byte   $07                             ; 9BCD 07                       .
        .byte   $02                             ; 9BCE 02                       .
        cpy     $0408                           ; 9BCF CC 08 04                 ...
        sty     $0880                           ; 9BD2 8C 80 08                 ...
        .byte   $07                             ; 9BD5 07                       .
        .byte   $02                             ; 9BD6 02                       .
        cmp     $0408                           ; 9BD7 CD 08 04                 ...
        sta     $0E80                           ; 9BDA 8D 80 0E                 ...
        ora     ($9B,x)                         ; 9BDD 01 9B                    ..
        dex                                     ; 9BDF CA                       .
        clc                                     ; 9BE0 18                       .
        brk                                     ; 9BE1 00                       .
        php                                     ; 9BE2 08                       .
        ora     ($02,x)                         ; 9BE3 01 02                    ..
        ldy     L8CD3                           ; 9BE5 AC D3 8C                 ...
        ora     $027F                           ; 9BE8 0D 7F 02                 ...
        cmp     $0DAF                           ; 9BEB CD AF 0D                 ...
        brk                                     ; 9BEE 00                       .
        .byte   $02                             ; 9BEF 02                       .
        cpy     $7F0D                           ; 9BF0 CC 0D 7F                 ...
        sta     $0D88                           ; 9BF3 8D 88 0D                 ...
        brk                                     ; 9BF6 00                       .
        .byte   $E7                             ; 9BF7 E7                       .
        .byte   $02                             ; 9BF8 02                       .
        ldy     L8CD3                           ; 9BF9 AC D3 8C                 ...
        ora     $027F                           ; 9BFC 0D 7F 02                 ...
        .byte   $CD                             ; 9BFF CD                       .
        .byte   $AF                             ; 9C00 AF                       .
L9C01:  .byte   $06                             ; 9C01 06                       .
L9C02:  sed                                     ; 9C02 F8                       .
        cpx     a:$0D                           ; 9C03 EC 0D 00                 ...
        sbc     ($08),y                         ; 9C06 F1 08                    ..
        .byte   $07                             ; 9C08 07                       .
        clc                                     ; 9C09 18                       .
        cpy     #$01                            ; 9C0A C0 01                    ..
        .byte   $AF                             ; 9C0C AF                       .
        php                                     ; 9C0D 08                       .
        ora     ($CF,x)                         ; 9C0E 01 CF                    ..
        php                                     ; 9C10 08                       .
        .byte   $07                             ; 9C11 07                       .
        ora     ($8F,x)                         ; 9C12 01 8F                    ..
        txa                                     ; 9C14 8A                       .
        .byte   $A7                             ; 9C15 A7                       .
        tay                                     ; 9C16 A8                       .
        ldy     $01AF                           ; 9C17 AC AF 01                 ...
        lda     $0108                           ; 9C1A AD 08 01                 ...
        cmp     $0708                           ; 9C1D CD 08 07                 ...
        .byte   $02                             ; 9C20 02                       .
        ora     ($8D,x)                         ; 9C21 01 8D                    ..
        .byte   $63                             ; 9C23 63                       c
        .byte   $A3                             ; 9C24 A3                       .
        lda     $A6                             ; 9C25 A5 A6                    ..
        tax                                     ; 9C27 AA                       .
        ora     #$02                            ; 9C28 09 02                    ..
        brk                                     ; 9C2A 00                       .
        sta     ($80,x)                         ; 9C2B 81 80                    ..
        .byte   $03                             ; 9C2D 03                       .
        tya                                     ; 9C2E 98                       .
        .byte   $80                             ; 9C2F 80                       .
        .byte   $97                             ; 9C30 97                       .
        tya                                     ; 9C31 98                       .
        .byte   $9B                             ; 9C32 9B                       .
        .byte   $80                             ; 9C33 80                       .
        txs                                     ; 9C34 9A                       .
        .byte   $80                             ; 9C35 80                       .
        sta     L9D9A,y                         ; 9C36 99 9A 9D                 ...
        .byte   $80                             ; 9C39 80                       .
        .byte   $9C                             ; 9C3A 9C                       .
        .byte   $80                             ; 9C3B 80                       .
        .byte   $9B                             ; 9C3C 9B                       .
        .byte   $9C                             ; 9C3D 9C                       .
        .byte   $9F                             ; 9C3E 9F                       .
        .byte   $80                             ; 9C3F 80                       .
        .byte   $9E                             ; 9C40 9E                       .
        .byte   $80                             ; 9C41 80                       .
        sta     $069E,x                         ; 9C42 9D 9E 06                 ...
        .byte   $FF                             ; 9C45 FF                       .
        .byte   $03                             ; 9C46 03                       .
        txa                                     ; 9C47 8A                       .
        sty     L8C8A                           ; 9C48 8C 8A 8C                 ...
        .byte   $07                             ; 9C4B 07                       .
        ora     $8A                             ; 9C4C 05 8A                    ..
        sty     L8C8A                           ; 9C4E 8C 8A 8C                 ...
        .byte   $07                             ; 9C51 07                       .
        .byte   $04                             ; 9C52 04                       .
        txa                                     ; 9C53 8A                       .
        sty     L8C8A                           ; 9C54 8C 8A 8C                 ...
        brk                                     ; 9C57 00                       .
        ora     ($AA,x)                         ; 9C58 01 AA                    ..
        .byte   $07                             ; 9C5A 07                       .
        .byte   $03                             ; 9C5B 03                       .
        dex                                     ; 9C5C CA                       .
        .byte   $07                             ; 9C5D 07                       .
        .byte   $02                             ; 9C5E 02                       .
        ora     ($AA,x)                         ; 9C5F 01 AA                    ..
        .byte   $04                             ; 9C61 04                       .
        brk                                     ; 9C62 00                       .
        .byte   $07                             ; 9C63 07                       .
        ora     #$06                            ; 9C64 09 06                    ..
        .byte   $FF                             ; 9C66 FF                       .
        clc                                     ; 9C67 18                       .
        rti                                     ; 9C68 40                       @

; ----------------------------------------------------------------------------
        cmp     L8D97,y                         ; 9C69 D9 97 8D                 ...
        .byte   $93                             ; 9C6C 93                       .
        sta     L97D9                           ; 9C6D 8D D9 97                 ...
        sta     L8D93                           ; 9C70 8D 93 8D                 ...
        asl     $F5                             ; 9C73 06 F5                    ..
        .byte   $02                             ; 9C75 02                       .
        .byte   $9C                             ; 9C76 9C                       .
        .byte   $02                             ; 9C77 02                       .
        txs                                     ; 9C78 9A                       .
        sta     $12,y                           ; 9C79 99 12 00                 ...
        .byte   $9C                             ; 9C7C 9C                       .
        sty     $02,x                           ; 9C7D 94 02                    ..
        .byte   $97                             ; 9C7F 97                       .
        .byte   $02                             ; 9C80 02                       .
        txs                                     ; 9C81 9A                       .
        sta     L9702,y                         ; 9C82 99 02 97                 ...
        .byte   $02                             ; 9C85 02                       .
        sta     $97,x                           ; 9C86 95 97                    ..
        ora     ($B5,x)                         ; 9C88 01 B5                    ..
        php                                     ; 9C8A 08                       .
        ora     ($01,x)                         ; 9C8B 01 01                    ..
        lda     $08,x                           ; 9C8D B5 08                    ..
        .byte   $07                             ; 9C8F 07                       .
        asl     L9C01                           ; 9C90 0E 01 9C                 ...
        adc     ($02,x)                         ; 9C93 61 02                    a.
        .byte   $B7                             ; 9C95 B7                       .
        adc     $027A,y                         ; 9C96 79 7A 02                 yz.
        .byte   $9C                             ; 9C99 9C                       .
        .byte   $02                             ; 9C9A 02                       .
        txs                                     ; 9C9B 9A                       .
        sta     L9702,y                         ; 9C9C 99 02 97                 ...
        .byte   $02                             ; 9C9F 02                       .
        sta     $019A,y                         ; 9CA0 99 9A 01                 ...
        .byte   $BB                             ; 9CA3 BB                       .
        php                                     ; 9CA4 08                       .
        .byte   $0B                             ; 9CA5 0B                       .
        .byte   $02                             ; 9CA6 02                       .
        ora     ($DB,x)                         ; 9CA7 01 DB                    ..
        php                                     ; 9CA9 08                       .
        asl     L0000                           ; 9CAA 06 00                    ..
        .byte   $03                             ; 9CAC 03                       .
        .byte   $8F                             ; 9CAD 8F                       .
        php                                     ; 9CAE 08                       .
        asl     a                               ; 9CAF 0A                       .
        clc                                     ; 9CB0 18                       .
        brk                                     ; 9CB1 00                       .
        asl     $50                             ; 9CB2 06 50                    .P
        .byte   $07                             ; 9CB4 07                       .
        .byte   $0B                             ; 9CB5 0B                       .
        stx     L8C8D                           ; 9CB6 8E 8D 8C                 ...
        .byte   $8B                             ; 9CB9 8B                       .
        txa                                     ; 9CBA 8A                       .
        .byte   $89                             ; 9CBB 89                       .
        dey                                     ; 9CBC 88                       .
        .byte   $87                             ; 9CBD 87                       .
        stx     $85                             ; 9CBE 86 85                    ..
        sty     $16                             ; 9CC0 84 16                    ..
        .byte   $9B                             ; 9CC2 9B                       .
        cpy     #$17                            ; 9CC3 C0 17                    ..
        .byte   $04                             ; 9CC5 04                       .
        brk                                     ; 9CC6 00                       .
        asl     $46                             ; 9CC7 06 46                    .F
        .byte   $07                             ; 9CC9 07                       .
        asl     a                               ; 9CCA 0A                       .
        php                                     ; 9CCB 08                       .
        ora     ($09),y                         ; 9CCC 11 09                    ..
        .byte   $02                             ; 9CCE 02                       .
        clc                                     ; 9CCF 18                       .
        .byte   $80                             ; 9CD0 80                       .
        .byte   $0C                             ; 9CD1 0C                       .
        .byte   $FF                             ; 9CD2 FF                       .
        .byte   $04                             ; 9CD3 04                       .
        brk                                     ; 9CD4 00                       .
        .byte   $04                             ; 9CD5 04                       .
        brk                                     ; 9CD6 00                       .
        .byte   $80                             ; 9CD7 80                       .
        sei                                     ; 9CD8 78                       x
        .byte   $02                             ; 9CD9 02                       .
        sta     L9F98,x                         ; 9CDA 9D 98 9F                 ...
        tya                                     ; 9CDD 98                       .
        adc     $7880,x                         ; 9CDE 7D 80 78                 }.x
        .byte   $80                             ; 9CE1 80                       .
        adc     L9F02,y                         ; 9CE2 79 02 9F                 y..
        sta     L8903,y                         ; 9CE5 99 03 89                 ...
        sta     ($67,x)                         ; 9CE8 81 67                    .g
        .byte   $80                             ; 9CEA 80                       .
        adc     ($13,x)                         ; 9CEB 61 13                    a.
        php                                     ; 9CED 08                       .
        sta     $0E0E,x                         ; 9CEE 9D 0E 0E                 ...
        .byte   $02                             ; 9CF1 02                       .
        .byte   $9C                             ; 9CF2 9C                       .
        cmp     $80,x                           ; 9CF3 D5 80                    ..
        .byte   $03                             ; 9CF5 03                       .
        sei                                     ; 9CF6 78                       x
        .byte   $02                             ; 9CF7 02                       .
        sta     L9F98,x                         ; 9CF8 9D 98 9F                 ...
        tya                                     ; 9CFB 98                       .
        adc     $7980,x                         ; 9CFC 7D 80 79                 }.y
        .byte   $80                             ; 9CFF 80                       .
        .byte   $79                             ; 9D00 79                       y
L9D01:  .byte   $02                             ; 9D01 02                       .
L9D02:  .byte   $9F                             ; 9D02 9F                       .
        sta     L8903,y                         ; 9D03 99 03 89                 ...
        sta     ($67,x)                         ; 9D06 81 67                    .g
        .byte   $80                             ; 9D08 80                       .
        adc     ($0F,x)                         ; 9D09 61 0F                    a.
        ora     ($9C,x)                         ; 9D0B 01 9C                    ..
        .byte   $D3                             ; 9D0D D3                       .
        .byte   $80                             ; 9D0E 80                       .
        .byte   $03                             ; 9D0F 03                       .
        sei                                     ; 9D10 78                       x
        .byte   $02                             ; 9D11 02                       .
        sta     L9F98,x                         ; 9D12 9D 98 9F                 ...
        tya                                     ; 9D15 98                       .
        adc     $7880,x                         ; 9D16 7D 80 78                 }.x
        .byte   $80                             ; 9D19 80                       .
        .byte   $7A                             ; 9D1A 7A                       z
        .byte   $02                             ; 9D1B 02                       .
        sta     L9F9A,x                         ; 9D1C 9D 9A 9F                 ...
        txs                                     ; 9D1F 9A                       .
        adc     $7A80,x                         ; 9D20 7D 80 7A                 }.z
        php                                     ; 9D23 08                       .
        .byte   $07                             ; 9D24 07                       .
        asl     $F8                             ; 9D25 06 F8                    ..
        .byte   $07                             ; 9D27 07                       .
        php                                     ; 9D28 08                       .
        ora     #$00                            ; 9D29 09 00                    ..
        clc                                     ; 9D2B 18                       .
        rti                                     ; 9D2C 40                       @

; ----------------------------------------------------------------------------
        .byte   $02                             ; 9D2D 02                       .
        .byte   $92                             ; 9D2E 92                       .
        .byte   $02                             ; 9D2F 02                       .
        stx     $9B,y                           ; 9D30 96 9B                    ..
        .byte   $9E                             ; 9D32 9E                       .
        .byte   $7B                             ; 9D33 7B                       {
        .byte   $03                             ; 9D34 03                       .
        txa                                     ; 9D35 8A                       .
        rts                                     ; 9D36 60                       `

; ----------------------------------------------------------------------------
        sta     $0302                           ; 9D37 8D 02 03                 ...
        sta     ($02),y                         ; 9D3A 91 02                    ..
        sty     $78,x                           ; 9D3C 94 78                    .x
        .byte   $02                             ; 9D3E 02                       .
        .byte   $9B                             ; 9D3F 9B                       .
        sei                                     ; 9D40 78                       x
        .byte   $9F                             ; 9D41 9F                       .
        rts                                     ; 9D42 60                       `

; ----------------------------------------------------------------------------
        .byte   $03                             ; 9D43 03                       .
        txa                                     ; 9D44 8A                       .
        .byte   $02                             ; 9D45 02                       .
        .byte   $03                             ; 9D46 03                       .
        .byte   $8F                             ; 9D47 8F                       .
        .byte   $02                             ; 9D48 02                       .
        .byte   $92                             ; 9D49 92                       .
        sta     $769B,y                         ; 9D4A 99 9B 76                 ..v
        .byte   $9B                             ; 9D4D 9B                       .
        .byte   $80                             ; 9D4E 80                       .
        ror     $03BE,x                         ; 9D4F 7E BE 03                 ~..
        tay                                     ; 9D52 A8                       .
        tax                                     ; 9D53 AA                       .
        lda     $0708                           ; 9D54 AD 08 07                 ...
        ora     #$01                            ; 9D57 09 01                    ..
        brk                                     ; 9D59 00                       .
        .byte   $89                             ; 9D5A 89                       .
        .byte   $80                             ; 9D5B 80                       .
        dey                                     ; 9D5C 88                       .
        .byte   $80                             ; 9D5D 80                       .
        .byte   $87                             ; 9D5E 87                       .
        dey                                     ; 9D5F 88                       .
        .byte   $8B                             ; 9D60 8B                       .
        .byte   $80                             ; 9D61 80                       .
L9D62:  txa                                     ; 9D62 8A                       .
        .byte   $80                             ; 9D63 80                       .
        .byte   $89                             ; 9D64 89                       .
        txa                                     ; 9D65 8A                       .
        sta     L8C80                           ; 9D66 8D 80 8C                 ...
        .byte   $80                             ; 9D69 80                       .
        .byte   $8B                             ; 9D6A 8B                       .
        sty     L808F                           ; 9D6B 8C 8F 80                 ...
        stx     L8D80                           ; 9D6E 8E 80 8D                 ...
        stx     $FF06                           ; 9D71 8E 06 FF                 ...
        .byte   $92                             ; 9D74 92                       .
        sty     $92,x                           ; 9D75 94 92                    ..
        sty     $07,x                           ; 9D77 94 07                    ..
        ora     $92                             ; 9D79 05 92                    ..
        sty     $92,x                           ; 9D7B 94 92                    ..
        sty     $07,x                           ; 9D7D 94 07                    ..
        .byte   $04                             ; 9D7F 04                       .
        .byte   $92                             ; 9D80 92                       .
        sty     $92,x                           ; 9D81 94 92                    ..
        sty     L0000,x                         ; 9D83 94 00                    ..
        ora     ($B2,x)                         ; 9D85 01 B2                    ..
        .byte   $07                             ; 9D87 07                       .
        .byte   $03                             ; 9D88 03                       .
        .byte   $D2                             ; 9D89 D2                       .
        .byte   $07                             ; 9D8A 07                       .
        .byte   $02                             ; 9D8B 02                       .
        ora     ($B2,x)                         ; 9D8C 01 B2                    ..
        .byte   $04                             ; 9D8E 04                       .
        brk                                     ; 9D8F 00                       .
        .byte   $04                             ; 9D90 04                       .
        brk                                     ; 9D91 00                       .
        .byte   $80                             ; 9D92 80                       .
        php                                     ; 9D93 08                       .
        .byte   $07                             ; 9D94 07                       .
        asl     $FF                             ; 9D95 06 FF                    ..
        .byte   $07                             ; 9D97 07                       .
        php                                     ; 9D98 08                       .
        .byte   $09                             ; 9D99 09                       .
L9D9A:  .byte   $02                             ; 9D9A 02                       .
        adc     L9302                           ; 9D9B 6D 02 93                 m..
        sta     $1880                           ; 9D9E 8D 80 18                 ...
        .byte   $80                             ; 9DA1 80                       .
        php                                     ; 9DA2 08                       .
        asl     L5A06                           ; 9DA3 0E 06 5A                 ..Z
        .byte   $07                             ; 9DA6 07                       .
        .byte   $07                             ; 9DA7 07                       .
        .byte   $7C                             ; 9DA8 7C                       |
        .byte   $03                             ; 9DA9 03                       .
        adc     #$6B                            ; 9DAA 69 6B                    ik
        .byte   $64                             ; 9DAC 64                       d
        adc     #$70                            ; 9DAD 69 70                    ip
        clc                                     ; 9DAF 18                       .
        rti                                     ; 9DB0 40                       @

; ----------------------------------------------------------------------------
        asl     L9D01                           ; 9DB1 0E 01 9D                 ...
        bcc     L9DBE                           ; 9DB4 90 08                    ..
        .byte   $07                             ; 9DB6 07                       .
        asl     $F5                             ; 9DB7 06 F5                    ..
        .byte   $07                             ; 9DB9 07                       .
        .byte   $07                             ; 9DBA 07                       .
        .byte   $02                             ; 9DBB 02                       .
        sta     ($02,x)                         ; 9DBC 81 02                    ..
L9DBE:  .byte   $03                             ; 9DBE 03                       .
        .byte   $97                             ; 9DBF 97                       .
        .byte   $95                             ; 9DC0 95                       .
L9DC1:  .byte   $13                             ; 9DC1 13                       .
        brk                                     ; 9DC2 00                       .
        sta     $02D8,x                         ; 9DC3 9D D8 02                 ...
        .byte   $93                             ; 9DC6 93                       .
        .byte   $02                             ; 9DC7 02                       .
        .byte   $97                             ; 9DC8 97                       .
        sta     $02,x                           ; 9DC9 95 02                    ..
        .byte   $93                             ; 9DCB 93                       .
        .byte   $02                             ; 9DCC 02                       .
        bcc     L9D62                           ; 9DCD 90 93                    ..
        .byte   $02                             ; 9DCF 02                       .
        .byte   $92                             ; 9DD0 92                       .
        .byte   $02                             ; 9DD1 02                       .
        bcc     L9D62                           ; 9DD2 90 8E                    ..
        .byte   $0F                             ; 9DD4 0F                       .
        ora     ($9D,x)                         ; 9DD5 01 9D                    ..
        stx     $B302                           ; 9DD7 8E 02 B3                 ...
        adc     $77,x                           ; 9DDA 75 77                    uw
        .byte   $02                             ; 9DDC 02                       .
        sta     L9702,y                         ; 9DDD 99 02 97                 ...
        stx     $02,y                           ; 9DE0 96 02                    ..
        sty     $02,x                           ; 9DE2 94 02                    ..
        stx     $97,y                           ; 9DE4 96 97                    ..
        stx     $80,y                           ; 9DE6 96 80                    ..
        .byte   $AF                             ; 9DE8 AF                       .
        ldx     $B9,y                           ; 9DE9 B6 B9                    ..
        brk                                     ; 9DEB 00                       .
        .byte   $9B                             ; 9DEC 9B                       .
        .byte   $80                             ; 9DED 80                       .
        php                                     ; 9DEE 08                       .
        asl     a                               ; 9DEF 0A                       .
        clc                                     ; 9DF0 18                       .
        brk                                     ; 9DF1 00                       .
        asl     $50                             ; 9DF2 06 50                    .P
        .byte   $07                             ; 9DF4 07                       .
        .byte   $0B                             ; 9DF5 0B                       .
        .byte   $03                             ; 9DF6 03                       .
        .byte   $8F                             ; 9DF7 8F                       .
        stx     L8C8D                           ; 9DF8 8E 8D 8C                 ...
        .byte   $8B                             ; 9DFB 8B                       .
        txa                                     ; 9DFC 8A                       .
        .byte   $89                             ; 9DFD 89                       .
        dey                                     ; 9DFE 88                       .
        .byte   $87                             ; 9DFF 87                       .
        .byte   $86                             ; 9E00 86                       .
L9E01:  asl     $9C,x                           ; 9E01 16 9C                    ..
L9E03:  cmp     $17                             ; 9E03 C5 17                    ..
L9E05:  .byte   $04                             ; 9E05 04                       .
L9E06:  brk                                     ; 9E06 00                       .
        php                                     ; 9E07 08                       .
L9E08:  asl     $0209                           ; 9E08 0E 09 02                 ...
        .byte   $04                             ; 9E0B 04                       .
        brk                                     ; 9E0C 00                       .
        asl     $DC                             ; 9E0D 06 DC                    ..
        .byte   $02                             ; 9E0F 02                       .
        dey                                     ; 9E10 88                       .
        .byte   $6F                             ; 9E11 6F                       o
        ldy     #$06                            ; 9E12 A0 06                    ..
        .byte   $82                             ; 9E14 82                       .
        ldy     $A8,x                           ; 9E15 B4 A8                    ..
        asl     $DC                             ; 9E17 06 DC                    ..
        .byte   $12                             ; 9E19 12                       .
        brk                                     ; 9E1A 00                       .
        .byte   $9E                             ; 9E1B 9E                       .
        and     #$02                            ; 9E1C 29 02                    ).
        .byte   $89                             ; 9E1E 89                       .
        bvs     L9DC1                           ; 9E1F 70 A0                    p.
        asl     $82                             ; 9E21 06 82                    ..
        lda     $A9,x                           ; 9E23 B5 A9                    ..
        asl     L9E05                           ; 9E25 0E 05 9E                 ...
        .byte   $0B                             ; 9E28 0B                       .
        .byte   $02                             ; 9E29 02                       .
        .byte   $87                             ; 9E2A 87                       .
        ror     $06A0                           ; 9E2B 6E A0 06                 n..
        .byte   $82                             ; 9E2E 82                       .
        .byte   $B3                             ; 9E2F B3                       .
        .byte   $A7                             ; 9E30 A7                       .
        asl     $DC                             ; 9E31 06 DC                    ..
        .byte   $02                             ; 9E33 02                       .
        stx     $6D                             ; 9E34 86 6D                    .m
        ldy     #$06                            ; 9E36 A0 06                    ..
        .byte   $82                             ; 9E38 82                       .
        .byte   $B2                             ; 9E39 B2                       .
        ldx     $06                             ; 9E3A A6 06                    ..
        .byte   $DC                             ; 9E3C DC                       .
        .byte   $02                             ; 9E3D 02                       .
        sta     $6C                             ; 9E3E 85 6C                    .l
        ldy     #$06                            ; 9E40 A0 06                    ..
        .byte   $82                             ; 9E42 82                       .
        lda     ($A5),y                         ; 9E43 B1 A5                    ..
        .byte   $04                             ; 9E45 04                       .
        brk                                     ; 9E46 00                       .
        asl     $DC                             ; 9E47 06 DC                    ..
        .byte   $02                             ; 9E49 02                       .
        .byte   $83                             ; 9E4A 83                       .
        ror     a                               ; 9E4B 6A                       j
        ldy     #$06                            ; 9E4C A0 06                    ..
        .byte   $82                             ; 9E4E 82                       .
        .byte   $AF                             ; 9E4F AF                       .
        .byte   $A3                             ; 9E50 A3                       .
        asl     L9E01                           ; 9E51 0E 01 9E                 ...
        eor     $06                             ; 9E54 45 06                    E.
        .byte   $DC                             ; 9E56 DC                       .
        iny                                     ; 9E57 C8                       .
        iny                                     ; 9E58 C8                       .
        iny                                     ; 9E59 C8                       .
        iny                                     ; 9E5A C8                       .
        ora     ($E8,x)                         ; 9E5B 01 E8                    ..
        .byte   $02                             ; 9E5D 02                       .
        iny                                     ; 9E5E C8                       .
        .byte   $02                             ; 9E5F 02                       .
        ora     ($88,x)                         ; 9E60 01 88                    ..
        rts                                     ; 9E62 60                       `

; ----------------------------------------------------------------------------
        .byte   $04                             ; 9E63 04                       .
        brk                                     ; 9E64 00                       .
        .byte   $02                             ; 9E65 02                       .
        .byte   $89                             ; 9E66 89                       .
        adc     $A0,x                           ; 9E67 75 A0                    u.
        asl     $82                             ; 9E69 06 82                    ..
        ldx     $06B3                           ; 9E6B AE B3 06                 ...
        .byte   $DC                             ; 9E6E DC                       .
        asl     L9E06                           ; 9E6F 0E 06 9E                 ...
        .byte   $63                             ; 9E72 63                       c
        .byte   $02                             ; 9E73 02                       .
        txa                                     ; 9E74 8A                       .
        ror     $A0,x                           ; 9E75 76 A0                    v.
        asl     $82                             ; 9E77 06 82                    ..
        lda     ($B6),y                         ; 9E79 B1 B6                    ..
        asl     $DC                             ; 9E7B 06 DC                    ..
        .byte   $02                             ; 9E7D 02                       .
        .byte   $83                             ; 9E7E 83                       .
        .byte   $6F                             ; 9E7F 6F                       o
        ldy     #$06                            ; 9E80 A0 06                    ..
        .byte   $82                             ; 9E82 82                       .
        tax                                     ; 9E83 AA                       .
        .byte   $AF                             ; 9E84 AF                       .
        asl     $F0                             ; 9E85 06 F0                    ..
        .byte   $E3                             ; 9E87 E3                       .
        asl     $9E,x                           ; 9E88 16 9E                    ..
        ora     $17                             ; 9E8A 05 17                    ..
        .byte   $04                             ; 9E8C 04                       .
        brk                                     ; 9E8D 00                       .
        .byte   $04                             ; 9E8E 04                       .
        brk                                     ; 9E8F 00                       .
        .byte   $04                             ; 9E90 04                       .
        brk                                     ; 9E91 00                       .
        asl     $3C                             ; 9E92 06 3C                    .<
        php                                     ; 9E94 08                       .
        ora     $09,y                           ; 9E95 19 09 00                 ...
        .byte   $07                             ; 9E98 07                       .
        ora     #$68                            ; 9E99 09 68                    .h
        rts                                     ; 9E9B 60                       `

; ----------------------------------------------------------------------------
        pla                                     ; 9E9C 68                       h
        .byte   $6B                             ; 9E9D 6B                       k
        rts                                     ; 9E9E 60                       `

; ----------------------------------------------------------------------------
        pla                                     ; 9E9F 68                       h
        jmp     (L6C60)                         ; 9EA0 6C 60 6C                 l`l

; ----------------------------------------------------------------------------
        rts                                     ; 9EA3 60                       `

; ----------------------------------------------------------------------------
        pla                                     ; 9EA4 68                       h
        .byte   $02                             ; 9EA5 02                       .
        .byte   $80                             ; 9EA6 80                       .
        .byte   $12                             ; 9EA7 12                       .
        brk                                     ; 9EA8 00                       .
        .byte   $9E                             ; 9EA9 9E                       .
        lda     ($68),y                         ; 9EAA B1 68                    .h
        rts                                     ; 9EAC 60                       `

; ----------------------------------------------------------------------------
        asl     L9E01                           ; 9EAD 0E 01 9E                 ...
        bcc     L9F1D                           ; 9EB0 90 6B                    .k
        .byte   $6B                             ; 9EB2 6B                       k
        .byte   $0F                             ; 9EB3 0F                       .
        ora     $9E                             ; 9EB4 05 9E                    ..
        stx     a:$04                           ; 9EB6 8E 04 00                 ...
        adc     #$60                            ; 9EB9 69 60                    i`
        adc     #$69                            ; 9EBB 69 69                    ii
        .byte   $80                             ; 9EBD 80                       .
        adc     #$69                            ; 9EBE 69 69                    ii
        adc     #$60                            ; 9EC0 69 60                    i`
        adc     #$02                            ; 9EC2 69 02                    i.
        .byte   $80                             ; 9EC4 80                       .
        .byte   $6B                             ; 9EC5 6B                       k
        .byte   $6B                             ; 9EC6 6B                       k
        asl     L9E03                           ; 9EC7 0E 03 9E                 ...
        .byte   $B7                             ; 9ECA B7                       .
        php                                     ; 9ECB 08                       .
        .byte   $14                             ; 9ECC 14                       .
        asl     $C8                             ; 9ECD 06 C8                    ..
        .byte   $07                             ; 9ECF 07                       .
        .byte   $0B                             ; 9ED0 0B                       .
        cpy     $CBCC                           ; 9ED1 CC CC CB                 ...
        .byte   $CB                             ; 9ED4 CB                       .
        nop                                     ; 9ED5 EA                       .
        .byte   $07                             ; 9ED6 07                       .
        php                                     ; 9ED7 08                       .
        .byte   $AF                             ; 9ED8 AF                       .
        lda     $1908                           ; 9ED9 AD 08 19                 ...
        asl     $3C                             ; 9EDC 06 3C                    .<
        .byte   $07                             ; 9EDE 07                       .
        php                                     ; 9EDF 08                       .
        pla                                     ; 9EE0 68                       h
        adc     #$6A                            ; 9EE1 69 6A                    ij
        .byte   $6B                             ; 9EE3 6B                       k
        jmp     (L6A6B)                         ; 9EE4 6C 6B 6A                 lkj

; ----------------------------------------------------------------------------
        adc     #$08                            ; 9EE7 69 08                    i.
        .byte   $14                             ; 9EE9 14                       .
        asl     $C8                             ; 9EEA 06 C8                    ..
        .byte   $04                             ; 9EEC 04                       .
        brk                                     ; 9EED 00                       .
        .byte   $02                             ; 9EEE 02                       .
        sta     $06                             ; 9EEF 85 06                    ..
        ora     ($02,x)                         ; 9EF1 01 02                    ..
        txa                                     ; 9EF3 8A                       .
        asl     $C8                             ; 9EF4 06 C8                    ..
        ror     L856E                           ; 9EF6 6E 6E 85                 nn.
        ror     $066E                           ; 9EF9 6E 6E 06                 nn.
        ora     ($8A,x)                         ; 9EFC 01 8A                    ..
        asl     $C8                             ; 9EFE 06 C8                    ..
        .byte   $6E                             ; 9F00 6E                       n
        .byte   $6E                             ; 9F01 6E                       n
L9F02:  asl     L9E08                           ; 9F02 0E 08 9E                 ...
        cpx     $0B07                           ; 9F05 EC 07 0B                 ...
        tax                                     ; 9F08 AA                       .
        tax                                     ; 9F09 AA                       .
        tax                                     ; 9F0A AA                       .
        tax                                     ; 9F0B AA                       .
        asl     $9E,x                           ; 9F0C 16 9E                    ..
        sty     a:$17                           ; 9F0E 8C 17 00                 ...
        .byte   $9F                             ; 9F11 9F                       .
        ora     $36A0,y                         ; 9F12 19 A0 36                 ..6
        lda     ($33,x)                         ; 9F15 A1 33                    .3
        ldx     #$3A                            ; 9F17 A2 3A                    .:
        ora     $01                             ; 9F19 05 01                    ..
        .byte   $A7                             ; 9F1B A7                       .
        asl     a                               ; 9F1C 0A                       .
L9F1D:  .byte   $02                             ; 9F1D 02                       .
        .byte   $04                             ; 9F1E 04                       .
        brk                                     ; 9F1F 00                       .
        .byte   $04                             ; 9F20 04                       .
        brk                                     ; 9F21 00                       .
        asl     $5A                             ; 9F22 06 5A                    .Z
        .byte   $07                             ; 9F24 07                       .
        ora     #$09                            ; 9F25 09 09                    ..
        .byte   $02                             ; 9F27 02                       .
        php                                     ; 9F28 08                       .
        .byte   $13                             ; 9F29 13                       .
        clc                                     ; 9F2A 18                       .
        .byte   $80                             ; 9F2B 80                       .
        bcc     L9F8E                           ; 9F2C 90 60                    .`
        .byte   $02                             ; 9F2E 02                       .
        ora     ($DA,x)                         ; 9F2F 01 DA                    ..
        ora     ($9A,x)                         ; 9F31 01 9A                    ..
        rts                                     ; 9F33 60                       `

; ----------------------------------------------------------------------------
        php                                     ; 9F34 08                       .
        .byte   $04                             ; 9F35 04                       .
        adc     $A079,y                         ; 9F36 79 79 A0                 yy.
        asl     $6E                             ; 9F39 06 6E                    .n
        php                                     ; 9F3B 08                       .
        .byte   $03                             ; 9F3C 03                       .
        .byte   $03                             ; 9F3D 03                       .
        adc     $0780                           ; 9F3E 6D 80 07                 m..
        .byte   $0C                             ; 9F41 0C                       .
        clc                                     ; 9F42 18                       .
        cpy     #$6D                            ; 9F43 C0 6D                    .m
        ldy     #$0E                            ; 9F45 A0 0E                    ..
        ora     ($9F,x)                         ; 9F47 01 9F                    ..
        jsr     L5A06                           ; 9F49 20 06 5A                  .Z
        php                                     ; 9F4C 08                       .
        .byte   $13                             ; 9F4D 13                       .
        .byte   $07                             ; 9F4E 07                       .
        ora     #$18                            ; 9F4F 09 18                    ..
        .byte   $80                             ; 9F51 80                       .
        .byte   $03                             ; 9F52 03                       .
        stx     $60,y                           ; 9F53 96 60                    .`
        .byte   $02                             ; 9F55 02                       .
        ora     ($DD,x)                         ; 9F56 01 DD                    ..
        ora     ($9D,x)                         ; 9F58 01 9D                    ..
        rts                                     ; 9F5A 60                       `

; ----------------------------------------------------------------------------
        php                                     ; 9F5B 08                       .
        .byte   $04                             ; 9F5C 04                       .
        .byte   $7C                             ; 9F5D 7C                       |
        .byte   $7C                             ; 9F5E 7C                       |
        ldy     #$06                            ; 9F5F A0 06                    ..
        lsr     $08                             ; 9F61 46 08                    F.
        .byte   $1A                             ; 9F63 1A                       .
        .byte   $07                             ; 9F64 07                       .
        .byte   $0B                             ; 9F65 0B                       .
        clc                                     ; 9F66 18                       .
        cpy     #$03                            ; 9F67 C0 03                    ..
        jmp     (L1860)                         ; 9F69 6C 60 18                 l`.

; ----------------------------------------------------------------------------
        .byte   $80                             ; 9F6C 80                       .
        .byte   $64                             ; 9F6D 64                       d
        .byte   $07                             ; 9F6E 07                       .
        asl     a                               ; 9F6F 0A                       .
        clc                                     ; 9F70 18                       .
        cpy     #$6C                            ; 9F71 C0 6C                    .l
        rts                                     ; 9F73 60                       `

; ----------------------------------------------------------------------------
        .byte   $07                             ; 9F74 07                       .
        php                                     ; 9F75 08                       .
        clc                                     ; 9F76 18                       .
        .byte   $80                             ; 9F77 80                       .
        .byte   $64                             ; 9F78 64                       d
        clc                                     ; 9F79 18                       .
        cpy     #$6C                            ; 9F7A C0 6C                    .l
        rts                                     ; 9F7C 60                       `

; ----------------------------------------------------------------------------
        asl     $F0                             ; 9F7D 06 F0                    ..
        php                                     ; 9F7F 08                       .
        ora     (L0018,x)                       ; 9F80 01 18                    ..
        .byte   $80                             ; 9F82 80                       .
        adc     ($63,x)                         ; 9F83 61 63                    ac
        adc     $02                             ; 9F85 65 02                    e.
        iny                                     ; 9F87 C8                       .
        rts                                     ; 9F88 60                       `

; ----------------------------------------------------------------------------
        .byte   $C7                             ; 9F89 C7                       .
        cmp     $04                             ; 9F8A C5 04                    ..
        brk                                     ; 9F8C 00                       .
        .byte   $07                             ; 9F8D 07                       .
L9F8E:  brk                                     ; 9F8E 00                       .
        ldy     #$07                            ; 9F8F A0 07                    ..
        ora     #$08                            ; 9F91 09 08                    ..
        ora     L0018                           ; 9F93 05 18                    ..
        .byte   $80                             ; 9F95 80                       .
        .byte   $02                             ; 9F96 02                       .
        .byte   $01                             ; 9F97 01                       .
L9F98:  stx     $07,y                           ; 9F98 96 07                    ..
L9F9A:  .byte   $04                             ; 9F9A 04                       .
        ora     $5B08                           ; 9F9B 0D 08 5B                 ..[
        .byte   $5C                             ; 9F9E 5C                       \
        .byte   $07                             ; 9F9F 07                       .
        ora     #$01                            ; 9FA0 09 01                    ..
        cmp     a:$0D,x                         ; 9FA2 DD 0D 00                 ...
        .byte   $80                             ; 9FA5 80                       .
        .byte   $7B                             ; 9FA6 7B                       {
        .byte   $80                             ; 9FA7 80                       .
        .byte   $03                             ; 9FA8 03                       .
        pla                                     ; 9FA9 68                       h
        .byte   $80                             ; 9FAA 80                       .
        .byte   $02                             ; 9FAB 02                       .
        .byte   $03                             ; 9FAC 03                       .
        sty     $01,x                           ; 9FAD 94 01                    ..
        eor     $07,x                           ; 9FAF 55 07                    U.
        php                                     ; 9FB1 08                       .
        ora     $561E                           ; 9FB2 0D 1E 56                 ..V
        ora     ($96,x)                         ; 9FB5 01 96                    ..
        .byte   $07                             ; 9FB7 07                       .
        ora     #$0D                            ; 9FB8 09 0D                    ..
        brk                                     ; 9FBA 00                       .
        .byte   $8F                             ; 9FBB 8F                       .
        ora     ($B1,x)                         ; 9FBC 01 B1                    ..
        php                                     ; 9FBE 08                       .
        ora     ($F1,x)                         ; 9FBF 01 F1                    ..
        ora     ($B1,x)                         ; 9FC1 01 B1                    ..
        rts                                     ; 9FC3 60                       `

; ----------------------------------------------------------------------------
        php                                     ; 9FC4 08                       .
        ora     $9D                             ; 9FC5 05 9D                    ..
        .byte   $54                             ; 9FC7 54                       T
        .byte   $02                             ; 9FC8 02                       .
        rts                                     ; 9FC9 60                       `

; ----------------------------------------------------------------------------
        ora     ($9D,x)                         ; 9FCA 01 9D                    ..
        .byte   $07                             ; 9FCC 07                       .
        ora     $0D                             ; 9FCD 05 0D                    ..
        .byte   $64                             ; 9FCF 64                       d
        ora     ($71,x)                         ; 9FD0 01 71                    .q
        ora     $0700                           ; 9FD2 0D 00 07                 ...
        ora     #$0E                            ; 9FD5 09 0E                    ..
        ora     ($9F,x)                         ; 9FD7 01 9F                    ..
        .byte   $8B                             ; 9FD9 8B                       .
        .byte   $02                             ; 9FDA 02                       .
        sta     $609B,x                         ; 9FDB 9D 9B 60                 ..`
        sta     L9B02,y                         ; 9FDE 99 02 9B                 ...
        sty     $60,x                           ; 9FE1 94 60                    .`
        .byte   $03                             ; 9FE3 03                       .
        dey                                     ; 9FE4 88                       .
        .byte   $02                             ; 9FE5 02                       .
        stx     $85                             ; 9FE6 86 85                    ..
        rts                                     ; 9FE8 60                       `

; ----------------------------------------------------------------------------
        .byte   $83                             ; 9FE9 83                       .
        rts                                     ; 9FEA 60                       `

; ----------------------------------------------------------------------------
        eor     ($02,x)                         ; 9FEB 41 02                    A.
        rts                                     ; 9FED 60                       `

; ----------------------------------------------------------------------------
        tax                                     ; 9FEE AA                       .
        rts                                     ; 9FEF 60                       `

; ----------------------------------------------------------------------------
        .byte   $02                             ; 9FF0 02                       .
        dey                                     ; 9FF1 88                       .
        stx     $60                             ; 9FF2 86 60                    .`
        sty     $A3                             ; 9FF4 84 A3                    ..
        .byte   $03                             ; 9FF6 03                       .
        .byte   $B2                             ; 9FF7 B2                       .
        .byte   $F4                             ; 9FF8 F4                       .
        .byte   $02                             ; 9FF9 02                       .
        .byte   $9F                             ; 9FFA 9F                       .
        sta     L9B60,x                         ; 9FFB 9D 60 9B                 .`.
        .byte   $02                             ; 9FFE 02                       .
        .byte   $9D                             ; 9FFF 9D                       .
