%ifndef PROTECTED_START_ASM
%define PROTECTED_START_ASM

%include "bootloader/constants.asm"
%include "bootloader/protected/io/print/print.inc"

	BITS 32

protected_start:
	mov esi, msg_in_protected_mode
	call protected_puts

	mov esi, msg_call_kernel
	call protected_puts

	; Save cursor position for loading within kernel
	movzx ebx, byte [xpos]
	movzx ecx, byte [ypos]
	; Call kernel start addr
	call 0x8:kernel_start
	jmp $

msg_in_protected_mode db "Now in Protected Mode!", 0
msg_call_kernel db "Calling kernel..", 0

%endif