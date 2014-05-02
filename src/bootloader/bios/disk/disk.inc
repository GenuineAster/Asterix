%ifndef BIOS_DISK_INC
%define BIOS_DISK_INC

%include "bootloader/bios/print/print.inc"
%include "bootloader/constants.asm"
%include "bootloader/bios/error.inc"


bios_disk:
	.load:
		mov ah, 0x02
		push ax
		mov cx, 0x0002
		mov dh, 0x00
		int 0x13
		jc .readerror
		pop dx
		cmp dl, al
		jne .readerror
		ret

	.readerror:
		call bios_error
		mov si, readerror_msg
		call bios_puts
		jmp $

readerror_msg db "Failed to read disk properly.", 0

%endif