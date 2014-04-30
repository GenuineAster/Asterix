%ifndef DISK_INC
%define DISK_INC

%include "bootloader/io/print/print.inc"
%include "bootloader/constants.asm"
%include "bootloader/error.inc"

disk:
	.load:
		push ax
		push cx
		push dx

		mov ah, 0x02
		mov dh, 1
		mov al, dh
		mov ch, 0
		mov cl, 2
		xor dh, dh
		int 0x13

		jc .readerror

		pop dx

		cmp dh, al
		jne .readerror

		pop cx
		pop ax

		ret



	.readerror:
		call error
		print_string readerror_msg, endl
		jmp $

readerror_msg db "Error when reading from disk.", 0

%endif