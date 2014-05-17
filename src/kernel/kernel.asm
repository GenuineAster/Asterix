	BITS 64

global get_cr0
get_cr0:
	mov rax, cr0
	push rax
	ret

global set_cr0
set_cr0:
	pop rax
	mov cr0, rax
	ret

global get_cr1
get_cr1:
	mov rax, cr1
	push rax
	ret

global set_cr1
set_cr1:
	pop rax
	mov cr1, rax
	ret

global get_cr2
get_cr2:
	mov rax, cr2
	push rax
	ret

global set_cr2
set_cr2:
	pop rax
	mov cr2, rax
	ret

global get_cr3
get_cr3:
	mov rax, cr3
	push rax
	ret

global set_cr3
set_cr3:
	pop rax
	mov cr3, rax
	ret

global get_cr4
get_cr4:
	mov rax, cr4
	push rax
	ret

global set_cr4
set_cr4:
	pop rax
	mov cr4, rax
	ret

global get_rsi
get_rsi:
	mov rax, rsi
	push rax
	ret

section .bss
align 32
stack:
    resb 0x4000
