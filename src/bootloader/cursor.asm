; cursor.asm
;-------------
; A bunch of cursor management subroutines
;-------------

	BITS 16

%macro cursor_position 2
	mov dh, %1
	mov dl, %2
	call set_cursor_position
%endmacro

%define cursor_shape_block     0x0007
%define cursor_shape_under     0x0607
%define cursor_shape_invisible 0x2607

%macro cursor_shape 1
	mov ch, 0x0
	mov cl, 0xF
	mov cx, %1
	call set_cursor_shape
%endmacro

%macro reset_cursor 0
	mov bh, 0x0
	cursor_shape cursor_shape_under
	cursor_position 0x0, 0x0
%endmacro


set_cursor_position:
	mov ah, 0x2
	int 0x10
	ret

set_cursor_shape:
	mov ah, 0x1
	int 0x10
	ret