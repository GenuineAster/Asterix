all: inkerex.iso

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

kernel.bin:
	nasm ${KERNEL_PATH}/kernel.asm -I ${SRC_DIR}/ -f bin -o $@
.PHONY : kernel.bin

kernel: kernel.bin

inkerex.iso: boot.bin kernel.bin
	cat $^ > ${BOOTSECTOR}
	dd if=/dev/zero of=$@ bs=512 count=2
	dd if=${BOOTSECTOR} of=$@ conv=notrunc
	rm ${BOOTSECTOR}
.PHONY : inkerex.iso

inkerex: inkerex.iso
disk:    inkerex.iso
cdrom:   inkerex.iso
cd:      inkerex.iso

stats:
	cloc --yaml . | grep -E 'Assembly:|C:' -A 4 | sed 's/nFiles/files/'
	echo -n "Total: " && cloc --yaml . | grep -E 'SUM:' -A 4 | grep 'code: ' | sed 's/.*code: //g;s/$$/ SLoC/g'
.PHONY : stats
.SILENT : stats

clean:
	rm *.bin
	rm *.iso
.PHONY : clean
