; bootloader.asm
;-------------
; Main bootloader file
;-------------

	BITS 16
	ORG 0x7C00

jmp bootloader

; Necessary includes for bootloader:
; -> Constants
	%include "bootloader/constants.asm"
; -> IO
    %include "bootloader/bios/io.inc"
; -> Misc
    %include "bootloader/bios/cursor.asm"
    %include "bootloader/bios/error.inc"

bootloader:
	xor ax, ax
	mov ds, ax
	mov ss, ax
	mov [boot_disk], dl

	mov ah, 0x00
	mov al, 0x13
	int 0x10

	push dx
	push bx
	reset_cursor
	clear_screen 0xF
	print_string endl
	pop bx
	pop dx


	mov bl, 0x1
	print_string project
	mov bl, 0xF
	print_string msg_initialized, endl

	call disk.load

	jmp $


msg_initialized  db " bootloader initialized.", 0
boot_disk db 0
times 510-($-$$) db 0	; Pad remainder of boot sector with 0
dw 0xAA55
