; bootloader.asm
;-------------
; Main bootloader file
;-------------

	ORG 0x7C00

jmp bootloader

; Necessary includes for bootloader:
; -> Constants
	%include "bootloader/constants.asm"
; -> BIOS
    %include "bootloader/bios/bios.inc"
; -> Protected Mode
	%include "bootloader/protected/protected.inc"

	BITS 16

bootloader:
	xor ax, ax
	mov ds, ax
	mov ss, ax
	mov [boot_disk], dl

	mov ax, 2
	int 0x10

	mov cx, 0x2607
	mov ah, 0x1
	int 0x10

	mov si, msg_initialized
	call bios_puts
	call bios_newline

	mov si, msg_loading_from_disk
	call bios_puts
	mov bx, kernel_start
	mov dl, [boot_disk]
	mov dh, 1
	mov al, 4 ; number of sectors to read
	call bios_disk.load

	call bios_newline
	mov si, msg_enter_protected
	call bios_puts
	call bios_newline

	mov bh, 0x0
	mov ah, 0x3
	int 0x10
	mov [xpos], dl
	mov [ypos], dh

	cli
	lgdt [gdt_descriptor]
	mov eax, cr0
	or  eax, 0x1
	mov cr0, eax
	jmp CODE_SEG:protected_init

	hlt

bios_newline:
	mov si, endl
	call bios_puts
	ret

boot_disk db 0
msg_initialized db "Asterix bootloader initialized.", 0
msg_loading_from_disk db "Loading kernel from disk.", 0
msg_enter_protected db "Entering Protected Mode.", 0
times 510-($-$$) db 0
dw 0xAA55
