; putsreg8.asm
;-------------
; prints 8-bit register ax in hexadecimal format
;-------------

%ifndef PUTSREG8_ASM
%define PUTSREG8_ASM
%include "bootloader/bios/print/putc.asm"

; prints 8-bit register ax
putsreg8:
	push ax
	push dx
	push bx
	mov si, hexstr
	mov dx, ax
	mov bx, dx
	shr bx, 4
	and bx, 0xF
	add si, bx
	pop bx
	print_char [ds:si]
	push bx
	mov si, hexstr
	mov bx, dx
	and bx, 0xF
	add si, bx
	pop bx
	print_char [ds:si]
	mov ax, dx

	pop dx
	pop ax
	ret

%endif