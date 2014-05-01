jmp kernel

	BITS 32

kernel:
	mov esi, kernelstr
	call puts
	mov esi, kernelstr
	call puts
	mov esi, kernelstr
	call puts
	mov esi, kernelstr
	call puts
	mov esi, kernelstr
	call puts
	mov esi, kernelstr
	call puts
	mov esi, kernelstr
	call puts
	mov esi, kernelstr
	call puts

	jmp $

puts:
	pusha

	mov edx, 0xb8000
	.loop:
	cmp [esi], byte 0
	je .end
	mov ah, 0x0f
	mov al, [esi]
	mov [edx], eax
	inc esi
	add edx, 2
	jmp .loop

	.end:
	popa
	ret

kernelstr db "Booting INKERNEX kernel!", 0
