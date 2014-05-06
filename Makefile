all: asterix.iso

SRC_DIR = src
BOOTLOADER_DIR = bootloader
BOOTLOADER_PATH = ${SRC_DIR}/${BOOTLOADER_DIR}
KERNEL_DIR = kernel
KERNEL_PATH = ${SRC_DIR}/${KERNEL_DIR}
BOOTSECTOR = bootsector.bin.tmp

boot.bin:
	nasm ${BOOTLOADER_PATH}/bootloader.asm -I ${SRC_DIR}/ -f bin -o $@
.PHONY : boot.bin

boot: boot.bin
bootloader: boot.bin

kernel.bin: src/kernel/kernel.o
	ld ${KERNEL_PATH}/kernel.o -Ttext 0x2000 -I ${SRC_DIR}/ -melf_i386 --oformat elf32-i386 -o $@
.PHONY : kernel.bin

kernel: kernel.bin

sysroot: boot.bin kernel
	rm   -rf sysroot
	mkdir -p sysroot
	mkdir -p sysroot/boot
	cp grub/*  -r sysroot/
	cp kernel.bin sysroot/boot/kernel.bin
	cp boot.bin   sysroot/boot/boot.bin


asterix.iso: sysroot bootloader kernel
	grub-mkrescue -o $@ sysroot
.PHONY : asterix.iso

asterix: asterix.iso
disk:    asterix.iso
cdrom:   asterix.iso
cd:      asterix.iso

stats:
	cloc --yaml . | grep -E 'Assembly:|C:' -A 4 | sed 's/nFiles/files/'
	echo -n "Total: " && cloc --yaml . | grep -E 'SUM:' -A 4 | grep 'code: ' | sed 's/.*code: //g;s/$$/ SLoC/g'
.PHONY : stats
.SILENT : stats

%.o: %.asm
	nasm -I ${SRC_DIR}/ -f elf32 $^ -o $@

clean:
	rm *.bin
	rm *.iso
.PHONY : clean
