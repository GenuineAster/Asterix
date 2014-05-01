; puts.asm
;-------------
; prints a string from si
;-------------

%ifndef BIOS_PUTS_ASM
%define BIOS_PUTS_ASM

	BITS 16

; Print String macro:
;   desc: prints the specified string
;   args: 1
;     arg1: the string to print
;   end
%macro bios_print_string 1
	mov si, %1
	call bios_puts
%endmacro

; initiates a BIOS print loop for the string in si
bios_puts:
 	mov ah, 0xE
 .putsloop:
 	lodsb
 	cmp al, 0
 	je .end
 	int 0x10
 	jmp .putsloop
 .end:
	ret
%endif