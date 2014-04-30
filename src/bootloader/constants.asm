; constants.asm
;-------------
; This file contains several useful constants
;-------------

	BITS 16

%ifndef CONSTANTS_ASM
%define CONSTANTS_ASM

%define true  1
%define false 0
%define TRUE  true
%define FALSE false
%define True  true
%define False false
endl db 13, 10, 0
reg16 dw 0
project db "INKEREX", 0
hexstr db '0123456789ABCDEF'
decstr db '0123456789'
octstr db '01234567'
binstr db '01'
%endif