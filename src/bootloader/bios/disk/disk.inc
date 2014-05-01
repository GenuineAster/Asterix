%ifndef BIOS_DISK_INC
%define BIOS_DISK_INC

%include "bootloader/bios/print/print.inc"
%include "bootloader/constants.asm"
%include "bootloader/bios/error.inc"

	BITS 16

bios_disk:
	.load:
		push dx
		mov ah, 0x02
		mov al, dh
		mov ch, 0x00
		mov cl, 0x2
		mov dh, 0x00
		int 0x13
		jc .readerror
		pop dx
		cmp dh, al
		jne .readerror
		ret

	.readerror:
		bios_error
		bios_print_string readerror_msg, endl
		jmp $

readerror_msg db "Failed to read disk disk properly.", 0

%endif