; putsreg16.asm
;-------------
; prints 16-bit register ax in hexadecimal format
;-------------

%ifndef PUTSREG16_ASM
%define PUTSREG16_ASM
%include "bootloader/bios/io/print/putc.asm"

; prints 16-bit register ax
putsreg16:
	push ax
	push dx
	push bx
	mov si, hexstr
	mov dx, ax
	mov bx, dx
	shr bx, 12
	and bx, 0xF
	add si, bx
	pop bx
	print_char [ds:si]
	push bx
	mov si, hexstr
	mov bx, dx
	shr bx, 8
	and bx, 0xF
	add si, bx
	pop bx
	print_char [ds:si]
	push bx
	mov si, hexstr
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