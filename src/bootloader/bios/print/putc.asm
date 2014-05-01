; putc.asm
;-------------
; prints a single character from al
;-------------

%ifndef BIOS_PUTC_ASM
%define BIOS_PUTC_ASM

	BITS 16

; Print Char macro:
;   desc: prints a single character
;   args: 1
;     arg1: the char to print
;   end
%macro bios_print_char 1
	mov al, %1
	call bios_putc
%endmacro

bios_putc:
	mov ah, 0xE
	int 0x10
	ret

%endif