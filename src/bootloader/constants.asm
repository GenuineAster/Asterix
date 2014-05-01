; constants.asm
;-------------
; This file contains several useful constants
;-------------

%ifndef CONSTANTS_ASM
%define CONSTANTS_ASM

%define true  1
%define false 0
%define TRUE  true
%define FALSE false
%define True  true
%define False false
endl db 13, 10, 32, 0
reg16 dw 0
;reg8  db 0
project   db "INKEREX", 0
errorstr  db "Error", 0
separator db ": ", 0
hexstr    db '0123456789ABCDEF'
;decstr  db '0123456789'
;octstr  db '01234567'
;binstr  db '01'

gdt_start:
gdt_null:
	dd 0
	dd 0
gdt_code:
	dw 0xFFFF
	dw 0
	db 0
	db 0b10011010
	db 0b11001111
	db 0
gdt_data:
	dw 0xFFFF
	dw 0
	db 0
	db 0b10010010
	db 0b11001111
	db 0
gdt_end:

gdt_descriptor:
	dw gdt_end - gdt_start - 1
	dd gdt_start

kernel_start equ 0x1200

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

xpos db 0
ypos db 0

%endif
