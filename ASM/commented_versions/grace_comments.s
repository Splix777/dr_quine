; Defines in ASM are defined with %define. These are similar to macros in C. They are used to define constants or variables that can be used in the program. In this case, we define two constants: FILENAME and SELF. FILENAME is the name of the file that will be created by the program. SELF is the source code of the program itself. We use SELF to print the source code of the program to the standard output. We use FILENAME to create the file with the source code of the program.
%define FILENAME "Grace_kid.s"
%define SELF "%%define FILENAME %2$cGrace_kid.s%2$c%1$c%%define SELF %2$c%3$s%2$c%1$c%1$c%%macro MAIN 0%1$c%1$csection .data%1$c    self: db SELF, 0%1$c    filename: db FILENAME, 0%1$c%1$csection .text%1$c    global _start%1$c    extern dprintf%1$c    extern exit%1$c%1$c_start:%1$c    call print_source%1$c    mov rax, 60%1$c    xor rdi, rdi%1$c    call exit%1$c%1$cprint_source:%1$c    push rbp%1$c    mov rbp, rsp%1$c%1$c    mov rdi, filename%1$c    mov rsi, 0102o%1$c    mov rdx, 0644o%1$c    mov rax, 2%1$c    syscall%1$c%1$c    mov rdi, rax%1$c    mov rsi, self%1$c    mov rdx, 10%1$c    mov rcx, 34%1$c    mov r8, self%1$c    call dprintf%1$c%1$c    mov rsp, rbp%1$c    pop rbp%1$c    ret%1$c%1$c%%endmacro%1$c%1$c; This is required comment%1$cMAIN%1$c"


; Defines a macro called MAIN that does not take any arguments. This macro is used to define the main function of the program. The main function is the entry point of the program. It is called when the program is executed. The main function is defined in the .text section of the program. The main function calls the print_source function and then exits the program. The print_source function prints the source code of the program to the standard output. THe instructions says the source code must not have a main declared, so we use the _start label as the entry point of the program.
%macro MAIN 0

; Defines the .data section of the program. The .data section is used to declare initialized data or constants. In this section, we define two variables: self and filename. The self variable contains the source code of the program. The filename variable contains the name of the file that will be created by the program.
section .data
    self: db SELF, 0
    filename: db FILENAME, 0

; Defines the .text section of the program. The .text section is used to declare the executable instructions of the program. In this section, we define the _start label as the entry point of the program. We also define two external functions: dprintf and exit. The _start label is the entry point of the program. It is called when the program is executed.
section .text
    global _start
    extern dprintf
    extern exit

; The _start label is the entry point of the program. It is called when the program is executed. The _start label calls the print_source function and then exits the program.
_start:
    call print_source
    mov rax, 60
    xor rdi, rdi
    call exit

; Defines the print_source function. The print_source function prints the source code of the program to the standard output. The print_source function is called by the _start label.
print_source:
    ; When entering a function, we need to save the base pointer (rbp) on the stack. This is done by pushing rbp on the stack. This will save as a bookmark to the current stack frame. Allowing us to use thr rsp to assign local variables.
    push rbp
    ; Set the base pointer to the current stack pointer. This will allow us to access the local variables using the base pointer.
    mov rbp, rsp

    ; Move the address of the filename variable to the rdi register. This is the first argument to the open system call.
    mov rdi, filename
    ; Move the value 0102o to the rsi register. This is the second argument to the open system call. Here we are specifying the flags for opening the file. In our case, we are using the O_CREAT flag to create the file if it does not exist. 0102o is the octal representation of the flags.
    mov rsi, 0102o
    ; Move the value 0644o to the rdx register. This is the third argument to the open system call. Here we are specifying the permissions for the file. 0644o is the octal representation of the permissions. In our case we are giving read and write permissions to the file.
    mov rdx, 0644o
    ; Move the value 2 to the rax register. This is the system call number for the open system call.
    mov rax, 2
    ; Call the open system call. This will open the file with the specified filename, flags, and permissions. Syscalls are used to make requests to the kernel. The open system call is used to open a file. Syscall knows which system call to make based on the value in the rax register.
    syscall
    ; At this point we've created an empty file with the name specified in the filename variable. The file descriptor is stored in the rax register.

    ; Move the file descriptor to the rdi register. This is the first argument to the dprintf function.
    mov rdi, rax
    ; Move the address of the self variable to the rsi register. This is the second argument to the dprintf function.
    mov rsi, self
    ; Move the value 10 to the rdx register. This is the third argument to the dprintf function. Here we are specifying the length of the string to print.
    mov rdx, 10
    ; Move the value 34 to the rcx register. This is the fourth argument to the dprintf function. Here we are specifying the format string to use for printing. The format string contains the format specifiers that will be replaced by the arguments passed to the dprintf function.
    mov rcx, 34
    ; Move the address of the self variable to the r8 register. This is the fifth argument to the dprintf function. Here we are specifying the format string to use for printing. The format string contains the format specifiers that will be replaced by the arguments passed to the dprintf function. We use the r8 so we can use the rsi register to pass the address of the self variable.
    mov r8, self
    ; Call the dprintf function. This will print the source code of the program to the file specified by the file descriptor.
    call dprintf

    ; Restore the stack pointer to the base pointer. This will free the local variables from the stack.
    mov rsp, rbp
    ; Pop the base pointer from the stack. This will restore the base pointer to the previous stack frame.
    pop rbp
    ; Return from the function. This will pop the return address from the stack and set the instruction pointer to the return address.
    ret

; %endmacro is used to end the definition of the MAIN macro.
%endmacro

; This is required comment
MAIN

; This is a quine, a program that prints its own source code without external input.