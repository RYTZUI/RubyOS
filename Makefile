AS_X86 := nasm
CC_X86 := x86_64-elf-gcc
LD_X86 := x86_64-elf-ld

BIN_DIR := bin
TARGET_X86 := $(BIN_DIR)/rubyos.bin
LD_SCRIPT := scripts/linker.ld

all: prep $(TARGET_X86)

prep:
	mkdir -p $(BIN_DIR)

$(TARGET_X86): arch/x86_64/boot.o common/kernel.o drivers/vga.o
	$(LD_X86) -m elf_i386 -n -T $(LD_SCRIPT) -o $(TARGET_X86) $^

arch/x86_64/boot.o: arch/x86_64/boot.asm
	$(AS_X86) -f elf32 $< -o $@

common/kernel.o: common/kernel.c
	$(CC_X86) -m32 -ffreestanding -c $< -o $@

drivers/vga.o: drivers/vga.c
	$(CC_X86) -m32 -ffreestanding -c $< -o $@

clean:
	rm -rf arch/x86_64/*.o common/*.o drivers/*.o $(BIN_DIR)/*