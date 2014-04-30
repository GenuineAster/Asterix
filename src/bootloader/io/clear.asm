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
	;push bx
	mov bh, %1
	call clear
	;pop bx
%endmacro


; calls the BIOS interrupt that clears the screen (plus some)
clear:
	push ax
	push cx
	push dx
	mov ax, 0x0600
	xor cx, cx
	mov dx, 0xFFFF
	int 0x10
	pop dx
	pop cx
	pop ax
	ret

%endif