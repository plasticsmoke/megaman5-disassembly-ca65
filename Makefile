# =============================================================================
# Mega Man 5 (U) — ca65 Disassembly Build System
# =============================================================================

CA65    = ca65 -I .
LD65    = ld65
CFG     = cfg/nes.cfg
ROM_OUT = build/mm5_built.nes
ROM_REF = mm5.nes

# Source files
HEADER_SRC = src/header.asm

# Swappable bank sources ($00-$1D)
BANK_SRCS = \
	src/bank00.asm \
	src/bank01.asm \
	src/bank02.asm \
	src/bank03.asm \
	src/bank04.asm \
	src/bank05.asm \
	src/bank06.asm \
	src/bank07.asm \
	src/bank08.asm \
	src/bank09.asm \
	src/bank0A.asm \
	src/bank0B.asm \
	src/bank0C.asm \
	src/bank0D.asm \
	src/bank0E.asm \
	src/bank0F.asm \
	src/bank10.asm \
	src/bank11.asm \
	src/bank12.asm \
	src/bank13.asm \
	src/bank14.asm \
	src/bank15.asm \
	src/bank16.asm \
	src/bank17.asm \
	src/bank18.asm \
	src/bank19.asm \
	src/bank1A.asm \
	src/bank1B.asm \
	src/bank1C.asm \
	src/bank1D.asm

# Fixed bank source ($1E/$1F, $C000-$FFFF)
FIXED_SRCS = src/fixed_bank.asm

# CHR ROM (256KB, .incbin of chr/chr.bin)
CHR_SRC = src/chr.asm

ALL_SRCS = $(HEADER_SRC) $(BANK_SRCS) $(FIXED_SRCS) $(CHR_SRC)
ALL_OBJS = $(ALL_SRCS:%.asm=build/%.o)

.PHONY: all verify clean

all: verify

$(ROM_OUT): $(ALL_OBJS) $(CFG)
	@mkdir -p $(dir $@)
	$(LD65) -C $(CFG) -o $@ $(ALL_OBJS)

# Pattern rule: assemble .asm -> .o
build/%.o: %.asm
	@mkdir -p $(dir $@)
	$(CA65) -o $@ $<

# CHR object depends on the extracted binary
build/src/chr.o: chr/chr.bin

verify: $(ROM_OUT)
	@cmp $(ROM_OUT) $(ROM_REF) && echo "BUILD VERIFIED: byte-perfect match!" || (echo "BUILD FAILED: ROM mismatch"; exit 1)

clean:
	rm -rf build/src build/mm5_built.nes
