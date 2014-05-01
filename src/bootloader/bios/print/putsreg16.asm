; putsreg16.asm
;-------------
; prints 16-bit register ax in hexadecimal format
;-------------

%ifndef BIOS_PUTSREG16_ASM
%define BIOS_PUTSREG16_ASM
%include "bootloader/bios/print/putc.asm"

	BITS 16

; prints 16-bit register ax
bios_putsreg16:
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
	bios_print_char [ds:si]
	push bx
	mov si, hexstr
	mov bx, dx
	shr bx, 8
	and bx, 0xF
	add si, bx
	pop bx
	bios_print_char [ds:si]
	push bx
	mov si, hexstr
	mov bx, dx
	shr bx, 4
	and bx, 0xF
	add si, bx
	pop bx
	bios_print_char [ds:si]
	push bx
	mov si, hexstr
	mov bx, dx
	and bx, 0xF
	add si, bx
	pop bx
	bios_print_char [ds:si]
	mov ax, dx
	pop dx
	pop ax
	ret

%endif