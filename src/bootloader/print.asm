; print.asm
;-------------
; Prints text to screen using BIOS interrupts
;-------------

	BITS 16

; Print String macro:
;   desc: prints the specified string
;   args: 1
;     arg1: the string to print
;   end
%macro print_string 1
	mov si, word %1
	call print
%endmacro


; initiates a BIOS print loop for the string in si
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
