all: asterix.iso

AS = nasm
ASFLAGS = -f elf64 -g
LDFLAGS = -g -m elf_x86_64 -L/usr/lib/gcc/`gcc -dumpmachine`/`gcc -dumpversion`/
LDLIBS  = -lgcc

bootstrap.o:
	$(AS) $(ASFLAGS) $(INCLUDE_ARGS) $(KERNEL_PATH)/bootstrap/bootstrap.s -o $@
.PHONY : boot.bin

bootstrap: bootstrap.o

kernel.bin: bootstrap.o src/kernel/kernel.s.o src/kernel/kernel.cpp.o
	$(LD) -g $(LDFLAGS) $(LDLIBS) $^ -T src/kernel/kernel.ld -o $@
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

%.s.o: %.s
	$(AS) $(ASFLAGS) $(INCLUDE_ARGS) $< -o $@

%.cpp.o: %.cpp
	$(CXX) $(CXXFLAGS) -std=c++11 $< -c -ffreestanding\
		$(INCLUDE_ARGS) -o $@

%.c.o: %.c
	$(CC) $(CFLAGS) -std=c11 $< -c -ffreestanding\
		$(INCLUDE_ARGS) -o $@