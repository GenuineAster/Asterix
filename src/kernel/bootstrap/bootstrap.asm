	BITS 32

MBALIGN			equ  1<<0
MBMEMINFO		equ  1<<1
MBFLAGS			equ  MBALIGN | MBMEMINFO
MBMAGIC			equ  0x1BADB002
MBCHECKSUM		equ -(MBMAGIC + MBFLAGS)

section .multiboot
multiboot_header:
	align 4
	dd MBMAGIC
	dd MBFLAGS
	dd MBCHECKSUM

section .gdt
gdt:
	.null equ $ - gdt
	dw 0
	dw 0
	db 0
	db 0
	db 0
	db 0
	.code equ $ - gdt
	dw 0
	dw 0
	db 0
	db 0b10011000
	db 0b00100000
	db 0
	.data equ $ - gdt
	dw 0
	dw 0
	db 0
	db 0b10010000
	db 0b00000000 
	db 0
	.pointer:
	dw $ - gdt - 1
	dq gdt
.endgdt:

section .text

extern kmain
extern paging_setup
global bootstrap

print_dot:
	mov al, '.'
	mov ah, 0x0F
	mov ecx, eax
	mov eax, 0
	mov edx, 160
	mul edx
	movzx ebx, byte [tmp]
	shl ebx, 1

	push edi

	mov edi, 0xB8000
	add edi, eax
	add edi, ebx

	mov eax, ecx
	mov word [ds:edi], ax
	add byte [tmp], 2

	pop edi
	ret


bootstrap:
	call print_dot

	xor  eax, eax
	push ebx ; Push ebx to stack for multiboot

	call print_dot
	
	; Check for CPUID
	pushfd
	pop eax
	mov ecx, eax
	xor eax, 1 << 21
	push eax
	popfd
	pushfd
	pop eax
	push ecx
	popfd
	xor eax, ecx
	jz .end
	
	call print_dot

	; check for long mode
	mov eax, 0x80000000
	cpuid
	cmp eax, 0x80000001
	jb .end
	mov eax, 0x80000001
	cpuid
	test edx, 1 << 29
	jz .end

	call print_dot

	; enter long mode

	;   disable paging
	mov eax, cr0
	and eax, (1<<31)-1
	mov cr0, eax

	; Clear memory that will
	; contain page tables stuff
	mov edi, 0xC1000
	mov cr3, edi
	xor eax, eax
	mov ecx, 4096
	rep stosd
	mov edi, cr3

	; set up paging tables
	mov dword [edi], 0xC2003
	add edi, 0x1000
	mov dword [edi], 0xC3003
	add edi, 0x1000
	mov dword [edi], 0xC4003
	add edi, 0x1000

	; identity map the first 4 MiB

	mov ebx, 0xC0003
	mov ecx, 0x200

	.se:
		mov dword [edi], ebx
		add ebx, 0x1000
		add edi, 8
		loop .se


	;   enable PAE paging
	mov eax, cr4
	or  eax, 1 << 5
	mov cr4, eax

	call print_dot

	;   set LM-bit
	mov ecx, 0xC0000080
	rdmsr
	or  eax, 1 << 8
	wrmsr

	call print_dot

	;   enable paging
	mov eax, cr0
	or  eax, 1 << 31
	mov cr0, eax

	call print_dot
	jmp $

	;   load 64-bit gdt
	lgdt [gdt.pointer]
	;   jump to 64-bit entry point
	jmp gdt.code:entry64

	call print_dot

	.end:
		hlt
		jmp $

	BITS 64

entry64:
	call print_dot

	cli
	call kmain

	call print_dot

	.end:
	hlt   ; stop execution
	jmp $ ; really stop execution
	; WHY HAVEN'T YOU STOPPED YET?!
	; STOP
	; SERIOUSLY
	; YOU WILL DIE BEYOND THIS COMMENT
	cli ; Fine!
	hlt ; You asked for it!
	; ..Please stop?
	.halt:
	hlt  ; I'll give you money
	jmp .halt
	; Okay, fine! You win! I give up!
	; Have fun trying to run *whatever*
	; is in RAM right now.


	; Asshat.

tmp db 0
