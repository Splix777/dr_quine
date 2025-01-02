section .data
    x dd 5 
    filename_fmt db "Sully_%d.s", 0
    exec_fmt db "Sully_%d", 0
    compile_fmt db "nasm -f elf64 -g -w+all -dNOEXECSTACK %1$s && ld --dynamic-linker /lib64/ld-linux-x86-64.so.2 -lc -no-pie -o %2$s %2$s.o && rm %2$s.o", 0
    execute_fmt db "./%s", 0
    source db "section .data%1$c    x dd %4$d%1$c    filename_fmt db %2$cSully_%%d.s%2$c, 0%1$c    exec_fmt db %2$cSully_%%d%2$c, 0%1$c    compile_fmt db %2$cnasm -f elf64 -g -w+all -dNOEXECSTACK %%1$s && ld --dynamic-linker /lib64/ld-linux-x86-64.so.2 -lc -no-pie -o %%2$s %%2$s.o && rm %%2$s.o%2$c, 0%1$c    execute_fmt db %2$c./%%s%2$c, 0%1$c    source db %2$c%3$s%2$c, 0%1$c%1$csection .bss%1$c    filename resb 100%1$c    execname resb 100%1$c    command resb 200%1$c%1$csection .text%1$c    global _start%1$c    extern sprintf%1$c    extern system%1$c    extern dprintf%1$c%1$c_start:%1$c    mov eax, [x]%1$c    test eax, eax%1$c    jle exit_prog%1$c    dec eax%1$c    mov [x], eax%1$c%1$c    lea rdi, [rel filename]%1$c    lea rsi, [rel filename_fmt]%1$c    mov edx, [x]%1$c    call sprintf%1$c%1$c    lea rdi, [rel execname]%1$c    lea rsi, [rel exec_fmt]%1$c    mov edx, [x]%1$c    call sprintf%1$c%1$c    lea rdi, [rel filename]%1$c    call create_file%1$c%1$c    lea rdi, [rel command]%1$c    lea rsi, [rel compile_fmt]%1$c    lea rdx, [rel filename]%1$c    lea rcx, [rel execname]%1$c    xor rax, rax%1$c    call sprintf%1$c%1$c    lea rdi, [rel command]%1$c    call system%1$c%1$c    lea rdi, [rel command]%1$c    lea rsi, [rel execute_fmt]%1$c    lea rdx, [rel execname]%1$c    xor rax, rax%1$c    call sprintf%1$c%1$c    lea rdi, [rel command]%1$c    call system%1$c%1$c    jmp exit_prog%1$c%1$cexit_prog:%1$c    mov rax, 60%1$c    xor rdi, rdi%1$c    syscall%1$c%1$ccreate_file:%1$c    lea rdi, [rel filename]%1$c    mov rsi, 0102o%1$c    mov rdx, 0644o%1$c    mov rax, 2%1$c    syscall%1$c    test rax, rax%1$c    js exit_prog%1$c    mov r12, rax%1$c%1$c    mov rdi, r12%1$c    lea rsi, [rel source]%1$c    mov rdx, 10%1$c    mov rcx, 34%1$c    lea r8, [rel source]%1$c    mov r9, [x]%1$c    push 0%1$c    call dprintf%1$c    add rsp, 8%1$c%1$c    mov rdi, r12%1$c    mov rax, 3%1$c    syscall%1$c    ret%1$c", 0

