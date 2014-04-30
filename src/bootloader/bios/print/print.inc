; print.asm
;-------------
; Prints text to screen using BIOS interrupts
;-------------

%ifndef PRINT_INC
%define PRINT_INC

	BITS 16

;%include "bootloader/print/putsreg8.asm"
%include "bootloader/bios/print/putsreg16.asm"
%include "bootloader/bios/print/putc.asm"
%include "bootloader/bios/print/puts.asm"

%macro print_string 2
	print_string %1
	print_string %2
%endmacro

%macro print_string 3
	print_string %1, %2
	print_string %3
%endmacro

%macro print_char 2
	print_char %1
	print_char %2
%endmacro

%macro print_char 3
	print_char %1, %2
	print_char %3
%endmacro

%endif