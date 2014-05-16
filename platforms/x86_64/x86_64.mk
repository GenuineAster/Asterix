all: asterix.iso

AS = nasm
ASFLAGS = -f elf64 -g
LDFLAGS = -g -m elf_x86_64 -L/usr/lib/gcc/`gcc -dumpmachine`/`gcc -dumpversion`/
LDLIBS  = -lgcc
CXXFLAGS=-Wwrite-strings -g -ffreestanding -std=c++11 -mcmodel=large \
	-mno-mmx -mno-sse -mno-sse2 -mno-sse3 -mno-3dnow -DASTERIX_$(ARCH)


kernel.bin: src/kernel/bootstrap/x86_64/paging.cpp.o src/kernel/bootstrap/$(ARCH)/bootstrap.asm.o src/kernel/kernel.asm.o src/kernel/kernel.cpp.o
	$(LD) $(LDFLAGS) $(LDLIBS) $^ -T platforms/$(ARCH)/kernel.ld -o $@
	objcopy $@ -O elf32-i386 $@
.PHONY : kernel.bin

kernel: kernel.bin

sysroot: kernel
	rm   -rf sysroot
	mkdir -p sysroot
	mkdir -p sysroot/boot
	cp grub/*  -r sysroot/
	cp kernel.bin sysroot/boot/kernel.bin


asterix.iso: sysroot kernel
	grub-mkrescue -o $@ sysroot &> /dev/null
.PHONY : asterix.iso

asterix: asterix.iso
disk:    asterix.iso
cdrom:   asterix.iso
cd:      asterix.iso

%.asm.o: %.asm
	$(AS) $(ASFLAGS) $(INCLUDE_ARGS) $< -o $@

%.cpp.o: %.cpp
	$(CXX) $(CXXFLAGS) $< -c \
		$(INCLUDE_ARGS) -o $@

%.c.o: %.c
	$(CC) $(CFLAGS) -std=c11 $< -c -ffreestanding\
		$(INCLUDE_ARGS) -o $@
