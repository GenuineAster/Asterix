%ifndef PROTECTED_START_ASM
%define PROTECTED_START_ASM

%include "bootloader/constants.asm"
%include "bootloader/protected/io/print/print.inc"

	BITS 32

protected_start:
	protected_print_string in_protected_mode
	call kernel_start+1
	jmp $

in_protected_mode db " Welcome to Protected Mode!", 0

%endif