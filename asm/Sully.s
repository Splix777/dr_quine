section .data
    x dd 5 
    filename_fmt db "Sully_%d.s", 0
    exec_fmt db "Sully_%d", 0
    compile_fmt db "nasm -f elf64 -g -w+all -dNOEXECSTACK %1$s && ld --dynamic-linker /lib64/ld-linux-x86-64.so.2 -lc -no-pie -o %2$s %2$s.o && rm %2$s.o", 0
    execute_fmt db "./%s", 0
    source db "section .data%1$c    x dd %4$d%1$c    filename_fmt db %2$cSully_%%d.s%2$c, 0%1$c    exec_fmt db %2$cSully_%%d%2$c, 0%1$c    compile_fmt db %2$cnasm -f elf64 -g -w+all -dNOEXECSTACK %%1$s && ld --dynamic-linker /lib64/ld-linux-x86-64.so.2 -lc -no-pie -o %%2$s %%2$s.o && rm %%2$s.o%2$c, 0%1$c    execute_fmt db %2$c./%%s%2$c, 0%1$c    source db %2$c%3$s%2$c, 0%1$c%1$csection .bss%1$c    filename resb 100%1$c    execname resb 100%1$c    command resb 200%1$c%1$csection .text%1$c    global _start%1$c    extern sprintf%1$c    extern system%1$c    extern dprintf%1$c%1$c_start:%1$c    mov eax, [x]%1$c    test eax, eax%1$c    jl exit_prog%1$c%1$c    lea rdi, [rel filename]%1$c    lea rsi, [rel filename_fmt]%1$c    mov edx, [x]%1$c    call sprintf%1$c%1$c    lea rdi, [rel execname]%1$c    lea rsi, [rel exec_fmt]%1$c    mov edx, [x]%1$c    call sprintf%1$c%1$c    lea rdi, [rel filename]%1$c    call create_file%1$c%1$c    lea rdi, [rel command]%1$c    lea rsi, [rel compile_fmt]%1$c    lea rdx, [rel filename]%1$c    lea rcx, [rel execname]%1$c    xor rax, rax%1$c    call sprintf%1$c%1$c    lea rdi, [rel command]%1$c    call system%1$c%1$c    lea rdi, [rel command]%1$c    lea rsi, [rel execute_fmt]%1$c    lea rdx, [rel execname]%1$c    xor rax, rax%1$c    call sprintf%1$c%1$c    lea rdi, [rel command]%1$c    call system%1$c%1$c    jmp exit_prog%1$c%1$cexit_prog:%1$c    mov rax, 60%1$c    xor rdi, rdi%1$c    syscall%1$c%1$ccreate_file:%1$c    lea rdi, [rel filename]%1$c    mov rsi, 0102o%1$c    mov rdx, 0644o%1$c    mov rax, 2%1$c    syscall%1$c    test rax, rax%1$c    js exit_prog%1$c    mov r12, rax%1$c%1$c    mov rdi, r12%1$c    lea rsi, [rel source]%1$c    mov rdx, 10%1$c    mov rcx, 34%1$c    lea r8, [rel source]%1$c%1$c    mov eax, [x]%1$c    dec eax%1$c    mov r9, rax%1$c%1$c    push 0%1$c    call dprintf%1$c    add rsp, 8%1$c%1$c    mov rdi, r12%1$c    mov rax, 3%1$c    syscall%1$c    ret%1$c", 0

section .bss
    filename resb 100
    execname resb 100
    command resb 200

section .text
    global _start
    extern sprintf
    extern system
    extern dprintf

_start:
    mov eax, [x]
    test eax, eax
    jl exit_prog  ; Changed from jle to jl for inclusivity down to x = 0

    lea rdi, [rel filename]
    lea rsi, [rel filename_fmt]
    mov edx, [x]
    call sprintf

    lea rdi, [rel execname]
    lea rsi, [rel exec_fmt]
    mov edx, [x]
    call sprintf

    lea rdi, [rel filename]
    call create_file

    lea rdi, [rel command]
    lea rsi, [rel compile_fmt]
    lea rdx, [rel filename]
    lea rcx, [rel execname]
    xor rax, rax
    call sprintf

    lea rdi, [rel command]
    call system

    lea rdi, [rel command]
    lea rsi, [rel execute_fmt]
    lea rdx, [rel execname]
    xor rax, rax
    call sprintf

    lea rdi, [rel command]
    call system

    jmp exit_prog

exit_prog:
    mov rax, 60
    xor rdi, rdi
    syscall

create_file:
    lea rdi, [rel filename]
    mov rsi, 0102o
    mov rdx, 0644o
    mov rax, 2
    syscall
    test rax, rax
    js exit_prog
    mov r12, rax

    mov rdi, r12
    lea rsi, [rel source]
    mov rdx, 10
    mov rcx, 34
    lea r8, [rel source]

    mov eax, [x]
    dec eax
    mov r9, rax

    push 0
    call dprintf
    add rsp, 8

    mov rdi, r12
    mov rax, 3
    syscall
    ret