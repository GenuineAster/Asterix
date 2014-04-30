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
	call puts
%endmacro

%macro print_string 2
	print_string %1
	print_string %2
%endmacro

%macro print_string 3
	print_string %1, %2
	print_string %3
%endmacro

%macro print_char 1
	mov al, %1
	call putc
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

; prints a single character
putc:
	mov ah, 0xE
	int 0x10
	ret