; We use the .bss section to declare uninitialized data or variables. In this section, we define three variables: filename, execname, and command. The filename variable is used to store the name of the file that will be created by the program. The execname variable is used to store the name of the executable that will be created by the program. The command variable is used to store the command that will be executed by
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
    ; Load the value of x into the eax register. The x variable is used to keep track of the number of times the program has been executed.
    mov eax, [x]
    ; Test the value of eax. If the value is less than or equal to zero, jump to the exit_prog label.
    test eax, eax
    jle exit_prog
    ; Decrement the value of eax. This will reduce the value of x by 1.
    dec eax
    ; Move the decremented value of x back into the x variable.
    mov [x], eax

    ; Load the address of the filename variable into the rdi register. This is the first argument to the sprintf function. We use rdi (destination index) to pass the address.
    lea rdi, [rel filename]
    ; Load the address of the filename_fmt variable into the rsi register. This is the second argument to the sprintf function. We use rsi (source index) to pass the address
    lea rsi, [rel filename_fmt]
    ; Load the value of x into the edx register. This is the third argument to the sprintf function. We use edx (data index) to pass the value of x.
    mov edx, [x]
    ; Call the sprintf function. This will format the filename string with the value of x and store the result in the filename variable. The sprintf function is used to format a string with variables.
    call sprintf

    ; Load the address of the execname variable into the rdi register. This is the first argument to the sprintf function.
    lea rdi, [rel execname]
    ; Load the address of the exec_fmt variable into the rsi register. This is the second argument to the sprintf function.
    lea rsi, [rel exec_fmt]
    ; Load the value of x into the edx register. This is the third argument to the sprintf function.
    mov edx, [x]
    ; Call the sprintf function. This will format the execname string with the value of x and store the result in the execname variable.
    call sprintf

    ; Now we have the filename and execname variables formatted with the value of x. We can create the source file using the filename variable. To pass the filename variable to the create_file function, we load the address of the filename variable into the rdi register.
    lea rdi, [rel filename]
    ; We call the create_file label to create the source file with the name specified in the filename variable. Call differently to jmp, call will push the address of the next instruction on the stack. This will set rsp to the address of the next mnemonic instruction.
    call create_file

    ; Now that we have created the source file, we can compile and execute it. We use the compile_fmt and execute_fmt variables to format the compile and execute commands with the filename and execname variables. Here we load all the previously formatted variables into the appropriate registers and call the sprintf function to format the command strings.
    lea rdi, [rel command]
    lea rsi, [rel compile_fmt]
    lea rdx, [rel filename]
    lea rcx, [rel execname]
    ; xor rax, rax is equivalent to mov rax, 0. We use xor rax, rax to set the rax register to zero before calling sprintf. This is done to ensure that the rax register is cleared before using it.
    xor rax, rax
    call sprintf

    ; Load the address of the command variable into the rdi register. This is the first argument to the system function. The system function is used to execute a command in the shell. We use the system function to compile the source file.
    lea rdi, [rel command]
    call system

    ; As before we format the command string for executing the compiled program. We load the address of the command variable into the rdi register and call the sprintf function to format the command string. This time we use the execute_fmt variable to format the command string.
    lea rdi, [rel command]
    lea rsi, [rel execute_fmt]
    lea rdx, [rel execname]
    xor rax, rax
    call sprintf

    ; Load the address of the command variable into the rdi register. This is the first argument to the system function. We use the system function to execute the compiled program.
    lea rdi, [rel command]
    call system

    ; Jump to the exit_prog label. This will terminate the program.
    jmp exit_prog

exit_prog:
    mov rax, 60
    xor rdi, rdi
    syscall

create_file:
    ; Load the address of the filename variable into the rdi register. This is the first argument to the open system call.
    lea rdi, [rel filename]
    ; Load the value 0102o into the rsi register. This is the second argument to the open system call. Here we are specifying the flags for opening the file. 0102o is the octal representation of the flags.
    mov rsi, 0102o
    ; Load the value 0644o into the rdx register. This is the third argument to the open system call. Here we are specifying the permissions for the file. 0644o is the octal representation of the permissions. In our case, we are giving read and write permissions to the file.
    mov rdx, 0644o
    ; Load the value 2 into the rax register. This is the system call number for the open system call.
    mov rax, 2
    ; Call the open system call. This will open the file with the specified filename, flags, and permissions. Syscalls are used to make requests to the kernel. The open system call is used to open a file. Syscall knows which system call to make based on the value in the rax register.
    syscall
    ; At this point, we've created an empty file with the name specified in the filename variable. The file descriptor is stored in the rax register. We call test to check if the file descriptor is negative. If it is, we jump to the exit_prog label. (The test instruction performs a bitwise AND operation between two operands and sets the zero flag based on the result.)
    test rax, rax
    js exit_prog
    ; If the file descriptor is not negative, we store it in the r12 register. The r12 register is used to store the file descriptor. r12 is the FD we will use to write to the file.
    mov r12, rax

    ; Load the file descriptor into the rdi register. This is the first argument to the dprintf function.
    mov rdi, r12
    ; Load the address of the source variable into the rsi register. This is the second argument to the dprintf function.
    lea rsi, [rel source]
    ; Load the value 10 into the rdx register. This is the third argument to the dprintf function. Here we are specifying the length of the string to print. 10 corresponds to the newline character.
    mov rdx, 10
    ; Load the value 34 into the rcx register. This is the fourth argument to the dprintf function. Here we are specifying the format string to use for printing. The format string contains the format specifiers that will be replaced by the arguments passed to the dprintf function. 34 corresponds to the double quote character.
    mov rcx, 34
    ; Load the address of the source variable into the r8 register. This is the fifth argument to the dprintf function. Here we are specifying the format string to use for printing. The format string contains the format specifiers that will be replaced by the arguments passed to the dprintf function. We use the r8 register so we can use the rsi register to pass the address of the source variable.
    lea r8, [rel source]
    ; Load the value of x into the r9 register. This is the sixth argument to the dprintf function. We use r9 to pass the value of x.
    mov r9, [x]
    ; Push the value 0 onto the stack. This is the seventh argument to the dprintf function. We use the push instruction to push the value onto the stack. We push 0 to indicate the end of the argument list. dprint requires a null-terminated argument list.
    push 0
    call dprintf
    ; After calling dprintf, we need to adjust the stack pointer to remove the arguments we pushed onto the stack. We use the add instruction to adjust the stack pointer by 8 bytes.
    add rsp, 8

    ; Load the file descriptor into the rdi register. This is the first argument to the write system call. We store the newly created file descriptor in the r12 register.
    mov rdi, r12
    ; Load 3 into the rax register. This is the system call to close the file descriptor. We use the close system call to close the file descriptor. The close system call releases the file descriptor so it can be reused. (sys close)
    mov rax, 3
    syscall
    ret
