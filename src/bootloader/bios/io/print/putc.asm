; putc.asm
;-------------
; prints a single character from al
;-------------

%ifndef PUTC_ASM
%define PUTC_ASM

; Print Char macro:
;   desc: prints a single character
;   args: 1
;     arg1: the char to print
;   end
%macro print_char 1
	mov al, %1
	call putc
%endmacro

putc:
	mov ah, 0xE
	int 0x10
	ret

%endif