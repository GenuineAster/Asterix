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

kernel.bin:
	nasm ${KERNEL_PATH}/kernel.asm -I ${SRC_DIR}/ -f bin -o $@
.PHONY : kernel.bin

kernel: kernel.bin

asterix.iso: boot.bin kernel.bin
	dd if=/dev/zero of=$@ bs=512 count=65536
	(echo -e "o\nn\np\n1\n\n\na\n1\nw\n" | fdisk $@) &> /dev/null
	cat $< > ${BOOTSECTOR}
	dd if=${BOOTSECTOR} of=$@ conv=notrunc
	rm ${BOOTSECTOR}
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

clean:
	rm *.bin
	rm *.iso
.PHONY : clean
