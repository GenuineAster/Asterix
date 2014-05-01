; cursor.asm
;-------------
; A bunch of cursor management subroutines
;-------------

%ifndef BIOS_CURSOR_ASM
%define BIOS_CURSOR_ASM

	BITS 16

; Defines for cursor shapes
%define bios_cursor_shape_block     0x0007
%define bios_cursor_shape_under     0x0607
%define bios_cursor_shape_invisible 0x2607

; Cursor Position macro:
;   desc: sets the cursor's position
;   args: 2
;     arg1: the new X position for the cursor
;     arg2: the new Y position for the cursor
;   end
%macro bios_cursor_position 2
	mov dx, (%1<<8)+%2
	call bios_set_cursor_position
%endmacro


; Cursor Shape macro:
;   desc: sets the cursor's shape
;   args: 1
;     arg1: the new shape for the cursor
;   end 
%macro bios_cursor_shape 1
	mov cx, %1
	call bios_set_cursor_shape
%endmacro

; Reset Cursor macro:
;   desc: resets the cursor's shape and position
;     to defaults
;   args: 0
;   end
%macro bios_reset_cursor 0
	xor bh, bh
	bios_cursor_shape bios_cursor_shape_under
	bios_cursor_position 0x0, 0x0
%endmacro

; calls the BIOS interrupt that sets cursor position
bios_set_cursor_position:
	push ax
	mov ah, 0x2
	int 0x10
	pop ax
	ret

; calls the BIOS interrupt that sets cursor shape
bios_set_cursor_shape:
	push ax
	mov ah, 0x1
	int 0x10
	pop ax
	ret

%endif