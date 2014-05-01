; puts.asm
;-------------
; prints a string from si
;-------------

%ifndef BIOS_PUTS_ASM
%define BIOS_PUTS_ASM

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