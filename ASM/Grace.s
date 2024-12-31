%define FILENAME "Grace_kid.s"
%define SELF "%%define FILENAME %2$cGrace_kid.s%2$c%1$c%%define SELF %2$c%3$s%2$c%1$c%1$c%%macro MAIN 0%1$c%1$csection .data%1$c    self: db SELF, 0%1$c    filename: db FILENAME, 0%1$c%1$csection .text%1$c    global _start%1$c    extern dprintf%1$c    extern exit%1$c%1$c_start:%1$c    call print_source%1$c    mov rax, 60%1$c    xor rdi, rdi%1$c    call exit%1$c%1$cprint_source:%1$c    push rbp%1$c    mov rbp, rsp%1$c%1$c    mov rdi, filename%1$c    mov rsi, 0102o%1$c    mov rdx, 0644o%1$c    mov rax, 2%1$c    syscall%1$c%1$c    mov rdi, rax%1$c    mov rsi, self%1$c    mov rdx, 10%1$c    mov rcx, 34%1$c    mov r8, self%1$c    call dprintf%1$c%1$c    mov rsp, rbp%1$c    pop rbp%1$c    ret%1$c%1$csection .note.GNU-stack%1$c%1$c%%endmacro%1$c%1$c; This is required comment%1$cMAIN%1$c"

%macro MAIN 0

section .data
    self: db SELF, 0
    filename: db FILENAME, 0

section .text
    global _start
    extern dprintf
    extern exit

_start:
    call print_source
    mov rax, 60
    xor rdi, rdi
    call exit

print_source:
    push rbp
    mov rbp, rsp

    lea rdi, [rel filename]
    mov rsi, 0102o
    mov rdx, 0644o
    mov rax, 2
    syscall

    cmp rax, 0
    jle error

    mov rdi, rax
    lea rsi, [rel self]
    mov rdx, 10
    mov rcx, 34
    lea r8, [rel self]
    call dprintf

    mov rsp, rbp
    pop rbp
    ret

error:
    mov rax, 60
    xor rdi, rdi
    call exit

section .note.GNU-stack

%endmacro

; This is required comment
MAIN
