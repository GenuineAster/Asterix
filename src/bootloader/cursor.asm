; cursor.asm
;-------------
; A bunch of cursor management subroutines
;-------------

%ifndef CURSOR_ASM
%define CURSOR_ASM

	BITS 16

; Defines for cursor shapes
%define cursor_shape_block     0x0007
%define cursor_shape_under     0x0607
%define cursor_shape_invisible 0x2607

; Cursor Position macro:
;   desc: sets the cursor's position
;   args: 2
;     arg1: the new X position for the cursor
;     arg2: the new Y position for the cursor
;   end
%macro cursor_position 2
	mov dh, %1
	mov dl, %2
	call set_cursor_position
%endmacro


; Cursor Shape macro:
;   desc: sets the cursor's shape
;   args: 1
;     arg1: the new shape for the cursor
;   end 
%macro cursor_shape 1
	mov cx, %1
	call set_cursor_shape
%endmacro

; Reset Cursor macro:
;   desc: resets the cursor's shape and position
;     to defaults
;   args: 0
;   end
%macro reset_cursor 0
	xor bh, bh
	cursor_shape cursor_shape_under
	cursor_position 0x0, 0x0
%endmacro

; calls the BIOS interrupt that sets cursor position
set_cursor_position:
	push ax
	mov ah, 0x2
	int 0x10
	pop ax
	ret

; calls the BIOS interrupt that sets cursor shape
set_cursor_shape:
	push ax
	mov ah, 0x1
	int 0x10
	pop ax
	ret

%endif