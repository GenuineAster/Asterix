; print.asm
;-------------
; Prints text to screen using BIOS interrupts
;-------------

%ifndef BIOS_PRINT_INC
%define BIOS_PRINT_INC

%include "bootloader/bios/print/puts.asm"

%endif