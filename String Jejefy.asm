global _start
global get_strlen 
global switchloop

section .data
    NULL equ 0
    SYS_EXIT equ 60
    string1 db 'hello everyone', NULL
    strlen dq 0

section .bss
    string2 resb 20

section .text
_start:
    mov rdi, string1        ; rdi points to first char of string1
    mov rsi, strlen         ; rsi points to first char of string2
    call get_strlen         
    mov rcx, qword[strlen]  ; rcx = value of strlen

    mov rsi, string1        ; rsi points to first char of string1
    mov rdi, string2        ; destination pointer to string2
    call switchloop         ; switch characters

    lea rax, [string1]      ; load effective address of string1 to rax (temp pointer to switch)
    mov rsi, string2    
    mov rdi, rax

    cld

string_copy:
    rep movsb               ; copy chars of string2 to string1 (repeat until rcx == 0)
    ret
    
    
exit_here:                   
    mov rax, SYS_EXIT
    xor rdi, rdi
    syscall

switchloop:
    mov r8, rsi              ; use r8 (source pointer) instead of rdi
    mov r9, rdi              ; use r9 (destination pointer) instead of rsi

    pointer_loop:
    mov al, byte[r8]         ; al = value of r8 (copy its value)
    cmp al, NULL             ; al =? NULL 
    je return2               ; ret if al points to end of string

    cmp al, 'a'              
    je a_switch              ; if al == 'a' switch the character for string2
    cmp al, 'e'
    je e_switch              ; else if al == 'e' switch the character for string2  
    cmp al, 'i'
    je i_switch              ; else if al == 'i' switch the character for string2
    cmp al, 'o'
    je o_switch              ; else if al == 'o' switch the character for string2
    cmp al, 'u'
    je u_switch              ; else if al == 'u' switch the character for string2
    jmp copy_char            ; else retain the same char from string1 to string2

    a_switch:   
    mov al, '@'              ; mov new char to al
    jmp store_char           ; store new char in string2 

    e_switch:
    mov al, '3'
    jmp store_char

    i_switch:  
    mov al, '1'
    jmp store_char

    o_switch:
    mov al, '0'
    jmp store_char

    u_switch:
    mov al, 'U'
    jmp store_char

    copy_char:
    mov byte[r9], al         ; copy new char, derived from the vowels, to string2
    inc r8                   ; point to the next char of string1
    inc r9                   ; point to the next char of string2
    jmp pointer_loop         ; loop again

    store_char:         
    mov byte[r9], al         ; copy initial char stored in al to string2
    inc r8                   ; point to the next char of string1
    inc r9                   ; point to the next char of string2
    jmp pointer_loop         ; loop again


    return2:
    mov byte[r9], NULL       ; terminate string2
    ret

get_strlen:
    len_loop:       
    mov al, byte[rdi]        ; al = value of rdi
    cmp al, NULL             ; al =? NULL             
    je return1               ; ret if al points to end of string

    inc rdi                  ; rdi points to the next char              
    inc byte[rsi]            ; increment strlen
    jmp len_loop             ; loop back

    return1:
    ret
