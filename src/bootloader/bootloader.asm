; bootloader.asm
;-------------
; Main bootloader file
;-------------

	BITS 16
	ORG 0x7C00

jmp bootloader

; Necessary includes for bootloader:
; -> IO
    %include "bootloader/io/io.inc"
; -> Misc
    %include "bootloader/cursor.asm"
    %include "bootloader/constants.asm"

bootloader:
	xor ax, ax
	mov ds, ax
	mov ss, ax

	mov ah, 0x00
	mov al, 0x13
	int 0x10

	reset_cursor
	clear_screen 0xF
	reset_cursor
	print_string endl


	mov bl, 0x4
	print_string project
	mov bl, 0xF
	print_char 32
	print_string initialized, endl

	jmp $


error db "Error!", 0
initialized  db "bootloader initialized..", 0
times 510-($-$$) db 0	; Pad remainder of boot sector with 0
dw 0xAA55
