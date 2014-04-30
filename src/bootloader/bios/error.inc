%ifndef ERROR_INC
%define ERROR_INC
%include "bootloader/constants.asm"
%include "bootloader/bios/io/print/puts.asm"

%macro error 0
	mov bl, 0x4
	print_string errorstr
	mov bl, 0xF
	print_string separator
%endmacro

%endif