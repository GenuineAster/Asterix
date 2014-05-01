%ifndef BIOS_ERROR_INC
%define BIOS_ERROR_INC
%include "bootloader/constants.asm"
%include "bootloader/bios/print/puts.asm"

	BITS 16

%macro bios_error 0
	mov bl, 0x4
	bios_print_string errorstr
	mov bl, 0xF
	bios_print_string separator
%endmacro

%endif