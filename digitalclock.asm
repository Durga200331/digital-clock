; sum.asm

section .data
    msg1 db "Enter the first number: ", 0
    len1 equ $ - msg1

    msg2 db "Enter the second number: ", 0
    len2 equ $ - msg2

    msg3 db "The sum is: ", 0
    len3 equ $ - msg3

section .bss
    num1 resb 5
    num2 resb 5

section .text
    global _start

_start:
    ; Print message 1
    mov eax, 4       ; syscall number for sys_write
    mov ebx, 1       ; file descriptor 1 (stdout)
    mov ecx, msg1    ; message to write
    mov edx, len1    ; message length
    int 0x80         ; invoke syscall

    ; Read input for num1
    mov eax, 3       ; syscall number for sys_read
    mov ebx, 0       ; file descriptor 0 (stdin)
    mov ecx, num1    ; buffer to read into
    mov edx, 5       ; maximum bytes to read
    int 0x80         ; invoke syscall

    ; Convert input to integer (num1)
    mov ebx, num1
    call atoi

    ; Print message 2
    mov eax, 4       ; syscall number for sys_write
    mov ebx, 1       ; file descriptor 1 (stdout)
    mov ecx, msg2    ; message to write
    mov edx, len2    ; message length
    int 0x80         ; invoke syscall

    ; Read input for num2
    mov eax, 3       ; syscall number for sys_read
    mov ebx, 0       ; file descriptor 0 (stdin)
    mov ecx, num2    ; buffer to read into
    mov edx, 5       ; maximum bytes to read
    int 0x80         ; invoke syscall

    ; Convert input to integer (num2)
    mov ebx, num2
    call atoi

    ; Calculate sum
    mov eax, [num1_int]
    add eax, [num2_int]

    ; Print result message
    mov eax, 4       ; syscall number for sys_write
    mov ebx, 1       ; file descriptor 1 (stdout)
    mov ecx, msg3    ; message to write
    mov edx, len3    ; message length
    int 0x80         ; invoke syscall

    ; Convert sum to string and print
    mov ebx, eax     ; result in eax
    call itoa
    mov edx, eax     ; message length
    int 0x80         ; invoke syscall

    ; Exit program
    mov eax, 1       ; syscall number for sys_exit
    xor ebx, ebx     ; exit status
    int 0x80         ; invoke syscall

; Procedure to convert string to integer
atoi:
    xor eax, eax     ; clear eax
    xor edx, edx     ; clear edx
    .atoi_loop:
        cmp byte [ebx], 0 ; check for end of string
        je .atoi_done
        sub byte [ebx], '0' ; convert char to integer
        inc ebx       ; next char
        imul eax, 10  ; multiply by 10
        add eax, edx  ; add to result
        jmp .atoi_loop
    .atoi_done:
        mov [num1_int], eax ; store the integer in num1_int
        ret

; Procedure to convert integer to string
itoa:
    xor ecx, ecx     ; clear ecx
    mov ebx, esp     ; store string at the top of the stack
    add ebx, 20      ; reserve space for the maximum size of a 32-bit integer string
    .itoa_loop:
        dec ebx       ; move to next byte in the buffer
        xor edx, edx  ; clear edx
        div dword [esp] ; divide eax by 10
        add dl, '0'   ; remainder becomes a character
        mov [ebx], dl ; store character in the buffer
        inc ecx       ; move to the next character in the buffer
        test eax, eax ; check if there is a remainder
        jnz .itoa_loop ; if there
