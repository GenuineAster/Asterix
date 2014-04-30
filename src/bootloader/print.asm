; print.asm
;-------------
; Prints text to screen using BIOS interrupts
;-------------

	BITS 16

%macro print_string 1
	mov si, word %1
	call print
%endmacro

print:
	mov ah, 0xE
.printloop:
	lodsb
	cmp al, 0
	je .end
	int 0x10
	jmp .printloop
.end:
	ret
