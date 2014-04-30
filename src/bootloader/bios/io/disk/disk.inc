%ifndef DISK_INC
%define DISK_INC

%include "bootloader/bios/io/print/print.inc"
%include "bootloader/constants.asm"
%include "bootloader/bios/error.inc"

disk:
	.load:
		push dx
		mov ax, 0x0201
		mov cx, 0x0002
		xor dh, dh
		int 0x13
		jc .readerror
		pop dx
		cmp dh, al
		jne .readerror
		ret

	.readerror:
		error
		print_string readerror_msg, endl
		jmp $

readerror_msg db "disk read", 0

%endif