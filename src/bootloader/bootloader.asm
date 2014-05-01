; bootloader.asm
;-------------
; Main bootloader file
;-------------

jmp bootloader

; Necessary includes for bootloader:
; -> Constants
	%include "bootloader/constants.asm"
; -> BIOS
    %include "bootloader/bios/bios.inc"
; -> Protected Mode
	%include "bootloader/protected/protected.inc"

	BITS 16
	ORG 0x7C00

bootloader:
	xor ax, ax
	mov ds, ax
	mov ss, ax
	mov [boot_disk], dl


	mov ax, 2
	int 0x10

	bios_print_string endl
	bios_print_string project, msg_initialized, endl

	mov bx, kernel_start
	mov dh, 1
	mov dl, [boot_disk]
	call bios_disk.load

	push bx
	push cx
	push dx
	mov bh, 0x0
	mov ah, 0x3
	int 0x10
	mov byte [xpos], 0
	mov byte [ypos], dl
	inc byte [ypos]
	pop dx
	pop cx
	pop bx

	cli
	lgdt [gdt_descriptor]
	mov eax, cr0
	or  eax, 0x1
	mov cr0, eax
	jmp CODE_SEG:protected_init

	jmp $


msg_initialized  db " bootloader initialized.", 0
boot_disk db 0
times 510-($-$$) db 0	; Pad remainder of boot sector with 0
dw 0xAA55
