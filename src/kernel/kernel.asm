[ORG 0x2000]
	BITS 32

mov ax, 0
mov ds, ax

global kernel

jmp kernel

setup:
	call load_cursor_pos
	ret

kernel:
	call setup
	mov ah , 0x0F
	mov esi, welcomestr
	call puts
	mov esi, punct_space
	call puts
	mov ah, 0x01
	mov esi, project
	call puts
	mov ah, 0x0F
	mov esi, punct_space
	call puts
	mov esi, kernelstr
	call puts
	mov esi, punct_excl
	call puts
	mov esi, endl
	call puts
	jmp $

dochar:
    call putc

puts:
	push cx
	push ax
    mov eax, [esi]
    lea esi, [esi+1]
    cmp al, 0
    pop cx
    mov ah, ch
    pop cx
    jne dochar
    ret
 
putc:
	.test_cr:
		cmp al, 13
		jne .test_lf
		call cr
		ret

	.test_lf:
		cmp al, 10
		jne .normal_char
		call lf
		ret

	.normal_char:
	    mov ecx, eax
	    movzx eax, byte [ypos]
	    mov edx, 160
	    mul edx
	    movzx ebx, byte [xpos]
	    shl ebx, 1
	 
	    mov edi, 0xb8000
	    add edi, eax
	    add edi, ebx
	 
	    mov eax, ecx
	    mov word [ds:edi], ax
	    inc byte [xpos]
	    ret

cr:
	mov byte [xpos], 0
	ret

lf:
	inc byte [ypos]
	ret

load_cursor_pos:
	mov byte [xpos], bl
	mov byte [ypos], cl
	ret

welcomestr db "Welcome to the", 0
project db "INKEREX", 0
kernelstr db "kernel", 0
punct_space db " ", 0
punct_dot   db ".", 0
punct_ques  db "?", 0
punct_comm  db ",", 0
punct_excl  db "!", 0
endl db 13, 10, 0
padding db " ", 0
xpos db 0
ypos db 0
