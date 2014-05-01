%ifndef PROTECTED_PUTS_ASM
%define PROTECTED_PUTS_ASM
	BITS 32

%macro protected_print_string 1
	mov esi, %1
	call protected_puts
%endmacro

dochar:
    call protected_putc      ; print one character

protected_puts:
    mov eax, [esi]           ; string char to AL
    lea esi, [esi+1]
    cmp al, 0
    jne dochar               ; else, we're done
    add byte [ypos], 1       ; down one row
    mov byte [xpos], 0       ; back to left
    ret
 
protected_putc:
    mov ah, 0x0F             ; attrib = white on black
    mov ecx, eax             ; save char/attribute
    movzx eax, byte [ypos]
    mov edx, 160             ; 2 bytes (char/attrib)
    mul edx                  ; for 80 columns
    movzx ebx, byte [xpos]
    shl ebx, 1               ; times 2 to skip attrib
 
    mov edi, 0xb8000         ; start of video memory
    add edi, eax             ; add y offset
    add edi, ebx             ; add x offset
 
    mov eax, ecx             ; restore char/attribute
    mov word [ds:edi], ax
    add byte [xpos], 1       ; advance to right
 
    ret

%endif