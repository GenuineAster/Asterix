%ifndef PROTECTED_INIT_ASM
%define PROTECTED_INIT_ASM

%include "bootloader/constants.asm"
%include "bootloader/protected/start.asm"

	BITS 32

protected_init:
	mov ax, DATA_SEG
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

	mov ebp, 0x90000
	mov esp, ebp

	jmp protected_start

%endif