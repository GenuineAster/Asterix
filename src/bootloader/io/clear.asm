; clear.asm
;-------------
; Clears the screen
;-------------

%ifndef CLEAR_ASM
%define CLEAR_ASM

	BITS 16

; Clear Screen macro:
;   args: 1
;     arg1:
;       The BIOS color attr to clear with
;   end
%macro clear_screen 1
	push bx
	mov bh, %1
	call clear
	pop bx
%endmacro


; calls the BIOS interrupt that clears the screen (plus some)
clear:
	push ax
	push cx
	push dx
	mov ah, 0x6
	mov al, 0x0
	mov ch, 0x00
	mov cl, 0x00
	mov dh, 0xFF
	mov dl, 0xFF
	int 0x10
	pop dx
	pop cx
	pop ax
	ret

%endif