%ifndef ERROR_INC
%define ERROR_INC
%include "bootloader/constants.asm"
%include "bootloader/io/print/puts.asm"

%macro error 0
	push bx
	mov bl, 0x4
	print_string errorstr
	print_string separator
	pop bx
%endmacro

%endif