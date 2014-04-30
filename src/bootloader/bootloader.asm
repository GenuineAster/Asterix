; bootloader.asm
;-------------
; Main bootloader file
;-------------

	BITS 16

jmp bootloader

; Necessary includes for bootloader:
; -> IO
    %include "bootloader/print.asm"
    %include "bootloader/clear.asm"
    %include "bootloader/cursor.asm"

bootloader:
	mov ax, 0x7C0		; Set up 4K stack space after this bootloader
	add ax, 288			; (4096 + 512) / 16 bytes per paragraph
	mov ss, ax
	mov sp, 4096

	mov ax, 0x7C0		; Set data segment to where we're loaded
	mov ds, ax

	reset_cursor
	clear_screen 0xF
	reset_cursor
	print_string msg

	jmp $				; Jump here - infinite loop!

	msg db "Starting INKEREX bootloader..", 0


times 510-($-$$) db 0	; Pad remainder of boot sector with 0s
dw 0xAA55				; The standard PC boot signature