.setcpu "6502"
.include "include/hardware.inc"
.include "include/zeropage.inc"
.include "include/constants.inc"

.segment "FIXED"

; =============================================================================
; FIXED BANK $1E/$1F ($C000-$FFFF) — NMI/IRQ/RESET, task scheduler,
; bank-switch API, sound queue, core engine. Raw da65 disassembly,
; annotation in progress.
; =============================================================================
L0000           := $0000
L0004           := $0004
L0020           := $0020
L0093           := $0093
L0097           := $0097
L00C0           := $00C0
L0100           := $0100
L0200           := $0200
L0880           := $0880
L0A02           := $0A02
L0F27           := $0F27
L0F37           := $0F37
L1018           := $1018
L1110           := $1110
L111C           := $111C
L1414           := $1414
L1501           := $1501
L1C01           := $1C01
L1C18           := $1C18
L1C20           := $1C20
L1C2C           := $1C2C
L2000           := $2000
L2010           := $2010
L211C           := $211C
L2120           := $2120
L2221           := $2221
L2511           := $2511
L2724           := $2724
L6040           := $6040
L69FE           := $69FE
L6F64           := $6F64
L8000           := $8000
L8003           := $8003
L8040           := $8040
L8044           := $8044
L8100           := $8100
L814D           := $814D
L988A           := $988A
; ----------------------------------------------------------------------------
; =============================================================================
; NMI HANDLER — $C000
; Per-frame PPU update pipeline. Order: OAM DMA, nametable buffer
; flushes, palette upload, CHR bank regs, scroll, PPUCTRL/PPUMASK,
; MMC3 IRQ latch + per-mode IRQ vector, then the task step.
; nmi_skip (rendering off) reduces it to the task step only;
; nmi_quick skips the upload phase (scroll/control writes only).
; =============================================================================
nmi_handler:
        php
        pha
        txa
        pha
        tya
        pha
        lda     nmi_skip                ; rendering disabled?
        beq     LC00D
        jmp     nmi_tasks               ; -> frame counter + task step only

LC00D:  lda     nmi_quick               ; quick mode: no uploads
        beq     LC014
        jmp     nmi_scroll

LC014:  lda     nametable_dirty         ; latch "nametable writes pending"
        ora     nt_column_dirty         ; (palette upload defers while set)
        sta     nt_busy
        lda     scroll_y                ; apply pending scroll/nametable
        sta     scroll_y_apl
        lda     scroll_x
        sta     scroll_x_apl
        lda     nt_select
        and     #$03
        sta     nt_sel_apl
        lda     irq_latch_req           ; apply pending IRQ latch + game mode
        sta     irq_latch
        lda     game_mode_req
        sta     game_mode
        cmp     #$05                    ; mode 5: X scroll comes from irq_split0
        bne     LC038
        lda     irq_split0
        sta     scroll_x_apl
LC038:  lda     ppuctrl_shadow          ; blank: NMI off, keep pattern bits,
        and     #$78                    ; nametable 0
        sta     PPUCTRL
        lda     #$00
        sta     PPUMASK
        sta     OAMADDR
        lda     #>OAM_BUF               ; sprite DMA from $0200
        sta     OAMDMA
        lda     nt_row_dirty            ; flush second buffer region ($07D0+)
        beq     LC059
        lda     #$00
        sta     nt_row_dirty
        ldx     #$50
        jsr     nametable_flush_at
LC059:  lda     nametable_dirty         ; flush main nametable buffer
        beq     LC060
        jsr     nametable_flush
LC060:  lda     nt_column_dirty         ; column writes: temporarily switch
        beq     LC07B                   ; PPU to increment-32 mode
        lda     ppuctrl_shadow
        and     #$7F
        ora     #$04
        sta     PPUCTRL
        ldx     #$00
        stx     nt_column_dirty
        jsr     nametable_flush_at
        lda     ppuctrl_shadow          ; back to increment-1
        and     #$7F
        sta     PPUCTRL
LC07B:  lda     palette_dirty           ; palette upload (skipped while
        beq     LC0AC                   ; nametable writes were pending)
        lda     nt_busy
        bne     LC0AC
        ldx     #$00
        stx     palette_dirty
        lda     PPUSTATUS
        lda     #$3F                    ; PPUADDR = $3F00
        sta     PPUADDR
        stx     PPUADDR
        ldy     #$20
LC094:  lda     PAL_BUF,x               ; upload 32 bytes from $0600
        sta     PPUDATA
        inx
        dey
        bne     LC094
        lda     #$3F                    ; park PPUADDR at $3F00 (avoid
        sta     PPUADDR                 ; palette corruption artifacts)
        sty     PPUADDR
        sty     PPUADDR
        sty     PPUADDR
LC0AC:  ldx     #$05                    ; CHR banking: write MMC3 R5..R0
LC0AE:  stx     MMC3_BANK_SELECT        ; from the chr_banks shadows
        lda     chr_banks,x             ; (CHR animation = rewriting these)
        sta     MMC3_BANK_DATA
        dex
        bpl     LC0AE
        lda     mmc3_sel_shadow         ; restore bank-select for main code
        sta     MMC3_BANK_SELECT
nmi_scroll:
        lda     game_mode               ; mode 4: X scroll from irq_split0,
        cmp     #$04                    ; Y forced to 0
        bne     LC0D3
        lda     PPUSTATUS
        lda     irq_split0
        sta     PPUSCROLL
        lda     #$00
        sta     PPUSCROLL
        beq     LC0E0
LC0D3:  lda     PPUSTATUS               ; normal: applied X/Y scroll
        lda     scroll_x_apl
        sta     PPUSCROLL
        lda     scroll_y_apl
        sta     PPUSCROLL
LC0E0:  lda     ppumask_shadow          ; re-enable rendering
        sta     PPUMASK
        lda     nt_sel_apl              ; PPUCTRL = base | nametable bits
        ora     ppuctrl_shadow
        sta     PPUCTRL
        lda     irq_latch               ; arm MMC3 scanline IRQ
        sta     MMC3_IRQ_LATCH
        sta     MMC3_IRQ_RELOAD
        ldx     irq_enable_idx          ; write $E000 (off) or $E001 (on)
        sta     MMC3_IRQ_DISABLE,x
        beq     nmi_tasks               ; latch 0 = no split this frame
        ldx     game_mode               ; select per-mode IRQ handler
        lda     irq_vec_lo,x
        sta     irq_vector
        lda     irq_vec_hi,x
        sta     irq_vector+1
nmi_tasks:
        inc     frame_counter
        ldx     #$FF                    ; flag "NMI happened" for scheduler
        stx     nmi_occurred
        inx
        ldy     #$04                    ; step all 4 task records:
LC110:  lda     task_state,x            ; state 1 (frame-wait): count down,
        cmp     #$01                    ; at 0 -> state 4 (ready)
        bne     LC11E
        dec     task_arg,x
        bne     LC11E
        lda     #$04
        sta     task_state,x
LC11E:  inx
        inx
        inx
        inx
        dey
        bne     LC110
        lda     game_mode               ; mode 4 defers this to its IRQ
        cmp     #$04
        beq     LC140
irq_hijack:
        tsx                             ; swap the interrupted return
        lda     $0107,x                 ; address with music_pump ($C147)
        sta     saved_pc_hi             ; so the sound driver runs after
        lda     $0106,x                 ; the handler exits
        sta     saved_pc_lo
        lda     #>music_pump
        sta     $0107,x
        lda     #<music_pump
        sta     $0106,x
LC140:  pla
        tay
        pla
        tax
        pla
        plp
        rti

; -----------------------------------------------------------------------------
; MUSIC PUMP TRAMPOLINE — $C147
; Entered via the hijacked NMI/IRQ return. Rebuilds a return frame with
; the original PC-1, runs the sound queue + driver, then RTS resumes
; the interrupted code exactly where it left off.
; -----------------------------------------------------------------------------
music_pump:
        php                             ; reserve 3 stack bytes (P + RTS
        php                             ; target patched in below)
        php
        pha
        txa
        pha
        tya
        pha
        tsx
        sec                             ; write saved PC - 1 into the
        lda     saved_pc_lo             ; reserved slot (RTS adds 1 back)
        sbc     #$01
        sta     $0105,x
        lda     saved_pc_hi
        sbc     #$00
        sta     $0106,x
        jsr     sound_queue_pump
        pla
        tay
        pla
        tax
        pla
        plp
        rts                             ; -> interrupted code

; =============================================================================
; IRQ HANDLER — $C169
; MMC3 scanline IRQ. Acknowledges, applies an optional per-mode delay
; (aligning the split with hblank), then dispatches through irq_vector
; (set from irq_vec_lo/hi by NMI, or chained by a first-split handler).
; =============================================================================
irq_handler:
        php
        pha
        txa
        pha
        tya
        pha
        sta     MMC3_IRQ_DISABLE        ; acknowledge
        sta     MMC3_IRQ_ENABLE         ; re-arm
        ldx     game_mode
        lda     irq_dly_flags,x         ; some modes need extra delay
        bne     LC182
        ldx     #$07
LC17E:  nop
        dex
        bne     LC17E
LC182:  jmp     (irq_vector)

; --- mode 1: mid-frame seam via PPUADDR ($79 = addr hi), X-only scroll -------
irq_m1_split:
        lda     PPUSTATUS
        lda     scroll_x_apl
        lsr     a
        lsr     a
        lsr     a
        ora     irq_split0
        ldy     irq_split1
        sty     PPUADDR
        sta     PPUADDR
        lda     ppuctrl_shadow
        sta     PPUCTRL
        lda     scroll_x_apl
        sta     PPUSCROLL
        lda     #$00
        sta     PPUSCROLL
        jmp     irq_ack_off

; --- mode 2: reset seam to $2300 row, flip nametable ------------------------
irq_m2_split:
        lda     PPUSTATUS
        lda     #$23
        sta     PPUADDR
        lda     #$00
        sta     PPUADDR
        lda     #$00
        sta     PPUSCROLL
        sta     PPUSCROLL
        lda     nt_sel_apl
        eor     #$01
        ora     ppuctrl_shadow
        sta     PPUCTRL
        jmp     irq_ack_off

; --- mode 3: X-scroll split, chain second split at line $2E -----------------
irq_m3_split:
        lda     PPUSTATUS
        lda     irq_split0
        sta     PPUSCROLL
        lda     #$00
        sta     PPUSCROLL
        lda     #$2E                    ; next split scanline
        sta     MMC3_IRQ_LATCH
        lda     #<irq_second_split
        sta     irq_vector
        lda     #>irq_second_split
        sta     irq_vector+1
        jmp     irq_exit

; --- mode 4: X/Y scroll split, chain at line $7A; runs the task step --------
irq_m4_split:
        lda     PPUSTATUS
        lda     irq_split1
        sta     PPUSCROLL
        lda     scroll_y_apl
        sta     PPUSCROLL
        lda     irq_split2              ; next split scanline
        sta     MMC3_IRQ_LATCH
        lda     #$04
        sta     irq_vector
        lda     #$C2
        sta     irq_vector+1
        jmp     irq_hijack              ; task step deferred from NMI

; --- second split ($C204): restore main scroll (chained by modes 3/4) -------
irq_second_split:
        lda     PPUSTATUS
        lda     scroll_x_apl
        sta     PPUSCROLL
        lda     scroll_y_apl
        sta     PPUSCROLL
        beq     irq_ack_off             ; Y = 0: done
; --- mode 5 entry: seam via PPUADDR $7A/$7B ----------------------------------
irq_m5_split:
        lda     PPUSTATUS
        lda     irq_split2
        sta     PPUADDR
        lda     irq_split3
        sta     PPUADDR
        lda     #$00
        sta     PPUSCROLL
        sta     PPUSCROLL
        lda     ppuctrl_shadow
        sta     PPUCTRL
        bne     irq_ack_off             ; (always)

; --- mode 6: seam to $29C0, nametable bit 1 ----------------------------------
irq_m6_split:
        lda     PPUSTATUS
        lda     #$29
        sta     PPUADDR
        lda     #$C0
        sta     PPUADDR
        lda     #$00
        sta     PPUSCROLL
        sta     PPUSCROLL
        lda     ppuctrl_shadow
        ora     #$02
        sta     PPUCTRL
        bne     irq_ack_off             ; (always)

; --- mode 7: X-scroll split, chain X-only second split at line $1F ----------
irq_m7_split:
        lda     PPUSTATUS
        lda     irq_split0
        sta     PPUSCROLL
        lda     #$00
        sta     PPUSCROLL
        lda     #$1F                    ; next split scanline
        sta     MMC3_IRQ_LATCH
        lda     #<irq_m7_second
        sta     irq_vector
        lda     #>irq_m7_second
        sta     irq_vector+1
        bne     irq_exit                ; (always)

irq_m7_second:
        lda     PPUSTATUS
        lda     irq_split1
        sta     PPUSCROLL
        lda     #$00
        sta     PPUSCROLL
irq_ack_off:
        sta     MMC3_IRQ_DISABLE        ; no more splits this frame
irq_exit:
        pla
        tay
        pla
        tax
        pla
        plp
        rti

; --- per-game-mode IRQ handler vectors (indexed by game_mode) ---------------
irq_vec_lo:
        .byte   $76,$85,$A9,$CA,$E7,$13,$2F,$4D ; C280
irq_vec_hi:
        .byte   $C2,$C1,$C1,$C1,$C1,$C2,$C2,$C2 ; C288
; mode 0 -> irq_ack_off (no split), 1-7 -> irq_mN_split above

; --- per-mode IRQ delay flags (1 = skip the hblank-align delay loop) ---------
irq_dly_flags:
        .byte   $00,$00,$00,$01,$01,$00,$00,$01 ; C290

; =============================================================================
; NAMETABLE WRITE BUFFER FLUSH — $C298 / $C29C
; NT_BUF ($0780) records: [PPU addr hi (bit 7 set = end of buffer),
; addr lo, length-1, data bytes...]. X = starting offset.
; =============================================================================
nametable_flush:
        ldx     #$00
        stx     nametable_dirty
nametable_flush_at:
        lda     NT_BUF,x                ; bit 7 set = end marker
        bmi     LC2BC
        sta     PPUADDR
        lda     NT_BUF+1,x
        sta     PPUADDR
        ldy     NT_BUF+2,x              ; length - 1
LC2AD:  lda     NT_BUF+3,x
        sta     PPUDATA
        inx
        dey
        bpl     LC2AD
        inx                             ; skip the 3 header bytes
        inx
        inx
        bne     nametable_flush_at
LC2BC:  rts

; --- $C2BD: PPUCTRL &= $11 — NMI off (keeps sprite pattern bit) --------------
render_ctrl_off:
        lda     ppuctrl_shadow
        and     #$11
        sta     ppuctrl_shadow
        sta     PPUCTRL
        rts

; --- $C2C7: PPUCTRL |= $80 — NMI on ------------------------------------------
nmi_ctrl_on:
        lda     ppuctrl_shadow
        ora     #$80
        sta     ppuctrl_shadow
        sta     PPUCTRL
        rts

; --- $C2D1: rendering off (nested; NMI reduces to task step) -----------------
disable_rendering:
        inc     nmi_skip
        lda     #$00
        sta     ppumask_shadow
        sta     PPUMASK
        rts

; --- $C2DB: rendering on ------------------------------------------------------
enable_rendering:
        dec     nmi_skip
        lda     #$18
        sta     ppumask_shadow
        sta     PPUMASK
        rts

; =============================================================================
; READ CONTROLLERS — $C2E5
; Reads both pads (merged with expansion port), computes new-press
; (joyN_press) and held (joyN_held), applies U+D/L+R lockout, then
; discards controller 2 entirely.
; =============================================================================
read_controllers:
        ldx     #$01                    ; strobe
        stx     JOY1
        dex
        stx     JOY1
        ldx     #$08
LC2F0:  lda     JOY1                    ; 8 bits: pad 1 + expansion
        lsr     a
        rol     joy1_press
        lsr     a
        rol     temp_00
        lda     JOY2                    ; pad 2 + expansion
        lsr     a
        rol     joy2_press
        lsr     a
        rol     temp_01
        dex
        bne     LC2F0
        lda     temp_00                 ; merge expansion-port bits
        ora     joy1_press
        sta     joy1_press
        lda     temp_01
        ora     joy2_press
        sta     joy2_press
        ldx     #$01
LC313:  lda     joy1_press,x            ; press = (new ^ old) & new
        tay
        eor     joy1_held,x
        and     joy1_press,x
        sta     joy1_press,x
        sty     joy1_held,x
        dex
        bpl     LC313
        ldx     #$03
LC323:  lda     joy1_press,x            ; opposite-direction lockout:
        and     #$0C                    ; U+D or L+R -> drop the D-pad
        cmp     #$0C
        beq     LC333
        lda     joy1_press,x
        and     #$03
        cmp     #$03
        bne     LC339
LC333:  lda     joy1_press,x
        and     #$F0
        sta     joy1_press,x
LC339:  dex
        bpl     LC323
        lda     #$00                    ; controller 2 is discarded
        sta     joy2_press
        sta     joy2_held
        rts

; =============================================================================
; PPU FILL NAMETABLE — $C343
; A = PPU address hi ($20/$24/$28/$2C: full nametable incl. attributes),
; X = fill byte, Y = attribute fill byte. A < $20 fills Y*256 bytes.
; =============================================================================
ppu_fill_nametable:
        sta     temp_00
        stx     temp_01
        sty     temp_02
        lda     PPUSTATUS
        lda     ppuctrl_shadow
        and     #$FE
        sta     PPUCTRL
        lda     temp_00
        sta     PPUADDR
        ldy     #$00
        sty     PPUADDR
        ldx     #$04                    ; nametable: 4 pages
        cmp     #$20
        bcs     LC365
        ldx     temp_02                 ; below $2000: Y pages
LC365:  ldy     #$00
        lda     temp_01
LC369:  sta     PPUDATA
        dey
        bne     LC369
        dex
        bne     LC369
        ldy     temp_02
        lda     temp_00
        cmp     #$20
        bcc     LC38C
        adc     #$02                    ; attribute table at $x3C0
        sta     PPUADDR                 ; (carry set: +$300 total)
        lda     #$C0
        sta     PPUADDR
        ldx     #$40
LC386:  sty     PPUDATA                 ; 64 attribute bytes = Y
        dex
        bne     LC386
LC38C:  ldx     temp_01
        rts

; --- $C38F: clear OAM buffer (all sprites offscreen at Y=$F8) ----------------
oam_clear:
        ldx     #$00
oam_clear_from:  lda     #$F8
LC393:  sta     OAM_BUF,x
        inx
        inx
        inx
        inx
        bne     LC393
        rts

; =============================================================================
; ENTITY CLEAR ALL — $C39D
; Deactivates entity slots $01-$17 (player slot 0 untouched): clears
; type, behavior PC hi, stun, enemy HP; spawn index reset to $FF.
; =============================================================================
entity_clear_all:
        ldx     #ENT_SLOT_MAX
LC39F:  lda     #$00
        sta     ent_type,x
        sta     ent_bhv_pc_hi,x
        sta     ent_stun,x
        sta     ent_enemy_hp,x
        lda     #$FF
        sta     ent_spawn_idx,x
        dex
        bne     LC39F
        stx     $74
        rts

; ----------------------------------------------------------------------------
scroll_irq_reset:  lda     #$00                            ; C3B8 A9 00                    ..
        sta     $99                             ; C3BA 85 99                    ..
        sta     $46                             ; C3BC 85 46                    .F
        sta     $78                             ; C3BE 85 78                    .x
        sta     $79                             ; C3C0 85 79                    .y
        sta     $7A                             ; C3C2 85 7A                    .z
        sta     $7B                             ; C3C4 85 7B                    .{
        sta     $FA                             ; C3C6 85 FA                    ..
        sta     $FB                             ; C3C8 85 FB                    ..
        sta     $FC                             ; C3CA 85 FC                    ..
        sta     $FD                             ; C3CC 85 FD                    ..
        ldy     #$88                            ; C3CE A0 88                    ..
        sty     $9B                             ; C3D0 84 9B                    ..
        ldy     #$3F                            ; C3D2 A0 3F                    .?
LC3D4:  sta     $0680,y                         ; C3D4 99 80 06                 ...
        dey                                     ; C3D7 88                       .
        bpl     LC3D4                           ; C3D8 10 FA                    ..
        sta     $58                             ; C3DA 85 58                    .X
        lda     #$50                            ; C3DC A9 50                    .P
        sta     $57                             ; C3DE 85 57                    .W
        lda     $26                             ; C3E0 A5 26                    .&
        cmp     #$0A                            ; C3E2 C9 0A                    ..
        bne     LC3EA                           ; C3E4 D0 04                    ..
        lda     #$00                            ; C3E6 A9 00                    ..
        sta     $43                             ; C3E8 85 43                    .C
LC3EA:  rts                                     ; C3EA 60                       `

; ----------------------------------------------------------------------------
palette_fade_in:  lda     #$30                            ; C3EB A9 30                    .0
        ldx     #$F0                            ; C3ED A2 F0                    ..
        bne     LC3F4                           ; C3EF D0 03                    ..
palette_fade_out:  lda     #$10                            ; C3F1 A9 10                    ..
        tax                                     ; C3F3 AA                       .
LC3F4:  sta     $0F                             ; C3F4 85 0F                    ..
        stx     $0D                             ; C3F6 86 0D                    ..
        inc     $1B                             ; C3F8 E6 1B                    ..
        ldy     #$04                            ; C3FA A0 04                    ..
        sty     $0E                             ; C3FC 84 0E                    ..
LC3FE:  lda     $A9                             ; C3FE A5 A9                    ..
        pha                                     ; C400 48                       H
        ldy     #$1F                            ; C401 A0 1F                    ..
LC403:  tya                                     ; C403 98                       .
        and     #$03                            ; C404 29 03                    ).
        cmp     #$03                            ; C406 C9 03                    ..
        bne     LC414                           ; C408 D0 0A                    ..
        lsr     $A9                             ; C40A 46 A9                    F.
        bcc     LC414                           ; C40C 90 06                    ..
        dey                                     ; C40E 88                       .
        dey                                     ; C40F 88                       .
        dey                                     ; C410 88                       .
        jmp     LC421                           ; C411 4C 21 C4                 L!.

; ----------------------------------------------------------------------------
LC414:  lda     $0620,y                         ; C414 B9 20 06                 . .
        sec                                     ; C417 38                       8
        sbc     $0F                             ; C418 E5 0F                    ..
        bpl     LC41E                           ; C41A 10 02                    ..
        lda     #$0F                            ; C41C A9 0F                    ..
LC41E:  sta     $0600,y                         ; C41E 99 00 06                 ...
LC421:  dey                                     ; C421 88                       .
        bpl     LC403                           ; C422 10 DF                    ..
        lda     $0600                           ; C424 AD 00 06                 ...
        sta     $0610                           ; C427 8D 10 06                 ...
        sty     $18                             ; C42A 84 18                    ..
        pla                                     ; C42C 68                       h
        sta     $A9                             ; C42D 85 A9                    ..
        lda     $0E                             ; C42F A5 0E                    ..
LC431:  pha                                     ; C431 48                       H
        jsr     frame_wait                      ; C432 20 22 FF                  ".
        pla                                     ; C435 68                       h
        sec                                     ; C436 38                       8
        sbc     #$01                            ; C437 E9 01                    ..
        bne     LC431                           ; C439 D0 F6                    ..
        lda     $0F                             ; C43B A5 0F                    ..
        clc                                     ; C43D 18                       .
        adc     $0D                             ; C43E 65 0D                    e.
        sta     $0F                             ; C440 85 0F                    ..
        cmp     #$50                            ; C442 C9 50                    .P
        beq     LC44A                           ; C444 F0 04                    ..
        lda     $0F                             ; C446 A5 0F                    ..
        bpl     LC3FE                           ; C448 10 B4                    ..
LC44A:  lda     #$00                            ; C44A A9 00                    ..
        sta     $A9                             ; C44C 85 A9                    ..
        dec     $1B                             ; C44E C6 1B                    ..
        rts                                     ; C450 60                       `

; ----------------------------------------------------------------------------
        pla                                     ; C451 68                       h
        sta     $02                             ; C452 85 02                    ..
        pla                                     ; C454 68                       h
        sta     $03                             ; C455 85 03                    ..
        ldy     #$01                            ; C457 A0 01                    ..
        lda     ($02),y                         ; C459 B1 02                    ..
        sta     L0004                           ; C45B 85 04                    ..
        iny                                     ; C45D C8                       .
        lda     ($02),y                         ; C45E B1 02                    ..
        sta     $05                             ; C460 85 05                    ..
        ldy     #$00                            ; C462 A0 00                    ..
LC464:  lda     (L0004),y                       ; C464 B1 04                    ..
        beq     LC48B                           ; C466 F0 23                    .#
        sta     $2006                           ; C468 8D 06 20                 .. 
        jsr     LC49B                           ; C46B 20 9B C4                  ..
        lda     (L0004),y                       ; C46E B1 04                    ..
        sta     $2006                           ; C470 8D 06 20                 .. 
        jsr     LC49B                           ; C473 20 9B C4                  ..
        lda     (L0004),y                       ; C476 B1 04                    ..
        sta     $06                             ; C478 85 06                    ..
        jsr     LC49B                           ; C47A 20 9B C4                  ..
LC47D:  lda     (L0004),y                       ; C47D B1 04                    ..
        sta     $2007                           ; C47F 8D 07 20                 .. 
        jsr     LC49B                           ; C482 20 9B C4                  ..
        dec     $06                             ; C485 C6 06                    ..
        bpl     LC47D                           ; C487 10 F4                    ..
        bmi     LC464                           ; C489 30 D9                    0.
LC48B:  lda     $02                             ; C48B A5 02                    ..
        clc                                     ; C48D 18                       .
        adc     #$02                            ; C48E 69 02                    i.
        sta     $02                             ; C490 85 02                    ..
        lda     $03                             ; C492 A5 03                    ..
        adc     #$00                            ; C494 69 00                    i.
        pha                                     ; C496 48                       H
        lda     $02                             ; C497 A5 02                    ..
        pha                                     ; C499 48                       H
        rts                                     ; C49A 60                       `

; ----------------------------------------------------------------------------
LC49B:  iny                                     ; C49B C8                       .
        bne     LC4A0                           ; C49C D0 02                    ..
        inc     $05                             ; C49E E6 05                    ..
LC4A0:  rts                                     ; C4A0 60                       `

; =============================================================================
; TILE COLLISION, HORIZONTAL MOVEMENT — $C4A1
; Probes the entity's leading vertical edge. Shape (ent_shape via $40)
; selects an extent record (shape_row_h/probe_rec_h): probe count, edge
; X offset, per-probe Y deltas. Each probe resolves screen/block/quad
; through the stage bank's layout to the metatile collision nibble
; ($B100[id] & $F0), with dynamic-override and breakable-block checks.
; Results: coll_results[] per probe, coll_max, coll_or.
; Uses probe_y/x/screen ($11-$13), block index $22, quadrant temp_03.
; =============================================================================
tile_collide_horiz:  jsr     tile_collide_setup                           ; C4A1 20 DB C6                  ..
        lda     $17                             ; C4A4 A5 17                    ..
        and     #$08                            ; C4A6 29 08                    ).
        beq     LC4AD                           ; C4A8 F0 03                    ..
        jmp     LC5A7                           ; C4AA 4C A7 C5                 L..

; ----------------------------------------------------------------------------
LC4AD:  lda     shape_row_h,y                         ; C4AD B9 07 C8                 ...
        sta     $40                             ; C4B0 85 40                    .@
        tay                                     ; C4B2 A8                       .
        lda     probe_rec_h,y                         ; C4B3 B9 37 C8                 .7.
        sta     $06                             ; C4B6 85 06                    ..
        lda     #$00                            ; C4B8 A9 00                    ..
        sta     $02                             ; C4BA 85 02                    ..
        jsr     stage_y_clamp                           ; C4BC 20 AA C7                  ..
        .byte   $BD                             ; C4BF BD                       .
        .byte   $90                             ; C4C0 90                       .
LC4C1:  .byte   $03                             ; C4C1 03                       .
        sta     $03                             ; C4C2 85 03                    ..
        lda     probe_rec_h1,y                         ; C4C4 B9 38 C8                 .8.
        pha                                     ; C4C7 48                       H
        clc                                     ; C4C8 18                       .
        adc     $11                             ; C4C9 65 11                    e.
        sta     $11                             ; C4CB 85 11                    ..
        pla                                     ; C4CD 68                       h
        bmi     LC4E7                           ; C4CE 30 17                    0.
        bcs     LC4D8                           ; C4D0 B0 06                    ..
        lda     $11                             ; C4D2 A5 11                    ..
        cmp     #$F0                            ; C4D4 C9 F0                    ..
        bcc     LC504                           ; C4D6 90 2C                    .,
LC4D8:  lda     $46                             ; C4D8 A5 46                    .F
        beq     LC4F7                           ; C4DA F0 1B                    ..
        lda     $11                             ; C4DC A5 11                    ..
        adc     #$0F                            ; C4DE 69 0F                    i.
        sta     $11                             ; C4E0 85 11                    ..
        dec     $13                             ; C4E2 C6 13                    ..
        jmp     LC504                           ; C4E4 4C 04 C5                 L..

; ----------------------------------------------------------------------------
LC4E7:  bcs     LC504                           ; C4E7 B0 1B                    ..
        lda     $46                             ; C4E9 A5 46                    .F
        beq     LC4F7                           ; C4EB F0 0A                    ..
        lda     $11                             ; C4ED A5 11                    ..
        sbc     #$0F                            ; C4EF E9 0F                    ..
        sta     $11                             ; C4F1 85 11                    ..
        inc     $13                             ; C4F3 E6 13                    ..
        bne     LC504                           ; C4F5 D0 0D                    ..
LC4F7:  lda     #$00                            ; C4F7 A9 00                    ..
        ldy     $06                             ; C4F9 A4 06                    ..
LC4FB:  sta     $48,y                           ; C4FB 99 48 00                 .H.
        dey                                     ; C4FE 88                       .
        bpl     LC4FB                           ; C4FF 10 FA                    ..
        jmp     tile_collide_done                           ; C501 4C 37 C7                 L7.

; ----------------------------------------------------------------------------
LC504:  lda     $03                             ; C504 A5 03                    ..
        bne     LC4F7                           ; C506 D0 EF                    ..
        lda     $11                             ; C508 A5 11                    ..
        lsr     a                               ; C50A 4A                       J
        lsr     a                               ; C50B 4A                       J
        pha                                     ; C50C 48                       H
        and     #$38                            ; C50D 29 38                    )8
        sta     $22                             ; C50F 85 22                    ."
        pla                                     ; C511 68                       h
        lsr     a                               ; C512 4A                       J
        and     #$02                            ; C513 29 02                    ).
        sta     $03                             ; C515 85 03                    ..
        lda     #$00                            ; C517 A9 00                    ..
        sta     L0004                           ; C519 85 04                    ..
        lda     probe_rec_h2,y                         ; C51B B9 39 C8                 .9.
        bpl     LC522                           ; C51E 10 02                    ..
        dec     L0004                           ; C520 C6 04                    ..
LC522:  clc                                     ; C522 18                       .
        adc     $0330,x                         ; C523 7D 30 03                 }0.
        sta     $12                             ; C526 85 12                    ..
        lda     $13                             ; C528 A5 13                    ..
        adc     L0004                           ; C52A 65 04                    e.
        sta     $13                             ; C52C 85 13                    ..
        lda     $12                             ; C52E A5 12                    ..
        lsr     a                               ; C530 4A                       J
        lsr     a                               ; C531 4A                       J
        lsr     a                               ; C532 4A                       J
        lsr     a                               ; C533 4A                       J
        pha                                     ; C534 48                       H
        and     #$01                            ; C535 29 01                    ).
        ora     $03                             ; C537 05 03                    ..
        sta     $03                             ; C539 85 03                    ..
        pla                                     ; C53B 68                       h
        lsr     a                               ; C53C 4A                       J
        ora     $22                             ; C53D 05 22                    ."
        sta     $22                             ; C53F 85 22                    ."
LC541:  ldy     $13                             ; C541 A4 13                    ..
        jsr     screen_layout_ptr                           ; C543 20 A3 D7                  ..
LC546:  jsr     block_ptr_setup                           ; C546 20 58 D7                  X.
LC549:  ldy     $03                             ; C549 A4 03                    ..
        lda     (L0000),y                       ; C54B B1 00                    ..
        tay                                     ; C54D A8                       .
        lda     $B100,y                         ; C54E B9 00 B1                 ...
        and     #$F0                            ; C551 29 F0                    ).
        jsr     tile_override_lookup                           ; C553 20 4E C7                  N.
        jsr     breakable_block_check                           ; C556 20 7C C7                  |.
        ldy     $02                             ; C559 A4 02                    ..
        sta     $48,y                           ; C55B 99 48 00                 .H.
        cmp     $42                             ; C55E C5 42                    .B
        bcc     LC564                           ; C560 90 02                    ..
        sta     $42                             ; C562 85 42                    .B
LC564:  ora     $10                             ; C564 05 10                    ..
        sta     $10                             ; C566 85 10                    ..
        lda     $02                             ; C568 A5 02                    ..
        cmp     $06                             ; C56A C5 06                    ..
        beq     LC5A7                           ; C56C F0 39                    .9
        inc     $02                             ; C56E E6 02                    ..
        inc     $40                             ; C570 E6 40                    .@
        ldy     $40                             ; C572 A4 40                    .@
        lda     $12                             ; C574 A5 12                    ..
        pha                                     ; C576 48                       H
        and     #$10                            ; C577 29 10                    ).
        sta     L0004                           ; C579 85 04                    ..
        pla                                     ; C57B 68                       h
        clc                                     ; C57C 18                       .
        adc     probe_rec_h2,y                         ; C57D 79 39 C8                 y9.
        sta     $12                             ; C580 85 12                    ..
        and     #$10                            ; C582 29 10                    ).
        cmp     L0004                           ; C584 C5 04                    ..
        beq     LC549                           ; C586 F0 C1                    ..
        lda     $03                             ; C588 A5 03                    ..
        eor     #$01                            ; C58A 49 01                    I.
        sta     $03                             ; C58C 85 03                    ..
        and     #$01                            ; C58E 29 01                    ).
        bne     LC549                           ; C590 D0 B7                    ..
        inc     $22                             ; C592 E6 22                    ."
        lda     $22                             ; C594 A5 22                    ."
        and     #$07                            ; C596 29 07                    ).
        bne     LC546                           ; C598 D0 AC                    ..
        inc     $13                             ; C59A E6 13                    ..
        dec     $22                             ; C59C C6 22                    ."
        lda     $22                             ; C59E A5 22                    ."
        and     #$38                            ; C5A0 29 38                    )8
        sta     $22                             ; C5A2 85 22                    ."
        jmp     LC541                           ; C5A4 4C 41 C5                 LA.

; ----------------------------------------------------------------------------
LC5A7:  jmp     tile_collide_done                           ; C5A7 4C 37 C7                 L7.

; =============================================================================
; TILE COLLISION, VERTICAL MOVEMENT — $C5AA
; Vertical-edge counterpart of tile_collide_horiz (records via
; shape_row_v/probe_rec_v: probe count, edge Y offset, per-probe X
; deltas). Collision type $40 is treated as $20 (solid) here. Handles
; screen-top/bottom crossing, incl. vertical-scroll rooms (vscroll $46).
; =============================================================================
tile_collide_vert:  jsr     tile_collide_setup                           ; C5AA 20 DB C6                  ..
        lda     $17                             ; C5AD A5 17                    ..
        and     #$08                            ; C5AF 29 08                    ).
        beq     LC5B6                           ; C5B1 F0 03                    ..
        jmp     LC6D8                           ; C5B3 4C D8 C6                 L..

; ----------------------------------------------------------------------------
LC5B6:  lda     shape_row_v,y                         ; C5B6 B9 E2 C8                 ...
        sta     $40                             ; C5B9 85 40                    .@
        tay                                     ; C5BB A8                       .
        lda     probe_rec_v,y                         ; C5BC B9 12 C9                 ...
        sta     $06                             ; C5BF 85 06                    ..
        lda     #$00                            ; C5C1 A9 00                    ..
        sta     $02                             ; C5C3 85 02                    ..
        lda     #$00                            ; C5C5 A9 00                    ..
        sta     L0004                           ; C5C7 85 04                    ..
        sta     $05                             ; C5C9 85 05                    ..
        lda     probe_rec_v1,y                         ; C5CB B9 13 C9                 ...
        bpl     LC5D2                           ; C5CE 10 02                    ..
        dec     L0004                           ; C5D0 C6 04                    ..
LC5D2:  clc                                     ; C5D2 18                       .
        adc     $0330,x                         ; C5D3 7D 30 03                 }0.
        sta     $12                             ; C5D6 85 12                    ..
        lda     $13                             ; C5D8 A5 13                    ..
        adc     L0004                           ; C5DA 65 04                    e.
        sta     $13                             ; C5DC 85 13                    ..
        lda     $12                             ; C5DE A5 12                    ..
        lsr     a                               ; C5E0 4A                       J
        lsr     a                               ; C5E1 4A                       J
        lsr     a                               ; C5E2 4A                       J
        lsr     a                               ; C5E3 4A                       J
        pha                                     ; C5E4 48                       H
        and     #$01                            ; C5E5 29 01                    ).
        sta     $03                             ; C5E7 85 03                    ..
        pla                                     ; C5E9 68                       h
        lsr     a                               ; C5EA 4A                       J
        sta     $22                             ; C5EB 85 22                    ."
        lda     $0390,x                         ; C5ED BD 90 03                 ...
        bmi     LC630                           ; C5F0 30 3E                    0>
        bne     LC618                           ; C5F2 D0 24                    .$
        lda     $11                             ; C5F4 A5 11                    ..
        clc                                     ; C5F6 18                       .
        adc     probe_rec_v2,y                         ; C5F7 79 14 C9                 y..
        sta     $11                             ; C5FA 85 11                    ..
        lda     probe_rec_v2,y                         ; C5FC B9 14 C9                 ...
LC5FF:  bmi     LC620                           ; C5FF 30 1F                    0.
        bcs     LC609                           ; C601 B0 06                    ..
        lda     $11                             ; C603 A5 11                    ..
        cmp     #$F0                            ; C605 C9 F0                    ..
        bcc     LC636                           ; C607 90 2D                    .-
LC609:  lda     $46                             ; C609 A5 46                    .F
        beq     LC618                           ; C60B F0 0B                    ..
        lda     $11                             ; C60D A5 11                    ..
        adc     #$0F                            ; C60F 69 0F                    i.
        sta     $11                             ; C611 85 11                    ..
        dec     $13                             ; C613 C6 13                    ..
        jmp     LC636                           ; C615 4C 36 C6                 L6.

; ----------------------------------------------------------------------------
LC618:  lda     #$EF                            ; C618 A9 EF                    ..
        sta     $11                             ; C61A 85 11                    ..
        inc     $05                             ; C61C E6 05                    ..
        bne     LC636                           ; C61E D0 16                    ..
LC620:  bcs     LC636                           ; C620 B0 14                    ..
        lda     $46                             ; C622 A5 46                    .F
        beq     LC630                           ; C624 F0 0A                    ..
        lda     $11                             ; C626 A5 11                    ..
        sbc     #$0F                            ; C628 E9 0F                    ..
        sta     $11                             ; C62A 85 11                    ..
        inc     $13                             ; C62C E6 13                    ..
        bne     LC636                           ; C62E D0 06                    ..
LC630:  lda     #$00                            ; C630 A9 00                    ..
        sta     $11                             ; C632 85 11                    ..
        inc     $05                             ; C634 E6 05                    ..
LC636:  lda     $11                             ; C636 A5 11                    ..
        lsr     a                               ; C638 4A                       J
        lsr     a                               ; C639 4A                       J
        pha                                     ; C63A 48                       H
        and     #$38                            ; C63B 29 38                    )8
        ora     $22                             ; C63D 05 22                    ."
        sta     $22                             ; C63F 85 22                    ."
        pla                                     ; C641 68                       h
        lsr     a                               ; C642 4A                       J
        and     #$02                            ; C643 29 02                    ).
        ora     $03                             ; C645 05 03                    ..
        sta     $03                             ; C647 85 03                    ..
LC649:  ldy     $13                             ; C649 A4 13                    ..
        jsr     screen_layout_ptr                           ; C64B 20 A3 D7                  ..
LC64E:  jsr     block_ptr_setup                           ; C64E 20 58 D7                  X.
LC651:  ldy     $03                             ; C651 A4 03                    ..
        lda     (L0000),y                       ; C653 B1 00                    ..
        tay                                     ; C655 A8                       .
        lda     $B100,y                         ; C656 B9 00 B1                 ...
        and     #$F0                            ; C659 29 F0                    ).
        cmp     #$40                            ; C65B C9 40                    .@
        bne     LC661                           ; C65D D0 02                    ..
        lda     #$20                            ; C65F A9 20                    . 
LC661:  jsr     tile_override_lookup                           ; C661 20 4E C7                  N.
        jsr     breakable_block_check                           ; C664 20 7C C7                  |.
        ldy     $02                             ; C667 A4 02                    ..
        sta     $48,y                           ; C669 99 48 00                 .H.
        cmp     $42                             ; C66C C5 42                    .B
        bcc     LC672                           ; C66E 90 02                    ..
        sta     $42                             ; C670 85 42                    .B
LC672:  ora     $10                             ; C672 05 10                    ..
        sta     $10                             ; C674 85 10                    ..
        lda     $02                             ; C676 A5 02                    ..
        cmp     $06                             ; C678 C5 06                    ..
        beq     LC6D8                           ; C67A F0 5C                    .\
        inc     $02                             ; C67C E6 02                    ..
        inc     $40                             ; C67E E6 40                    .@
        lda     $05                             ; C680 A5 05                    ..
        bne     LC651                           ; C682 D0 CD                    ..
        ldy     $40                             ; C684 A4 40                    .@
        lda     $11                             ; C686 A5 11                    ..
        pha                                     ; C688 48                       H
        and     #$10                            ; C689 29 10                    ).
        sta     L0004                           ; C68B 85 04                    ..
        pla                                     ; C68D 68                       h
        clc                                     ; C68E 18                       .
        adc     probe_rec_v2,y                         ; C68F 79 14 C9                 y..
        sta     $11                             ; C692 85 11                    ..
        and     #$10                            ; C694 29 10                    ).
        cmp     L0004                           ; C696 C5 04                    ..
        beq     LC651                           ; C698 F0 B7                    ..
        lda     $03                             ; C69A A5 03                    ..
        eor     #$02                            ; C69C 49 02                    I.
        sta     $03                             ; C69E 85 03                    ..
        and     #$02                            ; C6A0 29 02                    ).
        beq     LC6B8                           ; C6A2 F0 14                    ..
        lda     $22                             ; C6A4 A5 22                    ."
        cmp     #$38                            ; C6A6 C9 38                    .8
        bcc     LC651                           ; C6A8 90 A7                    ..
        lda     $46                             ; C6AA A5 46                    .F
        bne     LC6C1                           ; C6AC D0 13                    ..
        lda     $03                             ; C6AE A5 03                    ..
        eor     #$02                            ; C6B0 49 02                    I.
        sta     $03                             ; C6B2 85 03                    ..
        inc     $05                             ; C6B4 E6 05                    ..
        bne     LC651                           ; C6B6 D0 99                    ..
LC6B8:  lda     $22                             ; C6B8 A5 22                    ."
        clc                                     ; C6BA 18                       .
        adc     #$08                            ; C6BB 69 08                    i.
        sta     $22                             ; C6BD 85 22                    ."
        bne     LC64E                           ; C6BF D0 8D                    ..
LC6C1:  lda     $11                             ; C6C1 A5 11                    ..
        and     #$0F                            ; C6C3 29 0F                    ).
        sta     $11                             ; C6C5 85 11                    ..
        lda     $22                             ; C6C7 A5 22                    ."
        and     #$07                            ; C6C9 29 07                    ).
        sta     $22                             ; C6CB 85 22                    ."
        lda     $03                             ; C6CD A5 03                    ..
        and     #$01                            ; C6CF 29 01                    ).
        sta     $03                             ; C6D1 85 03                    ..
        dec     $13                             ; C6D3 C6 13                    ..
        jmp     LC649                           ; C6D5 4C 49 C6                 LI.

; ----------------------------------------------------------------------------
LC6D8:  jmp     tile_collide_done                           ; C6D8 4C 37 C7                 L7.

; -----------------------------------------------------------------------------
; TILE COLLISION SETUP — $C6DB
; Clears coll_or/coll_max, saves the $A000 bank ($F1), seeds probe
; screen/Y from the entity. In vertical-scroll rooms converts to
; camera-relative coordinates via scroll_y/scroll_y_hi (stage banks
; $0C/$0E get special-case handling).
; -----------------------------------------------------------------------------
tile_collide_setup:  lda     #$00                            ; C6DB A9 00                    ..
        sta     $10                             ; C6DD 85 10                    ..
        sta     $42                             ; C6DF 85 42                    .B
        lda     $F6                             ; C6E1 A5 F6                    ..
        sta     $F1                             ; C6E3 85 F1                    ..
        lda     $0348,x                         ; C6E5 BD 48 03                 .H.
        sta     $13                             ; C6E8 85 13                    ..
        lda     $0378,x                         ; C6EA BD 78 03                 .x.
        sta     $11                             ; C6ED 85 11                    ..
        lda     $46                             ; C6EF A5 46                    .F
        beq     LC736                           ; C6F1 F0 43                    .C
        lda     $26                             ; C6F3 A5 26                    .&
        cmp     #$0E                            ; C6F5 C9 0E                    ..
        bne     LC705                           ; C6F7 D0 0C                    ..
        lda     $11                             ; C6F9 A5 11                    ..
        cmp     #$60                            ; C6FB C9 60                    .`
        bcc     LC736                           ; C6FD 90 37                    .7
        clc                                     ; C6FF 18                       .
        adc     $79                             ; C700 65 79                    ey
        sta     $11                             ; C702 85 11                    ..
        rts                                     ; C704 60                       `

; ----------------------------------------------------------------------------
LC705:  lda     $0390,x                         ; C705 BD 90 03                 ...
        beq     LC712                           ; C708 F0 08                    ..
        lda     $13                             ; C70A A5 13                    ..
        sec                                     ; C70C 38                       8
        sbc     $0390,x                         ; C70D FD 90 03                 ...
        sta     $13                             ; C710 85 13                    ..
LC712:  lda     $13                             ; C712 A5 13                    ..
        clc                                     ; C714 18                       .
        adc     $FB                             ; C715 65 FB                    e.
        sta     $13                             ; C717 85 13                    ..
        lda     $0378,x                         ; C719 BD 78 03                 .x.
        clc                                     ; C71C 18                       .
        adc     $FA                             ; C71D 65 FA                    e.
        bcs     LC725                           ; C71F B0 04                    ..
        cmp     #$F0                            ; C721 C9 F0                    ..
        bcc     LC729                           ; C723 90 04                    ..
LC725:  dec     $13                             ; C725 C6 13                    ..
        adc     #$0F                            ; C727 69 0F                    i.
LC729:  sta     $11                             ; C729 85 11                    ..
        lda     $26                             ; C72B A5 26                    .&
        cmp     #$0C                            ; C72D C9 0C                    ..
        bne     LC736                           ; C72F D0 05                    ..
        lda     $0348,x                         ; C731 BD 48 03                 .H.
        sta     $13                             ; C734 85 13                    ..
LC736:  rts                                     ; C736 60                       `

; -----------------------------------------------------------------------------
; TILE COLLISION EPILOGUE — $C737
; For the player: latches coll_max >= $D0 (spikes etc.) into $36.
; Restores the saved $A000 bank and remaps.
; -----------------------------------------------------------------------------
tile_collide_done:  cpx     #$00                            ; C737 E0 00                    ..
        bne     LC747                           ; C739 D0 0C                    ..
        lda     $36                             ; C73B A5 36                    .6
        bne     LC747                           ; C73D D0 08                    ..
        lda     $42                             ; C73F A5 42                    .B
        cmp     #$D0                            ; C741 C9 D0                    ..
        bcc     LC747                           ; C743 90 02                    ..
        sta     $36                             ; C745 85 36                    .6
LC747:  lda     $F1                             ; C747 A5 F1                    ..
        sta     $F6                             ; C749 85 F6                    ..
        jmp     bank_load_shadow                ; C74B 4C 43 FF                 LC.

; -----------------------------------------------------------------------------
; DYNAMIC TILE OVERRIDE — $C74E
; Scans $43/4 records at $06C0 ([screen, block, quad, metatile id]);
; on match returns the override metatile's collision nibble instead.
; -----------------------------------------------------------------------------
tile_override_lookup:  sta     $07                             ; C74E 85 07                    ..
        ldy     $43                             ; C750 A4 43                    .C
        beq     LC779                           ; C752 F0 25                    .%
LC754:  lda     $06BC,y                         ; C754 B9 BC 06                 ...
        cmp     $13                             ; C757 C5 13                    ..
        bne     LC773                           ; C759 D0 18                    ..
        lda     $06BD,y                         ; C75B B9 BD 06                 ...
        cmp     $22                             ; C75E C5 22                    ."
        bne     LC773                           ; C760 D0 11                    ..
        lda     $06BE,y                         ; C762 B9 BE 06                 ...
        cmp     $03                             ; C765 C5 03                    ..
        bne     LC773                           ; C767 D0 0A                    ..
        lda     $06BF,y                         ; C769 B9 BF 06                 ...
        tay                                     ; C76C A8                       .
        lda     $B100,y                         ; C76D B9 00 B1                 ...
        and     #$F0                            ; C770 29 F0                    ).
        rts                                     ; C772 60                       `

; ----------------------------------------------------------------------------
LC773:  dey                                     ; C773 88                       .
        dey                                     ; C774 88                       .
        dey                                     ; C775 88                       .
        dey                                     ; C776 88                       .
        bne     LC754                           ; C777 D0 DB                    ..
LC779:  lda     $07                             ; C779 A5 07                    ..
        rts                                     ; C77B 60                       `

; -----------------------------------------------------------------------------
; BREAKABLE BLOCK CHECK — $C77C
; Tests the block's bit in the $0680 destroyed-block bitmap (bit/byte
; tables at probe-time via $F2B2/$F2C2). Destroyed solid -> passable.
; $1E disables the check.
; -----------------------------------------------------------------------------
breakable_block_check:  pha                                     ; C77C 48                       H
        lda     $1E                             ; C77D A5 1E                    ..
        bne     LC7A8                           ; C77F D0 27                    .'
        lda     $22                             ; C781 A5 22                    ."
        and     #$01                            ; C783 29 01                    ).
        asl     a                               ; C785 0A                       .
        asl     a                               ; C786 0A                       .
        ora     $03                             ; C787 05 03                    ..
        tay                                     ; C789 A8                       .
        lda     bit_masks,y                         ; C78A B9 B2 F2                 ...
        sta     $07                             ; C78D 85 07                    ..
        lda     $13                             ; C78F A5 13                    ..
        and     #$01                            ; C791 29 01                    ).
        tay                                     ; C793 A8                       .
        lda     $22                             ; C794 A5 22                    ."
        lsr     a                               ; C796 4A                       J
        ora     scr_parity_ofs,y                         ; C797 19 C2 F2                 ...
        tay                                     ; C79A A8                       .
        lda     $0680,y                         ; C79B B9 80 06                 ...
        and     $07                             ; C79E 25 07                    %.
        beq     LC7A8                           ; C7A0 F0 06                    ..
        pla                                     ; C7A2 68                       h
        and     #$10                            ; C7A3 29 10                    ).
        eor     #$10                            ; C7A5 49 10                    I.
        pha                                     ; C7A7 48                       H
LC7A8:  pla                                     ; C7A8 68                       h
        rts                                     ; C7A9 60                       `

; -----------------------------------------------------------------------------
; PER-STAGE Y CLAMP — $C7AA
; In vertical rooms, clamps probes below a per-stage-bank floor line
; (stage_clamp_y/scr tables) back to the entity's own Y/screen.
; -----------------------------------------------------------------------------
stage_y_clamp:  sty     L0000                           ; C7AA 84 00                    ..
        ldy     $26                             ; C7AC A4 26                    .&
        lda     stage_clamp_y,y                         ; C7AE B9 E7 C7                 ...
        sta     $01                             ; C7B1 85 01                    ..
        lda     stage_clamp_scr,y                         ; C7B3 B9 F7 C7                 ...
        sta     $03                             ; C7B6 85 03                    ..
        ldy     L0000                           ; C7B8 A4 00                    ..
        lda     $46                             ; C7BA A5 46                    .F
        beq     LC7E6                           ; C7BC F0 28                    .(
        lda     $01                             ; C7BE A5 01                    ..
        beq     LC7E6                           ; C7C0 F0 24                    .$
        lda     $26                             ; C7C2 A5 26                    .&
        cmp     #$0C                            ; C7C4 C9 0C                    ..
        bne     LC7CC                           ; C7C6 D0 04                    ..
        cpx     #$00                            ; C7C8 E0 00                    ..
        beq     LC7E6                           ; C7CA F0 1A                    ..
LC7CC:  lda     probe_rec_h1,y                         ; C7CC B9 38 C8                 .8.
        bmi     LC7E6                           ; C7CF 30 15                    0.
        clc                                     ; C7D1 18                       .
        adc     $0378,x                         ; C7D2 7D 78 03                 }x.
        bcs     LC7E6                           ; C7D5 B0 0F                    ..
        cmp     $01                             ; C7D7 C5 01                    ..
        bcc     LC7E6                           ; C7D9 90 0B                    ..
        lda     $0378,x                         ; C7DB BD 78 03                 .x.
        sta     $11                             ; C7DE 85 11                    ..
        lda     $03                             ; C7E0 A5 03                    ..
        bmi     LC7E6                           ; C7E2 30 02                    0.
        sta     $13                             ; C7E4 85 13                    ..
LC7E6:  rts                                     ; C7E6 60                       `

; ----------------------------------------------------------------------------
; -----------------------------------------------------------------------------
; COLLISION SHAPE TABLES — $C7E7-$C9DC
; shape_row_* index (from ent_shape) selects a variable-length extent
; record: probe count-1, edge offset, then per-probe axis deltas.
; -----------------------------------------------------------------------------
stage_clamp_y:  ; per-stage-bank Y clamp threshold (vertical rooms)
        .byte   $00,$00,$00,$C0,$00,$00,$00,$00,$00,$00,$00,$C0,$D0,$00,$00,$00   ; C7E7
stage_clamp_scr:  ; per-stage-bank clamp screen value
        .byte   $00,$00,$00,$13,$00,$00,$00,$00,$00,$00,$00,$00,$FF,$00,$00,$00   ; C7F7
shape_row_h:  ; shape -> extent record offset (horizontal probes)
        .byte   $00,$05,$09,$0E,$13,$18,$1D,$20,$24,$28,$2D,$32,$36,$3A,$3F,$44   ; C807
        .byte   $49,$4E,$52,$56,$59,$5C,$61,$66,$6A,$6E,$73,$78,$7C,$7F,$82,$87   ; C817
        .byte   $8C,$8F,$93,$97,$9A,$9D,$A1,$A5,$A8,$AB,$AB,$AB,$AB,$AB,$AB,$AB   ; C827
probe_rec_h:  ; records: [count-1][y offset][x deltas...] (via +0/+1/+2 below)
        .byte   $02   ; C837
probe_rec_h1:
        .byte   $0C   ; C838
probe_rec_h2:
        .byte   $F9,$07,$07,$01,$F6,$F9,$0E,$02,$F2,$F2,$0E,$0E,$02,$0C,$F2,$0E   ; C839
        .byte   $0E,$02,$0A,$F2,$0E,$0E,$02,$F8,$F2,$0E,$0E,$00,$00,$00,$01,$06   ; C849
        .byte   $FB,$0A,$01,$FA,$FB,$0A,$02,$10,$F5,$0B,$0B,$02,$F0,$F5,$0B,$0B   ; C859
        .byte   $01,$04,$F9,$0E,$01,$FC,$F9,$0E,$02,$10,$F1,$0F,$0F,$02,$F0,$F1   ; C869
        .byte   $0F,$0F,$02,$1C,$F1,$0F,$0F,$02,$E4,$F1,$0F,$0F,$01,$14,$F9,$0E   ; C879
        .byte   $01,$EC,$F9,$0E,$00,$04,$00,$00,$FC,$00,$02,$0C,$F5,$0B,$0B,$02   ; C889
        .byte   $F4,$F5,$0B,$0B,$01,$08,$F9,$0E,$01,$F8,$F9,$0E,$02,$14,$F5,$0B   ; C899
        .byte   $0B,$02,$EC,$F5,$0B,$0B,$01,$00,$F9,$0E,$00,$10,$00,$00,$F0,$00   ; C8A9
        .byte   $02,$0C,$F1,$0F,$0F,$02,$F4,$F1,$0F,$0F,$00,$36,$00,$01,$0C,$F9   ; C8B9
        .byte   $0E,$01,$F4,$F9,$0E,$00,$08,$00,$00,$F8,$00,$01,$FA,$F9,$0E,$01   ; C8C9
        .byte   $05,$F9,$0E,$00,$0C,$00,$00,$F4,$00   ; C8D9
shape_row_v:  ; shape -> extent record offset (vertical probes)
        .byte   $00,$05,$0A,$0F,$14,$18,$1C,$20,$24,$27,$2A,$2F,$34,$38,$3C,$40   ; C8E2
        .byte   $44,$49,$4E,$55,$5C,$62,$68,$6D,$72,$77,$7C,$7F,$82,$86,$8A,$8D   ; C8F2
        .byte   $90,$94,$98,$9B,$9E,$A3,$A8,$AE,$B4,$B9,$BE,$C1,$C4,$C8,$CB,$CB   ; C902
probe_rec_v:  ; records: [count-1][x offset][y deltas...]
        .byte   $02   ; C912
probe_rec_v1:
        .byte   $08   ; C913
probe_rec_v2:
        .byte   $F7,$09,$0B,$02,$F8,$F7,$09,$0B,$02,$00,$F5,$0B,$05,$02,$00,$FB   ; C914
        .byte   $05,$0B,$01,$0F,$FB,$0E,$01,$F1,$FB,$0E,$01,$0F,$F9,$00,$01,$F1   ; C924
        .byte   $F9,$00,$00,$0F,$04,$00,$F1,$04,$02,$0C,$F1,$0F,$0F,$02,$F4,$F1   ; C934
        .byte   $0F,$0F,$01,$08   ; C944
LC948:
        .byte   $FD,$06   ; C948
LC94A:
        .byte   $01,$F8,$FD,$06,$01   ; C94A
LC94F:
        .byte   $06,$FB,$0A,$01,$FA,$FB,$0A,$02,$10,$F1,$0F,$0F,$02,$F0,$F1,$0F   ; C94F
        .byte   $0F,$04,$10,$E5,$0F,$0F,$0F,$09,$04,$F0,$E5,$0F,$0F,$0F,$09,$03   ; C95F
        .byte   $08,$ED,$10,$10,$06,$03,$F8,$ED,$10,$10,$06,$02,$0C,$F5,$0B,$0B   ; C96F
        .byte   $02,$F4,$F5,$0B,$0B,$02,$07,$F5,$0B,$0B,$02,$F9,$F5,$0B,$0B,$00   ; C97F
        .byte   $04,$00,$00,$FC,$00,$01,$08,$F9,$0E,$01,$F8,$F9,$0E,$00,$0C,$00   ; C98F
        .byte   $00,$F4,$00,$01,$10,$00,$0C,$01,$F1   ; C99F
LC9A8:
        .byte   $00,$0C,$00,$14,$00   ; C9A8
LC9AD:
        .byte   $00,$EC,$00,$02,$10,$F5,$0B,$0B,$02,$F0,$F5,$0B,$0B,$03,$0C,$ED   ; C9AD
        .byte   $10,$10,$06,$03,$F4,$ED,$10,$10,$06,$02,$08,$F5,$0B,$0B,$02,$F8   ; C9BD
        .byte   $F5,$0B,$0B,$00,$08,$00,$00,$F8,$00,$01,$00,$FA,$08,$00,$00,$05   ; C9CD
LC9DD:  lda     $26                             ; C9DD A5 26                    .&
        cmp     #$01                            ; C9DF C9 01                    ..
        bne     LCA31                           ; C9E1 D0 4E                    .N
        lda     $29                             ; C9E3 A5 29                    .)
        and     #$1F                            ; C9E5 29 1F                    ).
        cmp     #$08                            ; C9E7 C9 08                    ..
        beq     LC9EF                           ; C9E9 F0 04                    ..
        cmp     #$0A                            ; C9EB C9 0A                    ..
        bne     LCA31                           ; C9ED D0 42                    .B
LC9EF:  lda     $99                             ; C9EF A5 99                    ..
        bne     LCA03                           ; C9F1 D0 10                    ..
        sta     $78                             ; C9F3 85 78                    .x
        sta     $79                             ; C9F5 85 79                    .y
        lda     #$4F                            ; C9F7 A9 4F                    .O
        sta     $7A                             ; C9F9 85 7A                    .z
        lda     #$40                            ; C9FB A9 40                    .@
        sta     $9B                             ; C9FD 85 9B                    ..
        lda     #$04                            ; C9FF A9 04                    ..
        sta     $99                             ; CA01 85 99                    ..
LCA03:  lda     $0330                           ; CA03 AD 30 03                 .0.
        clc                                     ; CA06 18                       .
        adc     #$03                            ; CA07 69 03                    i.
        sta     $0330                           ; CA09 8D 30 03                 .0.
        lda     $0348                           ; CA0C AD 48 03                 .H.
        adc     #$00                            ; CA0F 69 00                    i.
        sta     $0348                           ; CA11 8D 48 03                 .H.
        lda     $FC                             ; CA14 A5 FC                    ..
        bne     LCA24                           ; CA16 D0 0C                    ..
        sta     $11                             ; CA18 85 11                    ..
        lda     $F9                             ; CA1A A5 F9                    ..
        cmp     #$23                            ; CA1C C9 23                    .#
        beq     LCA2E                           ; CA1E F0 0E                    ..
        cmp     #$3F                            ; CA20 C9 3F                    .?
        beq     LCA2E                           ; CA22 F0 0A                    ..
LCA24:  inc     $78                             ; CA24 E6 78                    .x
        inc     $79                             ; CA26 E6 79                    .y
        inc     $79                             ; CA28 E6 79                    .y
        lda     #$03                            ; CA2A A9 03                    ..
        sta     $11                             ; CA2C 85 11                    ..
LCA2E:  jmp     LCAB4                           ; CA2E 4C B4 CA                 L..

; ----------------------------------------------------------------------------
LCA31:  lda     $30                             ; CA31 A5 30                    .0
        cmp     #$22                            ; CA33 C9 22                    ."
        bne     LCA38                           ; CA35 D0 01                    ..
        rts                                     ; CA37 60                       `

; ----------------------------------------------------------------------------
LCA38:  lda     $29                             ; CA38 A5 29                    .)
        and     #$C0                            ; CA3A 29 C0                    ).
        bne     LCA59                           ; CA3C D0 1B                    ..
        lda     $0330                           ; CA3E AD 30 03                 .0.
        sec                                     ; CA41 38                       8
        sbc     $FC                             ; CA42 E5 FC                    ..
        sta     $10                             ; CA44 85 10                    ..
        lda     $0330                           ; CA46 AD 30 03                 .0.
        sec                                     ; CA49 38                       8
        sbc     $3C                             ; CA4A E5 3C                    .<
        sta     $11                             ; CA4C 85 11                    ..
        lda     $0348                           ; CA4E AD 48 03                 .H.
        sbc     $3D                             ; CA51 E5 3D                    .=
        ora     $11                             ; CA53 05 11                    ..
        bcc     LCA5C                           ; CA55 90 05                    ..
        bne     LCAA4                           ; CA57 D0 4B                    .K
LCA59:  jmp     scroll_vert_update                           ; CA59 4C 10 CD                 L..

; ----------------------------------------------------------------------------
LCA5C:  lda     $10                             ; CA5C A5 10                    ..
        cmp     #$81                            ; CA5E C9 81                    ..
        bcs     LCA59                           ; CA60 B0 F7                    ..
        lda     $11                             ; CA62 A5 11                    ..
        eor     #$FF                            ; CA64 49 FF                    I.
        adc     #$01                            ; CA66 69 01                    i.
        cmp     #$08                            ; CA68 C9 08                    ..
        bcc     LCA6E                           ; CA6A 90 02                    ..
        lda     #$08                            ; CA6C A9 08                    ..
LCA6E:  sta     $11                             ; CA6E 85 11                    ..
        lda     $FC                             ; CA70 A5 FC                    ..
        sec                                     ; CA72 38                       8
        sbc     $11                             ; CA73 E5 11                    ..
        sta     $FC                             ; CA75 85 FC                    ..
        php                                     ; CA77 08                       .
        lda     $F9                             ; CA78 A5 F9                    ..
        sta     $11                             ; CA7A 85 11                    ..
        sbc     #$00                            ; CA7C E9 00                    ..
        sta     $F9                             ; CA7E 85 F9                    ..
        plp                                     ; CA80 28                       (
        lda     $2B                             ; CA81 A5 2B                    .+
        sbc     #$00                            ; CA83 E9 00                    ..
        sta     $2B                             ; CA85 85 2B                    .+
        bcs     LCAA0                           ; CA87 B0 17                    ..
        lda     #$00                            ; CA89 A9 00                    ..
        sta     $FC                             ; CA8B 85 FC                    ..
        sta     $2B                             ; CA8D 85 2B                    .+
        lda     $11                             ; CA8F A5 11                    ..
        sta     $F9                             ; CA91 85 F9                    ..
        lda     #$10                            ; CA93 A9 10                    ..
        cmp     $0330                           ; CA95 CD 30 03                 .0.
        bcc     LCAA0                           ; CA98 90 06                    ..
        sta     $0330                           ; CA9A 8D 30 03                 .0.
        jmp     section_retreat                           ; CA9D 4C 49 CC                 LI.

; ----------------------------------------------------------------------------
LCAA0:  lda     #$02                            ; CAA0 A9 02                    ..
        bne     LCAE9                           ; CAA2 D0 45                    .E
LCAA4:  beq     LCAE6                           ; CAA4 F0 40                    .@
        lda     $10                             ; CAA6 A5 10                    ..
        cmp     #$80                            ; CAA8 C9 80                    ..
        bcc     LCAE6                           ; CAAA 90 3A                    .:
        lda     #$08                            ; CAAC A9 08                    ..
        cmp     $11                             ; CAAE C5 11                    ..
        bcs     LCAB4                           ; CAB0 B0 02                    ..
        sta     $11                             ; CAB2 85 11                    ..
LCAB4:  lda     $FC                             ; CAB4 A5 FC                    ..
        clc                                     ; CAB6 18                       .
        adc     $11                             ; CAB7 65 11                    e.
        sta     $FC                             ; CAB9 85 FC                    ..
        php                                     ; CABB 08                       .
        lda     $F9                             ; CABC A5 F9                    ..
        adc     #$00                            ; CABE 69 00                    i.
        sta     $F9                             ; CAC0 85 F9                    ..
        plp                                     ; CAC2 28                       (
        lda     $2B                             ; CAC3 A5 2B                    .+
        adc     #$00                            ; CAC5 69 00                    i.
        sta     $2B                             ; CAC7 85 2B                    .+
        cmp     $2A                             ; CAC9 C5 2A                    .*
        bne     LCAE2                           ; CACB D0 15                    ..
        lda     #$00                            ; CACD A9 00                    ..
        sta     $FC                             ; CACF 85 FC                    ..
        lda     #$F0                            ; CAD1 A9 F0                    ..
        cmp     $0330                           ; CAD3 CD 30 03                 .0.
        bcs     LCAE2                           ; CAD6 B0 0A                    ..
        sta     $0330                           ; CAD8 8D 30 03                 .0.
        lda     #$00                            ; CADB A9 00                    ..
        sta     $FC                             ; CADD 85 FC                    ..
        jmp     section_advance                           ; CADF 4C 5F CB                 L_.

; ----------------------------------------------------------------------------
LCAE2:  lda     #$01                            ; CAE2 A9 01                    ..
        bne     LCAE9                           ; CAE4 D0 03                    ..
LCAE6:  jmp     scroll_vert_update                           ; CAE6 4C 10 CD                 L..

; ----------------------------------------------------------------------------
LCAE9:  sta     $10                             ; CAE9 85 10                    ..
        sta     $AC                             ; CAEB 85 AC                    ..
        lda     $FC                             ; CAED A5 FC                    ..
        sec                                     ; CAEF 38                       8
        sbc     $44                             ; CAF0 E5 44                    .D
        bpl     LCAF9                           ; CAF2 10 05                    ..
        eor     #$FF                            ; CAF4 49 FF                    I.
        clc                                     ; CAF6 18                       .
        adc     #$01                            ; CAF7 69 01                    i.
LCAF9:  sta     $11                             ; CAF9 85 11                    ..
        beq     LCAE6                           ; CAFB F0 E9                    ..
        lda     $10                             ; CAFD A5 10                    ..
        and     #$01                            ; CAFF 29 01                    ).
        beq     LCB08                           ; CB01 F0 05                    ..
        lda     $44                             ; CB03 A5 44                    .D
        jmp     LCB0C                           ; CB05 4C 0C CB                 L..

; ----------------------------------------------------------------------------
LCB08:  lda     $44                             ; CB08 A5 44                    .D
        eor     #$FF                            ; CB0A 49 FF                    I.
LCB0C:  and     #$07                            ; CB0C 29 07                    ).
        clc                                     ; CB0E 18                       .
        adc     $11                             ; CB0F 65 11                    e.
        lsr     a                               ; CB11 4A                       J
        lsr     a                               ; CB12 4A                       J
        lsr     a                               ; CB13 4A                       J
        beq     LCB5C                           ; CB14 F0 46                    .F
        lda     $10                             ; CB16 A5 10                    ..
        cmp     $28                             ; CB18 C5 28                    .(
        sta     $28                             ; CB1A 85 28                    .(
        php                                     ; CB1C 08                       .
        and     #$01                            ; CB1D 29 01                    ).
        tay                                     ; CB1F A8                       .
        plp                                     ; CB20 28                       (
        bne     LCB31                           ; CB21 D0 0E                    ..
        lda     $25                             ; CB23 A5 25                    .%
        clc                                     ; CB25 18                       .
        adc     scroll_step_tbl,y                         ; CB26 79 C6 D0                 y..
        cmp     #$20                            ; CB29 C9 20                    . 
        and     #$1F                            ; CB2B 29 1F                    ).
        sta     $25                             ; CB2D 85 25                    .%
        bcc     LCB39                           ; CB2F 90 08                    ..
LCB31:  lda     $24                             ; CB31 A5 24                    .$
        clc                                     ; CB33 18                       .
        adc     scroll_step_tbl,y                         ; CB34 79 C6 D0                 y..
        sta     $24                             ; CB37 85 24                    .$
LCB39:  lda     $25                             ; CB39 A5 25                    .%
        bne     LCB4D                           ; CB3B D0 10                    ..
        lda     $26                             ; CB3D A5 26                    .&
        cmp     #$05                            ; CB3F C9 05                    ..
        bne     LCB4D                           ; CB41 D0 0A                    ..
        lda     $24                             ; CB43 A5 24                    .$
        cmp     #$0B                            ; CB45 C9 0B                    ..
        beq     LCB5C                           ; CB47 F0 13                    ..
        cmp     #$1A                            ; CB49 C9 1A                    ..
        beq     LCB5C                           ; CB4B F0 0F                    ..
LCB4D:  lda     $F6                             ; CB4D A5 F6                    ..
        pha                                     ; CB4F 48                       H
        jsr     LD8EB                           ; CB50 20 EB D8                  ..
        jsr     draw_scroll_column                           ; CB53 20 E2 D4                  ..
        pla                                     ; CB56 68                       h
        sta     $F6                             ; CB57 85 F6                    ..
        jsr     bank_load_shadow                ; CB59 20 43 FF                  C.
LCB5C:  jmp     scroll_vert_update                           ; CB5C 4C 10 CD                 L..

; -----------------------------------------------------------------------------
; SECTION ADVANCE — $CB5F
; At section end (camera screen $2B == target $2A): checks the next
; section-list entry ($A950/$A951, attrs $A968) and starts the 4px/frame
; camera slide into it (boss doors via LD0FC when attr bit 7 set).
; -----------------------------------------------------------------------------
section_advance:  lda     $55                             ; CB5F A5 55                    .U
        bne     LCB5C                           ; CB61 D0 F9                    ..
        lda     $29                             ; CB63 A5 29                    .)
        and     #$1F                            ; CB65 29 1F                    ).
        tay                                     ; CB67 A8                       .
        lda     $A951,y                         ; CB68 B9 51 A9                 .Q.
        and     #$20                            ; CB6B 29 20                    ) 
        beq     LCB5C                           ; CB6D F0 ED                    ..
        lda     $A951,y                         ; CB6F B9 51 A9                 .Q.
        and     #$C0                            ; CB72 29 C0                    ).
        bne     LCB5C                           ; CB74 D0 E6                    ..
        iny                                     ; CB76 C8                       .
        sty     L0000                           ; CB77 84 00                    ..
        lda     $A950,y                         ; CB79 B9 50 A9                 .P.
        and     #$20                            ; CB7C 29 20                    ) 
        ora     L0000                           ; CB7E 05 00                    ..
        sta     $29                             ; CB80 85 29                    .)
        lda     $A950,y                         ; CB82 B9 50 A9                 .P.
        and     #$1F                            ; CB85 29 1F                    ).
        sta     $2A                             ; CB87 85 2A                    .*
        lda     #$00                            ; CB89 A9 00                    ..
        sta     $2B                             ; CB8B 85 2B                    .+
        lda     $A968,y                         ; CB8D B9 68 A9                 .h.
        pha                                     ; CB90 48                       H
        bpl     LCB96                           ; CB91 10 03                    ..
        jsr     LD0FC                           ; CB93 20 FC D0                  ..
LCB96:  jsr     scroll_irq_reset                           ; CB96 20 B8 C3                  ..
        jsr     entity_clear_all                           ; CB99 20 9D C3                  ..
        jsr     call_bank00_frame                           ; CB9C 20 2D F3                  -.
        jsr     LD07F                           ; CB9F 20 7F D0                  ..
        lda     $28                             ; CBA2 A5 28                    .(
        pha                                     ; CBA4 48                       H
        lda     #$01                            ; CBA5 A9 01                    ..
        sta     $28                             ; CBA7 85 28                    .(
        sta     $AC                             ; CBA9 85 AC                    ..
        pla                                     ; CBAB 68                       h
        and     #$01                            ; CBAC 29 01                    ).
        bne     LCBB4                           ; CBAE D0 04                    ..
        inc     $24                             ; CBB0 E6 24                    .$
        dec     $25                             ; CBB2 C6 25                    .%
LCBB4:  lda     $FC                             ; CBB4 A5 FC                    ..
        clc                                     ; CBB6 18                       .
        adc     #$04                            ; CBB7 69 04                    i.
        sta     $FC                             ; CBB9 85 FC                    ..
        lda     $F9                             ; CBBB A5 F9                    ..
        adc     #$00                            ; CBBD 69 00                    i.
        sta     $F9                             ; CBBF 85 F9                    ..
        lda     $0318                           ; CBC1 AD 18 03                 ...
        clc                                     ; CBC4 18                       .
        adc     #$A0                            ; CBC5 69 A0                    i.
        sta     $0318                           ; CBC7 8D 18 03                 ...
        lda     $0330                           ; CBCA AD 30 03                 .0.
        adc     #$00                            ; CBCD 69 00                    i.
        sta     $0330                           ; CBCF 8D 30 03                 .0.
        lda     $0348                           ; CBD2 AD 48 03                 .H.
        adc     #$00                            ; CBD5 69 00                    i.
        sta     $0348                           ; CBD7 8D 48 03                 .H.
        lda     $FC                             ; CBDA A5 FC                    ..
        sec                                     ; CBDC 38                       8
        sbc     $44                             ; CBDD E5 44                    .D
        sta     $11                             ; CBDF 85 11                    ..
        beq     LCBFE                           ; CBE1 F0 1B                    ..
        lda     $44                             ; CBE3 A5 44                    .D
        and     #$07                            ; CBE5 29 07                    ).
        clc                                     ; CBE7 18                       .
        adc     $11                             ; CBE8 65 11                    e.
        lsr     a                               ; CBEA 4A                       J
        lsr     a                               ; CBEB 4A                       J
        lsr     a                               ; CBEC 4A                       J
        beq     LCBFE                           ; CBED F0 0F                    ..
        inc     $25                             ; CBEF E6 25                    .%
        lda     $25                             ; CBF1 A5 25                    .%
        and     #$1F                            ; CBF3 29 1F                    ).
        sta     $25                             ; CBF5 85 25                    .%
        bne     LCBFB                           ; CBF7 D0 02                    ..
        inc     $24                             ; CBF9 E6 24                    .$
LCBFB:  jsr     draw_scroll_column                           ; CBFB 20 E2 D4                  ..
LCBFE:  lda     $FC                             ; CBFE A5 FC                    ..
        sta     $44                             ; CC00 85 44                    .D
        lda     #$04                            ; CC02 A9 04                    ..
        sta     $9F                             ; CC04 85 9F                    ..
        jsr     oam_clear                           ; CC06 20 8F C3                  ..
        lda     $F6                             ; CC09 A5 F6                    ..
        pha                                     ; CC0B 48                       H
        lda     #$12                            ; CC0C A9 12                    ..
        jsr     bank_load_pair                  ; CC0E 20 3D FF                  =.
        jsr     entity_render_all                           ; CC11 20 5E DF                  ^.
        lda     $0558                           ; CC14 AD 58 05                 .X.
        cmp     #$1D                            ; CC17 C9 1D                    ..
        bne     LCC20                           ; CC19 D0 05                    ..
        lda     #$00                            ; CC1B A9 00                    ..
        sta     $0570                           ; CC1D 8D 70 05                 .p.
LCC20:  pla                                     ; CC20 68                       h
        sta     $F6                             ; CC21 85 F6                    ..
        jsr     bank_load_shadow                ; CC23 20 43 FF                  C.
        lda     #$01                            ; CC26 A9 01                    ..
        sta     $0300                           ; CC28 8D 00 03                 ...
        lda     #$00                            ; CC2B A9 00                    ..
        sta     $95                             ; CC2D 85 95                    ..
        jsr     frame_wait                      ; CC2F 20 22 FF                  ".
        inc     $95                             ; CC32 E6 95                    ..
        lda     $FC                             ; CC34 A5 FC                    ..
        beq     LCC3B                           ; CC36 F0 03                    ..
        jmp     LCBB4                           ; CC38 4C B4 CB                 L..

; ----------------------------------------------------------------------------
LCC3B:  pla                                     ; CC3B 68                       h
        bpl     LCC41                           ; CC3C 10 03                    ..
        jsr     LD16B                           ; CC3E 20 6B D1                  k.
LCC41:  lda     #$00                            ; CC41 A9 00                    ..
        sta     $35                             ; CC43 85 35                    .5
        rts                                     ; CC45 60                       `

; ----------------------------------------------------------------------------
LCC46:  jmp     scroll_vert_update                           ; CC46 4C 10 CD                 L..

; -----------------------------------------------------------------------------
; SECTION RETREAT — $CC49
; Backward (leftward) section transition, mirror of section_advance.
; -----------------------------------------------------------------------------
section_retreat:  lda     $29                             ; CC49 A5 29                    .)
        and     #$1F                            ; CC4B 29 1F                    ).
        beq     LCC46                           ; CC4D F0 F7                    ..
        tay                                     ; CC4F A8                       .
        lda     $A968,y                         ; CC50 B9 68 A9                 .h.
        and     #$40                            ; CC53 29 40                    )@
        beq     LCC46                           ; CC55 F0 EF                    ..
        lda     $A94F,y                         ; CC57 B9 4F A9                 .O.
        and     #$20                            ; CC5A 29 20                    ) 
        beq     LCC46                           ; CC5C F0 E8                    ..
        dey                                     ; CC5E 88                       .
        sty     L0000                           ; CC5F 84 00                    ..
        lda     $A950,y                         ; CC61 B9 50 A9                 .P.
        and     #$20                            ; CC64 29 20                    ) 
        ora     L0000                           ; CC66 05 00                    ..
        sta     $29                             ; CC68 85 29                    .)
        lda     $A950,y                         ; CC6A B9 50 A9                 .P.
        and     #$1F                            ; CC6D 29 1F                    ).
        sta     $2A                             ; CC6F 85 2A                    .*
        sta     $2B                             ; CC71 85 2B                    .+
        jsr     scroll_irq_reset                           ; CC73 20 B8 C3                  ..
        jsr     entity_clear_all                           ; CC76 20 9D C3                  ..
        jsr     call_bank00_frame                           ; CC79 20 2D F3                  -.
        lda     $28                             ; CC7C A5 28                    .(
        pha                                     ; CC7E 48                       H
        lda     #$02                            ; CC7F A9 02                    ..
        sta     $28                             ; CC81 85 28                    .(
        sta     $AC                             ; CC83 85 AC                    ..
        pla                                     ; CC85 68                       h
        and     #$02                            ; CC86 29 02                    ).
        bne     LCC8E                           ; CC88 D0 04                    ..
        dec     $24                             ; CC8A C6 24                    .$
        inc     $25                             ; CC8C E6 25                    .%
LCC8E:  lda     $FC                             ; CC8E A5 FC                    ..
        sec                                     ; CC90 38                       8
        sbc     #$04                            ; CC91 E9 04                    ..
        sta     $FC                             ; CC93 85 FC                    ..
        lda     $F9                             ; CC95 A5 F9                    ..
        sbc     #$00                            ; CC97 E9 00                    ..
        sta     $F9                             ; CC99 85 F9                    ..
        lda     $0318                           ; CC9B AD 18 03                 ...
        sec                                     ; CC9E 38                       8
        sbc     #$80                            ; CC9F E9 80                    ..
        sta     $0318                           ; CCA1 8D 18 03                 ...
        lda     $0330                           ; CCA4 AD 30 03                 .0.
        sbc     #$00                            ; CCA7 E9 00                    ..
        sta     $0330                           ; CCA9 8D 30 03                 .0.
        lda     $0348                           ; CCAC AD 48 03                 .H.
        sbc     #$00                            ; CCAF E9 00                    ..
        sta     $0348                           ; CCB1 8D 48 03                 .H.
        lda     $FC                             ; CCB4 A5 FC                    ..
        sec                                     ; CCB6 38                       8
        sbc     $44                             ; CCB7 E5 44                    .D
        bpl     LCCC0                           ; CCB9 10 05                    ..
        eor     #$FF                            ; CCBB 49 FF                    I.
        clc                                     ; CCBD 18                       .
        adc     #$01                            ; CCBE 69 01                    i.
LCCC0:  sta     $11                             ; CCC0 85 11                    ..
        beq     LCCDF                           ; CCC2 F0 1B                    ..
        lda     $44                             ; CCC4 A5 44                    .D
        eor     #$FF                            ; CCC6 49 FF                    I.
        and     #$07                            ; CCC8 29 07                    ).
        clc                                     ; CCCA 18                       .
        adc     $11                             ; CCCB 65 11                    e.
        lsr     a                               ; CCCD 4A                       J
        lsr     a                               ; CCCE 4A                       J
        lsr     a                               ; CCCF 4A                       J
        beq     LCCDF                           ; CCD0 F0 0D                    ..
        dec     $25                             ; CCD2 C6 25                    .%
        bpl     LCCDC                           ; CCD4 10 06                    ..
        lda     #$1F                            ; CCD6 A9 1F                    ..
        sta     $25                             ; CCD8 85 25                    .%
        dec     $24                             ; CCDA C6 24                    .$
LCCDC:  jsr     draw_scroll_column                           ; CCDC 20 E2 D4                  ..
LCCDF:  lda     $FC                             ; CCDF A5 FC                    ..
        sta     $44                             ; CCE1 85 44                    .D
        lda     #$04                            ; CCE3 A9 04                    ..
        sta     $9F                             ; CCE5 85 9F                    ..
        jsr     oam_clear                           ; CCE7 20 8F C3                  ..
        lda     $F6                             ; CCEA A5 F6                    ..
        pha                                     ; CCEC 48                       H
        lda     #$12                            ; CCED A9 12                    ..
        jsr     bank_load_pair                  ; CCEF 20 3D FF                  =.
        jsr     entity_render_all                           ; CCF2 20 5E DF                  ^.
        pla                                     ; CCF5 68                       h
        sta     $F6                             ; CCF6 85 F6                    ..
        jsr     bank_load_shadow                ; CCF8 20 43 FF                  C.
        lda     #$01                            ; CCFB A9 01                    ..
        sta     $0300                           ; CCFD 8D 00 03                 ...
        lda     #$00                            ; CD00 A9 00                    ..
        sta     $95                             ; CD02 85 95                    ..
        jsr     frame_wait                      ; CD04 20 22 FF                  ".
        inc     $95                             ; CD07 E6 95                    ..
        lda     $FC                             ; CD09 A5 FC                    ..
        bne     LCC8E                           ; CD0B D0 81                    ..
        sta     $35                             ; CD0D 85 35                    .5
LCD0F:  rts                                     ; CD0F 60                       `

; ----------------------------------------------------------------------------
scroll_vert_update:  lda     $FC                             ; CD10 A5 FC                    ..
        bne     LCD0F                           ; CD12 D0 FB                    ..
        lda     #$10                            ; CD14 A9 10                    ..
        cmp     $0330                           ; CD16 CD 30 03                 .0.
        bcs     LCD22                           ; CD19 B0 07                    ..
        lda     #$F0                            ; CD1B A9 F0                    ..
        cmp     $0330                           ; CD1D CD 30 03                 .0.
        bcs     LCD25                           ; CD20 B0 03                    ..
LCD22:  sta     $0330                           ; CD22 8D 30 03                 .0.
LCD25:  ldy     $26                             ; CD25 A4 26                    .&
        lda     LD0CC,y                         ; CD27 B9 CC D0                 ...
        beq     LCD33                           ; CD2A F0 07                    ..
        cmp     $29                             ; CD2C C5 29                    .)
        bne     LCD33                           ; CD2E D0 03                    ..
        jmp     LCF5D                           ; CD30 4C 5D CF                 L].

; ----------------------------------------------------------------------------
LCD33:  lda     $0390                           ; CD33 AD 90 03                 ...
        bne     LCD0F                           ; CD36 D0 D7                    ..
        lda     $AF                             ; CD38 A5 AF                    ..
        beq     LCD57                           ; CD3A F0 1B                    ..
        lda     #$80                            ; CD3C A9 80                    ..
        sta     $01                             ; CD3E 85 01                    ..
        lda     $0378                           ; CD40 AD 78 03                 .x.
        cmp     #$08                            ; CD43 C9 08                    ..
        bcc     LCD74                           ; CD45 90 2D                    .-
        cmp     #$E8                            ; CD47 C9 E8                    ..
        bcc     LCD0F                           ; CD49 90 C4                    ..
        lda     $30                             ; CD4B A5 30                    .0
        cmp     #$03                            ; CD4D C9 03                    ..
        bne     LCD0F                           ; CD4F D0 BE                    ..
        lda     #$40                            ; CD51 A9 40                    .@
        sta     $01                             ; CD53 85 01                    ..
        bne     LCD74                           ; CD55 D0 1D                    ..
LCD57:  lda     #$40                            ; CD57 A9 40                    .@
        sta     $01                             ; CD59 85 01                    ..
        lda     $0378                           ; CD5B AD 78 03                 .x.
        cmp     #$E8                            ; CD5E C9 E8                    ..
        bcs     LCD74                           ; CD60 B0 12                    ..
        cmp     #$08                            ; CD62 C9 08                    ..
        bcs     LCD0F                           ; CD64 B0 A9                    ..
        lda     $37                             ; CD66 A5 37                    .7
        bne     LCD70                           ; CD68 D0 06                    ..
        lda     $30                             ; CD6A A5 30                    .0
        cmp     #$03                            ; CD6C C9 03                    ..
        bne     LCD0F                           ; CD6E D0 9F                    ..
LCD70:  lda     #$80                            ; CD70 A9 80                    ..
        sta     $01                             ; CD72 85 01                    ..
LCD74:  jsr     LCFF0                           ; CD74 20 F0 CF                  ..
        bcs     LCDCC                           ; CD77 B0 53                    .S
        lda     $29                             ; CD79 A5 29                    .)
        and     #$C0                            ; CD7B 29 C0                    ).
        beq     LCDEE                           ; CD7D F0 6F                    .o
        lda     $01                             ; CD7F A5 01                    ..
        and     $29                             ; CD81 25 29                    %)
        beq     LCDBB                           ; CD83 F0 36                    .6
        lda     $2B                             ; CD85 A5 2B                    .+
        cmp     $2A                             ; CD87 C5 2A                    .*
        beq     LCD9B                           ; CD89 F0 10                    ..
        inc     $2B                             ; CD8B E6 2B                    .+
LCD8D:  inc     $24                             ; CD8D E6 24                    .$
        inc     $F9                             ; CD8F E6 F9                    ..
        inc     $0348                           ; CD91 EE 48 03                 .H.
        lda     #$01                            ; CD94 A9 01                    ..
        sta     $AC                             ; CD96 85 AC                    ..
        jmp     LCE7C                           ; CD98 4C 7C CE                 L|.

; ----------------------------------------------------------------------------
LCD9B:  inc     $29                             ; CD9B E6 29                    .)
        lda     $29                             ; CD9D A5 29                    .)
        and     #$1F                            ; CD9F 29 1F                    ).
        sta     $29                             ; CDA1 85 29                    .)
        tay                                     ; CDA3 A8                       .
        lda     $A950,y                         ; CDA4 B9 50 A9                 .P.
        and     #$E0                            ; CDA7 29 E0                    ).
        ora     $29                             ; CDA9 05 29                    .)
        sta     $29                             ; CDAB 85 29                    .)
        lda     #$00                            ; CDAD A9 00                    ..
        sta     $2B                             ; CDAF 85 2B                    .+
        lda     $A950,y                         ; CDB1 B9 50 A9                 .P.
        and     #$1F                            ; CDB4 29 1F                    ).
        sta     $2A                             ; CDB6 85 2A                    .*
        jmp     LCD8D                           ; CDB8 4C 8D CD                 L..

; ----------------------------------------------------------------------------
LCDBB:  lda     $2B                             ; CDBB A5 2B                    .+
        beq     LCDCF                           ; CDBD F0 10                    ..
        dec     $2B                             ; CDBF C6 2B                    .+
LCDC1:  dec     $24                             ; CDC1 C6 24                    .$
        dec     $F9                             ; CDC3 C6 F9                    ..
        dec     $0348                           ; CDC5 CE 48 03                 .H.
        lda     #$02                            ; CDC8 A9 02                    ..
        sta     $AC                             ; CDCA 85 AC                    ..
LCDCC:  jmp     LCE7C                           ; CDCC 4C 7C CE                 L|.

; ----------------------------------------------------------------------------
LCDCF:  dec     $29                             ; CDCF C6 29                    .)
        lda     $29                             ; CDD1 A5 29                    .)
        and     #$1F                            ; CDD3 29 1F                    ).
        sta     $29                             ; CDD5 85 29                    .)
        tay                                     ; CDD7 A8                       .
        lda     $A950,y                         ; CDD8 B9 50 A9                 .P.
        and     #$E0                            ; CDDB 29 E0                    ).
        ora     $29                             ; CDDD 05 29                    .)
        sta     $29                             ; CDDF 85 29                    .)
        lda     $A950,y                         ; CDE1 B9 50 A9                 .P.
        and     #$1F                            ; CDE4 29 1F                    ).
        sta     $2B                             ; CDE6 85 2B                    .+
        sta     $2A                             ; CDE8 85 2A                    .*
        jmp     LCDC1                           ; CDEA 4C C1 CD                 L..

; ----------------------------------------------------------------------------
LCDED:  rts                                     ; CDED 60                       `

; ----------------------------------------------------------------------------
LCDEE:  lda     $FC                             ; CDEE A5 FC                    ..
        bne     LCDED                           ; CDF0 D0 FB                    ..
        lda     $29                             ; CDF2 A5 29                    .)
        and     #$1F                            ; CDF4 29 1F                    ).
        tay                                     ; CDF6 A8                       .
        lda     $2A                             ; CDF7 A5 2A                    .*
        bne     LCE04                           ; CDF9 D0 09                    ..
        lda     $A951,y                         ; CDFB B9 51 A9                 .Q.
        .byte   $25                             ; CDFE 25                       %
LCDFF:  ora     ($D0,x)                         ; CDFF 01 D0                    ..
        asl     a                               ; CE01 0A                       .
        beq     LCE2B                           ; CE02 F0 27                    .'
LCE04:  lda     $2B                             ; CE04 A5 2B                    .+
        beq     LCE2B                           ; CE06 F0 23                    .#
        cmp     $2A                             ; CE08 C5 2A                    .*
        bne     LCE7B                           ; CE0A D0 6F                    .o
LCE0C:  iny                                     ; CE0C C8                       .
        lda     $A950,y                         ; CE0D B9 50 A9                 .P.
        and     #$C0                            ; CE10 29 C0                    ).
        beq     LCE7B                           ; CE12 F0 67                    .g
        sta     $10                             ; CE14 85 10                    ..
        lda     #$00                            ; CE16 A9 00                    ..
        sta     $11                             ; CE18 85 11                    ..
        lda     $A950,y                         ; CE1A B9 50 A9                 .P.
        and     #$1F                            ; CE1D 29 1F                    ).
        sta     $12                             ; CE1F 85 12                    ..
        lda     #$01                            ; CE21 A9 01                    ..
        sta     $13                             ; CE23 85 13                    ..
        lda     #$01                            ; CE25 A9 01                    ..
        sta     $02                             ; CE27 85 02                    ..
        bne     LCE4A                           ; CE29 D0 1F                    ..
LCE2B:  lda     $A950,y                         ; CE2B B9 50 A9                 .P.
        dey                                     ; CE2E 88                       .
        bmi     LCE7B                           ; CE2F 30 4A                    0J
        and     #$C0                            ; CE31 29 C0                    ).
        beq     LCE7B                           ; CE33 F0 46                    .F
        eor     #$C0                            ; CE35 49 C0                    I.
        sta     $10                             ; CE37 85 10                    ..
        lda     $A950,y                         ; CE39 B9 50 A9                 .P.
        and     #$1F                            ; CE3C 29 1F                    ).
        sta     $11                             ; CE3E 85 11                    ..
        sta     $12                             ; CE40 85 12                    ..
        lda     #$FF                            ; CE42 A9 FF                    ..
        sta     $13                             ; CE44 85 13                    ..
        lda     #$02                            ; CE46 A9 02                    ..
        sta     $02                             ; CE48 85 02                    ..
LCE4A:  lda     $01                             ; CE4A A5 01                    ..
        and     $10                             ; CE4C 25 10                    %.
        beq     LCE7B                           ; CE4E F0 2B                    .+
        sty     $10                             ; CE50 84 10                    ..
        lda     $A950,y                         ; CE52 B9 50 A9                 .P.
        and     #$E0                            ; CE55 29 E0                    ).
        ora     $10                             ; CE57 05 10                    ..
        sta     $29                             ; CE59 85 29                    .)
        lda     $11                             ; CE5B A5 11                    ..
        sta     $2B                             ; CE5D 85 2B                    .+
        lda     $12                             ; CE5F A5 12                    ..
        sta     $2A                             ; CE61 85 2A                    .*
        lda     $F9                             ; CE63 A5 F9                    ..
        clc                                     ; CE65 18                       .
        adc     $13                             ; CE66 65 13                    e.
        sta     $F9                             ; CE68 85 F9                    ..
        sta     $24                             ; CE6A 85 24                    .$
        sta     $0348                           ; CE6C 8D 48 03                 .H.
        lda     $02                             ; CE6F A5 02                    ..
        sta     $AC                             ; CE71 85 AC                    ..
        lda     #$00                            ; CE73 A9 00                    ..
        jsr     set_mirroring                   ; CE75 20 B7 FF                  ..
        jmp     LCE7C                           ; CE78 4C 7C CE                 L|.

; ----------------------------------------------------------------------------
LCE7B:  rts                                     ; CE7B 60                       `

; ----------------------------------------------------------------------------
LCE7C:  lda     $01                             ; CE7C A5 01                    ..
        lsr     a                               ; CE7E 4A                       J
        lsr     a                               ; CE7F 4A                       J
        lsr     a                               ; CE80 4A                       J
        lsr     a                               ; CE81 4A                       J
        sta     $28                             ; CE82 85 28                    .(
        and     #$04                            ; CE84 29 04                    ).
        lsr     a                               ; CE86 4A                       J
        lsr     a                               ; CE87 4A                       J
        sta     $11                             ; CE88 85 11                    ..
        tax                                     ; CE8A AA                       .
        lda     LD0C8,x                         ; CE8B BD C8 D0                 ...
        sta     $25                             ; CE8E 85 25                    .%
        jsr     scroll_irq_reset                           ; CE90 20 B8 C3                  ..
        jsr     call_bank00_frame                           ; CE93 20 2D F3                  -.
        lda     $37                             ; CE96 A5 37                    .7
        beq     LCEA0                           ; CE98 F0 06                    ..
        lda     $28                             ; CE9A A5 28                    .(
        and     #$04                            ; CE9C 29 04                    ).
        beq     LCEA3                           ; CE9E F0 03                    ..
LCEA0:  jsr     entity_clear_all                           ; CEA0 20 9D C3                  ..
LCEA3:  lda     $28                             ; CEA3 A5 28                    .(
        and     #$04                            ; CEA5 29 04                    ).
        beq     LCED3                           ; CEA7 F0 2A                    .*
        lda     $FA                             ; CEA9 A5 FA                    ..
        clc                                     ; CEAB 18                       .
        adc     #$04                            ; CEAC 69 04                    i.
        sta     $FA                             ; CEAE 85 FA                    ..
        cmp     #$F0                            ; CEB0 C9 F0                    ..
        bcc     LCEB8                           ; CEB2 90 04                    ..
        adc     #$0F                            ; CEB4 69 0F                    i.
        sta     $FA                             ; CEB6 85 FA                    ..
LCEB8:  lda     $0360                           ; CEB8 AD 60 03                 .`.
        sec                                     ; CEBB 38                       8
        sbc     #$80                            ; CEBC E9 80                    ..
        sta     $0360                           ; CEBE 8D 60 03                 .`.
        lda     $0378                           ; CEC1 AD 78 03                 .x.
        sbc     #$03                            ; CEC4 E9 03                    ..
        sta     $0378                           ; CEC6 8D 78 03                 .x.
        bcs     LCF01                           ; CEC9 B0 36                    .6
        sbc     #$0F                            ; CECB E9 0F                    ..
        sta     $0378                           ; CECD 8D 78 03                 .x.
        jmp     LCF01                           ; CED0 4C 01 CF                 L..

; ----------------------------------------------------------------------------
LCED3:  lda     $FA                             ; CED3 A5 FA                    ..
        sec                                     ; CED5 38                       8
        sbc     #$04                            ; CED6 E9 04                    ..
        sta     $FA                             ; CED8 85 FA                    ..
        bcs     LCEE0                           ; CEDA B0 04                    ..
        sbc     #$0F                            ; CEDC E9 0F                    ..
        sta     $FA                             ; CEDE 85 FA                    ..
LCEE0:  lda     $37                             ; CEE0 A5 37                    .7
        beq     LCEE7                           ; CEE2 F0 03                    ..
        jsr     LD04F                           ; CEE4 20 4F D0                  O.
LCEE7:  lda     $0360                           ; CEE7 AD 60 03                 .`.
        clc                                     ; CEEA 18                       .
        adc     #$80                            ; CEEB 69 80                    i.
        sta     $0360                           ; CEED 8D 60 03                 .`.
        lda     $0378                           ; CEF0 AD 78 03                 .x.
        adc     #$03                            ; CEF3 69 03                    i.
        sta     $0378                           ; CEF5 8D 78 03                 .x.
        cmp     #$F0                            ; CEF8 C9 F0                    ..
        bcc     LCF01                           ; CEFA 90 05                    ..
        adc     #$0F                            ; CEFC 69 0F                    i.
        sta     $0378                           ; CEFE 8D 78 03                 .x.
LCF01:  jsr     LCF94                           ; CF01 20 94 CF                  ..
        lda     $11                             ; CF04 A5 11                    ..
        pha                                     ; CF06 48                       H
        lda     #$04                            ; CF07 A9 04                    ..
        sta     $9F                             ; CF09 85 9F                    ..
        jsr     oam_clear                           ; CF0B 20 8F C3                  ..
        lda     $F6                             ; CF0E A5 F6                    ..
        pha                                     ; CF10 48                       H
        lda     #$12                            ; CF11 A9 12                    ..
        jsr     bank_load_pair                  ; CF13 20 3D FF                  =.
        jsr     entity_render_all                           ; CF16 20 5E DF                  ^.
        pla                                     ; CF19 68                       h
        sta     $F6                             ; CF1A 85 F6                    ..
        jsr     bank_load_shadow                ; CF1C 20 43 FF                  C.
        lda     #$01                            ; CF1F A9 01                    ..
        sta     $0300                           ; CF21 8D 00 03                 ...
        lda     #$00                            ; CF24 A9 00                    ..
        sta     $95                             ; CF26 85 95                    ..
        jsr     frame_wait                      ; CF28 20 22 FF                  ".
        pla                                     ; CF2B 68                       h
        sta     $11                             ; CF2C 85 11                    ..
        inc     $95                             ; CF2E E6 95                    ..
        lda     $FA                             ; CF30 A5 FA                    ..
        sta     $45                             ; CF32 85 45                    .E
        beq     LCF39                           ; CF34 F0 03                    ..
        jmp     LCEA3                           ; CF36 4C A3 CE                 L..

; ----------------------------------------------------------------------------
LCF39:  lda     $0378                           ; CF39 AD 78 03                 .x.
        and     #$F8                            ; CF3C 29 F8                    ).
        sta     $0378                           ; CF3E 8D 78 03                 .x.
        lda     $29                             ; CF41 A5 29                    .)
        and     #$20                            ; CF43 29 20                    ) 
        beq     LCF5C                           ; CF45 F0 15                    ..
        lda     $29                             ; CF47 A5 29                    .)
        and     #$3F                            ; CF49 29 3F                    )?
        sta     $29                             ; CF4B 85 29                    .)
        lda     #$00                            ; CF4D A9 00                    ..
        sta     $25                             ; CF4F 85 25                    .%
        inc     $24                             ; CF51 E6 24                    .$
        lda     #$01                            ; CF53 A9 01                    ..
        sta     $28                             ; CF55 85 28                    .(
        lda     #$01                            ; CF57 A9 01                    ..
        jsr     set_mirroring                   ; CF59 20 B7 FF                  ..
LCF5C:  rts                                     ; CF5C 60                       `

; ----------------------------------------------------------------------------
LCF5D:  lda     #$08                            ; CF5D A9 08                    ..
        sta     $28                             ; CF5F 85 28                    .(
        lda     #$00                            ; CF61 A9 00                    ..
        sta     $11                             ; CF63 85 11                    ..
        ldy     $26                             ; CF65 A4 26                    .&
        lda     $24                             ; CF67 A5 24                    .$
        cmp     LD0EC,y                         ; CF69 D9 EC D0                 ...
        beq     LCFBF                           ; CF6C F0 51                    .Q
        jsr     LCF94                           ; CF6E 20 94 CF                  ..
        lda     $25                             ; CF71 A5 25                    .%
        bpl     LCF93                           ; CF73 10 1E                    ..
        lda     #$1D                            ; CF75 A9 1D                    ..
        sta     $25                             ; CF77 85 25                    .%
        inc     $24                             ; CF79 E6 24                    .$
        ldy     $26                             ; CF7B A4 26                    .&
        lda     $24                             ; CF7D A5 24                    .$
        cmp     LD0DC,y                         ; CF7F D9 DC D0                 ...
        bne     LCF93                           ; CF82 D0 0F                    ..
        lda     LD0EC,y                         ; CF84 B9 EC D0                 ...
        sta     $24                             ; CF87 85 24                    .$
        ldy     #$3F                            ; CF89 A0 3F                    .?
        lda     #$00                            ; CF8B A9 00                    ..
LCF8D:  sta     $0680,y                         ; CF8D 99 80 06                 ...
        dey                                     ; CF90 88                       .
        bpl     LCF8D                           ; CF91 10 FA                    ..
LCF93:  rts                                     ; CF93 60                       `

; ----------------------------------------------------------------------------
LCF94:  lda     $FA                             ; CF94 A5 FA                    ..
        sec                                     ; CF96 38                       8
        sbc     $45                             ; CF97 E5 45                    .E
        bpl     LCFA0                           ; CF99 10 05                    ..
        eor     #$FF                            ; CF9B 49 FF                    I.
        clc                                     ; CF9D 18                       .
        adc     #$01                            ; CF9E 69 01                    i.
LCFA0:  and     #$0F                            ; CFA0 29 0F                    ).
        sta     $10                             ; CFA2 85 10                    ..
        beq     LCF93                           ; CFA4 F0 ED                    ..
        lda     $28                             ; CFA6 A5 28                    .(
        and     #$04                            ; CFA8 29 04                    ).
        beq     LCFB1                           ; CFAA F0 05                    ..
        lda     $45                             ; CFAC A5 45                    .E
        jmp     LCFB5                           ; CFAE 4C B5 CF                 L..

; ----------------------------------------------------------------------------
LCFB1:  lda     $45                             ; CFB1 A5 45                    .E
        eor     #$FF                            ; CFB3 49 FF                    I.
LCFB5:  and     #$07                            ; CFB5 29 07                    ).
        clc                                     ; CFB7 18                       .
        adc     $10                             ; CFB8 65 10                    e.
        lsr     a                               ; CFBA 4A                       J
        lsr     a                               ; CFBB 4A                       J
        lsr     a                               ; CFBC 4A                       J
        beq     LCF93                           ; CFBD F0 D4                    ..
LCFBF:  ldx     $11                             ; CFBF A6 11                    ..
        lda     $25                             ; CFC1 A5 25                    .%
        and     #$01                            ; CFC3 29 01                    ).
        cmp     LD0CA,x                         ; CFC5 DD CA D0                 ...
        bne     LCFD9                           ; CFC8 D0 0F                    ..
        lda     $F6                             ; CFCA A5 F6                    ..
        pha                                     ; CFCC 48                       H
        jsr     LD583                           ; CFCD 20 83 D5                  ..
        pla                                     ; CFD0 68                       h
        sta     $F6                             ; CFD1 85 F6                    ..
        jsr     bank_load_shadow                ; CFD3 20 43 FF                  C.
        jmp     LCFE5                           ; CFD6 4C E5 CF                 L..

; ----------------------------------------------------------------------------
LCFD9:  lda     $F6                             ; CFD9 A5 F6                    ..
        pha                                     ; CFDB 48                       H
        jsr     LD674                           ; CFDC 20 74 D6                  t.
        pla                                     ; CFDF 68                       h
        sta     $F6                             ; CFE0 85 F6                    ..
        jsr     bank_load_shadow                ; CFE2 20 43 FF                  C.
LCFE5:  ldx     $11                             ; CFE5 A6 11                    ..
        lda     $25                             ; CFE7 A5 25                    .%
        clc                                     ; CFE9 18                       .
        adc     scroll_step_tbl,x                         ; CFEA 7D C6 D0                 }..
        sta     $25                             ; CFED 85 25                    .%
        rts                                     ; CFEF 60                       `

; ----------------------------------------------------------------------------
LCFF0:  ldx     #$00                            ; CFF0 A2 00                    ..
LCFF2:  lda     $A9E0,x                         ; CFF2 BD E0 A9                 ...
        bmi     LD04D                           ; CFF5 30 56                    0V
        cmp     $0348                           ; CFF7 CD 48 03                 .H.
        bne     LD047                           ; CFFA D0 4B                    .K
        lda     $A9E1,x                         ; CFFC BD E1 A9                 ...
        cmp     $01                             ; CFFF C5 01                    ..
        bne     LD04D                           ; D001 D0 4A                    .J
        lda     $A9E2,x                         ; D003 BD E2 A9                 ...
        sta     $24                             ; D006 85 24                    .$
        sta     $F9                             ; D008 85 F9                    ..
        sta     $0348                           ; D00A 8D 48 03                 .H.
        ldy     $A9E3,x                         ; D00D BC E3 A9                 ...
        lda     $29                             ; D010 A5 29                    .)
        and     #$1F                            ; D012 29 1F                    ).
        cmp     $A9E3,x                         ; D014 DD E3 A9                 ...
        bcc     LD028                           ; D017 90 0F                    ..
        lda     #$02                            ; D019 A9 02                    ..
        sta     $AC                             ; D01B 85 AC                    ..
        lda     $A950,y                         ; D01D B9 50 A9                 .P.
        and     #$1F                            ; D020 29 1F                    ).
        sta     $2B                             ; D022 85 2B                    .+
        lda     #$02                            ; D024 A9 02                    ..
        bne     LD02E                           ; D026 D0 06                    ..
LD028:  lda     #$00                            ; D028 A9 00                    ..
        sta     $2B                             ; D02A 85 2B                    .+
        lda     #$01                            ; D02C A9 01                    ..
LD02E:  sta     $AC                             ; D02E 85 AC                    ..
        lda     $A950,y                         ; D030 B9 50 A9                 .P.
        pha                                     ; D033 48                       H
        and     #$1F                            ; D034 29 1F                    ).
        sta     $2A                             ; D036 85 2A                    .*
        pla                                     ; D038 68                       h
        and     #$E0                            ; D039 29 E0                    ).
        ora     $A9E3,x                         ; D03B 1D E3 A9                 ...
        sta     $29                             ; D03E 85 29                    .)
        lda     #$00                            ; D040 A9 00                    ..
        jsr     set_mirroring                   ; D042 20 B7 FF                  ..
        sec                                     ; D045 38                       8
        rts                                     ; D046 60                       `

; ----------------------------------------------------------------------------
LD047:  inx                                     ; D047 E8                       .
        inx                                     ; D048 E8                       .
        inx                                     ; D049 E8                       .
        inx                                     ; D04A E8                       .
        bne     LCFF2                           ; D04B D0 A5                    ..
LD04D:  clc                                     ; D04D 18                       .
        rts                                     ; D04E 60                       `

; ----------------------------------------------------------------------------
LD04F:  ldy     #$17                            ; D04F A0 17                    ..
LD051:  lda     $0300,y                         ; D051 B9 00 03                 ...
        cmp     #$0D                            ; D054 C9 0D                    ..
        bne     LD078                           ; D056 D0 20                    . 
        lda     #$00                            ; D058 A9 00                    ..
        sta     $0570,y                         ; D05A 99 70 05                 .p.
        lda     $0348                           ; D05D AD 48 03                 .H.
        sta     $0348,y                         ; D060 99 48 03                 .H.
        lda     $0360,y                         ; D063 B9 60 03                 .`.
        clc                                     ; D066 18                       .
        adc     #$80                            ; D067 69 80                    i.
        sta     $0360,y                         ; D069 99 60 03                 .`.
        lda     $0378,y                         ; D06C B9 78 03                 .x.
        adc     #$03                            ; D06F 69 03                    i.
        sta     $0378,y                         ; D071 99 78 03                 .x.
        cmp     #$F0                            ; D074 C9 F0                    ..
        bcc     LD07B                           ; D076 90 03                    ..
LD078:  jsr     entity_wipe_y                           ; D078 20 FE F2                  ..
LD07B:  dey                                     ; D07B 88                       .
        bne     LD051                           ; D07C D0 D3                    ..
        rts                                     ; D07E 60                       `

; ----------------------------------------------------------------------------
LD07F:  lda     $26                             ; D07F A5 26                    .&
        cmp     #$06                            ; D081 C9 06                    ..
        beq     LD0B0                           ; D083 F0 2B                    .+
        cmp     #$01                            ; D085 C9 01                    ..
        bne     LD0AF                           ; D087 D0 26                    .&
        lda     #$8C                            ; D089 A9 8C                    ..
        sta     L0000                           ; D08B 85 00                    ..
        lda     $29                             ; D08D A5 29                    .)
        cmp     #$29                            ; D08F C9 29                    .)
        beq     LD09B                           ; D091 F0 08                    ..
        cmp     #$2A                            ; D093 C9 2A                    .*
        bne     LD0AF                           ; D095 D0 18                    ..
        lda     #$8F                            ; D097 A9 8F                    ..
        sta     L0000                           ; D099 85 00                    ..
LD09B:  ldy     #$02                            ; D09B A0 02                    ..
LD09D:  lda     L0000                           ; D09D A5 00                    ..
        sta     $05F0,y                         ; D09F 99 F0 05                 ...
        lda     #$00                            ; D0A2 A9 00                    ..
        sta     $05F8,y                         ; D0A4 99 F8 05                 ...
        sta     $05F4,y                         ; D0A7 99 F4 05                 ...
        dec     L0000                           ; D0AA C6 00                    ..
        dey                                     ; D0AC 88                       .
        bpl     LD09D                           ; D0AD 10 EE                    ..
LD0AF:  rts                                     ; D0AF 60                       `

; ----------------------------------------------------------------------------
LD0B0:  lda     $29                             ; D0B0 A5 29                    .)
        cmp     #$24                            ; D0B2 C9 24                    .$
        bne     LD0AF                           ; D0B4 D0 F9                    ..
        lda     #$0F                            ; D0B6 A9 0F                    ..
        ldy     #$03                            ; D0B8 A0 03                    ..
LD0BA:  sta     $060C,y                         ; D0BA 99 0C 06                 ...
        sta     $062C,y                         ; D0BD 99 2C 06                 .,.
        dey                                     ; D0C0 88                       .
        bpl     LD0BA                           ; D0C1 10 F7                    ..
        sty     $18                             ; D0C3 84 18                    ..
        rts                                     ; D0C5 60                       `

; ----------------------------------------------------------------------------
scroll_step_tbl:  .byte   $FF                             ; D0C6 FF                       .
        .byte   $01                             ; D0C7 01                       .
LD0C8:  .byte   $1D                             ; D0C8 1D                       .
        brk                                     ; D0C9 00                       .
LD0CA:  ora     (L0000,x)                       ; D0CA 01 00                    ..
LD0CC:  brk                                     ; D0CC 00                       .
        brk                                     ; D0CD 00                       .
        brk                                     ; D0CE 00                       .
        and     #$00                            ; D0CF 29 00                    ).
        brk                                     ; D0D1 00                       .
        brk                                     ; D0D2 00                       .
        brk                                     ; D0D3 00                       .
        brk                                     ; D0D4 00                       .
        brk                                     ; D0D5 00                       .
        brk                                     ; D0D6 00                       .
        .byte   $80                             ; D0D7 80                       .
        brk                                     ; D0D8 00                       .
        brk                                     ; D0D9 00                       .
        brk                                     ; D0DA 00                       .
        brk                                     ; D0DB 00                       .
LD0DC:  brk                                     ; D0DC 00                       .
        brk                                     ; D0DD 00                       .
        brk                                     ; D0DE 00                       .
        asl     L0000,x                         ; D0DF 16 00                    ..
        brk                                     ; D0E1 00                       .
        brk                                     ; D0E2 00                       .
        brk                                     ; D0E3 00                       .
        brk                                     ; D0E4 00                       .
        brk                                     ; D0E5 00                       .
        brk                                     ; D0E6 00                       .
        .byte   $03                             ; D0E7 03                       .
        brk                                     ; D0E8 00                       .
        brk                                     ; D0E9 00                       .
        brk                                     ; D0EA 00                       .
        brk                                     ; D0EB 00                       .
LD0EC:  brk                                     ; D0EC 00                       .
        brk                                     ; D0ED 00                       .
        brk                                     ; D0EE 00                       .
        ora     a:L0000,x                       ; D0EF 1D 00 00                 ...
        brk                                     ; D0F2 00                       .
        brk                                     ; D0F3 00                       .
        brk                                     ; D0F4 00                       .
        brk                                     ; D0F5 00                       .
        brk                                     ; D0F6 00                       .
        .byte   $04                             ; D0F7 04                       .
        brk                                     ; D0F8 00                       .
        brk                                     ; D0F9 00                       .
        brk                                     ; D0FA 00                       .
        brk                                     ; D0FB 00                       .
LD0FC:  lda     #$00                            ; D0FC A9 00                    ..
        sta     $9D                             ; D0FE 85 9D                    ..
        lda     $26                             ; D100 A5 26                    .&
        asl     a                               ; D102 0A                       .
        asl     a                               ; D103 0A                       .
        asl     a                               ; D104 0A                       .
        tax                                     ; D105 AA                       .
        lda     LD231,x                         ; D106 BD 31 D2                 .1.
        sta     $07D0                           ; D109 8D D0 07                 ...
        lda     LD232,x                         ; D10C BD 32 D2                 .2.
        sta     $07D1                           ; D10F 8D D1 07                 ...
        lda     LD233,x                         ; D112 BD 33 D2                 .3.
        sta     $22                             ; D115 85 22                    ."
        lda     LD234,x                         ; D117 BD 34 D2                 .4.
        sta     $10                             ; D11A 85 10                    ..
        lda     #$03                            ; D11C A9 03                    ..
        sta     $11                             ; D11E 85 11                    ..
        lda     #$25                            ; D120 A9 25                    .%
        jsr     queue_sound                           ; D122 20 5D EC                  ].
LD125:  ldy     LD235,x                         ; D125 BC 35 D2                 .5.
        jsr     LD829                           ; D128 20 29 D8                  ).
        lda     #$FF                            ; D12B A9 FF                    ..
        sta     $1C                             ; D12D 85 1C                    ..
LD12F:  lda     #$00                            ; D12F A9 00                    ..
        sta     $95                             ; D131 85 95                    ..
        jsr     frame_wait                      ; D133 20 22 FF                  ".
        inc     $95                             ; D136 E6 95                    ..
        inc     $9D                             ; D138 E6 9D                    ..
        lda     $9D                             ; D13A A5 9D                    ..
        and     #$03                            ; D13C 29 03                    ).
        bne     LD12F                           ; D13E D0 EF                    ..
        inx                                     ; D140 E8                       .
        dec     $11                             ; D141 C6 11                    ..
        beq     LD16A                           ; D143 F0 25                    .%
        lda     $07D1                           ; D145 AD D1 07                 ...
        sec                                     ; D148 38                       8
        sbc     #$40                            ; D149 E9 40                    .@
        sta     $07D1                           ; D14B 8D D1 07                 ...
        lda     $07D0                           ; D14E AD D0 07                 ...
        sbc     #$00                            ; D151 E9 00                    ..
        sta     $07D0                           ; D153 8D D0 07                 ...
        lda     $10                             ; D156 A5 10                    ..
        eor     #$02                            ; D158 49 02                    I.
        sta     $10                             ; D15A 85 10                    ..
        and     #$02                            ; D15C 29 02                    ).
        beq     LD125                           ; D15E F0 C5                    ..
        lda     $22                             ; D160 A5 22                    ."
        sec                                     ; D162 38                       8
        sbc     #$08                            ; D163 E9 08                    ..
        sta     $22                             ; D165 85 22                    ."
        jmp     LD125                           ; D167 4C 25 D1                 L%.

; ----------------------------------------------------------------------------
LD16A:  rts                                     ; D16A 60                       `

; ----------------------------------------------------------------------------
LD16B:  ldy     $26                             ; D16B A4 26                    .&
        lda     $0348                           ; D16D AD 48 03                 .H.
        cmp     LD301,y                         ; D170 D9 01 D3                 ...
        beq     LD16A                           ; D173 F0 F5                    ..
        lda     #$00                            ; D175 A9 00                    ..
        sta     $9D                             ; D177 85 9D                    ..
        lda     $26                             ; D179 A5 26                    .&
        sta     L0000                           ; D17B 85 00                    ..
        cmp     #$0E                            ; D17D C9 0E                    ..
        bne     LD18A                           ; D17F D0 09                    ..
        ldy     $F9                             ; D181 A4 F9                    ..
        lda     stage0E_screen_banks,y                         ; D183 B9 93 D7                 ...
        sta     L0000                           ; D186 85 00                    ..
        sta     $27                             ; D188 85 27                    .'
LD18A:  lda     L0000                           ; D18A A5 00                    ..
        asl     a                               ; D18C 0A                       .
        asl     a                               ; D18D 0A                       .
        clc                                     ; D18E 18                       .
        adc     L0000                           ; D18F 65 00                    e.
        tax                                     ; D191 AA                       .
        lda     LD2B1,x                         ; D192 BD B1 D2                 ...
        sta     $07D0                           ; D195 8D D0 07                 ...
        lda     LD2B2,x                         ; D198 BD B2 D2                 ...
        sta     $07D1                           ; D19B 8D D1 07                 ...
        lda     LD2B3,x                         ; D19E BD B3 D2                 ...
        sta     $22                             ; D1A1 85 22                    ."
        lda     LD2B4,x                         ; D1A3 BD B4 D2                 ...
        sta     $10                             ; D1A6 85 10                    ..
        lda     #$03                            ; D1A8 A9 03                    ..
        sta     $11                             ; D1AA 85 11                    ..
        lda     LD2B5,x                         ; D1AC BD B5 D2                 ...
        sta     $12                             ; D1AF 85 12                    ..
        lda     $F0                             ; D1B1 A5 F0                    ..
        bne     LD1BA                           ; D1B3 D0 05                    ..
        lda     #$25                            ; D1B5 A9 25                    .%
        jsr     queue_sound                           ; D1B7 20 5D EC                  ].
LD1BA:  ldy     $12                             ; D1BA A4 12                    ..
        jsr     LD829                           ; D1BC 20 29 D8                  ).
        ldx     #$00                            ; D1BF A2 00                    ..
        jsr     LD8C7                           ; D1C1 20 C7 D8                  ..
        ldy     #$00                            ; D1C4 A0 00                    ..
        sty     $07D2                           ; D1C6 8C D2 07                 ...
        sty     $07D7                           ; D1C9 8C D7 07                 ...
LD1CC:  lda     $07D4,y                         ; D1CC B9 D4 07                 ...
        sta     $07D3,y                         ; D1CF 99 D3 07                 ...
        iny                                     ; D1D2 C8                       .
        cpy     #$04                            ; D1D3 C0 04                    ..
        bne     LD1CC                           ; D1D5 D0 F5                    ..
        ldy     #$00                            ; D1D7 A0 00                    ..
LD1D9:  lda     $07D9,y                         ; D1D9 B9 D9 07                 ...
        sta     $07D7,y                         ; D1DC 99 D7 07                 ...
        iny                                     ; D1DF C8                       .
        cpy     #$06                            ; D1E0 C0 06                    ..
        bne     LD1D9                           ; D1E2 D0 F5                    ..
        sta     $1C                             ; D1E4 85 1C                    ..
        lda     $F0                             ; D1E6 A5 F0                    ..
        beq     LD1F6                           ; D1E8 F0 0C                    ..
        lda     #$00                            ; D1EA A9 00                    ..
        sta     $1C                             ; D1EC 85 1C                    ..
        ldx     #$50                            ; D1EE A2 50                    .P
        jsr     nametable_flush_at                           ; D1F0 20 9C C2                  ..
        jmp     LD207                           ; D1F3 4C 07 D2                 L..

; ----------------------------------------------------------------------------
LD1F6:  lda     #$00                            ; D1F6 A9 00                    ..
        sta     $95                             ; D1F8 85 95                    ..
        jsr     frame_wait                      ; D1FA 20 22 FF                  ".
        inc     $95                             ; D1FD E6 95                    ..
        inc     $9D                             ; D1FF E6 9D                    ..
        lda     $9D                             ; D201 A5 9D                    ..
        and     #$03                            ; D203 29 03                    ).
        bne     LD1F6                           ; D205 D0 EF                    ..
LD207:  dec     $11                             ; D207 C6 11                    ..
        beq     LD230                           ; D209 F0 25                    .%
        lda     $07D1                           ; D20B AD D1 07                 ...
        clc                                     ; D20E 18                       .
        adc     #$40                            ; D20F 69 40                    i@
        sta     $07D1                           ; D211 8D D1 07                 ...
        lda     $07D0                           ; D214 AD D0 07                 ...
        adc     #$00                            ; D217 69 00                    i.
        sta     $07D0                           ; D219 8D D0 07                 ...
        lda     $10                             ; D21C A5 10                    ..
        eor     #$02                            ; D21E 49 02                    I.
        sta     $10                             ; D220 85 10                    ..
        and     #$02                            ; D222 29 02                    ).
        bne     LD1BA                           ; D224 D0 94                    ..
        lda     $22                             ; D226 A5 22                    ."
        clc                                     ; D228 18                       .
        adc     #$08                            ; D229 69 08                    i.
        sta     $22                             ; D22B 85 22                    ."
        jmp     LD1BA                           ; D22D 4C BA D1                 L..

; ----------------------------------------------------------------------------
LD230:  rts                                     ; D230 60                       `

; ----------------------------------------------------------------------------
LD231:  .byte   $22                             ; D231 22                       "
LD232:  .byte   $DE                             ; D232 DE                       .
LD233:  .byte   $2F                             ; D233 2F                       /
LD234:  .byte   $03                             ; D234 03                       .
LD235:  .byte   $E2                             ; D235 E2                       .
        .byte   $E2                             ; D236 E2                       .
        .byte   $E3                             ; D237 E3                       .
        brk                                     ; D238 00                       .
        .byte   $22                             ; D239 22                       "
        dec     $032F,x                         ; D23A DE 2F 03                 ./.
        jmp     (L6F64)                         ; D23D 6C 64 6F                 ldo

; ----------------------------------------------------------------------------
        brk                                     ; D240 00                       .
        .byte   $22                             ; D241 22                       "
        dec     $032F,x                         ; D242 DE 2F 03                 ./.
        .byte   $5F                             ; D245 5F                       _
        .byte   $5F                             ; D246 5F                       _
        brk                                     ; D247 00                       .
        brk                                     ; D248 00                       .
        .byte   $22                             ; D249 22                       "
        dec     $032F,x                         ; D24A DE 2F 03                 ./.
        brk                                     ; D24D 00                       .
        brk                                     ; D24E 00                       .
        brk                                     ; D24F 00                       .
        brk                                     ; D250 00                       .
        .byte   $22                             ; D251 22                       "
        dec     $032F,x                         ; D252 DE 2F 03                 ./.
        cpy     #$C0                            ; D255 C0 C0                    ..
        cmp     (L0000,x)                       ; D257 C1 00                    ..
        .byte   $22                             ; D259 22                       "
        dec     $032F,x                         ; D25A DE 2F 03                 ./.
        ora     ($01,x)                         ; D25D 01 01                    ..
        bpl     LD261                           ; D25F 10 00                    ..
LD261:  .byte   $22                             ; D261 22                       "
        dec     $032F,x                         ; D262 DE 2F 03                 ./.
        bvc     LD2B7                           ; D265 50 50                    PP
        eor     (L0000),y                       ; D267 51 00                    Q.
        .byte   $22                             ; D269 22                       "
        dec     $032F,x                         ; D26A DE 2F 03                 ./.
        ora     a:$05                           ; D26D 0D 05 00                 ...
        brk                                     ; D270 00                       .
        .byte   $22                             ; D271 22                       "
        dec     $032F,x                         ; D272 DE 2F 03                 ./.
        adc     $65                             ; D275 65 65                    ee
        adc     $2200                           ; D277 6D 00 22                 m."
        dec     $032F,x                         ; D27A DE 2F 03                 ./.
        tax                                     ; D27D AA                       .
        tax                                     ; D27E AA                       .
        brk                                     ; D27F 00                       .
        brk                                     ; D280 00                       .
        .byte   $22                             ; D281 22                       "
        dec     $032F,x                         ; D282 DE 2F 03                 ./.
        asl     $15,x                           ; D285 16 15                    ..
        ora     (L0000),y                       ; D287 11 00                    ..
        .byte   $22                             ; D289 22                       "
        asl     $0127,x                         ; D28A 1E 27 01                 .'.
        adc     $65                             ; D28D 65 65                    ee
        adc     $2200                           ; D28F 6D 00 22                 m."
        dec     $032F,x                         ; D292 DE 2F 03                 ./.
        and     ($24,x)                         ; D295 21 24                    !$
        bit     $2200                           ; D297 2C 00 22                 ,."
        dec     $032F,x                         ; D29A DE 2F 03                 ./.
        .byte   $8B                             ; D29D 8B                       .
        .byte   $8B                             ; D29E 8B                       .
        ora     L0000,x                         ; D29F 15 00                    ..
        .byte   $22                             ; D2A1 22                       "
        dec     $032F,x                         ; D2A2 DE 2F 03                 ./.
        .byte   $E2                             ; D2A5 E2                       .
        .byte   $E2                             ; D2A6 E2                       .
        .byte   $E3                             ; D2A7 E3                       .
        brk                                     ; D2A8 00                       .
        .byte   $22                             ; D2A9 22                       "
        dec     $032F,x                         ; D2AA DE 2F 03                 ./.
        .byte   $72                             ; D2AD 72                       r
        .byte   $72                             ; D2AE 72                       r
        .byte   $7B                             ; D2AF 7B                       {
        brk                                     ; D2B0 00                       .
LD2B1:  .byte   $22                             ; D2B1 22                       "
LD2B2:  .byte   $41                             ; D2B2 41                       A
LD2B3:  .byte   $20                             ; D2B3 20                        
LD2B4:  .byte   $02                             ; D2B4 02                       .
LD2B5:  dex                                     ; D2B5 CA                       .
        .byte   $22                             ; D2B6 22                       "
LD2B7:  eor     (L0020,x)                       ; D2B7 41 20                    A 
        .byte   $02                             ; D2B9 02                       .
        .byte   $02                             ; D2BA 02                       .
        .byte   $22                             ; D2BB 22                       "
        eor     (L0020,x)                       ; D2BC 41 20                    A 
        .byte   $02                             ; D2BE 02                       .
        .byte   $17                             ; D2BF 17                       .
        .byte   $22                             ; D2C0 22                       "
        eor     (L0020,x)                       ; D2C1 41 20                    A 
        .byte   $02                             ; D2C3 02                       .
        .byte   $5F                             ; D2C4 5F                       _
        .byte   $22                             ; D2C5 22                       "
        eor     (L0020,x)                       ; D2C6 41 20                    A 
        .byte   $02                             ; D2C8 02                       .
        asl     a                               ; D2C9 0A                       .
        .byte   $22                             ; D2CA 22                       "
        eor     (L0020,x)                       ; D2CB 41 20                    A 
        .byte   $02                             ; D2CD 02                       .
        sed                                     ; D2CE F8                       .
        .byte   $22                             ; D2CF 22                       "
        eor     (L0020,x)                       ; D2D0 41 20                    A 
        .byte   $02                             ; D2D2 02                       .
        .byte   $7A                             ; D2D3 7A                       z
        .byte   $22                             ; D2D4 22                       "
        eor     (L0020,x)                       ; D2D5 41 20                    A 
        .byte   $02                             ; D2D7 02                       .
        asl     $4122                           ; D2D8 0E 22 41                 ."A
        jsr     L0A02                           ; D2DB 20 02 0A                  ..
        .byte   $22                             ; D2DE 22                       "
        eor     (L0020,x)                       ; D2DF 41 20                    A 
        .byte   $02                             ; D2E1 02                       .
        ora     #$22                            ; D2E2 09 22                    ."
        eor     (L0020,x)                       ; D2E4 41 20                    A 
        .byte   $02                             ; D2E6 02                       .
        sta     $21                             ; D2E7 85 21                    .!
        sta     ($18,x)                         ; D2E9 81 18                    ..
        brk                                     ; D2EB 00                       .
        asl     a                               ; D2EC 0A                       .
        .byte   $22                             ; D2ED 22                       "
        eor     (L0020,x)                       ; D2EE 41 20                    A 
        .byte   $02                             ; D2F0 02                       .
        .byte   $07                             ; D2F1 07                       .
        .byte   $22                             ; D2F2 22                       "
        eor     (L0020,x)                       ; D2F3 41 20                    A 
        .byte   $02                             ; D2F5 02                       .
        asl     a                               ; D2F6 0A                       .
        .byte   $22                             ; D2F7 22                       "
        eor     (L0020,x)                       ; D2F8 41 20                    A 
        .byte   $02                             ; D2FA 02                       .
        dex                                     ; D2FB CA                       .
        .byte   $22                             ; D2FC 22                       "
        eor     (L0020,x)                       ; D2FD 41 20                    A 
        .byte   $02                             ; D2FF 02                       .
        .byte   $41                             ; D300 41                       A
LD301:  brk                                     ; D301 00                       .
        brk                                     ; D302 00                       .
        brk                                     ; D303 00                       .
        brk                                     ; D304 00                       .
        brk                                     ; D305 00                       .
        brk                                     ; D306 00                       .
        brk                                     ; D307 00                       .
        brk                                     ; D308 00                       .
        brk                                     ; D309 00                       .
        brk                                     ; D30A 00                       .
        brk                                     ; D30B 00                       .
        brk                                     ; D30C 00                       .
        .byte   $1B                             ; D30D 1B                       .
        clc                                     ; D30E 18                       .
        brk                                     ; D30F 00                       .
        .byte   $07                             ; D310 07                       .
; =============================================================================
; STAGE LOAD — $D311
; Fade out, clear entities/OAM/scroll state, rendering off, init via
; $F3F2, then progressive full-screen redraw (draw_scroll_column per
; column in increment-32 mode). $27 seeded from stage_alt_bank_tbl.
; $1B guards the background task off the buffers during the redraw.
; =============================================================================
stage_load:  lda     #$00                            ; D311 A9 00                    ..
        sta     $95                             ; D313 85 95                    ..
        jsr     palette_fade_out                           ; D315 20 F1 C3                  ..
        inc     $1B                             ; D318 E6 1B                    ..
        jsr     oam_clear                           ; D31A 20 8F C3                  ..
        jsr     entity_clear_all                           ; D31D 20 9D C3                  ..
        jsr     scroll_irq_reset                           ; D320 20 B8 C3                  ..
        jsr     frame_wait                      ; D323 20 22 FF                  ".
        jsr     disable_rendering                           ; D326 20 D1 C2                  ..
        jsr     stage_state_init                           ; D329 20 F2 F3                  ..
        lda     $F9                             ; D32C A5 F9                    ..
        sta     $24                             ; D32E 85 24                    .$
        sta     $0348                           ; D330 8D 48 03                 .H.
        ldy     $26                             ; D333 A4 26                    .&
        lda     stage_alt_bank_tbl,y                         ; D335 B9 C2 D4                 ...
        sta     $27                             ; D338 85 27                    .'
LD33A:  jsr     draw_scroll_column                           ; D33A 20 E2 D4                  ..
        lda     $FF                             ; D33D A5 FF                    ..
        ora     #$04                            ; D33F 09 04                    ..
        sta     L2000                           ; D341 8D 00 20                 .. 
        ldx     #$00                            ; D344 A2 00                    ..
        stx     $1A                             ; D346 86 1A                    ..
        jsr     nametable_flush_at                           ; D348 20 9C C2                  ..
        lda     $FF                             ; D34B A5 FF                    ..
        sta     L2000                           ; D34D 8D 00 20                 .. 
        lda     $24                             ; D350 A5 24                    .$
        cmp     $F9                             ; D352 C5 F9                    ..
        bne     LD364                           ; D354 D0 0E                    ..
        inc     $25                             ; D356 E6 25                    .%
        lda     $25                             ; D358 A5 25                    .%
        and     #$1F                            ; D35A 29 1F                    ).
        sta     $25                             ; D35C 85 25                    .%
        bne     LD33A                           ; D35E D0 DA                    ..
        inc     $24                             ; D360 E6 24                    .$
        bne     LD33A                           ; D362 D0 D6                    ..
LD364:  lda     $26                             ; D364 A5 26                    .&
        sta     $F6                             ; D366 85 F6                    ..
        jsr     bank_load_shadow                ; D368 20 43 FF                  C.
        ldy     #$0F                            ; D36B A0 0F                    ..
LD36D:  lda     $A988,y                         ; D36D B9 88 A9                 ...
        sta     $0620,y                         ; D370 99 20 06                 . .
        lda     player_pal_bg,y                         ; D373 B9 B2 D4                 ...
        sta     $0630,y                         ; D376 99 30 06                 .0.
        cpy     #$04                            ; D379 C0 04                    ..
        bcs     LD38B                           ; D37B B0 0E                    ..
        lda     $A998,y                         ; D37D B9 98 A9                 ...
        sta     $05F0,y                         ; D380 99 F0 05                 ...
        lda     #$00                            ; D383 A9 00                    ..
        sta     $05F4,y                         ; D385 99 F4 05                 ...
        sta     $05F8,y                         ; D388 99 F8 05                 ...
LD38B:  dey                                     ; D38B 88                       .
        bpl     LD36D                           ; D38C 10 DF                    ..
        lda     $0620                           ; D38E AD 20 06                 . .
        sta     $0630                           ; D391 8D 30 06                 .0.
        lda     $A980                           ; D394 AD 80 A9                 ...
        sta     $EA                             ; D397 85 EA                    ..
        lda     $A981                           ; D399 AD 81 A9                 ...
        sta     $EB                             ; D39C 85 EB                    ..
        ldy     $F9                             ; D39E A4 F9                    ..
        lda     $AC00,y                         ; D3A0 B9 00 AC                 ...
        sta     $AD                             ; D3A3 85 AD                    ..
        sta     $AE                             ; D3A5 85 AE                    ..
        lda     #$01                            ; D3A7 A9 01                    ..
        sta     $28                             ; D3A9 85 28                    .(
        sta     $AC                             ; D3AB 85 AC                    ..
        lda     #$4C                            ; D3AD A9 4C                    .L
        sta     $03A8                           ; D3AF 8D A8 03                 ...
        lda     #$01                            ; D3B2 A9 01                    ..
        sta     $03C0                           ; D3B4 8D C0 03                 ...
        ldy     $29                             ; D3B7 A4 29                    .)
        sty     L0000                           ; D3B9 84 00                    ..
        lda     $A950,y                         ; D3BB B9 50 A9                 .P.
        and     #$1F                            ; D3BE 29 1F                    ).
        sta     $2A                             ; D3C0 85 2A                    .*
        lda     #$00                            ; D3C2 A9 00                    ..
        sta     $2B                             ; D3C4 85 2B                    .+
        lda     $A950,y                         ; D3C6 B9 50 A9                 .P.
        and     #$E0                            ; D3C9 29 E0                    ).
        ora     L0000                           ; D3CB 05 00                    ..
        sta     $29                             ; D3CD 85 29                    .)
        and     #$20                            ; D3CF 29 20                    ) 
        beq     LD3DD                           ; D3D1 F0 0A                    ..
        lda     $29                             ; D3D3 A5 29                    .)
        and     #$3F                            ; D3D5 29 3F                    )?
        sta     $29                             ; D3D7 85 29                    .)
        lda     #$01                            ; D3D9 A9 01                    ..
        bne     LD3E3                           ; D3DB D0 06                    ..
LD3DD:  lda     $F9                             ; D3DD A5 F9                    ..
        sta     $24                             ; D3DF 85 24                    .$
        lda     #$00                            ; D3E1 A9 00                    ..
LD3E3:  jsr     set_mirroring                   ; D3E3 20 B7 FF                  ..
        ldy     L0000                           ; D3E6 A4 00                    ..
        lda     $A968,y                         ; D3E8 B9 68 A9                 .h.
        bpl     LD3F0                           ; D3EB 10 03                    ..
        jsr     LD16B                           ; D3ED 20 6B D1                  k.
LD3F0:  jsr     call_bank00_frame                           ; D3F0 20 2D F3                  -.
        ldy     $26                             ; D3F3 A4 26                    .&
        lda     LD4D2,y                         ; D3F5 B9 D2 D4                 ...
        jsr     queue_sound_param                           ; D3F8 20 5B EC                  [.
        lda     #$01                            ; D3FB A9 01                    ..
        sta     $F5                             ; D3FD 85 F5                    ..
        jsr     bank_load_shadow                ; D3FF 20 43 FF                  C.
        ldy     $50                             ; D402 A4 50                    .P
        lda     $85F1,y                         ; D404 B9 F1 85                 ...
        sta     $ED                             ; D407 85 ED                    ..
        lda     $50                             ; D409 A5 50                    .P
        asl     a                               ; D40B 0A                       .
        asl     a                               ; D40C 0A                       .
        tay                                     ; D40D A8                       .
        lda     $854B,y                         ; D40E B9 4B 85                 .K.
        sta     $0631                           ; D411 8D 31 06                 .1.
        lda     $854C,y                         ; D414 B9 4C 85                 .L.
        sta     $0632                           ; D417 8D 32 06                 .2.
        lda     $854D,y                         ; D41A B9 4D 85                 .M.
        sta     $0633                           ; D41D 8D 33 06                 .3.
        lda     $FC                             ; D420 A5 FC                    ..
        sta     $44                             ; D422 85 44                    .D
        lda     $FA                             ; D424 A5 FA                    ..
        sta     $45                             ; D426 85 45                    .E
        lda     $0378                           ; D428 AD 78 03                 .x.
        sta     $3E                             ; D42B 85 3E                    .>
        lda     $0348                           ; D42D AD 48 03                 .H.
        sta     $3D                             ; D430 85 3D                    .=
        lda     $0330                           ; D432 AD 30 03                 .0.
        sta     $3C                             ; D435 85 3C                    .<
        lda     #$0B                            ; D437 A9 0B                    ..
        sta     $F5                             ; D439 85 F5                    ..
        jsr     bank_load_shadow                ; D43B 20 43 FF                  C.
        jsr     L814D                           ; D43E 20 4D 81                  M.
        lda     $26                             ; D441 A5 26                    .&
        cmp     #$0E                            ; D443 C9 0E                    ..
        bne     LD450                           ; D445 D0 09                    ..
        lda     $F9                             ; D447 A5 F9                    ..
        cmp     #$03                            ; D449 C9 03                    ..
        bne     LD450                           ; D44B D0 03                    ..
        jsr     L8000                           ; D44D 20 00 80                  ..
LD450:  jsr     LD474                           ; D450 20 74 D4                  t.
        jsr     enable_rendering                           ; D453 20 DB C2                  ..
        jsr     frame_wait                      ; D456 20 22 FF                  ".
        lda     #$00                            ; D459 A9 00                    ..
        sta     $1B                             ; D45B 85 1B                    ..
        jmp     palette_fade_in                           ; D45D 4C EB C3                 L..

; ----------------------------------------------------------------------------
        lda     $F5                             ; D460 A5 F5                    ..
        pha                                     ; D462 48                       H
        lda     $F6                             ; D463 A5 F6                    ..
        pha                                     ; D465 48                       H
        jsr     stage_load                           ; D466 20 11 D3                  ..
        inc     $95                             ; D469 E6 95                    ..
        pla                                     ; D46B 68                       h
        sta     $F6                             ; D46C 85 F6                    ..
        pla                                     ; D46E 68                       h
        sta     $F5                             ; D46F 85 F5                    ..
        jmp     bank_load_shadow                ; D471 4C 43 FF                 LC.

; ----------------------------------------------------------------------------
LD474:  lda     $26                             ; D474 A5 26                    .&
        cmp     #$0B                            ; D476 C9 0B                    ..
        bne     LD4B1                           ; D478 D0 37                    .7
        lda     $69                             ; D47A A5 69                    .i
        cmp     #$04                            ; D47C C9 04                    ..
        bne     LD4B1                           ; D47E D0 31                    .1
        lda     #$1B                            ; D480 A9 1B                    ..
        sta     $F5                             ; D482 85 F5                    ..
        jsr     bank_load_shadow                ; D484 20 43 FF                  C.
        ldy     #$36                            ; D487 A0 36                    .6
        ldx     #$28                            ; D489 A2 28                    .(
        stx     $43                             ; D48B 86 43                    .C
LD48D:  lda     $8F7F,y                         ; D48D B9 7F 8F                 ...
        sta     $06BC,x                         ; D490 9D BC 06                 ...
        lda     $8F80,y                         ; D493 B9 80 8F                 ...
        sta     $06BD,x                         ; D496 9D BD 06                 ...
        lda     $8F81,y                         ; D499 B9 81 8F                 ...
        sta     $06BE,x                         ; D49C 9D BE 06                 ...
        lda     $8F82,y                         ; D49F B9 82 8F                 ...
        sta     $06BF,x                         ; D4A2 9D BF 06                 ...
        dey                                     ; D4A5 88                       .
        dey                                     ; D4A6 88                       .
        dey                                     ; D4A7 88                       .
        dey                                     ; D4A8 88                       .
        dey                                     ; D4A9 88                       .
        dey                                     ; D4AA 88                       .
        dex                                     ; D4AB CA                       .
        dex                                     ; D4AC CA                       .
        dex                                     ; D4AD CA                       .
        dex                                     ; D4AE CA                       .
        bne     LD48D                           ; D4AF D0 DC                    ..
LD4B1:  rts                                     ; D4B1 60                       `

; ----------------------------------------------------------------------------
player_pal_bg:  .byte   $0F                             ; D4B2 0F                       .
        .byte   $0F                             ; D4B3 0F                       .
        .byte   $2C                             ; D4B4 2C                       ,
        .byte   $11                             ; D4B5 11                       .
player_pal_spr:  .byte   $0F                             ; D4B6 0F                       .
        .byte   $0F                             ; D4B7 0F                       .
        jsr     L0F37                           ; D4B8 20 37 0F                  7.
        .byte   $0F                             ; D4BB 0F                       .
        jsr     L0F27                           ; D4BC 20 27 0F                  '.
        .byte   $0F                             ; D4BF 0F                       .
        .byte   $20                             ; D4C0 20                        
        rol     a                               ; D4C1 2A                       *
stage_alt_bank_tbl:  brk                                     ; D4C2 00                       .
        ora     ($02,x)                         ; D4C3 01 02                    ..
        .byte   $03                             ; D4C5 03                       .
        .byte   $04                             ; D4C6 04                       .
        ora     $06                             ; D4C7 05 06                    ..
        .byte   $07                             ; D4C9 07                       .
        php                                     ; D4CA 08                       .
        ora     #$0A                            ; D4CB 09 0A                    ..
        php                                     ; D4CD 08                       .
        .byte   $0C                             ; D4CE 0C                       .
        ora     $0E0E                           ; D4CF 0D 0E 0E                 ...
LD4D2:  brk                                     ; D4D2 00                       .
        .byte   $02                             ; D4D3 02                       .
        ora     ($05,x)                         ; D4D4 01 05                    ..
        .byte   $03                             ; D4D6 03                       .
        asl     $07                             ; D4D7 06 07                    ..
        .byte   $04                             ; D4D9 04                       .
        php                                     ; D4DA 08                       .
        php                                     ; D4DB 08                       .
        php                                     ; D4DC 08                       .
        php                                     ; D4DD 08                       .
        ora     #$09                            ; D4DE 09 09                    ..
        ora     #$09                            ; D4E0 09 09                    ..
draw_scroll_column:  ldy     $24                             ; D4E2 A4 24                    .$
        jsr     screen_layout_ptr                           ; D4E4 20 A3 D7                  ..
        lda     #$20                            ; D4E7 A9 20                    . 
        sta     $0780                           ; D4E9 8D 80 07                 ...
        lda     $25                             ; D4EC A5 25                    .%
        sta     $0781                           ; D4EE 8D 81 07                 ...
        lsr     a                               ; D4F1 4A                       J
        lsr     a                               ; D4F2 4A                       J
        sta     $22                             ; D4F3 85 22                    ."
        lda     #$1D                            ; D4F5 A9 1D                    ..
        sta     $0782                           ; D4F7 8D 82 07                 ...
        lda     #$00                            ; D4FA A9 00                    ..
        sta     $03                             ; D4FC 85 03                    ..
        sta     L0004                           ; D4FE 85 04                    ..
        lda     $25                             ; D500 A5 25                    .%
        and     #$03                            ; D502 29 03                    ).
        sta     $05                             ; D504 85 05                    ..
LD506:  jsr     metatile_strip_decode                           ; D506 20 C0 D6                  ..
        ldx     $03                             ; D509 A6 03                    ..
        ldy     $05                             ; D50B A4 05                    ..
        lda     $05E0,y                         ; D50D B9 E0 05                 ...
        sta     $0783,x                         ; D510 9D 83 07                 ...
        lda     $05E4,y                         ; D513 B9 E4 05                 ...
        sta     $0784,x                         ; D516 9D 84 07                 ...
        lda     $22                             ; D519 A5 22                    ."
        cmp     #$38                            ; D51B C9 38                    .8
        bcs     LD531                           ; D51D B0 12                    ..
        lda     $05E8,y                         ; D51F B9 E8 05                 ...
        sta     $0785,x                         ; D522 9D 85 07                 ...
        lda     $05EC,y                         ; D525 B9 EC 05                 ...
        sta     $0786,x                         ; D528 9D 86 07                 ...
        inx                                     ; D52B E8                       .
        inx                                     ; D52C E8                       .
        inx                                     ; D52D E8                       .
        inx                                     ; D52E E8                       .
        stx     $03                             ; D52F 86 03                    ..
LD531:  lda     $05                             ; D531 A5 05                    ..
        lsr     a                               ; D533 4A                       J
        bcc     LD567                           ; D534 90 31                    .1
        tay                                     ; D536 A8                       .
        ldx     $22                             ; D537 A6 22                    ."
        lda     $0640,x                         ; D539 BD 40 06                 .@.
        and     LD57F,y                         ; D53C 39 7F D5                 9..
        sta     L0000                           ; D53F 85 00                    ..
        lda     $10                             ; D541 A5 10                    ..
        and     LD581,y                         ; D543 39 81 D5                 9..
        ora     L0000                           ; D546 05 00                    ..
        sta     $0640,x                         ; D548 9D 40 06                 .@.
        ldx     L0004                           ; D54B A6 04                    ..
        sta     $07A4,x                         ; D54D 9D A4 07                 ...
        lda     #$23                            ; D550 A9 23                    .#
        sta     $07A1,x                         ; D552 9D A1 07                 ...
        lda     #$C0                            ; D555 A9 C0                    ..
        ora     $22                             ; D557 05 22                    ."
        sta     $07A2,x                         ; D559 9D A2 07                 ...
        lda     #$00                            ; D55C A9 00                    ..
        sta     $07A3,x                         ; D55E 9D A3 07                 ...
        inx                                     ; D561 E8                       .
        inx                                     ; D562 E8                       .
        inx                                     ; D563 E8                       .
        inx                                     ; D564 E8                       .
        stx     L0004                           ; D565 86 04                    ..
LD567:  lda     $22                             ; D567 A5 22                    ."
        clc                                     ; D569 18                       .
        adc     #$08                            ; D56A 69 08                    i.
        sta     $22                             ; D56C 85 22                    ."
        cmp     #$40                            ; D56E C9 40                    .@
        bcc     LD506                           ; D570 90 94                    ..
        lda     #$20                            ; D572 A9 20                    . 
        adc     L0004                           ; D574 65 04                    e.
        tay                                     ; D576 A8                       .
        lda     #$FF                            ; D577 A9 FF                    ..
        sta     $0780,y                         ; D579 99 80 07                 ...
        sta     $1A                             ; D57C 85 1A                    ..
        rts                                     ; D57E 60                       `

; ----------------------------------------------------------------------------
LD57F:  .byte   $CC                             ; D57F CC                       .
        .byte   $33                             ; D580 33                       3
LD581:  .byte   $33                             ; D581 33                       3
        .byte   $CC                             ; D582 CC                       .
LD583:  ldy     $24                             ; D583 A4 24                    .$
        jsr     screen_layout_ptr                           ; D585 20 A3 D7                  ..
        lda     $25                             ; D588 A5 25                    .%
        and     #$1C                            ; D58A 29 1C                    ).
        asl     a                               ; D58C 0A                       .
        sta     $22                             ; D58D 85 22                    ."
        lda     #$00                            ; D58F A9 00                    ..
        sta     $03                             ; D591 85 03                    ..
        sta     $06                             ; D593 85 06                    ..
        lda     $25                             ; D595 A5 25                    .%
        and     #$03                            ; D597 29 03                    ).
        tax                                     ; D599 AA                       .
        eor     #$01                            ; D59A 49 01                    I.
        tay                                     ; D59C A8                       .
        lda     LD6A4,x                         ; D59D BD A4 D6                 ...
        sta     L0004                           ; D5A0 85 04                    ..
        lda     LD6A4,y                         ; D5A2 B9 A4 D6                 ...
        sta     $05                             ; D5A5 85 05                    ..
        lda     $25                             ; D5A7 A5 25                    .%
        lsr     a                               ; D5A9 4A                       J
        lsr     a                               ; D5AA 4A                       J
        tay                                     ; D5AB A8                       .
        lda     LD6B8,y                         ; D5AC B9 B8 D6                 ...
        sta     $0780                           ; D5AF 8D 80 07                 ...
        sta     $07D0                           ; D5B2 8D D0 07                 ...
        lda     LD6B0,y                         ; D5B5 B9 B0 D6                 ...
        ora     LD6A8,x                         ; D5B8 1D A8 D6                 ...
        sta     $0781                           ; D5BB 8D 81 07                 ...
        sta     $07D1                           ; D5BE 8D D1 07                 ...
        lda     #$1F                            ; D5C1 A9 1F                    ..
        sta     $0782                           ; D5C3 8D 82 07                 ...
        sta     $07D2                           ; D5C6 8D D2 07                 ...
        lda     #$23                            ; D5C9 A9 23                    .#
        sta     $07A3                           ; D5CB 8D A3 07                 ...
        sta     $07F3                           ; D5CE 8D F3 07                 ...
        lda     #$C0                            ; D5D1 A9 C0                    ..
        ora     $22                             ; D5D3 05 22                    ."
        sta     $07A4                           ; D5D5 8D A4 07                 ...
        sta     $07F4                           ; D5D8 8D F4 07                 ...
        lda     #$07                            ; D5DB A9 07                    ..
        .byte   $8D                             ; D5DD 8D                       .
        .byte   $A5                             ; D5DE A5                       .
LD5DF:  .byte   $07                             ; D5DF 07                       .
        sta     $07F5                           ; D5E0 8D F5 07                 ...
LD5E3:  jsr     metatile_strip_decode                           ; D5E3 20 C0 D6                  ..
        lda     #$04                            ; D5E6 A9 04                    ..
        sta     $07                             ; D5E8 85 07                    ..
        lda     L0004                           ; D5EA A5 04                    ..
        pha                                     ; D5EC 48                       H
        lda     $05                             ; D5ED A5 05                    ..
        pha                                     ; D5EF 48                       H
LD5F0:  ldx     $03                             ; D5F0 A6 03                    ..
        ldy     L0004                           ; D5F2 A4 04                    ..
        lda     $05E0,y                         ; D5F4 B9 E0 05                 ...
        sta     $0783,x                         ; D5F7 9D 83 07                 ...
        ldy     $05                             ; D5FA A4 05                    ..
        lda     $05E0,y                         ; D5FC B9 E0 05                 ...
LD5FF:  sta     $07D3,x                         ; D5FF 9D D3 07                 ...
        inc     $03                             ; D602 E6 03                    ..
        inc     L0004                           ; D604 E6 04                    ..
        inc     $05                             ; D606 E6 05                    ..
        dec     $07                             ; D608 C6 07                    ..
        bne     LD5F0                           ; D60A D0 E4                    ..
        pla                                     ; D60C 68                       h
        sta     $05                             ; D60D 85 05                    ..
        pla                                     ; D60F 68                       h
        sta     L0004                           ; D610 85 04                    ..
        lda     $25                             ; D612 A5 25                    .%
        and     #$03                            ; D614 29 03                    ).
        lsr     a                               ; D616 4A                       J
        tay                                     ; D617 A8                       .
        ldx     $22                             ; D618 A6 22                    ."
        lda     $0640,x                         ; D61A BD 40 06                 .@.
        and     LD6A0,y                         ; D61D 39 A0 D6                 9..
        sta     L0000                           ; D620 85 00                    ..
        lda     $10                             ; D622 A5 10                    ..
        and     LD6A2,y                         ; D624 39 A2 D6                 9..
        ora     L0000                           ; D627 05 00                    ..
        sta     $0640,x                         ; D629 9D 40 06                 .@.
        ldx     $06                             ; D62C A6 06                    ..
        sta     $07A6,x                         ; D62E 9D A6 07                 ...
        sta     $07F6,x                         ; D631 9D F6 07                 ...
        inc     $06                             ; D634 E6 06                    ..
        inc     $22                             ; D636 E6 22                    ."
        lda     $22                             ; D638 A5 22                    ."
        and     #$07                            ; D63A 29 07                    ).
        bne     LD5E3                           ; D63C D0 A5                    ..
        dec     $22                             ; D63E C6 22                    ."
        lda     $22                             ; D640 A5 22                    ."
        and     #$38                            ; D642 29 38                    )8
        sta     $22                             ; D644 85 22                    ."
        ldy     $24                             ; D646 A4 24                    .$
        iny                                     ; D648 C8                       .
        jsr     screen_layout_ptr                           ; D649 20 A3 D7                  ..
        jsr     metatile_strip_decode                           ; D64C 20 C0 D6                  ..
        ldy     L0004                           ; D64F A4 04                    ..
        lda     $05E0,y                         ; D651 B9 E0 05                 ...
        sta     $0783                           ; D654 8D 83 07                 ...
        ldy     $05                             ; D657 A4 05                    ..
        lda     $05E0,y                         ; D659 B9 E0 05                 ...
        sta     $07D3                           ; D65C 8D D3 07                 ...
        lda     $28                             ; D65F A5 28                    .(
        and     #$04                            ; D661 29 04                    ).
        lsr     a                               ; D663 4A                       J
        lsr     a                               ; D664 4A                       J
        tax                                     ; D665 AA                       .
        ldy     LD6AC,x                         ; D666 BC AC D6                 ...
        lda     #$FF                            ; D669 A9 FF                    ..
        sta     $0780,y                         ; D66B 99 80 07                 ...
        sta     $19                             ; D66E 85 19                    ..
        sta     $07D0,y                         ; D670 99 D0 07                 ...
        rts                                     ; D673 60                       `

; ----------------------------------------------------------------------------
LD674:  ldy     #$2E                            ; D674 A0 2E                    ..
LD676:  lda     $07D0,y                         ; D676 B9 D0 07                 ...
        sta     $0780,y                         ; D679 99 80 07                 ...
        dey                                     ; D67C 88                       .
        bpl     LD676                           ; D67D 10 F7                    ..
        lda     $0781                           ; D67F AD 81 07                 ...
        eor     #$20                            ; D682 49 20                    I 
        sta     $0781                           ; D684 8D 81 07                 ...
        lda     #$23                            ; D687 A9 23                    .#
        sta     $07A3                           ; D689 8D A3 07                 ...
        lda     $28                             ; D68C A5 28                    .(
        and     #$04                            ; D68E 29 04                    ).
        lsr     a                               ; D690 4A                       J
        lsr     a                               ; D691 4A                       J
        eor     #$01                            ; D692 49 01                    I.
        tax                                     ; D694 AA                       .
        ldy     LD6AC,x                         ; D695 BC AC D6                 ...
        lda     #$FF                            ; D698 A9 FF                    ..
        sta     $0780,y                         ; D69A 99 80 07                 ...
        sta     $19                             ; D69D 85 19                    ..
        rts                                     ; D69F 60                       `

; ----------------------------------------------------------------------------
LD6A0:  beq     LD6B1                           ; D6A0 F0 0F                    ..
LD6A2:  .byte   $0F                             ; D6A2 0F                       .
        .byte   $F0                             ; D6A3 F0                       .
LD6A4:  brk                                     ; D6A4 00                       .
        .byte   $04                             ; D6A5 04                       .
        php                                     ; D6A6 08                       .
        .byte   $0C                             ; D6A7 0C                       .
LD6A8:  brk                                     ; D6A8 00                       .
        jsr     L6040                           ; D6A9 20 40 60                  @`
LD6AC:  .byte   $23                             ; D6AC 23                       #
        rol     $1F2A                           ; D6AD 2E 2A 1F                 .*.
LD6B0:  brk                                     ; D6B0 00                       .
LD6B1:  .byte   $80                             ; D6B1 80                       .
        brk                                     ; D6B2 00                       .
        .byte   $80                             ; D6B3 80                       .
        brk                                     ; D6B4 00                       .
        .byte   $80                             ; D6B5 80                       .
        brk                                     ; D6B6 00                       .
        .byte   $80                             ; D6B7 80                       .
LD6B8:  jsr     L2120                           ; D6B8 20 20 21                   !
        and     ($22,x)                         ; D6BB 21 22                    !"
        .byte   $22                             ; D6BD 22                       "
        .byte   $23                             ; D6BE 23                       #
        .byte   $23                             ; D6BF 23                       #
metatile_strip_decode:  jsr     block_ptr_setup                           ; D6C0 20 58 D7                  X.
        ldy     #$03                            ; D6C3 A0 03                    ..
        sty     $02                             ; D6C5 84 02                    ..
        lda     #$00                            ; D6C7 A9 00                    ..
        sta     $10                             ; D6C9 85 10                    ..
LD6CB:  ldy     $02                             ; D6CB A4 02                    ..
        ldx     strip_offsets,y                         ; D6CD BE 8B D7                 ...
        lda     (L0000),y                       ; D6D0 B1 00                    ..
        jsr     metatile_override                           ; D6D2 20 03 D7                  ..
        tay                                     ; D6D5 A8                       .
        lda     $AD00,y                         ; D6D6 B9 00 AD                 ...
        sta     $05E0,x                         ; D6D9 9D E0 05                 ...
        lda     $AE00,y                         ; D6DC B9 00 AE                 ...
        sta     $05E1,x                         ; D6DF 9D E1 05                 ...
        lda     $AF00,y                         ; D6E2 B9 00 AF                 ...
        sta     $05E4,x                         ; D6E5 9D E4 05                 ...
        lda     $B000,y                         ; D6E8 B9 00 B0                 ...
        sta     $05E5,x                         ; D6EB 9D E5 05                 ...
        lda     $B100,y                         ; D6EE B9 00 B1                 ...
        and     #$03                            ; D6F1 29 03                    ).
        ora     $10                             ; D6F3 05 10                    ..
        sta     $10                             ; D6F5 85 10                    ..
        dec     $02                             ; D6F7 C6 02                    ..
        bmi     LD702                           ; D6F9 30 07                    0.
        asl     $10                             ; D6FB 06 10                    ..
        asl     $10                             ; D6FD 06 10                    ..
        jmp     LD6CB                           ; D6FF 4C CB D6                 L..

; ----------------------------------------------------------------------------
LD702:  rts                                     ; D702 60                       `

; -----------------------------------------------------------------------------
; METATILE OVERRIDE — $D703
; Replaces a decoded metatile id via the $06C0 dynamic-override records,
; then the $0680 destroyed-block bitmap (-> metatile 0). $59 skips both.
; -----------------------------------------------------------------------------
metatile_override:  pha                                     ; D703 48                       H
        tay                                     ; D704 A8                       .
        lda     $59                             ; D705 A5 59                    .Y
        bne     LD756                           ; D707 D0 4D                    .M
        ldy     $43                             ; D709 A4 43                    .C
        beq     LD72D                           ; D70B F0 20                    . 
LD70D:  lda     $06BC,y                         ; D70D B9 BC 06                 ...
        cmp     $47                             ; D710 C5 47                    .G
        bne     LD727                           ; D712 D0 13                    ..
        lda     $06BD,y                         ; D714 B9 BD 06                 ...
        cmp     $22                             ; D717 C5 22                    ."
        bne     LD727                           ; D719 D0 0C                    ..
        lda     $06BE,y                         ; D71B B9 BE 06                 ...
        cmp     $02                             ; D71E C5 02                    ..
        bne     LD727                           ; D720 D0 05                    ..
        pla                                     ; D722 68                       h
        lda     $06BF,y                         ; D723 B9 BF 06                 ...
        rts                                     ; D726 60                       `

; ----------------------------------------------------------------------------
LD727:  dey                                     ; D727 88                       .
        dey                                     ; D728 88                       .
        dey                                     ; D729 88                       .
        dey                                     ; D72A 88                       .
        bne     LD70D                           ; D72B D0 E0                    ..
LD72D:  lda     $1E                             ; D72D A5 1E                    ..
        bne     LD756                           ; D72F D0 25                    .%
        lda     $22                             ; D731 A5 22                    ."
        and     #$01                            ; D733 29 01                    ).
        asl     a                               ; D735 0A                       .
        asl     a                               ; D736 0A                       .
        ora     $02                             ; D737 05 02                    ..
        tay                                     ; D739 A8                       .
        lda     bit_masks,y                         ; D73A B9 B2 F2                 ...
        sta     $E6                             ; D73D 85 E6                    ..
        lda     $47                             ; D73F A5 47                    .G
        and     #$01                            ; D741 29 01                    ).
        tay                                     ; D743 A8                       .
        lda     $22                             ; D744 A5 22                    ."
        lsr     a                               ; D746 4A                       J
        ora     scr_parity_ofs,y                         ; D747 19 C2 F2                 ...
        tay                                     ; D74A A8                       .
        lda     $0680,y                         ; D74B B9 80 06                 ...
        and     $E6                             ; D74E 25 E6                    %.
        beq     LD756                           ; D750 F0 04                    ..
        pla                                     ; D752 68                       h
        lda     #$00                            ; D753 A9 00                    ..
        pha                                     ; D755 48                       H
LD756:  pla                                     ; D756 68                       h
        rts                                     ; D757 60                       `

; -----------------------------------------------------------------------------
; BLOCK POINTER SETUP — $D758
; temp_00/01 -> block def ($B200 + block_id*4), block id from the
; layout at ($20),y=$22. Maps the stage bank first; stage $0E screens
; borrow other stages' banks via stage0E_screen_banks (boss teleporter).
; -----------------------------------------------------------------------------
block_ptr_setup:  lda     $26                             ; D758 A5 26                    .&
        cmp     #$0E                            ; D75A C9 0E                    ..
        bne     LD768                           ; D75C D0 0A                    ..
        ldy     $47                             ; D75E A4 47                    .G
        lda     stage0E_screen_banks,y                         ; D760 B9 93 D7                 ...
        sta     $27                             ; D763 85 27                    .'
        jmp     LD76A                           ; D765 4C 6A D7                 Lj.

; ----------------------------------------------------------------------------
LD768:  lda     $27                             ; D768 A5 27                    .'
LD76A:  cmp     $F6                             ; D76A C5 F6                    ..
        beq     LD773                           ; D76C F0 05                    ..
        sta     $F6                             ; D76E 85 F6                    ..
        jsr     bank_load_shadow                ; D770 20 43 FF                  C.
LD773:  lda     #$00                            ; D773 A9 00                    ..
        sta     $01                             ; D775 85 01                    ..
        ldy     $22                             ; D777 A4 22                    ."
        lda     (L0020),y                       ; D779 B1 20                    . 
        asl     a                               ; D77B 0A                       .
        rol     $01                             ; D77C 26 01                    &.
        asl     a                               ; D77E 0A                       .
        rol     $01                             ; D77F 26 01                    &.
        sta     L0000                           ; D781 85 00                    ..
        lda     $01                             ; D783 A5 01                    ..
        clc                                     ; D785 18                       .
        adc     #$B2                            ; D786 69 B2                    i.
        sta     $01                             ; D788 85 01                    ..
        rts                                     ; D78A 60                       `

; ----------------------------------------------------------------------------
strip_offsets:  brk                                     ; D78B 00                       .
        .byte   $02                             ; D78C 02                       .
        php                                     ; D78D 08                       .
        asl     a                               ; D78E 0A                       .
attr_quad_masks:  .byte   $FC                             ; D78F FC                       .
        .byte   $F3                             ; D790 F3                       .
        .byte   $CF                             ; D791 CF                       .
        .byte   $3F                             ; D792 3F                       ?
stage0E_screen_banks:  asl     $0E0E                           ; D793 0E 0E 0E                 ...
        asl     $0E0E                           ; D796 0E 0E 0E                 ...
        asl     a:$0E                           ; D799 0E 0E 00                 ...
        ora     ($02,x)                         ; D79C 01 02                    ..
        .byte   $03                             ; D79E 03                       .
        .byte   $04                             ; D79F 04                       .
        ora     $06                             ; D7A0 05 06                    ..
        .byte   $07                             ; D7A2 07                       .
screen_layout_ptr:  lda     $26                             ; D7A3 A5 26                    .&
        cmp     $F6                             ; D7A5 C5 F6                    ..
        beq     LD7AE                           ; D7A7 F0 05                    ..
        sta     $F6                             ; D7A9 85 F6                    ..
        jsr     bank_load_shadow                ; D7AB 20 43 FF                  C.
LD7AE:  cpy     #$80                            ; D7AE C0 80                    ..
        bcc     LD7B4                           ; D7B0 90 02                    ..
        ldy     #$00                            ; D7B2 A0 00                    ..
LD7B4:  lda     $A900,y                         ; D7B4 B9 00 A9                 ...
        sty     $47                             ; D7B7 84 47                    .G
        pha                                     ; D7B9 48                       H
        lda     #$00                            ; D7BA A9 00                    ..
        sta     L0000                           ; D7BC 85 00                    ..
        pla                                     ; D7BE 68                       h
        asl     a                               ; D7BF 0A                       .
        rol     L0000                           ; D7C0 26 00                    &.
        asl     a                               ; D7C2 0A                       .
        rol     L0000                           ; D7C3 26 00                    &.
        asl     a                               ; D7C5 0A                       .
        rol     L0000                           ; D7C6 26 00                    &.
        asl     a                               ; D7C8 0A                       .
        rol     L0000                           ; D7C9 26 00                    &.
        asl     a                               ; D7CB 0A                       .
        rol     L0000                           ; D7CC 26 00                    &.
        asl     a                               ; D7CE 0A                       .
        rol     L0000                           ; D7CF 26 00                    &.
        sta     L0020                           ; D7D1 85 20                    . 
        lda     L0000                           ; D7D3 A5 00                    ..
        clc                                     ; D7D5 18                       .
        adc     #$B6                            ; D7D6 69 B6                    i.
        sta     $21                             ; D7D8 85 21                    .!
        rts                                     ; D7DA 60                       `

; ----------------------------------------------------------------------------
        lda     #$08                            ; D7DB A9 08                    ..
        sta     $07D0                           ; D7DD 8D D0 07                 ...
        lda     $0378,x                         ; D7E0 BD 78 03                 .x.
        and     #$F0                            ; D7E3 29 F0                    ).
        asl     a                               ; D7E5 0A                       .
        rol     $07D0                           ; D7E6 2E D0 07                 ...
        asl     a                               ; D7E9 0A                       .
        rol     $07D0                           ; D7EA 2E D0 07                 ...
        sta     $07D1                           ; D7ED 8D D1 07                 ...
        lda     $0330,x                         ; D7F0 BD 30 03                 .0.
        and     #$F0                            ; D7F3 29 F0                    ).
        lsr     a                               ; D7F5 4A                       J
        lsr     a                               ; D7F6 4A                       J
        lsr     a                               ; D7F7 4A                       J
        ora     $07D1                           ; D7F8 0D D1 07                 ...
LD7FB:  sta     $07D1                           ; D7FB 8D D1 07                 ...
        .byte   $20                             ; D7FE 20                        
LD7FF:  and     #$D8                            ; D7FF 29 D8                    ).
        lda     #$FF                            ; D801 A9 FF                    ..
        sta     $1C                             ; D803 85 1C                    ..
        rts                                     ; D805 60                       `

; ----------------------------------------------------------------------------
        lda     #$08                            ; D806 A9 08                    ..
        sta     $07D0                           ; D808 8D D0 07                 ...
        lda     $0378,x                         ; D80B BD 78 03                 .x.
        and     #$F0                            ; D80E 29 F0                    ).
        asl     a                               ; D810 0A                       .
        rol     $07D0                           ; D811 2E D0 07                 ...
        asl     a                               ; D814 0A                       .
        rol     $07D0                           ; D815 2E D0 07                 ...
        sta     $07D1                           ; D818 8D D1 07                 ...
        lda     $0330,x                         ; D81B BD 30 03                 .0.
        and     #$F0                            ; D81E 29 F0                    ).
        lsr     a                               ; D820 4A                       J
        lsr     a                               ; D821 4A                       J
        lsr     a                               ; D822 4A                       J
        ora     $07D1                           ; D823 0D D1 07                 ...
        sta     $07D1                           ; D826 8D D1 07                 ...
LD829:  lda     $F6                             ; D829 A5 F6                    ..
        pha                                     ; D82B 48                       H
        lda     $27                             ; D82C A5 27                    .'
        sta     $F6                             ; D82E 85 F6                    ..
        jsr     bank_load_shadow                ; D830 20 43 FF                  C.
        lda     $07D0                           ; D833 AD D0 07                 ...
        sta     $07D5                           ; D836 8D D5 07                 ...
        lda     $07D1                           ; D839 AD D1 07                 ...
        ora     #$20                            ; D83C 09 20                    . 
        sta     $07D6                           ; D83E 8D D6 07                 ...
        lda     #$01                            ; D841 A9 01                    ..
        sta     $07D2                           ; D843 8D D2 07                 ...
        sta     $07D7                           ; D846 8D D7 07                 ...
        lda     $AD00,y                         ; D849 B9 00 AD                 ...
        sta     $07D3                           ; D84C 8D D3 07                 ...
        lda     $AE00,y                         ; D84F B9 00 AE                 ...
        sta     $07D4                           ; D852 8D D4 07                 ...
        lda     $AF00,y                         ; D855 B9 00 AF                 ...
        sta     $07D8                           ; D858 8D D8 07                 ...
        lda     $B000,y                         ; D85B B9 00 B0                 ...
        sta     $07D9                           ; D85E 8D D9 07                 ...
        lda     $B100,y                         ; D861 B9 00 B1                 ...
        and     #$03                            ; D864 29 03                    ).
        sta     L0000                           ; D866 85 00                    ..
        ldy     $10                             ; D868 A4 10                    ..
        beq     LD873                           ; D86A F0 07                    ..
LD86C:  asl     L0000                           ; D86C 06 00                    ..
        asl     L0000                           ; D86E 06 00                    ..
        dey                                     ; D870 88                       .
        bne     LD86C                           ; D871 D0 F9                    ..
LD873:  ldy     $10                             ; D873 A4 10                    ..
        lda     attr_quad_masks,y                         ; D875 B9 8F D7                 ...
        ldy     $22                             ; D878 A4 22                    ."
        and     $0640,y                         ; D87A 39 40 06                 9@.
        ora     L0000                           ; D87D 05 00                    ..
        sta     $07DD                           ; D87F 8D DD 07                 ...
        sta     $0640,y                         ; D882 99 40 06                 .@.
        lda     #$23                            ; D885 A9 23                    .#
        sta     $07DA                           ; D887 8D DA 07                 ...
        lda     $22                             ; D88A A5 22                    ."
        ora     #$C0                            ; D88C 09 C0                    ..
        sta     $07DB                           ; D88E 8D DB 07                 ...
        lda     #$00                            ; D891 A9 00                    ..
        sta     $07DC                           ; D893 8D DC 07                 ...
        lda     #$FF                            ; D896 A9 FF                    ..
        sta     $07DE                           ; D898 8D DE 07                 ...
        pla                                     ; D89B 68                       h
        sta     $F6                             ; D89C 85 F6                    ..
        jsr     bank_load_shadow                ; D89E 20 43 FF                  C.
        rts                                     ; D8A1 60                       `

; ----------------------------------------------------------------------------
        lda     $0330,x                         ; D8A2 BD 30 03                 .0.
        lsr     a                               ; D8A5 4A                       J
        lsr     a                               ; D8A6 4A                       J
        lsr     a                               ; D8A7 4A                       J
        lsr     a                               ; D8A8 4A                       J
        pha                                     ; D8A9 48                       H
        and     #$01                            ; D8AA 29 01                    ).
        sta     $10                             ; D8AC 85 10                    ..
        pla                                     ; D8AE 68                       h
        lsr     a                               ; D8AF 4A                       J
        sta     $22                             ; D8B0 85 22                    ."
        lda     $0378,x                         ; D8B2 BD 78 03                 .x.
        lsr     a                               ; D8B5 4A                       J
        lsr     a                               ; D8B6 4A                       J
        pha                                     ; D8B7 48                       H
        and     #$38                            ; D8B8 29 38                    )8
        ora     $22                             ; D8BA 05 22                    ."
        sta     $22                             ; D8BC 85 22                    ."
        pla                                     ; D8BE 68                       h
        lsr     a                               ; D8BF 4A                       J
        and     #$02                            ; D8C0 29 02                    ).
        ora     $10                             ; D8C2 05 10                    ..
        sta     $10                             ; D8C4 85 10                    ..
        rts                                     ; D8C6 60                       `

; ----------------------------------------------------------------------------
LD8C7:  lda     $22                             ; D8C7 A5 22                    ."
        and     #$01                            ; D8C9 29 01                    ).
        asl     a                               ; D8CB 0A                       .
        asl     a                               ; D8CC 0A                       .
        ora     $10                             ; D8CD 05 10                    ..
        tay                                     ; D8CF A8                       .
        lda     bit_masks,y                         ; D8D0 B9 B2 F2                 ...
        sta     L0000                           ; D8D3 85 00                    ..
        lda     $0348,x                         ; D8D5 BD 48 03                 .H.
        and     #$01                            ; D8D8 29 01                    ).
        tay                                     ; D8DA A8                       .
        lda     $22                             ; D8DB A5 22                    ."
        lsr     a                               ; D8DD 4A                       J
        ora     scr_parity_ofs,y                         ; D8DE 19 C2 F2                 ...
        tay                                     ; D8E1 A8                       .
        lda     $0680,y                         ; D8E2 B9 80 06                 ...
        ora     L0000                           ; D8E5 05 00                    ..
        sta     $0680,y                         ; D8E7 99 80 06                 ...
        rts                                     ; D8EA 60                       `

; ----------------------------------------------------------------------------
LD8EB:  lda     $46                             ; D8EB A5 46                    .F
        beq     LD934                           ; D8ED F0 45                    .E
        lda     $F9                             ; D8EF A5 F9                    ..
        and     #$01                            ; D8F1 29 01                    ).
        tay                                     ; D8F3 A8                       .
        lda     scr_parity_ofs,y                         ; D8F4 B9 C2 F2                 ...
        sta     L0000                           ; D8F7 85 00                    ..
        lda     $FC                             ; D8F9 A5 FC                    ..
        lsr     a                               ; D8FB 4A                       J
        lsr     a                               ; D8FC 4A                       J
        lsr     a                               ; D8FD 4A                       J
        lsr     a                               ; D8FE 4A                       J
        lsr     a                               ; D8FF 4A                       J
LD900:  and     #$07                            ; D900 29 07                    ).
        clc                                     ; D902 18                       .
        adc     #$04                            ; D903 69 04                    i.
        cmp     #$08                            ; D905 C9 08                    ..
        and     #$07                            ; D907 29 07                    ).
        sta     $01                             ; D909 85 01                    ..
        bcs     LD913                           ; D90B B0 06                    ..
        lda     L0000                           ; D90D A5 00                    ..
        eor     #$20                            ; D90F 49 20                    I 
        sta     L0000                           ; D911 85 00                    ..
LD913:  lda     $01                             ; D913 A5 01                    ..
        and     #$01                            ; D915 29 01                    ).
        tay                                     ; D917 A8                       .
        lda     LD935,y                         ; D918 B9 35 D9                 .5.
        sta     $02                             ; D91B 85 02                    ..
        lda     $01                             ; D91D A5 01                    ..
        lsr     a                               ; D91F 4A                       J
        ora     L0000                           ; D920 05 00                    ..
        tay                                     ; D922 A8                       .
        ldx     #$08                            ; D923 A2 08                    ..
LD925:  lda     $0680,y                         ; D925 B9 80 06                 ...
        and     $02                             ; D928 25 02                    %.
        sta     $0680,y                         ; D92A 99 80 06                 ...
        iny                                     ; D92D C8                       .
        iny                                     ; D92E C8                       .
        iny                                     ; D92F C8                       .
        iny                                     ; D930 C8                       .
        dex                                     ; D931 CA                       .
        bne     LD925                           ; D932 D0 F1                    ..
LD934:  rts                                     ; D934 60                       `

; ----------------------------------------------------------------------------
LD935:  beq     LD946                           ; D935 F0 0F                    ..
        lda     $19                             ; D937 A5 19                    ..
        ora     $1A                             ; D939 05 1A                    ..
        bne     LD934                           ; D93B D0 F7                    ..
        lda     $1D                             ; D93D A5 1D                    ..
        bpl     LD934                           ; D93F 10 F3                    ..
        and     #$7F                            ; D941 29 7F                    ).
        sta     $1D                             ; D943 85 1D                    ..
        .byte   $29                             ; D945 29                       )
LD946:  .byte   $3F                             ; D946 3F                       ?
        sta     $22                             ; D947 85 22                    ."
        ldy     #$00                            ; D949 A0 00                    ..
        lda     $1D                             ; D94B A5 1D                    ..
        and     #$40                            ; D94D 29 40                    )@
        beq     LD95B                           ; D94F F0 0A                    ..
        ldy     #$04                            ; D951 A0 04                    ..
        lda     $29                             ; D953 A5 29                    .)
        and     #$20                            ; D955 29 20                    ) 
        beq     LD95B                           ; D957 F0 02                    ..
        ldy     #$08                            ; D959 A0 08                    ..
LD95B:  sty     $10                             ; D95B 84 10                    ..
LD95D:  lda     $22                             ; D95D A5 22                    ."
        pha                                     ; D95F 48                       H
        and     #$07                            ; D960 29 07                    ).
        asl     a                               ; D962 0A                       .
        asl     a                               ; D963 0A                       .
        sta     $0781                           ; D964 8D 81 07                 ...
        lda     #$02                            ; D967 A9 02                    ..
        sta     $0780                           ; D969 8D 80 07                 ...
        pla                                     ; D96C 68                       h
        and     #$F8                            ; D96D 29 F8                    ).
        asl     a                               ; D96F 0A                       .
        rol     $0780                           ; D970 2E 80 07                 ...
        asl     a                               ; D973 0A                       .
        rol     $0780                           ; D974 2E 80 07                 ...
        asl     a                               ; D977 0A                       .
        rol     $0780                           ; D978 2E 80 07                 ...
        asl     a                               ; D97B 0A                       .
        rol     $0780                           ; D97C 2E 80 07                 ...
        ora     $0781                           ; D97F 0D 81 07                 ...
        sta     $0781                           ; D982 8D 81 07                 ...
        clc                                     ; D985 18                       .
        adc     #$20                            ; D986 69 20                    i 
        sta     $0788                           ; D988 8D 88 07                 ...
        adc     #$20                            ; D98B 69 20                    i 
        sta     $078F                           ; D98D 8D 8F 07                 ...
        adc     #$20                            ; D990 69 20                    i 
        sta     $0796                           ; D992 8D 96 07                 ...
        lda     $22                             ; D995 A5 22                    ."
        ora     #$C0                            ; D997 09 C0                    ..
        sta     $079D                           ; D999 8D 9D 07                 ...
        lda     $0780                           ; D99C AD 80 07                 ...
        ora     $10                             ; D99F 05 10                    ..
        sta     $0780                           ; D9A1 8D 80 07                 ...
        sta     $0787                           ; D9A4 8D 87 07                 ...
        sta     $078E                           ; D9A7 8D 8E 07                 ...
        sta     $0795                           ; D9AA 8D 95 07                 ...
        ora     #$03                            ; D9AD 09 03                    ..
        sta     $079C                           ; D9AF 8D 9C 07                 ...
        lda     #$03                            ; D9B2 A9 03                    ..
        sta     $0782                           ; D9B4 8D 82 07                 ...
        sta     $0789                           ; D9B7 8D 89 07                 ...
        sta     $0790                           ; D9BA 8D 90 07                 ...
        sta     $0797                           ; D9BD 8D 97 07                 ...
        lda     #$00                            ; D9C0 A9 00                    ..
        sta     $079E                           ; D9C2 8D 9E 07                 ...
        ldy     $23                             ; D9C5 A4 23                    .#
        jsr     screen_layout_ptr                           ; D9C7 20 A3 D7                  ..
        jsr     metatile_strip_decode                           ; D9CA 20 C0 D6                  ..
        ldx     #$03                            ; D9CD A2 03                    ..
LD9CF:  lda     $05E0,x                         ; D9CF BD E0 05                 ...
        sta     $0783,x                         ; D9D2 9D 83 07                 ...
        lda     $05E4,x                         ; D9D5 BD E4 05                 ...
        sta     $078A,x                         ; D9D8 9D 8A 07                 ...
        lda     $05E8,x                         ; D9DB BD E8 05                 ...
        sta     $0791,x                         ; D9DE 9D 91 07                 ...
        lda     $05EC,x                         ; D9E1 BD EC 05                 ...
        sta     $0798,x                         ; D9E4 9D 98 07                 ...
        dex                                     ; D9E7 CA                       .
        bpl     LD9CF                           ; D9E8 10 E5                    ..
        lda     $10                             ; D9EA A5 10                    ..
        sta     $079F                           ; D9EC 8D 9F 07                 ...
        stx     $07A0                           ; D9EF 8E A0 07                 ...
        lda     $22                             ; D9F2 A5 22                    ."
        and     #$3F                            ; D9F4 29 3F                    )?
        cmp     #$38                            ; D9F6 C9 38                    .8
        bcc     LDA05                           ; D9F8 90 0B                    ..
        ldx     #$04                            ; D9FA A2 04                    ..
LD9FC:  lda     $079C,x                         ; D9FC BD 9C 07                 ...
        sta     $078E,x                         ; D9FF 9D 8E 07                 ...
        dex                                     ; DA02 CA                       .
        bpl     LD9FC                           ; DA03 10 F7                    ..
LDA05:  stx     $19                             ; DA05 86 19                    ..
        rts                                     ; DA07 60                       `

; ----------------------------------------------------------------------------
LDA08:  lda     #$00                            ; DA08 A9 00                    ..
        sta     $1E                             ; DA0A 85 1E                    ..
        lda     $10                             ; DA0C A5 10                    ..
        ora     #$03                            ; DA0E 09 03                    ..
        sta     $0780                           ; DA10 8D 80 07                 ...
        lda     #$C0                            ; DA13 A9 C0                    ..
        sta     $0781                           ; DA15 8D 81 07                 ...
        ldy     #$3F                            ; DA18 A0 3F                    .?
        sty     $0782                           ; DA1A 8C 82 07                 ...
LDA1D:  lda     $0680,y                         ; DA1D B9 80 06                 ...
        sta     $0783,y                         ; DA20 99 83 07                 ...
        lda     #$00                            ; DA23 A9 00                    ..
        sta     $0680,y                         ; DA25 99 80 06                 ...
        dey                                     ; DA28 88                       .
        bpl     LDA1D                           ; DA29 10 F2                    ..
        sty     $07C3                           ; DA2B 8C C3 07                 ...
        sty     $19                             ; DA2E 84 19                    ..
LDA30:  rts                                     ; DA30 60                       `

; ----------------------------------------------------------------------------
LDA31:  lda     #$04                            ; DA31 A9 04                    ..
        sta     $10                             ; DA33 85 10                    ..
        lda     $2C                             ; DA35 A5 2C                    .,
        beq     LDA3B                           ; DA37 F0 02                    ..
        asl     $10                             ; DA39 06 10                    ..
LDA3B:  lda     $10                             ; DA3B A5 10                    ..
        ora     #$20                            ; DA3D 09 20                    . 
        sta     $10                             ; DA3F 85 10                    ..
        lda     $19                             ; DA41 A5 19                    ..
        ora     $1A                             ; DA43 05 1A                    ..
        bne     LDA30                           ; DA45 D0 E9                    ..
LDA47:  lda     $1E                             ; DA47 A5 1E                    ..
        beq     LDA30                           ; DA49 F0 E5                    ..
        cmp     #$40                            ; DA4B C9 40                    .@
        beq     LDA08                           ; DA4D F0 B9                    ..
        and     #$7F                            ; DA4F 29 7F                    ).
        sta     $1E                             ; DA51 85 1E                    ..
        ldy     $23                             ; DA53 A4 23                    .#
        jsr     screen_layout_ptr                           ; DA55 20 A3 D7                  ..
        lda     $1E                             ; DA58 A5 1E                    ..
        sta     $22                             ; DA5A 85 22                    ."
        pha                                     ; DA5C 48                       H
        and     #$07                            ; DA5D 29 07                    ).
        asl     a                               ; DA5F 0A                       .
        asl     a                               ; DA60 0A                       .
        sta     $0781                           ; DA61 8D 81 07                 ...
        lda     #$02                            ; DA64 A9 02                    ..
        sta     $0780                           ; DA66 8D 80 07                 ...
        pla                                     ; DA69 68                       h
        and     #$F8                            ; DA6A 29 F8                    ).
        asl     a                               ; DA6C 0A                       .
        rol     $0780                           ; DA6D 2E 80 07                 ...
        asl     a                               ; DA70 0A                       .
        rol     $0780                           ; DA71 2E 80 07                 ...
        asl     a                               ; DA74 0A                       .
        rol     $0780                           ; DA75 2E 80 07                 ...
        asl     a                               ; DA78 0A                       .
        rol     $0780                           ; DA79 2E 80 07                 ...
        ora     $0781                           ; DA7C 0D 81 07                 ...
        sta     $0781                           ; DA7F 8D 81 07                 ...
        clc                                     ; DA82 18                       .
        adc     #$20                            ; DA83 69 20                    i 
        sta     $0794                           ; DA85 8D 94 07                 ...
        adc     #$20                            ; DA88 69 20                    i 
        sta     $07A7                           ; DA8A 8D A7 07                 ...
        adc     #$20                            ; DA8D 69 20                    i 
        sta     $07BA                           ; DA8F 8D BA 07                 ...
        lda     $0780                           ; DA92 AD 80 07                 ...
        ora     $10                             ; DA95 05 10                    ..
        sta     $0780                           ; DA97 8D 80 07                 ...
        sta     $0793                           ; DA9A 8D 93 07                 ...
        sta     $07A6                           ; DA9D 8D A6 07                 ...
        sta     $07B9                           ; DAA0 8D B9 07                 ...
        lda     #$0F                            ; DAA3 A9 0F                    ..
        sta     $0782                           ; DAA5 8D 82 07                 ...
        sta     $0795                           ; DAA8 8D 95 07                 ...
        sta     $07A8                           ; DAAB 8D A8 07                 ...
        sta     $07BB                           ; DAAE 8D BB 07                 ...
LDAB1:  jsr     metatile_strip_decode                           ; DAB1 20 C0 D6                  ..
        lda     $22                             ; DAB4 A5 22                    ."
        and     #$03                            ; DAB6 29 03                    ).
        tax                                     ; DAB8 AA                       .
        ldy     LDAF8,x                         ; DAB9 BC F8 DA                 ...
        ldx     #$00                            ; DABC A2 00                    ..
LDABE:  lda     $05E0,x                         ; DABE BD E0 05                 ...
        sta     $0780,y                         ; DAC1 99 80 07                 ...
        iny                                     ; DAC4 C8                       .
        inx                                     ; DAC5 E8                       .
        txa                                     ; DAC6 8A                       .
        and     #$03                            ; DAC7 29 03                    ).
        bne     LDABE                           ; DAC9 D0 F3                    ..
        tya                                     ; DACB 98                       .
        clc                                     ; DACC 18                       .
        adc     #$0F                            ; DACD 69 0F                    i.
        pha                                     ; DACF 48                       H
        ldy     $22                             ; DAD0 A4 22                    ."
        lda     $10                             ; DAD2 A5 10                    ..
        sta     $0680,y                         ; DAD4 99 80 06                 ...
        pla                                     ; DAD7 68                       h
        tay                                     ; DAD8 A8                       .
        cpy     #$4C                            ; DAD9 C0 4C                    .L
        bcc     LDABE                           ; DADB 90 E1                    ..
        inc     $1E                             ; DADD E6 1E                    ..
        inc     $22                             ; DADF E6 22                    ."
        lda     $22                             ; DAE1 A5 22                    ."
        and     #$03                            ; DAE3 29 03                    ).
        bne     LDAB1                           ; DAE5 D0 CA                    ..
        lda     #$FF                            ; DAE7 A9 FF                    ..
        sta     $07CC                           ; DAE9 8D CC 07                 ...
        ldy     $22                             ; DAEC A4 22                    ."
        cpy     #$39                            ; DAEE C0 39                    .9
        bcc     LDAF5                           ; DAF0 90 03                    ..
        sta     $07A6                           ; DAF2 8D A6 07                 ...
LDAF5:  sta     $19                             ; DAF5 85 19                    ..
        rts                                     ; DAF7 60                       `

; ----------------------------------------------------------------------------
LDAF8:  .byte   $03                             ; DAF8 03                       .
        .byte   $07                             ; DAF9 07                       .
        .byte   $0B                             ; DAFA 0B                       .
        .byte   $0F                             ; DAFB 0F                       .
        lda     $F5                             ; DAFC A5 F5                    ..
        pha                                     ; DAFE 48                       H
        lda     $F6                             ; DAFF A5 F6                    ..
        pha                                     ; DB01 48                       H
        lda     #$3F                            ; DB02 A9 3F                    .?
        sta     $22                             ; DB04 85 22                    ."
LDB06:  lda     $10                             ; DB06 A5 10                    ..
        pha                                     ; DB08 48                       H
        jsr     LD95D                           ; DB09 20 5D D9                  ].
        pla                                     ; DB0C 68                       h
        sta     $10                             ; DB0D 85 10                    ..
        jsr     nametable_flush                           ; DB0F 20 98 C2                  ..
        dec     $22                             ; DB12 C6 22                    ."
        bpl     LDB06                           ; DB14 10 F0                    ..
        lda     #$00                            ; DB16 A9 00                    ..
        sta     $22                             ; DB18 85 22                    ."
        pla                                     ; DB1A 68                       h
        sta     $F6                             ; DB1B 85 F6                    ..
        pla                                     ; DB1D 68                       h
        sta     $F5                             ; DB1E 85 F5                    ..
        jmp     bank_load_shadow                ; DB20 4C 43 FF                 LC.

; ----------------------------------------------------------------------------
        lda     $F5                             ; DB23 A5 F5                    ..
        pha                                     ; DB25 48                       H
        lda     $F6                             ; DB26 A5 F6                    ..
        pha                                     ; DB28 48                       H
        lda     #$80                            ; DB29 A9 80                    ..
        sta     $1E                             ; DB2B 85 1E                    ..
LDB2D:  lda     $10                             ; DB2D A5 10                    ..
        pha                                     ; DB2F 48                       H
        jsr     LDA47                           ; DB30 20 47 DA                  G.
        pla                                     ; DB33 68                       h
        sta     $10                             ; DB34 85 10                    ..
        jsr     frame_wait                      ; DB36 20 22 FF                  ".
        lda     $1E                             ; DB39 A5 1E                    ..
        bne     LDB2D                           ; DB3B D0 F0                    ..
        pla                                     ; DB3D 68                       h
        sta     $F6                             ; DB3E 85 F6                    ..
        pla                                     ; DB40 68                       h
        sta     $F5                             ; DB41 85 F5                    ..
        jmp     bank_load_shadow                ; DB43 4C 43 FF                 LC.

; ----------------------------------------------------------------------------
; -----------------------------------------------------------------------------
; BACKGROUND SERVICE TASK — $DB46 (task 1, stack $AF)
; Permanent task: steps the 4-byte LFSR RNG (rng_state $E4-$E7) and
; runs bg_frame_service (HUD/palette upkeep; skipped while nametable
; buffers are busy) every frame.
; -----------------------------------------------------------------------------
bg_task_entry:
        ldx     #$AF                            ; DB46 A2 AF                    ..
        txs                                     ; DB48 9A                       .
bg_task_loop:  ldx     #$00                            ; DB49 A2 00                    ..
        ldy     #$04                            ; DB4B A0 04                    ..
        lda     $E4,x                           ; DB4D B5 E4                    ..
        and     #$02                            ; DB4F 29 02                    ).
        sta     L0000                           ; DB51 85 00                    ..
        lda     $E5,x                           ; DB53 B5 E5                    ..
        and     #$02                            ; DB55 29 02                    ).
        eor     L0000                           ; DB57 45 00                    E.
        clc                                     ; DB59 18                       .
        beq     LDB5D                           ; DB5A F0 01                    ..
        sec                                     ; DB5C 38                       8
LDB5D:  ror     $E4,x                           ; DB5D 76 E4                    v.
        inx                                     ; DB5F E8                       .
        dey                                     ; DB60 88                       .
        bne     LDB5D                           ; DB61 D0 FA                    ..
        jsr     bg_frame_service                           ; DB63 20 6C DB                  l.
        jsr     frame_wait                      ; DB66 20 22 FF                  ".
        jmp     bg_task_loop                           ; DB69 4C 49 DB                 LI.

; ----------------------------------------------------------------------------
bg_frame_service:  lda     $19                             ; DB6C A5 19                    ..
        ora     $1A                             ; DB6E 05 1A                    ..
        ora     $1B                             ; DB70 05 1B                    ..
        bne     LDBD0                           ; DB72 D0 5C                    .\
        lda     #$03                            ; DB74 A9 03                    ..
        sta     $AB                             ; DB76 85 AB                    ..
        lda     $18                             ; DB78 A5 18                    ..
        and     #$01                            ; DB7A 29 01                    ).
        sta     $01                             ; DB7C 85 01                    ..
        lda     #$00                            ; DB7E A9 00                    ..
        sta     $18                             ; DB80 85 18                    ..
LDB82:  ldx     $AB                             ; DB82 A6 AB                    ..
        lda     $05F0,x                         ; DB84 BD F0 05                 ...
        bpl     LDB8F                           ; DB87 10 06                    ..
        and     #$7F                            ; DB89 29 7F                    ).
        tay                                     ; DB8B A8                       .
        jsr     LDBD1                           ; DB8C 20 D1 DB                  ..
LDB8F:  dec     $AB                             ; DB8F C6 AB                    ..
        bpl     LDB82                           ; DB91 10 EF                    ..
        lda     $01                             ; DB93 A5 01                    ..
        sta     $18                             ; DB95 85 18                    ..
        lda     $05D0                           ; DB97 AD D0 05                 ...
        bpl     LDBD0                           ; DB9A 10 34                    .4
        and     #$7F                            ; DB9C 29 7F                    ).
        tax                                     ; DB9E AA                       .
        ldy     LDDB3,x                         ; DB9F BC B3 DD                 ...
        lda     $05D2                           ; DBA2 AD D2 05                 ...
        inc     $05D2                           ; DBA5 EE D2 05                 ...
        cmp     LDDBC,y                         ; DBA8 D9 BC DD                 ...
        bne     LDBD0                           ; DBAB D0 23                    .#
        lda     #$00                            ; DBAD A9 00                    ..
        sta     $05D2                           ; DBAF 8D D2 05                 ...
        lda     $05D1                           ; DBB2 AD D1 05                 ...
        inc     $05D1                           ; DBB5 EE D1 05                 ...
        cmp     LDDBB,y                         ; DBB8 D9 BB DD                 ...
        bne     LDBC2                           ; DBBB D0 05                    ..
        lda     #$00                            ; DBBD A9 00                    ..
        sta     $05D1                           ; DBBF 8D D1 05                 ...
LDBC2:  ldx     LDDBD,y                         ; DBC2 BE BD DD                 ...
        tya                                     ; DBC5 98                       .
        clc                                     ; DBC6 18                       .
        adc     $05D1                           ; DBC7 6D D1 05                 m..
        tay                                     ; DBCA A8                       .
        lda     LDDBE,y                         ; DBCB B9 BE DD                 ...
        sta     $EA,x                           ; DBCE 95 EA                    ..
LDBD0:  rts                                     ; DBD0 60                       `

; ----------------------------------------------------------------------------
LDBD1:  lda     LDD01,y                         ; DBD1 B9 01 DD                 ...
        tay                                     ; DBD4 A8                       .
        lda     $05F8,x                         ; DBD5 BD F8 05                 ...
        inc     $05F8,x                         ; DBD8 FE F8 05                 ...
        cmp     LDD22,y                         ; DBDB D9 22 DD                 .".
        bne     LDC1F                           ; DBDE D0 3F                    .?
        lda     #$00                            ; DBE0 A9 00                    ..
        sta     $05F8,x                         ; DBE2 9D F8 05                 ...
        lda     $05F4,x                         ; DBE5 BD F4 05                 ...
        inc     $05F4,x                         ; DBE8 FE F4 05                 ...
        cmp     LDD21,y                         ; DBEB D9 21 DD                 .!.
        bne     LDBF5                           ; DBEE D0 05                    ..
        lda     #$00                            ; DBF0 A9 00                    ..
        sta     $05F4,x                         ; DBF2 9D F4 05                 ...
LDBF5:  tya                                     ; DBF5 98                       .
        clc                                     ; DBF6 18                       .
        adc     $05F4,x                         ; DBF7 7D F4 05                 }..
        tax                                     ; DBFA AA                       .
        lda     LDD23,x                         ; DBFB BD 23 DD                 .#.
        beq     LDC20                           ; DBFE F0 20                    . 
        asl     a                               ; DC00 0A                       .
        adc     LDD23,x                         ; DC01 7D 23 DD                 }#.
        tax                                     ; DC04 AA                       .
        lda     $AB                             ; DC05 A5 AB                    ..
        asl     a                               ; DC07 0A                       .
        asl     a                               ; DC08 0A                       .
        tay                                     ; DC09 A8                       .
        lda     #$03                            ; DC0A A9 03                    ..
        sta     L0000                           ; DC0C 85 00                    ..
LDC0E:  lda     LDC26,x                         ; DC0E BD 26 DC                 .&.
        sta     $0601,y                         ; DC11 99 01 06                 ...
        sta     $0621,y                         ; DC14 99 21 06                 .!.
        iny                                     ; DC17 C8                       .
        inx                                     ; DC18 E8                       .
        dec     L0000                           ; DC19 C6 00                    ..
        bne     LDC0E                           ; DC1B D0 F1                    ..
        inc     $01                             ; DC1D E6 01                    ..
LDC1F:  rts                                     ; DC1F 60                       `

; ----------------------------------------------------------------------------
LDC20:  ldx     $AB                             ; DC20 A6 AB                    ..
        sta     $05F0,x                         ; DC22 9D F0 05                 ...
        rts                                     ; DC25 60                       `

; ----------------------------------------------------------------------------
LDC26:  brk                                     ; DC26 00                       .
        brk                                     ; DC27 00                       .
        brk                                     ; DC28 00                       .
        asl     $1B                             ; DC29 06 1B                    ..
        .byte   $0B                             ; DC2B 0B                       .
        asl     $1B,x                           ; DC2C 16 1B                    ..
        .byte   $0B                             ; DC2E 0B                       .
        rol     $1B                             ; DC2F 26 1B                    &.
        .byte   $0B                             ; DC31 0B                       .
        jsr     L1501                           ; DC32 20 01 15                  ..
        bmi     LDC73                           ; DC35 30 3C                    0<
        bit     $3030                           ; DC37 2C 30 30                 ,00
        .byte   $3C                             ; DC3A 3C                       <
        bmi     LDC6D                           ; DC3B 30 30                    00
        bmi     LDC5F                           ; DC3D 30 20                    0 
        ora     ($01,x)                         ; DC3F 01 01                    ..
        jsr     L111C                           ; DC41 20 1C 11                  ..
        jsr     L1C01                           ; DC44 20 01 1C                  ..
        jsr     L2511                           ; DC47 20 11 25                  .%
        .byte   $0F                             ; DC4A 0F                       .
        .byte   $14                             ; DC4B 14                       .
        .byte   $04                             ; DC4C 04                       .
        .byte   $17                             ; DC4D 17                       .
        .byte   $14                             ; DC4E 14                       .
        .byte   $04                             ; DC4F 04                       .
        .byte   $27                             ; DC50 27                       '
        .byte   $14                             ; DC51 14                       .
        .byte   $04                             ; DC52 04                       .
        and     #$19                            ; DC53 29 19                    ).
        ora     #$19                            ; DC55 09 19                    ..
        ora     #$29                            ; DC57 09 29                    .)
        ora     #$29                            ; DC59 09 29                    .)
        ora     $1120,y                         ; DC5B 19 20 11                 . .
        .byte   $01                             ; DC5E 01                       .
LDC5F:  brk                                     ; DC5F 00                       .
        brk                                     ; DC60 00                       .
        brk                                     ; DC61 00                       .
        brk                                     ; DC62 00                       .
        brk                                     ; DC63 00                       .
        brk                                     ; DC64 00                       .
        brk                                     ; DC65 00                       .
        brk                                     ; DC66 00                       .
        brk                                     ; DC67 00                       .
        brk                                     ; DC68 00                       .
        brk                                     ; DC69 00                       .
        brk                                     ; DC6A 00                       .
        brk                                     ; DC6B 00                       .
        brk                                     ; DC6C 00                       .
LDC6D:  brk                                     ; DC6D 00                       .
        brk                                     ; DC6E 00                       .
        brk                                     ; DC6F 00                       .
        brk                                     ; DC70 00                       .
        brk                                     ; DC71 00                       .
        brk                                     ; DC72 00                       .
LDC73:  brk                                     ; DC73 00                       .
        brk                                     ; DC74 00                       .
        brk                                     ; DC75 00                       .
        brk                                     ; DC76 00                       .
        brk                                     ; DC77 00                       .
        brk                                     ; DC78 00                       .
        brk                                     ; DC79 00                       .
        brk                                     ; DC7A 00                       .
        brk                                     ; DC7B 00                       .
        brk                                     ; DC7C 00                       .
        brk                                     ; DC7D 00                       .
        brk                                     ; DC7E 00                       .
        brk                                     ; DC7F 00                       .
        jsr     L1C2C                           ; DC80 20 2C 1C                  ,.
        bit     L1C20                           ; DC83 2C 20 1C                 , .
        jsr     L1110                           ; DC86 20 10 11                  ..
        bpl     LDC8B                           ; DC89 10 00                    ..
LDC8B:  ora     (L0000,x)                       ; DC8B 01 00                    ..
        .byte   $0F                             ; DC8D 0F                       .
        .byte   $0F                             ; DC8E 0F                       .
        jsr     L211C                           ; DC8F 20 1C 21                  .!
        bpl     LDCA0                           ; DC92 10 0C                    ..
        ora     (L0000),y                       ; DC94 11 00                    ..
        .byte   $0F                             ; DC96 0F                       .
        ora     ($10,x)                         ; DC97 01 10                    ..
        .byte   $1C                             ; DC99 1C                       .
        .byte   $0C                             ; DC9A 0C                       .
        brk                                     ; DC9B 00                       .
        .byte   $0C                             ; DC9C 0C                       .
        .byte   $0F                             ; DC9D 0F                       .
        .byte   $0F                             ; DC9E 0F                       .
        .byte   $0F                             ; DC9F 0F                       .
LDCA0:  .byte   $0F                             ; DCA0 0F                       .
        and     ($11,x)                         ; DCA1 21 11                    !.
        ora     ($11,x)                         ; DCA3 01 11                    ..
        ora     ($21,x)                         ; DCA5 01 21                    .!
        ora     ($21,x)                         ; DCA7 01 21                    .!
        ora     ($11),y                         ; DCA9 11 11                    ..
        and     ($21),y                         ; DCAB 31 21                    1!
        and     ($21),y                         ; DCAD 31 21                    1!
        ora     ($21),y                         ; DCAF 11 21                    .!
        ora     ($31),y                         ; DCB1 11 31                    .1
        .byte   $13                             ; DCB3 13                       .
        ora     ($0F,x)                         ; DCB4 01 0F                    ..
        .byte   $13                             ; DCB6 13                       .
        ora     ($0A,x)                         ; DCB7 01 0A                    ..
        rol     $1B,x                           ; DCB9 36 1B                    6.
        .byte   $0B                             ; DCBB 0B                       .
        .byte   $37                             ; DCBC 37                       7
        clc                                     ; DCBD 18                       .
        php                                     ; DCBE 08                       .
        .byte   $27                             ; DCBF 27                       '
        clc                                     ; DCC0 18                       .
        php                                     ; DCC1 08                       .
        .byte   $07                             ; DCC2 07                       .
        clc                                     ; DCC3 18                       .
        php                                     ; DCC4 08                       .
        .byte   $13                             ; DCC5 13                       .
        ora     ($1A,x)                         ; DCC6 01 1A                    ..
        .byte   $0F                             ; DCC8 0F                       .
        and     ($09,x)                         ; DCC9 21 09                    !.
        asl     $0F                             ; DCCB 06 0F                    ..
        and     #$30                            ; DCCD 29 30                    )0
        brk                                     ; DCCF 00                       .
        ora     $30                             ; DCD0 05 30                    .0
        brk                                     ; DCD2 00                       .
        .byte   $0F                             ; DCD3 0F                       .
        and     ($1C),y                         ; DCD4 31 1C                    1.
        .byte   $27                             ; DCD6 27                       '
        and     ($1C),y                         ; DCD7 31 1C                    1.
        .byte   $0F                             ; DCD9 0F                       .
        rol     $11                             ; DCDA 26 11                    &.
        .byte   $0F                             ; DCDC 0F                       .
        .byte   $27                             ; DCDD 27                       '
        rol     $06                             ; DCDE 26 06                    &.
        rol     $06                             ; DCE0 26 06                    &.
        .byte   $27                             ; DCE2 27                       '
        asl     $27                             ; DCE3 06 27                    .'
        rol     $3C                             ; DCE5 26 3C                    &<
        bit     $2020                           ; DCE7 2C 20 20                 ,  
        .byte   $3C                             ; DCEA 3C                       <
        bit     $202C                           ; DCEB 2C 2C 20                 ,, 
        .byte   $3C                             ; DCEE 3C                       <
        .byte   $1C                             ; DCEF 1C                       .
        bpl     LDD1E                           ; DCF0 10 2C                    .,
        bit     $101C                           ; DCF2 2C 1C 10                 ,..
        bpl     LDD23                           ; DCF5 10 2C                    .,
        .byte   $1C                             ; DCF7 1C                       .
        and     L0004                           ; DCF8 25 04                    %.
        .byte   $0F                             ; DCFA 0F                       .
        .byte   $04                             ; DCFB 04                       .
        .byte   $0F                             ; DCFC 0F                       .
        and     $0F                             ; DCFD 25 0F                    %.
LDCFF:  and     L0004                           ; DCFF 25 04                    %.
LDD01:  brk                                     ; DD01 00                       .
        asl     $0C                             ; DD02 06 0C                    ..
        .byte   $12                             ; DD04 12                       .
        clc                                     ; DD05 18                       .
        asl     $1E1E,x                         ; DD06 1E 1E 1E                 ...
        asl     $221E,x                         ; DD09 1E 1E 22                 .."
        and     #$30                            ; DD0C 29 30                    )0
        rol     $3D,x                           ; DD0E 36 3D                    6=
        .byte   $44                             ; DD10 44                       D
        lsr     a                               ; DD11 4A                       J
        .byte   $4F                             ; DD12 4F                       O
        .byte   $54                             ; DD13 54                       T
        .byte   $5A                             ; DD14 5A                       Z
        .byte   $5F                             ; DD15 5F                       _
        adc     $69                             ; DD16 65 69                    ei
        adc     $7873                           ; DD18 6D 73 78                 msx
        adc     $8782,x                         ; DD1B 7D 82 87                 }..
LDD1E:  sty     $9292                           ; DD1E 8C 92 92                 ...
LDD21:  .byte   $03                             ; DD21 03                       .
LDD22:  php                                     ; DD22 08                       .
LDD23:  ora     ($02,x)                         ; DD23 01 02                    ..
        .byte   $03                             ; DD25 03                       .
        and     ($03),y                         ; DD26 31 03                    1.
        php                                     ; DD28 08                       .
        ora     $06                             ; DD29 05 06                    ..
        .byte   $07                             ; DD2B 07                       .
        asl     $03                             ; DD2C 06 03                    ..
        php                                     ; DD2E 08                       .
        php                                     ; DD2F 08                       .
        .byte   $12                             ; DD30 12                       .
        ora     #$0A                            ; DD31 09 0A                    ..
        .byte   $03                             ; DD33 03                       .
        php                                     ; DD34 08                       .
        .byte   $0C                             ; DD35 0C                       .
        ora     $0D0E                           ; DD36 0D 0E 0D                 ...
        .byte   $03                             ; DD39 03                       .
        php                                     ; DD3A 08                       .
        ora     #$0A                            ; DD3B 09 0A                    ..
        php                                     ; DD3D 08                       .
        .byte   $12                             ; DD3E 12                       .
        ora     ($0B,x)                         ; DD3F 01 0B                    ..
        asl     $041F,x                         ; DD41 1E 1F 04                 ...
        php                                     ; DD44 08                       .
        jsr     L2221                           ; DD45 20 21 22                  !"
        plp                                     ; DD48 28                       (
        brk                                     ; DD49 00                       .
        .byte   $04                             ; DD4A 04                       .
        php                                     ; DD4B 08                       .
        .byte   $23                             ; DD4C 23                       #
        bit     $25                             ; DD4D 24 25                    $%
        plp                                     ; DD4F 28                       (
        brk                                     ; DD50 00                       .
        .byte   $03                             ; DD51 03                       .
        php                                     ; DD52 08                       .
        rol     $27                             ; DD53 26 27                    &'
        plp                                     ; DD55 28                       (
        brk                                     ; DD56 00                       .
        .byte   $04                             ; DD57 04                       .
        php                                     ; DD58 08                       .
        plp                                     ; DD59 28                       (
        .byte   $22                             ; DD5A 22                       "
        and     (L0020,x)                       ; DD5B 21 20                    ! 
        brk                                     ; DD5D 00                       .
        .byte   $04                             ; DD5E 04                       .
        php                                     ; DD5F 08                       .
        plp                                     ; DD60 28                       (
        and     $24                             ; DD61 25 24                    %$
        .byte   $23                             ; DD63 23                       #
        brk                                     ; DD64 00                       .
        .byte   $03                             ; DD65 03                       .
        php                                     ; DD66 08                       .
        plp                                     ; DD67 28                       (
        .byte   $27                             ; DD68 27                       '
        rol     L0000                           ; DD69 26 00                    &.
        .byte   $02                             ; DD6B 02                       .
        asl     $29                             ; DD6C 06 29                    .)
        rol     a                               ; DD6E 2A                       *
        .byte   $2B                             ; DD6F 2B                       +
        .byte   $02                             ; DD70 02                       .
        .byte   $04                             ; DD71 04                       .
        bit     $2E2D                           ; DD72 2C 2D 2E                 ,-.
        .byte   $03                             ; DD75 03                       .
        php                                     ; DD76 08                       .
        .byte   $2F                             ; DD77 2F                       /
        bmi     LDDAF                           ; DD78 30 35                    05
        bmi     LDD7E                           ; DD7A 30 02                    0.
        php                                     ; DD7C 08                       .
        .byte   $32                             ; DD7D 32                       2
LDD7E:  .byte   $33                             ; DD7E 33                       3
        .byte   $34                             ; DD7F 34                       4
        .byte   $03                             ; DD80 03                       .
        php                                     ; DD81 08                       .
        .byte   $04                             ; DD82 04                       .
        .byte   $0B                             ; DD83 0B                       .
        ora     #$0A                            ; DD84 09 0A                    ..
        ora     ($08,x)                         ; DD86 01 08                    ..
        sec                                     ; DD88 38                       8
        and     $0801,y                         ; DD89 39 01 08                 9..
        .byte   $3A                             ; DD8C 3A                       :
        .byte   $3B                             ; DD8D 3B                       ;
        .byte   $03                             ; DD8E 03                       .
        php                                     ; DD8F 08                       .
        ora     #$0A                            ; DD90 09 0A                    ..
        .byte   $04                             ; DD92 04                       .
        .byte   $0B                             ; DD93 0B                       .
        .byte   $02                             ; DD94 02                       .
        php                                     ; DD95 08                       .
        .byte   $0F                             ; DD96 0F                       .
        bpl     LDDAA                           ; DD97 10 11                    ..
        .byte   $02                             ; DD99 02                       .
        php                                     ; DD9A 08                       .
        rol     $37,x                           ; DD9B 36 37                    67
        .byte   $3C                             ; DD9D 3C                       <
        .byte   $02                             ; DD9E 02                       .
        php                                     ; DD9F 08                       .
        and     $3F3E,x                         ; DDA0 3D 3E 3F                 =>?
        .byte   $02                             ; DDA3 02                       .
        php                                     ; DDA4 08                       .
        rti                                     ; DDA5 40                       @

; ----------------------------------------------------------------------------
        eor     ($42,x)                         ; DDA6 41 42                    AB
        .byte   $02                             ; DDA8 02                       .
        php                                     ; DDA9 08                       .
LDDAA:  .byte   $43                             ; DDAA 43                       C
        .byte   $44                             ; DDAB 44                       D
        eor     $03                             ; DDAC 45 03                    E.
        php                                     ; DDAE 08                       .
LDDAF:  lsr     $47                             ; DDAF 46 47                    FG
        pha                                     ; DDB1 48                       H
        .byte   $47                             ; DDB2 47                       G
LDDB3:  brk                                     ; DDB3 00                       .
        asl     $0B                             ; DDB4 06 0B                    ..
        ora     ($16),y                         ; DDB6 11 16                    ..
        .byte   $1C                             ; DDB8 1C                       .
        and     ($26,x)                         ; DDB9 21 26                    !&
LDDBB:  .byte   $02                             ; DDBB 02                       .
LDDBC:  .byte   $04                             ; DDBC 04                       .
LDDBD:  .byte   $01                             ; DDBD 01                       .
LDDBE:  stx     LFEFC                           ; DDBE 8E FC FE                 ...
        ora     (L0004,x)                       ; DDC1 01 04                    ..
        ora     ($8E,x)                         ; DDC3 01 8E                    ..
        .byte   $FC                             ; DDC5 FC                       .
        .byte   $02                             ; DDC6 02                       .
        .byte   $04                             ; DDC7 04                       .
        brk                                     ; DDC8 00                       .
        ldy     $70                             ; DDC9 A4 70                    .p
        .byte   $72                             ; DDCB 72                       r
        ora     (L0004,x)                       ; DDCC 01 04                    ..
        brk                                     ; DDCE 00                       .
        bcs     LDE3D                           ; DDCF B0 6C                    .l
        .byte   $02                             ; DDD1 02                       .
        .byte   $04                             ; DDD2 04                       .
        brk                                     ; DDD3 00                       .
        ldy     $70                             ; DDD4 A4 70                    .p
        .byte   $72                             ; DDD6 72                       r
        ora     ($10,x)                         ; DDD7 01 10                    ..
        ora     ($9A,x)                         ; DDD9 01 9A                    ..
        ror     $0801                           ; DDDB 6E 01 08                 n..
        ora     ($EE,x)                         ; DDDE 01 EE                    ..
        ror     a                               ; DDE0 6A                       j
        .byte   $03                             ; DDE1 03                       .
        ora     L0000                           ; DDE2 05 00                    ..
        .byte   $80                             ; DDE4 80                       .
        .byte   $F4                             ; DDE5 F4                       .
        inc     $F2,x                           ; DDE6 F6 F2                    ..
        ldx     #$8F                            ; DDE8 A2 8F                    ..
        txs                                     ; DDEA 9A                       .
        lda     #$40                            ; DDEB A9 40                    .@
        sta     $A1                             ; DDED 85 A1                    ..
LDDEF:  cli                                     ; DDEF 58                       X
        lda     #$01                            ; DDF0 A9 01                    ..
        sta     $96                             ; DDF2 85 96                    ..
        lda     #$DB                            ; DDF4 A9 DB                    ..
        sta     $94                             ; DDF6 85 94                    ..
        lda     #$46                            ; DDF8 A9 46                    .F
        sta     L0093                           ; DDFA 85 93                    ..
        lda     #$01                            ; DDFC A9 01                    ..
        jsr     task_create                     ; DDFE 20 F3 FE                  ..
        lda     #$00                            ; DE01 A9 00                    ..
        sta     $F9                             ; DE03 85 F9                    ..
        sta     $29                             ; DE05 85 29                    .)
        sta     $0330                           ; DE07 8D 30 03                 .0.
        sta     $0348                           ; DE0A 8D 48 03                 .H.
        sta     $0378                           ; DE0D 8D 78 03                 .x.
        sta     $0390                           ; DE10 8D 90 03                 ...
        sta     $95                             ; DE13 85 95                    ..
        lda     #$17                            ; DE15 A9 17                    ..
        sta     $F5                             ; DE17 85 F5                    ..
        lda     #$0C                            ; DE19 A9 0C                    ..
        sta     $F6                             ; DE1B 85 F6                    ..
        jsr     bank_load_shadow                ; DE1D 20 43 FF                  C.
        jsr     L8000                           ; DE20 20 00 80                  ..
        ldx     #$00                            ; DE23 A2 00                    ..
        stx     $14                             ; DE25 86 14                    ..
        stx     $15                             ; DE27 86 15                    ..
        stx     $16                             ; DE29 86 16                    ..
        stx     $17                             ; DE2B 86 17                    ..
        lda     #$1A                            ; DE2D A9 1A                    ..
        jsr     entity_set_subtype                           ; DE2F 20 98 EA                  ..
        jsr     entity_stop_y                           ; DE32 20 1E EA                  ..
        lda     #$01                            ; DE35 A9 01                    ..
        sta     $0300                           ; DE37 8D 00 03                 ...
        lda     #$80                            ; DE3A A9 80                    ..
        .byte   $8D                             ; DE3C 8D                       .
LDE3D:  plp                                     ; DE3D 28                       (
        ora     $8D                             ; DE3E 05 8D                    ..
        bmi     LDE45                           ; DE40 30 03                    0.
        sta     $0378                           ; DE42 8D 78 03                 .x.
LDE45:  jsr     stage_load                           ; DE45 20 11 D3                  ..
        lda     $BD                             ; DE48 A5 BD                    ..
        ora     #$80                            ; DE4A 09 80                    ..
        sta     $BD                             ; DE4C 85 BD                    ..
        lda     $BE                             ; DE4E A5 BE                    ..
        ora     #$80                            ; DE50 09 80                    ..
        sta     $BE                             ; DE52 85 BE                    ..
        lda     #$80                            ; DE54 A9 80                    ..
        sta     $2D                             ; DE56 85 2D                    .-
        lda     #$9C                            ; DE58 A9 9C                    ..
        sta     $B0                             ; DE5A 85 B0                    ..
        lda     #$08                            ; DE5C A9 08                    ..
        sta     $30                             ; DE5E 85 30                    .0
        lda     #$DE                            ; DE60 A9 DE                    ..
        sta     $94                             ; DE62 85 94                    ..
        lda     #$70                            ; DE64 A9 70                    .p
        sta     L0093                           ; DE66 85 93                    ..
        lda     #$00                            ; DE68 A9 00                    ..
        jsr     task_create                     ; DE6A 20 F3 FE                  ..
        jmp     task_exit                       ; DE6D 4C 0B FF                 L..

; ----------------------------------------------------------------------------
        ldx     #$DF                            ; DE70 A2 DF                    ..
        txs                                     ; DE72 9A                       .
LDE73:  lda     $15                             ; DE73 A5 15                    ..
        and     #$02                            ; DE75 29 02                    ).
        beq     LDE7F                           ; DE77 F0 06                    ..
        lda     $A0                             ; DE79 A5 A0                    ..
        eor     #$01                            ; DE7B 49 01                    I.
        sta     $A0                             ; DE7D 85 A0                    ..
LDE7F:  lda     $A0                             ; DE7F A5 A0                    ..
        beq     LDE89                           ; DE81 F0 06                    ..
        jsr     frame_wait                      ; DE83 20 22 FF                  ".
        jmp     LDE73                           ; DE86 4C 73 DE                 Ls.

; ----------------------------------------------------------------------------
LDE89:  lda     $30                             ; DE89 A5 30                    .0
        cmp     #$04                            ; DE8B C9 04                    ..
        bcs     LDEAC                           ; DE8D B0 1D                    ..
        lda     $54                             ; DE8F A5 54                    .T
        bne     LDEAC                           ; DE91 D0 19                    ..
        lda     $14                             ; DE93 A5 14                    ..
        and     #$10                            ; DE95 29 10                    ).
        beq     LDEAC                           ; DE97 F0 13                    ..
        lda     #$01                            ; DE99 A9 01                    ..
        sta     $F5                             ; DE9B 85 F5                    ..
        lda     #$08                            ; DE9D A9 08                    ..
        sta     $F6                             ; DE9F 85 F6                    ..
        jsr     bank_load_shadow                ; DEA1 20 43 FF                  C.
        lda     #$29                            ; DEA4 A9 29                    .)
        jsr     queue_sound                           ; DEA6 20 5D EC                  ].
        jsr     L8000                           ; DEA9 20 00 80                  ..
LDEAC:  lda     #$1B                            ; DEAC A9 1B                    ..
        jsr     bank_load_pair                  ; DEAE 20 3D FF                  =.
        jsr     L8000                           ; DEB1 20 00 80                  ..
        lda     #$1C                            ; DEB4 A9 1C                    ..
        jsr     bank_load_pair                  ; DEB6 20 3D FF                  =.
        jsr     L8000                           ; DEB9 20 00 80                  ..
        lda     $26                             ; DEBC A5 26                    .&
        sta     $F6                             ; DEBE 85 F6                    ..
        jsr     bank_load_shadow                ; DEC0 20 43 FF                  C.
        jsr     LC9DD                           ; DEC3 20 DD C9                  ..
        lda     #$1B                            ; DEC6 A9 1B                    ..
        sta     $F5                             ; DEC8 85 F5                    ..
        lda     $26                             ; DECA A5 26                    .&
        sta     $F6                             ; DECC 85 F6                    ..
        jsr     bank_load_shadow                ; DECE 20 43 FF                  C.
        jsr     L988A                           ; DED1 20 8A 98                  ..
        jsr     LDA31                           ; DED4 20 31 DA                  1.
        lda     $FC                             ; DED7 A5 FC                    ..
        sta     $44                             ; DED9 85 44                    .D
        lda     $FA                             ; DEDB A5 FA                    ..
        sta     $45                             ; DEDD 85 45                    .E
        lda     $0378                           ; DEDF AD 78 03                 .x.
        sta     $3E                             ; DEE2 85 3E                    .>
        lda     $0390                           ; DEE4 AD 90 03                 ...
        sta     $3F                             ; DEE7 85 3F                    .?
        lda     $0330                           ; DEE9 AD 30 03                 .0.
        sta     $3C                             ; DEEC 85 3C                    .<
        lda     $0348                           ; DEEE AD 48 03                 .H.
        sta     $3D                             ; DEF1 85 3D                    .=
        cmp     $69                             ; DEF3 C5 69                    .i
        bcc     LDEF9                           ; DEF5 90 02                    ..
        sta     $69                             ; DEF7 85 69                    .i
LDEF9:  lda     $26                             ; DEF9 A5 26                    .&
        bne     LDF1A                           ; DEFB D0 1D                    ..
        lda     $FC                             ; DEFD A5 FC                    ..
        lsr     a                               ; DEFF 4A                       J
        and     #$03                            ; DF00 29 03                    ).
        tay                                     ; DF02 A8                       .
        lda     $29                             ; DF03 A5 29                    .)
        and     #$1F                            ; DF05 29 1F                    ).
        tax                                     ; DF07 AA                       .
        lda     LDF53,x                         ; DF08 BD 53 DF                 .S.
        bne     LDF15                           ; DF0B D0 08                    ..
        lda     $9D                             ; DF0D A5 9D                    ..
        lsr     a                               ; DF0F 4A                       J
        lsr     a                               ; DF10 4A                       J
        lsr     a                               ; DF11 4A                       J
        and     #$03                            ; DF12 29 03                    ).
        tay                                     ; DF14 A8                       .
LDF15:  lda     LDF4F,y                         ; DF15 B9 4F DF                 .O.
        sta     $EA                             ; DF18 85 EA                    ..
LDF1A:  lda     #$04                            ; DF1A A9 04                    ..
        sta     $9F                             ; DF1C 85 9F                    ..
        jsr     oam_clear                           ; DF1E 20 8F C3                  ..
        jsr     entity_render_all                           ; DF21 20 5E DF                  ^.
        lda     #$00                            ; DF24 A9 00                    ..
        sta     $95                             ; DF26 85 95                    ..
        sta     $73                             ; DF28 85 73                    .s
        lda     $15                             ; DF2A A5 15                    ..
        and     #$01                            ; DF2C 29 01                    ).
        beq     LDF47                           ; DF2E F0 17                    ..
        lda     $EC                             ; DF30 A5 EC                    ..
        pha                                     ; DF32 48                       H
        lda     $ED                             ; DF33 A5 ED                    ..
        pha                                     ; DF35 48                       H
        lda     #$C2                            ; DF36 A9 C2                    ..
        sta     $EC                             ; DF38 85 EC                    ..
        lda     #$C3                            ; DF3A A9 C3                    ..
        sta     $ED                             ; DF3C 85 ED                    ..
        jsr     LE4A6                           ; DF3E 20 A6 E4                  ..
        pla                                     ; DF41 68                       h
        sta     $ED                             ; DF42 85 ED                    ..
        pla                                     ; DF44 68                       h
        sta     $EC                             ; DF45 85 EC                    ..
LDF47:  jsr     frame_wait                      ; DF47 20 22 FF                  ".
        inc     $95                             ; DF4A E6 95                    ..
        jmp     LDE73                           ; DF4C 4C 73 DE                 Ls.

; ----------------------------------------------------------------------------
LDF4F:  .byte   $80                             ; DF4F 80                       .
        .byte   $F4                             ; DF50 F4                       .
        inc     $F2,x                           ; DF51 F6 F2                    ..
LDF53:  brk                                     ; DF53 00                       .
        brk                                     ; DF54 00                       .
LDF55:  .byte   $FF                             ; DF55 FF                       .
        .byte   $FF                             ; DF56 FF                       .
        brk                                     ; DF57 00                       .
        brk                                     ; DF58 00                       .
        brk                                     ; DF59 00                       .
        brk                                     ; DF5A 00                       .
        brk                                     ; DF5B 00                       .
        brk                                     ; DF5C 00                       .
        brk                                     ; DF5D 00                       .
entity_render_all:  lda     #$FF                            ; DF5E A9 FF                    ..
        sta     $EC                             ; DF60 85 EC                    ..
        sta     $EE                             ; DF62 85 EE                    ..
        sta     $EF                             ; DF64 85 EF                    ..
        lda     $74                             ; DF66 A5 74                    .t
        beq     LDF71                           ; DF68 F0 07                    ..
        jsr     LE2E7                           ; DF6A 20 E7 E2                  ..
        lda     #$28                            ; DF6D A9 28                    .(
        sta     $EE                             ; DF6F 85 EE                    ..
LDF71:  inc     $9D                             ; DF71 E6 9D                    ..
        lda     $9D                             ; DF73 A5 9D                    ..
LDF75:  lsr     a                               ; DF75 4A                       J
        bcs     LDF91                           ; DF76 B0 19                    ..
        jsr     LE260                           ; DF78 20 60 E2                  `.
        ldx     #$00                            ; DF7B A2 00                    ..
        stx     $9E                             ; DF7D 86 9E                    ..
LDF7F:  lda     $0300,x                         ; DF7F BD 00 03                 ...
        beq     LDF87                           ; DF82 F0 03                    ..
        jsr     entity_render_one                           ; DF84 20 C3 DF                  ..
LDF87:  inc     $9E                             ; DF87 E6 9E                    ..
        ldx     $9E                             ; DF89 A6 9E                    ..
        cpx     #$18                            ; DF8B E0 18                    ..
        bne     LDF7F                           ; DF8D D0 F0                    ..
        beq     LDFB8                           ; DF8F F0 27                    .'
LDF91:  ldx     $56                             ; DF91 A6 56                    .V
        lda     $0300,x                         ; DF93 BD 00 03                 ...
        pha                                     ; DF96 48                       H
        cmp     #$6E                            ; DF97 C9 6E                    .n
        bne     LDF9E                           ; DF99 D0 03                    ..
        .byte   $20                             ; DF9B 20                        
        rts                                     ; DF9C 60                       `

; ----------------------------------------------------------------------------
LDF9D:  .byte   $E2                             ; DF9D E2                       .
LDF9E:  ldx     #$17                            ; DF9E A2 17                    ..
        stx     $9E                             ; DFA0 86 9E                    ..
LDFA2:  lda     $0300,x                         ; DFA2 BD 00 03                 ...
        beq     LDFAA                           ; DFA5 F0 03                    ..
        jsr     entity_render_one                           ; DFA7 20 C3 DF                  ..
LDFAA:  dec     $9E                             ; DFAA C6 9E                    ..
        ldx     $9E                             ; DFAC A6 9E                    ..
        bpl     LDFA2                           ; DFAE 10 F2                    ..
        pla                                     ; DFB0 68                       h
        cmp     #$6E                            ; DFB1 C9 6E                    .n
        beq     LDFB8                           ; DFB3 F0 03                    ..
        jsr     LE270                           ; DFB5 20 70 E2                  p.
LDFB8:  lda     $EF                             ; DFB8 A5 EF                    ..
        bpl     LDFC2                           ; DFBA 10 06                    ..
        lda     $EE                             ; DFBC A5 EE                    ..
        sta     $EF                             ; DFBE 85 EF                    ..
        inc     $EF                             ; DFC0 E6 EF                    ..
LDFC2:  rts                                     ; DFC2 60                       `

; ----------------------------------------------------------------------------
; Per-entity: offscreen/despawn policy (types $4A/$4B/$78/$AB/$BA are
; exempt), player fall-death (state 7 + sound $1D; gravity_flip-aware),
; then entity_render_visible: anim bank from anim_bank_tbl[type],
; descriptor from $8600/$8700[sub_type] in that bank, OAM build.
entity_render_one:  lda     $0528,x                         ; DFC3 BD 28 05                 .(.
        and     #$7F                            ; DFC6 29 7F                    ).
        sta     $0528,x                         ; DFC8 9D 28 05                 .(.
        lda     $0330,x                         ; DFCB BD 30 03                 .0.
        sec                                     ; DFCE 38                       8
        sbc     $FC                             ; DFCF E5 FC                    ..
        sta     $13                             ; DFD1 85 13                    ..
        lda     $0348,x                         ; DFD3 BD 48 03                 .H.
        sbc     $F9                             ; DFD6 E5 F9                    ..
        beq     LDFF9                           ; DFD8 F0 1F                    ..
        lda     $0528,x                         ; DFDA BD 28 05                 .(.
        and     #$08                            ; DFDD 29 08                    ).
        beq     LE057                           ; DFDF F0 76                    .v
        lda     $13                             ; DFE1 A5 13                    ..
        bcs     LDFE9                           ; DFE3 B0 04                    ..
        eor     #$FF                            ; DFE5 49 FF                    I.
        adc     #$01                            ; DFE7 69 01                    i.
LDFE9:  cmp     #$30                            ; DFE9 C9 30                    .0
        bcs     LE017                           ; DFEB B0 2A                    .*
        lda     $0390,x                         ; DFED BD 90 03                 ...
        beq     LDFF6                           ; DFF0 F0 04                    ..
        bpl     LE017                           ; DFF2 10 23                    .#
        bmi     LE00D                           ; DFF4 30 17                    0.
LDFF6:  jmp     entity_render_visible                           ; DFF6 4C 8F E0                 L..

; ----------------------------------------------------------------------------
LDFF9:  lda     $0378,x                         ; DFF9 BD 78 03                 .x.
        sta     $12                             ; DFFC 85 12                    ..
        .byte   $BD                             ; DFFE BD                       .
        .byte   $90                             ; DFFF 90                       .
LE000:  .byte   $03                             ; E000 03                       .
LE001:  beq     LE082                           ; E001 F0 7F                    ..
        bpl     LE017                           ; E003 10 12                    ..
        cpx     #$00                            ; E005 E0 00                    ..
        bne     LE00D                           ; E007 D0 04                    ..
        lda     $AF                             ; E009 A5 AF                    ..
        bne     LE01F                           ; E00B D0 12                    ..
LE00D:  lda     $12                             ; E00D A5 12                    ..
        cmp     #$80                            ; E00F C9 80                    ..
        bcs     entity_render_visible                           ; E011 B0 7C                    .|
        cpx     #$00                            ; E013 E0 00                    ..
        beq     entity_render_visible                           ; E015 F0 78                    .x
LE017:  cpx     #$00                            ; E017 E0 00                    ..
        bne     LE057                           ; E019 D0 3C                    .<
        lda     $AF                             ; E01B A5 AF                    ..
        bne     LE08E                           ; E01D D0 6F                    .o
LE01F:  lda     $17                             ; E01F A5 17                    ..
        and     #$40                            ; E021 29 40                    )@
        bne     LE042                           ; E023 D0 1D                    ..
        lda     #$07                            ; E025 A9 07                    ..
        cmp     $30                             ; E027 C5 30                    .0
        beq     LE08E                           ; E029 F0 63                    .c
        sta     $30                             ; E02B 85 30                    .0
        lda     #$2C                            ; E02D A9 2C                    .,
        sta     $0468                           ; E02F 8D 68 04                 .h.
        lda     #$01                            ; E032 A9 01                    ..
        sta     $0480                           ; E034 8D 80 04                 ...
        lda     #$F0                            ; E037 A9 F0                    ..
        jsr     queue_sound_param                           ; E039 20 5B EC                  [.
        lda     #$1D                            ; E03C A9 1D                    ..
        jsr     queue_sound                           ; E03E 20 5D EC                  ].
        rts                                     ; E041 60                       `

; ----------------------------------------------------------------------------
LE042:  lda     #$00                            ; E042 A9 00                    ..
        sta     $03D8                           ; E044 8D D8 03                 ...
        lda     $AF                             ; E047 A5 AF                    ..
        bne     LE051                           ; E049 D0 06                    ..
        lda     #$0C                            ; E04B A9 0C                    ..
        sta     $03F0                           ; E04D 8D F0 03                 ...
        rts                                     ; E050 60                       `

; ----------------------------------------------------------------------------
LE051:  lda     #$F4                            ; E051 A9 F4                    ..
        sta     $03F0                           ; E053 8D F0 03                 ...
        rts                                     ; E056 60                       `

; ----------------------------------------------------------------------------
LE057:  lda     $0300,x                         ; E057 BD 00 03                 ...
        cmp     #$4A                            ; E05A C9 4A                    .J
        beq     entity_render_visible                           ; E05C F0 31                    .1
        cmp     #$4B                            ; E05E C9 4B                    .K
        beq     entity_render_visible                           ; E060 F0 2D                    .-
        cmp     #$78                            ; E062 C9 78                    .x
        beq     entity_render_visible                           ; E064 F0 29                    .)
        cmp     #$AB                            ; E066 C9 AB                    ..
        beq     entity_render_visible                           ; E068 F0 25                    .%
        cmp     #$BA                            ; E06A C9 BA                    ..
        beq     entity_render_visible                           ; E06C F0 21                    .!
entity_deactivate:
        lda     #$00                            ; E06E A9 00                    ..
        sta     $05A0,x                         ; E070 9D A0 05                 ...
        sta     $0300,x                         ; E073 9D 00 03                 ...
        sta     $05B8,x                         ; E076 9D B8 05                 ...
        sta     $0450,x                         ; E079 9D 50 04                 .P.
        lda     #$FF                            ; E07C A9 FF                    ..
        sta     $0438,x                         ; E07E 9D 38 04                 .8.
        rts                                     ; E081 60                       `

; ----------------------------------------------------------------------------
LE082:  lda     $0528,x                         ; E082 BD 28 05                 .(.
        ora     #$80                            ; E085 09 80                    ..
        sta     $0528,x                         ; E087 9D 28 05                 .(.
        and     #$04                            ; E08A 29 04                    ).
        beq     entity_render_visible                           ; E08C F0 01                    ..
LE08E:  rts                                     ; E08E 60                       `

; ----------------------------------------------------------------------------
entity_render_visible:  ldy     $0300,x                         ; E08F BC 00 03                 ...
        lda     anim_bank_tbl,y                         ; E092 B9 3B E3                 .;.
        cmp     $F5                             ; E095 C5 F5                    ..
        beq     LE09C                           ; E097 F0 03                    ..
        jsr     bank_load_pair                  ; E099 20 3D FF                  =.
LE09C:  lda     $0528,x                         ; E09C BD 28 05                 .(.
        and     #$70                            ; E09F 29 70                    )p
        asl     a                               ; E0A1 0A                       .
        pha                                     ; E0A2 48                       H
        and     #$C0                            ; E0A3 29 C0                    ).
        sta     $10                             ; E0A5 85 10                    ..
        pla                                     ; E0A7 68                       h
        and     #$20                            ; E0A8 29 20                    ) 
        sta     $11                             ; E0AA 85 11                    ..
        ldy     $0558,x                         ; E0AC BC 58 05                 .X.
        beq     LE08E                           ; E0AF F0 DD                    ..
        lda     $8600,y                         ; E0B1 B9 00 86                 ...
        sta     L0000                           ; E0B4 85 00                    ..
        lda     $8700,y                         ; E0B6 B9 00 87                 ...
        sta     $01                             ; E0B9 85 01                    ..
        ldy     #$00                            ; E0BB A0 00                    ..
        lda     (L0000),y                       ; E0BD B1 00                    ..
        sta     $02                             ; E0BF 85 02                    ..
        and     #$7F                            ; E0C1 29 7F                    ).
        sta     $03                             ; E0C3 85 03                    ..
        lda     $05B8,x                         ; E0C5 BD B8 05                 ...
        bmi     LE0F0                           ; E0C8 30 26                    0&
        lda     $5A                             ; E0CA A5 5A                    .Z
        bne     LE0F0                           ; E0CC D0 22                    ."
        lda     $0570,x                         ; E0CE BD 70 05                 .p.
        inc     $0570,x                         ; E0D1 FE 70 05                 .p.
        ldy     #$01                            ; E0D4 A0 01                    ..
        cmp     (L0000),y                       ; E0D6 D1 00                    ..
        bne     LE0F0                           ; E0D8 D0 16                    ..
        lda     #$00                            ; E0DA A9 00                    ..
        sta     $0570,x                         ; E0DC 9D 70 05                 .p.
        lda     $0540,x                         ; E0DF BD 40 05                 .@.
        and     #$7F                            ; E0E2 29 7F                    ).
        inc     $0540,x                         ; E0E4 FE 40 05                 .@.
        cmp     $03                             ; E0E7 C5 03                    ..
        bne     LE0F0                           ; E0E9 D0 05                    ..
        lda     #$00                            ; E0EB A9 00                    ..
        sta     $0540,x                         ; E0ED 9D 40 05                 .@.
LE0F0:  lda     $05B8,x                         ; E0F0 BD B8 05                 ...
        and     #$7F                            ; E0F3 29 7F                    ).
        sta     $05B8,x                         ; E0F5 9D B8 05                 ...
        beq     LE133                           ; E0F8 F0 39                    .9
        dec     $05B8,x                         ; E0FA DE B8 05                 ...
        ldy     $0300,x                         ; E0FD BC 00 03                 ...
        cpy     #$44                            ; E100 C0 44                    .D
        beq     LE128                           ; E102 F0 24                    .$
        cpy     #$4F                            ; E104 C0 4F                    .O
        beq     LE128                           ; E106 F0 20                    . 
        cpy     #$7C                            ; E108 C0 7C                    .|
        beq     LE128                           ; E10A F0 1C                    ..
        cpy     #$A0                            ; E10C C0 A0                    ..
        beq     LE128                           ; E10E F0 18                    ..
        cpy     #$A5                            ; E110 C0 A5                    ..
        beq     LE128                           ; E112 F0 14                    ..
        cpy     #$AA                            ; E114 C0 AA                    ..
        beq     LE128                           ; E116 F0 10                    ..
        cpx     $56                             ; E118 E4 56                    .V
        bne     LE12F                           ; E11A D0 13                    ..
        ldy     $2F                             ; E11C A4 2F                    ./
        bpl     LE12F                           ; E11E 10 0F                    ..
        lsr     a                               ; E120 4A                       J
        lsr     a                               ; E121 4A                       J
        bcc     LE133                           ; E122 90 0F                    ..
        ldy     #$54                            ; E124 A0 54                    .T
        bne     LE14E                           ; E126 D0 26                    .&
LE128:  lsr     a                               ; E128 4A                       J
        lsr     a                               ; E129 4A                       J
        jsr     LE208                           ; E12A 20 08 E2                  ..
        bmi     LE133                           ; E12D 30 04                    0.
LE12F:  lsr     a                               ; E12F 4A                       J
        lsr     a                               ; E130 4A                       J
        bcs     LE143                           ; E131 B0 10                    ..
LE133:  lda     $0540,x                         ; E133 BD 40 05                 .@.
        and     #$7F                            ; E136 29 7F                    ).
        clc                                     ; E138 18                       .
        adc     #$02                            ; E139 69 02                    i.
        tay                                     ; E13B A8                       .
        lda     (L0000),y                       ; E13C B1 00                    ..
        bne     LE144                           ; E13E D0 04                    ..
        jmp     LE057                           ; E140 4C 57 E0                 LW.

; ----------------------------------------------------------------------------
LE143:  rts                                     ; E143 60                       `

; ----------------------------------------------------------------------------
LE144:  tay                                     ; E144 A8                       .
        lda     $0528,x                         ; E145 BD 28 05                 .(.
        bpl     LE143                           ; E148 10 F9                    ..
        lda     $02                             ; E14A A5 02                    ..
        bmi     LE15B                           ; E14C 30 0D                    0.
LE14E:  lda     L8000,y                         ; E14E B9 00 80                 ...
        sta     $02                             ; E151 85 02                    ..
        lda     $8200,y                         ; E153 B9 00 82                 ...
        sta     $03                             ; E156 85 03                    ..
        jmp     LE165                           ; E158 4C 65 E1                 Le.

; ----------------------------------------------------------------------------
LE15B:  lda     L8100,y                         ; E15B B9 00 81                 ...
        sta     $02                             ; E15E 85 02                    ..
        lda     $8300,y                         ; E160 B9 00 83                 ...
        sta     $03                             ; E163 85 03                    ..
LE165:  ldy     #$03                            ; E165 A0 03                    ..
        lda     ($02),y                         ; E167 B1 02                    ..
        rol     a                               ; E169 2A                       *
        rol     a                               ; E16A 2A                       *
        rol     a                               ; E16B 2A                       *
        and     #$03                            ; E16C 29 03                    ).
        cmp     #$01                            ; E16E C9 01                    ..
        beq     LE182                           ; E170 F0 10                    ..
        tax                                     ; E172 AA                       .
        ldy     #$00                            ; E173 A0 00                    ..
        lda     $EC,x                           ; E175 B5 EC                    ..
        bmi     LE17E                           ; E177 30 05                    0.
        cmp     ($02),y                         ; E179 D1 02                    ..
        beq     LE182                           ; E17B F0 05                    ..
        rts                                     ; E17D 60                       `

; ----------------------------------------------------------------------------
LE17E:  lda     ($02),y                         ; E17E B1 02                    ..
        sta     $EC,x                           ; E180 95 EC                    ..
LE182:  ldy     #$01                            ; E182 A0 01                    ..
        lda     ($02),y                         ; E184 B1 02                    ..
        sta     L0004                           ; E186 85 04                    ..
        iny                                     ; E188 C8                       .
        lda     ($02),y                         ; E189 B1 02                    ..
        tax                                     ; E18B AA                       .
        lda     $8400,x                         ; E18C BD 00 84                 ...
        sec                                     ; E18F 38                       8
        sbc     #$03                            ; E190 E9 03                    ..
        sta     $05                             ; E192 85 05                    ..
        lda     $8500,x                         ; E194 BD 00 85                 ...
        sbc     #$00                            ; E197 E9 00                    ..
        sta     $06                             ; E199 85 06                    ..
        ldx     $9F                             ; E19B A6 9F                    ..
        beq     LE1FF                           ; E19D F0 60                    .`
LE19F:  iny                                     ; E19F C8                       .
        lda     ($02),y                         ; E1A0 B1 02                    ..
        sta     $0201,x                         ; E1A2 9D 01 02                 ...
        lda     ($05),y                         ; E1A5 B1 05                    ..
        sta     $07                             ; E1A7 85 07                    ..
        lda     $10                             ; E1A9 A5 10                    ..
        bpl     LE1B4                           ; E1AB 10 07                    ..
        lda     #$F8                            ; E1AD A9 F8                    ..
        sec                                     ; E1AF 38                       8
        sbc     $07                             ; E1B0 E5 07                    ..
        sta     $07                             ; E1B2 85 07                    ..
LE1B4:  lda     $12                             ; E1B4 A5 12                    ..
        clc                                     ; E1B6 18                       .
        adc     $07                             ; E1B7 65 07                    e.
        sta     L0200,x                         ; E1B9 9D 00 02                 ...
        lda     $07                             ; E1BC A5 07                    ..
        bmi     LE1C4                           ; E1BE 30 04                    0.
        bcc     LE1C6                           ; E1C0 90 04                    ..
        bcs     LE200                           ; E1C2 B0 3C                    .<
LE1C4:  bcc     LE200                           ; E1C4 90 3A                    .:
LE1C6:  iny                                     ; E1C6 C8                       .
        lda     ($02),y                         ; E1C7 B1 02                    ..
        eor     $10                             ; E1C9 45 10                    E.
        ora     $11                             ; E1CB 05 11                    ..
        sta     $0202,x                         ; E1CD 9D 02 02                 ...
        lda     ($05),y                         ; E1D0 B1 05                    ..
        sta     $07                             ; E1D2 85 07                    ..
        lda     $10                             ; E1D4 A5 10                    ..
        and     #$40                            ; E1D6 29 40                    )@
        beq     LE1E1                           ; E1D8 F0 07                    ..
        lda     #$F8                            ; E1DA A9 F8                    ..
        sec                                     ; E1DC 38                       8
        sbc     $07                             ; E1DD E5 07                    ..
        sta     $07                             ; E1DF 85 07                    ..
LE1E1:  lda     $13                             ; E1E1 A5 13                    ..
        clc                                     ; E1E3 18                       .
        adc     $07                             ; E1E4 65 07                    e.
        sta     $0203,x                         ; E1E6 9D 03 02                 ...
        lda     $07                             ; E1E9 A5 07                    ..
        bmi     LE1F1                           ; E1EB 30 04                    0.
        bcc     LE1F3                           ; E1ED 90 04                    ..
        bcs     LE201                           ; E1EF B0 10                    ..
LE1F1:  bcc     LE201                           ; E1F1 90 0E                    ..
LE1F3:  inx                                     ; E1F3 E8                       .
        inx                                     ; E1F4 E8                       .
        inx                                     ; E1F5 E8                       .
        inx                                     ; E1F6 E8                       .
        stx     $9F                             ; E1F7 86 9F                    ..
        beq     LE1FF                           ; E1F9 F0 04                    ..
LE1FB:  dec     L0004                           ; E1FB C6 04                    ..
        bpl     LE19F                           ; E1FD 10 A0                    ..
LE1FF:  rts                                     ; E1FF 60                       `

; ----------------------------------------------------------------------------
LE200:  iny                                     ; E200 C8                       .
LE201:  lda     #$F8                            ; E201 A9 F8                    ..
        sta     L0200,x                         ; E203 9D 00 02                 ...
        bne     LE1FB                           ; E206 D0 F3                    ..
LE208:  ror     $05                             ; E208 66 05                    f.
        cpy     #$4F                            ; E20A C0 4F                    .O
        bcs     LE237                           ; E20C B0 29                    .)
        ldy     #$02                            ; E20E A0 02                    ..
LE210:  lda     $0621,y                         ; E210 B9 21 06                 .!.
        sta     $0601,y                         ; E213 99 01 06                 ...
        lda     $0625,y                         ; E216 B9 25 06                 .%.
        sta     $0605,y                         ; E219 99 05 06                 ...
        lda     $0629,y                         ; E21C B9 29 06                 .).
        sta     $0609,y                         ; E21F 99 09 06                 ...
        lda     $05                             ; E222 A5 05                    ..
        bpl     LE231                           ; E224 10 0B                    ..
        lda     #$30                            ; E226 A9 30                    .0
        sta     $0601,y                         ; E228 99 01 06                 ...
        sta     $0605,y                         ; E22B 99 05 06                 ...
        sta     $0609,y                         ; E22E 99 09 06                 ...
LE231:  dey                                     ; E231 88                       .
        bpl     LE210                           ; E232 10 DC                    ..
        sty     $18                             ; E234 84 18                    ..
        rts                                     ; E236 60                       `

; ----------------------------------------------------------------------------
LE237:  ldy     #$02                            ; E237 A0 02                    ..
LE239:  lda     $0625,y                         ; E239 B9 25 06                 .%.
        sta     $0605,y                         ; E23C 99 05 06                 ...
        lda     $0629,y                         ; E23F B9 29 06                 .).
        sta     $0609,y                         ; E242 99 09 06                 ...
        lda     $062D,y                         ; E245 B9 2D 06                 .-.
        sta     $060D,y                         ; E248 99 0D 06                 ...
        lda     $05                             ; E24B A5 05                    ..
        bpl     LE25A                           ; E24D 10 0B                    ..
        lda     #$30                            ; E24F A9 30                    .0
        sta     $0605,y                         ; E251 99 05 06                 ...
        sta     $0609,y                         ; E254 99 09 06                 ...
        sta     $060D,y                         ; E257 99 0D 06                 ...
LE25A:  dey                                     ; E25A 88                       .
        bpl     LE239                           ; E25B 10 DC                    ..
        sty     $18                             ; E25D 84 18                    ..
        rts                                     ; E25F 60                       `

; ----------------------------------------------------------------------------
LE260:  ldx     #$00                            ; E260 A2 00                    ..
        stx     $10                             ; E262 86 10                    ..
LE264:  jsr     LE27E                           ; E264 20 7E E2                  ~.
        inc     $10                             ; E267 E6 10                    ..
        ldx     $10                             ; E269 A6 10                    ..
        cpx     #$03                            ; E26B E0 03                    ..
        bne     LE264                           ; E26D D0 F5                    ..
        rts                                     ; E26F 60                       `

; ----------------------------------------------------------------------------
LE270:  ldx     #$02                            ; E270 A2 02                    ..
        stx     $10                             ; E272 86 10                    ..
LE274:  jsr     LE27E                           ; E274 20 7E E2                  ~.
        dec     $10                             ; E277 C6 10                    ..
        ldx     $10                             ; E279 A6 10                    ..
        bpl     LE274                           ; E27B 10 F7                    ..
LE27D:  rts                                     ; E27D 60                       `

; ----------------------------------------------------------------------------
LE27E:  lda     $2D,x                           ; E27E B5 2D                    .-
        bpl     LE27D                           ; E280 10 FB                    ..
        and     #$7F                            ; E282 29 7F                    ).
        tay                                     ; E284 A8                       .
        lda     $B0,y                           ; E285 B9 B0 00                 ...
        and     #$7F                            ; E288 29 7F                    ).
        sta     L0000                           ; E28A 85 00                    ..
        cpx     #$02                            ; E28C E0 02                    ..
        bne     LE297                           ; E28E D0 07                    ..
        ldy     $56                             ; E290 A4 56                    .V
        lda     $0450,y                         ; E292 B9 50 04                 .P.
        sta     L0000                           ; E295 85 00                    ..
LE297:  lda     LE2E1,x                         ; E297 BD E1 E2                 ...
        sta     $01                             ; E29A 85 01                    ..
        lda     LE2E4,x                         ; E29C BD E4 E2                 ...
        sta     $02                             ; E29F 85 02                    ..
        ldx     $9F                             ; E2A1 A6 9F                    ..
        beq     LE2DE                           ; E2A3 F0 39                    .9
        lda     #$48                            ; E2A5 A9 48                    .H
        sta     $03                             ; E2A7 85 03                    ..
LE2A9:  lda     $03                             ; E2A9 A5 03                    ..
        sta     L0200,x                         ; E2AB 9D 00 02                 ...
        lda     $02                             ; E2AE A5 02                    ..
        sta     $0203,x                         ; E2B0 9D 03 02                 ...
        lda     $01                             ; E2B3 A5 01                    ..
        sta     $0202,x                         ; E2B5 9D 02 02                 ...
        ldy     #$04                            ; E2B8 A0 04                    ..
        lda     L0000                           ; E2BA A5 00                    ..
        sec                                     ; E2BC 38                       8
        sbc     #$04                            ; E2BD E9 04                    ..
        bcs     LE2C5                           ; E2BF B0 04                    ..
        ldy     L0000                           ; E2C1 A4 00                    ..
        lda     #$00                            ; E2C3 A9 00                    ..
LE2C5:  sta     L0000                           ; E2C5 85 00                    ..
        tya                                     ; E2C7 98                       .
        ora     #$60                            ; E2C8 09 60                    .`
        sta     $0201,x                         ; E2CA 9D 01 02                 ...
        inx                                     ; E2CD E8                       .
        inx                                     ; E2CE E8                       .
        inx                                     ; E2CF E8                       .
        inx                                     ; E2D0 E8                       .
        beq     LE2DE                           ; E2D1 F0 0B                    ..
        lda     $03                             ; E2D3 A5 03                    ..
        sec                                     ; E2D5 38                       8
        sbc     #$08                            ; E2D6 E9 08                    ..
        sta     $03                             ; E2D8 85 03                    ..
        cmp     #$10                            ; E2DA C9 10                    ..
        bne     LE2A9                           ; E2DC D0 CB                    ..
LE2DE:  stx     $9F                             ; E2DE 86 9F                    ..
        rts                                     ; E2E0 60                       `

; ----------------------------------------------------------------------------
LE2E1:  ora     (L0000,x)                       ; E2E1 01 00                    ..
        .byte   $02                             ; E2E3 02                       .
LE2E4:  clc                                     ; E2E4 18                       .
        bpl     LE30F                           ; E2E5 10 28                    .(
LE2E7:  ldx     #$00                            ; E2E7 A2 00                    ..
        lda     LE313,x                         ; E2E9 BD 13 E3                 ...
        sec                                     ; E2EC 38                       8
        sbc     $76                             ; E2ED E5 76                    .v
        bcs     LE2F3                           ; E2EF B0 02                    ..
        sbc     #$0F                            ; E2F1 E9 0F                    ..
LE2F3:  sta     L0200,x                         ; E2F3 9D 00 02                 ...
        lda     LE314,x                         ; E2F6 BD 14 E3                 ...
        sta     $0201,x                         ; E2F9 9D 01 02                 ...
        lda     LE315,x                         ; E2FC BD 15 E3                 ...
        sta     $0202,x                         ; E2FF 9D 02 02                 ...
        lda     LE316,x                         ; E302 BD 16 E3                 ...
        sta     $0203,x                         ; E305 9D 03 02                 ...
        inx                                     ; E308 E8                       .
        inx                                     ; E309 E8                       .
        inx                                     ; E30A E8                       .
        inx                                     ; E30B E8                       .
        cpx     #$28                            ; E30C E0 28                    .(
        .byte   $D0                             ; E30E D0                       .
LE30F:  cmp     $9F86,y                         ; E30F D9 86 9F                 ...
        rts                                     ; E312 60                       `

; ----------------------------------------------------------------------------
LE313:  plp                                     ; E313 28                       (
LE314:  tay                                     ; E314 A8                       .
LE315:  .byte   $21                             ; E315 21                       !
LE316:  .byte   $04                             ; E316 04                       .
        cli                                     ; E317 58                       X
        tay                                     ; E318 A8                       .
        and     (L0004,x)                       ; E319 21 04                    !.
        dey                                     ; E31B 88                       .
        tay                                     ; E31C A8                       .
        and     (L0004,x)                       ; E31D 21 04                    !.
        clv                                     ; E31F B8                       .
        tay                                     ; E320 A8                       .
        and     (L0004,x)                       ; E321 21 04                    !.
        inx                                     ; E323 E8                       .
        tay                                     ; E324 A8                       .
        and     (L0004,x)                       ; E325 21 04                    !.
        plp                                     ; E327 28                       (
        tay                                     ; E328 A8                       .
        and     ($F4,x)                         ; E329 21 F4                    !.
        cli                                     ; E32B 58                       X
        tay                                     ; E32C A8                       .
        and     ($F4,x)                         ; E32D 21 F4                    !.
        dey                                     ; E32F 88                       .
        tay                                     ; E330 A8                       .
        and     ($F4,x)                         ; E331 21 F4                    !.
        clv                                     ; E333 B8                       .
        tay                                     ; E334 A8                       .
        and     ($F4,x)                         ; E335 21 F4                    !.
        inx                                     ; E337 E8                       .
        tay                                     ; E338 A8                       .
        and     ($F4,x)                         ; E339 21 F4                    !.
; entity type -> animation bank pair ($12/$13, $14/$15, $16/$17)
anim_bank_tbl:
        .byte   $12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12   ; E33B
        .byte   $12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$16,$12   ; E34B
        .byte   $12,$12,$16,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12   ; E35B
        .byte   $12,$16,$16,$12,$12,$12,$16,$12,$12,$12,$12,$12,$12,$16,$12,$12   ; E36B
        .byte   $12,$12,$16,$12,$12,$12,$12,$14,$12,$12,$12,$12,$12,$12,$12,$12   ; E37B
        .byte   $12,$12,$12,$12,$12,$12,$12,$14,$16,$14,$12,$12,$12,$12,$14,$12   ; E38B
        .byte   $12,$12,$14,$16,$14,$14,$12,$12,$12,$14,$14,$14,$14,$14,$14,$14   ; E39B
        .byte   $12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12   ; E3AB
        .byte   $14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$12,$14,$14,$14   ; E3BB
        .byte   $14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14   ; E3CB
        .byte   $14,$12,$12,$12,$12,$14,$14,$14,$14,$14,$12,$14,$14,$12,$12,$12   ; E3DB
        .byte   $14,$12,$12,$14,$14,$14,$14,$14,$12,$14,$14,$14,$12,$14,$14,$12   ; E3EB
        .byte   $12,$12,$12,$14,$12,$12,$12,$14,$16,$12,$12,$12,$12,$12,$12,$12   ; E3FB
        .byte   $12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12   ; E40B
        .byte   $12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12   ; E41B
        .byte   $12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12   ; E42B
 ; -----------------------------------------------------------------------------
; DEBUG PAD-2 TASK — $E43B (orphaned in retail)
; A leftover debug task: pad 2 DOWN toggles gravity_flip + player
; h-flip; pad 2 A skips to the next stage (debug_stage_next rotate
; table) and restarts the main game task. Unreachable in retail: no
; spawn site exists and read_controllers zeroes pad 2 every frame.
; -----------------------------------------------------------------------------
        ldx     #$6F                            ; E43B A2 6F                    .o
        txs                                     ; E43D 9A                       .
debug_pad2_loop:  lda     $15                             ; E43E A5 15                    ..
        and     #$04                            ; E440 29 04                    ).
        beq     LE455                           ; E442 F0 11                    ..
        lda     $0528                           ; E444 AD 28 05                 .(.
        eor     #$40                            ; E447 49 40                    I@
        sta     $0528                           ; E449 8D 28 05                 .(.
        lda     $AF                             ; E44C A5 AF                    ..
        eor     #$01                            ; E44E 49 01                    I.
        sta     $AF                             ; E450 85 AF                    ..
        jmp     LE490                           ; E452 4C 90 E4                 L..

; ----------------------------------------------------------------------------
LE455:  lda     $15                             ; E455 A5 15                    ..
        and     #$80                            ; E457 29 80                    ).
        beq     LE48A                           ; E459 F0 2F                    ./
        ldy     $26                             ; E45B A4 26                    .&
        lda     debug_stage_next,y                         ; E45D B9 96 E4                 ...
        sta     $26                             ; E460 85 26                    .&
        sta     $6C                             ; E462 85 6C                    .l
        lda     #$00                            ; E464 A9 00                    ..
        sta     $24                             ; E466 85 24                    .$
        sta     $25                             ; E468 85 25                    .%
        sta     $AD                             ; E46A 85 AD                    ..
        sta     $AE                             ; E46C 85 AE                    ..
        lda     #$DD                            ; E46E A9 DD                    ..
        sta     $94                             ; E470 85 94                    ..
        lda     #$E8                            ; E472 A9 E8                    ..
        sta     L0093                           ; E474 85 93                    ..
        lda     #$02                            ; E476 A9 02                    ..
        jsr     task_create                     ; E478 20 F3 FE                  ..
        lda     #$00                            ; E47B A9 00                    ..
        jsr     task_kill                       ; E47D 20 03 FF                  ..
        lda     #$01                            ; E480 A9 01                    ..
        jsr     task_kill                       ; E482 20 03 FF                  ..
        lda     #$03                            ; E485 A9 03                    ..
        jmp     task_exit                       ; E487 4C 0B FF                 L..

; ----------------------------------------------------------------------------
LE48A:  lda     $15                             ; E48A A5 15                    ..
        and     #$01                            ; E48C 29 01                    ).
        beq     LE490                           ; E48E F0 00                    ..
LE490:  jsr     frame_wait                      ; E490 20 22 FF                  ".
        jmp     debug_pad2_loop                           ; E493 4C 3E E4                 L>.

; ----------------------------------------------------------------------------
debug_stage_next:  ora     ($02,x)                         ; E496 01 02                    ..
        .byte   $03                             ; E498 03                       .
        .byte   $04                             ; E499 04                       .
        ora     $06                             ; E49A 05 06                    ..
        .byte   $07                             ; E49C 07                       .
        php                                     ; E49D 08                       .
        ora     #$0A                            ; E49E 09 0A                    ..
        .byte   $0B                             ; E4A0 0B                       .
        .byte   $0C                             ; E4A1 0C                       .
        ora     $0F0E                           ; E4A2 0D 0E 0F                 ...
        brk                                     ; E4A5 00                       .
LE4A6:  jsr     oam_clear                           ; E4A6 20 8F C3                  ..
        ldy     #$00                            ; E4A9 A0 00                    ..
        ldx     #$00                            ; E4AB A2 00                    ..
        stx     $95                             ; E4AD 86 95                    ..
        stx     $9F                             ; E4AF 86 9F                    ..
        stx     $77                             ; E4B1 86 77                    .w
LE4B3:  lda     LE614,x                         ; E4B3 BD 14 E6                 ...
        sta     L0200,y                         ; E4B6 99 00 02                 ...
        lda     LE615,x                         ; E4B9 BD 15 E6                 ...
        sta     $0203,y                         ; E4BC 99 03 02                 ...
        inx                                     ; E4BF E8                       .
        inx                                     ; E4C0 E8                       .
        iny                                     ; E4C1 C8                       .
        iny                                     ; E4C2 C8                       .
        iny                                     ; E4C3 C8                       .
        iny                                     ; E4C4 C8                       .
        cpx     #$64                            ; E4C5 E0 64                    .d
        bne     LE4B3                           ; E4C7 D0 EA                    ..
        ldy     #$06                            ; E4C9 A0 06                    ..
LE4CB:  lda     LE678,y                         ; E4CB B9 78 E6                 .x.
        sta     $0611,y                         ; E4CE 99 11 06                 ...
        dey                                     ; E4D1 88                       .
        bpl     LE4CB                           ; E4D2 10 F7                    ..
LE4D4:  lda     $14                             ; E4D4 A5 14                    ..
        and     #$20                            ; E4D6 29 20                    ) 
        beq     LE501                           ; E4D8 F0 27                    .'
        ldy     #$0F                            ; E4DA A0 0F                    ..
LE4DC:  lda     $0600,y                         ; E4DC B9 00 06                 ...
        sta     $0620,y                         ; E4DF 99 20 06                 . .
        lda     $0630,y                         ; E4E2 B9 30 06                 .0.
        sta     $0610,y                         ; E4E5 99 10 06                 ...
        dey                                     ; E4E8 88                       .
        bpl     LE4DC                           ; E4E9 10 F1                    ..
        lda     $0600                           ; E4EB AD 00 06                 ...
        sta     $0610                           ; E4EE 8D 10 06                 ...
        sta     $0630                           ; E4F1 8D 30 06                 .0.
        sty     $18                             ; E4F4 84 18                    ..
        ldy     #$0C                            ; E4F6 A0 0C                    ..
        lda     #$9C                            ; E4F8 A9 9C                    ..
LE4FA:  sta     $B0,y                           ; E4FA 99 B0 00                 ...
        dey                                     ; E4FD 88                       .
        bpl     LE4FA                           ; E4FE 10 FA                    ..
        rts                                     ; E500 60                       `

; ----------------------------------------------------------------------------
LE501:  lda     $14                             ; E501 A5 14                    ..
        and     #$0F                            ; E503 29 0F                    ).
        beq     LE537                           ; E505 F0 30                    .0
        and     #$03                            ; E507 29 03                    ).
        bne     LE524                           ; E509 D0 19                    ..
        lda     $14                             ; E50B A5 14                    ..
        and     #$08                            ; E50D 29 08                    ).
        beq     LE51B                           ; E50F F0 0A                    ..
        lda     $77                             ; E511 A5 77                    .w
        sec                                     ; E513 38                       8
        sbc     #$04                            ; E514 E9 04                    ..
        sta     $77                             ; E516 85 77                    .w
        jmp     LE52E                           ; E518 4C 2E E5                 L..

; ----------------------------------------------------------------------------
LE51B:  lda     $77                             ; E51B A5 77                    .w
        clc                                     ; E51D 18                       .
        adc     #$04                            ; E51E 69 04                    i.
        sta     $77                             ; E520 85 77                    .w
        bne     LE52E                           ; E522 D0 0A                    ..
LE524:  and     #$01                            ; E524 29 01                    ).
        beq     LE52C                           ; E526 F0 04                    ..
        inc     $77                             ; E528 E6 77                    .w
        bne     LE52E                           ; E52A D0 02                    ..
LE52C:  dec     $77                             ; E52C C6 77                    .w
LE52E:  lda     $77                             ; E52E A5 77                    .w
        and     #$0F                            ; E530 29 0F                    ).
        sta     $77                             ; E532 85 77                    .w
        jmp     LE584                           ; E534 4C 84 E5                 L..

; ----------------------------------------------------------------------------
LE537:  ldy     $77                             ; E537 A4 77                    .w
        lda     $0600,y                         ; E539 B9 00 06                 ...
        sta     $10                             ; E53C 85 10                    ..
        lda     $14                             ; E53E A5 14                    ..
        and     #$C0                            ; E540 29 C0                    ).
        beq     LE584                           ; E542 F0 40                    .@
        and     #$80                            ; E544 29 80                    ).
        beq     LE54D                           ; E546 F0 05                    ..
        inc     $10                             ; E548 E6 10                    ..
        jmp     LE54F                           ; E54A 4C 4F E5                 LO.

; ----------------------------------------------------------------------------
LE54D:  dec     $10                             ; E54D C6 10                    ..
LE54F:  lda     $10                             ; E54F A5 10                    ..
        cmp     #$0F                            ; E551 C9 0F                    ..
        beq     LE57C                           ; E553 F0 27                    .'
        lda     $10                             ; E555 A5 10                    ..
        and     #$3F                            ; E557 29 3F                    )?
        sta     $10                             ; E559 85 10                    ..
        and     #$0F                            ; E55B 29 0F                    ).
        cmp     #$0D                            ; E55D C9 0D                    ..
        bcc     LE57C                           ; E55F 90 1B                    ..
        lda     $14                             ; E561 A5 14                    ..
        and     #$80                            ; E563 29 80                    ).
        beq     LE574                           ; E565 F0 0D                    ..
        lda     $10                             ; E567 A5 10                    ..
        and     #$30                            ; E569 29 30                    )0
        adc     #$10                            ; E56B 69 10                    i.
        and     #$30                            ; E56D 29 30                    )0
        sta     $10                             ; E56F 85 10                    ..
        jmp     LE57C                           ; E571 4C 7C E5                 L|.

; ----------------------------------------------------------------------------
LE574:  lda     $10                             ; E574 A5 10                    ..
        and     #$30                            ; E576 29 30                    )0
        ora     #$0C                            ; E578 09 0C                    ..
        sta     $10                             ; E57A 85 10                    ..
LE57C:  lda     $10                             ; E57C A5 10                    ..
        sta     $0600,y                         ; E57E 99 00 06                 ...
        sta     $0620,y                         ; E581 99 20 06                 . .
LE584:  lda     $77                             ; E584 A5 77                    .w
        sta     L0000                           ; E586 85 00                    ..
        ldx     #$00                            ; E588 A2 00                    ..
        ldy     #$00                            ; E58A A0 00                    ..
LE58C:  lda     $0600,y                         ; E58C B9 00 06                 ...
        pha                                     ; E58F 48                       H
        and     #$F0                            ; E590 29 F0                    ).
        lsr     a                               ; E592 4A                       J
        lsr     a                               ; E593 4A                       J
        lsr     a                               ; E594 4A                       J
        lsr     a                               ; E595 4A                       J
        sty     $01                             ; E596 84 01                    ..
        tay                                     ; E598 A8                       .
        lda     LE67F,y                         ; E599 B9 7F E6                 ...
        ldy     $01                             ; E59C A4 01                    ..
        sta     $0201,x                         ; E59E 9D 01 02                 ...
        lda     #$00                            ; E5A1 A9 00                    ..
        cpy     L0000                           ; E5A3 C4 00                    ..
        bne     LE5A9                           ; E5A5 D0 02                    ..
        lda     #$01                            ; E5A7 A9 01                    ..
LE5A9:  sta     $0202,x                         ; E5A9 9D 02 02                 ...
        sta     $0206,x                         ; E5AC 9D 06 02                 ...
        pla                                     ; E5AF 68                       h
        and     #$0F                            ; E5B0 29 0F                    ).
        sty     $01                             ; E5B2 84 01                    ..
        tay                                     ; E5B4 A8                       .
        lda     LE67F,y                         ; E5B5 B9 7F E6                 ...
        ldy     $01                             ; E5B8 A4 01                    ..
        sta     $0205,x                         ; E5BA 9D 05 02                 ...
        txa                                     ; E5BD 8A                       .
        clc                                     ; E5BE 18                       .
        adc     #$08                            ; E5BF 69 08                    i.
        tax                                     ; E5C1 AA                       .
        iny                                     ; E5C2 C8                       .
        cpy     #$20                            ; E5C3 C0 20                    . 
        beq     LE5CF                           ; E5C5 F0 08                    ..
        cpy     #$10                            ; E5C7 C0 10                    ..
        bne     LE58C                           ; E5C9 D0 C1                    ..
        ldy     #$18                            ; E5CB A0 18                    ..
        bne     LE58C                           ; E5CD D0 BD                    ..
LE5CF:  lda     $0348                           ; E5CF AD 48 03                 .H.
        pha                                     ; E5D2 48                       H
        and     #$0F                            ; E5D3 29 0F                    ).
        sta     L0000                           ; E5D5 85 00                    ..
        pla                                     ; E5D7 68                       h
        lsr     a                               ; E5D8 4A                       J
        lsr     a                               ; E5D9 4A                       J
        lsr     a                               ; E5DA 4A                       J
        lsr     a                               ; E5DB 4A                       J
        tay                                     ; E5DC A8                       .
LE5DD:  lda     LE67F,y                         ; E5DD B9 7F E6                 ...
        sta     $0201,x                         ; E5E0 9D 01 02                 ...
        ldy     L0000                           ; E5E3 A4 00                    ..
        .byte   $B9                             ; E5E5 B9                       .
        .byte   $7F                             ; E5E6 7F                       .
LE5E7:  inc     $9D                             ; E5E7 E6 9D                    ..
        ora     $02                             ; E5E9 05 02                    ..
        lda     #$00                            ; E5EB A9 00                    ..
        sta     $0202,x                         ; E5ED 9D 02 02                 ...
        sta     $0206,x                         ; E5F0 9D 06 02                 ...
        jsr     LE68F                           ; E5F3 20 8F E6                  ..
        lda     #$FF                            ; E5F6 A9 FF                    ..
        sta     $18                             ; E5F8 85 18                    ..
        lda     $0600                           ; E5FA AD 00 06                 ...
LE5FD:  sta     $0610                           ; E5FD 8D 10 06                 ...
        lda     #$00                            ; E600 A9 00                    ..
        sta     $05F8                           ; E602 8D F8 05                 ...
        .byte   $8D                             ; E605 8D                       .
        .byte   $F9                             ; E606 F9                       .
LE607:  ora     $8D                             ; E607 05 8D                    ..
        .byte   $FA                             ; E609 FA                       .
        ora     $8D                             ; E60A 05 8D                    ..
        .byte   $FB                             ; E60C FB                       .
        ora     L0020                           ; E60D 05 20                    . 
        .byte   $22                             ; E60F 22                       "
        .byte   $FF                             ; E610 FF                       .
        jmp     LE4D4                           ; E611 4C D4 E4                 L..

; ----------------------------------------------------------------------------
LE614:  plp                                     ; E614 28                       (
LE615:  .byte   $80                             ; E615 80                       .
        plp                                     ; E616 28                       (
        dey                                     ; E617 88                       .
        plp                                     ; E618 28                       (
        tya                                     ; E619 98                       .
        plp                                     ; E61A 28                       (
        ldy     #$28                            ; E61B A0 28                    .(
        bcs     LE647                           ; E61D B0 28                    .(
        clv                                     ; E61F B8                       .
        plp                                     ; E620 28                       (
        iny                                     ; E621 C8                       .
        plp                                     ; E622 28                       (
        bne     LE65D                           ; E623 D0 38                    .8
        .byte   $80                             ; E625 80                       .
        sec                                     ; E626 38                       8
        dey                                     ; E627 88                       .
        sec                                     ; E628 38                       8
        tya                                     ; E629 98                       .
        sec                                     ; E62A 38                       8
        ldy     #$38                            ; E62B A0 38                    .8
        bcs     LE667                           ; E62D B0 38                    .8
        clv                                     ; E62F B8                       .
        sec                                     ; E630 38                       8
        iny                                     ; E631 C8                       .
        sec                                     ; E632 38                       8
        bne     LE67D                           ; E633 D0 48                    .H
        .byte   $80                             ; E635 80                       .
        pha                                     ; E636 48                       H
        dey                                     ; E637 88                       .
        pha                                     ; E638 48                       H
        tya                                     ; E639 98                       .
        pha                                     ; E63A 48                       H
        ldy     #$48                            ; E63B A0 48                    .H
        bcs     LE687                           ; E63D B0 48                    .H
        clv                                     ; E63F B8                       .
        pha                                     ; E640 48                       H
        iny                                     ; E641 C8                       .
        pha                                     ; E642 48                       H
        bne     LE69D                           ; E643 D0 58                    .X
        .byte   $80                             ; E645 80                       .
        cli                                     ; E646 58                       X
LE647:  dey                                     ; E647 88                       .
        cli                                     ; E648 58                       X
        tya                                     ; E649 98                       .
        cli                                     ; E64A 58                       X
        ldy     #$58                            ; E64B A0 58                    .X
        bcs     LE6A7                           ; E64D B0 58                    .X
        clv                                     ; E64F B8                       .
        cli                                     ; E650 58                       X
        iny                                     ; E651 C8                       .
        cli                                     ; E652 58                       X
        bne     LE5DD                           ; E653 D0 88                    ..
        .byte   $80                             ; E655 80                       .
        dey                                     ; E656 88                       .
        dey                                     ; E657 88                       .
        dey                                     ; E658 88                       .
        tya                                     ; E659 98                       .
        dey                                     ; E65A 88                       .
        ldy     #$88                            ; E65B A0 88                    ..
LE65D:  bcs     LE5E7                           ; E65D B0 88                    ..
        clv                                     ; E65F B8                       .
        dey                                     ; E660 88                       .
        iny                                     ; E661 C8                       .
        dey                                     ; E662 88                       .
        bne     LE5FD                           ; E663 D0 98                    ..
        .byte   $80                             ; E665 80                       .
        tya                                     ; E666 98                       .
LE667:  dey                                     ; E667 88                       .
        tya                                     ; E668 98                       .
        tya                                     ; E669 98                       .
        tya                                     ; E66A 98                       .
        ldy     #$98                            ; E66B A0 98                    ..
        bcs     LE607                           ; E66D B0 98                    ..
        clv                                     ; E66F B8                       .
        tya                                     ; E670 98                       .
        iny                                     ; E671 C8                       .
        tya                                     ; E672 98                       .
        bne     LE6ED                           ; E673 D0 78                    .x
        .byte   $80                             ; E675 80                       .
        sei                                     ; E676 78                       x
        dey                                     ; E677 88                       .
LE678:  bmi     LE6AA                           ; E678 30 30                    00
        bmi     LE68B                           ; E67A 30 0F                    0.
        .byte   $16                             ; E67C 16                       .
LE67D:  asl     $16,x                           ; E67D 16 16                    ..
LE67F:  bmi     LE6B2                           ; E67F 30 31                    01
        .byte   $32                             ; E681 32                       2
        .byte   $33                             ; E682 33                       3
        .byte   $34                             ; E683 34                       4
        and     $36,x                           ; E684 35 36                    56
        .byte   $37                             ; E686 37                       7
LE687:  sec                                     ; E687 38                       8
        and     $4241,y                         ; E688 39 41 42                 9AB
LE68B:  .byte   $43                             ; E68B 43                       C
        .byte   $44                             ; E68C 44                       D
        eor     $46                             ; E68D 45 46                    EF
LE68F:  lda     #$9C                            ; E68F A9 9C                    ..
        sec                                     ; E691 38                       8
        sbc     $B0                             ; E692 E5 B0                    ..
        pha                                     ; E694 48                       H
        and     #$10                            ; E695 29 10                    ).
        lsr     a                               ; E697 4A                       J
        lsr     a                               ; E698 4A                       J
        lsr     a                               ; E699 4A                       J
        lsr     a                               ; E69A 4A                       J
        tay                                     ; E69B A8                       .
        .byte   $B9                             ; E69C B9                       .
LE69D:  .byte   $7F                             ; E69D 7F                       .
        inc     $8D                             ; E69E E6 8D                    ..
        sbc     $A902,y                         ; E6A0 F9 02 A9                 ...
        jsr     LF88D                           ; E6A3 20 8D F8                  ..
        .byte   $02                             ; E6A6 02                       .
LE6A7:  sta     $02FC                           ; E6A7 8D FC 02                 ...
LE6AA:  lda     #$30                            ; E6AA A9 30                    .0
        sta     $02FB                           ; E6AC 8D FB 02                 ...
        lda     #$00                            ; E6AF A9 00                    ..
        .byte   $8D                             ; E6B1 8D                       .
LE6B2:  .byte   $FA                             ; E6B2 FA                       .
        .byte   $02                             ; E6B3 02                       .
        sta     $02FE                           ; E6B4 8D FE 02                 ...
        pla                                     ; E6B7 68                       h
        and     #$0F                            ; E6B8 29 0F                    ).
        tay                                     ; E6BA A8                       .
        lda     LE67F,y                         ; E6BB B9 7F E6                 ...
        sta     $02FD                           ; E6BE 8D FD 02                 ...
        lda     #$38                            ; E6C1 A9 38                    .8
        sta     $02FF                           ; E6C3 8D FF 02                 ...
        rts                                     ; E6C6 60                       `

; ----------------------------------------------------------------------------
entity_move_right:  lda     $0528,x                         ; E6C7 BD 28 05                 .(.
        ora     #$20                            ; E6CA 09 20                    . 
        sta     $0528,x                         ; E6CC 9D 28 05                 .(.
        cpx     #$00                            ; E6CF E0 00                    ..
        bne     LE6DD                           ; E6D1 D0 0A                    ..
        lda     $0330                           ; E6D3 AD 30 03                 .0.
        sta     $02                             ; E6D6 85 02                    ..
        lda     $0348                           ; E6D8 AD 48 03                 .H.
        sta     $03                             ; E6DB 85 03                    ..
LE6DD:  jsr     entity_move_right_collide                           ; E6DD 20 E6 E8                  ..
        cpx     #$00                            ; E6E0 E0 00                    ..
        bne     LE6F9                           ; E6E2 D0 15                    ..
        jsr     LEDF6                           ; E6E4 20 F6 ED                  ..
        bcc     LE6F9                           ; E6E7 90 10                    ..
        jsr     LEF15                           ; E6E9 20 15 EF                  ..
        .byte   $20                             ; E6EC 20                        
LE6ED:  sbc     ($E6),y                         ; E6ED F1 E6                    ..
        sec                                     ; E6EF 38                       8
        rts                                     ; E6F0 60                       `

; ----------------------------------------------------------------------------
        bcc     LE6F9                           ; E6F1 90 06                    ..
        beq     LE6F9                           ; E6F3 F0 04                    ..
        iny                                     ; E6F5 C8                       .
        jmp     LE738                           ; E6F6 4C 38 E7                 L8.

; ----------------------------------------------------------------------------
LE6F9:  jsr     tile_collide_vert                           ; E6F9 20 AA C5                  ..
        clc                                     ; E6FC 18                       .
        lda     $10                             ; E6FD A5 10                    ..
        and     #$10                            ; E6FF 29 10                    ).
        beq     LE707                           ; E701 F0 04                    ..
        jsr     LEEAF                           ; E703 20 AF EE                  ..
        sec                                     ; E706 38                       8
LE707:  rts                                     ; E707 60                       `

; ----------------------------------------------------------------------------
entity_move_left:  lda     $0528,x                         ; E708 BD 28 05                 .(.
        and     #$DF                            ; E70B 29 DF                    ).
        sta     $0528,x                         ; E70D 9D 28 05                 .(.
        cpx     #$00                            ; E710 E0 00                    ..
        bne     LE71E                           ; E712 D0 0A                    ..
        lda     $0330                           ; E714 AD 30 03                 .0.
        sta     $02                             ; E717 85 02                    ..
        lda     $0348                           ; E719 AD 48 03                 .H.
        sta     $03                             ; E71C 85 03                    ..
LE71E:  jsr     entity_move_left_collide                           ; E71E 20 0C E9                  ..
        cpx     #$00                            ; E721 E0 00                    ..
        bne     LE738                           ; E723 D0 13                    ..
        jsr     LEDF6                           ; E725 20 F6 ED                  ..
        bcc     LE738                           ; E728 90 0E                    ..
        jsr     LEF29                           ; E72A 20 29 EF                  ).
        jsr     LE732                           ; E72D 20 32 E7                  2.
        sec                                     ; E730 38                       8
        rts                                     ; E731 60                       `

; ----------------------------------------------------------------------------
LE732:  bcs     LE738                           ; E732 B0 04                    ..
        dey                                     ; E734 88                       .
        jmp     LE6F9                           ; E735 4C F9 E6                 L..

; ----------------------------------------------------------------------------
LE738:  jsr     tile_collide_vert                           ; E738 20 AA C5                  ..
        clc                                     ; E73B 18                       .
        lda     $10                             ; E73C A5 10                    ..
        and     #$10                            ; E73E 29 10                    ).
        beq     LE746                           ; E740 F0 04                    ..
        jsr     LEEC7                           ; E742 20 C7 EE                  ..
        sec                                     ; E745 38                       8
LE746:  rts                                     ; E746 60                       `

; ----------------------------------------------------------------------------
LE747:  cpx     #$00                            ; E747 E0 00                    ..
        bne     LE755                           ; E749 D0 0A                    ..
        lda     $0378                           ; E74B AD 78 03                 .x.
        sta     $02                             ; E74E 85 02                    ..
        lda     $0390                           ; E750 AD 90 03                 ...
        sta     $03                             ; E753 85 03                    ..
LE755:  jsr     entity_move_down_collide                           ; E755 20 2A E9                  *.
        cpx     #$00                            ; E758 E0 00                    ..
        bne     LE771                           ; E75A D0 15                    ..
        jsr     LED8F                           ; E75C 20 8F ED                  ..
        bcc     LE771                           ; E75F 90 10                    ..
        jsr     LEF4A                           ; E761 20 4A EF                  J.
        jsr     LE769                           ; E764 20 69 E7                  i.
        sec                                     ; E767 38                       8
        rts                                     ; E768 60                       `

; ----------------------------------------------------------------------------
LE769:  bcc     LE771                           ; E769 90 06                    ..
        beq     LE771                           ; E76B F0 04                    ..
        iny                                     ; E76D C8                       .
        jmp     collide_horiz_solid                           ; E76E 4C A8 E7                 L..

; ----------------------------------------------------------------------------
LE771:  jsr     tile_collide_horiz                           ; E771 20 A1 C4                  ..
        clc                                     ; E774 18                       .
        lda     $10                             ; E775 A5 10                    ..
        and     #$10                            ; E777 29 10                    ).
        beq     LE77F                           ; E779 F0 04                    ..
        jsr     LEEF7                           ; E77B 20 F7 EE                  ..
        sec                                     ; E77E 38                       8
LE77F:  rts                                     ; E77F 60                       `

; ----------------------------------------------------------------------------
entity_move_up:  cpx     #$00                            ; E780 E0 00                    ..
        bne     LE78E                           ; E782 D0 0A                    ..
        lda     $0378                           ; E784 AD 78 03                 .x.
        sta     $02                             ; E787 85 02                    ..
        lda     $0390                           ; E789 AD 90 03                 ...
        sta     $03                             ; E78C 85 03                    ..
LE78E:  jsr     entity_move_up_nofacing                           ; E78E 20 4A E9                  J.
        cpx     #$00                            ; E791 E0 00                    ..
        bne     collide_horiz_solid                           ; E793 D0 13                    ..
        jsr     LED8F                           ; E795 20 8F ED                  ..
        bcc     collide_horiz_solid                           ; E798 90 0E                    ..
        jsr     LEF60                           ; E79A 20 60 EF                  `.
        jsr     LE7A2                           ; E79D 20 A2 E7                  ..
        sec                                     ; E7A0 38                       8
        rts                                     ; E7A1 60                       `

; ----------------------------------------------------------------------------
LE7A2:  bcs     collide_horiz_solid                           ; E7A2 B0 04                    ..
        dey                                     ; E7A4 88                       .
        jmp     LE771                           ; E7A5 4C 71 E7                 Lq.

; ----------------------------------------------------------------------------
collide_horiz_solid:  jsr     tile_collide_horiz                           ; E7A8 20 A1 C4                  ..
        clc                                     ; E7AB 18                       .
        lda     $10                             ; E7AC A5 10                    ..
        and     #$10                            ; E7AE 29 10                    ).
        beq     LE7B6                           ; E7B0 F0 04                    ..
        jsr     LEEDD                           ; E7B2 20 DD EE                  ..
        sec                                     ; E7B5 38                       8
LE7B6:  rts                                     ; E7B6 60                       `

; ----------------------------------------------------------------------------
; --- $E7B7: gravity + fall + landing (player: gravity_flip-aware) -----------
entity_gravity_collide:
        cpx     #$00                            ; E7B7 E0 00                    ..
        bne     LE7CF                           ; E7B9 D0 14                    ..
        stx     $04C8                           ; E7BB 8E C8 04                 ...
        lda     $0378                           ; E7BE AD 78 03                 .x.
        sta     $02                             ; E7C1 85 02                    ..
        lda     $0390                           ; E7C3 AD 90 03                 ...
        sta     $03                             ; E7C6 85 03                    ..
        lda     $AF                             ; E7C8 A5 AF                    ..
        beq     LE7CF                           ; E7CA F0 03                    ..
        jmp     LE872                           ; E7CC 4C 72 E8                 Lr.

; ----------------------------------------------------------------------------
LE7CF:  lda     $03F0,x                         ; E7CF BD F0 03                 ...
        bpl     LE840                           ; E7D2 10 6C                    .l
        jsr     LE979                           ; E7D4 20 79 E9                  y.
        cpx     #$00                            ; E7D7 E0 00                    ..
        bne     LE81C                           ; E7D9 D0 41                    .A
        jsr     LED8F                           ; E7DB 20 8F ED                  ..
        bcc     LE81C                           ; E7DE 90 3C                    .<
        jsr     LEF4A                           ; E7E0 20 4A EF                  J.
        jsr     LE814                           ; E7E3 20 14 E8                  ..
        ldy     $73                             ; E7E6 A4 73                    .s
        lda     $0300,y                         ; E7E8 B9 00 03                 ...
        cmp     #$45                            ; E7EB C9 45                    .E
        bne     LE7F4                           ; E7ED D0 05                    ..
        sty     $04C8                           ; E7EF 8C C8 04                 ...
        beq     LE83C                           ; E7F2 F0 48                    .H
LE7F4:  lda     $03F0,y                         ; E7F4 B9 F0 03                 ...
        bpl     LE808                           ; E7F7 10 0F                    ..
        sta     $03F0                           ; E7F9 8D F0 03                 ...
        dec     $03F0                           ; E7FC CE F0 03                 ...
        lda     $03D8,y                         ; E7FF B9 D8 03                 ...
        sta     $03D8                           ; E802 8D D8 03                 ...
        jmp     LE83C                           ; E805 4C 3C E8                 L<.

; ----------------------------------------------------------------------------
LE808:  lda     #$00                            ; E808 A9 00                    ..
        sta     $03D8,x                         ; E80A 9D D8 03                 ...
        lda     #$FD                            ; E80D A9 FD                    ..
        sta     $03F0,x                         ; E80F 9D F0 03                 ...
        bne     LE83C                           ; E812 D0 28                    .(
LE814:  bcc     LE81C                           ; E814 90 06                    ..
        beq     LE81C                           ; E816 F0 04                    ..
        iny                                     ; E818 C8                       .
        jmp     collide_horiz_solid                           ; E819 4C A8 E7                 L..

; ----------------------------------------------------------------------------
LE81C:  jsr     LE9B7                           ; E81C 20 B7 E9                  ..
        jsr     tile_collide_horiz                           ; E81F 20 A1 C4                  ..
        lda     $42                             ; E822 A5 42                    .B
        cmp     #$40                            ; E824 C9 40                    .@
        bne     LE830                           ; E826 D0 08                    ..
        lda     $11                             ; E828 A5 11                    ..
        and     #$0F                            ; E82A 29 0F                    ).
        cmp     #$08                            ; E82C C9 08                    ..
        bcc     LE836                           ; E82E 90 06                    ..
LE830:  lda     $10                             ; E830 A5 10                    ..
        and     #$10                            ; E832 29 10                    ).
        beq     LE870                           ; E834 F0 3A                    .:
LE836:  jsr     LEEF7                           ; E836 20 F7 EE                  ..
        jsr     entity_stop_y                           ; E839 20 1E EA                  ..
LE83C:  lda     #$00                            ; E83C A9 00                    ..
        sec                                     ; E83E 38                       8
        rts                                     ; E83F 60                       `

; ----------------------------------------------------------------------------
LE840:  iny                                     ; E840 C8                       .
        jsr     entity_apply_yvel_up                           ; E841 20 99 E9                  ..
        cpx     #$00                            ; E844 E0 00                    ..
        bne     LE85C                           ; E846 D0 14                    ..
        jsr     LED8F                           ; E848 20 8F ED                  ..
        bcc     LE85C                           ; E84B 90 0F                    ..
        jsr     LEF60                           ; E84D 20 60 EF                  `.
        jsr     LE856                           ; E850 20 56 E8                  V.
        jmp     LE86B                           ; E853 4C 6B E8                 Lk.

; ----------------------------------------------------------------------------
LE856:  bcs     LE85C                           ; E856 B0 04                    ..
        dey                                     ; E858 88                       .
        jmp     LE771                           ; E859 4C 71 E7                 Lq.

; ----------------------------------------------------------------------------
LE85C:  jsr     LE9B7                           ; E85C 20 B7 E9                  ..
        jsr     tile_collide_horiz                           ; E85F 20 A1 C4                  ..
        lda     $10                             ; E862 A5 10                    ..
        and     #$10                            ; E864 29 10                    ).
        beq     LE870                           ; E866 F0 08                    ..
        jsr     LEEDD                           ; E868 20 DD EE                  ..
LE86B:  jsr     entity_stop_y                           ; E86B 20 1E EA                  ..
        lda     #$FF                            ; E86E A9 FF                    ..
LE870:  clc                                     ; E870 18                       .
        rts                                     ; E871 60                       `

; ----------------------------------------------------------------------------
LE872:  lda     $03F0,x                         ; E872 BD F0 03                 ...
        bpl     LE8A4                           ; E875 10 2D                    .-
        jsr     LE979                           ; E877 20 79 E9                  y.
        jsr     LED8F                           ; E87A 20 8F ED                  ..
        bcc     LE890                           ; E87D 90 11                    ..
        jsr     LEF4A                           ; E87F 20 4A EF                  J.
        jsr     LE888                           ; E882 20 88 E8                  ..
        jmp     LE89F                           ; E885 4C 9F E8                 L..

; ----------------------------------------------------------------------------
LE888:  bcc     LE890                           ; E888 90 06                    ..
        beq     LE890                           ; E88A F0 04                    ..
        iny                                     ; E88C C8                       .
        jmp     collide_horiz_solid                           ; E88D 4C A8 E7                 L..

; ----------------------------------------------------------------------------
LE890:  jsr     entity_apply_gravity                           ; E890 20 E1 E9                  ..
        jsr     tile_collide_horiz                           ; E893 20 A1 C4                  ..
        lda     $10                             ; E896 A5 10                    ..
        and     #$10                            ; E898 29 10                    ).
        beq     LE8A2                           ; E89A F0 06                    ..
        jsr     LEEF7                           ; E89C 20 F7 EE                  ..
LE89F:  jsr     entity_yvel_down1                           ; E89F 20 29 EA                  ).
LE8A2:  clc                                     ; E8A2 18                       .
        rts                                     ; E8A3 60                       `

; ----------------------------------------------------------------------------
LE8A4:  iny                                     ; E8A4 C8                       .
        jsr     entity_apply_yvel_up                           ; E8A5 20 99 E9                  ..
        jsr     LED8F                           ; E8A8 20 8F ED                  ..
        bcc     LE8BC                           ; E8AB 90 0F                    ..
        jsr     LEF60                           ; E8AD 20 60 EF                  `.
        jsr     LE8B6                           ; E8B0 20 B6 E8                  ..
        jmp     LE8D9                           ; E8B3 4C D9 E8                 L..

; ----------------------------------------------------------------------------
LE8B6:  bcs     LE8BC                           ; E8B6 B0 04                    ..
        dey                                     ; E8B8 88                       .
        jmp     LE771                           ; E8B9 4C 71 E7                 Lq.

; ----------------------------------------------------------------------------
LE8BC:  jsr     entity_apply_gravity                           ; E8BC 20 E1 E9                  ..
        jsr     tile_collide_horiz                           ; E8BF 20 A1 C4                  ..
        lda     $42                             ; E8C2 A5 42                    .B
        cmp     #$40                            ; E8C4 C9 40                    .@
        bne     LE8D0                           ; E8C6 D0 08                    ..
        lda     $11                             ; E8C8 A5 11                    ..
        and     #$0F                            ; E8CA 29 0F                    ).
        cmp     #$08                            ; E8CC C9 08                    ..
        bcs     LE8D6                           ; E8CE B0 06                    ..
LE8D0:  lda     $10                             ; E8D0 A5 10                    ..
        and     #$10                            ; E8D2 29 10                    ).
        beq     LE8A2                           ; E8D4 F0 CC                    ..
LE8D6:  jsr     LEEDD                           ; E8D6 20 DD EE                  ..
LE8D9:  jsr     entity_yvel_down1                           ; E8D9 20 29 EA                  ).
        sec                                     ; E8DC 38                       8
        rts                                     ; E8DD 60                       `

; ----------------------------------------------------------------------------
        lda     $0528,x                         ; E8DE BD 28 05                 .(.
        ora     #$20                            ; E8E1 09 20                    . 
        sta     $0528,x                         ; E8E3 9D 28 05                 .(.
entity_move_right_collide:  lda     $0318,x                         ; E8E6 BD 18 03                 ...
        clc                                     ; E8E9 18                       .
        adc     $03A8,x                         ; E8EA 7D A8 03                 }..
        sta     $0318,x                         ; E8ED 9D 18 03                 ...
        lda     $0330,x                         ; E8F0 BD 30 03                 .0.
        adc     $03C0,x                         ; E8F3 7D C0 03                 }..
        sta     $0330,x                         ; E8F6 9D 30 03                 .0.
        bcc     LE903                           ; E8F9 90 08                    ..
        lda     $0348,x                         ; E8FB BD 48 03                 .H.
        adc     #$00                            ; E8FE 69 00                    i.
        sta     $0348,x                         ; E900 9D 48 03                 .H.
LE903:  rts                                     ; E903 60                       `

; ----------------------------------------------------------------------------
        lda     $0528,x                         ; E904 BD 28 05                 .(.
        and     #$DF                            ; E907 29 DF                    ).
        sta     $0528,x                         ; E909 9D 28 05                 .(.
entity_move_left_collide:  lda     $0318,x                         ; E90C BD 18 03                 ...
        sec                                     ; E90F 38                       8
        sbc     $03A8,x                         ; E910 FD A8 03                 ...
        sta     $0318,x                         ; E913 9D 18 03                 ...
        lda     $0330,x                         ; E916 BD 30 03                 .0.
        sbc     $03C0,x                         ; E919 FD C0 03                 ...
        sta     $0330,x                         ; E91C 9D 30 03                 .0.
        bcs     LE929                           ; E91F B0 08                    ..
        lda     $0348,x                         ; E921 BD 48 03                 .H.
        sbc     #$00                            ; E924 E9 00                    ..
        sta     $0348,x                         ; E926 9D 48 03                 .H.
LE929:  rts                                     ; E929 60                       `

; ----------------------------------------------------------------------------
entity_move_down_collide:  lda     $0360,x                         ; E92A BD 60 03                 .`.
        clc                                     ; E92D 18                       .
        adc     $03D8,x                         ; E92E 7D D8 03                 }..
        sta     $0360,x                         ; E931 9D 60 03                 .`.
        lda     $0378,x                         ; E934 BD 78 03                 .x.
        adc     $03F0,x                         ; E937 7D F0 03                 }..
        sta     $0378,x                         ; E93A 9D 78 03                 .x.
        cmp     #$F0                            ; E93D C9 F0                    ..
        bcc     LE949                           ; E93F 90 08                    ..
        adc     #$0F                            ; E941 69 0F                    i.
        sta     $0378,x                         ; E943 9D 78 03                 .x.
        inc     $0390,x                         ; E946 FE 90 03                 ...
LE949:  rts                                     ; E949 60                       `

; ----------------------------------------------------------------------------
entity_move_up_nofacing:  lda     $0360,x                         ; E94A BD 60 03                 .`.
        sec                                     ; E94D 38                       8
        sbc     $03D8,x                         ; E94E FD D8 03                 ...
        sta     $0360,x                         ; E951 9D 60 03                 .`.
        lda     $0378,x                         ; E954 BD 78 03                 .x.
        sbc     $03F0,x                         ; E957 FD F0 03                 ...
        sta     $0378,x                         ; E95A 9D 78 03                 .x.
        bcs     LE967                           ; E95D B0 08                    ..
        sbc     #$0F                            ; E95F E9 0F                    ..
        sta     $0378,x                         ; E961 9D 78 03                 .x.
        dec     $0390,x                         ; E964 DE 90 03                 ...
LE967:  rts                                     ; E967 60                       `

; ----------------------------------------------------------------------------
entity_process_y_vel:
        lda     $03F0,x                         ; E968 BD F0 03                 ...
        bpl     LE973                           ; E96B 10 06                    ..
        jsr     LE979                           ; E96D 20 79 E9                  y.
        jmp     LE9B7                           ; E970 4C B7 E9                 L..

; ----------------------------------------------------------------------------
LE973:  jsr     entity_apply_yvel_up                           ; E973 20 99 E9                  ..
        jmp     LE9B7                           ; E976 4C B7 E9                 L..

; ----------------------------------------------------------------------------
LE979:  lda     $0360,x                         ; E979 BD 60 03                 .`.
        sec                                     ; E97C 38                       8
        sbc     $03D8,x                         ; E97D FD D8 03                 ...
        sta     $0360,x                         ; E980 9D 60 03                 .`.
        lda     $0378,x                         ; E983 BD 78 03                 .x.
        sbc     $03F0,x                         ; E986 FD F0 03                 ...
        sta     $0378,x                         ; E989 9D 78 03                 .x.
        cmp     #$F0                            ; E98C C9 F0                    ..
        bcc     LE998                           ; E98E 90 08                    ..
        adc     #$0F                            ; E990 69 0F                    i.
        sta     $0378,x                         ; E992 9D 78 03                 .x.
        inc     $0390,x                         ; E995 FE 90 03                 ...
LE998:  rts                                     ; E998 60                       `

; ----------------------------------------------------------------------------
entity_apply_yvel_up:  lda     $0360,x                         ; E999 BD 60 03                 .`.
        sec                                     ; E99C 38                       8
        sbc     $03D8,x                         ; E99D FD D8 03                 ...
        sta     $0360,x                         ; E9A0 9D 60 03                 .`.
        lda     $0378,x                         ; E9A3 BD 78 03                 .x.
        sbc     $03F0,x                         ; E9A6 FD F0 03                 ...
        sta     $0378,x                         ; E9A9 9D 78 03                 .x.
        bcs     LE9B6                           ; E9AC B0 08                    ..
        sbc     #$0F                            ; E9AE E9 0F                    ..
        sta     $0378,x                         ; E9B0 9D 78 03                 .x.
        dec     $0390,x                         ; E9B3 DE 90 03                 ...
LE9B6:  rts                                     ; E9B6 60                       `

; ----------------------------------------------------------------------------
LE9B7:  lda     $52                             ; E9B7 A5 52                    .R
        beq     LE9BF                           ; E9B9 F0 04                    ..
        cpx     #$00                            ; E9BB E0 00                    ..
        beq     LE9E0                           ; E9BD F0 21                    .!
LE9BF:  lda     $03D8,x                         ; E9BF BD D8 03                 ...
        sec                                     ; E9C2 38                       8
        sbc     $A1                             ; E9C3 E5 A1                    ..
        sta     $03D8,x                         ; E9C5 9D D8 03                 ...
        lda     $03F0,x                         ; E9C8 BD F0 03                 ...
        sbc     #$00                            ; E9CB E9 00                    ..
        sta     $03F0,x                         ; E9CD 9D F0 03                 ...
        bpl     LE9E0                           ; E9D0 10 0E                    ..
        cmp     #$F9                            ; E9D2 C9 F9                    ..
        bcs     LE9E0                           ; E9D4 B0 0A                    ..
        lda     #$F9                            ; E9D6 A9 F9                    ..
        sta     $03F0,x                         ; E9D8 9D F0 03                 ...
        lda     #$00                            ; E9DB A9 00                    ..
        sta     $03D8,x                         ; E9DD 9D D8 03                 ...
LE9E0:  rts                                     ; E9E0 60                       `

; ----------------------------------------------------------------------------
entity_apply_gravity:  lda     $03D8,x                         ; E9E1 BD D8 03                 ...
        clc                                     ; E9E4 18                       .
        adc     $A1                             ; E9E5 65 A1                    e.
        sta     $03D8,x                         ; E9E7 9D D8 03                 ...
        lda     $03F0,x                         ; E9EA BD F0 03                 ...
        adc     #$00                            ; E9ED 69 00                    i.
        sta     $03F0,x                         ; E9EF 9D F0 03                 ...
        bmi     LEA02                           ; E9F2 30 0E                    0.
        cmp     #$07                            ; E9F4 C9 07                    ..
        bcc     LEA02                           ; E9F6 90 0A                    ..
        lda     #$07                            ; E9F8 A9 07                    ..
        sta     $03F0,x                         ; E9FA 9D F0 03                 ...
        lda     #$00                            ; E9FD A9 00                    ..
        sta     $03D8,x                         ; E9FF 9D D8 03                 ...
LEA02:  rts                                     ; EA02 60                       `

; ----------------------------------------------------------------------------
        lda     $03D8,x                         ; EA03 BD D8 03                 ...
        clc                                     ; EA06 18                       .
        adc     #$40                            ; EA07 69 40                    i@
        sta     $03D8,x                         ; EA09 9D D8 03                 ...
        lda     $03F0,x                         ; EA0C BD F0 03                 ...
        adc     #$00                            ; EA0F 69 00                    i.
        sta     $03F0,x                         ; EA11 9D F0 03                 ...
        cmp     #$0F                            ; EA14 C9 0F                    ..
        bne     LEA1D                           ; EA16 D0 05                    ..
        lda     #$00                            ; EA18 A9 00                    ..
        sta     $03D8,x                         ; EA1A 9D D8 03                 ...
LEA1D:  rts                                     ; EA1D 60                       `

; ----------------------------------------------------------------------------
entity_stop_y:  lda     #$00                            ; EA1E A9 00                    ..
        sta     $03D8,x                         ; EA20 9D D8 03                 ...
        lda     #$FF                            ; EA23 A9 FF                    ..
        sta     $03F0,x                         ; EA25 9D F0 03                 ...
        rts                                     ; EA28 60                       `

; ----------------------------------------------------------------------------
entity_yvel_down1:  lda     #$00                            ; EA29 A9 00                    ..
        sta     $03D8,x                         ; EA2B 9D D8 03                 ...
        lda     #$01                            ; EA2E A9 01                    ..
        sta     $03F0,x                         ; EA30 9D F0 03                 ...
        rts                                     ; EA33 60                       `

; ----------------------------------------------------------------------------
; --- $EA34: slot Y yvel = -0.25 (weak upward nudge) --------------------------
entity_yvel_neg_y:
        lda     #$C0                            ; EA34 A9 C0                    ..
        sta     $03D8,y                         ; EA36 99 D8 03                 ...
        lda     #$FF                            ; EA39 A9 FF                    ..
        sta     $03F0,y                         ; EA3B 99 F0 03                 ...
        rts                                     ; EA3E 60                       `

; ----------------------------------------------------------------------------
; --- $EA3F: dispatch left/right movement by dir bits 0-1 ---------------------
entity_horiz_dispatch:
        lda     $0420,x                         ; EA3F BD 20 04                 . .
        clc                                     ; EA42 18                       .
        and     #$03                            ; EA43 29 03                    ).
        beq     LEA97                           ; EA45 F0 50                    .P
        and     #$01                            ; EA47 29 01                    ).
        beq     LEA4E                           ; EA49 F0 03                    ..
        jmp     entity_move_right                           ; EA4B 4C C7 E6                 L..

; ----------------------------------------------------------------------------
LEA4E:  iny                                     ; EA4E C8                       .
        jmp     entity_move_left                           ; EA4F 4C 08 E7                 L..

; ----------------------------------------------------------------------------
entity_vert_dispatch:
        clc                                     ; EA52 18                       .
        lda     $0420,x                         ; EA53 BD 20 04                 . .
        and     #$0C                            ; EA56 29 0C                    ).
        beq     LEA97                           ; EA58 F0 3D                    .=
        and     #$04                            ; EA5A 29 04                    ).
        beq     LEA61                           ; EA5C F0 03                    ..
        jmp     LE747                           ; EA5E 4C 47 E7                 LG.

; ----------------------------------------------------------------------------
LEA61:  iny                                     ; EA61 C8                       .
        jmp     entity_move_up                           ; EA62 4C 80 E7                 L..

; ----------------------------------------------------------------------------
entity_facing_dispatch:
        lda     $0420,x                         ; EA65 BD 20 04                 . .
        and     #$03                            ; EA68 29 03                    ).
        beq     LEA97                           ; EA6A F0 2B                    .+
        and     #$01                            ; EA6C 29 01                    ).
        beq     LEA7B                           ; EA6E F0 0B                    ..
        lda     $0528,x                         ; EA70 BD 28 05                 .(.
        ora     #$20                            ; EA73 09 20                    . 
        sta     $0528,x                         ; EA75 9D 28 05                 .(.
        jmp     entity_move_right_collide                           ; EA78 4C E6 E8                 L..

; ----------------------------------------------------------------------------
LEA7B:  lda     $0528,x                         ; EA7B BD 28 05                 .(.
        and     #$DF                            ; EA7E 29 DF                    ).
        sta     $0528,x                         ; EA80 9D 28 05                 .(.
        jmp     entity_move_left_collide                           ; EA83 4C 0C E9                 L..

; ----------------------------------------------------------------------------
entity_vert_dispatch_raw:
        lda     $0420,x                         ; EA86 BD 20 04                 . .
        and     #$0C                            ; EA89 29 0C                    ).
        beq     LEA97                           ; EA8B F0 0A                    ..
        and     #$04                            ; EA8D 29 04                    ).
        beq     LEA94                           ; EA8F F0 03                    ..
        jmp     entity_move_down_collide                           ; EA91 4C 2A E9                 L*.

; ----------------------------------------------------------------------------
LEA94:  jmp     entity_move_up_nofacing                           ; EA94 4C 4A E9                 LJ.

; ----------------------------------------------------------------------------
LEA97:  rts                                     ; EA97 60                       `

; ----------------------------------------------------------------------------
entity_set_subtype:  sta     $0558,x                         ; EA98 9D 58 05                 .X.
        lda     #$00                            ; EA9B A9 00                    ..
        sta     $0540,x                         ; EA9D 9D 40 05                 .@.
        sta     $0570,x                         ; EAA0 9D 70 05                 .p.
        rts                                     ; EAA3 60                       `

; ----------------------------------------------------------------------------
entity_init_pos:
        pha                                     ; EAA4 48                       H
        lda     $0330,x                         ; EAA5 BD 30 03                 .0.
        sta     $0330,y                         ; EAA8 99 30 03                 .0.
        lda     $0348,x                         ; EAAB BD 48 03                 .H.
        sta     $0348,y                         ; EAAE 99 48 03                 .H.
        lda     $0378,x                         ; EAB1 BD 78 03                 .x.
        sta     $0378,y                         ; EAB4 99 78 03                 .x.
        lda     $0390,x                         ; EAB7 BD 90 03                 ...
        sta     $0390,y                         ; EABA 99 90 03                 ...
LEABD:  lda     $0528,x                         ; EABD BD 28 05                 .(.
        and     #$60                            ; EAC0 29 60                    )`
        sta     $0528,y                         ; EAC2 99 28 05                 .(.
        lda     #$00                            ; EAC5 A9 00                    ..
        sta     $0318,y                         ; EAC7 99 18 03                 ...
        sta     $0360,y                         ; EACA 99 60 03                 .`.
        sta     $05B8,y                         ; EACD 99 B8 05                 ...
        sta     $0468,y                         ; EAD0 99 68 04                 .h.
        sta     $0480,y                         ; EAD3 99 80 04                 ...
        sta     $0498,y                         ; EAD6 99 98 04                 ...
        sta     $04B0,y                         ; EAD9 99 B0 04                 ...
        sta     $04C8,y                         ; EADC 99 C8 04                 ...
        sta     $04E0,y                         ; EADF 99 E0 04                 ...
        sta     $04F8,y                         ; EAE2 99 F8 04                 ...
        sta     $0510,y                         ; EAE5 99 10 05                 ...
        pla                                     ; EAE8 68                       h
entity_init_subtype_y:
        sta     $0558,y                         ; EAE9 99 58 05                 .X.
        lda     #$00                            ; EAEC A9 00                    ..
        sta     $0540,y                         ; EAEE 99 40 05                 .@.
        sta     $0570,y                         ; EAF1 99 70 05                 .p.
        rts                                     ; EAF4 60                       `

; ----------------------------------------------------------------------------
; --- $EAF5: load velocity preset $10 from speed_px/sub tables ----------------
entity_speed_preset:
        pha                                     ; EAF5 48                       H
        stx     L0000                           ; EAF6 86 00                    ..
        ldx     $10                             ; EAF8 A6 10                    ..
        lda     #$00                            ; EAFA A9 00                    ..
        sta     $02                             ; EAFC 85 02                    ..
        lda     speed_px_tbl,x                         ; EAFE BD 62 EB                 .b.
        sta     $01                             ; EB01 85 01                    ..
        bpl     LEB07                           ; EB03 10 02                    ..
        dec     $02                             ; EB05 C6 02                    ..
LEB07:  lda     speed_sub_tbl,x                         ; EB07 BD BC EB                 ...
        sta     $03                             ; EB0A 85 03                    ..
        ldx     L0000                           ; EB0C A6 00                    ..
        lda     $0330,x                         ; EB0E BD 30 03                 .0.
        clc                                     ; EB11 18                       .
        adc     $01                             ; EB12 65 01                    e.
        sta     $0330,y                         ; EB14 99 30 03                 .0.
        lda     $0348,x                         ; EB17 BD 48 03                 .H.
        adc     $02                             ; EB1A 65 02                    e.
        sta     $0348,y                         ; EB1C 99 48 03                 .H.
        lda     $0390,x                         ; EB1F BD 90 03                 ...
        sta     $0390,y                         ; EB22 99 90 03                 ...
        lda     $0378,x                         ; EB25 BD 78 03                 .x.
        clc                                     ; EB28 18                       .
        adc     $03                             ; EB29 65 03                    e.
        sta     $0378,y                         ; EB2B 99 78 03                 .x.
        lda     $03                             ; EB2E A5 03                    ..
        bpl     LEB48                           ; EB30 10 16                    ..
        bcs     LEABD                           ; EB32 B0 89                    ..
        lda     $0378,y                         ; EB34 B9 78 03                 .x.
        sbc     #$10                            ; EB37 E9 10                    ..
        sta     $0378,y                         ; EB39 99 78 03                 .x.
        lda     $0390,y                         ; EB3C B9 90 03                 ...
        sec                                     ; EB3F 38                       8
        sbc     #$01                            ; EB40 E9 01                    ..
        sta     $0390,y                         ; EB42 99 90 03                 ...
        jmp     LEABD                           ; EB45 4C BD EA                 L..

; ----------------------------------------------------------------------------
LEB48:  lda     $0378,y                         ; EB48 B9 78 03                 .x.
        bcs     LEB51                           ; EB4B B0 04                    ..
        cmp     #$F0                            ; EB4D C9 F0                    ..
        bcc     LEB5F                           ; EB4F 90 0E                    ..
LEB51:  adc     #$0F                            ; EB51 69 0F                    i.
        sta     $0378,y                         ; EB53 99 78 03                 .x.
        lda     $0390,y                         ; EB56 B9 90 03                 ...
        clc                                     ; EB59 18                       .
        adc     #$01                            ; EB5A 69 01                    i.
        sta     $0390,y                         ; EB5C 99 90 03                 ...
LEB5F:  jmp     LEABD                           ; EB5F 4C BD EA                 L..

; ----------------------------------------------------------------------------
speed_px_tbl:  sbc     ($10),y                         ; EB62 F1 10                    ..
        .byte   $F4                             ; EB64 F4                       .
        .byte   $0C                             ; EB65 0C                       .
        bpl     LEB72                           ; EB66 10 0A                    ..
        brk                                     ; EB68 00                       .
        inc     $F0,x                           ; EB69 F6 F0                    ..
        brk                                     ; EB6B 00                       .
        beq     LEB7E                           ; EB6C F0 10                    ..
        brk                                     ; EB6E 00                       .
        brk                                     ; EB6F 00                       .
        .byte   $F4                             ; EB70 F4                       .
        .byte   $0C                             ; EB71 0C                       .
LEB72:  brk                                     ; EB72 00                       .
        .byte   $0C                             ; EB73 0C                       .
        .byte   $F4                             ; EB74 F4                       .
        beq     LEB87                           ; EB75 F0 10                    ..
        .byte   $F4                             ; EB77 F4                       .
        .byte   $0C                             ; EB78 0C                       .
        brk                                     ; EB79 00                       .
        brk                                     ; EB7A 00                       .
        beq     LEB8D                           ; EB7B F0 10                    ..
        .byte   $EC                             ; EB7D EC                       .
LEB7E:  .byte   $0C                             ; EB7E 0C                       .
        brk                                     ; EB7F 00                       .
        sbc     LFC07,y                         ; EB80 F9 07 FC                 ...
        sed                                     ; EB83 F8                       .
        .byte   $04                             ; EB84 04                       .
        php                                     ; EB85 08                       .
        .byte   $FC                             ; EB86 FC                       .
LEB87:  sed                                     ; EB87 F8                       .
        .byte   $04                             ; EB88 04                       .
        php                                     ; EB89 08                       .
        .byte   $F4                             ; EB8A F4                       .
        .byte   $0C                             ; EB8B 0C                       .
        .byte   $EC                             ; EB8C EC                       .
LEB8D:  .byte   $14                             ; EB8D 14                       .
        .byte   $F4                             ; EB8E F4                       .
        sed                                     ; EB8F F8                       .
        .byte   $02                             ; EB90 02                       .
        .byte   $0C                             ; EB91 0C                       .
        asl     $0C0E                           ; EB92 0E 0E 0C                 ...
        .byte   $02                             ; EB95 02                       .
        sed                                     ; EB96 F8                       .
        .byte   $F4                             ; EB97 F4                       .
        cpx     LE814                           ; EB98 EC 14 E8                 ...
        clc                                     ; EB9B 18                       .
        .byte   $FC                             ; EB9C FC                       .
        .byte   $04                             ; EB9D 04                       .
        cpx     #$20                            ; EB9E E0 20                    . 
        sbc     ($10),y                         ; EBA0 F1 10                    ..
        inx                                     ; EBA2 E8                       .
        clc                                     ; EBA3 18                       .
        .byte   $E2                             ; EBA4 E2                       .
        asl     $18E8,x                         ; EBA5 1E E8 18                 ...
        sed                                     ; EBA8 F8                       .
        php                                     ; EBA9 08                       .
        .byte   $10                             ; EBAA 10                       .
LEBAB:  brk                                     ; EBAB 00                       .
LEBAC:  beq     LEBAE                           ; EBAC F0 00                    ..
LEBAE:  brk                                     ; EBAE 00                       .
        inx                                     ; EBAF E8                       .
        clc                                     ; EBB0 18                       .
        sed                                     ; EBB1 F8                       .
        php                                     ; EBB2 08                       .
        cpx     $1C                             ; EBB3 E4 1C                    ..
        .byte   $F4                             ; EBB5 F4                       .
        .byte   $0C                             ; EBB6 0C                       .
        .byte   $FC                             ; EBB7 FC                       .
        .byte   $04                             ; EBB8 04                       .
        bpl     LEBAB                           ; EBB9 10 F0                    ..
        .byte   $10                             ; EBBB 10                       .
speed_sub_tbl:  .byte   $FF                             ; EBBC FF                       .
        .byte   $FF                             ; EBBD FF                       .
        php                                     ; EBBE 08                       .
        php                                     ; EBBF 08                       .
        asl     $1814                           ; EBC0 0E 14 18                 ...
        .byte   $14                             ; EBC3 14                       .
        asl     $0800                           ; EBC4 0E 00 08                 ...
        php                                     ; EBC7 08                       .
        .byte   $14                             ; EBC8 14                       .
        .byte   $EC                             ; EBC9 EC                       .
        .byte   $04                             ; EBCA 04                       .
LEBCB:  .byte   $04                             ; EBCB 04                       .
        brk                                     ; EBCC 00                       .
        .byte   $F4                             ; EBCD F4                       .
        .byte   $0C                             ; EBCE 0C                       .
        brk                                     ; EBCF 00                       .
        brk                                     ; EBD0 00                       .
        .byte   $F4                             ; EBD1 F4                       .
        .byte   $0C                             ; EBD2 0C                       .
        beq     LEBE5                           ; EBD3 F0 10                    ..
        bpl     LEBCB                           ; EBD5 10 F4                    ..
        beq     LEBE9                           ; EBD7 F0 10                    ..
        brk                                     ; EBD9 00                       .
        brk                                     ; EBDA 00                       .
        brk                                     ; EBDB 00                       .
        .byte   $FC                             ; EBDC FC                       .
        .byte   $04                             ; EBDD 04                       .
        .byte   $FC                             ; EBDE FC                       .
        .byte   $04                             ; EBDF 04                       .
        .byte   $04                             ; EBE0 04                       .
        .byte   $FC                             ; EBE1 FC                       .
        .byte   $04                             ; EBE2 04                       .
        .byte   $FC                             ; EBE3 FC                       .
        .byte   $FC                             ; EBE4 FC                       .
LEBE5:  .byte   $FC                             ; EBE5 FC                       .
        .byte   $FC                             ; EBE6 FC                       .
        .byte   $FC                             ; EBE7 FC                       .
        .byte   $02                             ; EBE8 02                       .
LEBE9:  .byte   $FA                             ; EBE9 FA                       .
        .byte   $F4                             ; EBEA F4                       .
        sed                                     ; EBEB F8                       .
        .byte   $02                             ; EBEC 02                       .
        inc     $0C08,x                         ; EBED FE 08 0C                 ...
        asl     $FE                             ; EBF0 06 FE                    ..
        .byte   $FF                             ; EBF2 FF                       .
        .byte   $FF                             ; EBF3 FF                       .
LEBF4:  .byte   $04                             ; EBF4 04                       .
        .byte   $04                             ; EBF5 04                       .
LEBF6:  cpx     #$E0                            ; EBF6 E0 E0                    ..
LEBF8:  .byte   $FA                             ; EBF8 FA                       .
        .byte   $FA                             ; EBF9 FA                       .
        php                                     ; EBFA 08                       .
        php                                     ; EBFB 08                       .
        brk                                     ; EBFC 00                       .
        brk                                     ; EBFD 00                       .
        brk                                     ; EBFE 00                       .
        brk                                     ; EBFF 00                       .
LEC00:  .byte   $0C                             ; EC00 0C                       .
        .byte   $0C                             ; EC01 0C                       .
        sed                                     ; EC02 F8                       .
        sed                                     ; EC03 F8                       .
        beq     LEBF6                           ; EC04 F0 F0                    ..
        beq     LEBF8                           ; EC06 F0 F0                    ..
        cpx     #$10                            ; EC08 E0 10                    ..
        bpl     LEBF4                           ; EC0A 10 E8                    ..
        inx                                     ; EC0C E8                       .
        .byte   $FA                             ; EC0D FA                       .
        .byte   $FA                             ; EC0E FA                       .
        inc     LF4FE,x                         ; EC0F FE FE F4                 ...
        .byte   $F4                             ; EC12 F4                       .
        .byte   $04                             ; EC13 04                       .
        .byte   $FA                             ; EC14 FA                       .
        .byte   $FA                             ; EC15 FA                       .
entity_set_facing:
        lda     #$01                            ; EC16 A9 01                    ..
        sta     $0420,x                         ; EC18 9D 20 04                 . .
        lda     $0330,x                         ; EC1B BD 30 03                 .0.
        sec                                     ; EC1E 38                       8
        sbc     $0330                           ; EC1F ED 30 03                 .0.
        lda     $0348,x                         ; EC22 BD 48 03                 .H.
        sbc     $0348                           ; EC25 ED 48 03                 .H.
        bcc     LEC2F                           ; EC28 90 05                    ..
        lda     #$02                            ; EC2A A9 02                    ..
        sta     $0420,x                         ; EC2C 9D 20 04                 . .
LEC2F:  rts                                     ; EC2F 60                       `

; ----------------------------------------------------------------------------
; --- $EC30: dir bits -> flags bit 5 (hflip; MM5 moved it from MM4's bit 6) ---
entity_facing_to_flags:
        lda     $0420,x                         ; EC30 BD 20 04                 . .
        and     #$03                            ; EC33 29 03                    ).
        beq     LEC49                           ; EC35 F0 12                    ..
        ror     a                               ; EC37 6A                       j
        ror     a                               ; EC38 6A                       j
        ror     a                               ; EC39 6A                       j
        ror     a                               ; EC3A 6A                       j
        and     #$20                            ; EC3B 29 20                    ) 
        sta     L0000                           ; EC3D 85 00                    ..
        lda     $0528,x                         ; EC3F BD 28 05                 .(.
        and     #$DF                            ; EC42 29 DF                    ).
        ora     L0000                           ; EC44 05 00                    ..
        sta     $0528,x                         ; EC46 9D 28 05                 .(.
LEC49:  rts                                     ; EC49 60                       `

; ----------------------------------------------------------------------------
entity_flip_direction:
        lda     $0420,x                         ; EC4A BD 20 04                 . .
        eor     #$03                            ; EC4D 49 03                    I.
        sta     $0420,x                         ; EC4F 9D 20 04                 . .
        lda     $0528,x                         ; EC52 BD 28 05                 .(.
        eor     #$20                            ; EC55 49 20                    I 
        sta     $0528,x                         ; EC57 9D 28 05                 .(.
        rts                                     ; EC5A 60                       `

; ----------------------------------------------------------------------------
queue_sound_param:  sta     $D9                             ; EC5B 85 D9                    ..
queue_sound:  stx     L0000                           ; EC5D 86 00                    ..
        ldx     $DA                             ; EC5F A6 DA                    ..
        sta     $01                             ; EC61 85 01                    ..
        lda     $DC,x                           ; EC63 B5 DC                    ..
        cmp     #$88                            ; EC65 C9 88                    ..
        bne     LEC73                           ; EC67 D0 0A                    ..
        lda     $01                             ; EC69 A5 01                    ..
        sta     $DC,x                           ; EC6B 95 DC                    ..
        inx                                     ; EC6D E8                       .
        txa                                     ; EC6E 8A                       .
        and     #$07                            ; EC6F 29 07                    ).
        sta     $DA                             ; EC71 85 DA                    ..
LEC73:  ldx     L0000                           ; EC73 A6 00                    ..
        rts                                     ; EC75 60                       `

; ----------------------------------------------------------------------------
entity_y_dist_abs:  lda     $0378                           ; EC76 AD 78 03                 .x.
        sec                                     ; EC79 38                       8
        sbc     $0378,x                         ; EC7A FD 78 03                 .x.
        bcs     LEC84                           ; EC7D B0 05                    ..
        eor     #$FF                            ; EC7F 49 FF                    I.
        adc     #$01                            ; EC81 69 01                    i.
        clc                                     ; EC83 18                       .
LEC84:  rts                                     ; EC84 60                       `

; ----------------------------------------------------------------------------
        lda     $0378,y                         ; EC85 B9 78 03                 .x.
        sec                                     ; EC88 38                       8
        sbc     $0378,x                         ; EC89 FD 78 03                 .x.
        bcs     LEC93                           ; EC8C B0 05                    ..
        eor     #$FF                            ; EC8E 49 FF                    I.
        adc     #$01                            ; EC90 69 01                    i.
        clc                                     ; EC92 18                       .
LEC93:  rts                                     ; EC93 60                       `

; ----------------------------------------------------------------------------
entity_x_dist_px:  lda     $0330                           ; EC94 AD 30 03                 .0.
        sec                                     ; EC97 38                       8
        sbc     $0330,x                         ; EC98 FD 30 03                 .0.
        pha                                     ; EC9B 48                       H
        lda     $0348                           ; EC9C AD 48 03                 .H.
        sbc     $0348,x                         ; EC9F FD 48 03                 .H.
        pla                                     ; ECA2 68                       h
        bcs     LECAA                           ; ECA3 B0 05                    ..
        eor     #$FF                            ; ECA5 49 FF                    I.
        adc     #$01                            ; ECA7 69 01                    i.
        clc                                     ; ECA9 18                       .
LECAA:  rts                                     ; ECAA 60                       `

; ----------------------------------------------------------------------------
        lda     $0330,y                         ; ECAB B9 30 03                 .0.
        sec                                     ; ECAE 38                       8
        sbc     $0330,x                         ; ECAF FD 30 03                 .0.
        pha                                     ; ECB2 48                       H
        lda     $0348,y                         ; ECB3 B9 48 03                 .H.
        sbc     $0348,x                         ; ECB6 FD 48 03                 .H.
        pla                                     ; ECB9 68                       h
        bcs     LECC1                           ; ECBA B0 05                    ..
        eor     #$FF                            ; ECBC 49 FF                    I.
        adc     #$01                            ; ECBE 69 01                    i.
        clc                                     ; ECC0 18                       .
LECC1:  rts                                     ; ECC1 60                       `

; ----------------------------------------------------------------------------
; --- $ECC2: full distance calculation from the player slot -------------------
entity_distance_calc:
        ldy     #$00                            ; ECC2 A0 00                    ..
entity_distance_from_y:  lda     $0378,y                         ; ECC4 B9 78 03                 .x.
        sta     L0000                           ; ECC7 85 00                    ..
        lda     $0330,y                         ; ECC9 B9 30 03                 .0.
        sta     $01                             ; ECCC 85 01                    ..
        lda     $0348,y                         ; ECCE B9 48 03                 .H.
        sta     $02                             ; ECD1 85 02                    ..
        ldy     #$00                            ; ECD3 A0 00                    ..
        lda     L0000                           ; ECD5 A5 00                    ..
        sec                                     ; ECD7 38                       8
        sbc     $0378,x                         ; ECD8 FD 78 03                 .x.
        ldy     #$00                            ; ECDB A0 00                    ..
        bcs     LECE5                           ; ECDD B0 06                    ..
        eor     #$FF                            ; ECDF 49 FF                    I.
        adc     #$01                            ; ECE1 69 01                    i.
        ldy     #$04                            ; ECE3 A0 04                    ..
LECE5:  sta     L0000                           ; ECE5 85 00                    ..
        lda     $01                             ; ECE7 A5 01                    ..
        sec                                     ; ECE9 38                       8
        sbc     $0330,x                         ; ECEA FD 30 03                 .0.
        pha                                     ; ECED 48                       H
        lda     $02                             ; ECEE A5 02                    ..
        sbc     $0348,x                         ; ECF0 FD 48 03                 .H.
        pla                                     ; ECF3 68                       h
        bcs     LECFC                           ; ECF4 B0 06                    ..
        eor     #$FF                            ; ECF6 49 FF                    I.
        adc     #$01                            ; ECF8 69 01                    i.
        iny                                     ; ECFA C8                       .
        iny                                     ; ECFB C8                       .
LECFC:  sta     $01                             ; ECFC 85 01                    ..
        cmp     L0000                           ; ECFE C5 00                    ..
        bcs     LED0B                           ; ED00 B0 09                    ..
        pha                                     ; ED02 48                       H
        lda     L0000                           ; ED03 A5 00                    ..
        sta     $01                             ; ED05 85 01                    ..
        pla                                     ; ED07 68                       h
        sta     L0000                           ; ED08 85 00                    ..
        iny                                     ; ED0A C8                       .
LED0B:  lda     #$00                            ; ED0B A9 00                    ..
        sta     $02                             ; ED0D 85 02                    ..
        lda     $01                             ; ED0F A5 01                    ..
        lsr     a                               ; ED11 4A                       J
        lsr     a                               ; ED12 4A                       J
        cmp     L0000                           ; ED13 C5 00                    ..
        bcs     LED20                           ; ED15 B0 09                    ..
        inc     $02                             ; ED17 E6 02                    ..
        asl     a                               ; ED19 0A                       .
        cmp     L0000                           ; ED1A C5 00                    ..
        bcs     LED20                           ; ED1C B0 02                    ..
        inc     $02                             ; ED1E E6 02                    ..
LED20:  tya                                     ; ED20 98                       .
        asl     a                               ; ED21 0A                       .
        asl     a                               ; ED22 0A                       .
        clc                                     ; ED23 18                       .
        adc     $02                             ; ED24 65 02                    e.
        tay                                     ; ED26 A8                       .
        lda     LED2B,y                         ; ED27 B9 2B ED                 .+.
        rts                                     ; ED2A 60                       `

; ----------------------------------------------------------------------------
LED2B:  .byte   $04                             ; ED2B 04                       .
        ora     $06                             ; ED2C 05 06                    ..
        .byte   $04                             ; ED2E 04                       .
        php                                     ; ED2F 08                       .
        .byte   $07                             ; ED30 07                       .
        asl     L0004                           ; ED31 06 04                    ..
        .byte   $0C                             ; ED33 0C                       .
        .byte   $0B                             ; ED34 0B                       .
        asl     a                               ; ED35 0A                       .
        .byte   $04                             ; ED36 04                       .
        php                                     ; ED37 08                       .
        ora     #$0A                            ; ED38 09 0A                    ..
        .byte   $04                             ; ED3A 04                       .
        .byte   $04                             ; ED3B 04                       .
        .byte   $03                             ; ED3C 03                       .
        .byte   $02                             ; ED3D 02                       .
        .byte   $04                             ; ED3E 04                       .
        brk                                     ; ED3F 00                       .
        ora     ($02,x)                         ; ED40 01 02                    ..
        .byte   $04                             ; ED42 04                       .
        .byte   $0C                             ; ED43 0C                       .
        ora     $040E                           ; ED44 0D 0E 04                 ...
        brk                                     ; ED47 00                       .
        .byte   $0F                             ; ED48 0F                       .
        .byte   $0E                             ; ED49 0E                       .
        .byte   $04                             ; ED4A 04                       .
dir_byte_tbl:  php                                     ; ED4B 08                       .
        ora     #$09                            ; ED4C 09 09                    ..
        ora     #$01                            ; ED4E 09 01                    ..
        ora     $05                             ; ED50 05 05                    ..
        ora     L0004                           ; ED52 05 04                    ..
        asl     $06                             ; ED54 06 06                    ..
        asl     $02                             ; ED56 06 02                    ..
        asl     a                               ; ED58 0A                       .
        asl     a                               ; ED59 0A                       .
        asl     a                               ; ED5A 0A                       .
        ldy     #$00                            ; ED5B A0 00                    ..
        jsr     entity_distance_from_y                           ; ED5D 20 C4 EC                  ..
        sta     L0000                           ; ED60 85 00                    ..
        tay                                     ; ED62 A8                       .
        lda     $04B0,x                         ; ED63 BD B0 04                 ...
        clc                                     ; ED66 18                       .
        adc     #$08                            ; ED67 69 08                    i.
        and     #$0F                            ; ED69 29 0F                    ).
        sec                                     ; ED6B 38                       8
        sbc     L0000                           ; ED6C E5 00                    ..
        and     #$0F                            ; ED6E 29 0F                    ).
        sec                                     ; ED70 38                       8
        sbc     #$08                            ; ED71 E9 08                    ..
        beq     LED7F                           ; ED73 F0 0A                    ..
        bcs     LED7C                           ; ED75 B0 05                    ..
        inc     $04B0,x                         ; ED77 FE B0 04                 ...
        bne     LED7F                           ; ED7A D0 03                    ..
LED7C:  dec     $04B0,x                         ; ED7C DE B0 04                 ...
LED7F:  lda     $04B0,x                         ; ED7F BD B0 04                 ...
        and     #$0F                            ; ED82 29 0F                    ).
        sta     $04B0,x                         ; ED84 9D B0 04                 ...
        tay                                     ; ED87 A8                       .
        lda     dir_byte_tbl,y                         ; ED88 B9 4B ED                 .K.
        sta     $0420,x                         ; ED8B 9D 20 04                 . .
        rts                                     ; ED8E 60                       `

; ----------------------------------------------------------------------------
LED8F:  lda     $0528,x                         ; ED8F BD 28 05                 .(.
        bpl     LEDF4                           ; ED92 10 60                    .`
        lda     $0390,x                         ; ED94 BD 90 03                 ...
        bne     LEDF4                           ; ED97 D0 5B                    .[
        sty     L0000                           ; ED99 84 00                    ..
        ldy     #$17                            ; ED9B A0 17                    ..
        sty     $73                             ; ED9D 84 73                    .s
LED9F:  lda     $0300,y                         ; ED9F B9 00 03                 ...
        beq     LEDEC                           ; EDA2 F0 48                    .H
        lda     $0390,y                         ; EDA4 B9 90 03                 ...
        bne     LEDEC                           ; EDA7 D0 43                    .C
        lda     $0528,y                         ; EDA9 B9 28 05                 .(.
        and     #$04                            ; EDAC 29 04                    ).
        bne     LEDEC                           ; EDAE D0 3C                    .<
        lda     $0528,y                         ; EDB0 B9 28 05                 .(.
        and     #$03                            ; EDB3 29 03                    ).
        beq     LEDEC                           ; EDB5 F0 35                    .5
        and     #$01                            ; EDB7 29 01                    ).
        beq     LEDC0                           ; EDB9 F0 05                    ..
        lda     $03F0,x                         ; EDBB BD F0 03                 ...
        bpl     LEDEC                           ; EDBE 10 2C                    .,
LEDC0:  jsr     LEE4F                           ; EDC0 20 4F EE                  O.
        bne     LEDEC                           ; EDC3 D0 27                    .'
        jsr     LEE70                           ; EDC5 20 70 EE                  p.
        bcc     LEDD1                           ; EDC8 90 07                    ..
        lda     $0528,y                         ; EDCA B9 28 05                 .(.
        and     #$01                            ; EDCD 29 01                    ).
        bne     LEDEC                           ; EDCF D0 1B                    ..
LEDD1:  lda     $10                             ; EDD1 A5 10                    ..
        cmp     $13                             ; EDD3 C5 13                    ..
        bcs     LEDEC                           ; EDD5 B0 15                    ..
        lda     $12                             ; EDD7 A5 12                    ..
        sec                                     ; EDD9 38                       8
        sbc     $11                             ; EDDA E5 11                    ..
        bcc     LEDEC                           ; EDDC 90 0E                    ..
        sta     $11                             ; EDDE 85 11                    ..
        cmp     #$08                            ; EDE0 C9 08                    ..
        bcc     LEDE8                           ; EDE2 90 04                    ..
        lda     #$08                            ; EDE4 A9 08                    ..
        sta     $11                             ; EDE6 85 11                    ..
LEDE8:  ldy     L0000                           ; EDE8 A4 00                    ..
        sec                                     ; EDEA 38                       8
        rts                                     ; EDEB 60                       `

; ----------------------------------------------------------------------------
LEDEC:  dec     $73                             ; EDEC C6 73                    .s
        ldy     $73                             ; EDEE A4 73                    .s
        bne     LED9F                           ; EDF0 D0 AD                    ..
        ldy     L0000                           ; EDF2 A4 00                    ..
LEDF4:  clc                                     ; EDF4 18                       .
        rts                                     ; EDF5 60                       `

; ----------------------------------------------------------------------------
LEDF6:  lda     $0528,x                         ; EDF6 BD 28 05                 .(.
        bpl     LEE4D                           ; EDF9 10 52                    .R
        lda     $0390,x                         ; EDFB BD 90 03                 ...
        bne     LEE4D                           ; EDFE D0 4D                    .M
        sty     L0000                           ; EE00 84 00                    ..
        ldy     #$17                            ; EE02 A0 17                    ..
        sty     $01                             ; EE04 84 01                    ..
LEE06:  lda     $0300,y                         ; EE06 B9 00 03                 ...
        beq     LEE45                           ; EE09 F0 3A                    .:
        cmp     #$02                            ; EE0B C9 02                    ..
        beq     LEE45                           ; EE0D F0 36                    .6
        lda     $0390,y                         ; EE0F B9 90 03                 ...
        bne     LEE45                           ; EE12 D0 31                    .1
        lda     $0528,y                         ; EE14 B9 28 05                 .(.
        and     #$04                            ; EE17 29 04                    ).
        bne     LEE45                           ; EE19 D0 2A                    .*
        lda     $0528,y                         ; EE1B B9 28 05                 .(.
        and     #$02                            ; EE1E 29 02                    ).
        beq     LEE45                           ; EE20 F0 23                    .#
        jsr     LEE4F                           ; EE22 20 4F EE                  O.
        bne     LEE45                           ; EE25 D0 1E                    ..
        jsr     LEE70                           ; EE27 20 70 EE                  p.
        lda     $11                             ; EE2A A5 11                    ..
        cmp     $12                             ; EE2C C5 12                    ..
        bcs     LEE45                           ; EE2E B0 15                    ..
        lda     $13                             ; EE30 A5 13                    ..
        sec                                     ; EE32 38                       8
        sbc     $10                             ; EE33 E5 10                    ..
        bcc     LEE45                           ; EE35 90 0E                    ..
        sta     $10                             ; EE37 85 10                    ..
        cmp     #$08                            ; EE39 C9 08                    ..
        bcc     LEE41                           ; EE3B 90 04                    ..
        lda     #$08                            ; EE3D A9 08                    ..
        sta     $10                             ; EE3F 85 10                    ..
LEE41:  ldy     L0000                           ; EE41 A4 00                    ..
        sec                                     ; EE43 38                       8
        rts                                     ; EE44 60                       `

; ----------------------------------------------------------------------------
LEE45:  dec     $01                             ; EE45 C6 01                    ..
        ldy     $01                             ; EE47 A4 01                    ..
        bne     LEE06                           ; EE49 D0 BB                    ..
        ldy     L0000                           ; EE4B A4 00                    ..
LEE4D:  clc                                     ; EE4D 18                       .
        rts                                     ; EE4E 60                       `

; ----------------------------------------------------------------------------
LEE4F:  lda     $0330                           ; EE4F AD 30 03                 .0.
        sec                                     ; EE52 38                       8
        sbc     $0330,y                         ; EE53 F9 30 03                 .0.
        sta     $10                             ; EE56 85 10                    ..
        lda     $0348                           ; EE58 AD 48 03                 .H.
        sbc     $0348,y                         ; EE5B F9 48 03                 .H.
        bcs     LEE6F                           ; EE5E B0 0F                    ..
        pha                                     ; EE60 48                       H
        lda     $10                             ; EE61 A5 10                    ..
        eor     #$FF                            ; EE63 49 FF                    I.
        adc     #$01                            ; EE65 69 01                    i.
        sta     $10                             ; EE67 85 10                    ..
        pla                                     ; EE69 68                       h
        eor     #$FF                            ; EE6A 49 FF                    I.
        adc     #$00                            ; EE6C 69 00                    i.
        clc                                     ; EE6E 18                       .
LEE6F:  rts                                     ; EE6F 60                       `

; ----------------------------------------------------------------------------
LEE70:  lda     $0408,y                         ; EE70 B9 08 04                 ...
        and     #$3F                            ; EE73 29 3F                    )?
        tax                                     ; EE75 AA                       .
        lda     LF0B1,x                         ; EE76 BD B1 F0                 ...
        sta     $12                             ; EE79 85 12                    ..
        lda     LF0F1,x                         ; EE7B BD F1 F0                 ...
        sta     $13                             ; EE7E 85 13                    ..
        lda     $30                             ; EE80 A5 30                    .0
        cmp     #$02                            ; EE82 C9 02                    ..
        bne     LEE8C                           ; EE84 D0 06                    ..
        lda     $12                             ; EE86 A5 12                    ..
        sbc     #$02                            ; EE88 E9 02                    ..
        sta     $12                             ; EE8A 85 12                    ..
LEE8C:  lda     $0378                           ; EE8C AD 78 03                 .x.
        sec                                     ; EE8F 38                       8
        sbc     $0378,y                         ; EE90 F9 78 03                 .x.
        bcs     LEE9A                           ; EE93 B0 05                    ..
        eor     #$FF                            ; EE95 49 FF                    I.
        adc     #$01                            ; EE97 69 01                    i.
        clc                                     ; EE99 18                       .
LEE9A:  sta     $11                             ; EE9A 85 11                    ..
        php                                     ; EE9C 08                       .
        bcc     LEEAB                           ; EE9D 90 0C                    ..
        lda     $30                             ; EE9F A5 30                    .0
        cmp     #$02                            ; EEA1 C9 02                    ..
        bne     LEEAB                           ; EEA3 D0 06                    ..
        lda     $12                             ; EEA5 A5 12                    ..
        sbc     #$04                            ; EEA7 E9 04                    ..
        sta     $12                             ; EEA9 85 12                    ..
LEEAB:  ldx     #$00                            ; EEAB A2 00                    ..
        plp                                     ; EEAD 28                       (
        rts                                     ; EEAE 60                       `

; ----------------------------------------------------------------------------
LEEAF:  lda     $12                             ; EEAF A5 12                    ..
        and     #$0F                            ; EEB1 29 0F                    ).
        sta     $12                             ; EEB3 85 12                    ..
        lda     $0330,x                         ; EEB5 BD 30 03                 .0.
        sec                                     ; EEB8 38                       8
        sbc     $12                             ; EEB9 E5 12                    ..
        sta     $0330,x                         ; EEBB 9D 30 03                 .0.
        lda     $0348,x                         ; EEBE BD 48 03                 .H.
        sbc     #$00                            ; EEC1 E9 00                    ..
        sta     $0348,x                         ; EEC3 9D 48 03                 .H.
        rts                                     ; EEC6 60                       `

; ----------------------------------------------------------------------------
LEEC7:  lda     $12                             ; EEC7 A5 12                    ..
        and     #$0F                            ; EEC9 29 0F                    ).
        eor     #$0F                            ; EECB 49 0F                    I.
        sec                                     ; EECD 38                       8
        adc     $0330,x                         ; EECE 7D 30 03                 }0.
        sta     $0330,x                         ; EED1 9D 30 03                 .0.
        lda     $0348,x                         ; EED4 BD 48 03                 .H.
        adc     #$00                            ; EED7 69 00                    i.
        sta     $0348,x                         ; EED9 9D 48 03                 .H.
        rts                                     ; EEDC 60                       `

; ----------------------------------------------------------------------------
LEEDD:  lda     $11                             ; EEDD A5 11                    ..
        and     #$0F                            ; EEDF 29 0F                    ).
        eor     #$0F                            ; EEE1 49 0F                    I.
        clc                                     ; EEE3 18                       .
        adc     $0378,x                         ; EEE4 7D 78 03                 }x.
        sta     $0378,x                         ; EEE7 9D 78 03                 .x.
        cmp     #$F0                            ; EEEA C9 F0                    ..
        bcc     LEEF6                           ; EEEC 90 08                    ..
        adc     #$0F                            ; EEEE 69 0F                    i.
        sta     $0378,x                         ; EEF0 9D 78 03                 .x.
        inc     $0390,x                         ; EEF3 FE 90 03                 ...
LEEF6:  rts                                     ; EEF6 60                       `

; ----------------------------------------------------------------------------
LEEF7:  lda     $11                             ; EEF7 A5 11                    ..
        pha                                     ; EEF9 48                       H
        and     #$0F                            ; EEFA 29 0F                    ).
        sta     $11                             ; EEFC 85 11                    ..
        lda     $0378,x                         ; EEFE BD 78 03                 .x.
        sec                                     ; EF01 38                       8
        sbc     $11                             ; EF02 E5 11                    ..
        sta     $0378,x                         ; EF04 9D 78 03                 .x.
        bcs     LEF11                           ; EF07 B0 08                    ..
        sbc     #$0F                            ; EF09 E9 0F                    ..
        sta     $0378,x                         ; EF0B 9D 78 03                 .x.
        dec     $0390,x                         ; EF0E DE 90 03                 ...
LEF11:  pla                                     ; EF11 68                       h
        sta     $11                             ; EF12 85 11                    ..
        rts                                     ; EF14 60                       `

; ----------------------------------------------------------------------------
LEF15:  sec                                     ; EF15 38                       8
        lda     $0330,x                         ; EF16 BD 30 03                 .0.
        sbc     $10                             ; EF19 E5 10                    ..
        sta     $0330,x                         ; EF1B 9D 30 03                 .0.
        lda     $0348,x                         ; EF1E BD 48 03                 .H.
        sbc     #$00                            ; EF21 E9 00                    ..
        sta     $0348,x                         ; EF23 9D 48 03                 .H.
        jmp     LEF3A                           ; EF26 4C 3A EF                 L:.

; ----------------------------------------------------------------------------
LEF29:  clc                                     ; EF29 18                       .
        lda     $0330,x                         ; EF2A BD 30 03                 .0.
        adc     $10                             ; EF2D 65 10                    e.
        sta     $0330,x                         ; EF2F 9D 30 03                 .0.
        lda     $0348,x                         ; EF32 BD 48 03                 .H.
        adc     #$00                            ; EF35 69 00                    i.
        sta     $0348,x                         ; EF37 9D 48 03                 .H.
LEF3A:  sec                                     ; EF3A 38                       8
        lda     $02                             ; EF3B A5 02                    ..
        sbc     $0330,x                         ; EF3D FD 30 03                 .0.
        sta     $02                             ; EF40 85 02                    ..
        lda     $03                             ; EF42 A5 03                    ..
        sbc     $0348,x                         ; EF44 FD 48 03                 .H.
        ora     $02                             ; EF47 05 02                    ..
        rts                                     ; EF49 60                       `

; ----------------------------------------------------------------------------
LEF4A:  sec                                     ; EF4A 38                       8
        lda     $0378,x                         ; EF4B BD 78 03                 .x.
        sbc     $11                             ; EF4E E5 11                    ..
        sta     $0378,x                         ; EF50 9D 78 03                 .x.
        bcs     LEF77                           ; EF53 B0 22                    ."
        sbc     #$0F                            ; EF55 E9 0F                    ..
        sta     $0378,x                         ; EF57 9D 78 03                 .x.
        dec     $0390,x                         ; EF5A DE 90 03                 ...
        jmp     LEF77                           ; EF5D 4C 77 EF                 Lw.

; ----------------------------------------------------------------------------
LEF60:  clc                                     ; EF60 18                       .
        lda     $0378,x                         ; EF61 BD 78 03                 .x.
        adc     $11                             ; EF64 65 11                    e.
        sta     $0378,x                         ; EF66 9D 78 03                 .x.
        bcs     LEF74                           ; EF69 B0 09                    ..
        cmp     #$F0                            ; EF6B C9 F0                    ..
        bcc     LEF77                           ; EF6D 90 08                    ..
        adc     #$0F                            ; EF6F 69 0F                    i.
        sta     $0378,x                         ; EF71 9D 78 03                 .x.
LEF74:  inc     $0390,x                         ; EF74 FE 90 03                 ...
LEF77:  sec                                     ; EF77 38                       8
        lda     $02                             ; EF78 A5 02                    ..
        sbc     $0378,x                         ; EF7A FD 78 03                 .x.
LEF7D:  sta     $02                             ; EF7D 85 02                    ..
        lda     $03                             ; EF7F A5 03                    ..
        sbc     $0390,x                         ; EF81 FD 90 03                 ...
        ora     $02                             ; EF84 05 02                    ..
        rts                                     ; EF86 60                       `

; ----------------------------------------------------------------------------
; --- $EF87: entity X vs player hitbox check (shapes via extent tables) -------
entity_player_collide:
        sec                                     ; EF87 38                       8
        lda     $0528                           ; EF88 AD 28 05                 .(.
        bpl     LEFF7                           ; EF8B 10 6A                    .j
        lda     $0390                           ; EF8D AD 90 03                 ...
        ora     $0390,x                         ; EF90 1D 90 03                 ...
        bne     LEFF7                           ; EF93 D0 62                    .b
        lda     $0528,x                         ; EF95 BD 28 05                 .(.
        bpl     LEFF7                           ; EF98 10 5D                    .]
        and     #$04                            ; EF9A 29 04                    ).
        bne     LEFF7                           ; EF9C D0 59                    .Y
        lda     $0408,x                         ; EF9E BD 08 04                 ...
        and     #$3F                            ; EFA1 29 3F                    )?
        tay                                     ; EFA3 A8                       .
        lda     $0330                           ; EFA4 AD 30 03                 .0.
        sec                                     ; EFA7 38                       8
        sbc     $0330,x                         ; EFA8 FD 30 03                 .0.
        pha                                     ; EFAB 48                       H
        lda     $0348                           ; EFAC AD 48 03                 .H.
        sbc     $0348,x                         ; EFAF FD 48 03                 .H.
        sta     L0000                           ; EFB2 85 00                    ..
        pla                                     ; EFB4 68                       h
        bcs     LEFC5                           ; EFB5 B0 0E                    ..
        eor     #$FF                            ; EFB7 49 FF                    I.
        adc     #$01                            ; EFB9 69 01                    i.
        pha                                     ; EFBB 48                       H
        lda     L0000                           ; EFBC A5 00                    ..
        eor     #$FF                            ; EFBE 49 FF                    I.
        adc     #$00                            ; EFC0 69 00                    i.
        sta     L0000                           ; EFC2 85 00                    ..
        pla                                     ; EFC4 68                       h
LEFC5:  cmp     LF0F1,y                         ; EFC5 D9 F1 F0                 ...
        bcs     LEFF7                           ; EFC8 B0 2D                    .-
        sec                                     ; EFCA 38                       8
        lda     L0000                           ; EFCB A5 00                    ..
        bne     LEFF7                           ; EFCD D0 28                    .(
        lda     LF0B1,y                         ; EFCF B9 B1 F0                 ...
        sta     L0000                           ; EFD2 85 00                    ..
        lda     $0558                           ; EFD4 AD 58 05                 .X.
        cmp     #$14                            ; EFD7 C9 14                    ..
        beq     LEFE1                           ; EFD9 F0 06                    ..
        lda     $30                             ; EFDB A5 30                    .0
        cmp     #$02                            ; EFDD C9 02                    ..
        bne     LEFE8                           ; EFDF D0 07                    ..
LEFE1:  lda     L0000                           ; EFE1 A5 00                    ..
        sec                                     ; EFE3 38                       8
        sbc     #$07                            ; EFE4 E9 07                    ..
        sta     L0000                           ; EFE6 85 00                    ..
LEFE8:  lda     $0378                           ; EFE8 AD 78 03                 .x.
        sec                                     ; EFEB 38                       8
        sbc     $0378,x                         ; EFEC FD 78 03                 .x.
        bcs     LEFF5                           ; EFEF B0 04                    ..
        eor     #$FF                            ; EFF1 49 FF                    I.
        adc     #$01                            ; EFF3 69 01                    i.
LEFF5:  cmp     L0000                           ; EFF5 C5 00                    ..
LEFF7:  rts                                     ; EFF7 60                       `

; ----------------------------------------------------------------------------
; --- $EFF8: entity X vs slot hitbox check (weapon collision) -----------------
entity_hitbox_check:
        sec                                     ; EFF8 38                       8
        lda     #$01                            ; EFF9 A9 01                    ..
        sta     $10                             ; EFFB 85 10                    ..
        lda     $0300,x                         ; EFFD BD 00 03                 ...
        beq     LEFF7                           ; F000 F0 F5                    ..
        lda     $0528,x                         ; F002 BD 28 05                 .(.
        bpl     LEFF7                           ; F005 10 F0                    ..
        and     #$04                            ; F007 29 04                    ).
        bne     LEFF7                           ; F009 D0 EC                    ..
        lda     $0390,x                         ; F00B BD 90 03                 ...
        bne     LEFF7                           ; F00E D0 E7                    ..
        ldy     #$03                            ; F010 A0 03                    ..
LF012:  lda     $0300,y                         ; F012 B9 00 03                 ...
        beq     LF068                           ; F015 F0 51                    .Q
        lda     $0528,y                         ; F017 B9 28 05                 .(.
        bpl     LF068                           ; F01A 10 4C                    .L
        lda     $0390,y                         ; F01C B9 90 03                 ...
        bne     LF068                           ; F01F D0 47                    .G
        lda     $0300,y                         ; F021 B9 00 03                 ...
        cmp     #$70                            ; F024 C9 70                    .p
        bcc     LF068                           ; F026 90 40                    .@
        jsr     LF06D                           ; F028 20 6D F0                  m.
        lda     $0330,y                         ; F02B B9 30 03                 .0.
        sec                                     ; F02E 38                       8
        sbc     $0330,x                         ; F02F FD 30 03                 .0.
        pha                                     ; F032 48                       H
        lda     $0348,y                         ; F033 B9 48 03                 .H.
        sbc     $0348,x                         ; F036 FD 48 03                 .H.
        sta     $02                             ; F039 85 02                    ..
        pla                                     ; F03B 68                       h
        bcs     LF04C                           ; F03C B0 0E                    ..
        eor     #$FF                            ; F03E 49 FF                    I.
        adc     #$01                            ; F040 69 01                    i.
        pha                                     ; F042 48                       H
        lda     $02                             ; F043 A5 02                    ..
        eor     #$FF                            ; F045 49 FF                    I.
        adc     #$00                            ; F047 69 00                    i.
        sta     $02                             ; F049 85 02                    ..
        pla                                     ; F04B 68                       h
LF04C:  cmp     $01                             ; F04C C5 01                    ..
        bcs     LF068                           ; F04E B0 18                    ..
        lda     $02                             ; F050 A5 02                    ..
        bne     LF068                           ; F052 D0 14                    ..
        lda     $0378,y                         ; F054 B9 78 03                 .x.
        sec                                     ; F057 38                       8
        sbc     $0378,x                         ; F058 FD 78 03                 .x.
        bcs     LF061                           ; F05B B0 04                    ..
        eor     #$FF                            ; F05D 49 FF                    I.
        adc     #$01                            ; F05F 69 01                    i.
LF061:  cmp     L0000                           ; F061 C5 00                    ..
        bcs     LF068                           ; F063 B0 03                    ..
        sty     $10                             ; F065 84 10                    ..
        rts                                     ; F067 60                       `

; ----------------------------------------------------------------------------
LF068:  dey                                     ; F068 88                       .
        bne     LF012                           ; F069 D0 A7                    ..
        sec                                     ; F06B 38                       8
        rts                                     ; F06C 60                       `

; ----------------------------------------------------------------------------
LF06D:  sty     $02                             ; F06D 84 02                    ..
        lda     $0408,x                         ; F06F BD 08 04                 ...
        and     #$3F                            ; F072 29 3F                    )?
        tay                                     ; F074 A8                       .
        lda     LF0B1,y                         ; F075 B9 B1 F0                 ...
        sta     L0000                           ; F078 85 00                    ..
        lda     LF0F1,y                         ; F07A B9 F1 F0                 ...
        sta     $01                             ; F07D 85 01                    ..
        ldy     $02                             ; F07F A4 02                    ..
        lda     $32                             ; F081 A5 32                    .2
        cmp     #$01                            ; F083 C9 01                    ..
        beq     LF092                           ; F085 F0 0B                    ..
        lda     $0300,y                         ; F087 B9 00 03                 ...
        cmp     #$C2                            ; F08A C9 C2                    ..
        bne     LF09C                           ; F08C D0 0E                    ..
        ldy     #$13                            ; F08E A0 13                    ..
        bne     LF09E                           ; F090 D0 0C                    ..
LF092:  lda     $0540,y                         ; F092 B9 40 05                 .@.
        tay                                     ; F095 A8                       .
        lda     LF159,y                         ; F096 B9 59 F1                 .Y.
        tay                                     ; F099 A8                       .
        bne     LF09E                           ; F09A D0 02                    ..
LF09C:  ldy     $5B                             ; F09C A4 5B                    .[
LF09E:  lda     L0000                           ; F09E A5 00                    ..
        sec                                     ; F0A0 38                       8
        sbc     LF131,y                         ; F0A1 F9 31 F1                 .1.
        sta     L0000                           ; F0A4 85 00                    ..
        lda     $01                             ; F0A6 A5 01                    ..
        sec                                     ; F0A8 38                       8
        sbc     LF145,y                         ; F0A9 F9 45 F1                 .E.
        sta     $01                             ; F0AC 85 01                    ..
        ldy     $02                             ; F0AE A4 02                    ..
        rts                                     ; F0B0 60                       `

; ----------------------------------------------------------------------------
LF0B1:  .byte   $14                             ; F0B1 14                       .
        .byte   $12                             ; F0B2 12                       .
        .byte   $74                             ; F0B3 74                       t
        .byte   $14                             ; F0B4 14                       .
        .byte   $3C                             ; F0B5 3C                       <
        bpl     LF0C7                           ; F0B6 10 0F                    ..
        asl     $1C16                           ; F0B8 0E 16 1C                 ...
        asl     $1818                           ; F0BB 0E 18 18                 ...
        .byte   $14                             ; F0BE 14                       .
        .byte   $12                             ; F0BF 12                       .
        jsr     L1018                           ; F0C0 20 18 10                  ..
        .byte   $1A                             ; F0C3 1A                       .
        .byte   $1C                             ; F0C4 1C                       .
        .byte   $20                             ; F0C5 20                        
        .byte   $24                             ; F0C6 24                       $
LF0C7:  .byte   $12                             ; F0C7 12                       .
        .byte   $1C                             ; F0C8 1C                       .
        plp                                     ; F0C9 28                       (
        bit     $0E                             ; F0CA 24 0E                    $.
        .byte   $12                             ; F0CC 12                       .
        clc                                     ; F0CD 18                       .
        .byte   $14                             ; F0CE 14                       .
        .byte   $14                             ; F0CF 14                       .
        .byte   $14                             ; F0D0 14                       .
        .byte   $14                             ; F0D1 14                       .
        .byte   $1C                             ; F0D2 1C                       .
        bpl     LF0E3                           ; F0D3 10 0E                    ..
        .byte   $1C                             ; F0D5 1C                       .
        .byte   $34                             ; F0D6 34                       4
        .byte   $1C                             ; F0D7 1C                       .
        jmp     L1C20                           ; F0D8 4C 20 1C                 L .

; ----------------------------------------------------------------------------
        clc                                     ; F0DB 18                       .
        .byte   $54                             ; F0DC 54                       T
        .byte   $54                             ; F0DD 54                       T
        bit     $24                             ; F0DE 24 24                    $$
        jsr     L1414                           ; F0E0 20 14 14                  ..
LF0E3:  .byte   $1C                             ; F0E3 1C                       .
        .byte   $1C                             ; F0E4 1C                       .
        .byte   $0C                             ; F0E5 0C                       .
        .byte   $0C                             ; F0E6 0C                       .
        .byte   $0C                             ; F0E7 0C                       .
        .byte   $0C                             ; F0E8 0C                       .
        .byte   $0C                             ; F0E9 0C                       .
        .byte   $0C                             ; F0EA 0C                       .
        .byte   $0C                             ; F0EB 0C                       .
        .byte   $0C                             ; F0EC 0C                       .
        .byte   $0C                             ; F0ED 0C                       .
        .byte   $0C                             ; F0EE 0C                       .
        .byte   $0C                             ; F0EF 0C                       .
        .byte   $0C                             ; F0F0 0C                       .
LF0F1:  bpl     LF101                           ; F0F1 10 0E                    ..
        bpl     LF16D                           ; F0F3 10 78                    .x
        bpl     LF103                           ; F0F5 10 0C                    ..
        .byte   $0B                             ; F0F7 0B                       .
        asl     a                               ; F0F8 0A                       .
        .byte   $12                             ; F0F9 12                       .
        .byte   $14                             ; F0FA 14                       .
        asl     $1214                           ; F0FB 0E 14 12                 ...
        .byte   $14                             ; F0FE 14                       .
        bpl     LF115                           ; F0FF 10 14                    ..
LF101:  .byte   $0E                             ; F101 0E                       .
        .byte   $10                             ; F102 10                       .
LF103:  bpl     LF113                           ; F103 10 0E                    ..
        asl     $0C0E                           ; F105 0E 0E 0C                 ...
        .byte   $12                             ; F108 12                       .
        asl     $1014                           ; F109 0E 14 10                 ...
        asl     a                               ; F10C 0A                       .
        asl     a                               ; F10D 0A                       .
        sec                                     ; F10E 38                       8
        bmi     LF139                           ; F10F 30 28                    0(
        .byte   $0B                             ; F111 0B                       .
        .byte   $20                             ; F112 20                        
LF113:  .byte   $14                             ; F113 14                       .
        .byte   $0B                             ; F114 0B                       .
LF115:  clc                                     ; F115 18                       .
        clc                                     ; F116 18                       .
        pha                                     ; F117 48                       H
        bmi     LF126                           ; F118 30 0C                    0.
        sec                                     ; F11A 38                       8
        plp                                     ; F11B 28                       (
        bpl     LF146                           ; F11C 10 28                    .(
        jsr     L1C18                           ; F11E 20 18 1C                  ..
        asl     $2420                           ; F121 0E 20 24                 . $
        plp                                     ; F124 28                       (
        php                                     ; F125 08                       .
LF126:  php                                     ; F126 08                       .
        php                                     ; F127 08                       .
        php                                     ; F128 08                       .
        php                                     ; F129 08                       .
        php                                     ; F12A 08                       .
        php                                     ; F12B 08                       .
        php                                     ; F12C 08                       .
        php                                     ; F12D 08                       .
        php                                     ; F12E 08                       .
        php                                     ; F12F 08                       .
        php                                     ; F130 08                       .
LF131:  asl     a                               ; F131 0A                       .
        php                                     ; F132 08                       .
        php                                     ; F133 08                       .
        .byte   $04                             ; F134 04                       .
        php                                     ; F135 08                       .
        asl     a                               ; F136 0A                       .
        .byte   $04                             ; F137 04                       .
        .byte   $94                             ; F138 94                       .
LF139:  asl     a                               ; F139 0A                       .
        sed                                     ; F13A F8                       .
        asl     a                               ; F13B 0A                       .
        asl     a                               ; F13C 0A                       .
        php                                     ; F13D 08                       .
        asl     L0000                           ; F13E 06 00                    ..
        php                                     ; F140 08                       .
        .byte   $04                             ; F141 04                       .
        brk                                     ; F142 00                       .
        .byte   $FC                             ; F143 FC                       .
        brk                                     ; F144 00                       .
LF145:  .byte   $05                             ; F145 05                       .
LF146:  asl     $FC                             ; F146 06 FC                    ..
        ora     L0000                           ; F148 05 00                    ..
        .byte   $FC                             ; F14A FC                       .
        brk                                     ; F14B 00                       .
        dey                                     ; F14C 88                       .
        ora     $F4                             ; F14D 05 F4                    ..
        ora     $05                             ; F14F 05 05                    ..
        .byte   $04                             ; F151 04                       .
        .byte   $02                             ; F152 02                       .
        brk                                     ; F153 00                       .
        .byte   $04                             ; F154 04                       .
        asl     $06                             ; F155 06 06                    ..
        asl     $FC                             ; F157 06 FC                    ..
LF159:  ora     ($10,x)                         ; F159 01 10                    ..
        ora     ($12),y                         ; F15B 11 12                    ..
        ora     ($10),y                         ; F15D 11 10                    ..
        ldx     #$08                            ; F15F A2 08                    ..
LF161:  lda     $0300,x                         ; F161 BD 00 03                 ...
        beq     LF16D                           ; F164 F0 07                    ..
        inx                                     ; F166 E8                       .
        cpx     #$18                            ; F167 E0 18                    ..
        bne     LF161                           ; F169 D0 F6                    ..
        sec                                     ; F16B 38                       8
        rts                                     ; F16C 60                       `

; ----------------------------------------------------------------------------
LF16D:  clc                                     ; F16D 18                       .
        rts                                     ; F16E 60                       `

; ----------------------------------------------------------------------------
; --- $F16F: find free entity slot $08-$17, return in Y (C set = none) --------
find_free_slot_y:
        ldy     #$08                            ; F16F A0 08                    ..
LF171:  lda     $0300,y                         ; F171 B9 00 03                 ...
        beq     LF17D                           ; F174 F0 07                    ..
        iny                                     ; F176 C8                       .
        cpy     #$18                            ; F177 C0 18                    ..
        bne     LF171                           ; F179 D0 F6                    ..
        sec                                     ; F17B 38                       8
        rts                                     ; F17C 60                       `

; ----------------------------------------------------------------------------
LF17D:  clc                                     ; F17D 18                       .
        rts                                     ; F17E 60                       `

; ----------------------------------------------------------------------------
        jsr     entity_x_dist_px                           ; F17F 20 94 EC                  ..
        sta     $0A                             ; F182 85 0A                    ..
        lda     #$01                            ; F184 A9 01                    ..
        bcs     LF18A                           ; F186 B0 02                    ..
        lda     #$02                            ; F188 A9 02                    ..
LF18A:  sta     $0C                             ; F18A 85 0C                    ..
        jsr     entity_y_dist_abs                           ; F18C 20 76 EC                  v.
        sta     $0B                             ; F18F 85 0B                    ..
        lda     #$04                            ; F191 A9 04                    ..
        bcs     LF197                           ; F193 B0 02                    ..
        lda     #$08                            ; F195 A9 08                    ..
LF197:  ora     $0C                             ; F197 05 0C                    ..
        sta     $0C                             ; F199 85 0C                    ..
        lda     $0B                             ; F19B A5 0B                    ..
        cmp     $0A                             ; F19D C5 0A                    ..
        bcs     LF1D4                           ; F19F B0 33                    .3
        lda     $02                             ; F1A1 A5 02                    ..
        sta     $03A8,x                         ; F1A3 9D A8 03                 ...
        lda     $03                             ; F1A6 A5 03                    ..
        sta     $03C0,x                         ; F1A8 9D C0 03                 ...
        lda     $0A                             ; F1AB A5 0A                    ..
        sta     $01                             ; F1AD 85 01                    ..
        lda     #$00                            ; F1AF A9 00                    ..
        sta     L0000                           ; F1B1 85 00                    ..
        jsr     div16                           ; F1B3 20 2D F2                  -.
        lda     L0004                           ; F1B6 A5 04                    ..
        sta     $02                             ; F1B8 85 02                    ..
        lda     $05                             ; F1BA A5 05                    ..
        sta     $03                             ; F1BC 85 03                    ..
        lda     $0B                             ; F1BE A5 0B                    ..
        sta     $01                             ; F1C0 85 01                    ..
        lda     #$00                            ; F1C2 A9 00                    ..
        sta     L0000                           ; F1C4 85 00                    ..
        jsr     div16                           ; F1C6 20 2D F2                  -.
        lda     L0004                           ; F1C9 A5 04                    ..
        sta     $03D8,x                         ; F1CB 9D D8 03                 ...
        lda     $05                             ; F1CE A5 05                    ..
        sta     $03F0,x                         ; F1D0 9D F0 03                 ...
        rts                                     ; F1D3 60                       `

; ----------------------------------------------------------------------------
LF1D4:  lda     $02                             ; F1D4 A5 02                    ..
        sta     $03D8,x                         ; F1D6 9D D8 03                 ...
        lda     $03                             ; F1D9 A5 03                    ..
        sta     $03F0,x                         ; F1DB 9D F0 03                 ...
        lda     $0B                             ; F1DE A5 0B                    ..
        sta     $01                             ; F1E0 85 01                    ..
        lda     #$00                            ; F1E2 A9 00                    ..
        sta     L0000                           ; F1E4 85 00                    ..
        jsr     div16                           ; F1E6 20 2D F2                  -.
        lda     L0004                           ; F1E9 A5 04                    ..
        sta     $02                             ; F1EB 85 02                    ..
        lda     $05                             ; F1ED A5 05                    ..
        sta     $03                             ; F1EF 85 03                    ..
        lda     $0A                             ; F1F1 A5 0A                    ..
        sta     $01                             ; F1F3 85 01                    ..
        lda     #$00                            ; F1F5 A9 00                    ..
LF1F7:  sta     L0000                           ; F1F7 85 00                    ..
        jsr     div16                           ; F1F9 20 2D F2                  -.
        lda     L0004                           ; F1FC A5 04                    ..
        sta     $03A8,x                         ; F1FE 9D A8 03                 ...
        lda     $05                             ; F201 A5 05                    ..
        sta     $03C0,x                         ; F203 9D C0 03                 ...
        rts                                     ; F206 60                       `

; ----------------------------------------------------------------------------
div8:
        lda     #$00                            ; F207 A9 00                    ..
        sta     $02                             ; F209 85 02                    ..
        sta     $03                             ; F20B 85 03                    ..
        lda     L0000                           ; F20D A5 00                    ..
        ora     $01                             ; F20F 05 01                    ..
        bne     LF216                           ; F211 D0 03                    ..
        sta     $02                             ; F213 85 02                    ..
        rts                                     ; F215 60                       `

; ----------------------------------------------------------------------------
LF216:  ldy     #$08                            ; F216 A0 08                    ..
LF218:  asl     $02                             ; F218 06 02                    ..
        rol     L0000                           ; F21A 26 00                    &.
        rol     $03                             ; F21C 26 03                    &.
        sec                                     ; F21E 38                       8
        lda     $03                             ; F21F A5 03                    ..
        sbc     $01                             ; F221 E5 01                    ..
        bcc     LF229                           ; F223 90 04                    ..
        sta     $03                             ; F225 85 03                    ..
        inc     $02                             ; F227 E6 02                    ..
LF229:  dey                                     ; F229 88                       .
        bne     LF218                           ; F22A D0 EC                    ..
        rts                                     ; F22C 60                       `

; ----------------------------------------------------------------------------
div16:  lda     #$00                            ; F22D A9 00                    ..
        sta     $06                             ; F22F 85 06                    ..
        sta     $07                             ; F231 85 07                    ..
        lda     L0000                           ; F233 A5 00                    ..
        ora     $01                             ; F235 05 01                    ..
        ora     $02                             ; F237 05 02                    ..
        ora     $03                             ; F239 05 03                    ..
        bne     LF242                           ; F23B D0 05                    ..
        sta     L0004                           ; F23D 85 04                    ..
        sta     $05                             ; F23F 85 05                    ..
        rts                                     ; F241 60                       `

; ----------------------------------------------------------------------------
LF242:  stx     $09                             ; F242 86 09                    ..
        ldy     #$10                            ; F244 A0 10                    ..
LF246:  asl     $06                             ; F246 06 06                    ..
        rol     L0000                           ; F248 26 00                    &.
        rol     $01                             ; F24A 26 01                    &.
        rol     $07                             ; F24C 26 07                    &.
        sec                                     ; F24E 38                       8
        lda     $01                             ; F24F A5 01                    ..
        sbc     $02                             ; F251 E5 02                    ..
        tax                                     ; F253 AA                       .
        lda     $07                             ; F254 A5 07                    ..
        sbc     $03                             ; F256 E5 03                    ..
        bcc     LF260                           ; F258 90 06                    ..
        stx     $01                             ; F25A 86 01                    ..
        sta     $07                             ; F25C 85 07                    ..
        inc     $06                             ; F25E E6 06                    ..
LF260:  dey                                     ; F260 88                       .
        bne     LF246                           ; F261 D0 E3                    ..
        lda     $06                             ; F263 A5 06                    ..
        sta     L0004                           ; F265 85 04                    ..
        lda     L0000                           ; F267 A5 00                    ..
        sta     $05                             ; F269 85 05                    ..
        ldx     $09                             ; F26B A6 09                    ..
        rts                                     ; F26D 60                       `

; ----------------------------------------------------------------------------
        sta     L0000                           ; F26E 85 00                    ..
        sty     $01                             ; F270 84 01                    ..
        lda     #$00                            ; F272 A9 00                    ..
        sta     $02                             ; F274 85 02                    ..
        sta     $03                             ; F276 85 03                    ..
        sta     L0004                           ; F278 85 04                    ..
        ldy     #$08                            ; F27A A0 08                    ..
LF27C:  lsr     $01                             ; F27C 46 01                    F.
        bcc     LF28D                           ; F27E 90 0D                    ..
        clc                                     ; F280 18                       .
        lda     L0000                           ; F281 A5 00                    ..
        adc     $02                             ; F283 65 02                    e.
        sta     $02                             ; F285 85 02                    ..
        lda     L0004                           ; F287 A5 04                    ..
        adc     $03                             ; F289 65 03                    e.
        sta     $03                             ; F28B 85 03                    ..
LF28D:  asl     L0000                           ; F28D 06 00                    ..
        ror     L0004                           ; F28F 66 04                    f.
        dey                                     ; F291 88                       .
        bne     LF27C                           ; F292 D0 E8                    ..
        lda     $02                             ; F294 A5 02                    ..
        rts                                     ; F296 60                       `

; ----------------------------------------------------------------------------
        lda     $0438,x                         ; F297 BD 38 04                 .8.
        and     #$07                            ; F29A 29 07                    ).
        tay                                     ; F29C A8                       .
        lda     bit_masks,y                         ; F29D B9 B2 F2                 ...
        sta     L0000                           ; F2A0 85 00                    ..
        lda     $0438,x                         ; F2A2 BD 38 04                 .8.
        lsr     a                               ; F2A5 4A                       J
        lsr     a                               ; F2A6 4A                       J
        lsr     a                               ; F2A7 4A                       J
        tay                                     ; F2A8 A8                       .
        lda     L0100,y                         ; F2A9 B9 00 01                 ...
        ora     L0000                           ; F2AC 05 00                    ..
        sta     L0100,y                         ; F2AE 99 00 01                 ...
        rts                                     ; F2B1 60                       `

; ----------------------------------------------------------------------------
; -----------------------------------------------------------------------------
; BIT MASK TABLES — $F2B2 (breakable-block bitmap etc.)
; -----------------------------------------------------------------------------
bit_masks:      .byte $01,$02,$04,$08,$10,$20,$40,$80   ; F2B2
bit_masks_inv:  .byte $FE,$FD,$FB,$F7,$EF,$DF,$BF,$7F   ; F2BA
scr_parity_ofs: .byte $00,$20                           ; F2C2

; -----------------------------------------------------------------------------
; ENTITY WIPE — $F2C4 (X-indexed; the standard "remove entity" call,
; used from nearly every code bank): spawn idx = $FF, then type, AI
; state, stun, HP, shape and all general vars cleared.
; -----------------------------------------------------------------------------
entity_wipe_x:
        lda     #$FF
        sta     ent_spawn_idx,x
        lda     #$00
        sta     ent_bhv_pc_hi,x
        sta     ent_type,x
        sta     ent_stun,x
        sta     ent_enemy_hp,x
        sta     $0408,x                 ; shape
        sta     $0468,x                 ; param/timer
        sta     $0480,x                 ; var5
        sta     $0498,x                 ; var6
        sta     $04B0,x                 ; angle
        sta     $04C8,x                 ; var1
        sta     $04E0,x                 ; var2
        sta     $04F8,x
        sta     $0510,x
        rts

; ----------------------------------------------------------------------------
; --- $F2F3: entity wipe Y, exempting types $C5/$79 ---------------------------
entity_wipe_y_checked:
        lda     $0300,y                         ; F2F3 B9 00 03                 ...
        cmp     #$C5                            ; F2F6 C9 C5                    ..
        beq     LF32C                           ; F2F8 F0 32                    .2
        cmp     #$79                            ; F2FA C9 79                    .y
        beq     LF32C                           ; F2FC F0 2E                    ..
entity_wipe_y:
        lda     #$FF                            ; F2FE A9 FF                    ..
        sta     $0438,y                         ; F300 99 38 04                 .8.
        lda     #$00                            ; F303 A9 00                    ..
        sta     $05A0,y                         ; F305 99 A0 05                 ...
        sta     $0300,y                         ; F308 99 00 03                 ...
        sta     $05B8,y                         ; F30B 99 B8 05                 ...
        sta     $0450,y                         ; F30E 99 50 04                 .P.
        sta     $0408,y                         ; F311 99 08 04                 ...
        sta     $0468,y                         ; F314 99 68 04                 .h.
        sta     $0480,y                         ; F317 99 80 04                 ...
        sta     $0498,y                         ; F31A 99 98 04                 ...
        sta     $04B0,y                         ; F31D 99 B0 04                 ...
        sta     $04C8,y                         ; F320 99 C8 04                 ...
        sta     $04E0,y                         ; F323 99 E0 04                 ...
        sta     $04F8,y                         ; F326 99 F8 04                 ...
        sta     $0510,y                         ; F329 99 10 05                 ...
LF32C:  rts                                     ; F32C 60                       `

 ; -----------------------------------------------------------------------------
; CALL BANK $00 SERVICE — $F32D
; Saves the current pair, maps bank $00 at $8000 + stage bank at $A000,
; calls bank $00's $8000 entry, restores. Per-frame engine service.
; -----------------------------------------------------------------------------
call_bank00_frame:  lda     $F5                             ; F32D A5 F5                    ..
        pha                                     ; F32F 48                       H
        lda     $F6                             ; F330 A5 F6                    ..
        pha                                     ; F332 48                       H
        lda     #$00                            ; F333 A9 00                    ..
        sta     $F5                             ; F335 85 F5                    ..
        lda     $26                             ; F337 A5 26                    .&
        sta     $F6                             ; F339 85 F6                    ..
        jsr     bank_load_shadow                ; F33B 20 43 FF                  C.
        jsr     L8000                           ; F33E 20 00 80                  ..
        pla                                     ; F341 68                       h
        sta     $F6                             ; F342 85 F6                    ..
        pla                                     ; F344 68                       h
        sta     $F5                             ; F345 85 F5                    ..
        jmp     bank_load_shadow                ; F347 4C 43 FF                 LC.

; ----------------------------------------------------------------------------
render_frame_banksafe:  lda     $F5                             ; F34A A5 F5                    ..
        pha                                     ; F34C 48                       H
        lda     $F6                             ; F34D A5 F6                    ..
        pha                                     ; F34F 48                       H
        lda     #$04                            ; F350 A9 04                    ..
        sta     $9F                             ; F352 85 9F                    ..
        jsr     oam_clear                           ; F354 20 8F C3                  ..
        jsr     entity_render_all                           ; F357 20 5E DF                  ^.
        pla                                     ; F35A 68                       h
        sta     $F6                             ; F35B 85 F6                    ..
        pla                                     ; F35D 68                       h
        sta     $F5                             ; F35E 85 F5                    ..
        jmp     bank_load_shadow                ; F360 4C 43 FF                 LC.

; ----------------------------------------------------------------------------
; --- $F363: render entities + one frame (quick NMI), banks saved -------------
render_tick_frame:
        inc     $95                             ; F363 E6 95                    ..
        jsr     render_frame_banksafe                           ; F365 20 4A F3                  J.
        lda     #$00                            ; F368 A9 00                    ..
        sta     $95                             ; F36A 85 95                    ..
        jmp     frame_wait                      ; F36C 4C 22 FF                 L".

; ----------------------------------------------------------------------------
; --- $F36F: render tick preserving OAM 0-$10 (HUD sprites) -------------------
render_tick_hud:
        lda     $F5                             ; F36F A5 F5                    ..
        pha                                     ; F371 48                       H
        lda     $F6                             ; F372 A5 F6                    ..
        pha                                     ; F374 48                       H
        inc     $95                             ; F375 E6 95                    ..
        ldx     #$44                            ; F377 A2 44                    .D
        stx     $9F                             ; F379 86 9F                    ..
        jsr     oam_clear_from                           ; F37B 20 91 C3                  ..
        jsr     entity_render_all                           ; F37E 20 5E DF                  ^.
        lda     #$00                            ; F381 A9 00                    ..
        sta     $95                             ; F383 85 95                    ..
        pla                                     ; F385 68                       h
        sta     $F6                             ; F386 85 F6                    ..
        pla                                     ; F388 68                       h
        sta     $F5                             ; F389 85 F5                    ..
        jsr     bank_load_shadow                ; F38B 20 43 FF                  C.
        jmp     frame_wait                      ; F38E 4C 22 FF                 L".

; ----------------------------------------------------------------------------
; --- $F391: render tick clearing OAM 0-$BF only (menus) ----------------------
render_tick_menu:
        lda     $F5                             ; F391 A5 F5                    ..
        pha                                     ; F393 48                       H
        lda     $F6                             ; F394 A5 F6                    ..
        pha                                     ; F396 48                       H
        inc     $95                             ; F397 E6 95                    ..
        ldx     #$00                            ; F399 A2 00                    ..
        lda     #$F8                            ; F39B A9 F8                    ..
LF39D:  sta     L0200,x                         ; F39D 9D 00 02                 ...
        inx                                     ; F3A0 E8                       .
        inx                                     ; F3A1 E8                       .
        inx                                     ; F3A2 E8                       .
        inx                                     ; F3A3 E8                       .
        cpx     #$C0                            ; F3A4 E0 C0                    ..
        bne     LF39D                           ; F3A6 D0 F5                    ..
        ldx     #$04                            ; F3A8 A2 04                    ..
        stx     $9F                             ; F3AA 86 9F                    ..
        jsr     entity_render_all                           ; F3AC 20 5E DF                  ^.
        lda     #$00                            ; F3AF A9 00                    ..
        sta     $95                             ; F3B1 85 95                    ..
        pla                                     ; F3B3 68                       h
        sta     $F6                             ; F3B4 85 F6                    ..
        pla                                     ; F3B6 68                       h
        sta     $F5                             ; F3B7 85 F5                    ..
        jsr     bank_load_shadow                ; F3B9 20 43 FF                  C.
        jmp     frame_wait                      ; F3BC 4C 22 FF                 L".

; ----------------------------------------------------------------------------
; --- $F3BF: load player palette rows (defaults or $32-selected backup) --------
player_palette_load:
        ldy     #$03                            ; F3BF A0 03                    ..
LF3C1:  lda     $32                             ; F3C1 A5 32                    .2
        beq     LF3D4                           ; F3C3 F0 0F                    ..
        lda     $0630,y                         ; F3C5 B9 30 06                 .0.
        sta     $0610,y                         ; F3C8 99 10 06                 ...
        lda     $0634,y                         ; F3CB B9 34 06                 .4.
        sta     $0614,y                         ; F3CE 99 14 06                 ...
        jmp     LF3E6                           ; F3D1 4C E6 F3                 L..

; ----------------------------------------------------------------------------
LF3D4:  lda     player_pal_bg,y                         ; F3D4 B9 B2 D4                 ...
        sta     $0630,y                         ; F3D7 99 30 06                 .0.
        sta     $0610,y                         ; F3DA 99 10 06                 ...
        lda     player_pal_spr,y                         ; F3DD B9 B6 D4                 ...
        sta     $0634,y                         ; F3E0 99 34 06                 .4.
        sta     $0614,y                         ; F3E3 99 14 06                 ...
LF3E6:  dey                                     ; F3E6 88                       .
        bpl     LF3C1                           ; F3E7 10 D8                    ..
        lda     $0600                           ; F3E9 AD 00 06                 ...
        sta     $0610                           ; F3EC 8D 10 06                 ...
        sty     $18                             ; F3EF 84 18                    ..
        rts                                     ; F3F1 60                       `

; ----------------------------------------------------------------------------
; --- $F3F2: wipe game/scroll zp state, tile overrides + breakable bitmap;
; player state/palette vars survive (fully for states $16/$17) ----------------
stage_state_init:  lda     $30                             ; F3F2 A5 30                    .0
        sta     L0000                           ; F3F4 85 00                    ..
        lda     $2D                             ; F3F6 A5 2D                    .-
        sta     $01                             ; F3F8 85 01                    ..
        lda     $2E                             ; F3FA A5 2E                    ..
        sta     $02                             ; F3FC 85 02                    ..
        lda     $32                             ; F3FE A5 32                    .2
        sta     $03                             ; F400 85 03                    ..
        lda     $50                             ; F402 A5 50                    .P
        sta     L0004                           ; F404 85 04                    ..
        lda     #$00                            ; F406 A9 00                    ..
        ldy     #$0F                            ; F408 A0 0F                    ..
LF40A:  sta     $30,y                           ; F40A 99 30 00                 .0.
        sta     $50,y                           ; F40D 99 50 00                 .P.
        dey                                     ; F410 88                       .
        bpl     LF40A                           ; F411 10 F7                    ..
        sta     $25                             ; F413 85 25                    .%
        sta     $AF                             ; F415 85 AF                    ..
        sta     $52                             ; F417 85 52                    .R
        sta     $43                             ; F419 85 43                    .C
        sta     $FC                             ; F41B 85 FC                    ..
        sta     $FD                             ; F41D 85 FD                    ..
        sta     $FA                             ; F41F 85 FA                    ..
        sta     $FB                             ; F421 85 FB                    ..
        sta     $05F0                           ; F423 8D F0 05                 ...
        sta     $05F1                           ; F426 8D F1 05                 ...
        sta     $05F2                           ; F429 8D F2 05                 ...
        sta     $05F3                           ; F42C 8D F3 05                 ...
        sta     $05D0                           ; F42F 8D D0 05                 ...
        sta     $2D                             ; F432 85 2D                    .-
        sta     $2E                             ; F434 85 2E                    ..
        sta     $2F                             ; F436 85 2F                    ./
        ldy     #$3F                            ; F438 A0 3F                    .?
LF43A:  sta     $06C0,y                         ; F43A 99 C0 06                 ...
        cpy     #$1F                            ; F43D C0 1F                    ..
        bcs     LF444                           ; F43F B0 03                    ..
        sta     $0680,y                         ; F441 99 80 06                 ...
LF444:  dey                                     ; F444 88                       .
        bpl     LF43A                           ; F445 10 F3                    ..
        lda     L0000                           ; F447 A5 00                    ..
        sta     $30                             ; F449 85 30                    .0
        cmp     #$16                            ; F44B C9 16                    ..
        beq     LF454                           ; F44D F0 05                    ..
        cmp     #$17                            ; F44F C9 17                    ..
        beq     LF454                           ; F451 F0 01                    ..
        rts                                     ; F453 60                       `

; ----------------------------------------------------------------------------
LF454:  lda     $01                             ; F454 A5 01                    ..
        sta     $2D                             ; F456 85 2D                    .-
        lda     $02                             ; F458 A5 02                    ..
        sta     $2E                             ; F45A 85 2E                    ..
        lda     $03                             ; F45C A5 03                    ..
        sta     $32                             ; F45E 85 32                    .2
        lda     L0004                           ; F460 A5 04                    ..
        sta     $50                             ; F462 85 50                    .P
        rts                                     ; F464 60                       `

; ----------------------------------------------------------------------------
; --- $F465: clear $0100-$011F buffer ------------------------------------------
clear_buf_0100:
        ldy     #$1F                            ; F465 A0 1F                    ..
        lda     #$00                            ; F467 A9 00                    ..
LF469:  sta     L0100,y                         ; F469 99 00 01                 ...
        dey                                     ; F46C 88                       .
        bpl     LF469                           ; F46D 10 FA                    ..
        rts                                     ; F46F 60                       `

; ----------------------------------------------------------------------------
; --- $F470: set entity direction + 8-dir velocity ------------------------------
; Y = direction index (dir byte from dir_byte_tbl), A = speed row base;
; X/Y velocity from dir_vel_sub/px_tbl[(y & 7) | base], Y at index ^ 4.
entity_set_dir_velocity:
        sty     L0000                           ; F470 84 00                    ..
        sta     $01                             ; F472 85 01                    ..
        lda     dir_byte_tbl,y                         ; F474 B9 4B ED                 .K.
        sta     $0420,x                         ; F477 9D 20 04                 . .
        lda     L0000                           ; F47A A5 00                    ..
        and     #$07                            ; F47C 29 07                    ).
        ora     $01                             ; F47E 05 01                    ..
        tay                                     ; F480 A8                       .
        lda     dir_vel_sub_tbl,y                         ; F481 B9 9E F4                 ...
        sta     $03A8,x                         ; F484 9D A8 03                 ...
        lda     dir_vel_px_tbl,y                         ; F487 B9 EE F4                 ...
        sta     $03C0,x                         ; F48A 9D C0 03                 ...
        tya                                     ; F48D 98                       .
        eor     #$04                            ; F48E 49 04                    I.
        tay                                     ; F490 A8                       .
        lda     dir_vel_sub_tbl,y                         ; F491 B9 9E F4                 ...
        sta     $03D8,x                         ; F494 9D D8 03                 ...
        lda     dir_vel_px_tbl,y                         ; F497 B9 EE F4                 ...
        sta     $03F0,x                         ; F49A 9D F0 03                 ...
        rts                                     ; F49D 60                       `

; ----------------------------------------------------------------------------
; -----------------------------------------------------------------------------
; DATA BLOCK — $F49E-$FDFF
; dir_vel_sub_tbl/dir_vel_px_tbl: 8-direction velocity components
; (quarter-sine rows, Y component read at index ^4). The remainder is
; unclassified table data (opcode density ~3%, no code found);
; L-labels kept for stray references pending classification.
; -----------------------------------------------------------------------------
dir_vel_sub_tbl:
        .byte   $00,$18,$2D,$3B,$40,$3B,$2D,$18,$00,$C3,$6A,$D9,$00,$D9,$6A,$C3   ; F49E
        .byte   $00,$87,$D4,$B2,$00,$B2,$D4,$87,$00,$9C,$21,$7A,$99,$7A,$21,$9C   ; F4AE
        .byte   $00,$61,$B5,$EC,$00,$EC,$B5,$61,$00,$25,$1F,$C5,$00,$C5,$1F,$25   ; F4BE
        .byte   $00,$E9,$89,$9E,$00,$9E,$89,$E9,$00,$30,$5A,$76,$80,$76,$5A,$30   ; F4CE
        .byte   $00   ; F4DE
LF4DF:
        .byte   $F4,$C4,$4F,$80,$4F,$C4,$F4,$00,$0F,$A8,$64,$00,$64,$A8,$0F   ; F4DF
dir_vel_px_tbl:
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01,$02,$01,$01,$00   ; F4EE
LF4FE:
        .byte   $00,$01,$02,$03,$04,$03,$02,$01,$00,$00,$01,$01,$01,$01,$01,$00   ; F4FE
        .byte   $00,$00,$00,$00,$01,$00,$00,$00,$00,$01,$02,$02,$03,$02,$02,$01   ; F50E
        .byte   $00,$01,$03,$04,$05,$04,$03,$01,$00,$00,$00,$00,$00,$00,$00,$00   ; F51E
        .byte   $00,$00,$01,$02,$02   ; F52E
LF533:
        .byte   $02,$01,$00,$00,$03,$05,$07,$08,$07,$05,$03,$FF,$75,$FF,$55,$FF   ; F533
        .byte   $D5,$FF,$55,$FF,$DF,$F7,$FD,$FB,$55,$FF,$77,$FE,$5D,$FF,$D5,$EF   ; F543
        .byte   $45,$FF,$CD,$FF,$D5,$FF,$D5,$FF,$D5,$FA,$7B,$FF,$7F,$FF,$75,$FF   ; F553
        .byte   $F7,$FF,$D5,$FF,$D3,$FE,$75,$DF,$F7,$FB,$D7,$FF,$55,$FF,$55,$FE   ; F563
        .byte   $C5,$F7,$77,$FE,$75,$FE,$7D,$7F,$5D,$7F,$DD,$F7,$75,$7F,$7B,$FF   ; F573
        .byte   $DD,$FF,$41,$FF,$55,$FB,$55,$FB,$95,$FE,$7D,$FF,$75,$FF,$CF,$FF   ; F583
        .byte   $F3,$FF,$5D,$FF,$F5,$FF,$67,$FF,$D7,$DF,$55,$FF,$5F,$FF,$75,$FF   ; F593
        .byte   $D5,$F7,$DD,$9D,$DF,$FF,$55,$7F,$55,$FF,$5D,$77,$35,$FF,$5F,$F2   ; F5A3
        .byte   $5D,$FF,$CD,$F7,$D7,$FF,$55,$7F,$55,$7F,$D5,$FB   ; F5B3
LF5BF:
        .byte   $F7,$7F,$4D,$FF,$7D,$FE,$77,$FF,$FF,$FF,$7D,$FF,$55,$BF,$5D,$FF   ; F5BF
        .byte   $57,$F9,$D5,$FF,$75,$7F,$55,$FD,$57,$FF,$45,$FF,$77,$FF,$75,$EF   ; F5CF
        .byte   $F5,$FF,$35,$DF,$5F,$FF,$7D,$FB,$D7,$FF,$65,$FB,$DD,$BF,$B5,$FF   ; F5DF
LF5EF:
        .byte   $7D,$FF,$7F,$FB,$DD,$FB,$5F,$FF,$D7,$FF,$75,$FF,$57,$FF   ; F5EF
LF5FD:
        .byte   $D5,$FF   ; F5FD
LF5FF:
        .byte   $75,$07,$01,$FF,$D1,$FF,$5D,$FF,$53,$FF,$DD,$FD,$77,$D7,$5F,$F7   ; F5FF
        .byte   $FF,$F7,$77,$FF,$57,$FF,$34,$FF,$55,$7F,$75,$DF,$57,$BF,$59,$F7   ; F60F
        .byte   $F1,$FD,$5D,$FB,$D5,$FF,$95,$DD,$D5,$FF,$75,$FF,$55,$FF,$FD,$FF   ; F61F
        .byte   $77,$BD,$DD,$FF,$FF,$FF,$55,$7F,$7D,$DF,$55,$FF,$D5,$FF,$75,$FF   ; F62F
        .byte   $55,$DF,$51,$BF,$5F,$FF,$77,$BF,$5D,$BF,$57,$7F,$5D,$FF,$5F,$7F   ; F63F
        .byte   $63,$FF,$57,$FE,$5F,$FF   ; F64F
LF655:
        .byte   $56,$FF,$D5,$FF,$77,$DF,$75,$FF,$7D,$FB,$75,$FF,$F7,$DF,$F5,$FF   ; F655
        .byte   $5D,$FF,$57,$FF,$5D,$FF,$5B,$FF,$7F,$FF,$57,$FF,$37,$DF,$57,$DF   ; F665
        .byte   $55,$FF,$D7,$FF,$77,$FF,$D7,$FF,$77,$FD,$DD,$FE,$5D,$FF,$DC,$F7   ; F675
        .byte   $7D,$FF,$55,$FD,$55,$F6,$F5,$FF,$57,$FE,$55,$FF,$57,$FE,$D7,$FF   ; F685
        .byte   $55,$7F,$73,$F7,$55,$FF,$D5,$DF,$4F,$FF,$71,$EB,$E5,$FF,$55,$FF   ; F695
        .byte   $75,$FF,$D7,$FF,$57,$FF,$D5,$FF,$FD,$7F,$D5,$FF,$75,$FF,$C7,$FD   ; F6A5
        .byte   $5D,$FA,$5D,$FF,$55,$FD,$55,$DF,$7D,$F7,$FD,$FF,$78,$FB,$57,$F9   ; F6B5
        .byte   $75,$FF,$75,$FF,$55,$F7,$77,$FF,$5D,$F7,$77,$FE,$D7,$FF,$D7,$FF   ; F6C5
        .byte   $5D,$FF,$45,$EE,$4D,$FF,$DD,$FF,$57,$FB,$D5,$FF,$7F,$FF,$45,$FD   ; F6D5
        .byte   $65,$FF,$C5,$FF,$57,$FF,$75,$FF,$5D,$FF,$77,$FF,$75,$FF,$C7,$FD   ; F6E5
        .byte   $DF,$7D,$75,$FF,$75,$F4,$59,$7F,$D5,$FF,$77,$FF,$55,$BF,$5D,$FF   ; F6F5
        .byte   $5D,$FB,$5F,$77,$F3,$FF,$55,$FF,$7D,$EF,$57,$FF,$57,$FF,$57,$F7   ; F705
        .byte   $5F,$FF,$57,$FF,$F5,$F9,$01,$DF,$D5,$7D,$01,$FF,$5D,$FF,$77,$FF   ; F715
        .byte   $5D,$FF,$94,$EF,$DD,$FF,$7D,$FF,$54,$FF,$57,$FF,$5F,$BE,$7D,$EF   ; F725
        .byte   $75,$FF,$55,$FF,$FF,$FD,$55,$DF,$71,$FF,$55,$FF,$75,$FF,$67,$EF   ; F735
        .byte   $55,$FF,$75,$FF,$5D,$FF,$51,$F7,$55,$FF,$DF,$FF,$75,$FD,$7F,$FF   ; F745
        .byte   $7D,$FF,$D5,$FF,$55,$FF,$5F,$DF,$5D,$FD,$F5,$FF,$DD,$FF,$95,$FF   ; F755
        .byte   $57,$FF,$7D,$DF,$D5,$DB,$5F,$FF,$5F,$FF,$7D,$FF,$5F,$FE,$55,$FF   ; F765
        .byte   $5D,$7E,$5F,$FF,$DF,$BF,$7D,$F7,$B7,$BB,$F5,$FF,$7D,$FF,$75,$FF   ; F775
        .byte   $CD,$FF,$75,$FF,$15,$FF,$55,$FF,$65,$EF,$C5,$EF,$57,$FF,$7E,$FF   ; F785
        .byte   $C5,$3F,$75,$FF,$D1,$FF,$FF,$FF,$7D,$BF,$F5,$FF,$79,$FF,$5D,$FF   ; F795
        .byte   $D5,$FE,$F5,$FF,$31,$FF,$37,$FF,$57,$FF,$75,$FF,$7D,$BF,$77,$FF   ; F7A5
        .byte   $7D,$EF,$F5,$FB,$5D,$EF,$DD,$FF,$73,$FF,$FD,$FB,$79,$DF,$D6,$FF   ; F7B5
        .byte   $55,$FF,$FD,$FF,$5F,$FF,$55,$FE,$59,$7F,$55,$FF,$57,$FF,$7E,$FF   ; F7C5
        .byte   $D7,$DF,$FF,$DF,$D7,$FF,$D3,$FF,$57,$FF,$75,$FF,$5D,$FF,$D5,$FF   ; F7D5
        .byte   $5D,$5F,$5D,$E7,$7D,$FF,$55,$FF,$F5,$FF,$5D,$FF,$55,$FF,$55,$F7   ; F7E5
        .byte   $5F,$FF,$F5,$F7,$55,$FF,$55,$FF,$71,$FF,$F5,$00,$00,$00,$00,$00   ; F7F5
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$40,$00,$00,$00,$00,$00,$00,$00   ; F805
        .byte   $00,$00,$01,$00,$00,$00,$00,$00,$20,$00,$00,$00,$00,$00,$00,$00   ; F815
        .byte   $00,$00,$00,$00,$00,$00,$20,$00,$00,$00,$00,$00,$00,$00,$40,$00   ; F825
        .byte   $00,$02,$22,$00,$00,$00,$00,$00,$00,$00,$10,$00   ; F835
LF841:
        .byte   $00,$00,$00,$00,$10,$00   ; F841
LF847:
        .byte   $00,$00,$00,$20,$40,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00   ; F847
        .byte   $00,$00,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00   ; F857
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$00   ; F867
        .byte   $49,$00,$80,$00,$00,$82,$04,$10,$00   ; F877
LF880:
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$00,$00   ; F880
LF88D:
        .byte   $00,$80,$00,$00,$00,$00,$00,$00,$00,$00,$40,$00,$00,$00,$00,$00   ; F88D
        .byte   $10,$00   ; F89D
LF89F:
        .byte   $00,$00,$00,$00,$00,$02,$10,$00   ; F89F
LF8A7:
        .byte   $00,$80,$00,$00,$00,$00,$00,$02,$00,$00,$00,$00,$80,$00,$00,$80   ; F8A7
        .byte   $00,$00,$00,$00,$20,$00,$00,$00,$01,$80,$00,$00,$00,$00,$00,$00   ; F8B7
        .byte   $04,$00,$00,$00,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00   ; F8C7
        .byte   $10,$00   ; F8D7
LF8D9:
        .byte   $00,$00,$00,$00,$00,$00,$00,$20,$00,$00,$00,$00,$00,$00,$00,$00   ; F8D9
        .byte   $80,$00,$01,$00,$01,$02,$00,$02,$00,$00,$48,$00,$04,$01,$48,$08   ; F8E9
        .byte   $00,$00,$A0,$00,$10,$00   ; F8F9
LF8FF:
        .byte   $44,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00   ; F8FF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00   ; F90F
        .byte   $00,$00,$00,$00,$01,$00,$10,$00   ; F91F
LF927:
        .byte   $00,$00,$0A,$00,$00,$00,$00,$00,$00,$00,$00,$02,$00,$08,$00,$00   ; F927
        .byte   $00,$02,$00,$08,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00   ; F937
        .byte   $20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$10,$00   ; F947
LF955:
        .byte   $00,$00,$40,$00,$00,$00,$80,$00,$00,$00,$00,$00,$00,$08,$40,$00   ; F955
        .byte   $00,$08,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$0C,$02,$00,$00   ; F965
        .byte   $80,$80,$00,$00,$40,$00,$80,$20,$20,$00,$40,$00,$00,$00,$00,$00   ; F975
        .byte   $00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00   ; F985
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$00   ; F995
        .byte   $08,$20,$00,$00,$80,$00,$00,$00,$04,$00,$02,$00,$00,$00,$00,$00   ; F9A5
        .byte   $08,$00,$00,$00,$00,$00,$00,$00,$00,$00,$10,$00   ; F9B5
LF9C1:
        .byte   $10,$00   ; F9C1
LF9C3:
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$81,$00   ; F9C3
        .byte   $00,$00,$00,$00,$08,$00,$00,$08,$02,$08,$00,$00,$10,$00   ; F9D3
LF9E1:
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$20,$00,$81,$00,$08,$00   ; F9E1
        .byte   $00,$00,$14,$00,$10,$00   ; F9F1
LF9F7:
        .byte   $80,$00,$02,$00,$00,$22,$40,$00,$04,$00,$00,$00,$00,$00,$00,$00   ; F9F7
        .byte   $00,$00,$40,$00,$00,$00,$00,$00,$40,$00,$00,$00,$00,$00,$00,$00   ; FA07
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08   ; FA17
        .byte   $00,$00,$00,$00,$44,$00,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00   ; FA27
        .byte   $00,$00,$00,$00,$00,$20,$80,$08,$00,$00,$00,$00,$00,$00,$00,$00   ; FA37
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$20,$00,$00,$08,$00,$00   ; FA47
        .byte   $00,$00,$00,$00,$00,$00   ; FA57
LFA5D:
        .byte   $41,$00,$08,$00,$01,$08,$10,$00   ; FA5D
LFA65:
        .byte   $02,$00,$40,$08,$00,$00,$00,$00,$40,$00,$40,$00,$00,$00,$00,$00   ; FA65
        .byte   $00,$00,$C1,$00,$00,$00,$00,$00,$00,$20,$10,$20,$00,$00,$00,$00   ; FA75
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$04,$00,$00,$00   ; FA85
        .byte   $02,$20,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$C1,$02,$20,$00   ; FA95
        .byte   $20,$00,$10,$00   ; FAA5
LFAA9:
        .byte   $00,$00,$20,$00,$00,$08,$00,$00,$01,$00,$20,$00,$00,$00,$00,$00   ; FAA9
        .byte   $02,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00   ; FAB9
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$04,$00,$00,$00,$00,$00,$00,$00   ; FAC9
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$04,$02,$04,$00,$04,$00,$00,$00   ; FAD9
        .byte   $02,$00,$68,$20,$00,$00,$10,$00   ; FAE9
LFAF1:
        .byte   $00,$00,$00,$00,$00,$00,$00,$80,$10,$20,$20,$00,$00,$00,$02,$00   ; FAF1
        .byte   $00,$08,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$00,$00,$00   ; FB01
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00   ; FB11
LFB1B:
        .byte   $00,$00,$00,$00,$00,$00,$04,$00,$00,$00,$00,$00,$00,$00,$08,$00   ; FB1B
        .byte   $00,$00,$90,$00   ; FB2B
LFB2F:
        .byte   $00,$00,$00,$00,$08,$80,$00,$00,$00,$00,$00,$00,$03,$00,$40,$00   ; FB2F
        .byte   $40,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00   ; FB3F
        .byte   $00,$00,$02,$00,$00,$00,$10,$00   ; FB4F
LFB57:
        .byte   $00,$00,$00,$00   ; FB57
LFB5B:
        .byte   $00,$00   ; FB5B
LFB5D:
        .byte   $00,$08,$00,$08,$00,$00,$00,$00,$01,$00,$00,$00,$81,$00,$80,$00   ; FB5D
        .byte   $08,$00,$20,$00,$00,$00,$00,$00,$00,$00,$58,$00,$00,$00,$20,$00   ; FB6D
        .byte   $00,$02,$00,$00,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00   ; FB7D
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$21,$00,$00,$00,$00,$00   ; FB8D
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$02,$00,$00,$00,$00,$00,$00,$00   ; FB9D
        .byte   $00,$00,$00,$00,$04,$08,$00,$00,$40,$80,$00,$00,$00,$00,$8C,$02   ; FBAD
        .byte   $60,$20,$00,$00,$00,$00,$00,$00,$00,$00,$20,$00,$00,$00,$00,$00   ; FBBD
        .byte   $00,$00,$00,$00,$08,$00,$02,$00,$80,$00,$00,$00,$10,$80,$80,$A0   ; FBCD
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$00,$00,$00,$00,$00,$00   ; FBDD
        .byte   $00,$00,$00,$00,$00,$00,$00,$02,$08,$02,$00,$00,$00,$00,$00,$00   ; FBED
LFBFD:
        .byte   $00,$48,$D3,$00,$00,$00,$00,$00,$00,$00   ; FBFD
LFC07:
        .byte   $00,$00,$00,$02,$00,$00,$00,$00,$00,$40,$00,$00,$00,$00,$00,$00   ; FC07
        .byte   $00,$00,$00,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00   ; FC17
        .byte   $00,$00,$04,$03,$00,$00,$00,$04,$00,$00,$00,$20,$04,$00,$01,$00   ; FC27
        .byte   $00,$02,$01,$10,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00   ; FC37
        .byte   $00,$00,$00,$00,$00,$00,$00,$84,$00,$00,$00,$00,$00,$00,$00,$00   ; FC47
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$10,$08,$00,$00,$00,$08   ; FC57
        .byte   $00,$01,$00,$00,$44,$0E,$00,$00,$41,$00,$00,$00,$00,$00,$00,$48   ; FC67
        .byte   $00,$C0,$40,$00,$40,$00,$00,$1A,$00,$04,$00,$00,$00,$00,$00,$00   ; FC77
        .byte   $00,$00,$00,$00,$00,$00,$00,$10,$00   ; FC87
LFC90:
        .byte   $10,$00   ; FC90
LFC92:
        .byte   $00,$00,$00,$14,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$14   ; FC92
        .byte   $00,$00,$08,$00,$04,$00,$41,$40,$00,$00,$00,$00,$B0,$00   ; FCA2
LFCB0:
        .byte   $00,$00,$00,$00,$00,$04,$42,$00,$08,$00,$20,$44,$80,$00,$00,$41   ; FCB0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$80,$00,$00,$00,$00,$00   ; FCC0
        .byte   $00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$40,$00,$00   ; FCD0
        .byte   $04,$40,$80,$00,$00,$00,$80,$10,$42,$00,$09,$04,$80,$00,$00,$00   ; FCE0
        .byte   $20,$00,$01,$00,$40,$00,$40,$44,$00,$00,$10,$00   ; FCF0
LFCFC:
        .byte   $00,$00,$40,$50,$00   ; FCFC
LFD01:
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$10,$00   ; FD01
LFD0C:
        .byte   $00,$00,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00   ; FD0C
        .byte   $00,$00,$00,$00,$02,$00,$00,$00,$00,$00,$80,$00,$00,$00,$00   ; FD1C
LFD2B:
        .byte   $00,$00,$40,$80,$00,$08,$00,$12,$00,$44,$00,$00,$40,$20,$00,$00   ; FD2B
        .byte   $00,$40,$04,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00   ; FD3B
        .byte   $00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00   ; FD4B
        .byte   $00,$10,$00   ; FD5B
LFD5E:
        .byte   $20,$00,$02,$01,$00,$04,$84,$00,$03,$00,$00,$00,$00,$00,$00,$00   ; FD5E
        .byte   $21,$04,$00,$00,$04,$04,$00,$50,$00   ; FD6E
LFD77:
        .byte   $00,$00,$00,$00,$01,$00,$04,$00,$01,$00,$00,$00,$00,$00,$00,$00   ; FD77
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$04,$00,$00,$00,$00,$00,$00,$00   ; FD87
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$01,$01,$40,$00   ; FD97
        .byte   $00,$00,$00,$01,$01,$00,$01,$08,$00,$00,$00,$80,$01,$00,$00,$20   ; FDA7
        .byte   $00,$00,$00,$00,$00,$02,$00,$00,$00,$00,$00,$00,$00,$80,$00,$00   ; FDB7
        .byte   $04,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$14,$00,$00   ; FDC7
        .byte   $00,$00,$00,$90,$00   ; FDD7
LFDDC:
        .byte   $00,$00,$00,$10,$00   ; FDDC
LFDE1:
        .byte   $00,$00,$00,$10,$00   ; FDE1
LFDE6:
        .byte   $44,$04,$C4,$00,$00,$00,$00,$00,$00,$40,$00,$00,$40,$00,$0A,$00   ; FDE6
        .byte   $08   ; FDF6
LFDF7:
        .byte   $00,$2E,$00,$09,$00,$10,$00   ; FDF7
LFDFE:
        .byte   $00,$11   ; FDFE
; =============================================================================
; RESET — $FE00
; Hardware init, RAM clear, sound queue init, MMC3 setup, then spawns
; the main game task ($E8DD) as task 2 and falls into the scheduler.
; =============================================================================
; da65 artifacts: addresses referenced from not-yet-converted data
; regions that fall mid-instruction here are kept as constants.
LFE75           := $FE75
LFEDD           := $FEDD
LFF4D           := $FF4D
LFF5D           := $FF5D
LFF5F           := $FF5F
LFF77           := $FF77

reset:  sei
        cld
        lda     #$08                    ; NMI off, sprites pattern $1000
        sta     PPUCTRL
        lda     #$40                    ; APU frame IRQ off
        sta     APU_FRAME
        ldx     #$00
        stx     PPUMASK
        stx     $4010                   ; DMC IRQ off
        stx     SND_CHN
        dex
        txs
        ldx     #$04                    ; wait 4 PPU frames (warmup)
LFE1B:  lda     PPUSTATUS
        bpl     LFE1B
LFE20:  lda     PPUSTATUS
        bmi     LFE20
        dex
        bne     LFE1B
        lda     PPUSTATUS
        lda     #$10                    ; exercise PPUADDR toggle
        tay
LFE2E:  sta     PPUADDR
        sta     PPUADDR
        eor     #$10
        dey
        bne     LFE2E
        tya                             ; clear all 2KB of RAM
LFE3A:  sta     temp_00,y
        sta     $0100,y
        sta     OAM_BUF,y
        sta     $0300,y
        sta     $0400,y
        sta     $0500,y
        sta     $0600,y
        sta     $0700,y
        dey
        bne     LFE3A
        ldx     #$07                    ; sound queue: all slots empty
        lda     #$88
LFE59:  sta     sound_queue,x
        dex
        bpl     LFE59
        lda     #$18                    ; rendering on (BG + sprites)
        sta     ppumask_shadow
        lda     #$01                    ; horizontal-scroll mirroring
        jsr     set_mirroring
        ldx     #$05                    ; CHR banks R5..R0 = 0
        lda     #$00
LFE6B:  stx     MMC3_BANK_SELECT
        sta     MMC3_BANK_DATA
        dex
        bpl     LFE6B
        jsr     oam_clear
        lda     #$20                    ; clear both nametables
        ldx     #$00
        ldy     #$00
        jsr     ppu_fill_nametable
        lda     #$28
        ldx     #$00
        ldy     #$00
        jsr     ppu_fill_nametable
        lda     #$DD                    ; spawn main game task:
        sta     task_ptr_hi_arg         ; task 2, entry $DDE8
        lda     #$E8
        sta     task_ptr_lo
        lda     #$02
        jsr     task_create
        lda     #$88
        sta     $E4                     ; sound queue guard slot
        sta     irq_latch_req
        sta     ppuctrl_shadow          ; NMI on, BG pattern $1000
        sta     PPUCTRL
        lda     #$02
        sta     $BF                     ; (player state init: $BF = 2,
        lda     #$9C                    ;  $B0/$BA = $9C — cf. MM4 player
        sta     $B0                     ;  HP full+owned encoding; to be
        sta     $BA                     ;  confirmed and named)
; =============================================================================
; TASK SCHEDULER — $FEAB
; Cooperative multitasker, 4 task records (4 bytes each at $80).
; States: 0 = free, 1 = frame-wait (NMI counts down), 2 = running,
; 4 = ready, 8 = new (entry pointer in record). Runs every ready task
; until all are waiting; task 0 also reads the controllers each frame.
; =============================================================================
scheduler_run:
        ldx     #$FF                    ; discard stack
        txs
LFEAE:  ldx     #$00
        stx     nmi_occurred
        ldy     #$04
LFEB4:  lda     task_state,x            ; scan for state >= 4 (ready/new)
        cmp     #$04
        bcs     LFEC4
        inx
        inx
        inx
        inx
        dey
        bne     LFEB4
        jmp     LFEAE                   ; none ready: idle until NMI

LFEC4:  lda     nmi_occurred            ; NMI during scan? rescan
        bne     LFEAE
        dey
        tya
        eor     #$03                    ; cur_task = record index (0-3)
        sta     cur_task
        ldy     task_state,x
        lda     #$02                    ; mark running
        sta     task_state,x
        cpy     #$08                    ; new task?
        bne     LFEE3
        lda     task_sp,x               ; yes: jump to its entry point
        sta     task_ptr_lo
        lda     task_ptr_hi,x
        sta     task_ptr_hi_arg
        jmp     (task_ptr_lo)

LFEE3:  lda     task_sp,x               ; ready: restore its stack
        tax
        txs
        lda     cur_task                ; task 0 reads the pads first
        bne     LFEEE
        jsr     read_controllers
LFEEE:  pla                             ; restore Y/X saved by frame_wait
        tay
        pla
        tax
        rts                             ; -> resume after frame_wait

; --- $FEF3: create task A (0-3), entry pointer in task_ptr_lo/hi ------------
task_create:
        jsr     LFF17
        lda     task_ptr_lo
        sta     task_sp,x
        lda     task_ptr_hi_arg
LFEFC:  sta     task_ptr_hi,x
        lda     #$08                    ; state: new
        sta     task_state,x
        rts

; --- $FF03: free task slot A -------------------------------------------------
task_kill:
        jsr     LFF17
        lda     #$00
        sta     task_state,x
        rts

; --- $FF0B: terminate current task, re-enter scheduler ------------------------
task_exit:
        jsr     LFF15
        lda     #$00
        sta     task_state,x
        jmp     scheduler_run

LFF15:  lda     cur_task                ; X = task record offset (id * 4)
LFF17:  asl     a
        asl     a
        tax
        rts

; --- $FF1B: yield X frames ----------------------------------------------------
frame_wait_x:
        jsr     frame_wait
        dex
        bne     frame_wait_x
        rts

; --- $FF22: yield one frame ---------------------------------------------------
; Saves X/Y on the task's stack, records SP, sets state 1 with a
; 1-frame counter, and drops back into the scheduler.
frame_wait:
        lda     #$01
        sta     task_ptr_lo
        txa
        pha
        tya
        pha
        jsr     LFF15
        lda     task_ptr_lo
        sta     task_arg,x
        lda     #$01                    ; state: frame-wait
        sta     task_state,x
        txa
        tay
        tsx
        stx     task_sp,y
        jmp     scheduler_run

; =============================================================================
; PRG BANK SWITCHING — $FF3D / $FF43
; Banks swap in 16KB pairs: bank_load_pair maps A at $8000 (R6) and
; A+1 at $A000 (R7); bank_load_shadow (re)maps from prg_bank_8000/a000.
; bank_nest guards against IRQ/NMI re-entry; a sound request arriving
; while nested sets sound_pending and is pumped on the way out.
; =============================================================================
bank_load_pair:
        sta     prg_bank_8000
        sta     prg_bank_a000
        inc     prg_bank_a000
bank_load_shadow:
        inc     bank_nest
        lda     #$06                    ; MMC3 R6 <- prg_bank_8000
        sta     mmc3_sel_shadow
        sta     MMC3_BANK_SELECT
        lda     prg_bank_8000
        sta     $F3                     ; last bank actually written
        sta     MMC3_BANK_DATA
        lda     #$07                    ; MMC3 R7 <- prg_bank_a000
LFF55:  sta     mmc3_sel_shadow
        sta     MMC3_BANK_SELECT
        lda     prg_bank_a000
        sta     $F4                     ; last bank actually written
        sta     MMC3_BANK_DATA
        dec     bank_nest
        lda     sound_pending           ; deferred sound request?
        bne     sound_queue_pump
        rts

; =============================================================================
; SOUND QUEUE PUMP — $FF68
; Maps the sound engine pair ($18 at $8000, $19 at $A000), drains the
; queue through the driver's play entry ($8003), runs its per-frame
; update ($8000), then restores the previous banks. If called while
; bank switching is in progress, defers via sound_pending.
; =============================================================================
sound_queue_pump:
        lda     bank_nest
        bne     LFFB4                   ; nested: defer
        lda     #$06                    ; map sound engine bank $18
        sta     mmc3_sel_shadow
        sta     MMC3_BANK_SELECT
        lda     #$18
LFF75:  sta     MMC3_BANK_DATA
        lda     #$07                    ; map sound data bank $19
        sta     mmc3_sel_shadow
        sta     MMC3_BANK_SELECT
        lda     #$19
        sta     MMC3_BANK_DATA
; --- $FF84: drain queue, then run driver update -------------------------------
sound_play:
        stx     $A7                     ; save caller X/Y
        sty     $A8
        ldx     sound_q_idx
        lda     sound_queue,x
        cmp     #$88                    ; empty slot = queue drained
        beq     LFFA6
        pha
        lda     #$88                    ; free the slot, advance (mod 8)
        sta     sound_queue,x
        inx
        txa
        and     #$07
        sta     sound_q_idx
        pla
        jsr     L8003                   ; sound driver: play sound A
        ldx     $A7
        ldy     $A8
        jmp     sound_play

LFFA6:  jsr     L8000                   ; sound driver: per-frame update
LFFA9:  lda     #$00
        sta     sound_pending
        ldx     $A7
        ldy     $A8
        jmp     bank_load_shadow        ; restore game banks

LFFB4:  inc     sound_pending           ; deferred: pumped after restore
        rts

; --- $FFB7: set mirroring (1 = horizontal scroll, 0 = vertical scroll) --------
set_mirroring:
        sta     MMC3_MIRRORING
        sta     $2C                     ; mirroring shadow
        rts

; --- $FFBD-$FFF9: padding / unreferenced data ---------------------------------
        .byte   $00,$40,$01,$C0,$00,$00,$00,$00 ; FFBD
        .byte   $00,$00,$00,$00,$00,$81,$00,$00 ; FFC5
        .byte   $00,$00,$01,$00,$01,$00,$40,$00 ; FFCD
LFFD5:  .byte   $04,$00                         ; FFD5
LFFD7:  .byte   $01,$00,$00,$00,$40,$00         ; FFD7
LFFDD:  .byte   $00,$00,$00,$00,$00,$00,$00,$01 ; FFDD
        .byte   $00,$00,$00,$04,$00,$00,$00,$00 ; FFE5
        .byte   $00,$10,$00                     ; FFED
LFFF0:  .byte   $6B,$3F,$A6,$15,$44,$04,$00,$00 ; FFF0
        .byte   $08,$F5                         ; FFF8

; --- CPU vectors ---------------------------------------------------------------
        .addr   nmi_handler             ; FFFA NMI    = $C000
        .addr   reset                   ; FFFC RESET  = $FE00
        .addr   irq_handler             ; FFFE IRQ    = $C169
