section .data
    source db "section .data%1$c    source db %2$c%3$s%2$c, 0x0%1$c%1$csection .text%1$c    global _start%1$c    extern printf%1$c    extern exit%1$c%1$c_start:%1$c    ; This is a comment inside main%1$c    call print_source%1$c    mov rax, 60%1$c    xor rdi, rdi%1$c    call exit%1$c%1$cprint_source:%1$c    push rbp%1$c    mov rbp, rsp%1$c    mov rdi, source%1$c    mov rsi, 10%1$c    mov rdx, 34%1$c    mov rcx, source%1$c    call printf%1$c    mov rsp, rbp%1$c    pop rbp%1$c    ret%1$c%1$c; This is a comment outside functions", 0x0

section .text
    global _start
    extern printf
    extern exit

_start:
    ; This is a comment inside main
    call print_source
    mov rax, 60
    xor rdi, rdi
    call exit

print_source:
    push rbp
    mov rbp, rsp
    mov rdi, source
    mov rsi, 10
    mov rdx, 34
    mov rcx, source
    call printf
    mov rsp, rbp
    pop rbp
    ret

; This is a comment outside functions