%ifndef BIOS_ERROR_INC
%define BIOS_ERROR_INC
%include "bootloader/constants.asm"
%include "bootloader/bios/print/puts.asm"


bios_error:
	call bios_newline
	mov si, errorstr
	call bios_puts
	mov si, separator
	call bios_puts
	ret

%endif