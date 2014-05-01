; print.asm
;-------------
; Prints text to screen using BIOS interrupts
;-------------

%ifndef BIOS_PRINT_INC
%define BIOS_PRINT_INC

	BITS 16

;%include "bootloader/print/putsreg8.asm"
;%include "bootloader/bios/print/putsreg16.asm"
%include "bootloader/bios/print/putc.asm"
%include "bootloader/bios/print/puts.asm"

%macro bios_print_string 2
	bios_print_string %1
	bios_print_string %2
%endmacro

%macro bios_print_string 3
	bios_print_string %1, %2
	bios_print_string %3
%endmacro

%macro bios_print_char 2
	bios_print_char %1
	bios_print_char %2
%endmacro

%macro bios_print_char 3
	bios_print_char %1, %2
	bios_print_char %3
%endmacro

%endif