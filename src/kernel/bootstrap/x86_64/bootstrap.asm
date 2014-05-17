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
extern setup_paging
global bootstrap

bootstrap:

	push eax
	push ebx
	xor  eax, eax

	
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
	

	; check for long mode
	mov eax, 0x80000000
	cpuid
	cmp eax, 0x80000001
	jb .end
	mov eax, 0x80000001
	cpuid
	test edx, 1 << 29
	jz .end


	; enter long mode

	mov eax, cr0                                   ; Set the A-register to control register 0.
    and eax, 01111111111111111111111111111111b     ; Clear the PG-bit, which is bit 31.
    mov cr0, eax                                   ; Set control register 0 to the A-register.
    mov edi, 0x1000    ; Set the destination index to 0x1000.
    mov cr3, edi       ; Set control register 3 to the destination index.
    xor eax, eax       ; Nullify the A-register.
    mov ecx, 4096      ; Set the C-register to 4096.
    rep stosd          ; Clear the memory.
    mov edi, cr3       ; Set the destination index to control register 3.
    mov DWORD [edi], 0x2003      ; Set the double word at the destination index to 0x2003.
    add edi, 0x1000              ; Add 0x1000 to the destination index.
    mov DWORD [edi], 0x3003      ; Set the double word at the destination index to 0x3003.
    add edi, 0x1000              ; Add 0x1000 to the destination index.
    mov DWORD [edi], 0x4003      ; Set the double word at the destination index to 0x4003.
    add edi, 0x1000              ; Add 0x1000 to the destination index.
   	mov ebx, 0x00000003          ; Set the B-register to 0x00000003.
    mov ecx, 1024                ; Set the C-register to 512.
 
.SetEntry:
    mov DWORD [edi], ebx         ; Set the double word at the destination index to the B-register.
    add ebx, 0x1000              ; Add 0x1000 to the B-register.
    add edi, 8                   ; Add eight to the destination index.
    loop .SetEntry               ; Set the next entry.

    mov eax, cr4                 ; Set the A-register to control register 4.
    or eax, 1 << 5               ; Set the PAE-bit, which is the 6th bit (bit 5).
    mov cr4, eax                 ; Set control register 4 to the A-register.

    pop ebx

    mov ecx, 0xC0000080          ; Set the C-register to 0xC0000080, which is the EFER MSR.
    rdmsr                        ; Read from the model-specific register.
    or eax, 1 << 8               ; Set the LM-bit which is the 9th bit (bit 8).
    wrmsr                        ; Write to the model-specific register.

    mov eax, cr0                 ; Set the A-register to control register 0.
    or eax, 1 << 31              ; Set the PG-bit, which is the 32nd bit (bit 31).
    mov cr0, eax                 ; Set control register 0 to the A-register.


    pop ebx
    pop eax
	;   load 64-bit gdt
	lgdt [gdt.pointer]
	;   jump to 64-bit entry point
	jmp gdt.code:entry64


	.end:
		hlt
		jmp $

	BITS 64

entry64:
	cli
	mov rdi, 0x10000
	mov rsi, rbx
	mov ax, gdt.data
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	;mov edi, 0xB8000

	shl rbx, 32
	and rax, rbx
	push rax
	call kmain

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
