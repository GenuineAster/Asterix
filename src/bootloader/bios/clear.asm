; clear.asm
;-------------
; Clears the screen
;-------------

%ifndef BIOS_CLEAR_ASM
%define BIOS_CLEAR_ASM

	BITS 16

; Clear Screen macro:
;   args: 1
;     arg1:
;       The BIOS color attr to clear with
;   end
%macro bios_clear_screen 1
	;push bx
	mov bh, %1
	call bios_clear
	;pop bx
%endmacro


; calls the BIOS interrupt that clears the screen (plus some)
bios_clear:
	push ax
	mov ax, 0x13
	int 0x10
	pop ax
	ret

%endif