all: boot.bin

SRC_DIR = src
BOOTLOADER_DIR = bootloader
BOOTLOADER_PATH = ${SRC_DIR}/${BOOTLOADER_DIR}

boot.bin:
	nasm ${BOOTLOADER_PATH}/bootloader.asm -I ${SRC_DIR}/ -f bin -o $@

clean:
	rm *.bin
