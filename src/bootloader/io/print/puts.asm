; puts.asm
;-------------
; prints a string from si
;-------------

%ifndef PUTS_ASM
%define PUTS_ASM

; Print String macro:
;   desc: prints the specified string
;   args: 1
;     arg1: the string to print
;   end
%macro print_string 1
	push ax
	mov si, word %1
	call puts
	pop ax
%endmacro

; initiates a BIOS print loop for the string in si
puts:
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