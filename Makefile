all: inkerex.iso

SRC_DIR = src
BOOTLOADER_DIR = bootloader
BOOTLOADER_PATH = ${SRC_DIR}/${BOOTLOADER_DIR}
BOOTSECTOR = bootsector.bin.tmp

boot.bin: 
	nasm ${BOOTLOADER_PATH}/bootloader.asm -I ${SRC_DIR}/ -f bin -o $@
.PHONY : boot.bin

inkerex.iso: boot.bin
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
.PHONY : clean
